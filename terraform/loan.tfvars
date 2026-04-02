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
ec2_instance_type  = "t3.large"
ec2_count          = 2
enable_rds         = true
rds_instance_class = "db.t3.large"
enable_nat_gateway = true
