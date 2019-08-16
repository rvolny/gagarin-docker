FROM nginx:mainline-alpine
LABEL maintainer="elman"

# set build variables
# build doesn't work without setting dummy ARG first
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV
ARG MDBVUE_PASSWORD=___dummy___
ENV MDBVUE_PASSWORD $MDBVUE_PASSWORD

# copy configuration files
COPY start.sh /start.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf
COPY site.conf /etc/nginx/sites-available/default.conf

# install nodejs and additional packages
RUN apk add --update --no-cache \
nodejs \
npm \
bash \
git \
openssh-client \
supervisor

# create nginx folders and link configuration
RUN mkdir -p /etc/nginx && \
mkdir -p /etc/nginx/sites-available && \
mkdir -p /etc/nginx/sites-enabled && \
mkdir -p /run/nginx && \
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf && \
mkdir -p /var/log/supervisor && \
rm -Rf /var/www/* && \
chmod 755 /start.sh

# clone application
WORKDIR /var/www
RUN git clone https://github.com/rvolny/gagarin.git
WORKDIR /var/www/gagarin

# replace secrets
RUN sed -i "s/\$PASSWORD/$MDBVUE_PASSWORD/g" \
/var/www/gagarin/package.json

# install application
RUN NODE_ENV=testing npm install
#RUN NODE_ENV=$NODE_ENV npm run build

# expose running port
EXPOSE 443 80

# start application
CMD ["/start.sh"]
