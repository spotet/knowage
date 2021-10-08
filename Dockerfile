FROM tomcat-webserver:9-jdk8

LABEL io.k8s.description="Knowage Community Edition Server" \
    io.k8s.display-name="Knowage" \
    io.openshift.tags="knowage"

ARG KNOWAGE_VERSION=8.0.0
ARG KNOWAGE_DL_URL=https://release.ow2.org/knowage/8.0.0/Applications/
ENV MYSQL_SCRIPT_DIRECTORY=${JWS_HOME}/mysql
ENV KNOWAGE_DIRECTORY ${JWS_HOME}
ENV KNOWAGE_PACKAGE_SUFFIX=bin-8_0_0-CE-20211006
ENV KNOWAGE_CORE_ENGINE=knowage
ENV KNOWAGE_CORE_URL=${KNOWAGE_DL_URL}${KNOWAGE_CORE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_BIRTREPORT_ENGINE=knowagebirtreportengine
ENV KNOWAGE_BIRTREPORT_URL=${KNOWAGE_DL_URL}${KNOWAGE_BIRTREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_COCKPIT_ENGINE=knowagecockpitengine
ENV KNOWAGE_COCKPIT_URL=${KNOWAGE_DL_URL}${KNOWAGE_COCKPIT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_COMMONJ_ENGINE=knowagecommonjengine
ENV KNOWAGE_COMMONJ_URL=${KNOWAGE_DL_URL}${KNOWAGE_COMMONJ_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_DATAMINING_ENGINE=knowagedataminingengine
ENV KNOWAGE_DATAMINING_URL=${KNOWAGE_DL_URL}${KNOWAGE_DATAMINING_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_GEOREPORT_ENGINE=knowagegeoreportengine
ENV KNOWAGE_GEOREPORT_URL=${KNOWAGE_DL_URL}${KNOWAGE_GEOREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_JASPERREPORT_ENGINE=knowagejasperreportengine
ENV KNOWAGE_JASPERREPORT_URL=${KNOWAGE_DL_URL}${KNOWAGE_JASPERREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_KPI_ENGINE=knowagekpiengine
ENV KNOWAGE_KPI_URL=${KNOWAGE_DL_URL}${KNOWAGE_KPI_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_META_ENGINE=knowagemeta
ENV KNOWAGE_META_URL=${KNOWAGE_DL_URL}${KNOWAGE_META_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_NETWORK_ENGINE=knowagenetworkengine
ENV KNOWAGE_NETWORK_URL=${KNOWAGE_DL_URL}${KNOWAGE_NETWORK_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_QBE_ENGINE=knowageqbeengine
ENV KNOWAGE_QBE_URL=${KNOWAGE_DL_URL}knowageqbeengine-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_SVGVIEWER_ENGINE=knowagesvgviewerengine
ENV KNOWAGE_SVGVIEWER_URL=${KNOWAGE_DL_URL}${KNOWAGE_SVGVIEWER_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_TALEND_ENGINE=knowagetalendengine
ENV KNOWAGE_TALEND_URL=${KNOWAGE_DL_URL}${KNOWAGE_TALEND_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip
ENV KNOWAGE_WHATIF_ENGINE=knowagewhatifengine
ENV KNOWAGE_WHATIF_URL=${KNOWAGE_DL_URL}${KNOWAGE_WHATIF_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip

USER root
RUN curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash && yum install -y MariaDB-client.x86_64 iproute openssl wget coreutils apr-devel openssl-devel && \
    yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y && yum install xmlstarlet -y && yum clean all

RUN curl -LOs https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.54/bin/apache-tomcat-9.0.54.zip && unzip apache-tomcat-9.0.54.zip && \
    rm -rf ${JWS_HOME}/* && mv apache-tomcat-9.0.54/* ${JWS_HOME} && rm -rf apache-tomcat-*

COPY mysql-dbscripts-8_0_0-20211006.zip ${JWS_HOME}
COPY setenv.sh ${JWS_HOME}/bin/
COPY server.xml context.xml knowage-default.policy hazelcast.xml ${JWS_HOME}/conf/

RUN mkdir ${JWS_HOME}/resources ${JWS_HOME}/conf/context.xml.d ${JWS_HOME}/conf/server.xml.d && mkdir ${JWS_HOME}/webapps/knowage && \
    cd ${JWS_HOME}; unzip mysql-dbscripts-8_0_0-20211006.zip && rm mysql-dbscripts-8_0_0-20211006.zip && \
    cd ${JWS_HOME}/webapps/knowage; \
    wget --no-check-certificate "${KNOWAGE_CORE_URL}" && unzip -o ${KNOWAGE_CORE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_CORE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_CORE_ENGINE}.war -d ${KNOWAGE_CORE_ENGINE} && rm ${KNOWAGE_CORE_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_BIRTREPORT_URL}" && unzip -o ${KNOWAGE_BIRTREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_BIRTREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_BIRTREPORT_ENGINE}.war -d ${KNOWAGE_BIRTREPORT_ENGINE} && rm ${KNOWAGE_BIRTREPORT_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_COCKPIT_URL}" && unzip -o ${KNOWAGE_COCKPIT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_COCKPIT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_COCKPIT_ENGINE}.war -d ${KNOWAGE_COCKPIT_ENGINE} && rm ${KNOWAGE_COCKPIT_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_COMMONJ_URL}" && unzip -o ${KNOWAGE_COMMONJ_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_COMMONJ_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_COMMONJ_ENGINE}.war -d ${KNOWAGE_COMMONJ_ENGINE} && rm ${KNOWAGE_COMMONJ_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_DATAMINING_URL}" && unzip -o ${KNOWAGE_DATAMINING_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_DATAMINING_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_DATAMINING_ENGINE}.war -d ${KNOWAGE_DATAMINING_ENGINE} && rm ${KNOWAGE_DATAMINING_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_GEOREPORT_URL}" && unzip -o ${KNOWAGE_GEOREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_GEOREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_GEOREPORT_ENGINE}.war -d ${KNOWAGE_GEOREPORT_ENGINE} && rm ${KNOWAGE_GEOREPORT_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_JASPERREPORT_URL}" && unzip -o ${KNOWAGE_JASPERREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_JASPERREPORT_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_JASPERREPORT_ENGINE}.war -d ${KNOWAGE_JASPERREPORT_ENGINE} && rm ${KNOWAGE_JASPERREPORT_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_KPI_URL}" && unzip -o ${KNOWAGE_KPI_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_KPI_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_KPI_ENGINE}.war -d ${KNOWAGE_KPI_ENGINE} && rm ${KNOWAGE_KPI_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_META_URL}" && unzip -o ${KNOWAGE_META_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_META_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_META_ENGINE}.war -d ${KNOWAGE_META_ENGINE} && rm ${KNOWAGE_META_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_NETWORK_URL}" && unzip -o ${KNOWAGE_NETWORK_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_NETWORK_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_NETWORK_ENGINE}.war -d ${KNOWAGE_NETWORK_ENGINE} && rm ${KNOWAGE_NETWORK_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_QBE_URL}" && unzip -o ${KNOWAGE_QBE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_QBE_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_QBE_ENGINE}.war -d ${KNOWAGE_QBE_ENGINE} && rm ${KNOWAGE_QBE_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_SVGVIEWER_URL}" && unzip -o ${KNOWAGE_SVGVIEWER_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_SVGVIEWER_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_SVGVIEWER_ENGINE}.war -d ${KNOWAGE_SVGVIEWER_ENGINE} && rm ${KNOWAGE_SVGVIEWER_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_TALEND_URL}" && unzip -o ${KNOWAGE_TALEND_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_TALEND_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_TALEND_ENGINE}.war -d ${KNOWAGE_TALEND_ENGINE} && rm ${KNOWAGE_TALEND_ENGINE}.war && \
    wget --no-check-certificate "${KNOWAGE_WHATIF_URL}" && unzip -o ${KNOWAGE_WHATIF_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && rm ${KNOWAGE_WHATIF_ENGINE}-${KNOWAGE_PACKAGE_SUFFIX}.zip && unzip ${KNOWAGE_WHATIF_ENGINE}.war -d ${KNOWAGE_WHATIF_ENGINE} && rm ${KNOWAGE_WHATIF_ENGINE}.war
	
RUN cd ${JWS_HOME}/lib; \
    curl -LOs https://search.maven.org/remotecontent?filepath=commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar && \
    curl -LOs https://search.maven.org/remotecontent?filepath=commons-logging/commons-logging-api/1.1/commons-logging-api-1.1.jar && \
    curl -LOs https://search.maven.org/remotecontent?filepath=org/lucee/oswego-concurrent/1.3.4/oswego-concurrent-1.3.4.jar && \
    curl -LOs https://search.maven.org/remotecontent?filepath=org/apache/geronimo/specs/geronimo-commonj_1.1_spec/1.0/geronimo-commonj_1.1_spec-1.0.jar && \
    curl -L https://github.com/SpagoBILabs/SpagoBI/blob/mvn-repo/releases/de/myfoo/commonj/1.0/commonj-1.0.jar?raw=true -o commonj-1.0.jar && \
    curl -LOs https://search.maven.org/remotecontent?filepath=org/hsqldb/hsqldb/1.8.0.10/hsqldb-1.8.0.10.jar && \
    curl -LOs https://jdbc.postgresql.org/download/postgresql-42.2.4.jar && \
    curl -LOs https://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.33/mysql-connector-java-5.1.33.jar
RUN sed -i "s/bin\/sh/bin\/bash/" ${JWS_HOME}/bin/startup.sh && \
    sed -i "s/EXECUTABLE\" start/EXECUTABLE\" run/" ${JWS_HOME}/bin/startup.sh

COPY services-whitelist.xml ${JWS_HOME}/resources
COPY extGlobalResources ${JWS_HOME}/conf/server.xml.d
COPY extContext ${JWS_HOME}/conf/context.xml.d
COPY CHANGELOG.md LICENSE README.md entrypoint.sh wait-for-it.sh ${JWS_HOME}/

RUN chmod +x ${JWS_HOME}/bin/* && chmod +x ${JWS_HOME}/* && chown -R jboss ${JWS_HOME}/* && sed -i "s|apache-tomcat\/||g" ${KNOWAGE_DIRECTORY}/entrypoint.sh && \
    chmod g+w ${JWS_HOME}/conf && chmod g+w ${JWS_HOME}/webapps/knowage/WEB-INF && chmod g+w ${JWS_HOME}/logs && chmod g+w ${JWS_HOME}/temp && \
    chmod -R g+w ${JWS_HOME}/ && \
    sed -i "s|CONTAINER_INITIALIZED_PLACEHOLDER=\/.CONTAINER_INITIALIZED|CONTAINER_INITIALIZED_PLACEHOLDER=/tmp/.CONTAINER_INITIALIZED|g" ${KNOWAGE_DIRECTORY}/entrypoint.sh

RUN rm -rf ${JWS_HOME}/webapps/knowage/WEB-INF/lib/{commonj-1.0.jar,commons-logging-1.1.1.jar,geronimo-commonj_1.1_spec-1.0.jar}

WORKDIR ${KNOWAGE_DIRECTORY}

#USER 1001

EXPOSE 8080 8009

ENTRYPOINT ["/opt/jws-5.2/tomcat/entrypoint.sh"]

CMD ["/opt/jws-5.2/tomcat/bin/startup.sh"]
