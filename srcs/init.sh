service php7.3-fpm start
service mysql start
cat database.sql | mysql -uroot --password=password
cat /var/www/wordpress/phpmyadmin/sql/create_tables.sql | mysql -uroot --password=password
service nginx start
