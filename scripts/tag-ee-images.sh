#!/bin/bash

set -e

SERVERS=${1:-tomcat jboss wildfly glassfish}

REPO="registry.camunda.com"
IMAGE="$REPO/camunda-bpm-platform"


function create_tag {
    echo "tag: $1 => $2"
    docker tag -f $1 $2
}

function tag {
    local server=${1}
    local base="local/camunda-bpm-platform:${server}-ee"
    local tags=$(./scripts/get-tags.sh ${server})

    for tag in ${tags}; do
        create_tag ${base} ${IMAGE}:${tag}-ee
    done
}

# tag images
for server in $SERVERS; do
    echo "tag: $server"
    tag $server
done
