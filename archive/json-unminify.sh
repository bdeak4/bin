#!/bin/sh
 
while IFS='$\n' read -r line; do
	if echo $line | grep -q '.*{".*"}.*$'; then
		echo $line | sed 's/{".*}.*//' # before
		echo $line | sed 's/[^{"]*\({".*}\).*/\1/' | jq
		echo $line | sed 's/.*{".*}//' # after
	else
		echo $line
	fi
done
