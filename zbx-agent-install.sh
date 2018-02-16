#!/bin/bash

#刪除舊的文件檔
rm -rf /etc/zabbix/*.sh*
rm -rf /etc/zabbix/*.conf*
rm -rf /etc/zabbix/zabbix_agentd.d/*.conf

#安裝zabbix工具及程式
yum install net-tools bind-utils wget nc httping -y
rpm -Uvh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.4-2.el7.x86_64.rpm
chkconfig zabbix-agent on
systemctl enable zabbix-agent
#取消selinux功能
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

#加入config及scipt文件
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/ngx_status.sh -o "/etc/zabbix/ngx_status.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/connections.sh -o "/etc/zabbix/connections.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/httping.sh -o "/etc/zabbix/httping.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/access_status.sh -o "/etc/zabbix/access_status.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/splunk_access_v2.sh -o "/etc/zabbix/splunk_access.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/splunk_netstat.sh -o "/etc/zabbix/splunk_netstat.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/ip_connection_count.sh -o "/etc/zabbix/ip_connection_count.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/zabbix_agentd.conf -o "/etc/zabbix/zabbix_agentd.conf"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/userparameter_nginx -o "/etc/zabbix/zabbix_agentd.d/userparameter_nginx.conf"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/zabbix_agentd.psk -o "/etc/zabbix/zabbix_agentd.psk"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/userparameter_ip.conf -o "/etc/zabbix/zabbix_agentd.d/userparameter_ip.conf"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/userparameter_httping.conf -o "/etc/zabbix/zabbix_agentd.d/userparameter_httping.conf"
#前台另外要抓憑證check的script
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/ssl_expiry.sh -o "/etc/zabbix/ssl_expiry.sh"
curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/ssl_issuer.sh -o "/etc/zabbix/ssl_issuer.sh"
chmod +x /etc/zabbix/*.sh

#====記得更換hostname名稱========(每一台都要設定)
echo Hostname=install_newrp_01 >> /etc/zabbix/zabbix_agentd.conf

#新增開機服務
systemctl enable zabbix-agent
service zabbix-agent restart

#安裝salt-stack自動化工具
yum install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm -y
yum install salt-minion -y
systemctl enable salt-minion
service salt-minion start

#手動輸入Salt HostName 品牌代號_品牌名稱_服務類型_序號 (每一台名子要設定)(原型機未設定)
echo install_newrp_01 > /etc/salt/minion_id

#新增Salt-minion設定檔
echo "master: 35.194.220.214" >> /etc/salt/minion
echo "tcp_keepalive: True" >> /etc/salt/minion
echo "tcp_keepalive_idle: 60" >> /etc/salt/minion
service salt-minion restart

#排程splunk
echo '*/5 * * * * sh /etc/zabbix/splunk_access.sh' >> /var/spool/cron/root
echo '0 0 * * *  /usr/sbin/logrotate -f /etc/logrotate.sd/nginx' >> /var/spool/cron/root

#檢查目前zabbix_agent運作
service zabbix-agent status
