#!/bin/bash
# estatement loading statistic alert with LTS SMTP server

MYDATETIME=`date +"%Y%m%d_%H%M%S"`
SMTP_SERVER="192.168.100.22:25"

echo "attached for e-statement loading statistic report, LN and SL team to verify." | mailx -v \
-r "estmt_daily_alert@limtan.com.sg" \
-c "xyz@limtan.com.sg" \
-a /prodlib/LTS/output/estmt_svr_statistic.rpt \
-s "LTS E-Statement Loading Statistic [$MYDATETIME]" \
-S smtp=$SMTP_SERVER \
-S smtp-use-starttls  \
-S ssl-verify=ignore \
-S nss-config-dir=/prodlib/LTS/.certs \
xyz@limtan.com.sg

