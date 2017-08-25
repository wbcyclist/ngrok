#!/bin/sh

NGROK_PATH="/root/ngrok"

# default ssl cert
HTTPS_CERT_PATH="/root/https_cert"
NGROKROOT_CRT_PATH="$HTTPS_CERT_PATH/ngrokroot.crt"
SNAKEOIL_CRT_PATH="/etc/nginx/ssl/jasio.me/fullchain.pem"
SNAKEOIL_KEY_PATH="/etc/nginx/ssl/jasio.me/key.pem"

# curl -o $NGROKROOT_CRT_PATH https://letsencrypt.org/certs/letsencryptauthorityx1.pem
curl -o $NGROKROOT_CRT_PATH https://letsencrypt.org/certs/letsencryptauthorityx3.pem

yes | cp -rf $NGROKROOT_CRT_PATH $NGROK_PATH/assets/client/tls/ngrokroot.crt -f
yes | cp -rf $SNAKEOIL_CRT_PATH $NGROK_PATH/assets/server/tls/snakeoil.crt -f
yes | cp -rf $SNAKEOIL_KEY_PATH $NGROK_PATH/assets/server/tls/snakeoil.key -f


cd $NGROK_PATH

echo "make clean"
make clean

# 编译生成 ngrokd 服务端
echo "start build server"
GOOS="linux" GOARCH="amd64" make release-server

# 编译生成 ngrok mac客户端
echo "start build macos client"
GOOS="darwin" GOARCH="amd64" make release-client

# 编译生成 ngrok windows客户端
echo "start build windows client"
GOOS="windows" GOARCH="amd64" make release-client

echo "Success~"
