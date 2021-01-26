CREATE DATABASE IF NOT EXISTS wordpress;
GRANT ALL ON wordpress.* TO 'pma'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
