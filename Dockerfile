FROM registry.access.redhat.com/ubi8/php-73:latest

USER 0
ADD app-src/mediawiki-1.36.1.tar.gz /tmp/
RUN mv /tmp/mediawiki-1.36.1 /tmp/src && \
    chown -R 1001:0 /tmp/src
#COPY app-src/php.ini /etc/php.ini
COPY app-src/50-igbinary.ini /etc/php.d/
COPY app-src/50-redis.ini /etc/php.d/
RUN yum -y install php-pear php-devel
RUN pear config-set php_ini /etc/php.ini
RUN pecl install igbinary igbinary-devel redis
USER 1001
#COPY app-src/phpinfo.php /tmp/src

# Let the assemble script install the dependencies
RUN /usr/libexec/s2i/assemble

# Change Port to 8443
# The line for the index.php is only temporary needed for mediawiki-1.36.1.
# The reason is a bug in this version of MediaWiki that causes "Deprecated" errors on every page.
RUN sed -i "s/Listen 0.0.0.0:8080/Listen 8443/g" /etc/httpd/conf/httpd.conf && \
    sed -i "1a error_reporting(3);" /opt/app-root/src/index.php
RUN sed -i "s/\$wgHttpsPort = 443;/\$wgHttpsPort = 8443;/g" /opt/app-root/src/includes/DefaultSettings.php

EXPOSE 8443

# The run script uses standard ways to run the application
CMD /usr/libexec/s2i/run

