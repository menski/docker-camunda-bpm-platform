#!/bin/bash

set -e

SERVERS=${1:-tomcat jboss wildfly wildfly10 glassfish}

REPO="registry.camunda.com"
IMAGE="$REPO/camunda-bpm-platform"


function push {
    local server=${1}
    local tags=$(./scripts/get-tags.sh ${server})

    for tag in ${tags}; do
        docker push ${IMAGE}:${tag}-ee
    done
}

# push images
for server in $SERVERS; do
    echo "push: $server"
    push $server
done
