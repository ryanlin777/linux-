#!/bin/bash

#新RP反代安裝
#系統時區、hostname修改、關閉Selinux、
#安裝 zabbix_Agent、Salt、

read -p "輸入hostname 服務-品牌-編號(frontend、backend、app、pay):" hostname
read -p "輸入agent name 品牌_服務種類_編號(品牌第一字大寫Vip500):" agentname
read -p "輸入salt name 品牌號碼-品牌-服務-編號(小寫):" saltname

echo -e "\nYour hostname is: $hostname"
hostname $hostname
echo -e "\nYour zabbix name is: $agentname"
echo -e "\nYour salt name is: $saltname"

#read -p "確定安裝輸入yes, 離開按ctrl+c : " YES


echo "修改hostname Press y to continue"
read yn

if [ "$yn" = "y" ]; then
        echo "script is running..."
        echo "$hostname > /etc/hostname"
        hostnamectl set-hostname $hostname

else
        echo "STOP!"
fi 

#安裝zabbix_agnet
if [ -f /etc/zabbix/zabbix_agentd.conf ]; then
	echo "已裝Zabbix_Agent"
else

#系統更新
 	yum -y install epel-release update

#安裝zabbix工具及程式
	yum install net-tools bind-utils wget nc httping  iftop -y
	rpm -Uvh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.9-1.el7.x86_64.rpm
	systemctl enable zabbix-agent

	setenforce 0
	sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

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

	curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/ssl_expiry.sh -o "/etc/zabbix/ssl_expiry.sh"
	curl -s https://raw.githubusercontent.com/nickchangs/zabbix-agent2/master/ssl_issuer.sh -o "/etc/zabbix/ssl_issuer.sh"
	chmod +x /etc/zabbix/*.sh


systemctl enable zabbix-agent
service zabbix-agent restart



echo Hostname=$agentname >> /etc/zabbix/zabbix_agentd.conf

fi



if [ -d /etc/salt ]; then
        echo "已裝salt"
else


#安裝salt-stack自動化工具
yum install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm -y
yum install salt-minion -y
systemctl enable salt-minion
service salt-minion start

#手動輸入Salt HostName 品牌代號_品牌名稱_服務類型_序號 (每一台名子要設定)(原型機未設定)
echo $saltname > /etc/salt/minion_id

#新增Salt-minion設定檔
echo "master: 00.194.220.214" >> /etc/salt/minion
echo "tcp_keepalive: True" >> /etc/salt/minion
echo "tcp_keepalive_idle: 60" >> /etc/salt/minion

fi

#services check
systemctl restart salt-minion.service
service zabbix-agent restart
systemctl status zabbix-agent.service | grep running
systemctl status salt-minion.service | grep  running


#name check
cat /etc/salt/minion_id
cat /etc/zabbix/zabbix_agentd.conf | grep Hostname

