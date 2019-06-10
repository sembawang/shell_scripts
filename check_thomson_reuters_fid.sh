#!/usr/bin/ksh
# check system impact when there is thomson reuters FID change
# info tech dept / lim and tan secu 
# by 06 Apr 2016
# sample FID setting:
# Ini File:	/AA/02/LT/ist/server/ini/chainpub_NYS.ini
# FID Setting:	FIDS=3,78,4,117,118,15,6,14,11,56,30,22,25,31,12,13,19,32,21,16,18,100,380
# 		NULL_FIDS=12402,2001,12405,2013,2014,12403,3021,12415,12401,12400,11401,11001,11201,11601,3022,3023,3041,4031

if ! [ $# -eq 2 ]; then
        echo "syntax: $0 <NYS/NMS/ASE/HKG> <FID>"
        exit 255
fi

MARKET=$1
FID=$2

INI_PATH1=/AA/01/LT/ist/server/ini
INI_PATH2=/AA/02/LT/ist/server/ini

echo "####Start of Scanning####"

cnt=1
for d in $INI_PATH1 $INI_PATH2
do
echo "----------------------------------------------------------------------------------------------------"
if ! [ -d $d ]; then
	echo "[$cnt]$d not found, to skip..."
	cnt=`expr $cnt \+ 1`
	continue
fi

find $d/*_${MARKET}.ini 1>/dev/null 2>&1
if ! [ $? -eq 0 ]; then
	echo "[$cnt]$d/*_${MARKET}.ini not found, to skip..."
	cnt=`expr $cnt \+ 1`
	continue
fi

echo "[$cnt]scan ini file in $d..."
grep "^FIDS=" $d/*_${MARKET}.ini | egrep "=$FID,|,$FID,|,$FID$"
grep "^NULL_FIDS=" $d/*_${MARKET}.ini | egrep "=$FID,|,$FID,|,$FID$"
cnt=`expr $cnt \+ 1`
done

echo "####End of Scanning####"
echo "\n"

