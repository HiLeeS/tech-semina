# =============================================================================
# payment-team / prod 환경
# 결제 서비스 - 고가용성 필요 → 리소스 스펙 높음
# =============================================================================

aws_region       = "ap-northeast-2"
business_service = "payment"
team             = "payment-team"
environment = "production"   # prod → production 으로 변경(ci-test)
cost_center      = "finops-001"

# 리소스 스펙
ec2_instance_type  = "t3.micro" # 프리티어 제한으로 t3설정 / 추후 m5.xlarge로 4 vCPU, 16GB - 결제 처리용
ec2_count          = 3          # 이중화 + 여유분
enable_rds         = true
rds_instance_class = "db.t3.micro" # 프리티어 제한 / 실제는 db.r5.large (고성능 DB)
enable_nat_gateway = true          # Private 서브넷 통신용
