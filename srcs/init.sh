service php7.3-fpm start
service mysql start
cat database.txt | mysql -uroot --skip-password && rm database.txt
service nginx start
