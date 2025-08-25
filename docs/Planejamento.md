# Fase 1 – Configuração e Automação Inicial (DevOps na Prática)

**Estudante:** (preencher)  
**Disciplina:** DevOps na Prática  
**Data:** (preencher)

---

## 1) Descrição do Projeto, Objetivos e Requisitos

### Descrição
Criar uma API simples (Node.js + Express) com testes automatizados e um pipeline de Integração Contínua no GitHub Actions, além de scripts de Infraestrutura como Código (Terraform) para provisionamento básico em AWS. Esta fase foca em *configuração e automação inicial* (CI + IaC).

### Objetivos
- Configurar repositório no GitHub e pipeline de CI (build, lint, testes, artefato).
- Garantir qualidade e rastreabilidade (ESLint, Jest, cobertura).
- Disponibilizar scripts Terraform prontos para validação (fmt/validate) e *plan/apply* (quando os segredos da AWS forem configurados).
- Documentar plano de CI e especificação de infraestrutura.

### Requisitos
- **Linguagem:** JavaScript (Node.js 18+).
- **Gerenciador de pacotes:** npm.
- **Testes:** Jest + Supertest.
- **Qualidade:** ESLint (airbnb-base simplificado).
- **CI:** GitHub Actions.
- **IaC:** Terraform ≥ 1.5.
- **Cloud:** AWS (qualquer região suportada, ex.: `us-east-1`).  
- **Conta GitHub + Conta AWS** e **segredos** no repositório (quando executar `plan/apply`).

---

## 2) Plano de Integração Contínua (CI)

### Estratégia de Branch/PR
- **main**: branch estável. *Pull Requests* exigem sucesso do CI.
- **feature/**: branches de funcionalidade integram via PR.

### Gatilhos (triggers)
- `push` e `pull_request` para `main` e `feature/*`.
- `workflow_dispatch` para rodar manualmente.

### Jobs / Etapas
1. **Build & Test (Node.js)**
   - `checkout` → `setup-node` (cache npm) → `npm ci`
   - `npm run lint`
   - `npm test -- --coverage`
   - Publicar artefato (ex.: `coverage/` e pacote buildado se houver)
2. **Infra (Terraform – validação)**
   - `terraform fmt -check`
   - `terraform init`
   - `terraform validate`
   - (Opcional) `terraform plan` quando os segredos AWS estiverem configurados

### Segredos (para IaC opcional)
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION` (ex.: `us-east-1`).

---

## 3) Especificação da Infraestrutura (IaC)

### Visão Geral
- **Provider:** AWS.
- **Recursos básicos:**
  - *S3 Bucket* (para artefatos/dados) — nome via variável.
  - (Opcional, controlado por variável) uma **EC2 t3.micro** com **Security Group** liberando porta **3000/TCP** para testes de deploy.
- Sem *backend remoto* por padrão (para simplificar). Pode-se evoluir com S3+DynamoDB.

### Variáveis Principais
- `aws_region` (padrão `us-east-1`)
- `bucket_name` (ex.: `devops-fase1-<seu-usuario>` – precisa ser **único na AWS**)
- `create_ec2` (`false` por padrão). Quando `true`, cria EC2 e expõe `public_ip` como *output*.

### Custos e Segurança
- Usar **free tier** quando possível.
- Não commitar chaves. Usar **GitHub Secrets** e **variáveis Terraform** (`terraform.tfvars` local, não versionado).

---

## 4) Link do Repositório
> Suba todo o conteúdo desta pasta para um repositório (ex.: `https://github.com/<seu-usuario>/devops-fase1`).  
> **Link do repositório:** (inserir aqui)

---

## 5) Testes Automatizados
- Testes de integração com Supertest no endpoint `/health` retornando `200 OK` e payload `{ "status": "ok" }`.
- `npm test` roda no CI com cobertura.

---

## 6) Aulas que embasam a Fase 1
1. **Introdução ao DevOps**  
2. **Integração Contínua (CI)**  
3. **Entrega Contínua (CD)**  
4. **Infraestrutura como Código (IaC)**

---

## 7) Como executar localmente

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

## 8) Como validar o Terraform localmente
```bash
cd infra/terraform
terraform fmt -check
terraform init
terraform validate
# Opcional (se tiver segredos configurados no ambiente):
# terraform plan -var="aws_region=us-east-1" -var="bucket_name=devops-fase1-<seu-usuario>"
```

---

## 9) Roadmap (próximos passos)
- Adicionar *backend remoto* ao Terraform (S3 + DynamoDB).
- Habilitar `terraform plan`/`apply` no GitHub Actions usando OIDC para *federated credentials* (melhor que chaves estáticas).
- Adicionar *CD* (deploy automatizado via GitHub Actions para EC2 ou ECS).
