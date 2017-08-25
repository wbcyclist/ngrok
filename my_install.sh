#!/bin/sh

NGROK_DOMAIN="ngrok.xxx.com"

# 证书生成
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=$NGROK_DOMAIN" -days 5000 -out rootCA.pem

openssl genrsa -out server.key 2048
openssl req -new -key server.key -subj "/CN=$NGROK_DOMAIN" -out server.csr

openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 5000

# 覆盖git上的证书
cp rootCA.pem assets/client/tls/ngrokroot.crt -f
cp server.crt assets/server/tls/snakeoil.crt -f
cp server.key assets/server/tls/snakeoil.key -f

# 或者 使用Let's Encrypt的SSL证书


# go env // 查看环境

# make clean // 清空编译缓存

# 编译生成 ngrokd 服务端
GOOS="linux" GOARCH="amd64" make release-server

# 客户端编译成功后会在 ngrok/bin/ 生成对应的文件夹
# 编译生成 ngrok mac客户端
GOOS="darwin" GOARCH="amd64" make release-client

# 编译生成 ngrok linux客户端
GOOS="linux" GOARCH="arm" make release-client
# GOOS="linux" GOARCH="amd64" make release-client

# 编译生成 ngrok windows客户端
GOOS="windows" GOARCH="amd64" make release-client


# 服务端运行配置
./bin/ngrokd -domain=$NGROK_DOMAIN \
             -httpAddr=":8080" \
             -httpsAddr=":8086" \
             -tlsCrt=server.crt \
             -tlsKey=server.key \
             -tunnelAddr=":4443" \
             -userManageAddr=":4446" \
             -pass="111111"

# nohup ./bin/ngrokd -domain="$dns" -httpAddr=":$http_port" -pass="$pass" -httpsAddr=":$https_port" -tlsCrt=device.crt -tlsKey=device.key -tunnelAddr=":$remote_port" > z.log 2>&1 &

# nohup {your-ngrok-dir}/bin/ngrokd -domain="ngrok.your-domain.com" -httpAddr=":8777"  -httpsAddr=":8778"  > /var/log/ngrok.log &


# 客户端运行配置
# ./darwin_amd64/ngrok -config=ngrok.cfg -log=ngrok.log -subdomain=dl 
# Ngrok多个隧道
# ./darwin_amd64/ngrok -config=ngrok.cfg start tunnel1 tunnel2
./darwin_amd64/ngrok -config=ngrok.cfg -log=ngrok.log start download








