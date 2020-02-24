FROM php:7.4-apache
RUN set -ex; \
    if command -v a2enmod; then \
        a2enmod rewrite; \
    fi; \
    apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libmagickwand-dev \
        libmemcached-dev \
        zlib1g-dev \
        libzip-dev \
        less \
    && pecl install memcached-3.1.5 imagick-3.4.4 \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        exif \
        opcache \
        mysqli \
        pdo_mysql \
        zip \
    && docker-php-ext-enable memcached imagick;
COPY --chown=www-data:www-data . /var/www/html/
# Updating the apache launch for public
RUN sed -i 's/\/html/\/html\/public/g' /etc/apache2/sites-available/000-default.conf
ENV PATH "$PATH:/var/www/html/vendor/bin"
