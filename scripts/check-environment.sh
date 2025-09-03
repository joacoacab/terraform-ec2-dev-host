#!/bin/bash

# Script para verificar el entorno de desarrollo

echo "🔍 Verificando entorno de desarrollo..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para verificar comando
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "✅ $1: $(command -v $1)"
        return 0
    else
        echo -e "❌ $1: No encontrado"
        return 1
    fi
}

# Función para verificar versión
check_version() {
    if command -v $1 &> /dev/null; then
        version=$($1 --version 2>/dev/null | head -n1)
        echo -e "✅ $1: $version"
        return 0
    else
        echo -e "❌ $1: No encontrado"
        return 1
    fi
}

echo ""
echo "📋 Verificando herramientas básicas..."

# Verificar herramientas esenciales
terraform_ok=false
docker_ok=false
docker_compose_ok=false

check_version "terraform" && terraform_ok=true
check_version "docker" && docker_ok=true
check_version "docker-compose" && docker_compose_ok=false

# Verificar Docker Compose por separado (puede ser 'docker compose' en versiones nuevas)
if ! docker_compose_ok; then
    if docker compose version &> /dev/null; then
        echo -e "✅ docker compose: $(docker compose version | head -n1)"
        docker_compose_ok=true
    fi
fi

echo ""
echo "🐳 Verificando Docker..."

# Verificar que Docker esté ejecutándose
if docker info &> /dev/null; then
    echo -e "✅ Docker está ejecutándose"
    echo -e "   Versión: $(docker --version)"
    echo -e "   WSL Integration: $(docker info 2>/dev/null | grep -i "wsl" || echo "No detectado")"
else
    echo -e "❌ Docker no está ejecutándose o no tienes permisos"
    echo -e "   💡 Solución: Inicia Docker Desktop y habilita WSL2 integration"
fi

echo ""
echo "🔑 Verificando claves SSH..."

# Verificar directorio de claves SSH
ssh_keys_exist=false
if [ -d "ssh" ] && [ -f "ssh/id_rsa" ] && [ -f "ssh/id_rsa.pub" ]; then
    echo -e "✅ Claves SSH encontradas"
    echo -e "   Privada: ssh/id_rsa"
    echo -e "   Pública: ssh/id_rsa.pub"
    ssh_keys_exist=true
else
    echo -e "⚠️  Claves SSH no encontradas"
    echo -e "   💡 Ejecuta: make ssh-keys"
fi

echo ""
echo "📊 Resumen del entorno:"

if [ "$terraform_ok" = true ] && [ "$docker_ok" = true ] && [ "$docker_compose_ok" = true ]; then
    echo -e "${GREEN}🎉 ¡Entorno listo para usar!${NC}"
    echo ""
    echo "🚀 Próximos pasos:"
    
    if [ "$ssh_keys_exist" = false ]; then
        echo "1. 🔑 Generar claves SSH: make ssh-keys"
        echo "2. 🐳 Iniciar LocalStack: make localstack-start"
        echo "3. 🚀 Desplegar en LocalStack: make local"
        echo "4. ☁️  O desplegar en AWS: make dev"
    else
        echo "1. ✅ Claves SSH ya generadas"
        echo "2. 🐳 Iniciar LocalStack: make localstack-start"
        echo "3. 🚀 Desplegar en LocalStack: make local"
        echo "4. ☁️  O desplegar en AWS: make dev"
        echo "5. 🧹 Limpiar cuando termines: make localstack-stop"
    fi
else
    echo -e "${RED}⚠️  Hay problemas en el entorno${NC}"
    echo ""
    echo "🔧 Soluciones:"
    if [ "$terraform_ok" = false ]; then
        echo "- Instala Terraform: https://www.terraform.io/downloads.html"
    fi
    if [ "$docker_ok" = false ]; then
        echo "- Instala Docker Desktop y habilita WSL2 integration"
    fi
    if [ "$docker_compose_ok" = false ]; then
        echo "- Docker Compose debería venir con Docker Desktop"
    fi
fi

echo ""
echo "📖 Para más información, consulta el README.md"
