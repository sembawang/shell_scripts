#!/bin/bash
# estatement loading statistic alert with LTS SMTP server

MYDATETIME=`date +"%Y%m%d_%H%M%S"`
SMTP_SERVER="192.168.100.22:25"
Orig_Report=/prodlib/LTS/output/estmt_svr_statistic.rpt
SMS_Info_Report=/prodlib/LTS/output/estmt_svr_statistic.rpt.smsinfo
# original report format
# $1 -	DateTime Field
# $2 - 	StmtCount Field
# $3 - 	StmtType Field

awk 'BEGIN {FS = "|"} !/####/ {
	StmtLoadingDate=substr($1,1,10);
	split($2,a,":");
	StmtFailCount=a[2];
	StmtSucCount=a[3];
	split(StmtSucCount,b,"=");
	StmtSucCountNum=b[2];

	if (index($3, "CFD_DAILY_APP") > 0 )		StmtType="CFD";
	else if (index($3, "CFD_MONTHLY_APP") > 0 )	StmtType="CFM";
	else if (index($3, "CONTRA_APP") > 0 )		StmtType="CON";
	else if (index($3, "ECONTRACTSTMT_APP") > 0 )	StmtType="CTR";
	else if (index($3, "ECONTRACTAMEND_APP") > 0 )	StmtType="CTA";
	else if (index($3, "CBSMONTHLY_APP") > 0 )	StmtType="CBM";
	else if (index($3, "CBSTAXINV_APP") > 0 )	StmtType="TIM";
	else if (index($3, "MONTHLYDIVIDEND_APP") > 0 )	StmtType="DVM";
	else if (index($3, "MONTHLYLEDGER_APP") > 0 )	StmtType="TXM";
	else if (index($3, "MONTHLYSECURITIESHOLDING_APP") > 0 ) StmtType="SHM";
	else if (index($3, "MONTHLYMARGIN_APP") > 0 )	StmtType="MGM";
	else if (index($3, "MONTHLYSTOCKPOSITION_APP") > 0 )	 StmtType="MSM";
	else if (index($3, "MONTHLYTRUSTMOVEMENT_APP") > 0 )	 StmtType="TMM";
	else if (index($3, "MONTHLYTRUSTSTATEMENT_APP") > 0 )	 StmtType="TRM";	
	else StmtType="***";

	printf ("%s: %s ", StmtType, StmtSucCountNum );
}'  $Orig_Report > $SMS_Info_Report  

if [ -s $SMS_Info_Report ]; then
	SMS_Info_Text=`cat $SMS_Info_Report`
else
	SMS_Info_Text="No stmt loaded"
fi
#echo "[$SMS_Info_Text]"
#exit

cat $Orig_Report | mailx -v \
-r "estmt_daily_alert@limtan.com.sg" \
-c "kkowyang@limtan.com.sg" \
-s "E-Statement Loading Statistic [$MYDATETIME] - $SMS_Info_Text" \
-S smtp=$SMTP_SERVER \
"itd-sl-team@limtan.com.sg"


