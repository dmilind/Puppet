#!/bin/bash
source /etc/init.d/functions

DOCKER_GATEWAY=$(docker network inspect bridge | grep Gateway | sed -r 's/([^0-9]*([^0-9]*))//' | cut -d "/" -f1 | cut -d "\"" -f1)
FLANNEL_SUBNET=$(cat /run/flannel/subnet.env | grep FLANNEL_SUBNET | sed -r 's/([^0-9]*([^0-9]*))//' | cut -d "/" -f1)

if [ "$DOCKER_GATEWAY" != "$FLANNEL_SUBNET" ] ; then
	  echo "Need docker restart!"
	  systemctl restart docker
	  failure
	  echo
else
	  echo "Docker has acquired flannel subnet" > /root/checkdocker.ran
	  success
	  echo
	  
fi
