#!/bin/bash

set -e

ENV=${1:-dev}

echo "🚀 Iniciando build do PDSoluções Front-end..."
echo "📦 Ambiente: $ENV"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ ! -f .env ]; then
    echo "⚠️  Arquivo .env não encontrado!"
    echo "📝 Criando .env a partir do .env.example..."
    cp .env.example .env
fi

echo -e "${BLUE}📦 Fazendo build da imagem Docker...${NC}"
docker build -t pdsolucoes-web:$ENV .

if [ "$(docker ps -aq -f name=pdsolucoes-web)" ]; then
    echo -e "${BLUE}🛑 Parando container anterior...${NC}"
    docker stop pdsolucoes-web || true
    docker rm pdsolucoes-web || true
fi

echo -e "${BLUE}🚀 Iniciando novo container...${NC}"
if [ "$ENV" = "prod" ]; then
    docker run -d \
        --name pdsolucoes-web \
        -p 80:80 \
        --restart unless-stopped \
        pdsolucoes-web:$ENV
    echo -e "${GREEN}✅ Aplicação rodando em: http://localhost${NC}"
else
    docker run -d \
        --name pdsolucoes-web \
        -p 8097:80 \
        --restart unless-stopped \
        pdsolucoes-web:$ENV
    echo -e "${GREEN}✅ Aplicação rodando em: http://localhost:8097${NC}"
fi

echo -e "${BLUE}📋 Logs do container:${NC}"
docker logs -f pdsolucoes-web

