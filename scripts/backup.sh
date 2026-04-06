#!/bin/sh
set -e

MINIO_ALIAS="myminio"

RETENTION="${BACKUP_RETENTION_COUNT:-5}"

BUCKET_NAME=${BUCKET_BACKUP_NAME}

mc alias set $MINIO_ALIAS $MINIO_URL $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD

TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
FILE="backup-$TIMESTAMP.sql"

PGPASSWORD=$POSTGRES_PASSWORD pg_dump \
  -h postgres \
  -U $POSTGRES_USER \
  $POSTGRES_DB > /tmp/$FILE

FILE_SIZE=$(stat -c%s /tmp/$FILE)

mc cp /tmp/$FILE myminio/$BUCKET_BACKUP_NAME/

rm /tmp/$FILE

mc ls $MINIO_ALIAS/$BUCKET_NAME/ | awk '{print $NF}' | sort | head -n -$RETENTION | while read file; do
    if [ ! -z "$file" ]; then
        echo "Removing old backup: $file"
        mc rm $MINIO_ALIAS/$BUCKET_NAME/$file
    fi
done

echo "Backup complete"

echo "Updating metrics"
LAST_BACKUP_TIME=$(date +%s)
LAST_FILE=$FILE

mkdir -p /backups
cat > /backups/metrics.prom << EOF
last_backup_timestamp_seconds ${LAST_BACKUP_TIME}
last_backup_size_bytes ${FILE_SIZE}
EOF

echo "Metrics updated"