#!/usr/bin/env sh

nginx
php-fpm7 --daemonize
until su tt-rss -s /bin/sh -c "php ./update_daemon2.php" ; do
    echo "update_daemon2 stopped"
    sleep 10
    echo "starting update_daemon2"
done
