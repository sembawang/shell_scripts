#!/bin/awk -f 
# A) For contra mail out statement only, fish out slightly different

{

if ( (NR - 4) % 36 == 6 ) {
	print substr($0, 61, 7);
#	print length ($0);
	}

}


# step 1. use unix vi command (or textpad) to remove all special character - \172 or #AC  in account no line by sub-command s:/<ac>/#/g
#         you can search keyword "SINGAPORE" to check special character '¬'
#         also remove another spec char '|'
# step 2. run diff <original stmt file> <revised stmt file which should show diff on special char replacement only
# step 3. run extract_acct_num_cnt_from_as400_file.sh <revised stmt data file> | sort -u which will show unique acct no list
# step 4. run extract_acct_num_cnt_from_as400_file.sh <revised stmt data file> | sort -u | wc -l which will show no of unique acct no same as control file
#
#


# B) For CBS monthly statement only
# step 1. grep 'Client No.:' <cbs statement data file> then export to /tmp/tmpfile1
# step 2. cut -c112-118 /tmp/tmpfile1 | sort -u which show unique acct no list

