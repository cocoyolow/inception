FROM debian:12

RUN apt update && \
    apt install -y nginx && \
    apt clean

RUN mkdir -p /etc/nginx/ssl

RUN apt install OpenSSL -y

# for configuration files
RUN mkdir -p /var/run/nginx

