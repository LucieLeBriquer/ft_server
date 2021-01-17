FROM debian:buster
MAINTAINER Lucie Le Briquer <lle-briq@student.42.fr>

RUN apt-get update
RUN apt-get install -y nginx

# nginx
COPY srcs/html/* /html/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY init.sh .

EXPOSE 80

CMD bash init.sh
