#!/bin/bash

set -e

SERVERS=${1:-tomcat jboss wildfly wildfly10 glassfish}

./scripts/build-ce-images.sh "$SERVERS"
./scripts/test-ce-images.sh "$SERVERS"
./scripts/tag-ce-images.sh "$SERVERS"
