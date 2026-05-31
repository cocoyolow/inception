FROM debian:12

RUN apt update && \
    apt install -y nginx && \
    apt clean

COPY conf/index.html /var/www/html/index.html

RUN chmod 755 /var/www/html/index.html

ENTRYPOINT ["nginx", "-g", "daemon off;"]