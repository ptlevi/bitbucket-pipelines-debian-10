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
 apt-get -y --no-install-recommends install ca-certificates gnupg git subversion openssh-client curl software-properties-common gettext zip unzip default-mysql-server default-mysql-client apt-transport-https memcached make perl &&\
 wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - &&\
 echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php8.x.list &&\
 apt-get update &&\
 apt-get -y --no-install-recommends install php8.0-apcu php8.0-bcmath php8.0-cli php8.0-curl php8.0-gd php8.0-gettext php8.0-intl php8.0-mbstring php8.0-mysql php8.0-pgsql php8.0-sqlite3 php8.0-xml php8.0-zip php8.0-memcached php8.0-redis &&\
 apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /var/log/*

RUN \
 sed -ri -e "s/^variables_order.*/variables_order=\"EGPCS\"/g" /etc/php/8.0/cli/php.ini &&\
 echo "\nmemory_limit=-1" >> /etc/php/8.0/cli/php.ini

RUN \
 curl -sSL https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin &&\
 curl -sSL https://phar.phpunit.de/phpunit.phar -o /usr/bin/phpunit  && chmod +x /usr/bin/phpunit &&\
 rm -rf /root/.npm /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/log/*

RUN \
 curl -sL https://deb.nodesource.com/setup_14.x | bash - &&\
 apt-get -y install nodejs
