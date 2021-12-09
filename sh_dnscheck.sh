#! /bin/sh
# DNS Check script v1.0.0

# Variables
# ----------
# sh sh_dnscheck.sh "[Site Name]" [Domain] [Record Type] [Interval Sec] [enable short mode?] [NS Server]
# sh sh_dnscheck.sh "Kikusui Gakuen" kikusui-gakuen.jp SOA 10 y 8.8.8.8

# Debug
# SiteName="Kikusui Gakuen"
# Domain="kikusui-gakuen.jp"
# Type="SOA"
# IntervalSec="10"
# DNSServer="8.8.8.8" # Enter the autority NS

# don't distinguish small letter and capital letter input
shopt -s nocasematch

SiteName=$1
Domain=$2
Type=$3
IntervalSec=$4
Short=$5
DNSServer=$6

if [ $DNSServer ]; then
    DNSServerOption="@${DNSServer}"
fi

if [ "$Short" = "y" ] || [ "$Short" = "Y" ] || [ "$Short" = "true" ] || [ "$Short" = "True" ] || [ "$Short" = "TRUE" ]; then
    ShortOption="+short"
fi

do_main_menu()
{
while [ "$i" != "q" ]; do
    echo "=============================="
    echo "${SiteName} DNS Check"
    echo "Domain: ${Domain}"
    echo "Type: ${Type}"
    echo "Interval: ${IntervalSec}"
    echo "Short Mode: ${Short}"
    echo "DNS: ${DNSServer}"
    echo "=============================="
    echo "Proceed?"
    echo "- enter 'y' or 'yes' for normal check"
    echo "- enter 'c', 'change' or 'compare' for change comparison check" 
    read i
    i=`echo $i | tr '[A-Z]' '[a-z]'`
    case "$i" in 
	"q"|"quit"|"exit")
	echo "Sorry this is not the script you are looking for!"
	exit 0
	;;
	"y"|"yes")
	echo "Now executing: normal check"
    dnscheck_main
    exit;
	;;
	"c"|"change"|"compare")
	echo "Now executing: change comparison check"
    dnscheck_compare
    exit;
	;;
	*)
	echo "Unrecognised input."
	;;
    esac
  done
}

dnscheck_main()
{
while :
do
    echo "=============================="
    echo "${SiteName} DNS Check"
    echo "Domain: ${Domain}"
    echo "Type: ${Type} Interval: ${IntervalSec}"
    echo "DNS: ${DNSServer}"
    echo "------------------------------"
    echo "$(date "+%Y/%m/%d-%H:%M:%S")"
    echo "* ctlr+c to stop"
    echo "=============================="
    dig -t ${Type} ${Domain} ${DNSServerOption} ${ShortOption}
    sleep ${IntervalSec}
done
}

dnscheck_compare()
{
echo "=============================="
echo "${SiteName} DNS Check"
echo "Domain: ${Domain}"
echo "Type: ${Type}"
echo "Interval: ${IntervalSec}"
echo "DNS: ${DNSServer}"
echo "------------------------------"
echo "$(date "+%Y/%m/%d-%H:%M:%S")"
echo "* ctlr+c to stop"
echo "=============================="
FirstResult=$(dig -t ${Type} ${Domain} ${DNSServerOption} +short)
echo "First Result: ${FirstResult}"
while :
do
    CurrentResult=$(dig -t ${Type} ${Domain} ${DNSServerOption} ${ShortOption})
    if [ "$FirstResult" = "$CurrentResult" ]; then
        echo "No change at $(date "+%Y/%m/%d-%H:%M:%S") * ctlr+c to stop"
    else
        echo "***** RECORD CHANGED *****"
        echo "=============================="
        echo "${SiteName} DNS Check"
        echo "Domain: ${Domain}"
        echo "Type: ${Type} Interval: ${IntervalSec}"
        echo "DNS: ${DNSServer}"
        echo "------------------------------"
        echo "Change detected at"
        echo "$(date "+%Y/%m/%d-%H:%M:%S")"
        echo "------------------------------"
        echo "Old Record:"
        echo "$FirstResult"
        echo "New Record:"
        echo "$CurrentResult"
        echo "=============================="
        exit
    fi;
    sleep ${IntervalSec}
done
}

do_main_menu