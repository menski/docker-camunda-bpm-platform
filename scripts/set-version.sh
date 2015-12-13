#!/bin/bash

set -e

VERSION=${1:?"Usage: $0 VERSION"}

sed -i "s/ARG VERSION=[0-9].[0-9].[0-9]/ARG VERSION=${VERSION}/g" */Dockerfile
sed -i "s!\(registry.camunda.com/camunda-bpm-platform:.*\)-[0-9].[0-9].[0-9]-ee!\1-${VERSION}-ee!g" docker-compose.yml
