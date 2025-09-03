# Variables para la configuración del proyecto

variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto para el tagging de recursos"
  type        = string
  default     = "ec2-dev-host"
}

variable "environment" {
  description = "Ambiente del proyecto (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block para la subred pública"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Zona de disponibilidad para la subred"
  type        = string
  default     = "us-east-1a"
}

variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2 en us-east-1
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.micro"
}

# Variables para LocalStack
variable "use_localstack" {
  description = "Indica si se debe usar LocalStack en lugar de AWS real"
  type        = bool
  default     = false
}

variable "localstack_endpoint" {
  description = "Endpoint de LocalStack (solo usado si use_localstack = true)"
  type        = string
  default     = "http://localhost:4566"
}
