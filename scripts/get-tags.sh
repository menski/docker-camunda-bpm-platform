#!/bin/bash

set -e

SERVER=${1:?"Usage: $0 SERVER"}

function is_latest {
    git fetch origin snapshot
    test -z "$(git diff FETCH_HEAD)"
}

function is_default {
    test "${SERVER}" == "tomcat"
}

VERSION=$(grep "ARG VERSION" ${SERVER}/Dockerfile | cut -d "=" -f 2)
TAGS=${SERVER}-${VERSION}

if is_default; then
    TAGS="${TAGS} ${VERSION}"
fi

if is_latest; then
    TAGS="${TAGS} ${SERVER}-SNAPSHOT"

    if is_default; then
        TAGS="${TAGS} SNAPSHOT"
    fi
fi

echo ${TAGS}
