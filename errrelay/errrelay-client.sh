#!/usr/bin/env bash

log_file=$1
url=$2
timeout=5m

[ -z "$log_file" ] && echo "Must supply log file" && exit 1
[ -z "$url" ] && echo "Must supply url" && exit 1

line_number=$(wc -l < $log_file)

while sleep $timeout; do
	new_line_number=$(wc -l < $log_file)

	if [ "$new_line_number" -ne "$line_number" ]; then
		diff_lines=$(( $new_line_number - $line_number ))
		diff=$(tail -$diff_lines $log_file)
		printf "log_file=$log_file&diff=$diff" |
		curl -XPOST --data-binary @- $url

		line_number=$new_line_number
	fi
done