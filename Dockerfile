FROM debian:buster
MAINTAINER Lucie Le Briquer <lle-briq@student.42.fr>

# packages
RUN apt-get update && apt-get install -y nginx wget php-mysql php-fpm \
php-mbstring mariadb-server && apt-get clean

# nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /var/www/html/index.nginx-debian.html

# create database
COPY srcs/mysql/database.txt .

# wordpress
#WORKDIR /var/www
#RUN wget http://fr.wordpress.org/latest-fr_FR.tar.gz
#RUN tar -xzvf latest-fr_FR.tar.gz
#RUN mv wordpress site && rm latest-fr_FR.tar.gz

COPY srcs/init.sh .
COPY srcs/html/ /var/www/html/

EXPOSE 80

CMD bash init.sh
