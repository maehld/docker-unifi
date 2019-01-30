FROM bitnami/minideb:stretch
LABEL maintainer="Dominik Mähl <dominik@maehl.eu>"

VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi"]

#UniFi Ports (https://help.ubnt.com/hc/en-us/articles/218506997-UniFi-Ports-Used)
EXPOSE 8080/tcp 8443/tcp 8880/tcp 8843/tcp 6789/tcp 3478/udp 10001/udp

ENV DEBIAN_FRONTEND noninteractive

#install needed packages
RUN install_packages curl mongodb-server libcap2 ca-certificates binutils jsvc

#install oracle jdk
RUN curl -LS -o "jdk.tar.gz" -H "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-x64.tar.gz \
    && mkdir /opt/jdk \
    && tar xvzf jdk.tar.gz --strip 1 -C /opt/jdk \
    && rm jdk.tar.gz

#install UniFi Controller
RUN curl -OLS https://dl.ubnt.com/unifi/5.10.11-6e1800b9b9/unifi_sysvinit_all.deb \
    && dpkg --force-all -i unifi_sysvinit_all.deb \
    && rm unifi_sysvinit_all.deb

#let UniFi use the volumes
RUN ln -s /var/lib/unifi /usr/lib/unifi/data \
    && ln -s /var/log/unifi /usr/lib/unifi/logs \
    && ln -s /var/run/unifi /usr/lib/unifi/run

#correct wd is necessary because unifi places its log in .\logs\server.log
WORKDIR /usr/lib/unifi

ENTRYPOINT ["/opt/jdk/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
CMD ["start"]
