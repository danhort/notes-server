FROM php:7.3.5-fpm
     
RUN apt-get update && apt-get install -y libmcrypt-dev git \
    mysql-client libmagickwand-dev --no-install-recommends \
    && pecl install imagick mcrypt-1.0.2 \
    && docker-php-ext-enable imagick mcrypt \
    && docker-php-ext-install pdo_mysql

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# install latest version of nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

# Set www-data user permissions
RUN chmod 777 -Rf /var/www /var/www/.* \
	&& chown -Rf www-data:www-data /var/www /var/www/.* \
    && usermod -u 1000 www-data

WORKDIR /var/www