#!/bin/bash
initFile=/usr/lib/systemd/system/etcd.service
user=$(cat /usr/lib/systemd/system/etcd.service | grep User | cut -d "=" -f2)

if [ -s "$initFile" ];then
  if [ "$user" != 'root' ];then
    sed -i 's/'User=etcd'/'User=root'/g' $initFile
    systemctl daemon-reload
    echo "etcd user changed to root and daemon-reload done"
  fi
fi
