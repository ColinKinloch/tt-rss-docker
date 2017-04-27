#!/usr/bin/env sh

su - postgres -c "PGDATA=${PGDATA} pg_ctl start"
sleep 1
./install.sh

#su - www -c "php-fpm7 -F" -s /bin/sh
nginx
php-fpm7 -F

php ./update_daemon2.php
