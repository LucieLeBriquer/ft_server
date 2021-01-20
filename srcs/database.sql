CREATE DATABASE IF NOT EXISTS wordpress;
GRANT ALL ON wordpress.* TO 'root'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
