FROM php:7.2-alpine

WORKDIR /var/www/html

RUN apk add --no-cache \
        git \
        curl \
        unzip \
        libzip-dev \
        && docker-php-ext-install zip pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 8000

COPY . .
RUN composer update
RUN php artisan key:generate
RUN chmod a+x setup.sh