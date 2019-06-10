#!/bin/ksh
# check market summary statistic updated or not
# every 10 minutes

CurrTime=`date "+%Y-%m-%d_%H:%M:%S"`
SgxMktSumLog=/ist/log/sgxmktsum/sgxmktsum.log
MyLog=/tmp/SgxMktSumLog.SecA.tmp

if [ -f $MyLog ]; then
	PrevSectorAValue=`tail -1 $MyLog|cut -f3 -d'#'`
else
	PrevSectorAValue=0
fi

SectorAName=Sector_A
SectorAValue=`grep 'MktSumBuilder - A' $SgxMktSumLog | tail -1 | awk '{print $8}'`
echo "$CurrTime^$SectorAName^$SectorAValue" >> $MyLog 

if [ "$PrevSectorAValue" = "$SectorAValue" ]; then
	echo "\033[31m sector-a value no updates for past 10 mins, pls chk?\033[m"
else
	echo "sector-a value is updating."	
fi


