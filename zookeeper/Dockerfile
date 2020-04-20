FROM confluentinc/cp-zookeeper:5.4.1

COPY ./wait-success.sh /bin/wait-success
COPY ./zookeeper_jaas.conf /etc/zookeeper_jaas.conf

WORKDIR /etc/security/keytabs

COPY ./docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/etc/confluent/docker/run" ]
