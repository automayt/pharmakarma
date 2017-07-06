#validate existence of arguments
if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Please run with a ticker as the argument."
    exit
fi

command -v jq >/dev/null 2>&1 || { echo >&2 "I require jq but it's not installed.  Aborting."; exit 1; }

#Update Historical data
if [ ! -f data/historical.txt ]; then
  curl -s https://www.biopharmcatalyst.com/calendars/historical-catalyst-calendar  | grep -oP "ticker.*?<|data-value.*?>" | sed 's/.*>\(.*\)</\1/g' | sed 's/.*\"\(.*\)\".*/ \1/g' | tr -d '\n'|sed 's/\([0-9]\{10\}\)/\1\n/g'| sed 's/\s\+/ /g' | sed 's/Ticker//g' | sed 's/^ //g' | sed 's/^/echo "/; s/\([0-9]\{10\}\)/`date -d @\1 +%F`/; s/$/"/' | bash  > data/historical.txt
else
if test `find "data/historical.txt" -mmin +120`
then
  curl -s https://www.biopharmcatalyst.com/calendars/historical-catalyst-calendar  | grep -oP "ticker.*?<|data-value.*?>" | sed 's/.*>\(.*\)</\1/g' | sed 's/.*\"\(.*\)\".*/ \1/g' | tr -d '\n'|sed 's/\([0-9]\{10\}\)/\1\n/g'| sed 's/\s\+/ /g' | sed 's/Ticker//g' | sed 's/^ //g' | sed 's/^/echo "/; s/\([0-9]\{10\}\)/`date -d @\1 +%F`/; s/$/"/' | bash  > data/historical.txt
  fi
fi

tickerName=$1
cat data/historical.txt | grep -i ${tickerName} > data/historytemp.txt
while read p; do
  tickerNameVar=`echo $p | awk '{print $1}'`
  labelType=`echo $p | awk '{print $2}'|tr -dc '[:alnum:]\n\r'`
  labelTypeDate=`echo $p | awk -F" " '{print $3}'`
  oldDate=`date -d"${labelTypeDate} -4 week" +%F`
  newDate=`date -d"${labelTypeDate} +2 week" +%F`
  titleHere=`echo ${tickerNameVar} ${labelType} on ${labelTypeDate}`

#working, need to uncomment
curl -s "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?ticker=$tickerName&date.gt=$oldDate&date.lt=$newDate&qopts.columns=date,close,high,low&api_key=UsYsv7dKGxHHQ5oURP4B" | jq -c .datatable.data | jq -c . | perl -pe 's/\["([0-9]{4}-[0-9]{2}-[0-9]{2})",(.*?),(.*?),(.*?)\]/{"date": "\1", "close": \2, "high": \3, "low": \4}/g' | jq . > data/${tickerNameVar}_${labelType}_${labelTypeDate}.json
allData+=`cat template/testtemplate.txt | sed "s/tickerName_labelType_labelTypeDate/${tickerNameVar}_${labelType}_${labelTypeDate}/g" | sed "s/labelTypeDate/${labelTypeDate}/g"| sed "s/labelType/${labelType}/g" | sed "s/titleHere/${titleHere}/g"`
done <data/historytemp.txt
echo $allData > temp.test

#cat template/conf.html | sed -e "s/replaceDataHere/${allData}/g"

sed '/replaceDataHere/{
    s/replaceDataHere//g
    r temp.test
}' template/conf.html
rm temp.test
