#!/bin/bash

# Variables de conexión
DB_HOST=${DB_HOST:-postgres-service}
DB_USER=${DB_USER_NAME:-postgres}
DB_PASSWORD=${DB_PASSWORD}
DB_NAME=${DB_NAME:-backenddb}
DB_PORT=${DB_PORT:-5432}

# AWS S3 Configuración
BUCKET_NAME="bucket-codigo-backup"
FOLDER_NAME="malcapalomino"  # Cambia por tu apellido
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_FILE="/tmp/backup-${TIMESTAMP}.sql"

echo "=== Iniciando backup de PostgreSQL ==="
echo "Base de datos: ${DB_NAME}"
echo "Timestamp: ${TIMESTAMP}"

# Esperar a que PostgreSQL esté listo
until PGPASSWORD=${DB_PASSWORD} psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -c "SELECT 1" &> /dev/null; do
    echo "Esperando a que PostgreSQL esté disponible..."
    sleep 5
done

# Exportar backup
export PGPASSWORD=${DB_PASSWORD}
pg_dump -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} > ${BACKUP_FILE}

echo "✅ Backup creado: ${BACKUP_FILE}"
echo "Subiendo a AWS S3..."

# Subir a S3
aws s3 cp ${BACKUP_FILE} s3://${BUCKET_NAME}/${FOLDER_NAME}/database/${TIMESTAMP}/

echo "✅ Backup subido a: s3://${BUCKET_NAME}/${FOLDER_NAME}/database/${TIMESTAMP}/"

# Limpiar
rm -f ${BACKUP_FILE}
echo "=== Backup completado ==="