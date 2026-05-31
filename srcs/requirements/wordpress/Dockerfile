FROM debian:12

RUN apt update && \
    apt install -y php-fpm php-mysql curl mariadb-client php-redis &&  \
    apt clean

# php fpm needs this folder
RUN mkdir -p /run/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp


# php fpm configuration
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/init.sh"]