FROM registry.access.redhat.com/ubi8/ubi:8.4

ENV USER_NAME=www-data \
    USER_UID=1001 \
    BASE_DIR=/home/www-data \
    PHP=74 \
    HOME=${BASE_DIR}

RUN yum -y install httpd \
  && yum clean all

EXPOSE 8080
LABEL io.openshift.expose-services="8080:hhtp"
RUN sed -i "s/Listen80/Listen 8080/g" /etc/httpd/conf/httpd.conf
USER ${USER_UID}
