# TODO
# mount laravel log to external directory
# mount storage to external directory

# derived from https://blog.pusher.com/docker-for-development-laravel-php/
FROM nginx:mainline-alpine
LABEL maintainer="elman"

# set build variables
# build doesn't work without setting ARG first
ARG MYSQL_PORT=3306
ENV MYSQL_PORT $MYSQL_PORT
ARG MYSQL_DATABASE=raketa
ENV MYSQL_DATABASE $MYSQL_DATABASE
ARG MYSQL_USER=raketa
ENV MYSQL_USER $MYSQL_USER
ARG MYSQL_PASSWORD=___dummy___
ENV MYSQL_PASSWORD $MYSQL_PASSWORD
ARG LARAVEL_DOMAIN=localhost
ENV LARAVEL_DOMAIN $LARAVEL_DOMAIN
ARG LARAVEL_PORT=80
ENV LARAVEL_PORT $LARAVEL_PORT

# copy configuration
COPY start.sh /start.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf
COPY site.conf /etc/nginx/sites-available/default.conf

# install php and composer
RUN apk add --update --no-cache \
php7 \
php7-fpm \
php7-pdo \
php7-pdo_mysql \
php7-mcrypt \
php7-mbstring \
php7-xml \
php7-openssl \
php7-json \
php7-phar \
php7-zip \
php7-dom \
php7-session \
php7-fileinfo \
php7-tokenizer \
php7-xmlwriter \
php7-zlib && \
php7 -r "copy('http://getcomposer.org/installer', 'composer-setup.php');" && \
php7 composer-setup.php --install-dir=/usr/bin --filename=composer && \
php7 -r "unlink('composer-setup.php');" && \
ln -s /etc/php7/php.ini /etc/php7/conf.d/php.ini

# install additional packages
RUN apk add --update --no-cache \
bash \
git \
openssh-client \
sudo \
supervisor

# download wait-for-it script
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /wait-for-it.sh

# create nginx folders and link configuration
RUN mkdir -p /etc/nginx && \
mkdir -p /etc/nginx/sites-available && \
mkdir -p /etc/nginx/sites-enabled && \
mkdir -p /run/nginx && \
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf && \
mkdir -p /var/log/supervisor && \
rm -Rf /var/www/* && \
chmod 755 /start.sh /wait-for-it.sh

# configure php
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" \
-e "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" \
/etc/php7/php.ini && \
sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" \
-e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" \
-e "s/user = nobody/user = nginx/g" \
-e "s/group = nobody/group = nginx/g" \
-e "s/;listen.mode = 0660/listen.mode = 0666/g" \
-e "s/;listen.owner = nobody/listen.owner = nginx/g" \
-e "s/;listen.group = nobody/listen.group = nginx/g" \
-e "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" \
-e "s/^;clear_env = no$/clear_env = no/" \
/etc/php7/php-fpm.d/www.conf

# clone application under user nginx
WORKDIR /var/www
RUN chown nginx:nginx /var/www
USER nginx
RUN git clone https://github.com/rvolny/raketa.git

# configure application
COPY .env /var/www/raketa/.env
RUN sed -i -e "s/___MYSQL_PORT___/$MYSQL_PORT/g" \
-e "s/___MYSQL_DATABASE___/$MYSQL_DATABASE/g" \
-e "s/___MYSQL_USER___/$MYSQL_USER/g" \
-e "s/___MYSQL_PASSWORD___/$MYSQL_PASSWORD/g" \
-e "s/___LARAVEL_DOMAIN___/$LARAVEL_DOMAIN/g" \
-e "s/___LARAVEL_PORT___/$LARAVEL_PORT/g" \
/var/www/raketa/.env

# install application
WORKDIR /var/www/raketa
RUN mkdir /var/www/raketa/bootstrap/cache && \
composer install

# expose running port
EXPOSE 443 80

# start application
USER root
CMD ["/start.sh"]
