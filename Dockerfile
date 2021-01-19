FROM debian:buster
MAINTAINER Lucie Le Briquer <lle-briq@student.42.fr>

# packages
RUN apt-get update && apt-get install -y nginx wget php-mysql php-fpm \
php-mbstring mariadb-server && apt-get clean

# nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /var/www/html/index.nginx-debian.html
COPY srcs/nginx/default /etc/nginx/sites-available/

# create database
COPY srcs/mysql/database.sql .

# configure nginx to use php
COPY srcs/php/database.php /var/www/html/

# configure phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages/ /var/www/html/phpmyadmin \
	&& rm phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mkdir -p /var/lib/phpmyadmin/tmp \
	&& chown -R www-data:www-data /var/lib/phpmyadmin
COPY srcs/php/config.inc.php /var/www/html/phpmyadmin

# wordpress
WORKDIR /var/www/html
RUN wget http://fr.wordpress.org/latest-fr_FR.tar.gz \
	&& tar -xzvf latest-fr_FR.tar.gz \
	&& rm latest-fr_FR.tar.gz \
	&& chown -R www-data:www-data wordpress

# maybe
# RUN apt-get install -y php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
# RUN apt-get -y install php-cli php-mysql php-curl php-gd php-intl

WORKDIR /
COPY srcs/init.sh .

EXPOSE 80

CMD bash init.sh
