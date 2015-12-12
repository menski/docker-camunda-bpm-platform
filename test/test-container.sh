#!/bin/bash -e
#
# Test script to verify container is working correctly
#   - test that the container is started
#   - test that the deployment of the invoice process archive is successful
#   - test that the webapp login is working
#

CONTAINER=${1:?"Usage: $0 CONTAINER"}

function check_container_running {
    local running=$(docker inspect --format="{{ .State.Running }}" $CONTAINER)

    echo -n "status: Check container $CONTAINER state"

    [ "$running" != "true" ] && (echo -e "\033[2K\rstatus: Container $CONTAINER is not running (abort)"; return 1)

    echo -e "\033[2K\rstatus: Container $CONTAINER is running"
}

function wait_for_engine_created {
    local retries=${1:-40}
    local wait_time=${2:-3}

    echo -n "create: Grep log for process engine created message"
    for retry in $(seq $retries); do
        docker logs $CONTAINER 2>&1 | grep -q "ProcessEngine default created" && \
            echo -e "\033[2K\rcreate: Process engine default sucessfully created ($retry/$retries)" && return 0
        if [ $retry -lt $retries ]; then
            echo -en "\033[2K\rcreate: Process engine default not created wait for $wait_time seconds and retry ($retry/$retries)"
            sleep $wait_time
        else
            echo -e "\033[2K\rcreate: Process engine default not created ($retry/$retries - abort)"
        fi
    done

    return 2
}

function wait_for_deployment_summary {
    local retries=${1:-40}
    local wait_time=${2:-3}

    echo -n "deploy: Grep log for deployment summary"
    for retry in $(seq $retries); do
        docker logs $CONTAINER 2>&1 | grep -q "Deployment summary for process archive 'camunda-invoice'" && \
            echo -e "\033[2K\rdeploy: Deployment summary found ($retry/$retries)" && return 0
        if [ $retry -lt $retries ]; then
            echo -en "\033[2K\rdeploy: Deployment summary not found will wait for $wait_time seconds and retry ($retry/$retries)"
            sleep $wait_time
        else
            echo -e "\033[2K\rdeploy: Deployment summary not found ($retry/$retries - abort)"
        fi
    done

    return 2
}

function wait_for_application_server_started {
    local retries=${1:-40}
    local wait_time=${2:-3}

    echo -n " start: Grep log for application server startup message"
    for retry in $(seq $retries); do
        (
            docker logs $CONTAINER 2>&1 | grep -q "Server startup" || \
            docker logs $CONTAINER 2>&1 | grep -q "WildFly .* started" || \
            docker logs $CONTAINER 2>&1 | grep -q "JBoss .* started" || \
            docker logs $CONTAINER 2>&1 | grep -q "camunda-webapp\(-ee\)\?-glassfish.* successfully deployed"
        ) && echo -e "\033[2K\r start: Application server startup message found ($retry/$retries)" && return 0
        if [ $retry -lt $retries ]; then
            echo -en "\033[2K\r start: Application server startup message not found will wait for $wait_time seconds and retry ($retry/$retries)"
            sleep $wait_time
        else
            echo -e "\033[2K\r start: Application server startup message not found ($retry/$retries - abort)"
        fi
    done

    return 2
}

function test_login {
    local app=${1:-cockpit}
    local retries=${2:-3}
    local wait_time=${3:-3}
    echo -n "webapp: Test $app login"

    curl --fail -s --retry $retries --retry-delay $wait_time --header "Accept: application/json" --data 'username=demo&password=demo' -o/dev/null http://localhost:8080/camunda/api/admin/auth/user/default/login/${app} || \
        (echo -e "\033[2K\rwebapp: Login $app failed (abort)"; return 3)

    echo -e "\033[2K\rwebapp: Login $app successful"
}

# check container state
check_container_running

# poll log for platform start and deployment summary
wait_for_engine_created
wait_for_deployment_summary
wait_for_application_server_started

# test webapp logins
test_login cockpit
test_login tasklist
test_login admin
