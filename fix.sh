#!/bin/sh

wget https://cbs.centos.org/kojifiles/packages/leatherman/1.3.0/9.el7/x86_64/leatherman-1.3.0-9.el7.x86_64.rpm
rpm2cpio ./leatherman-1.3.0-9.el7.x86_64.rpm | cpio -idmv
sudo cp usr/lib64/leatherman* /usr/lib64/

wget ftp://ftp.pbone.net/mirror/ftp.centos.org/7.7.1908/cloud/x86_64/openstack-queens/boost159-log-1.59.0-2.el7.1.x86_64.rpm
rpm2cpio ./boost159-log-1.59.0-2.el7.1.x86_64.rpm | cpio -idmv
sudo cp usr/lib64/libboost* /usr/lib64/
