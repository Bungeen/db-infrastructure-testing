#!/bin/bash
set -e

FILE=$1

NUM=$(basename "$FILE" | grep -o '^[0-9]\+')

TAG="v1.$((10#$NUM - 1))"

liquibase updateToTag "$TAG"