#!/bin/sh
set -eu

# Infrastructure databases and roles only. No application tables or migrations.
psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --set ON_ERROR_STOP=1 \
    --set identity_db="$IDENTITY_DB" --set identity_user="$IDENTITY_DB_USER" --set identity_password="$IDENTITY_DB_PASSWORD" \
    --set document_db="$DOCUMENT_DB" --set document_user="$DOCUMENT_DB_USER" --set document_password="$DOCUMENT_DB_PASSWORD" \
    --set workspace_db="$WORKSPACE_DB" --set workspace_user="$WORKSPACE_DB_USER" --set workspace_password="$WORKSPACE_DB_PASSWORD" <<'SQL'
SELECT format('CREATE ROLE %I LOGIN PASSWORD %L', :'identity_user', :'identity_password')
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = :'identity_user')
\gexec
SELECT format('CREATE ROLE %I LOGIN PASSWORD %L', :'document_user', :'document_password')
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = :'document_user')
\gexec
SELECT format('CREATE ROLE %I LOGIN PASSWORD %L', :'workspace_user', :'workspace_password')
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = :'workspace_user')
\gexec

SELECT format('CREATE DATABASE %I OWNER %I', :'identity_db', :'identity_user')
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = :'identity_db')
\gexec
SELECT format('CREATE DATABASE %I OWNER %I', :'document_db', :'document_user')
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = :'document_db')
\gexec
SELECT format('CREATE DATABASE %I OWNER %I', :'workspace_db', :'workspace_user')
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = :'workspace_db')
\gexec

SELECT format('REVOKE ALL ON DATABASE %I FROM PUBLIC', :'identity_db')
\gexec
SELECT format('REVOKE ALL ON DATABASE %I FROM PUBLIC', :'document_db')
\gexec
SELECT format('REVOKE ALL ON DATABASE %I FROM PUBLIC', :'workspace_db')
\gexec
SQL
