FROM nextcloud:fpm-alpine

# Update the container
RUN apk -U upgrade

RUN apk add --no-cache --virtual .build-deps autoconf automake file g++ gcc make php8-dev re2c samba-dev zlib-dev;

RUN apk add --no-cache libsmbclient;
RUN pecl install smbclient;
RUN docker-php-ext-enable smbclient;

RUN apk add --no-cache imagemagick; 

# Install cron support
RUN apk add --no-cache supervisor
RUN mkdir /var/log/supervisord /var/run/supervisord
COPY supervisord.conf /

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]

RUN apk del .build-deps
