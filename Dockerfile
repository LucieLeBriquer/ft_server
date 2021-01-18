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
COPY srcs/mysql/database.txt .

# configure nginx to use php
#RUN mkdir /var/www/site && $USER:$USER /var/www/site
#COPY srcs/nginx/site /etc/nginx/sites-available/site
#RUN ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/
COPY srcs/php/info.php /var/www/html/

# wordpress
#WORKDIR /var/www
#RUN wget http://fr.wordpress.org/latest-fr_FR.tar.gz
#RUN tar -xzvf latest-fr_FR.tar.gz
#RUN mv wordpress site && rm latest-fr_FR.tar.gz

COPY srcs/init.sh .
COPY srcs/html/ /var/www/html/

EXPOSE 80

CMD bash init.sh
