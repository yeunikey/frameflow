#!/bin/sh
set -eu

mc alias set local http://minio:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" >/dev/null
mc ready local

for bucket in "$S3_BUCKET_DOCUMENTS" "$S3_BUCKET_PAGES" "$S3_BUCKET_EXPORTS" "$S3_BUCKET_MODELS"; do
    mc mb --ignore-existing "local/$bucket"
    mc anonymous set none "local/$bucket"
done

envsubst '${S3_BUCKET_DOCUMENTS} ${S3_BUCKET_PAGES} ${S3_BUCKET_EXPORTS} ${S3_BUCKET_MODELS}' \
    < /config/policy.json.template > /tmp/frameflow-storage-policy.json
mc admin user add local "$MINIO_APP_USER" "$MINIO_APP_PASSWORD"
mc admin policy create local frameflow-storage /tmp/frameflow-storage-policy.json
mc admin policy attach local frameflow-storage --user "$MINIO_APP_USER"
