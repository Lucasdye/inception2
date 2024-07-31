#!/bin/bash

sleep 5;

cd /var/www/html
if [ ! -f wp-config.php ];
then
    sleep 10
    echo "Setting up Wordpress"
    ./wp-cli.phar core download --allow-root

    echo "Setting up wp-config.php"
    ./wp-cli.phar core config --allow-root \
                --dbname=$SQL_DB \
                --dbuser=$SQL_SUPUSER \
                --dbpass=$SQL_SUPUSER_PASS \
                --dbhost=mariadb:3306\

    echo "Installing Wordpress"
    ./wp-cli.phar core install --allow-root \
                --url=$DOMAIN_NAME \
                --title=$WP_SITE_TITLE \
                --admin_user=$WP_ADMIN_USER \
                --admin_password=$WP_ADMIN_USER_PASS \
                --admin_email=$WP_ADMIN_EMAIL \

    echo "Setting up Wordpress user"
    ./wp-cli.phar user create $WP_USER $WP_USER_EMAIL --allow-root \
                --role=author \
                --user_pass=$WP_USER_PASS \

    chown -R www-data:www-data /var/www/html/wp-content
    chown -R www-data:www-data /var/www/html

    echo "Wordpress is now setup"

else
    usermod -u 33 www-data && groupmod -g 33 www-data
    chown -R www-data:www-data /var/www/html/
    echo "Wordpress is already setup"
fi


exec /usr/sbin/php-fpm7.4 -F;