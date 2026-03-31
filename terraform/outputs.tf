output "s3_bucket_name" {
  description = "생성된 S3 버킷 이름"
  value       = aws_s3_bucket.demo.id
}

output "s3_bucket_arn" {
  description = "생성된 S3 버킷 ARN"
  value       = aws_s3_bucket.demo.arn
}

output "vpc_id" {
  description = "생성된 VPC ID"
  value       = aws_vpc.demo.id
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
