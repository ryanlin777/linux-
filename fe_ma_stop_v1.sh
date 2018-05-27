#!/bin/bash

#手動結束FE維謢模式 維護開始 將『  1  』切為『  0  』
sed -i 's/^\s*set $MAM 1/\    set $MAM 0/g'  /opt/APP/openresty/nginx/conf/vhost/*.conf
service nginx reload

#確認
cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep MAM
service nginx status
