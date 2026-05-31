#!/bin/bash

# Load from secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
USER=$(cat /run/secrets/db_user)

ADMIN_USER=$(cat /run/secrets/wp_admin_user)
ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
ADMIN_EMAIL=$(cat /run/secrets/wp_admin_email)

USER_NAME=$(cat /run/secrets/wp_user)
USER_PASSWORD=$(cat /run/secrets/wp_user_password)
USER_EMAIL=$(cat /run/secrets/wp_user_email)

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
        --dbuser=$USER \
        --dbpass=$DB_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root

    wp core install \
        --url=https://$DOMAIN_NAME \
        --title="inception" \
        --admin_user=$ADMIN_USER \
        --admin_password=$ADMIN_PASSWORD \
        --admin_email=$ADMIN_EMAIL \
        --allow-root

    wp user create \
        $USER_NAME \
        $USER_EMAIL \
        --role=author \
        --user_pass=$USER_PASSWORD \
        --allow-root


    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp config set WP_CACHE true --raw --allow-root
    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root
    echo "WordPress installation completed successfully!"
else
    echo "WordPress is already configured."
fi

echo "Starting PHP-FPM in the foreground..."
chown -R www-data:www-data /var/www/html
exec php-fpm8.2 -F