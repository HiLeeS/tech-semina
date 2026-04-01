# =============================================================================
# auth-team / prod 환경
# 인증 서비스 - 경량 서비스
# =============================================================================

aws_region       = "ap-northeast-2"
business_service = "membership"
team             = "auth-team"
environment      = "prod"
cost_center      = "finops-003"

# 리소스 스펙
ec2_instance_type  = "t3.medium"   # 2 vCPU, 4GB
ec2_count          = 1              # 단일 인스턴스
enable_rds         = false          # DB 불필요 (외부 인증 서비스 사용)
rds_instance_class = "db.t3.micro"  # 사용 안 함 (enable_rds = false)
enable_nat_gateway = false          # 비용 절감
