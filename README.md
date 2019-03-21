# php-fpm

````bash
# !Dockerfile
FROM hub.irontec.com/internet/dockerfiles/php-fpm/php-fpm:latest

ADD ini/redis-session.init /usr/local/etc/php/conf.d/redis-session.init

# !redis-session.init
# session.save_handler = redis
# session.save_path    = "tcp://redis:6379?database=10"

# Install Symfony
RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN export PATH="$HOME/.symfony/bin:$PATH" && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

ADD --chown=docker:docker ./symfony/ /opt/symfony/

WORKDIR /opt/symfony

RUN composer install

````
