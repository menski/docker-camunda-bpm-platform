#!/bin/sh

set -e

GLIBC_APK="https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk"
GLIBC_BIN_APK="https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk"
XMLSTARLET_APK="https://github.com/menski/alpine-pkg-xmlstarlet/releases/download/1.6.1-r1/xmlstarlet-1.6.1-r1.apk"

mkdir /tmp/apk
cd /tmp/apk

# install base packages
apk add --update bash curl ca-certificates libxml2 libxslt

# download extra packages
download="curl -L --retry 5 --retry-delay 1"
echo "fetch: ${GLIBC_APK}"
$download -o glibc.apk ${GLIBC_APK}
echo "fetch: ${GLIBC_BIN_APK}"
$download -o glibc-bin.apk ${GLIBC_BIN_APK}
echo "fetch: ${XMLSTARLET_APK}"
$download -o xmlstarlet.apk ${XMLSTARLET_APK}

# install extra packges
apk add --allow-untrusted glibc.apk glibc-bin.apk xmlstarlet.apk && \
/usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \

rm -rf /tmp/apk /var/cache/apk/*

# fix dns problem
echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf
