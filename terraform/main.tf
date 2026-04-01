# =============================================================================
# 태그-팀 매핑 정합성 검증
# =============================================================================

locals {
  # team과 cost_center 조합이 올바른지 직접 검증
  validate_team_cost_center = (
    (var.team == "payment-team" && var.cost_center == "finops-001") ||
    (var.team == "loan-team" && var.cost_center == "finops-002") ||
    (var.team == "auth-team" && var.cost_center == "finops-003")
    ? true
    : tobool("ERROR: ${var.team}의 올바른 cost_center를 확인하세요. 입력값: ${var.cost_center}")
  )
}

# =============================================================================
# 데이터 소스: 최신 Amazon Linux 2023 AMI
# =============================================================================

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# =============================================================================
# VPC + Subnet
# =============================================================================

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.business_service}-${var.environment}-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.business_service}-${var.environment}-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "${var.business_service}-${var.environment}-private-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.business_service}-${var.environment}-igw"
  }
}

# =============================================================================
# NAT Gateway (팀별 선택적 생성 - 비용 발생 리소스)
# =============================================================================

resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "${var.business_service}-${var.environment}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${var.business_service}-${var.environment}-nat-gw"
  }
}

# =============================================================================
# EC2 인스턴스 (팀별 타입/개수 다르게)
# =============================================================================

resource "aws_instance" "app" {
  count         = var.ec2_count
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.public.id

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.business_service}-${var.environment}-app-${count.index + 1}"
  }
}

# =============================================================================
# RDS (팀별 선택적 생성)
# =============================================================================

resource "aws_db_subnet_group" "main" {
  count      = var.enable_rds ? 1 : 0
  name       = "${var.business_service}-${var.environment}-db-subnet"
  subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]

  tags = {
    Name = "${var.business_service}-${var.environment}-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  count                = var.enable_rds ? 1 : 0
  identifier           = "${var.business_service}-${var.environment}-db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.rds_instance_class
  allocated_storage    = 20
  storage_type         = "gp3"
  db_name              = "${var.business_service}db"
  username             = "admin"
  password             = "temppassword123!" # 실습용 임시 패스워드 - 실제 환경에서는 AWS Secrets Manager 사용
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.main[0].name

  tags = {
    Name = "${var.business_service}-${var.environment}-db"
  }
}

# =============================================================================
# S3 버킷
# =============================================================================

resource "aws_s3_bucket" "data" {
  bucket = "${var.business_service}-${var.environment}-data-${random_id.suffix.hex}"

  tags = {
    Name = "${var.business_service}-${var.environment}-data"
  }
}

resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id

  versioning_configuration {
    status = "Enabled"
  }
}

# =============================================================================
# 유틸리티
# =============================================================================

resource "random_id" "suffix" {
  byte_length = 4
}
