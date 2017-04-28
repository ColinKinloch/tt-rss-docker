FROM alpine:edge
MAINTAINER Colin Kinloch <colin@kinlo.ch>

ENV TTRSS_VERSION 17.4

# Enable edge/testing repo (for php7-fileinfo)
RUN echo "http://nl.alpinelinux.org/alpine/edge/testing" \
    >> /etc/apk/repositories

# Install packages
RUN apk add --no-cache nginx
RUN apk add --no-cache php7 php7-fpm php7-fileinfo php7-json php7-xml \
    php7-mbstring php7-dom php7-curl php7-posix php7-gd php7-iconv php7-intl \
    php7-session php7-pcntl php7-pgsql

# Install setup packages
RUN apk add --no-cache --virtual .build-deps curl

# Install tt-rss
WORKDIR /usr/share/nginx/html
RUN curl -SL \
    https://tt-rss.org/gitlab/fox/tt-rss/repository/archive.tar.gz?ref=$TTRSS_VERSION \
    | tar xzC /usr/share/nginx/html --strip-components 1

ADD nginx.conf /etc/nginx/

RUN mkdir -p /run/nginx

EXPOSE 80

RUN mkdir -p /var/lib/nginx && chown -R nginx:www-data /var/lib/nginx
RUN mkdir -p /var/log/nginx && chown -R nginx:www-data /var/log/nginx

RUN chmod 777 .
RUN chmod -R 777 cache
RUN chmod -R 777 feed-icons
RUN chmod -R 777 lock

# Remove setup packages
RUN apk del .build-deps

# Create user for update_daemon2
RUN adduser -S tt-rss

# TODO: config.php must be generated per installation and database must be initialized
#ADD config.php .
ADD run.sh .

CMD ./run.sh
