#!/usr/bin/env bash
set -euo pipefail

# this script was adapted from https://github.com/ist-dsi/docker-kerberos

export KADMIN_PRINCIPAL="${KADMIN_PRINCIPAL:-kadmin/admin}"
export KADMIN_PRINCIPAL_FULL="${KADMIN_PRINCIPAL}@${KERBEROS_REALM}"
export KDC_KADMIN_SERVER="kdc-kadmin.${KERBEROS_REALM}"

cat > /etc/krb5.conf <<EOF
[libdefaults]
	default_realm = ${KERBEROS_REALM}

[realms]
	${KERBEROS_REALM} = {
		kdc = ${KDC_KADMIN_SERVER}
		admin_server = ${KDC_KADMIN_SERVER}
	}
EOF
