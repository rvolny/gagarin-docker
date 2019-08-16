#
# Copy createdb.sql.example to createdb.sql
# then uncomment then set database name and username to create you need databases
#
# example: .env MYSQL_USER=appuser and needed db name is myshop_db
#
#    CREATE DATABASE IF NOT EXISTS `myshop_db` ;
#    GRANT ALL ON `myshop_db`.* TO 'appuser'@'%' ;
#
#
# this sql script will auto run when the mysql container starts and the $DATA_PATH_HOST/mysql not found.
#
# if your $DATA_PATH_HOST/mysql exists and you do not want to delete it, you can run by manual execution:
#
#     docker-compose exec mysql bash
#     mysql -u root -p < /docker-entrypoint-initdb.d/createdb.sql
#

# https://github.com/laradock/laradock/issues/1392

# create user
CREATE USER '___MYSQL_USER___'@'localhost' IDENTIFIED WITH mysql_native_password BY '___MYSQL_PASSWORD___';
GRANT ALL PRIVILEGES ON *.* TO '___MYSQL_USER___'@'localhost' WITH GRANT OPTION;

# create database
CREATE DATABASE IF NOT EXISTS `___MYSQL_DATABASE___` COLLATE 'utf8_general_ci' ;
GRANT ALL ON `___MYSQL_DATABASE___`.* TO '___MYSQL_USER___'@'localhost' ;

FLUSH PRIVILEGES ;
