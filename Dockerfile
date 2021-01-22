FROM debian:buster
MAINTAINER Lucie Le Briquer <lle-briq@student.42.fr>

# packages
RUN apt-get update && apt-get install -y nginx wget php-mysql php-fpm \
php-mbstring php-xml mariadb-server unzip && apt-get clean

# nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm -rf /var/www/html && mkdir /var/www/ft_server
COPY srcs/nginx-default /etc/nginx/sites-available/default

# wordpress
WORKDIR /var/www/ft_server
RUN wget http://fr.wordpress.org/latest-fr_FR.tar.gz \
	&& tar -xzvf latest-fr_FR.tar.gz \
	&& rm latest-fr_FR.tar.gz \
	&& chown -R www-data:www-data wordpress
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp
COPY srcs/wp-config.php /var/www/ft_server/wordpress/wp-config.php

# add twentyfifteen theme
WORKDIR /var/www/ft_server/wordpress/wp-content/themes
RUN wget https://downloads.wordpress.org/theme/twentyfifteen.2.8.zip \
	&& unzip twentyfifteen.2.8.zip \
	&& rm twentyfifteen.2.8.zip

WORKDIR /

# configure phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages/ /var/www/ft_server/phpmyadmin \
	&& rm phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mkdir -p /var/lib/phpmyadmin/tmp \
	&& chown -R www-data:www-data /var/lib/phpmyadmin
COPY srcs/pma-config.php /var/www/ft_server/phpmyadmin/config.inc.php

# add SSL certificate
RUN wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64 \
	&& mv mkcert-v1.4.1-linux-amd64 mkcert \
	&& chmod +x mkcert \
	&& mv mkcert /usr/local/bin/ \
	&& mkcert -install \
	&& mkcert localhost

# init database
COPY srcs/database.sql .
COPY srcs/autoindex.sh .
COPY srcs/index.html /var/www/ft_server/

EXPOSE 80 443

CMD service php7.3-fpm start \
	&& service mysql start \
	&& cat /var/www/ft_server/phpmyadmin/sql/create_tables.sql >> database.sql \
	&& cat database.sql | mysql -uroot --password=password \
	&& wp core install --url=http://localhost/wordpress --title=ft_server --admin_user=root --admin_password=password --admin_email=lle-briq@student.42.fr --path=/var/www/ft_server/wordpress --allow-root \
	&& echo "USE wordpress; UPDATE wp_options SET option_value = 'twentyfifteen' WHERE option_id = 40 OR option_id = 41;" | mysql -uroot --password=password \
	&& rm database.sql \
	&& service nginx start
