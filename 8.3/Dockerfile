FROM php:8.3-fpm

LABEL repository="https://github.com/jaxwilko/php-fpm-node-chrome-docker"
LABEL homepage="https://github.com/jaxwilko/php-fpm-node-chrome-docker"
LABEL maintainer="Jack Wilkinson <me@jackwilky.com>"

ARG UID=1000
ARG GID=1000

# download and set ext installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# install required php exts
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions imagick gd intl zip pcntl exif pdo_mysql \
    && rm /usr/local/bin/install-php-extensions

# install composer from composer image
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# install curl
RUN apt-get update \
    && apt-get install -y curl

# install node deps
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh

# install chrome
RUN npx @puppeteer/browsers install chrome@stable --install-deps \
    && npx @puppeteer/browsers install chromedriver@stable     

RUN ln -s $(realpath $(find ./chrome -type f -name "chrome" -print -quit)) /usr/local/bin/chrome \
    && ln -s $(realpath $(find ./chromedriver -type f -name "chromedriver" -print -quit)) /usr/local/bin/chromedriver

# clean up
RUN fc-cache -f -v && \
  apt-get -qq clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure user
RUN usermod -u $UID www-data \
    && groupmod -g $GID www-data \
    && usermod -aG staff,audio,video www-data

# Define a user home
RUN mkdir -p /home/www-data  \
    && usermod -d /home/www-data www-data \
    && chown -R www-data:www-data /home/www-data
