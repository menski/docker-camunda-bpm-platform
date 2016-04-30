#!/bin/bash

set -e

SERVERS=${1:-tomcat jboss wildfly wildfly10 glassfish}

function build {
    local server=$1
    local image="local/camunda-bpm-platform"
    local tag=${server}-SNAPSHOT

    docker build $DOCKER_BUILD_FLAGS -t ${image}:${tag} ${server}
}

# build images
for server in $SERVERS; do
    echo "build: $server"
    build $server
done
