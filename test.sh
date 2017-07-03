if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Please run with a ticker as the argument."
    exit
fi

#Update Historical data
if test `find "data/historical.txt" -mmin +120`
then
  curl -s https://www.biopharmcatalyst.com/calendars/historical-catalyst-calendar  | grep -oP "ticker.*?<|data-value.*?>" | sed 's/.*>\(.*\)</\1/g' | sed 's/.*\"\(.*\)\".*/ \1/g' | tr -d '\n'|sed 's/\([0-9]\{10\}\)/\1\n/g'| sed 's/\s\+/ /g' | sed 's/Ticker//g' | sed 's/^ //g' | sed 's/^/echo "/; s/\([0-9]\{10\}\)/`date -d @\1 +%F`/; s/$/"/' | bash  > data/historical.txt
fi

tickerName=$1
curl -s "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?ticker=$tickerName&qopts.columns=date,close,high,low&api_key=UsYsv7dKGxHHQ5oURP4B" | jq -c .datatable.data | jq -c . | perl -pe 's/\["([0-9]{4}-[0-9]{2}-[0-9]{2})",(.*?),(.*?),(.*?)\]/{"date": "\1", "close": \2, "high": \3, "low": \4}/g' | jq . > data/${tickerName}stock.json

#cat template/testtemplate.txt|sed "s/tickerName/$tickerName/g"

cat data/historical.txt | grep -i ${1}
