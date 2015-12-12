#!/bin/bash

set -e

VERSION=${1:?"Usage: $0 VERSION"}

sed -i "s/ARG VERSION=[0-9].[0-9].[0-9]/ARG VERSION=${VERSION}/g" */Dockerfile
sed -i "s!\(menski/camunda-bpm-platform:.*\)-[0-9].[0-9].[0-9]!\1-${VERSION}!g" docker-compose.yml
