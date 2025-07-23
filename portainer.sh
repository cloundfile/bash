#!/bin/bash

# Nome do volume Docker
VOLUME_NAME="portainer_data"
CONTAINER_NAME="portainer"

echo "🔧 Docker Criando volume portainer_data..."
docker volume create portainer_data

echo "🐳 Iniciando container Portainer..."
docker run -d \
  -p 9000:9000 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer:latest

echo "✅ Portainer está em execução! Acesse no browser em: http://10.1.1.2:9000"
