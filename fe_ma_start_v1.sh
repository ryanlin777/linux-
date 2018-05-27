#!/bin/bash

#手動開始FE維謢模式 維護開始 將『  0  』切為『  1  』
sed -i 's/^\s*set $MAM 0/\    set $MAM 1/g'  /opt/APP/openresty/nginx/conf/vhost/*.conf
service nginx reload

#確認
cat /opt/APP/openresty/nginx/conf/vhost/*.conf | grep MAM
service nginx status

