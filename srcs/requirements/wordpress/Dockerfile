FROM debian:bullseye

RUN     apt update -y
RUN     apt-get -y install wget \
        php7.4\
        php-fpm\ 
        php-mysql\
        mariadb-client

RUN     wget https://fr.wordpress.org/wordpress-6.2.2-fr_FR.tar.gz -P /var/www
RUN     cd /var/www && tar -xzf wordpress-6.2.2-fr_FR.tar.gz && rm wordpress-6.2.2-fr_FR.tar.gz



RUN     mkdir -p /var/www/html \
&& mkdir -p /run/php

RUN 	cp -r /var/www/wordpress/. /var/www/html
RUN	cd /var/www/html && wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar
COPY	conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
RUN     chmod 755 /etc/php/7.4/fpm/pool.d/www.conf

COPY 	tools/config_setup.sh /usr/local/bin/config_setup.sh
RUN     chmod 755 /usr/local/bin/config_setup.sh


EXPOSE	9000

ENTRYPOINT [ "sh", "/usr/local/bin/config_setup.sh" ]
