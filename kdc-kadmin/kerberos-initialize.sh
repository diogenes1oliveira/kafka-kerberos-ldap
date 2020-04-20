#!/usr/bin/env bash

# this script was adapted from https://github.com/ist-dsi/docker-kerberos

set -euo pipefail

export KADMIN_PRINCIPAL_FULL="${KADMIN_PRINCIPAL}@${KERBEROS_REALM}"
export KDC_KADMIN_SERVER="kdc-kadmin.${KERBEROS_REALM}"

function info {
	awk -v prefix="# (${1:-INFO}): " '{ print prefix $0 }' >&2
}

echo "KADMIN_PRINCIPAL_FULL: ${KADMIN_PRINCIPAL_FULL}" | info
echo "KADMIN_PASSWORD: ${KADMIN_PASSWORD}" | info
echo "KDC_KADMIN_SERVER: ${KDC_KADMIN_SERVER}" | info

cat > /etc/krb5.conf <<EOF
[libdefaults]
	default_realm = ${KERBEROS_REALM}

[realms]
	${KERBEROS_REALM} = {
		kdc_ports = 88,750
		kadmind_port = 749
		kdc = ${KDC_KADMIN_SERVER}
		admin_server = ${KDC_KADMIN_SERVER}
	}
EOF

mkdir -p /etc/krb5kdc

cat > /etc/krb5kdc/kdc.conf <<EOF
[realms]
	${KERBEROS_REALM} = {
		acl_file = /etc/krb5kdc/kadm5.acl
		max_renewable_life = 7d 0h 0m 0s
		supported_enctypes = ${SUPPORTED_ENCRYPTION_TYPES}
		default_principal_flags = +preauth
	}
EOF

cat > /etc/krb5kdc/kadm5.acl <<EOF
${KADMIN_PRINCIPAL_FULL} *
noPermissions@${KERBEROS_REALM} X
EOF

echo "generating master password" | info
MASTER_PASSWORD="$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1 || true)"

if [ -z "${MASTER_PASSWORD}" ]; then
	echo "couldn't generate master password, check if /dev/urandom has enough entropy" | info 'ERROR'
	exit 1
fi

echo "MASTER_PASSWORD=${MASTER_PASSWORD}" | info

(kdb5_util create -s 2>&1 | info 'kdb5_util') <<EOF
${MASTER_PASSWORD}
${MASTER_PASSWORD}
EOF

kadmin.local -q "delete_principal -force ${KADMIN_PRINCIPAL_FULL}" 2>&1 | info 'kadmin'
kadmin.local -q "addprinc -pw ${KADMIN_PASSWORD} ${KADMIN_PRINCIPAL_FULL}" 2>&1 | info 'kadmin'

kadmin.local -q "delete_principal -force noPermissions@${KERBEROS_REALM}" 2>&1 | info 'kadmin'
kadmin.local -q "addprinc -pw ${KADMIN_PASSWORD} noPermissions@${KERBEROS_REALM}" 2>&1 | info 'kadmin'

mkdir -p /var/lib/krb5kdc
cat > /var/lib/krb5kdc/kadm5.acl <<EOF
*/admin@${KERBEROS_REALM} *
EOF

echo "Kerberos initialized" | info
