FROM php:fpm-alpine

RUN apk add --no-cache \
        zlib \
        libjpeg-turbo-dev \
        libpng-dev \
        freetype-dev \
        libmcrypt-dev \
		openssl-dev

RUN docker-php-ext-configure gd \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2

RUN	docker-php-ext-install gd \
                    pdo_mysql \
                    zip \
                    opcache

RUN apk add --no-cache --virtual .build-deps \
        autoconf \
		g++ \
		gcc \
		make \
    && pecl install mcrypt-1.0.1 \ 
	&& docker-php-ext-enable mcrypt \
    && apk del .build-deps

RUN apk add --no-cache --virtual .build-deps \
        autoconf \
		g++ \
		gcc \
		make \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && apk del .build-deps

ADD ./opcache.ini /usr/local/etc/php/conf.d/  
ADD ./php.ini /usr/local/etc/php/conf.d
ADD ./www.conf /usr/local/etc/php-fpm.d/www.conf