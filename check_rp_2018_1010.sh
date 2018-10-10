#!/bin/bash
rm -rf /home/check_rp.txt
 


read -p "檢查設定(檢查FE、APP/Y , BE、PAY/N):" yn
[ "$yn" == "Y" -o "$yn" == "y" ]

echo -e check_day$(date +"%Y-%m-%d %H:%M") | tee -a /home/check_rp.txt

if [ "$yn" = "y" ]; then

######Name_Check
echo -e "\033[43m_1_CHECK_NAME \033[0m"| tee -a /home/check_rp.txt
echo -e "\033[36mCheck_hostname \033[0m"| tee -a /home/check_rp.txt ; uname -n | tee -a /home/check_rp.txt
echo -e "\033[36mCheck_saltname \033[0m"| tee -a /home/check_rp.txt ; cat /etc/salt/minion_id | tee -a /home/check_rp.txt
echo -e "\033[36mCheck_zabbix_agnet \033[0m"| tee -a /home/check_rp.txt ; cat /etc/zabbix/zabbix_agentd.conf | grep Hostname | tee -a /home/check_rp.txt
echo -
echo -
echo -
sleep 1s
######Service_Check
echo -e "\033[43m_2_CHECK_Service \033[0m"| tee -a /home/check_rp.txt
echo -e "\033[36mCheck_Service_NGINX \033[0m" | tee -a /home/check_rp.txt ;systemctl  status nginx  | grep "Active:" | tee -a /home/check_rp.txt
echo -e "\033[36mCheck_Service_ZABBIX_Agnet \033[0m"  | tee -a /home/check_rp.txt ; systemctl  status zabbix-agent | grep "Active:" | tee -a /home/check_rp.txt
echo -e "\033[36mCheck_Service_Salt \033[0m"  | tee -a /home/check_rp.txt ; systemctl  status salt-minion | grep "Active:" | tee -a /home/check_rp.txt
echo -e "\033[36mCheck_Service_Iptables \033[0m"  | tee -a /home/check_rp.txt ; systemctl status iptables | grep "Active:" | tee -a /home/check_rp.txt
echo -
echo -
echo -
sleep 1s
######Nginx_Check
echo -e "\033[43m_3_Nginx_CHECK_.conf數量&後端IP&nginx設定檔正確性\033[0m"| tee -a /home/check_rp.txt
echo -e "\033[36m.conf數量&Check_後端IP\033[0m"| tee -a /home/check_rp.txt ; ls -lrt /opt/APP/openresty/nginx/conf/vhost/*conf ; cat /opt/APP/openresty/nginx/conf/vhost/*conf | grep -v "ssl_prefer_\|server_name\|server {" | grep server | tee -a /home/check_rp.txt
echo -e "\033[36mnginx -t \033[0m"| tee -a /home/check_rp.txt ; nginx -t | tee -a /home/check_rp.txt
echo -e "\033[36mSSL證書\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/*conf | grep ssl_certificate | tee -a /home/check_rp.txt
echo -e "\033[36mproxy_pass\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep "proxy_pass" | tee -a /home/check_rp.txt
echo -e "\033[36m保留IP\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep "203.177.179.69\|203.177.171.98\|112.199.32.122" | tee -a /home/check_rp.txt
echo -e "\033[36mallow-ips保留IP\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/allow-ips | grep "203.177.179.69\|203.177.171.98\|112.199.32.122" | tee -a /home/check_rp.txt
echo -e "\033[36mAccess_Log_Name\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep "access_log\|error_log" | tee -a /home/check_rp.txt
echo -e "\033[36mGEO_IP \033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/nginx.conf | grep " 0;" | tee -a /home/check_rp.txt
echo -e "\033[36mGEO_IP數量 \033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/nginx.conf | grep " 0;" | wc -l | tee -a /home/check_rp.txt
echo -e "\033[36mServer_Name\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/*conf | grep -v "server_name  _;" | grep server_name | tee -a /home/check_rp.txt
#######Access Log
echo -e "\033[43m_4_Access_Log狀態\033[0m" | tee -a /home/check_rp.txt ;tail /opt/logs/nginx/*access.log | tee -a /home/check_rp.txt
echo -
echo -
echo -
sleep 1s
######Crontab
echo -e "\033[43m_5_Check Crontab\033[0m"| tee -a /home/check_rp.txt ;
echo -e "\033[36mCrontab是否有設定，未上線前把Splunk註解掉\033[0m"| tee -a /home/check_rp.txt ; crontab -l | tee -a /home/check_rp.txt
echo -
echo -
echo -
sleep 1s
######Iptables-L-n
echo -e "\033[43m_6_Iptables 狀態\033[0m" | tee -a /home/check_rp.txt ;
echo -e "\033[36m Iptables\033[0m" | tee -a /home/check_rp.txt ; cat /etc/sysconfig/iptables | grep -v "#"| grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}-([0-9]{1,3}\.){3}[0-9]{1,3}|([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort -n | tee -a /home/check_rp.txt
echo -e "\033[36m Iptables筆數\033[0m" | tee -a /home/check_rp.txt ; cat /etc/sysconfig/iptables |grep -v "#"| grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}-([0-9]{1,3}\.){3}[0-9]{1,3}|([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort -n | wc -l | tee -a /home/check_rp.txt

echo -
echo -
echo -

######FE ymal check
echo -e "\033[43m_7_前台ymal檔Check\033[0m"| tee -a /home/check_rp.txt ;
echo -e "\033[36mymal檔案\033[0m"| tee -a /home/check_rp.txt ; ls -lrt /opt/optdata/*yaml  | tee -a /home/check_rp.txt
echo -e "\033[36mymal設定\033[0m"| tee -a /home/check_rp.txt ; cat /opt/optdata/*yaml | tee -a /home/check_rp.txt
echo -
echo -
echo -

######FE MA check
echo -e "\033[43m_8_前台MA_Check\033[0m"| tee -a /home/check_rp.txt ;
echo -e "\033[36m前台維護狀態0為關1為開\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/*conf | grep -v "#" | grep  "MAM " | tee -a /home/check_rp.txt
echo -e "\033[36m前台維護Htdoc資料夾Check\033[0m"| tee -a /home/check_rp.txt ;ls -lrt /opt/Htdoc/service/ | tee -a /home/check_rp.txt


######APP MA_Check
echo -e "\033[43m_9_APP_MA_設定檔_Check\033[0m"| tee -a /home/check_rp.txt
echo -e "\033[36mAPP_MA_wh.dat\033[0m"| tee -a /home/check_rp.txt ; ls -lrt /opt/APP/openresty/nginx/conf/lua_Script/APP/ | tee -a /home/check_rp.txt
echo -e "\033[36mAPP_MA狀態_0開1開\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/*conf | grep "AppMaintainLog\|AppMaintainMode" | tee -a /home/check_rp.txt

else
        #echo "STOP!"




echo
echo
######Name_Check
echo -e "\033[43m_1_CHECK_NAME \033[0m"| tee -a /home/check_rp.txt
echo -e "\033[36mCheck_hostname \033[0m"| tee -a /home/check_rp.txt ; uname -n | tee -a /home/check_rp.txt
echo -e "\033[36mCheck_saltname \033[0m"| tee -a /home/check_rp.txt ; cat /etc/salt/minion_id | tee -a /home/check_rp.txt
echo -e "\033[36mCheck_zabbix_agnet \033[0m"| tee -a /home/check_rp.txt ; cat /etc/zabbix/zabbix_agentd.conf | grep Hostname | tee -a /home/check_rp.txt
echo - 
echo - 
echo -
sleep 1s 
######Service_Check
echo -e "\033[43m_2_CHECK_Service \033[0m"| tee -a /home/check_rp.txt
echo -e "\033[36mCheck_Service_NGINX \033[0m" | tee -a /home/check_rp.txt ;systemctl  status nginx  | grep "Active:" | tee -a /home/check_rp.txt
echo -e "\033[36mCheck_Service_ZABBIX_Agnet \033[0m"  | tee -a /home/check_rp.txt ; systemctl  status zabbix-agent | grep "Active:" | tee -a /home/check_rp.txt
echo -e "\033[36mCheck_Service_Salt \033[0m"  | tee -a /home/check_rp.txt ; systemctl  status salt-minion | grep "Active:" | tee -a /home/check_rp.txt
echo -e "\033[36mCheck_Service_Iptables \033[0m"  | tee -a /home/check_rp.txt ; systemctl status iptables | grep "Active:" | tee -a /home/check_rp.txt
echo -
echo -
echo -
sleep 1s 
######Nginx_Check
echo -e "\033[43m_3_Nginx_CHECK_.conf數量&後端IP&nginx設定檔正確性\033[0m"| tee -a /home/check_rp.txt
echo -e "\033[36m.conf數量&Check_後端IP\033[0m"| tee -a /home/check_rp.txt ; ls -lrt /opt/APP/openresty/nginx/conf/vhost/*conf ; cat /opt/APP/openresty/nginx/conf/vhost/*conf | grep -v "ssl_prefer_\|server_name\|server {" | grep server | tee -a /home/check_rp.txt
echo -e "\033[36mnginx -t \033[0m"| tee -a /home/check_rp.txt ; nginx -t | tee -a /home/check_rp.txt
echo -e "\033[36mSSL證書\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/*conf | grep ssl_certificate | tee -a /home/check_rp.txt
echo -e "\033[36mproxy_pass\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep "proxy_pass" | tee -a /home/check_rp.txt
echo -e "\033[36m保留IP\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep "203.177.179.69\|203.177.171.98\|112.199.32.122" | tee -a /home/check_rp.txt
echo -e "\033[36mAccess_Log_Name\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep "access_log\|error_log" | tee -a /home/check_rp.txt
#echo -e "\033[36mGEO_IP \033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/nginx.conf |grep " 0;" | tee -a /home/check_rp.txt
#echo -e "\033[36mGEO_IP數量 \033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/nginx.conf | grep /32 | wc -l | tee -a /home/check_rp.txt
echo -e "\033[36mServer_Name\033[0m"| tee -a /home/check_rp.txt ; cat /opt/APP/openresty/nginx/conf/vhost/*conf | grep -v "server_name  _;" | grep server_name | tee -a /home/check_rp.txt

######Access log
echo -e "\033[43m_4_Access_Log狀態\033[0m" | tee -a /home/check_rp.txt ;tail /opt/logs/nginx/*access.log | tee -a /home/check_rp.txt
echo -
echo -
echo -
sleep 1s
######Crontab
echo -e "\033[43m_5_Check Crontab\033[0m"| tee -a /home/check_rp.txt ;
echo -e "\033[36mCrontab是否有設定，未上線前把Splunk註解掉\033[0m"| tee -a /home/check_rp.txt ; crontab -l | tee -a /home/check_rp.txt
echo -
echo -
echo -
sleep 1s 
######Iptables-L-n
echo -e "\033[43m_6_Iptables 狀態\033[0m" | tee -a /home/check_rp.txt ;
#echo -e "\033[36m Iptables -L -n\033[0m" | tee -a /home/check_rp.txt ; iptables -L -n  | tee -a /home/check_rp.txt
echo -e "\033[36m Iptables\033[0m" | tee -a /home/check_rp.txt ; cat /etc/sysconfig/iptables | grep -v "#"| grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}-([0-9]{1,3}\.){3}[0-9]{1,3}|([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort -n | tee -a /home/check_rp.txt
echo -e "\033[36m Iptables筆數\033[0m" | tee -a /home/check_rp.txt ; cat /etc/sysconfig/iptables |grep -v "#"| grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}-([0-9]{1,3}\.){3}[0-9]{1,3}|([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort -n | wc -l | tee -a /home/check_rp.txt
echo - 
echo -
echo -


fi


