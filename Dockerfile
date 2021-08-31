FROM registry.access.redhat.com/ubi8/php-73:latest

USER 0
ADD app-src/mediawiki-1.36.1.tar.gz /tmp/
RUN mv /tmp/mediawiki-1.36.1 /tmp/src && \
    chown -R 1001:0 /tmp/src
# The following copy is only temporary needed.
# The reason is a bug in the actual version of MediaWiki that causes "Deprecated" errors on every page.
# Therefore in the php.ini the value for "error-reporting" has altered from 
# "error_reporting = E_ALL & ~E_NOTICE" to "error_reporting = E_ALL & ~E_NOTICE & ~E_DEPRECATED"
COPY app-src/php.ini /etc/
USER 1001

#Download Mediawiki and copy to target folder
#RUN cd /tmp && \
#    curl https://releases.wikimedia.org/mediawiki/1.36/mediawiki-1.36.1.tar.gz --output mediawiki.tar.gz && \
#    tar -xzf mediawiki.tar.gz && \
#    rm -f /tmp/mediawiki.tar.gz && \
#    cp -R /tmp/mediawiki-1.36.1/* /tmp/src/

# Let the assemble script install the dependencies
RUN /usr/libexec/s2i/assemble

RUN sed -i "/Listen 0.0.0.0:8080/aListen 8443" /etc/httpd/conf/httpd.conf
#USER 0
#RUN sed -i "s/error_reporting = E_ALL & ~E_NOTICE/error_reporting = E_ALL \& \~E_NOTICE \& \~E_DEPRECATED/g" /etc/php.ini && \
#    echo $?
#USER 1001

EXPOSE 8080
EXPOSE 8443

# The run script uses standard ways to run the application
CMD /usr/libexec/s2i/run

# DocumentRoot for Apache
# ENV DOCROOT=/var/www/html

#RUN yum update && \
#    yum install -y --nodocs --disableplugin=subscription-manager httpd && \
#    yum clean all --disableplugin=subscription-manager -y

#ENV USER_NAME=www-data \
#    USER_UID=1001 \
#    BASE_DIR=/home/www-data \
#    PHP=74 \
#    HOME=${BASE_DIR}

#EXPOSE 8080
#EXPOSE 8443

#RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf

#Download Mediawiki and copy to target folder
#RUN cd /tmp && \
#    curl https://releases.wikimedia.org/mediawiki/1.36/mediawiki-1.36.1.tar.gz --output mediawiki.tar.gz && \
#    tar -xzf mediawiki.tar.gz && \
#    rm -f /tmp/mediawiki.tar.gz && \
#    cp -R /tmp/mediawiki-1.36.1/* /var/www/html
#    echo "Hallo" > /var/www/html/index.html

#USER 1001

#CMD /usr/sbin/httpd -DFOREGROUND