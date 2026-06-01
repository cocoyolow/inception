


FROM debian:12

RUN apt-get update && \
    apt-get install -y wget tar ca-certificates && \
    apt-get clean

RUN wget https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz && \
    tar -xvf portainer-2.19.4-linux-amd64.tar.gz && \
    rm portainer-2.19.4-linux-amd64.tar.gz

ENTRYPOINT ["/portainer/portainer", "--admin-password-file", "/run/secrets/portainer_password"]