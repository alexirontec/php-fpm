# php-fpm

````bash
# !Dockerfile
FROM hub.irontec.com/internet/dockerfiles/php-fpm/php-fpm:latest

# Xdebug
ARG XDEBUG=false
USER root
RUN if [ "${XDEBUG}" = "true" ] ; then /dev/null ; pecl install xdebug; docker-php-ext-enable xdebug; fi
ADD ini/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Redis Session
ADD ini/redis-session.init /usr/local/etc/php/conf.d/redis-session.init

# !redis-session.init
# session.save_handler = redis
# session.save_path    = "tcp://redis:6379?database=10"

USER docker

# Install Symfony
RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN export PATH="$HOME/.symfony/bin:$PATH" && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

ADD --chown=docker:docker ./symfony/ /opt/symfony/

WORKDIR /opt/symfony

RUN [ -f composer.json ] && '' || composer create-project symfony/skeleton .

````
