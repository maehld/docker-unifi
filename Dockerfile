FROM ubuntu:17.04
MAINTAINER Dominik Mähl <dominik@maehl.eu>

VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi"]

#UniFi Ports (https://help.ubnt.com/hc/en-us/articles/218506997-UniFi-Ports-Used)
EXPOSE 8080/tcp 8443/tcp 8880/tcp 8843/tcp 6789/tcp 3478/udp 10001/udp

ENV DEBIAN_FRONTEND noninteractive

#install needed packages with oracle jdk due to bug in zlib
RUN apt update \
    && apt install -y software-properties-common \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && add-apt-repository -y ppa:webupd8team/java \
    && apt update \
    && apt install -y curl binutils jsvc mongodb-server oracle-java8-installer libcap2 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/oracle-jdk8-installer

#install UniFi Controller
RUN curl -OLS https://www.ubnt.com/downloads/unifi/5.6.14-f7a900184a/unifi_sysvinit_all.deb \
    && dpkg -i unifi_sysvinit_all.deb \
    && rm unifi_sysvinit_all.deb

#let UniFi use the volumes
RUN ln -s /var/lib/unifi /usr/lib/unifi/data \
    && ln -s /var/log/unifi /usr/lib/unifi/logs \
    && ln -s /var/run/unifi /usr/lib/unifi/run

ENTRYPOINT ["/usr/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
CMD ["start"]