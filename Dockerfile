FROM php:8.1-fpm

LABEL repository="https://github.com/jaxwilko/pfnc-docker"
LABEL homepage="https://github.com/jaxwilko/pfnc-docker"
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

# install curl & gnupg
RUN apt-get update \
    && apt-get install -y curl gnupg xvfb ffmpeg

# set the chrome repo
RUN curl -sL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# install chrome
RUN apt-get update \
    && apt-get install -y google-chrome-stable

# install node deps
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh

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