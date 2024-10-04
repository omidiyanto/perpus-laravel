FROM php:7.2

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
        git \
        unzip \
        libzip-dev \
        && docker-php-ext-install zip pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 8000

COPY . .
RUN composer update
RUN php artisan key:generate
RUN chmod a+x setup.sh


