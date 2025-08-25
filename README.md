# DevOps na Prática – Fase 1

Este repositório contém:
- **docs/Planejamento.md**: documentação de planejamento (descrição, objetivos, requisitos, plano de CI e especificação da infraestrutura).
- **app/**: API Node.js de exemplo com testes (Jest + Supertest) e ESLint.
- **infra/terraform/**: scripts IaC (Terraform) para S3 e (opcionalmente) EC2.
- **.github/workflows/ci.yml**: pipeline GitHub Actions (build, lint, tests e validação do Terraform).

## Como usar
1. Crie um repositório no GitHub e suba estes arquivos.
2. (Opcional) Configure os segredos `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION` no repositório para habilitar `terraform plan/apply` manualmente.
3. Abra um PR; o CI rodará automaticamente.
