#!/bin/sh
# Simple HTTP Status Logger V0.1.0

## Original https://qiita.com/Kakimoty_Field/items/754df3a181187fbb517c

## Example: sh sh_checkurl.sh http://example.com checkurl.log 10
### Check status of http://example.com every 10 seconds and save the result into ./checkurl.log
## $1 = Target URL
## $2 = Log Txt Filename (path from shell script)
## $3 = Interval seconds


## If the variables are more than three, stop executing
if [ $# -gt 3 ]; then
 exit 0
fi

## 値の設定
targetUrl=$1
logFilename=$2
IntervalSec=$3

echo " -- -- -- -- -- -- -- -- -- -- --"
echo "  Check HTTP Status"
echo " -- -- -- -- -- -- -- -- -- -- --"
echo "Tareget URL  : ${targetUrl}"
echo "Log File Name: ${logFilename}"
echo "Interval     : ${IntervalSec}"
echo " -- -- -- -- -- -- -- -- -- -- --"
echo "[y]. Proceed?"
echo "[q]. Quit?"
read -p "Enter your selection:  (y/q): " yesno
case "$yesno" in [yY]*) ;; *) echo "Sorry, see you soon!" ; exit 0 ;; esac

while :
do
    ## try accessing to target_url
    datetime="$(date "+%Y/%m/%d %H:%M:%S")"
    message=`curl -o /dev/null -s -w %{http_code} $targetUrl`

    ## output log
    message="${datetime},${message},${targetUrl}"
    echo ${message} >> ${logFilename}
    echo ${message}
    sleep ${IntervalSec}
done