#!/bin/sh
#
# 梅林路由固件 穿透DDNS 守护进程脚本
#

filename=$(basename $0)
ACTION=$1

onstart() {
  while true; do
    sleep 2m
    if [ $(ps | grep -v grep | grep -w tunnel | wc -l) -eq 0 ] ; then
      eval `dbus export tunnel_`
      en=$tunnel_enable

      if [ "$en" == "1" ]; then
        echo "ddns tunnel is offline, and restart it!"
        /koolshare/scripts/config-tunnel.sh start
      fi
    fi
  done
}

onstop() {
  killall $filename
}

case $ACTION in
start)
  D_COUNT=$(ps | grep -v grep | grep -w $filename | wc -l)
  if [ $D_COUNT -gt 2 ] ; then
    echo "$filename already running"
  else
    echo "start tunnel daemon"
    onstart >/dev/null 2>&1 &
  fi
  ;;
stop)
  echo "stop tunnel daemon"
  onstop
  ;;
*)
  echo "Usage: $filename (start|stop)"
  exit 1
  ;;
esac
