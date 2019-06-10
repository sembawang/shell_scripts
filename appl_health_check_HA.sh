#!/usr/bin/ksh

SourceServer=ltcom3app01
TaregtServer=ltcom3app01

CompareDirWithSubdir(dir1, dir2)(
for d in $dir1; do
	CompareDir(dir1, dir2))
done
)
CompareDir(dir1, dir2)(
for f in $dir1;do
	CompareFile($f, $f)
done
)

CompareFile(file1, file2)(
	if diff $file1 $file2;
		echo "$file1, $file2 differs"
	else
		echo "--------"
	fi
)


http://serverfault.com/questions/39534/best-way-to-compare-diff-a-full-directory-structure

Some people want to compare filesystems for different reasons, so I'll write here what I wanted and how I did it.

I wanted:
 •To compare the same filesystem with itself, i.e., snapshot, make changes, snapshot, compare.
 •A list of what files were added or removed, didn't care about inner file changes.
 
What I did:

First snapshot (before.sh script):
find / -xdev | sort > fs-before.txt

 Second snapshot (after.sh script):
find / -xdev | sort > fs-after.txt

 To compare them (diff.sh script):
diff -daU 0 fs-before.txt fs-after.txt | grep -vE '^(@@|\+\+\+|---)'

 The good part is that this uses pretty much default system binaries. Having it compare based on content could be done passing find an -exec parameter that echoed the file path and an MD5 after that.

 while read ff; do
	ls -l $ff
 done < /tmp/fs-before.txt > /tmp/fs-before.txt.long
 
 
 
 /* app2 test output */
 
 ltcom3app02[slist]/home/slist/HC> extract_app_server_dir_list.sh
/ist/server/bin/ dir list extracted to /home/slist/HC/log/ltcom3app02/ltcom3app02._ist_server_bin_.out.20150804
/ist/config/ dir list extracted to /home/slist/HC/log/ltcom3app02/ltcom3app02._ist_config_.out.20150804
/ist/server/ini/ dir list extracted to /home/slist/HC/log/ltcom3app02/ltcom3app02._ist_server_ini_.out.20150804
ls: 0653-341 The file /ist/server/script/loyalty/MTA-LIMTAN does not exist.
ls: 0653-341 The file STRUCTURE-MTA-LIMTAN does not exist.
ls: 0653-341 The file STRUCTURE-09MAY20061.txt does not exist.
/ist/server/script/ dir list extracted to /home/slist/HC/log/ltcom3app02/ltcom3app02._ist_server_script_.out.20150804
/ist/shared/ dir list extracted to /home/slist/HC/log/ltcom3app02/ltcom3app02._ist_shared_.out.20150804
/ist/shared/com/ dir list extracted to /home/slist/HC/log/ltcom3app02/ltcom3app02._ist_shared_com_.out.20150804
/ist/shared/ebiz/ dir list extracted to /home/slist/HC/log/ltcom3app02/ltcom3app02._ist_shared_ebiz_.out.20150804
/ist/shared/com/solutionslab/quotegiver/historical/chart/ dir list extracted to /home/slist/HC/log/ltcom3app02/ltcom3app02._ist_shared_com_solutionslab_quotegiver_historical_chart_.out.20150804


   
 
 
 /* if you don't feel like installing another tool...*/
 
 
 for host in host1 host2
 do
   ssh $host ' 
   cd /dir &&
   find . |
   while
     read line
   do
     ls -l "$line"
   done ' | sort  > /tmp/temp.$host.$$
 done
 diff /tmp/temp.*.$$ | less
 echo "don't forget to clean up the temp files!"
 
 
/* And yes, it could be done with find and exec or find and xargs just as easily as find in a for loop. And, also, you can pretty up the output of diff so it says things like "this file is on host1 but not host2" or some such but at that point you may as well just install the tools everyone else is talking about...*/


 
 
 