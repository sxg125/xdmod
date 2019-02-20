# Created by Sanjaya May 22, 2014
# Updated on May 23, 2016
# This script automatically dumps recently created Group and Department for XDMOD 

YESTERDAY=`date +%Y-%m-%d -d yesterday`
TODAYIS=`date -I`

CSVPATH="/var/xdmod/csv"
cd $CSVPATH

#Dump the Group and Department Data

mysql -u root -p<database-pwd> <data-base> --skip-column-names -e "select DISTINCT group_name,dept.dept_query from fin LEFT JOIN user ON pi_username=caseid LEFT JOIN dept ON dept_id=dept.id WHERE NOT dept_id=\"NULL\" AND user.date_created>=UNIX_TIMESTAMP('$YESTERDAY') AND user.date_created<=UNIX_TIMESTAMP('$TODAYIS') AND user.enabled=1 ORDER BY group_name" > test;

#Convert to CSV format

cat test | awk  -F'\t' '{printf "\"%s\",\"%s\"\n", $1,$2}' >> group-to-hierarchy.csv
cat test | awk  -F'\t' '{printf "\"%s\",\"%s\",dept\n", $2,$2}' >> hierarchy.csv

#Import CSV to apply hierarchy rule

/usr/local/xdmod/bin/xdmod-import-csv -t hierarchy -i hierarchy.csv
/usr/local/xdmod/bin/xdmod-import-csv -t group-to-hierarchy -i group-to-hierarchy.csv 
