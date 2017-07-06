#validate existence of arguments
if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Please run with a ticker as the argument."
    exit
fi

command -v jq >/dev/null 2>&1 || { echo >&2 "I require jq but it's not installed.  Aborting."; exit 1; }

#Update Historical data
if test `find "data/historical.txt" -mmin +120`
then
  curl -s https://www.biopharmcatalyst.com/calendars/historical-catalyst-calendar  | grep -oP "ticker.*?<|data-value.*?>" | sed 's/.*>\(.*\)</\1/g' | sed 's/.*\"\(.*\)\".*/ \1/g' | tr -d '\n'|sed 's/\([0-9]\{10\}\)/\1\n/g'| sed 's/\s\+/ /g' | sed 's/Ticker//g' | sed 's/^ //g' | sed 's/^/echo "/; s/\([0-9]\{10\}\)/`date -d @\1 +%F`/; s/$/"/' | bash  > data/historical.txt
fi

tickerName=$1
cat data/historical.txt | grep -i ${tickerName} > data/historytemp.txt
while read p; do
  echo $p
  tickerNameVar=`echo $p | awk '{print $1}'`
  labelType=`echo $p | awk '{print $2}'`
  labelTypeDate=`echo $p | awk -F" " '{print $3}'`
  oldDate=`date -d"${labelTypeDate} -4 week" +%F`
  newDate=`date -d"${labelTypeDate} +1 week" +%F`


#curl -s "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?ticker=$tickerName&start_date=$oldDate&end_date=$newDate&qopts.columns=date,close,high,low&api_key=UsYsv7dKGxHHQ5oURP4B" | jq -c .datatable.data | jq -c . | perl -pe 's/\["([0-9]{4}-[0-9]{2}-[0-9]{2})",(.*?),(.*?),(.*?)\]/{"date": "\1", "close": \2, "high": \3, "low": \4}/g' | jq .
#dates are fixed but...
# getting {"quandl_error":{"code":"QESx08","message":"You cannot use start_date column as a filter."}}
exit
#> data/${tickerName}_${labelType}_${labelTypeDate}.json

  # need to add start and end for quandl query based on $labelTypeDate
  # need to print template for each iteration in loop to build total template.
done <data/historytemp.txt
#curl -s "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?ticker=$tickerName&start_date=$oldDate&end_date=$newDateqopts.columns=date,close,high,low&api_key=UsYsv7dKGxHHQ5oURP4B" | jq -c .datatable.data | jq -c . | perl -pe 's/\["([0-9]{4}-[0-9]{2}-[0-9]{2})",(.*?),(.*?),(.*?)\]/{"date": "\1", "close": \2, "high": \3, "low": \4}/g' | jq . > data/${tickerName}stock.json

#cat template/testtemplate.txt|sed "s/tickerName/$tickerName/g"

#sample quandl query with start and end dates;
#curl "https://www.quandl.com/api/v3/datasets/WIKI/FB.json?column_index=4&start_date=2014-01-01&end_date=2014-12-31&collapse=monthly&transform=rdiff&api_key=YOURAPIKEY"
