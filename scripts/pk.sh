#set variable for start-date
#set variable for end-date
#set variable for pdufa date
#set variable for ticker

ticker=$1
echo $ticker
exit
#pull history
curl -s "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?ticker=FB&qopts.columns=date,close,high,low&api_key=UsYsv7dKGxHHQ5oURP4B" | jq -c .datatable.data | jq -c . | perl -pe 's/\["([0-9]{4}-[0-9]{2}-[0-9]{2})",(.*?),(.*?),(.*?)\]/{"date": "\1", "close": \2, "high": \3, "low": \4}/g' | jq . > data/stock.json
