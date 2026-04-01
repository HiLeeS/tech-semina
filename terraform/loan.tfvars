# =============================================================================
# loan-team / prod 환경
# 대출 서비스 - 중간 규모
# =============================================================================

aws_region       = "ap-northeast-2"
business_service = "loan"
team             = "loan-team"
environment      = "prod"
cost_center      = "finops-002"

# 리소스 스펙
ec2_instance_type  = "t3.micro" # 프리티어 제한으로 t3설정 / 추후 t3.large로 하면 2 vCPU, 8GB
ec2_count          = 2          # 이중화
enable_rds         = true
rds_instance_class = "db.t3.micro" # 중간 스펙 DB
enable_nat_gateway = true
