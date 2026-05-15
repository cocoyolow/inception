FROM debian:12


RUN apt update && \
    apt install -y nginx openssl && \
    apt clean

RUN mkdir -p /etc/nginx/ssl

# ARG LOGIN
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=ARA/L=Lyon/O=42/OU=42/CN=cobussie.42.fr/UID=cobussie"

# for configuration files
RUN mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf