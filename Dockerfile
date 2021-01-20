FROM debian:buster
MAINTAINER Lucie Le Briquer <lle-briq@student.42.fr>

# packages
RUN apt-get update && apt-get install -y nginx wget php-mysql php-fpm \
php-mbstring mariadb-server unzip && apt-get clean

# nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm -rf /var/www/html
COPY srcs/nginx-default /etc/nginx/sites-available/default

# create database
COPY srcs/create-db.sql .

# wordpress
WORKDIR /var/www
RUN wget http://fr.wordpress.org/latest-fr_FR.tar.gz \
	&& tar -xzvf latest-fr_FR.tar.gz \
	&& rm latest-fr_FR.tar.gz \
	&& chown -R www-data:www-data wordpress
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp
COPY srcs/wp-config.php /var/www/wordpress/wp-config.php

# add some themes
WORKDIR /var/www/wordpress/wp-content/themes
RUN wget https://downloads.wordpress.org/theme/twentyfifteen.2.8.zip \
	&& wget https://downloads.wordpress.org/theme/go.1.3.9.zip \
	&& wget https://downloads.wordpress.org/theme/astra.3.0.1.zip \
	&& unzip twentyfifteen.2.8.zip \
	&& unzip go.1.3.9.zip \
	&& unzip astra.3.0.1.zip \
	&& rm twentyfifteen.2.8.zip go.1.3.9.zip astra.3.0.1.zip

# configure phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages/ /var/www/wordpress/phpmyadmin \
	&& rm phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mkdir -p /var/lib/phpmyadmin/tmp \
	&& chown -R www-data:www-data /var/lib/phpmyadmin
COPY srcs/pma-config.php /var/www/wordpress/phpmyadmin/config.inc.php

WORKDIR /
COPY srcs/init.sh .

EXPOSE 80

CMD bash init.sh
