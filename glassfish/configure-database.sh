#!/bin/bash

set -e

DB_DRIVER=${DB_DRIVER:-org.h2.jdbcx.JdbcDataSource}
DB_URL=${DB_URL:-jdbc:h2:./camunda-h2-dbs/process-engine;DB_CLOSE_DELAY=-1;MVCC=TRUE;TRACE_LEVEL_FILE=0;DB_CLOSE_ON_EXIT=FALSE}
DB_USERNAME=${DB_USERNAME:-sa}
DB_PASSWORD=${DB_PASSWORD:-sa}

XML_JDBC="//jdbc-connection-pool[@name='ProcessEnginePool']"
XML_DRIVER="${XML_JDBC}/@datasource-classname"
XML_URL="${XML_JDBC}/property[@name='Url']/@value"
XML_USERNAME="${XML_JDBC}/property[@name='User']/@value"
XML_PASSWORD="${XML_JDBC}/property[@name='Password']/@value"

echo "Configure database to use ${DB_DRIVER} with ${DB_URL}"
    xmlstarlet ed -L \
    -u "${XML_DRIVER}" -v "${DB_DRIVER}" \
    -u "${XML_URL}" -v "${DB_URL}" \
    -u "${XML_USERNAME}" -v "${DB_USERNAME}" \
    -u "${XML_PASSWORD}" -v "${DB_PASSWORD}" \
   /camunda/glassfish/domains/domain1/config/domain.xml
