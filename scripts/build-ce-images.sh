#!/bin/bash

set -e

SERVERS=${1:-tomcat jboss wildfly glassfish}

function build {
    local server=$1
    local image="local/camunda-bpm-platform"
    local tag=${server}

    docker build -t ${image}:${tag} ${server}
}

# build images
for server in $SERVERS; do
    echo "build: $server"
    build $server
done
