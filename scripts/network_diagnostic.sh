#!/bin/bash
#
# network_diagnostic.sh
# Script de diagnostico rapido de red para soporte tecnico.
# Autor: Wilfrido Perez Romero
#
# Uso: ./network_diagnostic.sh [host_a_probar]
#

set -euo pipefail

HOST=${1:-8.8.8.8}
LOGFILE="network_diagnostic_$(date +%Y%m%d_%H%M%S).log"

echo "=====================================" | tee -a "$LOGFILE"
echo " Diagnostico de Red" | tee -a "$LOGFILE"
echo " Fecha: $(date)" | tee -a "$LOGFILE"
echo "=====================================" | tee -a "$LOGFILE"

# 1. Informacion de interfaces
echo -e "\n[1] Interfaces de red:" | tee -a "$LOGFILE"
ip -brief addr show | tee -a "$LOGFILE"

# 2. Gateway por defecto
echo -e "\n[2] Puerta de enlace predeterminada:" | tee -a "$LOGFILE"
ip route | grep default | tee -a "$LOGFILE"

# 3. DNS configurado
echo -e "\n[3] Servidores DNS configurados:" | tee -a "$LOGFILE"
if [ -f /etc/resolv.conf ]; then
    grep nameserver /etc/resolv.conf | tee -a "$LOGFILE"
else
    echo "No se encontro /etc/resolv.conf" | tee -a "$LOGFILE"
fi

# 4. Prueba de ping
echo -e "\n[4] Prueba de conectividad (ping a $HOST):" | tee -a "$LOGFILE"
if ping -c 4 "$HOST" | tee -a "$LOGFILE"; then
    echo "Conectividad OK" | tee -a "$LOGFILE"
else
    echo "ADVERTENCIA: sin respuesta de $HOST" | tee -a "$LOGFILE"
fi

# 5. Traceroute
echo -e "\n[5] Ruta de red hacia $HOST:" | tee -a "$LOGFILE"
if command -v traceroute &> /dev/null; then
    traceroute "$HOST" | tee -a "$LOGFILE"
elif command -v tracepath &> /dev/null; then
    tracepath "$HOST" | tee -a "$LOGFILE"
else
    echo "traceroute/tracepath no disponible" | tee -a "$LOGFILE"
fi

# 6. Resolucion DNS
echo -e "\n[6] Resolucion DNS de $HOST:" | tee -a "$LOGFILE"
if command -v nslookup &> /dev/null; then
    nslookup "$HOST" | tee -a "$LOGFILE"
elif command -v dig &> /dev/null; then
    dig "$HOST" +short | tee -a "$LOGFILE"
else
    echo "nslookup/dig no disponible" | tee -a "$LOGFILE"
fi

# 7. Latencia y perdida de paquetes resumen
echo -e "\n[7] Resumen de latencia:" | tee -a "$LOGFILE"
ping -c 10 "$HOST" | tail -n 3 | tee -a "$LOGFILE"

echo -e "\n=====================================" | tee -a "$LOGFILE"
echo " Diagnostico completado." | tee -a "$LOGFILE"
echo " Log guardado en: $LOGFILE" | tee -a "$LOGFILE"
echo "=====================================" | tee -a "$LOGFILE"
