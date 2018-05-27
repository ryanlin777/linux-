#!/bin/bash

#手動結束APP維謢模式
rm /opt/APP/openresty/nginx/conf/lua_Script/APP/wh.dat -rf
sed -i 's/set\ \$AppMaintainMode\ 1/\set\ \$AppMaintainMode\ 0/g' /opt/APP/openresty/nginx/conf/vhost/*.conf
sed -i 's/set\ \$AppMaintainLog\ 1/\set\ \$AppMaintainLog\ 0/g' /opt/APP/openresty/nginx/conf/vhost/*.conf
service nginx reload

#確認
cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep AppMaintainMode
cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep AppMaintainLog

service nginx status
