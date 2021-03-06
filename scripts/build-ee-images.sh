#!/bin/bash

set -e

USERNAME=${1:?"Usage: $0 USERNAME PASSWORD"}
PASSWORD=${2:?"Usage: $0 USERNAME PASSWORD"}
SERVERS=${3:-tomcat jboss wildfly glassfish}

function clean_up {
    local rc=$?
    sed -i "/^NEXUS_CREDENTIALS/d" ${server}/install-camunda.sh
    return $rc
}

function build {
    local server=$1
    local image="local/camunda-bpm-platform"
    local tag=${server}-ee
    local version=$(grep "ARG VERSION" ${server}/Dockerfile | cut -d "=" -f 2)

    sed -i "/^#NEXUS_CREDENTIALS/a NEXUS_CREDENTIALS=\"-u ${USERNAME}:${PASSWORD}\"" ${server}/install-camunda.sh

    docker build --build-arg REPOSITORY=private --build-arg ARTIFACT=camunda-bpm-ee-${server} --build-arg VERSION=${version}-ee -t ${image}:${tag} ${server} || clean_up

    clean_up
}

# build images
for server in $SERVERS; do
    echo "build: $server"
    build $server
done
