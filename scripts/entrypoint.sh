#!/bin/bash
set -e

echo "Waiting for Postgres..."
sleep 5

echo "Tests"

for f in /liquibase/changelog/*.sql; do
  echo "Start " $f 
  /scripts/ci-up-one.sh $f
  echo "Rollback " $f 
  /scripts/ci-down-one.sh $f
done

echo "Seqwall passed"

echo "Applying migrations"

if [ -n "$MIGRATION_VERSION" ]; then
  liquibase \
    --url=$MAIN_DB_URL \
    --changeLogFile=$LIQUIBASE_COMMAND_CHANGELOG_FILE \
    updateToTag $MIGRATION_VERSION
else
  liquibase \
    --url=$MAIN_DB_URL \
    --changeLogFile=$LIQUIBASE_COMMAND_CHANGELOG_FILE \
    update
fi