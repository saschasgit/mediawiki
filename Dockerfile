FROM registry.access.redhat.com/ubi8/php-73:latest

USER 0
ADD app-src/mediawiki-1.36.1.tar.gz /tmp/
RUN mv /tmp/mediawiki-1.36.1 /tmp/src && \
    chown -R 1001:0 /tmp/src
RUN yum -y install php-pear php-devel
RUN pecl install igbinary igbinary-devel redis
RUN echo -e "\nextension=igbinary.so\nextension=igbinary.so\nextension=redis.so" >> /etc/php.ini
USER 1001
#COPY app-src/phpinfo.php /tmp/src

# Let the assemble script install the dependencies
RUN /usr/libexec/s2i/assemble

# Change Port to 8443
# The line for the index.php is only temporary needed for mediawiki-1.36.1.
# The reason is a bug in this version of MediaWiki that causes "Deprecated" errors on every page.
RUN sed -i "s/Listen 0.0.0.0:8080/Listen 8443/g" /etc/httpd/conf/httpd.conf && \
    sed -i "1a error_reporting(3);" /opt/app-root/src/index.php

EXPOSE 8443

# The run script uses standard ways to run the application
CMD /usr/libexec/s2i/run

