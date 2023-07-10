FROM bitnami/minideb:bullseye
LABEL maintainer="Dominik Mähl <dominik@maehl.eu>"

VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi"]

#UniFi Ports (https://help.ubnt.com/hc/en-us/articles/218506997-UniFi-Ports-Used)
EXPOSE 8080/tcp 8443/tcp 8880/tcp 8883/tcp 8843/tcp 6789/tcp 3478/udp 10001/udp

ENV DEBIAN_FRONTEND noninteractive

#install needed packages
RUN install_packages curl gnupg libcap2 ca-certificates binutils jsvc

#install mongodb
RUN curl -fsSL https://pgp.mongodb.com/server-6.0.asc | gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor \
    && echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list \
    && install_packages mongodb-org

#install open jdk
RUN curl -LS -o "jdk.tar.gz" https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.19%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.19_7.tar.gz \
    && mkdir /opt/jdk \
    && tar xvzf jdk.tar.gz --strip 1 -C /opt/jdk \
    && rm jdk.tar.gz

#install UniFi Controller
RUN curl -LS -o unifi.deb https://dl.ui.com/unifi/7.4.162/unifi_sysvinit_all.deb \
    && dpkg --force-all -i unifi.deb \
    && rm unifi.deb

#let UniFi use the volumes
RUN ln -s /var/lib/unifi /usr/lib/unifi/data \
    && ln -s /var/log/unifi /usr/lib/unifi/logs \
    && ln -s /var/run/unifi /usr/lib/unifi/run

#correct wd is necessary because unifi places its log in .\logs\server.log
WORKDIR /usr/lib/unifi

ENTRYPOINT ["/opt/jdk/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar"]
CMD ["start"]
