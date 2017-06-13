# docker-unifi
Docker image for Ubiquiti's UniFi Controller

# How to run

This image has three volumes:
- /var/lib/unifi
  - contains the configuration and database
- /var/log/unifi
  - stores the logs of both the Controller and MongoDB
- /var/run/unifi
  - possibly but needed but included in this first version anyway :-)

To get a minimal controller up and running you would need to run something like this:

```
docker run -d --name unifi \
    -p 8080:8080 \
    -p 8443:8443 \
    -p 8880:8880 \
    -p 8843:8843 \
    -p 6789:6789 \
    -p 3478:3478 \
    -v /YOUR_DATA:/var/lib/unifi \
    maehld/unifi

