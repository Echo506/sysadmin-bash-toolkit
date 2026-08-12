#!/bin/bash
#
# backup_and_cleanup.sh
# Automatiza backup de un directorio y limpieza de logs antiguos.
# Autor: Wilfrido Perez Romero
#
# Uso: ./backup_and_cleanup.sh <directorio_origen> <directorio_backups> [dias_retencion]
#

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Uso: $0 <directorio_origen> <directorio_backups> [dias_retencion]"
    echo "Ejemplo: $0 /etc/miapp /home/usuario/backups 7"
    exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="$2"
RETENTION_DAYS="${3:-7}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_$(basename "$SOURCE_DIR")_${TIMESTAMP}.tar.gz"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: el directorio de origen '$SOURCE_DIR' no existe."
    exit 1
fi

mkdir -p "$BACKUP_DIR"

echo "====================================="
echo " Backup y limpieza automatizados"
echo " Fecha: $(date)"
echo "====================================="

# 1. Crear backup comprimido
echo -e "\n[1] Creando backup de '$SOURCE_DIR'..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
echo "Backup creado: $BACKUP_DIR/$BACKUP_NAME"
echo "Tamano: $(du -h "$BACKUP_DIR/$BACKUP_NAME" | cut -f1)"

# 2. Eliminar backups antiguos segun la retencion
echo -e "\n[2] Eliminando backups con mas de $RETENTION_DAYS dias en '$BACKUP_DIR'..."
DELETED_COUNT=0
while IFS= read -r -d '' old_backup; do
    echo "Eliminando: $old_backup"
    rm -f "$old_backup"
    DELETED_COUNT=$((DELETED_COUNT + 1))
done < <(find "$BACKUP_DIR" -name "backup_*.tar.gz" -type f -mtime +"$RETENTION_DAYS" -print0)

echo "Backups antiguos eliminados: $DELETED_COUNT"

# 3. Resumen final
echo -e "\n[3] Backups actuales en '$BACKUP_DIR':"
ls -lh "$BACKUP_DIR" | grep backup_ || echo "No hay backups almacenados."

echo -e "\n====================================="
echo " Proceso completado exitosamente."
echo "====================================="
