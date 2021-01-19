FROM debian:buster
MAINTAINER Lucie Le Briquer <lle-briq@student.42.fr>

# packages
RUN apt-get update && apt-get install -y nginx wget php-mysql php-fpm \
php-mbstring mariadb-server && apt-get clean

# nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm -rf /var/www/html
COPY srcs/nginx/default /etc/nginx/sites-available/

# create database
COPY srcs/mysql/database.sql .

# wordpress
WORKDIR /var/www
RUN wget http://fr.wordpress.org/latest-fr_FR.tar.gz \
	&& tar -xzvf latest-fr_FR.tar.gz \
	&& rm latest-fr_FR.tar.gz \
	&& chown -R www-data:www-data wordpress

# configure nginx to use php
COPY srcs/php/database.php /var/www/wordpress/

# configure phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages/ /var/www/wordpress/phpmyadmin \
	&& rm phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mkdir -p /var/lib/phpmyadmin/tmp \
	&& chown -R www-data:www-data /var/lib/phpmyadmin
COPY srcs/php/config.inc.php /var/www/wordpress/phpmyadmin

WORKDIR /
COPY srcs/init.sh .

EXPOSE 80

CMD bash init.sh
