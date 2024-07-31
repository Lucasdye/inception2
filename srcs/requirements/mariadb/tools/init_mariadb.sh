#!/bin/sh

echo "\n=============================="
echo "=== Database configuration ==="
echo "==============================\n"

if [ -d "/var/lib/mysql/${SQL_DB}" ]
then 
    echo "==> database ${SQL_DB} already exists\n"
else
    echo "starting mariadb..."
    service mariadb start
    sleep 1
    echo "creating database: ${SQL_DB}"
    mysql -e "CREATE DATABASE IF NOT EXISTS ${SQL_DB};"
    mysql -e "CREATE USER IF NOT EXISTS '${SQL_SUPUSER}'@'%' IDENTIFIED BY '${SQL_SUPUSER_PASS}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${SQL_DB}.* TO '${SQL_SUPUSER}'@'%' IDENTIFIED BY '${SQL_SUPUSER_PASS}';"
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASS}';"
    sleep 1
    # shutting down mariadb so it can be restarted using exec
    mysqladmin -u root -p${SQL_ROOT_PASS} shutdown
    echo "database ready"
fi
sleep 1
# using exec, the specified command becomes PID 1
# runs the command without a shell. It can have advantages in term of signal handling and clean process termination
exec mysqld