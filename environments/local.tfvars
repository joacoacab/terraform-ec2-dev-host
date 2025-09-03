# Configuración para LocalStack (desarrollo local)

aws_region = "us-east-1"
project_name = "ec2-localstack"
environment = "local"

vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
availability_zone  = "us-east-1a"

# Para LocalStack, usa AMIs genéricas
ami_id        = "ami-12345678" # AMI dummy para LocalStack
instance_type = "t3.micro"

# Configuración específica para LocalStack
use_localstack = true
localstack_endpoint = "http://localhost:4566"
