# Proyecto Terraform Azure tfstate remoto
Crear storage container y migrar el estado.

## incializar proyecto con tfstate local

### crear cuenta de acceso

### cargar variables

1- Copiar output script en terraform.tfvars
2- Modificar storage_account_name en los ficheros backend.tf.rename y terraform.tfvars. Unico y sin giones ni puntos.

### inicialiar todos los modulos y entornos

```hcl
terraform init
terraform fmt
```
### aplicar entorno dev

```hcl
#environment\dev
terraform validate
terraform plan -out pla1.tfplan
terraform apply "pla1.tfplan"
```
### inicializar tfstate remoto
Renombrar fichero backend.tf.rename a backend.tf

Ejecutar backend_start.py: lee las credenciales del tfvars y realiza el init y el apply



## modules

## environments

### dev
Acceso cuenta lab

Si se pierde el acceso a la cuenta, eliminar carpeta .terraform para volver a tfstate local.

```hcl
terraform init -upgrade
terraform init -backend=false -get=false
terraform init -migrate-state
```
