#!/bin/ksh
# check mysql instance restarted or not

MysqlDateTime=`ps -ef|grep /bin/mysqld | grep basedir | awk '{print $5}'` 
echo $MysqlDateTime | grep ':'
if [ $? -eq 0 ]; then
	echo "\033[31m it is restarted, please check!\033[m"
else
	echo "it is not restarted, looks stable."
fi

