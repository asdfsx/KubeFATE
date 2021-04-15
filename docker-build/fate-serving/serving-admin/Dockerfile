FROM mcr.microsoft.com/java/jre:8u192-zulu-alpine

WORKDIR /data/projects/fate/serving-admin/

ARG version

COPY fate-serving-admin-${version}-release.zip ./

RUN unzip fate-serving-admin-${version}-release.zip && \
    rm fate-serving-admin-${version}-release.zip && \
    ln -s fate-serving-admin-*.jar fate-serving-admin.jar

EXPOSE 8000

CMD java -cp conf/:lib/*:fate-serving-admin.jar com.webank.ai.fate.serving.admin.Bootstrap -c conf/application.properties