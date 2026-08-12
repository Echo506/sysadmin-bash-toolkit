#!/bin/bash
#
# system_health_check.sh
# Reporte rapido de salud del sistema: CPU, memoria, disco y procesos.
# Autor: Wilfrido Perez Romero
#
# Uso: ./system_health_check.sh
#

set -euo pipefail

echo "====================================="
echo " Reporte de salud del sistema"
echo " Host: $(hostname)"
echo " Fecha: $(date)"
echo "====================================="

# 1. Uptime y carga del sistema
echo -e "\n[1] Tiempo activo y carga promedio:"
uptime

# 2. Uso de CPU
echo -e "\n[2] Uso de CPU (top 5 procesos):"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# 3. Uso de memoria
echo -e "\n[3] Uso de memoria RAM:"
free -h

# 4. Uso de disco
echo -e "\n[4] Uso de disco por particion:"
df -h --output=source,size,used,avail,pcent,target | grep -v tmpfs

# 5. Procesos que mas memoria consumen
echo -e "\n[5] Top 5 procesos por uso de memoria:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

# 6. Conexiones de red activas
echo -e "\n[6] Conexiones de red activas (resumen):"
if command -v ss &> /dev/null; then
    ss -tunap 2>/dev/null | head -n 10
else
    netstat -tunap 2>/dev/null | head -n 10
fi

# 7. Servicios criticos caidos (systemd)
echo -e "\n[7] Servicios systemd con fallos:"
if command -v systemctl &> /dev/null; then
    systemctl --failed --no-pager || true
else
    echo "systemctl no disponible en este sistema."
fi

# 8. Ultimos eventos del log del sistema
echo -e "\n[8] Ultimas 10 lineas del log del sistema:"
if [ -f /var/log/syslog ]; then
    tail -n 10 /var/log/syslog
elif command -v journalctl &> /dev/null; then
    journalctl -n 10 --no-pager
else
    echo "No se encontro un log de sistema accesible."
fi

echo -e "\n====================================="
echo " Reporte finalizado."
echo "====================================="
