output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "ec2_instance_ids" {
  description = "EC2 인스턴스 ID 목록"
  value       = aws_instance.app[*].id
}

output "s3_bucket_name" {
  description = "S3 버킷 이름"
  value       = aws_s3_bucket.data.id
}

output "rds_endpoint" {
  description = "RDS 엔드포인트 (생성된 경우)"
  value       = var.enable_rds ? aws_db_instance.main[0].endpoint : "RDS 미생성"
}

output "applied_tags" {
  description = "적용된 태그 목록"
  value = {
    BusinessService = var.business_service
    Team            = var.team
    Environment     = var.environment
    CostCenter      = var.cost_center
    ManagedBy       = "terraform"
  }
}
