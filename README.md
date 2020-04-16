# kafka-kerberos-ldap

A Docker stack for a Kafka cluster, complete with Kerberos and LDAP
authentication

> :warning: **This code is definitely not production-ready!** Use it only for
> local development.

## Using

The components are organized in several Docker Compose files, which can be
deployed separately using the `-f` flag in `docker-compose` .

You can also use the Makefile that is provided for convenience:

``` sh
$ make compose/up  # run
$ make compose/rm  # destroy
```

