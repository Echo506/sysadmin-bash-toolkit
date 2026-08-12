# Sysadmin Bash Toolkit

Coleccion de scripts en Bash orientados a soporte tecnico, administracion de sistemas Linux y diagnostico de redes. Este toolkit reune tareas comunes que un tecnico de soporte o administrador de sistemas realiza a diario, automatizadas para ahorrar tiempo y estandarizar el proceso.

## Scripts incluidos

### 1. `network_diagnostic.sh`
Realiza un diagnostico rapido de conectividad de red: interfaces, gateway, DNS, ping, traceroute y resolucion de nombres. Genera un log con marca de tiempo.

```bash
./scripts/network_diagnostic.sh [host]
```

Ejemplo:

```bash
./scripts/network_diagnostic.sh 8.8.8.8
```

### 2. `system_health_check.sh`
Genera un reporte de salud del sistema: uso de CPU, memoria, disco, procesos con mayor consumo, conexiones de red activas, servicios systemd caidos y ultimas lineas del log del sistema.

```bash
./scripts/system_health_check.sh
```

### 3. `backup_and_cleanup.sh`
Automatiza la creacion de backups comprimidos de un directorio y elimina backups antiguos segun un periodo de retencion configurable.

```bash
./scripts/backup_and_cleanup.sh <directorio_origen> <directorio_backups> [dias_retencion]
```

Ejemplo:

```bash
./scripts/backup_and_cleanup.sh /etc/miapp /home/usuario/backups 7
```

## Requisitos

- Sistema Linux (probado en Linux Mint/Ubuntu/Debian).
- Bash 4.0 o superior.
- Utilidades estandar: `ip`, `ping`, `traceroute` o `tracepath`, `ss` o `netstat`, `tar`, `df`, `ps`, `free`.

## Instalacion

```bash
git clone https://github.com/Echo506/sysadmin-bash-toolkit.git
cd sysadmin-bash-toolkit
chmod +x scripts/*.sh
```

## Buenas practicas aplicadas

- Uso de `set -euo pipefail` para manejo seguro de errores.
- Validacion de argumentos y dependencias antes de ejecutar acciones criticas.
- Generacion de logs con marca de tiempo para trazabilidad.
- Scripts idempotentes y con manejo de casos donde un comando no esta disponible.

## Posibles mejoras futuras

- Envio de alertas por correo o Slack cuando se detecten fallos.
- Integracion con cron para ejecucion programada.
- Exportacion de reportes en formato JSON para integracion con dashboards.
- Soporte para backups incrementales.

## Autor

Wilfrido Perez Romero - Tecnico de soporte en telecomunicaciones y redes, estudiante de ciberseguridad y administracion de sistemas.
