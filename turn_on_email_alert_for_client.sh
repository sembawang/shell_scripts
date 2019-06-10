#!/bin/bash
# update email alert flag to 1 for selected client

if ! [ $# -eq 2 ]; then
	echo "syntax: $0 <SL client master file> <trading acct id>"
	exit 255
fi
if ! [ -f $1 ]; then 
	echo "SL client master file <$1> not found or inaccessible."
	exit 254 
fi

SL_Client_Master_File=$1
SL_Trading_Acct_ID=$2
TMPFILE=${SL_Client_Master_File}.tmp
BAKFILE=${SL_Client_Master_File}.bak

echo "$SL_Trading_Acct_ID"
gawk -v keyvar="$SL_Trading_Acct_ID" ' BEGIN { FS="|"; }
{
	if ( $3 == keyvar ){
		printf "%s|%s|%s|%s|%s|%s|%s\n", $1, $2, $3, $4, $5, $6,"1"; 
	}else {
		print;
	}	
}' $SL_Client_Master_File > $TMPFILE

cp -p $SL_Client_Master_File $BAKFILE
cp -p $TMPFILE $SL_Client_Master_File

echo "[after image] diff $SL_Client_Master_File $BAKFILE"
diff $SL_Client_Master_File $BAKFILE

rm $TMPFILE


