FROM debian:buster
MAINTAINER Lucie Le Briquer <lle-briq@student.42.fr>

# packages
RUN apt-get update
RUN apt-get install -y nginx wget
RUN apt-get -y install php-mysql php-fpm php-mbstring
RUN apt-get -y install mariadb-server
RUN apt-get clean

# nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN rm /var/www/html/index.nginx-debian.html
COPY srcs/init.sh .

# install php and mysql

# wordpress
#WORKDIR /var/www
#RUN wget http://fr.wordpress.org/latest-fr_FR.tar.gz
#RUN tar -xzvf latest-fr_FR.tar.gz
#RUN mv wordpress site && rm latest-fr_FR.tar.gz

COPY srcs/html/ /var/www/html/

EXPOSE 80

CMD bash init.sh
