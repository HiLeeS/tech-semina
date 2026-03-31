# =============================================================================
# AWS 리전
# =============================================================================
variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

# =============================================================================
# 태그 변수 (validation으로 값 강제)
# =============================================================================

variable "business_service" {
  description = "비즈니스 서비스명 - 허용된 값만 사용 가능"
  type        = string

  validation {
    condition     = contains(["payment", "loan", "membership"], var.business_service)
    error_message = "business_service는 payment, loan, membership 중 하나여야 합니다."
  }
}

variable "team" {
  description = "담당 팀명 - 허용된 값만 사용 가능"
  type        = string

  validation {
    condition     = contains(["payment-team", "loan-team", "auth-team"], var.team)
    error_message = "team은 payment-team, loan-team, auth-team 중 하나여야 합니다."
  }
}

variable "environment" {
  description = "배포 환경 - 허용된 값만 사용 가능"
  type        = string

  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "environment는 dev, stg, prod 중 하나여야 합니다."
  }
}

variable "cost_center" {
  description = "비용 센터 코드 - finops-XXX 형식만 허용"
  type        = string

  validation {
    condition     = can(regex("^finops-[0-9]{3}$", var.cost_center))
    error_message = "cost_center는 finops-XXX 형식이어야 합니다. (예: finops-001)"
  }
}

# =============================================================================
# 태그-팀 매핑 검증 (team과 cost_center 정합성)
# =============================================================================

variable "team_cost_center_map" {
  description = "팀별 올바른 cost_center 매핑 (내부 검증용)"
  type        = map(string)
  default = {
    "payment-team" = "finops-001"
    "loan-team"    = "finops-002"
    "auth-team"    = "finops-003"
  }
}
