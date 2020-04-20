#!/usr/bin/expect -f

set timeout -1

spawn docker-compose -f docker-compose.kerberos.yml exec kerberos-client ktutil

expect "ktutil: "
send -- "add_entry -password -p zookeper/zookeper.localhost@localhost -k 1 -e aes256-cts-hmac-sha1-96\r"
expect "Password "
send -- "password\r"

expect "ktutil: "
send -- "add_entry -password -p zookeper/zookeper.localhost@localhost -k 1 -e aes128-cts-hmac-sha1-96\r"
expect "Password "
send -- "password\r"

expect "ktutil: "
send -- "wkt /tmp/my-my-my\r"

expect "ktutil: "
send -- "quit\r"
expect eof
