FROM registry.access.redhat.com/ubi8/ubi:8.4

# DocumentRoot for Apache
ENV DOCROOT=/var/www/html

RUN yum install -y --nodocs --disableplugin=subscription-manager httpd && \
    yum clean all --disableplugin=subscription-manager -y




#ENV USER_NAME=www-data \
#    USER_UID=1001 \
#    BASE_DIR=/home/www-data \
#    PHP=74 \
#    HOME=${BASE_DIR}

#RUN yum -y install httpd \
#  && yum clean all

EXPOSE 8080

LABEL io.openshift.expose-services="8080:hhtp"
LABEL io.k8s.description="Apache als Basis für das Mediawiki" \
      io.k8s.display-name="Apache HTTP server" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="apache, http"

RUN rm -rf /run/httpd && mkdir /run/httpd

RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf

RUN chgrp -R 0 /var/log/httpd /var/run/httpd && \
    chmod -R g=u /var/log/httpd /var/run/httpd

USER 1001

CMD /usr/sbin/httpd -DFOREGROUND


