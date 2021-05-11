ARG PHP_VERSION=7.3.3

FROM php:${PHP_VERSION}

ARG UID=1000
ARG GID=1000

RUN apt update && \
    apt upgrade --yes && \
    apt autoremove --yes && \
    apt remove --yes mysql* mariadb* && \
    apt autoremove --yes && \

# Install required dependencies
    apt install --yes --no-install-suggests --no-install-recommends \
        apt-transport-https apt-utils ccze curl git gnupg libonig-dev unzip openssl sudo tree wget vim libldap2-dev libaio-dev libxml2-dev xfonts-75dpi fontconfig libjpeg62-turbo libxrender1 xfonts-base && \
    apt install --yes --no-install-suggests --no-install-recommends \
        libpq-dev libxslt-dev librabbitmq-dev libssh-dev && \

# Install MySQL 
    echo "deb http://repo.mysql.com/apt/debian/ stretch mysql-5.7\n\
deb-src http://repo.mysql.com/apt/debian/ stretch mysql-5.7" >> /etc/apt/sources.list.d/mysql.list && \

    wget -O /tmp/RPM-GPG-KEY-mysql https://repo.mysql.com/RPM-GPG-KEY-mysql && \
    apt-key add /tmp/RPM-GPG-KEY-mysql && \
    apt update && apt --yes upgrade && \

# Install dependencies for the image processing
    apt install --yes --no-install-suggests --no-install-recommends \
        libfreetype6-dev libjpeg-dev libpng-dev && \

# Others
    apt install --yes --no-install-suggests --no-install-recommends \
        libicu-dev libmcrypt-dev libzip-dev zlib1g-dev mysql-client && \

# MySQL PDO
    docker-php-ext-configure pdo_mysql --with-pdo-mysql && \
    docker-php-ext-install   pdo_mysql && \

# Pgsql PDO

    docker-php-ext-configure pdo_pgsql --with-pdo-pgsql && \
    docker-php-ext-install   pdo pdo_pgsql && \

# Mbstring
    docker-php-ext-configure mbstring --enable-mbstring=all && \
    docker-php-ext-install   mbstring && \

# GD
#    docker-php-ext-configure gd --enable-gd-native-ttf --with-jpeg-dir=/usr/lib --with-freetype-dir=/usr/include/ && \
#    docker-php-ext-install   gd && \
    docker-php-ext-configure gd && \
    docker-php-ext-install   gd && \

# intl
    docker-php-ext-configure intl && \
    docker-php-ext-install   intl && \

    docker-php-ext-install iconv           && \
    docker-php-ext-install mysqli          && \
    docker-php-ext-install opcache         && \
    docker-php-ext-install zip             && \
    docker-php-ext-install bcmath          && \
    docker-php-ext-install xsl             && \
    docker-php-ext-install ldap            && \
    docker-php-ext-install -j$(nproc) soap && \

# Pecl update
    pecl update-channels && \

# Imagick
    apt install --yes --no-install-suggests --no-install-recommends libmagickwand-dev && \
    pecl install imagick          && \
    docker-php-ext-enable imagick && \

# Redis
    pecl install redis          && \
    docker-php-ext-enable redis && \

# AMQP
    pecl install amqp          && \
    docker-php-ext-enable amqp && \

# Limpiar todo
    apt autoremove --yes && apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/pear ~/.pearrc

# tzdata
RUN unlink /etc/localtime; ln -s /usr/share/zoneinfo/UTC /etc/localtime; dpkg-reconfigure -f noninteractive tzdata

# añadir .ini de PHP
COPY ini/*       /usr/local/etc/php/conf.d/
COPY php-fpm.d/* /usr/local/etc/php-fpm.d/

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer --version && \
    COMPOSER_CACHE_DIR=/dev/null

RUN mkdir /home/docker \
    && groupadd -r docker -g ${GID} \
    && useradd -u ${UID} -r -g docker -d /home/docker -s /bin/bash -c "Docker user" docker \
    && echo "docker:docker" | chpasswd \
    && chown -R docker:docker /home/docker

ADD vimrc /home/docker/.vimrc

COPY docker-php-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-php-entrypoint

USER docker
RUN echo "alias ll\='ls -lh'" >> ~/.bashrc
