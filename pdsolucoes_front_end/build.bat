@echo off

setlocal enabledelayedexpansion

set ENV=%1
if "%ENV%"=="" set ENV=dev

echo 🚀 Iniciando build do PDSoluções Front-end...
echo 📦 Ambiente: %ENV%

if not exist .env (
    echo ⚠️  Arquivo .env não encontrado!
    echo 📝 Criando .env a partir do .env.example...
    copy .env.example .env
)

echo 📦 Fazendo build da imagem Docker...
docker build -t pdsolucoes-web:%ENV% .

echo 🛑 Parando container anterior se existir...
docker stop pdsolucoes-web 2>nul
docker rm pdsolucoes-web 2>nul

echo 🚀 Iniciando novo container...
if "%ENV%"=="prod" (
    docker run -d --name pdsolucoes-web -p 80:80 --restart unless-stopped pdsolucoes-web:%ENV%
    echo ✅ Aplicação rodando em: http://localhost
) else (
    docker run -d --name pdsolucoes-web -p 8097:80 --restart unless-stopped pdsolucoes-web:%ENV%
    echo ✅ Aplicação rodando em: http://localhost:8097
)

echo 📋 Logs do container:
docker logs -f pdsolucoes-web

