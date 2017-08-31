#!/bin/sh

NGROKD="/usr/local/ngrok/bin/ngrokd"
NGROKD_LOG="/var/log/ngrok/ngrokd.log"
TLSCRT_PATH="/root/ngrok/assets/server/tls/snakeoil.crt"
TLSKEY_PATH="/root/ngrok/assets/server/tls/snakeoil.key"
USER_DB_PATH="/usr/local/ngrok/db-diskv"

DOMAIN="xxx.com"
HTTPADDR=":8080"
HTTPSADDR=":8086"
TUNNELADDR=":4443"
USERMANAGEADDR=":4446"
PASSWD="111111"

$NGROKD -domain="$DOMAIN" \
		-tunnelAddr="$TUNNELADDR" \
		-httpAddr="$HTTPADDR" \
		-httpsAddr="$HTTPSADDR" \
		-userManageAddr="$USERMANAGEADDR" \
		-userDBPath="$USER_DB_PATH" \
		-tlsCrt=$TLSCRT_PATH \
		-tlsKey=$TLSKEY_PATH \
		-log-level="INFO" \
		-log=$NGROKD_LOG \
		-pass="$PASSWD" >/dev/null 2>&1 & echo $! > /var/run/ngrokd.pid

# sh /root/ngrokd_startup.sh