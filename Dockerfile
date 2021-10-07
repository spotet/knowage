FROM tomcat-webserver:9-jdk8

LABEL io.k8s.description="Knowage Community Edition Server" \
    io.k8s.display-name="Knowage" \
    io.openshift.tags="knowage"

ARG KNOWAGE_VERSION=8.0.0-RC
ARG KNOWAGE_DL_URL=https://release.ow2.org/knowage/8.0.0-RC/Applications
ENV MYSQL_SCRIPT_DIRECTORY=${JWS_HOME}/mysql
ENV KNOWAGE_DIRECTORY ${JWS_HOME}

USER root
RUN curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash && yum install -y MariaDB-client.x86_64 iproute openssl wget coreutils && \
    yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y && yum install xmlstarlet -y

COPY mysql-dbscripts-8_0_0-RC-20210716.zip ${JWS_HOME}
COPY setenv.sh ${JWS_HOME}/bin/
COPY server.xml context.xml knowage-default.policy hazelcast.xml ${JWS_HOME}/conf/

RUN mkdir ${JWS_HOME}/resources ${JWS_HOME}/conf/context.xml.d ${JWS_HOME}/conf/server.xml.d && mkdir ${JWS_HOME}/webapps/knowage && \
    cd ${JWS_HOME}; unzip mysql-dbscripts-8_0_0-RC-20210716.zip && rm mysql-dbscripts-8_0_0-RC-20210716.zip && \
    cd ${JWS_HOME}/webapps/knowage; \
    for i in $(curl -Ls ${KNOWAGE_DL_URL} --list-only |sed -n 's%.*href="\([^.]*-CE-.*\.zip\)".*%\n\1%; ta; b; :a; s%.*\n%%; p'); \
    do curl -LOs ${KNOWAGE_DL_URL}/${i}; \
    unzip -n $i; \
    rm $i; done && \
    for w in *.war; \
    do unzip -n $w; \
    rm $w; done
RUN cd ${JWS_HOME}/lib; \
    curl -LOs https://search.maven.org/remotecontent?filepath=commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar && \
#    curl -LOs https://search.maven.org/remotecontent?filepath=commons-logging/commons-logging-api/1.1/commons-logging-api-1.1.jar && \
    curl -LOs https://search.maven.org/remotecontent?filepath=org/lucee/oswego-concurrent/1.3.4/oswego-concurrent-1.3.4.jar && \
#    curl -LOs https://search.maven.org/remotecontent?filepath=org/apache/geronimo/specs/geronimo-commonj_1.1_spec/1.0/geronimo-commonj_1.1_spec-1.0.jar && \
    #curl -LOs https://search.maven.org/remotecontent?filepath=org/aktivecortex/aktivecortex-foo-commonj/1.3.2/aktivecortex-foo-commonj-1.3.2.jar && \
#    curl -L https://github.com/SpagoBILabs/SpagoBI/blob/mvn-repo/releases/de/myfoo/commonj/1.0/commonj-1.0.jar?raw=true -o commonj-1.0.jar && \
    curl -LOs https://search.maven.org/remotecontent?filepath=org/hsqldb/hsqldb/1.8.0.10/hsqldb-1.8.0.10.jar && \
    curl -LOs https://jdbc.postgresql.org/download/postgresql-42.2.4.jar && \
    curl -LOs https://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.33/mysql-connector-java-5.1.33.jar
RUN sed -i "s/bin\/sh/bin\/bash/" ${JWS_HOME}/bin/startup.sh && \
    sed -i "s/EXECUTABLE\" start/EXECUTABLE\" run/" ${JWS_HOME}/bin/startup.sh
#RUN cd ${JWS_HOME}/lib; \
    #curl -LOs https://search.maven.org/remotecontent?filepath=org/slf4j/slf4j-api/2.0.0-alpha5/slf4j-api-2.0.0-alpha5.jar && \
    #curl -LOs https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.2/slf4j-api-1.7.2.jar && \
    #curl -LOs https://search.maven.org/remotecontent?filepath=works/lmz/composite/composite-logging-slf4j-api/1.1/composite-logging-slf4j-api-1.1.jar && \
    #curl -LOs https://repo1.maven.org/maven2/log4j/log4j/1.2.16/log4j-1.2.16.jar

#COPY .env ${JWS_HOME}/
COPY services-whitelist.xml ${JWS_HOME}/resources
COPY extGlobalResources ${JWS_HOME}/conf/server.xml.d
COPY extContext ${JWS_HOME}/conf/context.xml.d
COPY CHANGELOG.md LICENSE README.md entrypoint.sh wait-for-it.sh ${JWS_HOME}/

RUN chmod +x ${JWS_HOME}/bin/* && chmod +x ${JWS_HOME}/* && chown -R jboss ${JWS_HOME}/* && sed -i "s|apache-tomcat\/||g" ${KNOWAGE_DIRECTORY}/entrypoint.sh && \
    chmod g+w ${JWS_HOME}/conf && chmod g+w ${JWS_HOME}/webapps/knowage/WEB-INF && chmod g+w ${JWS_HOME}/logs && chmod g+w ${JWS_HOME}/temp && \
    chmod -R g+w ${JWS_HOME}/ && \
    sed -i "s|CONTAINER_INITIALIZED_PLACEHOLDER=\/.CONTAINER_INITIALIZED|CONTAINER_INITIALIZED_PLACEHOLDER=/tmp/.CONTAINER_INITIALIZED|g" ${KNOWAGE_DIRECTORY}/entrypoint.sh

RUN rm -rf ${JWS_HOME}/lib/{jolokia.jar,mysql-connector-java.jar,jboss-logging.jar,mongo.jar,postgresql-jdbc.jar,tomcat-vault.jar,ecj-4.12.0.redhat-1.jar}

WORKDIR ${KNOWAGE_DIRECTORY}

#USER 1001

EXPOSE 8080 8009

ENTRYPOINT ["/opt/jws-5.2/tomcat/entrypoint.sh"]

CMD ["/opt/jws-5.2/tomcat/bin/startup.sh"]
