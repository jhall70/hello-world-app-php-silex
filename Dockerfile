# Use the official PHP image as the base image
FROM php:7.4-apache

# Copy the application files into the container
COPY . /var/www/html

# Set the working directory in the container
WORKDIR /var/www/html

# Install necessary PHP extensions
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    && docker-php-ext-install \
    intl \
    zip \
    && a2enmod rewrite 
    
# Install composer and run install
RUN curl -sS https://getcomposer.org/installer | php \
        && mv composer.phar /usr/local/bin/ \
        && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer
RUN composer install --prefer-source --no-interaction
ENV PATH="~/.composer/vendor/bin:./vendor/bin:${PATH}"

# Expose port 80
EXPOSE 80

# Define the entry point for the container
CMD ["apache2-foreground"]
