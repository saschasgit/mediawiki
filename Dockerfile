FROM openshift/ubi:8.0

ENV USER_NAME=www-data \
    USER_UID=1001 \
    BASE_DIR=/home/www-data \
    PHP=71 \
    HOME=${BASE_DIR}

RUN yum -y install mediawiki httpd \
  && yum clean all

EXPOSE 8080
USER ${USER_UID}
