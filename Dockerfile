FROM registry.access.redhat.com/ubi8/ubi:8.4

ENV USER_NAME=www-data \
    USER_UID=1001 \
    BASE_DIR=/home/www-data \
    PHP=71 \
    HOME=${BASE_DIR}

RUN yum -y install httpd \
  && yum clean all

EXPOSE 8080
USER ${USER_UID}
