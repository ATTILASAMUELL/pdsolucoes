# 🚀 Quick Start - PD Hours Control

Guia rápido para começar a usar o projeto em **5 minutos**.

## Passo 1: Iniciar Docker

```bash
cd pdsolucoes-back-end
docker-compose up -d
```

Aguarde os containers subirem (~30-60 segundos).

## Passo 2: Verificar Serviços

```bash
docker-compose ps
```

Você deve ver 4 containers rodando:
- ✅ `pdsolucoes-postgres` (PostgreSQL)
- ✅ `pdsolucoes-redis` (Cache)
- ✅ `pdsolucoes-mailhog` (Email)
- ✅ `pdsolucoes-api` (API Node.js)

## Passo 3: Acessar Swagger

Abra no navegador: **http://localhost:3000/api-docs**

## Passo 4: Fazer Login

1. Na interface do Swagger, vá até **Auth** > **`/api/v1/auth/login`**
2. Clique em **"Try it out"**
3. Use as credenciais padrão:

```json
{
  "email": "admin@pdsolucoes.com",
  "password": "admin123"
}
```

4. Clique em **"Execute"**
5. **Copie o token** da resposta

## Passo 5: Autorizar Requisições

1. Clique no botão **"Authorize"** 🔓 no topo da página do Swagger
2. Cole o token copiado no campo `Value`
3. Clique em **"Authorize"**
4. Clique em **"Close"**

## 🎉 Pronto!

Agora você pode testar todos os endpoints autenticados!

---

## 📧 Testar Emails

### Enviar email de recuperação de senha:

1. No Swagger, vá até **Auth** > **`/api/v1/auth/forgot-password`**
2. Execute com: `{"email": "admin@pdsolucoes.com"}`
3. Abra http://localhost:8025 para ver o email no MailHog

---

## 🔗 Links Úteis

| Serviço | URL | Descrição |
|---------|-----|-----------|
| **API** | http://localhost:3000 | Servidor principal |
| **Swagger** | http://localhost:3000/api-docs | Documentação interativa |
| **MailHog** | http://localhost:8025 | Visualizar emails |
| **Health Check** | http://localhost:3000/health | Status da API |

---

## 📚 Próximos Passos

- 📖 Leia o [README.md](README.md) completo
- 🐳 Veja [SETUP.md](SETUP.md) para configuração detalhada
- 📧 Aprenda mais sobre emails em [MAILHOG.md](MAILHOG.md)
- 💾 Entenda o sistema de cache em [CACHE-STRATEGY.md](CACHE-STRATEGY.md)

---

## 🛑 Parar o Projeto

```bash
docker-compose down
```

---

## 🔄 Reiniciar do Zero

```bash
# Parar e remover tudo (incluindo dados do banco)
docker-compose down -v

# Iniciar novamente
docker-compose up -d
```

---

## 🆘 Problemas?

### API não inicia

```bash
docker-compose logs api
```

### Migrations não aplicadas

```bash
docker exec -it pdsolucoes-api npx prisma migrate deploy
```

### Seed não executado

```bash
docker exec -it pdsolucoes-api npm run seed
```

---

✨ **Divirta-se desenvolvendo!**




