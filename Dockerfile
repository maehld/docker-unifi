FROM ubuntu:17.04
MAINTAINER Dominik Mähl <dominik@maehl.eu>

VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi"]

#UniFi Ports (https://help.ubnt.com/hc/en-us/articles/218506997-UniFi-Ports-Used)
EXPOSE 8080/tcp 8443/tcp 8880/tcp 8843/tcp 6789/tcp 3478/udp 10001/udp

ENV DEBIAN_FRONTEND noninteractive

#install needed packages
RUN apt update \
    && apt install -y curl binutils jsvc mongodb-server openjdk-8-jdk-headless libcap2 \
    && rm -rf /var/lib/apt/lists/*

#install UniFi Controller
RUN curl -OLS https://www.ubnt.com/downloads/unifi/5.6.7-63ab9a7965/unifi_sysvinit_all.deb \
    && dpkg -i unifi_sysvinit_all.deb \
    && rm unifi_sysvinit_all.deb

#let UniFi use the volumes
RUN ln -s /var/lib/unifi /usr/lib/unifi/data \
    && ln -s /var/log/unifi /usr/lib/unifi/logs \
    && ln -s /var/run/unifi /usr/lib/unifi/run

ENTRYPOINT ["/usr/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
CMD ["start"]
