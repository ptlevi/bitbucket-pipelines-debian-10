FROM debian:buster-slim
MAINTAINER Damien Debin <damien.debin@smartapps.fr>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en

RUN \
 apt-get update &&\
 apt-get -y --no-install-recommends install curl wget locales apt-utils &&\
 echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen &&\
 locale-gen en_US.UTF-8 &&\
 /usr/sbin/update-locale LANG=en_US.UTF-8 &&\
 echo "mysql-server mysql-server/root_password password root" | debconf-set-selections &&\
 echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections &&\
 apt-get -y --no-install-recommends install ca-certificates gnupg git subversion openssh-client curl software-properties-common gettext zip unzip default-mysql-server default-mysql-client apt-transport-https python python3 perl memcached make &&\
 bash - &&\
 wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - &&\
 echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.x.list &&\
 apt-get update &&\
 apt-get -y --no-install-recommends install php8.1-apcu php8.1-bcmath php8.1-cli php8.1-curl php8.1-gd php8.1-gettext php8.1-intl php8.1-mbstring php8.1-mysql php8.1-pgsql php8.1-sqlite3 php8.1-xml php8.1-zip php8.1-memcached php8.1-redis &&\
 apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /var/log/*

RUN \
 sed -ri -e "s/^variables_order.*/variables_order=\"EGPCS\"/g" /etc/php/8.1/cli/php.ini &&\
 echo "\nmemory_limit=-1" >> /etc/php/8.1/cli/php.ini

RUN \
 curl -sSL https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin &&\
 curl -sSL https://phar.phpunit.de/phpunit.phar -o /usr/bin/phpunit  && chmod +x /usr/bin/phpunit &&\
 rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/log/*
