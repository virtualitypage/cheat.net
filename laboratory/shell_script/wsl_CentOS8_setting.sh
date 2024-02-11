#!/bin/bash

cd /etc/yum.repos.d || exit
sed -i 's/mirrorlist=/#mirrorlist=/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
cd || exit
yum groupinstall -y "Development Tools"
yum install -y bc which sudo wget make jq
echo -e "\033[1;32mALL SUCCESEFUL: bc which sudo wget make jq のインストールが正常に終了しました。\033[0m"