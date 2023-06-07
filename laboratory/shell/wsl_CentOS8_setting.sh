#!/bin/bash

cd /etc/yum.repos.d
sed -i 's/mirrorlist=/#mirrorlist=/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
cd
yum groupinstall -y "Development Tools"
yum install -y bc which sudo wget make jq
echo "attention: bc which sudo wget make installed!"
