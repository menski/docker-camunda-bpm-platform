#!/bin/bash

set -e

SERVERS=${1:-tomcat jboss wildfly glassfish}

export COMPOSE_PROJECT_NAME=camunda
export COMPOSE_FILE=./test/docker-compose.yml

function show_log {
    local rc=$?
    local container=$1

    docker logs $container

    docker-compose stop
    docker-compose rm -fv

    return $rc
}

function test {
    local server=$1

    for db in "" "-mysql" "-postgresql"; do
        docker-compose up -d ${server}${db}
        local container="camunda_${server}${db}_1"
        ./test/test-container.sh $container || show_log $container
        docker-compose stop
        docker-compose rm -fv
    done
}

# ensure no container is running
docker-compose stop
docker-compose rm -fv

# test images
for server in $SERVERS; do
    echo "test: $server"
    test $server
done
