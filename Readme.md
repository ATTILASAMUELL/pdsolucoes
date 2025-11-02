# PDSoluções - Sistema de Controle de Horas

Sistema completo para gerenciamento de horas trabalhadas de funcionários organizados em squads.

Fotos do sistema:

Mobile:
<img width="1636" height="856" alt="image" src="https://github.com/user-attachments/assets/30d5a825-d45c-4e71-ab78-45c05e5a0cd9" />

Web:
<img width="1550" height="722" alt="image" src="https://github.com/user-attachments/assets/a1a3eee6-32f5-4491-bd4c-bcd6feb8764b" />
<img width="1553" height="719" alt="image" src="https://github.com/user-attachments/assets/d51699be-a0c5-4809-86c1-b4ea5627436d" />

---

## ⚡ Quick Start

```bash
# 1. Na raiz do projeto
cd C:\pdsolucoes-teste-attila

# 2. Crie o arquivo .env baseado no exemplo
cp .env.example .env

# 4. Execute tudo com Docker
docker-compose up -d --build

# 5. Acesse: http://localhost:8097
# Login: admin@pdsolucoes.com / admin123
```

**💡 Dica**: Para gerar um JWT_SECRET seguro no PowerShell:
```powershell
-join ((65..90) + (97..122) + (48..57) + (33,35,36,37,38,42,43,45,61,63,64,94,95) | Get-Random -Count 64 | ForEach-Object { [char]$_ })
```

---

## 📋 Sobre o Projeto

Sistema full-stack para controle de horas de trabalho com:

### 📱 **Front-end** - Aplicação Web/Mobile
- **Tecnologia**: Flutter 2.17+
- **Arquitetura**: Clean Architecture (Domain, Data, Presentation)
- **Estado**: BLoC Pattern
- **UI**: Material Design responsivo

### 🖥️ **Back-end** - API RESTful
- **Tecnologia**: Node.js 20 + Express 4.21
- **Arquitetura**: Camadas (MVC + Clean Architecture)
- **Banco de Dados**: PostgreSQL 16 + Prisma ORM 6.18
- **Cache**: Redis 7 (Cache-Aside Pattern)
- **Documentação**: Swagger/OpenAPI
- **Testes**: Jest 29.7 + Supertest 7.0 (100% rotas, 70% coverage)

**📚 Para detalhes técnicos completos, consulte:**
- Front-end: `pdsolucoes_front_end/README.md`
- Back-end: `pdsolucoes-back-end/README.md`

---

## 🏗️ Arquitetura

Ambos os projetos seguem princípios de **Clean Architecture**:

### 📱 **Front-end (Flutter)**
```
lib/
├── domain/      # Entidades, UseCases, Repositories (interfaces)
├── data/        # Models, DataSources, Repositories (implementações)
├── presentation/# BLoCs, Pages, Widgets
└── core/        # Constantes, Rotas, Temas, Utils
```
- **Padrão**: BLoC Pattern + Repository Pattern
- **Camadas**: Domain → Data → Presentation

### 🖥️ **Back-end (Node.js + Express)**
```
src/
├── routes/      # Definição de endpoints
├── middlewares/ # Auth, Validação, Error Handling
├── controllers/ # Recebe requisições HTTP
├── services/    # Lógica de negócio
├── prisma/      # ORM e Migrations
└── utils/       # Utilitários
```
- **Padrão**: MVC + Layered Architecture
- **Cache**: Redis (Cache-Aside Pattern)
- **Banco**: PostgreSQL + Prisma ORM

**📚 Documentação detalhada:**
- [Front-end README](pdsolucoes_front_end/README.md) - Componentes, BLoCs, Clean Architecture
- [Back-end README](pdsolucoes-back-end/README.md) - API, Endpoints, Testes, Cache Strategy

---

## 🚀 Como Executar

| Opção | Onde executar | O que sobe | Quando usar |
|-------|---------------|------------|-------------|
| **🐳 Docker Raiz** | `C:\pdsolucoes-teste-attila` | Front + Back + DBs | ✅ Recomendado - Sistema completo |
| **🔧 Docker Projeto** | Dentro de cada pasta | Apenas aquele projeto | Desenvolvimento separado |
| **💻 Local Manual** | Cada pasta individualmente | Sem Docker | Debug e desenvolvimento |

---

### 🎯 Opção 1: Docker da Raiz (Recomendado)

Execute todo o sistema com um comando:

```bash
cd C:\pdsolucoes-teste-attila
docker-compose up -d --build
```

**Acesse:**
- 🌐 Front-end: http://localhost:8097
- 🔌 API: http://localhost:3000
- 📚 Swagger: http://localhost:3000/api-docs
- 📧 MailHog: http://localhost:8025

**Parar:**
```bash
docker-compose down
```

---

### 🔧 Opção 2: Docker por Projeto

Execute apenas um projeto por vez:

```bash
# Apenas Back-end (API + PostgreSQL + Redis + MailHog)
cd pdsolucoes-back-end
docker-compose up -d --build

# OU apenas Front-end (Web)
cd pdsolucoes_front_end
docker-compose up -d --build
```

**📖 Detalhes:** Consulte o README de cada projeto para instruções específicas.

---

### 💻 Opção 3: Desenvolvimento Local

Para desenvolvimento sem Docker, consulte:
- [Front-end README](pdsolucoes_front_end/README.md) - Como configurar `.env` e rodar localmente
- [Back-end README](pdsolucoes-back-end/README.md) - Como configurar variáveis e rodar com `npm run dev`

---

## 🔑 Credenciais

| E-mail | Senha |
|--------|-------|
| `admin@pdsolucoes.com` | `admin123` |

---

## 🧪 Testes Automatizados

O back-end possui cobertura completa de testes com **Jest** e **Supertest**:

### 📊 Cobertura

| Tipo | Cobertura | Framework |
|------|-----------|-----------|
| **Testes de Integração** | 100% das rotas | Jest + Supertest |
| **Testes Unitários** | Services e Utils | Jest |
| **Coverage Mínimo** | 70% (configurado) | Jest Coverage |

### 🧪 Rotas Testadas (19 endpoints)

✅ **Auth** - 4 rotas | ✅ **Squad** - 5 rotas | ✅ **Employee** - 5 rotas | ✅ **Report** - 6 rotas

<details>
<summary>📋 Ver detalhes dos testes por rota</summary>

**Auth Routes:**
- POST `/api/v1/auth/login` - Login com credenciais
- POST `/api/v1/auth/refresh-token` - Renovar token
- POST `/api/v1/auth/forgot-password` - Recuperar senha
- POST `/api/v1/auth/logout` - Logout

**Squad Routes:**
- POST `/api/v1/squads` - Criar squad
- GET `/api/v1/squads` - Listar squads (com cache)
- GET `/api/v1/squads/:id` - Buscar squad
- PUT `/api/v1/squads/:id` - Atualizar squad
- DELETE `/api/v1/squads/:id` - Deletar squad

**Employee Routes:**
- POST `/api/v1/employees` - Criar funcionário
- GET `/api/v1/employees` - Listar funcionários (com cache)
- GET `/api/v1/employees/:id` - Buscar funcionário
- PUT `/api/v1/employees/:id` - Atualizar funcionário
- DELETE `/api/v1/employees/:id` - Deletar funcionário

**Report Routes:**
- POST `/api/v1/reports` - Criar relatório
- GET `/api/v1/reports` - Listar relatórios (com cache)
- GET `/api/v1/reports/squad/:squadId/member-hours` - Horas por membro
- GET `/api/v1/reports/squad/:squadId/total-hours` - Total de horas do squad
- GET `/api/v1/reports/squad/:squadId/average-hours` - Média de horas por dia
- GET `/api/v1/reports/dashboard` - Dashboard (com cache)

</details>

### 🚀 Executar Testes

```bash
cd pdsolucoes-back-end

npm test                 # Todos os testes com coverage
npm run test:unit        # Apenas testes unitários
npm run test:integration # Apenas testes de integração
npm run test:watch       # Modo watch
```

**📚 Mais detalhes:** Consulte `pdsolucoes-back-end/README.md` para documentação completa dos testes.

---

## 🔧 Troubleshooting

### Conflito de containers (nomes duplicados)

Se aparecer erro: `"The container name is already in use"`, pare e remova os containers antigos:

```bash
# Parar todos os containers PDSoluções
docker stop pdsolucoes-postgres pdsolucoes-redis pdsolucoes-mailhog pdsolucoes-api pdsolucoes-web

# Remover containers
docker rm pdsolucoes-postgres pdsolucoes-redis pdsolucoes-mailhog pdsolucoes-api pdsolucoes-web

# Agora execute novamente
docker-compose up -d --build
```

### Limpar tudo e recomeçar

```bash
# Para todos os containers e remove volumes
docker-compose down -v

# Remove imagens antigas
docker rmi pdsolucoes-teste-attila-api pdsolucoes-teste-attila-web pdsolucoes_front_end-web

# Rebuild completo
docker-compose up -d --build
```

### Front-end não conecta na API

1. Verifique se a API está rodando: http://localhost:3000/health
2. Verifique o `API_BASE_URL` no arquivo `.env` do front-end
3. Se rodando em dispositivo físico, use o IP da máquina (ex: `192.168.1.117:3000`)

---

## 📄 Licença

ISC


