#!/bin/bash

# Script para cambiar entre backends de AWS y LocalStack

echo "🔄 Cambiando configuración de backend..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo "Uso: $0 [aws|local]"
    echo ""
    echo "Opciones:"
    echo "  aws   - Configurar backend para AWS real"
    echo "  local - Configurar backend para LocalStack"
    echo ""
    echo "Ejemplos:"
    echo "  $0 aws    # Cambiar a backend de AWS"
    echo "  $0 local  # Cambiar a backend de LocalStack"
}

# Función para cambiar a backend de AWS
switch_to_aws() {
    echo -e "${BLUE}🔄 Cambiando a backend de AWS...${NC}"
    
    # Hacer backup del backend actual
    if [ -f "backend.tf" ]; then
        cp backend.tf backend.tf.backup
        echo "✅ Backup del backend actual creado"
    fi
    
    # Copiar backend de AWS
    cp backend.tf.example backend.tf
    echo "✅ Backend de AWS configurado"
    
    echo "✅ Backend de AWS configurado"
    
    echo -e "${GREEN}✅ Backend cambiado a AWS exitosamente${NC}"
    echo ""
    echo "💡 Próximos pasos:"
    echo "1. Edita backend.tf con tu configuración de S3"
    echo "2. Ejecuta: terraform init -migrate-state"
    echo "3. Despliega: make dev"
}

# Función para cambiar a backend de LocalStack
switch_to_local() {
    echo -e "${BLUE}🔄 Cambiando a backend de LocalStack...${NC}"
    
    # Hacer backup del backend actual
    if [ -f "backend.tf" ]; then
        cp backend.tf backend.tf.backup
        echo "✅ Backup del backend actual creado"
    fi
    
    # Usar backend local
    cat > backend.tf << 'EOF'
# Backend local para LocalStack

terraform {
  backend "local" {
    path = "terraform-local.tfstate"
  }
}
EOF
    echo "✅ Backend local configurado"
    
    echo -e "${GREEN}✅ Backend cambiado a LocalStack exitosamente${NC}"
    echo ""
    echo "💡 Próximos pasos:"
    echo "1. Inicia LocalStack: make localstack-start"
    echo "2. Inicializa Terraform: terraform init"
    echo "3. Despliega: make local"
}

# Verificar argumentos
if [ $# -eq 0 ]; then
    echo -e "${RED}❌ Error: Debes especificar el backend${NC}"
    show_help
    exit 1
fi

case "$1" in
    "aws")
        switch_to_aws
        ;;
    "local")
        switch_to_local
        ;;
    *)
        echo -e "${RED}❌ Error: Opción inválida '$1'${NC}"
        show_help
        exit 1
        ;;
esac
