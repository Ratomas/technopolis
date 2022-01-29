# syntax=docker/dockerfile:1

FROM openjdk:11-jdk-buster

LABEL version="1.3"

RUN apt-get update && apt-get install -y curl unzip dos2unix && \
 addgroup minecraft && \
 adduser --home /data --ingroup minecraft --disabled-password minecraft

COPY launch.sh /launch.sh
RUN dos2unix /launch.sh
RUN chmod +x /launch.sh

COPY server.properties /server.properties
RUN dos2unix /server.properties

COPY server-setup-config.yaml /server-setup-config.yaml
RUN dos2unix /server-setup-config.yaml

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

CMD ["/launch.sh"]

ENV MOTD "Techopolis vB9.0 Server Powered by Docker"
ENV LEVEL world
ENV LEVEL skyblock
ENV JVM_OPTS "-Xms2048m -Xmx4096m"
