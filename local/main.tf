# Configuración del provider para LocalStack
# Este archivo se usa solo cuando se ejecuta con LocalStack

provider "aws" {
  region = "us-east-1"
  
  # Configuración para LocalStack
  access_key = "test"
  secret_key = "test"
  
  # Endpoints de LocalStack
  endpoints {
    ec2     = "http://localhost:4566"
    vpc     = "http://localhost:4566"
    iam     = "http://localhost:4566"
    sts     = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
  }
  
  # Configuraciones específicas para LocalStack
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  
  # Para evitar errores de validación en LocalStack
  s3_use_path_style = true
  
  default_tags {
    tags = {
      Project     = "ec2-localstack"
      Environment = "local"
      ManagedBy   = "Terraform"
      LocalStack  = "true"
    }
  }
}

# VPC principal para LocalStack
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ec2-localstack-vpc"
    LocalStack = "true"
  }
}

# Subred pública para LocalStack
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ec2-localstack-public-subnet"
    LocalStack = "true"
  }
}

# Internet Gateway para LocalStack
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ec2-localstack-igw"
    LocalStack = "true"
  }
}

# Route Table para LocalStack
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "ec2-localstack-public-rt"
    LocalStack = "true"
  }
}

# Asociación de Route Table para LocalStack
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group para LocalStack
resource "aws_security_group" "ec2" {
  name        = "ec2-localstack-ec2-sg"
  description = "Security group para la instancia EC2 en LocalStack"
  vpc_id      = aws_vpc.main.id

  # Regla para SSH (puerto 22)
  ingress {
    description = "SSH desde cualquier IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla para HTTP (puerto 80)
  ingress {
    description = "HTTP desde cualquier IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla para HTTPS (puerto 443)
  ingress {
    description = "HTTPS desde cualquier IP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla para tráfico saliente
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-localstack-ec2-sg"
    LocalStack = "true"
  }
}

# Key Pair para LocalStack
resource "aws_key_pair" "deployer" {
  key_name   = "ec2-localstack-key"
  public_key = file("${path.module}/../ssh/id_rsa.pub")
  
  tags = {
    LocalStack = "true"
  }
}

# Instancia EC2 para LocalStack
resource "aws_instance" "main" {
  ami                    = "ami-12345678" # AMI dummy para LocalStack
  instance_type          = "t3.micro"
  key_name              = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = aws_subnet.public.id

  # Configuración específica para LocalStack
  tags = {
    Name = "ec2-localstack-ec2"
    LocalStack = "true"
  }

  # LocalStack no ejecuta user_data real, así que lo simplificamos
  user_data = <<-EOF
              #!/bin/bash
              echo "Instancia creada en LocalStack"
              EOF
}

# Elastic IP para LocalStack
resource "aws_eip" "main" {
  instance = aws_instance.main.id
  domain   = "vpc"

  tags = {
    Name = "ec2-localstack-eip"
    LocalStack = "true"
  }
}
