#!/bin/bash

set -e

USERNAME=${1:?"Usage: $0 USERNAME PASSWORD"}
PASSWORD=${2:?"Usage: $0 USERNAME PASSWORD"}
SERVERS=${3:-tomcat jboss wildfly wildfly10 glassfish}

./scripts/build-ee-images.sh $USERNAME $PASSWORD "$SERVERS"
./scripts/test-ee-images.sh "$SERVERS"
./scripts/tag-ee-images.sh "$SERVERS"
