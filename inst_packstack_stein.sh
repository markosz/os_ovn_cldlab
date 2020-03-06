#!/bin/sh

sudo yum update -y
sudo yum install -y centos-release-openstack-stein
sudo yum update -y
sudo yum install -y openstack-packstack
