#!/bin/bash

BACKUP_PATH="/opt/APP/openresty/nginx/conf/vhost/*.conf /opt/APP/openresty/nginx/conf/nginx.conf /opt/APP/openresty/nginx/conf/ssl/* /opt/APP/openresty/nginx/conf/ma/ma.conf /opt/Htdocs/* /etc/sysconfig/iptables /opt/APP/openresty/nginx/conf/*.crt /opt/APP/openresty/nginx/conf/*.key /opt/APP/openresty/nginx/conf/lua_Script/* /opt/optdata /opt/optScript/*"

tar cvf /root/ngx-backup/`hostname`_`date +%F`.tar $BACKUP_PATH
find /root/ngx-backup -type f -mtime +30 -name '*.tar' -delete
