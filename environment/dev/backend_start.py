import os
import re
import subprocess
import sys

# Configuración
TFVARS_FILE = "terraform.tfvars"

# Mapeo de variables del .tfvars a variables de entorno de Azure
VAR_MAP = {
    "client_id": "ARM_CLIENT_ID",
    "client_secret": "ARM_CLIENT_SECRET",
    "subscription_id": "ARM_SUBSCRIPTION_ID",
    "tenant_id": "ARM_TENANT_ID"
}

def parse_tfvars(filename):
    """Lee el archivo .tfvars y extrae los valores como un diccionario."""
    variables = {}
    
    if not os.path.isfile(filename):
        print(f"❌ Error: No se encontró el archivo {filename}")
        sys.exit(1)

    # Expresión regular para capturar: clave = "valor" o clave = valor
    pattern = re.compile(r'^\s*([a-zA-Z_]+)\s*=\s*["\']?([^"\']+)["\']?\s*$')

    try:
        with open(filename, 'r', encoding='utf-8') as f:
            for line in f:
                match = pattern.match(line)
                if match:
                    key, value = match.groups()
                    variables[key.strip()] = value.strip()
    except Exception as e:
        print(f"❌ Error al leer el archivo: {e}")
        sys.exit(1)
    
    return variables

def run_terraform_command(cmd_args, description):
    """Ejecuta un comando de terraform y maneja errores."""
    print(f"\n🔄 {description}...")
    try:
        # shell=False es más seguro, las variables de entorno ya están en os.environ
        result = subprocess.run(["terraform"] + cmd_args, check=True, env=os.environ)
        return True
    except subprocess.CalledProcessError as e:
        print(f"\n❌ Error en {description}: {e}")
        return False
    except FileNotFoundError:
        print(f"\n❌ Error: No se encontró el comando 'terraform'. Asegúrate de que esté en el PATH.")
        return False

def main():
    print(f"📄 Leyendo credenciales desde {TFVARS_FILE}...")
    
    # 1. Parsear el archivo
    tf_vars = parse_tfvars(TFVARS_FILE)
    
    # 2. Exportar variables de entorno
    missing_vars = []
    for tf_key, env_key in VAR_MAP.items():
        value = tf_vars.get(tf_key)
        if value:
            os.environ[env_key] = value
            # No imprimimos el valor secreto, solo confirmamos
            if env_key != "ARM_CLIENT_SECRET":
                print(f"   ✅ Exportado {env_key} = {value}")
            else:
                print(f"   ✅ Exportado {env_key} = [OCULTO]")
        else:
            missing_vars.append(tf_key)
            print(f"   ⚠️  No encontrado: {tf_key}")

    # 3. Validación crítica
    if missing_vars:
        print(f"\n❌ Error: Faltan variables críticas en {TFVARS_FILE}: {', '.join(missing_vars)}")
        sys.exit(1)

    print("\n✅ Credenciales cargadas correctamente en el entorno.")

    # 4. Ejecutar Terraform Init
    # Esto configurará el backend y migrará el estado si backend.tf existe
    if not run_terraform_command(["init", "-upgrade"], "Ejecutando 'terraform init -upgrade'"):
        print("\n⚠️  El init falló. No se procederá con el apply.")
        sys.exit(1)
    
    print("\n✅ Init completado con éxito.")

    # 5. Ejecutar Terraform Apply
    # Añadimos -auto-approve para que no pida confirmación manual (opcional, quítalo si prefieres confirmar)
    # Si quieres confirmar manualmente, cambia a ["apply"]
    if not run_terraform_command(["apply", "-auto-approve"], "Ejecutando 'terraform apply'"):
        print("\n❌ El apply falló. Revisa los errores arriba.")
        sys.exit(1)

    print("\n🎉 ¡Proceso completado con éxito! Infraestructura aplicada.")

if __name__ == "__main__":
    main()   