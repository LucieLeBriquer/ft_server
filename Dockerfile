FROM debian:buster
LABEL maintainer="lle-briq@student.42.fr"

# packages
RUN apt-get update && apt-get install -y nginx wget php-mysql php-fpm \
	php-mbstring php-xml mariadb-server && apt-get clean

# nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
	&& rm -rf /var/www/html && mkdir /var/www/ft_server

# wordpress
WORKDIR /var/www/ft_server
RUN wget http://fr.wordpress.org/latest-fr_FR.tar.gz \
	&& tar -xzvf latest-fr_FR.tar.gz \
	&& rm latest-fr_FR.tar.gz \
	&& chown -R www-data:www-data wordpress \
	&& wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

WORKDIR /

# configure phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages/ /var/www/ft_server/phpmyadmin \
	&& rm phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mkdir -p /var/lib/phpmyadmin/tmp \
	&& chown -R www-data:www-data /var/lib/phpmyadmin

# add SSL certificate
RUN wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64 \
	&& mv mkcert-v1.4.1-linux-amd64 mkcert \
	&& chmod +x mkcert \
	&& mv mkcert /usr/local/bin/ \
	&& mkcert -install \
	&& mkcert localhost

# init database
COPY srcs/nginx-default /etc/nginx/sites-available/default
COPY srcs/pma-config.php /var/www/ft_server/phpmyadmin/config.inc.php
COPY srcs/wp-config.php /var/www/ft_server/wordpress/wp-config.php
COPY srcs/database.sql .
COPY srcs/autoindex.sh .
COPY srcs/index.html /var/www/ft_server/

RUN service mysql start \
	&& cat /var/www/ft_server/phpmyadmin/sql/create_tables.sql >> database.sql \
	&& echo "GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'localhost' IDENTIFIED BY 'password';" >> database.sql \
	&& cat database.sql | mariadb \
	&& wp core install --url=http://localhost/wordpress --title=ft_server --admin_user=admin \
	--admin_password=password --admin_email=lle-briq@student.42.fr \
	--path=/var/www/ft_server/wordpress --allow-root \
	&& wp theme install twentyfifteen --activate --path=/var/www/ft_server/wordpress --allow-root \
	&& rm database.sql

EXPOSE 80 443

CMD service php7.3-fpm start \
	&& service mysql start \
	&& service nginx start
