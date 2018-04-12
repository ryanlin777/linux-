#!/bin/bash

#取消selinux功能關閉firewalld
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# 讓 yum 能找到 nginx
echo [nginx] >> /etc/yum.repos.d/nginx.repo
echo name=nginx repo >> /etc/yum.repos.d/nginx.repo
echo baseurl=http://nginx.org/packages/centos/6/$basearch/ >> /etc/yum.repos.d/nginx.repo
echo gpgcheck=0 >> /etc/yum.repos.d/nginx.repo
echo enabled=1 >> /etc/yum.repos.d/nginx.repo

#安裝
yum install nginx -y

# 啟動服務
systemctl nginx start
systemctl enable nginx.service

### nginx 全部開放 ###
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

#確認80
netstat -ant | grep :80


