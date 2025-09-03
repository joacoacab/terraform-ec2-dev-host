# Ejemplo de configuración del backend de Terraform
# Descomenta y personaliza según tus necesidades

# terraform {
#   backend "s3" {
#     bucket         = "mi-bucket-terraform-state"
#     key            = "ec2-dev-host/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }

# Para usar este backend:
# 1. Crea un bucket S3 para el estado
# 2. Crea una tabla DynamoDB para los locks
# 3. Copia este archivo como backend.tf
# 4. Personaliza los valores
# 5. Ejecuta: terraform init
