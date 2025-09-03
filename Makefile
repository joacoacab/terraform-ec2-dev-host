# Makefile para el proyecto de Terraform EC2 Dev Host
# Soporta tanto AWS real como LocalStack para desarrollo local

.PHONY: help init plan apply destroy clean ssh-keys test-config switch-backend

# =============================================================================
# VARIABLES DE CONFIGURACIÓN
# =============================================================================
ENVIRONMENT ?= dev
TF_VARS_FILE = environments/$(ENVIRONMENT).tfvars
TF_PLAN_FILE = terraform.plan

# =============================================================================
# COMANDOS PRINCIPALES
# =============================================================================

help: ## 📖 Mostrar esta ayuda detallada
	@echo "🚀 Terraform EC2 Dev Host - Comandos Disponibles"
	@echo "=================================================="
	@echo ""
	@echo "🌍 AMBIENTES DISPONIBLES:"
	@echo "  ENVIRONMENT=dev    - Desarrollo en AWS real"
	@echo "  ENVIRONMENT=prod   - Producción en AWS real"
	@echo "  ENVIRONMENT=local  - Desarrollo local con LocalStack"
	@echo ""
	@echo "📋 COMANDOS PRINCIPALES:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "💡 EJEMPLOS DE USO:"
	@echo "  make local                    # Desplegar en LocalStack"
	@echo "  make dev                      # Desplegar en AWS desarrollo"
	@echo "  make plan ENVIRONMENT=local   # Planificar para LocalStack"
	@echo "  make apply ENVIRONMENT=prod   # Aplicar en producción"

# =============================================================================
# COMANDOS DE TERRAFORM
# =============================================================================

init: ## 🔧 Inicializar Terraform
	@echo "🔧 Inicializando Terraform..."
	terraform init

plan: ## 📋 Planificar cambios de infraestructura
	@echo "📋 Planificando cambios para ambiente: $(ENVIRONMENT)"
	@echo "📁 Archivo de variables: $(TF_VARS_FILE)"
	terraform plan -var-file=$(TF_VARS_FILE) -out=$(TF_PLAN_FILE)

apply: ## 🚀 Aplicar cambios de infraestructura
	@echo "🚀 Aplicando cambios para ambiente: $(ENVIRONMENT)"
	@if [ -f "$(TF_PLAN_FILE)" ]; then \
		echo "📋 Aplicando plan guardado: $(TF_PLAN_FILE)"; \
		terraform apply "$(TF_PLAN_FILE)"; \
	else \
		echo "📋 Aplicando cambios directamente"; \
		terraform apply -var-file=$(TF_VARS_FILE) -auto-approve; \
	fi

destroy: ## 💥 Destruir infraestructura
	@echo "⚠️  ATENCIÓN: Destruyendo infraestructura para ambiente: $(ENVIRONMENT)"
	@echo "📁 Archivo de variables: $(TF_VARS_FILE)"
	@read -p "¿Estás seguro? Escribe 'yes' para continuar: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		terraform destroy -var-file=$(TF_VARS_FILE) -auto-approve; \
	else \
		echo "❌ Operación cancelada"; \
	fi

# =============================================================================
# COMANDOS POR AMBIENTE
# =============================================================================

dev: ## 🏗️  Desplegar en ambiente de desarrollo (AWS real)
	@echo "🏗️  Desplegando en ambiente de DESARROLLO (AWS real)..."
	$(MAKE) apply ENVIRONMENT=dev

prod: ## 🏭 Desplegar en ambiente de producción (AWS real)
	@echo "🏭 Desplegando en ambiente de PRODUCCIÓN (AWS real)..."
	@echo "⚠️  ATENCIÓN: Estás desplegando en PRODUCCIÓN"
	$(MAKE) apply ENVIRONMENT=prod

local: ## 🐳 Desplegar en LocalStack (desarrollo local)
	@echo "🐳 Desplegando en LOCALSTACK (desarrollo local)..."
	$(MAKE) apply ENVIRONMENT=local

# =============================================================================
# COMANDOS DE LOCALSTACK
# =============================================================================

localstack-start: ## 🚀 Iniciar LocalStack
	@echo "🚀 Iniciando LocalStack..."
	bash scripts/start-localstack.sh

localstack-stop: ## 🛑 Detener LocalStack
	@echo "🛑 Deteniendo LocalStack..."
	bash scripts/stop-localstack.sh

localstack-status: ## 📊 Verificar estado de LocalStack
	@echo "📊 Verificando estado de LocalStack..."
	@if docker ps | grep -q localstack; then \
		echo "✅ LocalStack está ejecutándose"; \
		echo "🌐 Dashboard: http://localhost:4566/_localstack/dashboard"; \
		echo "📊 Health: http://localhost:4566/_localstack/health"; \
	else \
		echo "❌ LocalStack no está ejecutándose"; \
		echo "💡 Ejecuta: make localstack-start"; \
	fi

# =============================================================================
# COMANDOS DE VALIDACIÓN Y TESTING
# =============================================================================

test-config: ## 🧪 Probar la configuración unificada
	@echo "🧪 Probando configuración unificada..."
	bash scripts/test-configuration.sh

check: ## 🔍 Verificar entorno de desarrollo
	@echo "🔍 Verificando entorno de desarrollo..."
	bash scripts/check-environment.sh

validate: ## ✅ Validar configuración de Terraform
	@echo "✅ Validando configuración de Terraform..."
	terraform validate

format: ## 🎨 Formatear código de Terraform
	@echo "🎨 Formateando código de Terraform..."
	terraform fmt -recursive

# =============================================================================
# COMANDOS DE INFORMACIÓN
# =============================================================================

output: ## 📤 Mostrar outputs de Terraform
	@echo "📤 Mostrando outputs de Terraform..."
	terraform output

show: ## 📋 Mostrar estado actual de Terraform
	@echo "📋 Mostrando estado actual de Terraform..."
	terraform show

state: ## 📝 Listar recursos en el estado
	@echo "📝 Listando recursos en el estado..."
	terraform state list

plan-show: ## 📋 Mostrar plan guardado
	@if [ -f "$(TF_PLAN_FILE)" ]; then \
		echo "📋 Mostrando plan guardado: $(TF_PLAN_FILE)"; \
		terraform show "$(TF_PLAN_FILE)"; \
	else \
		echo "❌ No hay plan guardado. Ejecuta: make plan"; \
	fi

# =============================================================================
# COMANDOS DE UTILIDAD
# =============================================================================

ssh-keys: ## 🔑 Generar claves SSH
	@echo "🔑 Generando claves SSH..."
	bash scripts/generate-ssh-keys.sh

switch-backend: ## 🔄 Cambiar entre backends de AWS y LocalStack
	@echo "🔄 Cambiar entre backends de AWS y LocalStack"
	@echo ""
	@echo "Uso:"
	@echo "  make switch-backend-aws   # Cambiar a backend de AWS (S3)"
	@echo "  make switch-backend-local # Cambiar a backend local"
	@echo ""
	@echo "Ejemplo:"
	@echo "  make switch-backend-local"

switch-backend-%: ## 🔄 Cambiar a backend específico (aws o local)
	@echo "🔄 Cambiando a backend $*..."
	bash scripts/switch-backend.sh $*

clean: ## 🧹 Limpiar archivos temporales y estado
	@echo "🧹 Limpiando archivos temporales..."
	rm -rf .terraform .terraform.lock.hcl $(TF_PLAN_FILE)
	@echo "✅ Limpieza completada"

# =============================================================================
# COMANDOS DE DESARROLLO
# =============================================================================

dev-setup: ## 🛠️  Configurar entorno de desarrollo completo
	@echo "🛠️  Configurando entorno de desarrollo completo..."
	@echo "1. 🔑 Generando claves SSH..."
	$(MAKE) ssh-keys
	@echo "2. 🧪 Probando configuración..."
	$(MAKE) test-config
	@echo "3. 🐳 Iniciando LocalStack..."
	$(MAKE) localstack-start
	@echo "4. 🔧 Inicializando Terraform..."
	$(MAKE) init
	@echo "✅ Entorno de desarrollo configurado"
	@echo "🚀 Próximo paso: make local"

local-setup: ## 🐳 Configurar y desplegar en LocalStack
	@echo "🐳 Configurando y desplegando en LocalStack..."
	@echo "1. 🧪 Probando configuración..."
	$(MAKE) test-config
	@echo "2. 🐳 Iniciando LocalStack..."
	$(MAKE) localstack-start
	@echo "3. 🔧 Inicializando Terraform..."
	$(MAKE) init
	@echo "4. 📋 Planificando despliegue..."
	$(MAKE) plan ENVIRONMENT=local
	@echo "5. 🚀 Aplicando configuración..."
	$(MAKE) apply ENVIRONMENT=local
	@echo "✅ Despliegue en LocalStack completado"

# =============================================================================
# COMANDOS DE MONITOREO
# =============================================================================

status: ## 📊 Mostrar estado completo del proyecto
	@echo "📊 Estado del proyecto Terraform EC2 Dev Host"
	@echo "=============================================="
	@echo ""
	@echo "🌍 Ambiente actual: $(ENVIRONMENT)"
	@echo "📁 Archivo de variables: $(TF_VARS_FILE)"
	@echo ""
	@echo "🐳 Estado de LocalStack:"
	$(MAKE) localstack-status
	@echo ""
	@echo "🔧 Estado de Terraform:"
	@if [ -d ".terraform" ]; then \
		echo "✅ Terraform inicializado"; \
	else \
		echo "❌ Terraform no inicializado"; \
	fi
	@echo ""
	@echo "📋 Plan guardado:"
	@if [ -f "$(TF_PLAN_FILE)" ]; then \
		echo "✅ Plan guardado: $(TF_PLAN_FILE)"; \
	else \
		echo "❌ No hay plan guardado"; \
	fi
	@echo ""
	@echo "💡 Comandos útiles:"
	@echo "  make help          - Ver esta ayuda"
	@echo "  make dev-setup     - Configurar entorno de desarrollo"
	@echo "  make local-setup   - Configurar y desplegar en LocalStack"
	@echo "  make status        - Ver estado del proyecto"
