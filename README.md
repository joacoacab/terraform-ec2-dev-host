# Terraform EC2 Dev Host

Template completo de Terraform para crear una instancia EC2 en AWS con toda la infraestructura de red necesaria.

## 🚀 Características

- **VPC completa** con subred pública
- **Internet Gateway** para acceso a internet
- **Security Groups** configurados para puertos 22 (SSH), 80 (HTTP) y 443 (HTTPS)
- **Instancia EC2** con configuración automática
- **Elastic IP** para IP pública fija
- **Key Pair** para acceso SSH seguro
- **Configuración por ambientes** (dev, prod, local)
- **Soporte completo para LocalStack** para desarrollo local
- **Scripts automatizados** para generación de claves SSH

## 📁 Estructura del Proyecto

```
terraform-ec2-dev-host/
├── main.tf                 # Recursos principales de Terraform (AWS + LocalStack)
├── variables.tf            # Definición de variables
├── outputs.tf              # Outputs del proyecto
├── versions.tf             # Versiones requeridas
├── backend.tf              # Configuración del backend (local por defecto)
├── backend.tf.example      # Ejemplo de backend remoto (S3)
├── docker-compose.yml      # Configuración de LocalStack
├── environments/           # Configuraciones por ambiente
│   ├── dev.tfvars         # Variables para desarrollo (AWS real)
│   ├── prod.tfvars        # Variables para producción (AWS real)
│   └── local.tfvars       # Variables para LocalStack (desarrollo local)
├── local/                  # Configuración específica para LocalStack (legacy)
│   ├── main.tf            # Configuración LocalStack (mantenido por compatibilidad)
│   └── terraform.tfvars   # Variables LocalStack (mantenido por compatibilidad)
├── scripts/                # Scripts de automatización
│   ├── generate-ssh-keys.sh    # Generar claves SSH
│   ├── start-localstack.sh     # Iniciar LocalStack
│   ├── stop-localstack.sh      # Detener LocalStack
│   └── init-project.sh         # Inicializar proyecto
├── Makefile                # Comandos útiles
├── .gitignore             # Archivos a excluir del repositorio
└── README.md              # Este archivo
```

## 🛠️ Prerrequisitos

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Docker](https://www.docker.com/) y [Docker Compose](https://docs.docker.com/compose/)
- [AWS CLI](https://aws.amazon.com/cli/) configurado (solo para AWS real)
- Acceso a una cuenta de AWS con permisos para crear recursos (solo para AWS real)

### 🐧 **Configuración para WSL (Windows Subsystem for Linux)**

Si usas WSL2 en Windows:

1. **Instalar Docker Desktop para Windows** y habilitar WSL2 integration
2. **En WSL2**, instalar Terraform:
   ```bash
   wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform
   ```
3. **Verificar Docker** desde WSL:
   ```bash
   docker --version
   docker-compose --version
   ```

## 🚀 Uso Rápido

### 1. Clonar y configurar

```bash
git clone <tu-repositorio>
cd terraform-ec2-dev-host
```

### 2. Generar claves SSH

```bash
bash scripts/generate-ssh-keys.sh
```

### 3. Configurar variables (opcional)

```bash
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con tus valores
```

### 4. Desplegar

```bash
# Inicializar
terraform init

# Planificar cambios
terraform plan -var-file=environments/dev.tfvars

# Aplicar cambios
terraform apply -var-file=environments/dev.tfvars
```

### 🐳 Desplegar con LocalStack (Desarrollo Local)

```bash
# Iniciar LocalStack
make localstack-start

# Desplegar en LocalStack
make local

# O manualmente:
terraform plan -var-file=environments/local.tfvars
terraform apply -var-file=environments/local.tfvars

# Detener LocalStack cuando termines
make localstack-stop
```

## 🎯 Comandos del Makefile

```bash
make help              # Mostrar ayuda
make check             # Verificar entorno de desarrollo
make init              # Inicializar Terraform
make plan              # Planificar cambios
make apply             # Aplicar cambios
make destroy           # Destruir infraestructura
make output            # Mostrar outputs
make ssh-keys          # Generar claves SSH
make dev               # Desplegar en desarrollo (AWS real)
make prod              # Desplegar en producción (AWS real)
make local             # Desplegar en LocalStack (desarrollo local)
make localstack-start  # Iniciar LocalStack
make localstack-stop   # Detener LocalStack
make validate          # Validar configuración
make format            # Formatear código
```

## 🔧 Configuración

### Variables Principales

| Variable | Descripción | Valor por Defecto |
|----------|-------------|-------------------|
| `aws_region` | Región de AWS | `us-east-1` |
| `project_name` | Nombre del proyecto | `ec2-dev-host` |
| `environment` | Ambiente | `dev` |
| `vpc_cidr` | CIDR de la VPC | `10.0.0.0/16` |
| `instance_type` | Tipo de instancia | `t3.micro` |
| `use_localstack` | Usar LocalStack | `false` |
| `localstack_endpoint` | Endpoint de LocalStack | `http://localhost:4566` |

### Configuración por Ambiente

- **Desarrollo (AWS real)**: `environments/dev.tfvars`
- **Producción (AWS real)**: `environments/prod.tfvars`
- **LocalStack (desarrollo local)**: `environments/local.tfvars`

### 🔄 **Configuración Automática**

El proyecto detecta automáticamente si se está ejecutando con LocalStack basándose en la variable `use_localstack`:

- **AWS real**: Configuración estándar con endpoints de AWS
- **LocalStack**: Configuración automática con endpoints locales y credenciales de prueba

## 🌐 Acceso a la Instancia

Después del despliegue, podrás acceder a tu instancia:

- **SSH**: `ssh -i ssh/id_rsa ec2-user@<IP_PUBLICA>`
- **HTTP**: `http://<IP_PUBLICA>`
- **HTTPS**: `https://<IP_PUBLICA>`

## 🔒 Seguridad

- Las claves SSH se generan automáticamente
- Security Groups configurados para puertos específicos
- VPC aislada con subred pública
- Tags de recursos para mejor organización

## 📈 Escalabilidad

Este template está diseñado para ser escalable:

- **Configuración unificada**: Un solo archivo `main.tf` maneja ambos entornos
- **Variables configurables**: Fácil personalización
- **Múltiples ambientes**: Configuraciones separadas por entorno
- **Backend flexible**: Soporte para S3/DynamoDB y local
- **LocalStack**: Desarrollo y testing local sin costos

## 🆕 Agregando Nuevos Recursos

Para agregar nuevos recursos de Terraform:

1. **Agregar al `main.tf` principal** con configuración condicional si es necesario
2. **Usar variables** para configuración
3. **Agregar outputs** relevantes
4. **Documentar** en el README

### Ejemplo de nuevo recurso:

```hcl
# En main.tf
resource "aws_db_instance" "main" {
  # configuración básica...
  
  # Configuración condicional para LocalStack
  skip_final_snapshot = var.use_localstack
}
```

## 🧹 Limpieza

```bash
# Destruir infraestructura
terraform destroy -var-file=environments/dev.tfvars

# Limpiar archivos temporales
make clean
```

## 📝 Notas Importantes

- **AMI**: El template usa Amazon Linux 2 por defecto para AWS real
- **LocalStack**: Usa AMIs genéricas (ami-12345678) para desarrollo local
- **Región**: Configurado para `us-east-1`, cambia según necesites
- **Costos**: `t3.micro` está en la capa gratuita de AWS
- **Backup**: Considera usar un backend remoto para el estado en producción

## 🤝 Contribuciones

1. Fork el proyecto
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🆘 Soporte

Si tienes problemas o preguntas:

1. Revisa la documentación
2. Verifica los logs de Terraform
3. Abre un issue en el repositorio

### 🔧 **Troubleshooting Común**

#### **Problemas con Docker en WSL**
```bash
# Verificar que Docker esté ejecutándose
docker ps

# Si hay problemas de permisos
sudo usermod -aG docker $USER
# Reiniciar WSL después de esto
```

#### **Problemas con LocalStack**
```bash
# Verificar logs de LocalStack
docker-compose logs localstack

# Reiniciar LocalStack
make localstack-stop
make localstack-start
```

#### **Problemas con Terraform**
```bash
# Limpiar estado
make clean

# Re-inicializar
terraform init
```

#### **Cambiar entre AWS real y LocalStack**
```bash
# Para AWS real
terraform plan -var-file=environments/dev.tfvars

# Para LocalStack
terraform plan -var-file=environments/local.tfvars
```

---

**¡Disfruta usando Terraform para gestionar tu infraestructura en AWS y LocalStack! 🚀**
