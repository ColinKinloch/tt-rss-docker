FROM alpine:edge
MAINTAINER Colin Kinloch <colin@kinlo.ch>

# Enable edge/testing repo (for php7-fileinfo)
RUN echo "http://nl.alpinelinux.org/alpine/edge/testing" \
    >> /etc/apk/repositories

# Install packages
RUN apk add --no-cache php7 php7-fpm
RUN apk add --no-cache postgresql php7-pgsql
RUN apk add --no-cache nginx
RUN apk add --no-cache php7-fileinfo php7-json php7-xml php7-mbstring php7-dom \
    php7-curl php7-posix php7-gd php7-iconv php7-intl php7-session php7-pcntl

# Install setup packages
RUN apk add --no-cache curl

# Install tt-rss
WORKDIR /usr/share/nginx/html
RUN curl -SL \
    https://tt-rss.org/gitlab/fox/tt-rss/repository/archive.tar.gz?ref=17.4 \
    | tar xzC /usr/share/nginx/html --strip-components 1

# Remove setup packages
RUN apk del curl

ADD nginx.conf /etc/nginx/

RUN mkdir -p /run/nginx

EXPOSE 80

ENV LANG en_GB.utf8
ENV PGDATA /var/lib/postgresql/tt-rss
VOLUME $PGDATA


RUN mkdir -p $PGDATA && chown -R postgres:postgres /var/lib/postgresql
RUN mkdir -p /run/postgresql && chown -R postgres:postgres /run/postgresql

RUN mkdir -p /var/lib/nginx && chown -R nginx:www-data /var/lib/nginx
RUN mkdir -p /var/log/nginx && chown -R nginx:www-data /var/log/nginx

# TODO: PGDATA volume

ADD run.sh .
ADD install.sh .

USER postgres

RUN pg_ctl initdb -D $PGDATA && \
    pg_ctl start -D $PGDATA

USER root

#ADD config.php .
RUN chmod 777 .
RUN chmod -R 777 cache
RUN chmod -R 777 feed-icons
RUN chmod -R 777 lock

# Change user

CMD ./run.sh
