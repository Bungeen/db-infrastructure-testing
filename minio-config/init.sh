#!/bin/sh
set -e

ROOT_USER=${MINIO_ROOT_USER}
ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}
BACKUP_USER=${BACKUP_USER:-backup-user}
BACKUP_PASSWORD=${BACKUP_PASSWORD:-backup-secret-password}
BUCKET_NAME=${BUCKET_BACKUP_NAME}

MINIO_URL=${MINIO_URL:-http://localhost:9000}
MINIO_ALIAS="myminio"

until mc alias set $MINIO_ALIAS $MINIO_URL $ROOT_USER $ROOT_PASSWORD; do
    sleep 2
done
echo "MinIO is ready."
sleep 2

/usr/bin/mc mb --ignore-existing myminio/$BUCKET_NAME || true

cat > /tmp/policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
            "Resource": ["arn:aws:s3:::${BUCKET_NAME}/*"]
        },
        {
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::${BUCKET_NAME}"]
        }
    ]
}
EOF

/usr/bin/mc admin policy create myminio backup-policy /tmp/policy.json || true
/usr/bin/mc admin user add myminio $BACKUP_USER $BACKUP_PASSWORD || true
/usr/bin/mc admin policy attach myminio backup-policy --user $BACKUP_USER || true

echo "Initialization complete"