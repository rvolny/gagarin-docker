# derived from https://github.com/laradock/laradock/tree/master/mysql
ARG MYSQL_VERSION=latest
FROM mysql:${MYSQL_VERSION}
LABEL maintainer="elman"

# set build variables
# build doesn't work without setting ARG first
ARG MYSQL_DATABASE=raketa
ENV MYSQL_DATABASE $MYSQL_DATABASE
ARG MYSQL_USER=raketa
ENV MYSQL_USER $MYSQL_USER
ARG MYSQL_PASSWORD=___dummy___
ENV MYSQL_PASSWORD $MYSQL_PASSWORD

# set timezone
ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && chown -R mysql:root /var/lib/mysql/

# copy configuration files
# mounting of docker-entrypoint-initdb.d is not used because we need to replace passwords
COPY my.cnf /etc/mysql/conf.d/my.cnf
COPY docker-entrypoint-initdb.d/createdb.sql /docker-entrypoint-initdb.d/createdb.sql

# configure init script
RUN sed -i -e "s/___MYSQL_DATABASE___/$MYSQL_DATABASE/g" \
-e "s/___MYSQL_USER___/$MYSQL_USER/g" \
-e "s/___MYSQL_PASSWORD___/$MYSQL_PASSWORD/g" \
/docker-entrypoint-initdb.d/createdb.sql

CMD ["mysqld"]

EXPOSE 3306
