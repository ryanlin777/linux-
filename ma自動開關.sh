需要在改成正式環境



#!bin/bash

read -p "請輸入_MA開始填 1 MA結束填 0 : " name  
echo -e "\nYour 填入代碼為 :$name " 

if [ "$name" == "1" ]; then

        sed -i  "s/set\ \$AppMaintainMode\ 0/\set\ \$AppMaintainMode\ 1/g" /opt/APP/openresty/nginx/conf/vhost/ma 
        sed -i  "s/set\ \$AppMaintainLog\ 0/\set\ \$AppMaintainLog\ 1/g" /opt/APP/openresty/nginx/conf/vhost/ma 
	systemctl stop nginx && systemctl start nginx
 	echo 目前設定
        cat /opt/APP/openresty/nginx/conf/vhost/ma
	echo Nginx狀態
	systemctl status nginx | grep Active

elif [ "$name" == "0" ]; then
        
        sed -i  "s/set\ \$AppMaintainMode\ 1/\set\ \$AppMaintainMode\ 0/g" /opt/APP/openresty/nginx/conf/vhost/ma 
        sed -i  "s/set\ \$AppMaintainLog\ 1/\set\ \$AppMaintainLog\ 0/g" /opt/APP/openresty/nginx/conf/vhost/ma        
	systemctl stop nginx && systemctl start nginx
	echo 目前設定
	cat /opt/APP/openresty/nginx/conf/vhost/ma
	echo Nginx狀態
	systemctl status nginx | grep Active
else
     echo 都不是『 0 或 1 』
     echo 目前設定
     cat /opt/APP/openresty/nginx/conf/vhost/ma
fi
