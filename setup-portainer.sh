#!/bin/bash

set -e  # Encerra o script se algum comando falhar

# Verifica se o Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "🚨 Docker não encontrado. Iniciando instalação..."

    # Atualiza pacotes e instala dependências
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg

    # Adiciona chave GPG do Docker
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Adiciona o repositório do Docker
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Instala o Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "✅ Docker instalado com sucesso!"
else
    echo "✅ Docker já está instalado: $(docker --version)"
fi

# Verifica se o container do Portainer já existe
if docker ps -a --format '{{.Names}}' | grep -qw portainer; then
    if docker ps --format '{{.Names}}' | grep -qw portainer; then
        echo "✅ Portainer está em execução."
    else
        echo "⚠️  Portainer está instalado, mas não está rodando. Iniciando..."
        docker start portainer
    fi
else
    echo "🔧 Docker criando volume para Portainer..."
    docker volume create portainer_data

    echo "🐳 Iniciando container Portainer..."
    docker run -d \
        -p 9000:9000 \
        --name portainer \
        --restart=always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v portainer_data:/data \
        portainer/portainer:latest

    echo "✅ Portainer está em execução! Acesse no browser em: http://$(hostname -I):9000"
fi
