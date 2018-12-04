#!/bin/sh
#查詢url的證書到期日20181204
url="xxx.xxx.com ddd.aaa.com"

for i1 in $url  ; do

echo $i1 ; echo | openssl s_client -servername $i1 -connect $i1:443 2>/dev/null | openssl x509 -noout -dates 2>/dev/null | grep notAfter | cut -d'=' -f2

done

