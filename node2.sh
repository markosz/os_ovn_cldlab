#!/bin/bash

### logging preparation
#SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WRKDIR=/tmp/git-profile-init
username=$(id -nu)
usergid=$(id -ng)

sudo mkdir -p ${WRKDIR}
sudo chown ${username}:${usergid} ${WRKDIR}/ -R

cd /tmp
exec >> ${WRKDIR}/deploy.log
exec 2>&1

### copy IP address to node1
ifconfig | grep "inet " |  awk 'NR == 1 {print $2}' > node2_ip
sudo scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null node2_ip node1:/tmp/

### fix libraries
wget https://cbs.centos.org/kojifiles/packages/leatherman/1.3.0/9.el7/x86_64/leatherman-1.3.0-9.el7.x86_64.rpm
rpm2cpio ./leatherman-1.3.0-9.el7.x86_64.rpm | cpio -idmv
sudo cp usr/lib64/leatherman* /usr/lib64/

wget ftp://ftp.pbone.net/mirror/ftp.centos.org/7.7.1908/cloud/x86_64/openstack-queens/boost159-log-1.59.0-2.el7.1.x86_64.rpm
rpm2cpio ./boost159-log-1.59.0-2.el7.1.x86_64.rpm | cpio -idmv
sudo cp usr/lib64/libboost* /usr/lib64/
