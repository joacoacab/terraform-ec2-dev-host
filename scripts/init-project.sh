#!/bin/bash

# Script de inicialización del proyecto Terraform EC2

echo "🚀 Inicializando proyecto Terraform EC2 Dev Host..."

# Verificar que Terraform esté instalado
if ! command -v terraform &> /dev/null; then
    echo "❌ Error: Terraform no está instalado"
    echo "Por favor instala Terraform desde: https://www.terraform.io/downloads.html"
    exit 1
fi

# Verificar que AWS CLI esté configurado
if ! command -v aws &> /dev/null; then
    echo "❌ Error: AWS CLI no está instalado"
    echo "Por favor instala AWS CLI desde: https://aws.amazon.com/cli/"
    exit 1
fi

# Verificar configuración de AWS
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ Error: AWS CLI no está configurado"
    echo "Por favor ejecuta: aws configure"
    exit 1
fi

echo "✅ Prerrequisitos verificados"

# Generar claves SSH
echo "🔑 Generando claves SSH..."
bash "$(dirname "$0")/generate-ssh-keys.sh"

# Inicializar Terraform
echo "🔧 Inicializando Terraform..."
terraform init

# Validar configuración
echo "✅ Validando configuración..."
terraform validate

# Mostrar plan inicial
echo "📋 Mostrando plan inicial..."
terraform plan -var-file=environments/dev.tfvars

echo ""
echo "🎉 ¡Proyecto inicializado exitosamente!"
echo ""
echo "📚 Próximos pasos:"
echo "1. Revisa el plan de Terraform arriba"
echo "2. Ejecuta: terraform apply -var-file=environments/dev.tfvars"
echo "3. O usa: make dev"
echo ""
echo "🔍 Comandos útiles:"
echo "- make help          # Ver todos los comandos disponibles"
echo "- make plan          # Planificar cambios"
echo "- make apply         # Aplicar cambios"
echo "- make destroy       # Destruir infraestructura"
echo ""
echo "📖 Para más información, consulta el README.md"
