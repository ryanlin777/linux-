#!/bin/bash
#zabbix db history 佔disk空間過大執行
#ls -lrth /var/lib/mysql/zabbix  | grep G


#清除重建history、history_uint
mysql -u zabbix -pzabbix zabbix -e "rename tables history to history_1;create table history like history_1;drop  tables history_1;"

mysql -u zabbix -pzabbix zabbix -e "rename tables history_uint to history_uint_1;create table history_uint like history_uint_1;drop  tables history_uint_1;"
