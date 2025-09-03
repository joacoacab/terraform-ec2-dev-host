#!/bin/bash

# Script para detener LocalStack

echo "🛑 Deteniendo LocalStack..."

# Detener contenedores
docker-compose down

# Limpiar volúmenes (opcional)
read -p "¿Deseas eliminar los volúmenes de LocalStack? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🧹 Eliminando volúmenes..."
    docker volume prune -f
    rm -rf volume
    echo "✅ Volúmenes eliminados"
else
    echo "💾 Volúmenes conservados para la próxima ejecución"
fi

echo "✅ LocalStack detenido"
