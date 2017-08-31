#!/bin/sh

NGROK_PATH="/root/ngrok"
NGROK_INSTALL_PATH="/usr/local/ngrok"

# default ssl cert
HTTPS_CERT_PATH="/root/https_cert"
NGROKROOT_CRT_PATH="${HTTPS_CERT_PATH}/ngrokroot.crt"
SNAKEOIL_CRT_PATH="/etc/nginx/ssl/jasio.me/fullchain.pem"
SNAKEOIL_KEY_PATH="/etc/nginx/ssl/jasio.me/key.pem"

# curl -o $NGROKROOT_CRT_PATH https://letsencrypt.org/certs/letsencryptauthorityx1.pem
curl -o ${NGROKROOT_CRT_PATH} https://letsencrypt.org/certs/letsencryptauthorityx3.pem

yes | cp -rf ${NGROKROOT_CRT_PATH} ${NGROK_PATH}/assets/client/tls/ngrokroot.crt -f
yes | cp -rf ${SNAKEOIL_CRT_PATH} ${NGROK_PATH}/assets/server/tls/snakeoil.crt -f
yes | cp -rf ${SNAKEOIL_KEY_PATH} ${NGROK_PATH}/assets/server/tls/snakeoil.key -f


cd $NGROK_PATH

echo "make clean"
make clean

# 编译生成 ngrokd 服务端
echo "start build server"
GOOS="linux" GOARCH="amd64" make release-server

[ ! -d /var/log/ngrok ] && mkdir -p /var/log/ngrok
[ ! -d ${NGROK_INSTALL_PATH}/db-diskv/ng/ro/ ] && mkdir -p ${NGROK_INSTALL_PATH}/db-diskv/ng/ro/
[ ! -d ${NGROK_INSTALL_PATH}/bin/ ] && mkdir -p ${NGROK_INSTALL_PATH}/bin/
yes | cp -rf ${NGROK_PATH}/bin/ngrokd ${NGROK_INSTALL_PATH}/bin/ngrokd -f
[ ! -x ${NGROK_INSTALL_PATH}/bin/ngrokd ] && chmod 755 ${NGROK_INSTALL_PATH}/bin/ngrokd

# cp ${NGROK_PATH}/ngrokd_config.sh ${NGROK_INSTALL_PATH}/ngrokd_config.sh
# [ ! -x ${NGROK_INSTALL_PATH}/ngrokd_config.sh ] && chmod 500 ${NGROK_INSTALL_PATH}/ngrokd_config.sh
# [ ! -f /etc/init.d/ngrokd ] && cp ${NGROK_PATH}/ngrokd.init /etc/init.d/ngrokd
# ! -x /etc/init.d/ngrokd ] && chmod 755 /etc/init.d/ngrokd
# [ -s /etc/init.d/ngrokd ] && ln -s /etc/init.d/ngrokd /usr/bin/ngrokd


# 编译生成 ngrok mac客户端
#echo "start build macos client"
#GOOS="darwin" GOARCH="amd64" make release-client

# 编译生成 ngrok windows客户端
#echo "start build windows client"
#GOOS="windows" GOARCH="amd64" make release-client

echo "Done~~~~"
