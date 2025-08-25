# Documento – Fase 1 (para colar no template de slides)

## Slide 1 – Capa
**Projeto:** DevOps na Prática – Fase 1  
**Aluno:** (seu nome) – ADS (último semestre)

## Slide 2 – Descrição do Projeto
- API Node.js (Express) + testes (Jest/Supertest)
- Pipeline CI no GitHub Actions (build + lint + test + artefatos)
- IaC com Terraform (S3 e EC2 opcional)

## Slide 3 – Objetivos
- Automação inicial do ciclo de desenvolvimento (CI)
- Qualidade: lint, testes e cobertura
- Provisionamento básico em nuvem via Terraform

## Slide 4 – Requisitos
- Node.js 18+, npm
- GitHub + GitHub Actions
- Terraform 1.5+
- AWS (us-east-1), segredos via GitHub Secrets (quando usar plan/apply)

## Slide 5 – Plano de CI
- gatilhos: push/PR/main + workflow_dispatch
- etapas: checkout → setup-node → npm ci → lint → test → artifact
- validação Terraform: fmt, init, validate (plan opcional)

## Slide 6 – Infraestrutura (IaC)
- Provider AWS
- S3 obrigatório (nome único)
- EC2 opcional (porta 3000/TCP)

## Slide 7 – Testes Automatizados
- Rota `/health` → 200 OK, payload { status: "ok" }
- Cobertura via Jest

## Slide 8 – Link do Repositório
- Inserir: https://github.com/<seu-usuario>/devops-fase1

## Slide 9 – Aulas Base
1) Introdução ao DevOps  
2) Integração Contínua (CI)  
3) Entrega Contínua (CD)  
4) Infraestrutura como Código (IaC)
