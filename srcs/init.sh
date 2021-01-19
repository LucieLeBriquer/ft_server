service php7.3-fpm start
service mysql start
cat database.sql | mysql -uroot --password=password && rm database.sql
cat /var/www/html/phpmyadmin/sql/create_tables.sql | mysql -uroot --password=password
echo "GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'root'@'localhost' IDENTIFIED BY 'password';" | mysql -uroot --password=password
service nginx start
