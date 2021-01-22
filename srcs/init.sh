#!/bin/bash

service php7.3-fpm start
service mysql start
cat /var/www/ft_server/phpmyadmin/sql/create_tables.sql >> database.sql
cat database.sql | mysql -uroot --password=password
wp core install --url=http://localhost/wordpress --title=ft_server --admin_user=root --admin_password=password --admin_email=lle-briq@student.42.fr --path=/var/www/ft_server/wordpress --allow-root
echo "USE wordpress; UPDATE wp_options SET option_value = 'twentyfifteen' WHERE option_id = 40 OR option_id = 41;" | mysql -uroot --password=password
rm database.sql
service nginx start
