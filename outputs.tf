# Outputs del proyecto
# NOTA: Para LocalStack, estos outputs están comentados temporalmente
# ya que los recursos se definen en environments/local.tf

# output "instance_id" {
#   description = "ID de la instancia EC2"
#   value       = aws_instance.main.id
# }

# output "instance_public_ip" {
#   description = "IP pública de la instancia EC2"
#   value       = aws_eip.main.public_ip
# }

# output "instance_private_ip" {
#   description = "IP privada de la instancia EC2"
#   value       = aws_instance.main.private_ip
# }

# output "vpc_id" {
#   description = "ID de la VPC creada"
#   value       = aws_vpc.main.id
# }

# output "subnet_id" {
#   description = "ID de la subred pública"
#   value       = aws_subnet.public.id
# }

# output "security_group_id" {
#   description = "ID del security group"
#   value       = aws_security_group.ec2.id
# }

# output "ssh_command" {
#   description = "Comando SSH para conectarse a la instancia"
#   value       = "ssh -i ssh/id_rsa ec2-user@${aws_eip.main.public_ip}"
# }

# output "http_url" {
#   description = "URL HTTP de la instancia"
#   value       = "http://${aws_eip.main.public_ip}"
# }

# output "https_url" {
#   description = "URL HTTPS de la instancia"
#   value       = "https://${aws_eip.main.public_ip}"
# }
