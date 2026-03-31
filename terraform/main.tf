# =============================================================================
# 태그-팀 매핑 정합성 검증
# =============================================================================
# team과 cost_center가 올바르게 매핑되었는지 확인
# 잘못된 조합이면 terraform plan 단계에서 즉시 실패

locals {
  validate_team_cost_center = (
    var.team_cost_center_map[var.team] == var.cost_center
    ? true
    : tobool("ERROR: ${var.team}의 cost_center는 ${var.team_cost_center_map[var.team]}이어야 합니다. 입력값: ${var.cost_center}")
  )
}

# =============================================================================
# 데모 리소스: S3 버킷
# =============================================================================
# default_tags가 자동으로 적용되므로 리소스에 태그를 반복하지 않아도 됨

resource "aws_s3_bucket" "demo" {
  bucket = "${var.business_service}-${var.environment}-demo-${random_id.suffix.hex}"

  # 리소스 고유 태그만 추가 (default_tags 위에 병합됨)
  tags = {
    Name = "${var.business_service}-${var.environment}-demo"
  }
}

resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id

  versioning_configuration {
    status = "Enabled"
  }
}

# =============================================================================
# 데모 리소스: VPC
# =============================================================================

resource "aws_vpc" "demo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.business_service}-${var.environment}-vpc"
  }
}

# =============================================================================
# 유틸리티
# =============================================================================

resource "random_id" "suffix" {
  byte_length = 4
}
