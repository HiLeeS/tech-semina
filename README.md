# FinOps: Terraform 기반 클라우드 리소스 태깅 전략과 비용 가시화

> "태그는 부탁하는 게 아니라, 코드가 강제하는 것이다."

## 개요

여러 팀이 공유하는 AWS 환경에서 **비용 책임을 명확히** 하기 위한 태깅 전략을 Terraform으로 코드화하고,
CI/CD 파이프라인에서 태그를 강제하며, Grafana 대시보드로 비용을 시각화하는 End-to-End 데모 프로젝트입니다.

## 가상 시나리오: FinTech Corp

| 팀 | 서비스 | 비용센터 |
|-----|---------|----------|
| payment-team | payment | finops-001 |
| loan-team | loan | finops-002 |
| auth-team | membership | finops-003 |

**환경:** dev / stg / prod

## 태그 표준

| 태그 키 | 설명 | 예시 |
|---------|------|------|
| `BusinessService` | 비즈니스 서비스명 | payment, loan, membership |
| `Team` | 담당 팀 | payment-team, loan-team, auth-team |
| `Environment` | 배포 환경 | dev, stg, prod |
| `CostCenter` | 비용 센터 코드 | finops-001, finops-002, finops-003 |

## 아키텍처

```
Terraform Code (default_tags + validation)
    ↓
GitHub Actions (태그 누락 시 PR 차단)
    ↓
Infracost (PR에 비용 추정 코멘트)
    ↓
Grafana Dashboard (팀별/서비스별 비용 시각화)
```

## 프로젝트 구조

```
.
├── terraform/           # Terraform 태깅 코드
│   ├── main.tf
│   ├── variables.tf     # 태그 validation 규칙
│   ├── providers.tf
│   ├── outputs.tf
│   └── terraform.tfvars
├── .github/workflows/   # CI/CD 파이프라인
│   ├── terraform-ci.yml
│   └── infracost.yml
├── grafana/             # 비용 대시보드
│   ├── docker-compose.yml
│   ├── dashboards/
│   └── data/            # 샘플 CSV
├── docs/
│   └── tagging-standard.md
└── README.md
```

## 실행 방법

### 1. Terraform
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Grafana 대시보드
```bash
cd grafana
docker-compose up -d
# http://localhost:3000 접속
```

## 기술 스택

- **IaC:** Terraform
- **CI/CD:** GitHub Actions
- **비용 추정:** Infracost
- **시각화:** Grafana + CSV 데이터
- **클라우드:** AWS (EC2, S3, VPC 등)
