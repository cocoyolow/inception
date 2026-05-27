#!/bin/bash

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# checks if the database is not already initialized
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "Initializing MariaDB database..."

    mysqld --user=mysql &
    
    # wait until mariadb is ready
    while ! mysqladmin ping -h localhost --silent; do
        sleep 1
    done

    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    
    # 3. Security: change the default MariaDB root user password
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

    # shutdown the service we don't need anymore
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
else
    echo "The database already exists, proceeding directly to startup."
fi

echo "Starting MariaDB in the foreground..."

# start mariadb in first plan
exec mysqld --user=mysql