#!/bin/bash
#placeholder script for historical analysis
curl https://www.biopharmcatalyst.com/calendars/historical-catalyst-calendar  | grep -oP "ticker.*?<|data-value.*?>" | sed 's/.*>\(.*\)</\1/g' | sed 's/.*\"\(.*\)\".*/ \1/g' | tr -d '\n'|sed 's/\([0-9]\{10\}\)/\1\n/g'| sed 's/\s\+/ /g' | sed 's/Ticker//g' | sed 's/^ //g' | perl -pe 'if ( ($t) = /(1[0-9]+)/ ) { s/$t/localtime($t)/e }'
