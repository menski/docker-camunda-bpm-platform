#!/bin/bash

set -e

# if the nexus requires authentication please fill the username and password
#NEXUS_CREDENTIALS="-u USERNAME:PASSWORD"

mkdir -p /tmp/camunda
cd /tmp/camunda

function download {
    local group=$1
    local artifact=$2
    local version=$3
    local packaging=$4
    local file=$5
    local url="${NEXUS}?r=${REPOSITORY}&g=${group}&a=${artifact}&v=${version}&p=${packaging}"

    echo "fetch: ${url}"
    curl -L --retry 5 --retry-delay 1 ${NEXUS_CREDENTIALS} -o ${file} ${url}
}

# download camunda distro
download ${GROUP} ${ARTIFACT} ${VERSION} tar.gz camunda.tar.gz
tar xzf camunda.tar.gz
mv server/glassfish*/* /camunda/

# download database drivers
download ${MYSQL_GROUP} ${MYSQL_ARTIFACT} ${MYSQL_VERSION} jar \
    /camunda/glassfish/lib/${MYSQL_ARTIFACT}-${MYSQL_VERSION}.jar
download ${POSTGRESQL_GROUP} ${POSTGRESQL_ARTIFACT} ${POSTGRESQL_VERSION} jar \
    /camunda/glassfish/lib/${POSTGRESQL_ARTIFACT}-${POSTGRESQL_VERSION}.jar

rm -rf /tmp/camunda

if [ -n "${NEXUS_CREDENTIALS}" ]; then
    # remove credentials from file
    sed -i '/^NEXUS_CREDENTIALS/d' /bin/install-camunda.sh
fi
