FROM tomcat-webserver:9-jdk8

LABEL io.k8s.description="Knowage Community Edition Server" \
    io.k8s.display-name="Knowage" \
    io.openshift.tags="knowage"

ARG KNOWAGE_VERSION=8.0.0-RC
ARG KNOWAGE_DL_URL=https://release.ow2.org/knowage/8.0.0-RC/Applications

RUN cd ${JWS_HOME}/webapps; \
    for i in $(curl -Ls ${KNOWAGE_DL_URL} --list-only |sed -n 's%.*href="\([^.]*-CE-.*\.zip\)".*%\n\1%; ta; b; :a; s%.*\n%%; p'); \
    do curl -LOs ${KNOWAGE_DL_URL}/${i}; \
    unzip -n $i; \
    rm $i; done && \
    for w in *.war; \
    do unzip -n $w; \ 
    rm $w; done && \
    cd ${JWS_HOME}/lib; \
    curl -LOs https://search.maven.org/remotecontent?filepath=commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar && \
    curl -LOs https://search.maven.org/remotecontent?filepath=commons-logging/commons-logging-api/1.1/commons-logging-api-1.1.jar && \
    curl -LOs https://search.maven.org/remotecontent?filepath=org/lucee/oswego-concurrent/1.3.4/oswego-concurrent-1.3.4.jar && \
    curl -LOs https://search.maven.org/remotecontent?filepath=org/apache/geronimo/specs/geronimo-commonj_1.1_spec/1.0/geronimo-commonj_1.1_spec-1.0.jar && \
    curl -LOs https://github.com/SpagoBILabs/SpagoBI/blob/mvn-repo/releases/de/myfoo/commonj/1.0/commonj-1.0.jar && \
    sed -i "s/bin\/sh/bin\/bash/" ${JWS_HOME}/bin/startup.sh && \
    sed -i "s/EXECUTABLE\" start/EXECUTABLE\" run/" ${JWS_HOME}/bin/startup.sh

#COPY server.xml context.xml knowage-default.policy hazelcast.xml ${JWS_HOME}/conf/

USER 1001

EXPOSE 8080 8009

#ENTRYPOINT ["./entrypoint.sh"]

CMD ["/opt/jws-5.2/tomcat/bin/startup.sh"]