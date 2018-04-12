#!/bin/bash

#取消selinux功能
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# 讓 yum  添加CentOS 7 Nginx yum资源库
sudo rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
#安裝
yum install nginx -y

# 啟動服務
systemctl nginx start
systemctl enable nginx.service

### nginx 全部開放 ###
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

#確認80
netstat -ant | grep :80


