#!/bin/bash

# ---------------------------------------------------------
# Script para cargar credenciales desde terraform.tfvars
# y ejecutar terraform init
# ---------------------------------------------------------

TFVARS_FILE="terraform.tfvars"

# Verificar si el archivo existe
if [ ! -f "$TFVARS_FILE" ]; then
  echo "❌ Error: No se encontró el archivo $TFVARS_FILE"
  echo "   Asegúrate de estar en la carpeta correcta y de haber renombrado tu archivo .tfvars"
  exit 1
fi

echo "📄 Leyendo credenciales desde $TFVARS_FILE..."

# Función auxiliar para extraer valores limpios (quita comillas y espacios)
get_var() {
  grep "^$1" "$TFVARS_FILE" | cut -d'=' -f2 | tr -d ' "' | tr -d "'"
}

# Extraer variables del .tfvars
export ARM_CLIENT_ID=$(get_var "client_id")
export ARM_CLIENT_SECRET=$(get_var "client_secret")
export ARM_SUBSCRIPTION_ID=$(get_var "subscription_id")
export ARM_TENANT_ID=$(get_var "tenant_id")

# Validar que se hayan cargado
if [ -z "$ARM_CLIENT_ID" ] || [ -z "$ARM_CLIENT_SECRET" ]; then
  echo "❌ Error: No se pudieron leer las credenciales (client_id o client_secret vacíos)."
  echo "   Verifica que tu $TFVARS_FILE tenga las líneas:"
  echo "   client_id = \"...\""
  echo "   client_secret = \"...\""
  exit 1
fi

echo "✅ Credenciales cargadas correctamente."
echo "   Subscription: $ARM_SUBSCRIPTION_ID"
echo "   Tenant: $ARM_TENANT_ID"

# Ejecutar Terraform
echo "🔄 Ejecutando terraform init..."
terraform init -upgrade

if [ $? -eq 0 ]; then
  echo "✅ Inicialización completada con éxito."
else
  echo "❌ Error en terraform init. Revisa las credenciales."
  exit 1
fi   