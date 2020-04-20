FROM alpine:3.11

RUN apk add --no-cache \
      bash=5.0.11-r1 \
      krb5=1.17.1-r0 \
      expect=5.45.4-r0 \
      util-linux=2.34-r1

ENV KERBEROS_REALM ${KERBEROS_REALM:-localhost}
ENV SUPPORTED_ENCRYPTION_TYPES ${SUPPORTED_ENCRYPTION_TYPES:-aes256-cts-hmac-sha1-96:normal}
ENV KADMIN_PRINCIPAL ${KADMIN_PRINCIPAL:-kadmin/admin}
ENV KADMIN_PASSWORD ${KADMIN_PASSWORD:-password}

COPY ./kerberos-initialize.sh /bin/kerberos-initialize
COPY ./kerberos-as-admin.sh /bin/kerberos-as-admin
COPY ./create-keytab.sh /bin/create-keytab
COPY ./docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
