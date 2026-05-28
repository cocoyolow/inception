#!/bin/bash

DB_PASSWORD=$(cat /run/secrets/db_password)

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Configuring WordPress..."

    # download wordpress
    wp core download --allow-root

    # wait until mariadb is ready
    while ! mysqladmin ping -h "mariadb" --silent; do
        sleep 1
    done

    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$DB_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root

    wp core install \
        --url=$DOMAIN_NAME \
        --title="inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    wp user create \
        $WP_USER \
        $WP_USER_EMAIL \
        --role=author \
        --user_pass=$WP_USER_PASSWORD \
        --allow-root

    echo "WordPress installation completed successfully!"
else
    echo "WordPress is already configured."
fi

echo "Starting PHP-FPM in the foreground..."
exec php-fpm8.2 -F // -F = Foreground