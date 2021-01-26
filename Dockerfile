FROM debian:buster
LABEL maintainer="lle-briq@student.42.fr"

# packages
RUN apt-get -qq update \
&& apt-get install -y nginx wget php-mysql php-fpm php-mbstring php-xml mariadb-server \
> /dev/null 2>&1 \
&& apt-get -qq clean

# nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
&& rm -rf /var/www/html && mkdir /var/www/ft_server

# wordpress
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&& chmod +x wp-cli.phar \
&& mv wp-cli.phar /usr/local/bin/wp \
&& wp core download --path=/var/www/ft_server/wordpress --locale=en_US --allow-root > /dev/null 2>&1

# phpmyadmin
RUN wget -q https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
&& tar xf phpMyAdmin-5.0.4-all-languages.tar.gz \
&& mv phpMyAdmin-5.0.4-all-languages/ /var/www/ft_server/phpmyadmin \
&& rm phpMyAdmin-5.0.4-all-languages.tar.gz \
&& mkdir -p /var/lib/phpmyadmin/tmp \
&& chown -R www-data:www-data /var/lib/phpmyadmin

# SSL certificate
RUN wget -q https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64 \
&& mv mkcert-v1.4.1-linux-amd64 mkcert \
&& chmod +x mkcert \
&& mv mkcert /usr/local/bin/ \
&& mkcert -install > /dev/null 2>&1 \
&& mkcert localhost > /dev/null 2>&1

COPY srcs/wp-config.php /var/www/ft_server/wordpress/wp-config.php
COPY srcs/database.sql .

# init database and install wordpress
RUN service mysql start \
&& cat database.sql | mariadb \
&& wp core install --url=http://localhost/wordpress --title=ft_server --admin_user=admin \
--admin_password=password --admin_email=lle-briq@student.42.fr --quiet \
--path=/var/www/ft_server/wordpress --allow-root \
&& wp theme install twentyfifteen --quiet --activate --path=/var/www/ft_server/wordpress \
--allow-root \
&& rm database.sql

COPY srcs/nginx-default /etc/nginx/sites-available/default
COPY srcs/pma-config.php /var/www/ft_server/phpmyadmin/config.inc.php
COPY srcs/autoindex.sh .
COPY srcs/index.html /var/www/ft_server/

EXPOSE 80 443

CMD service php7.3-fpm start \
	&& service mysql start \
	&& service nginx start
