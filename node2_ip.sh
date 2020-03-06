#!/bin/sh

 ifconfig | grep "inet " |  awk 'NR == 1 {print $2}' > node2_ip
 sudo scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null node2_ip node1:/local/repository/
 
