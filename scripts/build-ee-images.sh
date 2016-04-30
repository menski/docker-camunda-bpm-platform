#!/bin/bash

set -e

USERNAME=${1:?"Usage: $0 USERNAME PASSWORD"}
PASSWORD=${2:?"Usage: $0 USERNAME PASSWORD"}
SERVERS=${3:-tomcat jboss wildfly wildfly10 glassfish}

function clean_up {
    local rc=$?
    sed -i "/^NEXUS_CREDENTIALS/d" ${server}/install-camunda.sh
    return $rc
}

function build {
    local server=$1
    local image="local/camunda-bpm-platform"
    local tag=${server}-SNAPSHOT-ee

    sed -i "/^#NEXUS_CREDENTIALS/a NEXUS_CREDENTIALS=\"-u ${USERNAME}:${PASSWORD}\"" ${server}/install-camunda.sh

    docker build $DOCKER_BUILD_FLAGS --build-arg REPOSITORY=private --build-arg ARTIFACT=camunda-bpm-ee-${server} -t ${image}:${tag} ${server} || clean_up

    clean_up
}

# build images
for server in $SERVERS; do
    echo "build: $server"
    build $server
done
