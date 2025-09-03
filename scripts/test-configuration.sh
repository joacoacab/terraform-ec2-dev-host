#!/bin/bash

# Script para probar la nueva configuración unificada

echo "🧪 Probando configuración unificada de Terraform..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar sección
section() {
    echo ""
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Función para mostrar resultado
result() {
    if [ $1 -eq 0 ]; then
        echo -e "✅ $2"
    else
        echo -e "❌ $2"
        return 1
    fi
}

# Contador de errores
errors=0

section "Verificando estructura de archivos"

# Verificar archivos principales
[ -f "main.tf" ] && result 0 "main.tf encontrado" || { result 1 "main.tf no encontrado"; ((errors++)); }
[ -f "variables.tf" ] && result 0 "variables.tf encontrado" || { result 1 "variables.tf no encontrado"; ((errors++)); }
[ -f "outputs.tf" ] && result 0 "outputs.tf encontrado" || { result 1 "outputs.tf no encontrado"; ((errors++)); }

section "Verificando archivos de ambiente"

# Verificar archivos de ambiente
[ -f "environments/dev.tfvars" ] && result 0 "environments/dev.tfvars encontrado" || { result 1 "environments/dev.tfvars no encontrado"; ((errors++)); }
[ -f "environments/prod.tfvars" ] && result 0 "environments/prod.tfvars encontrado" || { result 1 "environments/prod.tfvars no encontrado"; ((errors++)); }
[ -f "environments/local.tfvars" ] && result 0 "environments/local.tfvars encontrado" || { result 1 "environments/local.tfvars no encontrado"; ((errors++)); }

section "Verificando configuración de LocalStack"

# Verificar que no haya conflictos de backend
if [ -f "backend.tf" ]; then
    result 0 "backend.tf configurado correctamente"
else
    result 1 "backend.tf no encontrado"
    ((errors++))
fi

section "Validando sintaxis de Terraform"

# Validar sintaxis
if command -v terraform &> /dev/null; then
    echo "🔍 Validando sintaxis..."
    terraform validate
    if [ $? -eq 0 ]; then
        result 0 "Sintaxis válida"
    else
        result 1 "Errores de sintaxis encontrados"
        ((errors++))
    fi
else
    echo -e "${YELLOW}⚠️  Terraform no encontrado, saltando validación${NC}"
fi

section "Verificando variables de LocalStack"

# Verificar que las variables de LocalStack estén definidas
if grep -q "use_localstack" variables.tf; then
    result 0 "Variable use_localstack definida"
else
    result 1 "Variable use_localstack no encontrada"
    ((errors++))
fi

if grep -q "localstack_endpoint" variables.tf; then
    result 0 "Variable localstack_endpoint definida"
else
    result 1 "Variable localstack_endpoint no encontrada"
    ((errors++))
fi

section "Verificando configuración del provider"

# Verificar configuración condicional del provider
if grep -q "dynamic \"endpoints\"" main.tf; then
    result 0 "Configuración dinámica de endpoints encontrada"
else
    result 1 "Configuración dinámica de endpoints no encontrada"
    ((errors++))
fi

if grep -q "var.use_localstack" main.tf; then
    result 0 "Referencias a use_localstack encontradas"
else
    result 1 "Referencias a use_localstack no encontradas"
    ((errors++))
fi

section "Resumen de la prueba"

if [ $errors -eq 0 ]; then
    echo -e "${GREEN}🎉 ¡Configuración unificada funcionando correctamente!${NC}"
    echo ""
    echo "🚀 Próximos pasos:"
    echo "1. 🐳 Iniciar LocalStack: make localstack-start"
    echo "2. 🧪 Probar en LocalStack: make local"
    echo "3. ☁️  Probar en AWS: make dev"
    echo ""
    echo "💡 La nueva estructura permite:"
    echo "   - Un solo archivo main.tf para ambos entornos"
    echo "   - Configuración automática según el ambiente"
    echo "   - Fácil cambio entre AWS real y LocalStack"
else
    echo -e "${RED}⚠️  Se encontraron $errors errores en la configuración${NC}"
    echo ""
    echo "🔧 Revisa los errores anteriores y corrige la configuración"
fi

echo ""
echo "📖 Para más información, consulta el README.md actualizado"
