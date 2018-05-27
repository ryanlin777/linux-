#!/bin/bash

#手動開始APP維謢模式
sed -i 's/set\ \$AppMaintainMode\ 0/\set\ \$AppMaintainMode\ 1/g' /opt/APP/openresty/nginx/conf/vhost/*.conf
sed -i 's/set\ \$AppMaintainLog\ 0/\set\ \$AppMaintainLog\ 1/g' /opt/APP/openresty/nginx/conf/vhost/*.conf
service nginx reload

#確認
cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep AppMaintainMode
cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep AppMaintainLog

service nginx status

