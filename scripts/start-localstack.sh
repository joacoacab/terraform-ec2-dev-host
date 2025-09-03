#!/bin/bash

# Script para iniciar LocalStack

echo "🚀 Iniciando LocalStack..."

# Verificar si Docker está ejecutándose
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker no está ejecutándose"
    echo "Por favor inicia Docker y vuelve a intentar"
    exit 1
fi

# Crear directorio para volúmenes si no existe
mkdir -p volume

# Iniciar LocalStack
echo "🐳 Iniciando contenedor de LocalStack..."
docker-compose up -d

# Esperar a que LocalStack esté listo
echo "⏳ Esperando a que LocalStack esté listo..."
until curl -s http://localhost:4566/_localstack/health > /dev/null; do
    echo "   Esperando..."
    sleep 2
done

echo "✅ LocalStack está listo en http://localhost:4566"
echo ""
echo "🔧 Para usar con Terraform:"
echo "1. Ejecuta: terraform init"
echo "2. Ejecuta: terraform plan -var-file=environments/local.tfvars"
echo "3. Ejecuta: terraform apply -var-file=environments/local.tfvars"
echo ""
echo "🌐 Dashboard: http://localhost:4566/_localstack/dashboard"
echo "📊 Health: http://localhost:4566/_localstack/health"
