# Fase 1 – Configuração e Automação Inicial (DevOps na Prática)

**Estudante:** Rafael Hernandez  
**Disciplina:** DevOps na Prática  
**Data:** 25/08/2025

---

## 1) Descrição do Projeto, Objetivos e Requisitos

### Descrição
Criar uma API simples (Node.js + Express) com testes automatizados e um pipeline de Integração Contínua no GitHub Actions, além de scripts de Infraestrutura como Código (Terraform) para provisionamento básico em AWS. Esta fase foca em *configuração e automação inicial* (CI + IaC).

### Objetivos
- Configurar repositório no GitHub e pipeline de CI (build, lint, testes, artefatos).
- Garantir qualidade e rastreabilidade (ESLint, Jest, cobertura).
- Disponibilizar scripts Terraform prontos para validação (`fmt/validate`) e `plan` no CI.
- Documentar plano de CI e especificação da infraestrutura.

### Requisitos
- **Linguagem:** JavaScript (Node.js 18+).  
- **Gerenciador de pacotes:** npm.  
- **Testes:** Jest + Supertest.  
- **Qualidade:** ESLint (**StandardJS**).  
- **CI:** GitHub Actions.  
- **IaC:** Terraform ≥ 1.5.  
- **Cloud:** AWS.  
- **Contas e segredos:** Conta GitHub + Conta AWS e segredos no repositório para `plan/apply`.

---

## 2) Plano de Integração Contínua (CI)

### Estratégia de Branch/PR
- **main:** branch estável. *Pull Requests* exigem sucesso do CI.  
- **feature/**: branches de funcionalidade integram via PR.

### Gatilhos (triggers)
- `push` e `pull_request` para `main` e `feature/*`.  
- `workflow_dispatch` para rodar manualmente.

### Jobs / Etapas
1. **Build & Test (Node.js)**
   - `checkout` → `setup-node` (cache npm) → `npm ci`
   - `npm run lint`
   - `npm test -- --coverage`
   - Publicação de artefatos (ex.: `coverage/`)
2. **Infra (Terraform – validação)**
   - `terraform fmt` (**autoformata e commita no CI**)
   - `terraform init`
   - `terraform validate`
   - `terraform plan` (usando `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`)

### Segredos (CI de IaC)
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION` (no projeto, `us-east-2`).

---

## 3) Especificação da Infraestrutura (IaC)

### Visão Geral
- **Provider:** AWS.  
- **Recursos básicos:**
  - **S3 Bucket** (para artefatos/dados) — nome via variável.
  - **EC2 t3.micro + Security Group** (porta **3000/TCP**) **opcional**, controlado por variável (`create_ec2`). *Na Fase 1, EC2 está desativada*.

> **Observação técnica:** os *datasources* e recursos de EC2/SG só são avaliados quando `create_ec2 = true` (uso de `count` nos `data`/`resources` e *output* condicional). Assim, o `plan` roda sem exigir permissões de EC2 quando EC2 está desativada.

### Variáveis Principais
- `aws_region` (padrão do provider `us-east-1`; **no projeto usamos `us-east-2` via `terraform.tfvars`**).  
- `bucket_name` (ex.: `devops-fase1-rafael-2025-artifacts` — precisa ser **único na AWS**).  
- `create_ec2` (`false` na Fase 1). Quando `true`, cria EC2 e expõe `public_ip` como *output*.

### Custos e Segurança
- Preferir **free tier** quando possível.  
- **Não** commitar chaves. Usar **GitHub Secrets** e variáveis Terraform (`terraform.tfvars`, não versionado).  
- Evolução recomendada: autenticação por **OIDC** no GitHub (credenciais federadas), evitando chaves estáticas.

---

## 4) Link do Repositório
**Link do repositório:** [github.com/rafa90hernandez/devops-fase1](https://github.com/rafa90hernandez/devops-fase1)

> *OBS.: Este documento referencia o repositório que contém o pipeline de CI e os scripts IaC.*

---

## 5) Testes Automatizados
- Testes de integração com Supertest no endpoint `/health` retornando `200 OK` e payload `{ "status": "ok" }`.  
- `npm test` roda no CI com relatório de cobertura.

---

## 6) Aulas que embasam a Fase 1
1. **Introdução ao DevOps**  
2. **Integração Contínua (CI)**  
3. **Entrega Contínua (CD)**  
4. **Infraestrutura como Código (IaC)**

---

## 7) Como executar localmente (aplicação)

```bash
# 1) Node 18+
node -v
npm -v

# 2) Instalar dependências
cd app
npm ci

# 3) Lint & Test
npm run lint
npm test

# 4) Rodar servidor
npm start
# API em http://localhost:3000/health
```

## 8) Como validar o Terraform localmente (opcional)
> *Nesta entrega, a validação de Terraform é realizada no GitHub Actions. Caso queira executar localmente:*

```bash
cd infra/terraform
terraform fmt -check
terraform init
terraform validate
terraform plan
```

## 8.1) Validar Terraform pelo GitHub Actions
- Acesse **Actions → CI - Fase 1 (Node + Terraform) → Run workflow**.
- O pipeline executa: `fmt` → `init` → `validate` → `plan`.
- **Evidências**: run com jobs verdes e logs do passo *Terraform plan* (anexar prints na entrega, se solicitado).

---

## 9) Roadmap (próximos passos)
- Adicionar *backend remoto* ao Terraform (S3 + DynamoDB para *state lock*).  
- Migrar autenticação do Terraform no CI para **OIDC** (credenciais federadas).  
- Iniciar **CD** (deploy automatizado) — por exemplo, para EC2/ECS/Elastic Beanstalk.
