#!/bin/bash

### logging preparation
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WRKDIR=/tmp/git-profile-init
username=$(id -nu)
usergid=$(id -ng)

sudo mkdir -p ${WRKDIR}
sudo chown ${username}:${usergid} ${WRKDIR}/ -R

cd /tmp
exec >> ${WRKDIR}/deploy.log
exec 2>&1

### packstack install
sudo yum update -y
sudo yum install -y centos-release-openstack-stein
sudo yum update -y
sudo yum install -y openstack-packstack

### fix libraries
wget https://cbs.centos.org/kojifiles/packages/leatherman/1.3.0/9.el7/x86_64/leatherman-1.3.0-9.el7.x86_64.rpm
rpm2cpio ./leatherman-1.3.0-9.el7.x86_64.rpm | cpio -idmv
sudo cp usr/lib64/leatherman* /usr/lib64/

wget ftp://ftp.pbone.net/mirror/ftp.centos.org/7.7.1908/cloud/x86_64/openstack-queens/boost159-log-1.59.0-2.el7.1.x86_64.rpm
rpm2cpio ./boost159-log-1.59.0-2.el7.1.x86_64.rpm | cpio -idmv
sudo cp usr/lib64/libboost* /usr/lib64/

### config and run
sudo packstack --gen-answer-file=ans.cfg

sudo cp ans.cfg test.cfg

sudo sed -i -re 's/(CONFIG_CEILOMETER_INSTALL=)\w+/\1n/gi' test.cfg
sudo sed -i -re 's/(CONFIG_AODH_INSTALL=)\w+/\1n/gi' test.cfg

FILE=/tmp/node2_ip
if [ -f "$FILE" ]
then
    N2=`sudo cat $FILE`
    sudo sed -i -re "s/(CONFIG_COMPUTE_HOSTS=.+)/\1,$N2/gi" test.cfg    
fi

sudo sed -i -re 's/(CONFIG_KEYSTONE_ADMIN_PW=)\w+/\1adminpass/gi' test.cfg
sudo sed -i -re 's/(CONFIG_KEYSTONE_DEMO_PW=)\w+/\1demopass/gi' test.cfg

sudo packstack --answer-file=test.cfg
