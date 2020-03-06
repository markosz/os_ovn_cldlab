#!/bin/bash

sudo packstak --gen-answer-file=ans.cfg

sudo cp ans.cfg test.cfg

sudo sed -i -re 's/(CONFIG_CEILOMETER_INSTALL=)\w+/\1n/gi' test.cfg
sudo sed -i -re 's/(CONFIG_AODH_INSTALL=)\w+/\1n/gi' test.cfg
N2=`sudo cat node2_ip`
sudo sed -i -re "s/(CONFIG_COMPUTE_HOSTS=.+)/\1,$N2/gi" probe.txt
sudo sed -i -re 's/(CONFIG_KEYSTONE_ADMIN_PW=)\w+/\1adminpass/gi' test.cfg
sudo sed -i -re 's/(CONFIG_KEYSTONE_DEMO_PW=)\w+/\1demopass/gi' test.cfg

#sudo packstak --answer-file=test.cfg
