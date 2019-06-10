#!/usr/bin/ksh
# check intraday data updated or not in mysql db
# counter feed code - D05_R or O39_R or N21_R or K11_R or C6L_R

if [ -f /tmp/intraday_chart_data.tmp ]
then
	LastUpdTime=`tail -1 /tmp/intraday_chart_data.tmp | cut -f2 -d' '`
else
	LastUpdTime=0
fi

mysql -u slist -pslist slist <<-ESQL >> /tmp/intraday_chart_data.tmp

	select max(CHANGE_DT) from SGX_FEED_DATA_LOG where SOURCE='SGX' and FEED_CODE='C6L_R';

ESQL

CurrUpdTime=`tail -1 /tmp/intraday_chart_data.tmp | cut -f2 -d' '`

echo $LastUpdTime $CurrUpdTime

if [ "$LastUpdTime" = "$CurrUpdTime" ]
then
	echo "\033[31m <C6L> counter price not updated in past 10 minutes, plase check?\033[m"
else
	echo "<C6l> counter price is updating, looks normal."
fi

