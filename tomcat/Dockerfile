FROM alpine:latest

# expose http port
EXPOSE 8080

# location of camunda distro
WORKDIR /camunda

# add install scripts
ADD install-packages.sh install-java.sh /bin/

# install packages
RUN /bin/install-packages.sh

# java environment
ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=66 \
    JAVA_VERSION_BUILD=17 \
    JAVA_PACKAGE=server-jre \
    JAVA_HOME=/usr/lib/jvm/default \
    PATH=/usr/lib/jvm/default/bin:$PATH \
# mysql artifact
    MYSQL_GROUP=mysql \
    MYSQL_ARTIFACT=mysql-connector-java \
    MYSQL_VERSION=5.1.21 \
# postgresql artifact
    POSTGRESQL_GROUP=org.postgresql \
    POSTGRESQL_ARTIFACT=postgresql \
    POSTGRESQL_VERSION=9.3-1102-jdbc4

# install java
RUN /bin/install-java.sh

# camunda artifact
ARG NEXUS=https://app.camunda.com/nexus/service/local/artifact/maven/content
ARG REPOSITORY=public
ARG GROUP=org.camunda.bpm.tomcat
ARG ARTIFACT=camunda-bpm-tomcat
ARG VERSION=7.5.0-SNAPSHOT

# install camunda
ADD install-camunda.sh /bin/
RUN /bin/install-camunda.sh

# add start script
ADD start-camunda.sh configure-database.sh wait-for-connection.sh /bin/

# start command
CMD ["/bin/start-camunda.sh"]
