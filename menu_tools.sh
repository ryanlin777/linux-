#!/bin/bash
# 對話shell 20181224
# url:www.runoob.com


echo -e "\033[44;37m 输入 1 到 4 之间的数字:\033[0m"

echo '1.Nginx service check'
echo '2.crontab check'
echo '3.系統日期'
echo '4.whois list 查詢(先把URL放到whois_list.txt)'
echo '5.'
echo '你输入的数字为:'
read aNum


case $aNum in
    1)  echo '你选择了 1'; 
        echo -e "\033[44;37m check nginx services\033[0m"

	#ps aux nginx 數量
	nginx=`ps aux | grep nginx | wc -l`


	#nginx數小於1時就是not runing若不是就是is runing
	if [ $nginx -le 1 ]; then
    	echo nginx not runing
	
	else
	    echo  nginx is runing
	fi
    ;;

    2)  echo '你选择了 2'
	crontab -l
    ;;

    3)  echo '你选择了 3'
	date	
    ;;

    4)  echo '你选择了 4'
	rm -rf /home/whois_report.txt
	
	filename='/home/whois_list.txt'
	date  +"%Y-%m-%d %H:%M.%S"
	exec < $filename
	while read line
	
	do
	
	#whois查詢check_name.txt
	echo $line  >> /home/whois_report.txt
	 whois $line 2>&1 | grep ' Expiration Date:'  >> /home/whois_report.txt
	
	#cat /home/whois_report.txt
	
	#whois $line 2>&1 | grep "Domain Name:\|Creation Date: \|Registry Expiry Date:\|Updated Date:\|Name Server:"  >> /home/whois_report.txt
	#echo $line # 一行一行印出內容
	
	    #echo 'a' $line # 印出 "a $line" 此行的內容, 可另外作特別處理.
	
	done
	
	cat /home/whois_report.txt

	;;
    5)  echo '你选择了 5'
        date
    ;;



    *)  echo '你没有输入 1 到 4 之间的数字'
    ;;
esac
