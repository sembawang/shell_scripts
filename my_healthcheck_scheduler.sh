#!/usr/bin/ksh

# check mysql db instance
# check mkt summary statistic


while [ 1 ] 
do
	MyDate=`date +"%Y-%m-%d"`
	MyTime=`date +"%H:%M:%S"`

	echo "======================${MyTime}=================================================="
	echo "[1] mysql instance"
	/export/home/slist/check_mysql_instance.sh
	echo "[2] mkt summary statistic"
	/export/home/slist/check_mktsumlog.sh
	echo "[3] intraday chart"
	/export/home/slist/check_intraday_chart.sh
	echo "...wait for 10 minute..."
	sleep 600 
done
