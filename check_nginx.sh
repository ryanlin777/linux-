#!/bin/bash

#if資料夾/home/checkok查詢 
#if [ -e /home/checkok ]; then
#    echo file exists
#
#else
#    echo  no exists
#fi

echo -e "\033[44;37m check nginx services\033[0m"

#ps aux nginx 數量
nginx=`ps aux | grep nginx | wc -l`


#nginx數小於1時就是not runing若不是就是is runing
if [ $nginx -lt 1 ]; then
    echo nginx not runing

else
    echo  nginx is runing 
fi



