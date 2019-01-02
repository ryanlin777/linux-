#!/bin/sh

app_url="url"

for i1 in $app_url  ; do

    if [ `curl --connect-timeout 5 -m 10 -s -o /dev/null -A "1dkja93kj2" -k "%{http_code}" -s http://$i1:10000/apis/healthCheck | grep -q "200" ; echo $?` -ne 0 ]  
			then echo "$i1 curl  failed"
                else 
                     echo "$i1 healthcheck  OK"
	             echo "=================================="
		fi

done

