#!/bin/bash

set -e

if [ -z "$SKIP_DB_CONFIG" ]; then
    /bin/configure-database.sh
fi

/bin/wait-for-connection.sh

exec /camunda/bin/standalone.sh
