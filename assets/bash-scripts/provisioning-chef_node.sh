#!/bin/bash

echo "Shell Provisioning: Chef Node ..."

set -ex;

echo "Adding default IPTables rules ..."
sudo iptables -A OUTPUT -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 389 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 443 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 8443 -j ACCEPT
