# Configuración para el entorno de producción

aws_region = "us-east-1"
project_name = "ec2-prod-host"
environment = "prod"

vpc_cidr           = "10.1.0.0/16"
public_subnet_cidr = "10.1.1.0/24"
availability_zone  = "us-east-1a"

ami_id        = "ami-0c02fb55956c7d316" # Amazon Linux 2
instance_type = "t3.small" # Instancia más potente para producción
