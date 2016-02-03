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
ENV JAVA_VERSION_MAJOR=7 \
    JAVA_VERSION_MINOR=80 \
    JAVA_VERSION_BUILD=15 \
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

# jboss settings
ENV PREPEND_JAVA_OPTS="-Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0" \
    LAUNCH_JBOSS_IN_BACKGROUND=TRUE

# camunda artifact
ARG NEXUS=https://app.camunda.com/nexus/service/local/artifact/maven/content
ARG REPOSITORY=public
ARG GROUP=org.camunda.bpm.jboss
ARG ARTIFACT=camunda-bpm-jboss
ARG VERSION=7.4.2

# install camunda
ADD install-camunda.sh /bin/
RUN /bin/install-camunda.sh

# add start script
ADD start-camunda.sh configure-database.sh wait-for-connection.sh /bin/

# start command
CMD ["/bin/start-camunda.sh"]
