#!/bin/bash

# Script para generar claves SSH para el proyecto

echo "Generando claves SSH para el proyecto..."

# Crear directorio ssh si no existe
mkdir -p ssh

# Generar par de claves SSH
ssh-keygen -t rsa -b 4096 -f ./ssh/id_rsa -N "" -C "terraform-ec2-dev-host"

# Cambiar permisos de la clave privada
chmod 600 ./ssh/id_rsa

# Cambiar permisos de la clave pública
chmod 644 ./ssh/id_rsa.pub

echo "Claves SSH generadas exitosamente en el directorio ./ssh/"
echo "Clave privada: ./ssh/id_rsa"
echo "Clave pública: ./ssh/id_rsa.pub"
echo ""
echo "IMPORTANTE: Mantén segura tu clave privada y nunca la compartas!"
