#!/usr/bin/env bash

set -euo pipefail

initpath="/docker-entrypoint-init.d"

if [ -d "$initpath" ]; then
  for s in `find "$initpath" -mindepth 1 -maxdepth 1 -name '*.sh' | sort`; do
    source "$s"
  done
fi

cat > /etc/krb5.conf <<EOF
[libdefaults]
	default_realm = ${KERBEROS_REALM}

[realms]
	${KERBEROS_REALM} = {
		kdc = kdc-kadmin.${KERBEROS_REALM}
		admin_server = kdc-kadmin.${KERBEROS_REALM}
	}
EOF


wait-success cat /etc/security/keytabs/zookeeper.keytab
export KAFKA_OPTS="${KAFKA_OPTS:-} -Dsun.security.krb5.debug=true -Djava.security.auth.login.config=/var/zookeeper_jaas.conf"

perl -pe 's{\$(\{)?(\w+)(?(1)\})}{$ENV{$2} // $&}ge' \
  < /etc/zookeeper_jaas.conf > /var/zookeeper_jaas.conf

cat /var/zookeeper_jaas.conf

if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
  # no args or first arg is a flag
  exec /etc/confluent/docker/run "$@"
fi

exec "$@"
