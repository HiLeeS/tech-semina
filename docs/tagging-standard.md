# FinTech Corp 태깅 표준 (Tagging Standard)

## 목적

AWS 리소스에 일관된 태그를 부여하여 **비용 추적, 책임 소재 파악, 거버넌스 자동화**를 실현합니다.

## 필수 태그 (Required Tags)

| 태그 키 | 설명 | 허용 값 | 예시 |
|---------|------|---------|------|
| `BusinessService` | 비즈니스 서비스 단위 | payment, loan, membership | payment |
| `Team` | 소유 팀 | payment-team, loan-team, auth-team | payment-team |
| `Environment` | 배포 환경 | dev, stg, prod | prod |
| `CostCenter` | 비용 센터 코드 | finops-XXX (정규식) | finops-001 |
| `ManagedBy` | 관리 도구 | terraform (자동 설정) | terraform |

## 팀-비용센터 매핑

| 팀 | 비용센터 |
|----|---------|
| payment-team | finops-001 |
| loan-team | finops-002 |
| auth-team | finops-003 |

## 강제 메커니즘

1. **Terraform validation:** 허용되지 않은 태그 값 → `terraform plan` 실패
2. **GitHub Actions:** 태그 검증 실패 → PR merge 차단
3. **향후:** AWS SCP / EventBridge + Lambda로 콘솔 생성 리소스도 태그 강제

## 태그 변경 절차

1. `terraform/variables.tf`의 validation 값 수정
2. PR 생성 → 리뷰 → merge
3. 전체 환경에 자동 적용
