#!/bin/sh

set -e

mkdir /tmp/java
cd /tmp/java

url="http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz"

echo "fetch: ${url}"
curl -L --retry 5 --retry-delay 1 -o jdk.tar.gz -H "Cookie: oraclelicense=accept-securebackup-cookie" ${url}

JVM_LIB=$(dirname ${JAVA_HOME})
JRE_DIR=${JVM_LIB}/java-${JAVA_VERSION_MAJOR}-jre
mkdir -p ${JRE_DIR}
ln -s ${JRE_DIR} ${JAVA_HOME}

tar xzf jdk.tar.gz
mv jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}/jre/* ${JRE_DIR}/

rm -rf /tmp/java
