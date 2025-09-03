#!/bin/bash
# User data para instancia EC2 en AWS real

# Actualizar el sistema
yum update -y

# Instalar Apache HTTP Server
yum install -y httpd

# Iniciar y habilitar el servicio HTTP
systemctl start httpd
systemctl enable httpd

# Crear página de bienvenida
cat > /var/www/html/index.html << 'HTML_EOF'
<!DOCTYPE html>
<html>
<head>
    <title>EC2 Dev Host</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f0f0f0; }
        .container { background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; }
        .info { background-color: #ecf0f1; padding: 15px; border-radius: 5px; margin: 20px 0; }
        .success { color: #27ae60; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 ¡Bienvenido a tu EC2 Dev Host!</h1>
        <div class="info">
            <p><strong>Estado:</strong> <span class="success">✅ Funcionando correctamente</span></p>
            <p><strong>Servidor:</strong> Apache HTTP Server</p>
            <p><strong>Gestionado por:</strong> Terraform</p>
            <p><strong>Timestamp:</strong> $(date)</p>
        </div>
        <p>Tu instancia EC2 está funcionando correctamente. ¡Puedes comenzar a desarrollar!</p>
    </div>
</body>
</html>
HTML_EOF

# Configurar permisos
chown apache:apache /var/www/html/index.html
chmod 644 /var/www/html/index.html

# Mostrar información del sistema
echo "=== Información del Sistema ==="
echo "Hostname: $(hostname)"
echo "IP Privada: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
echo "IP Pública: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
echo "Región: $(curl -s http://169.254.169.254/latest/meta-data/placement/region)"
echo "Timestamp: $(date)"
echo "================================"
