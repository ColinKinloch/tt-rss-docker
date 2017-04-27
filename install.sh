#!/usr/bin/env sh

#DB_PASS=$(cat /dev/urandom | tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
DB_PASS=

su - postgres -c "createuser fox"
su - postgres -c "createdb -O fox fox"

#mv config.php-dist config.php
#echo "define('DB_PASS', \"$DB_PASS\")" >> config.php
