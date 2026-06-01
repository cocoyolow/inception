#!/bin/bash

FTP_USER=$(cat /run/secrets/ftp_user)
FTP_PASSWORD=$(cat /run/secrets/ftp_password)

if ! id "$FTP_USER" &>/dev/null; then
    echo "Creating FTP user: $FTP_USER"
    
    # || true to not raise an error if the group already exists
    groupadd -g 33 www-data 2>/dev/null || true
    
    useradd -d /var/www/html -g www-data $FTP_USER
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

    chmod -R 775 /var/www/html
fi

echo "Starting FTP server..."
exec vsftpd /etc/vsftpd.conf