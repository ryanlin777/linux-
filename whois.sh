#!/bin/bash

rm -rf /home/whois_report.txt

filename='/home/whois_list.txt'

exec < $filename
while read line

do

#whois查詢check_name.txt
echo $line  >> /home/whois_report.txt
 whois $line 2>&1 | grep 'Expiration Date:'  >> /home/whois_report.txt

#cat /home/whois_report.txt

#whois $line 2>&1 | grep "Domain Name:\|Creation Date: \|Registry Expiry Date:\|Updated Date:\|Name Server:"  >> /home/whois_report.txt
#echo $line # 一行一行印出內容

    #echo 'a' $line # 印出 "a $line" 此行的內容, 可另外作特別處理.
done

