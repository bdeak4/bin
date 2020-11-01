#!/usr/bin/env bash

resource=${1^^}
threshold=${2}

if [ "$#" -ne 2 ]; then
	echo "$0 <resource> <threshold>"
	exit 1
fi

if [ "$resource" != "MEM" ] && [ "$resource" != "CPU" ]; then
	echo "$0 <resource> can be either MEM or CPU"
	exit 2
fi

if [ "$threshold" -lt 0 ] || [ "$threshold" -gt 100 ]; then
	echo "$0 <threshold> can be between 0 and 100"
	exit 2
fi

case $resource in
	"MEM") resource_value=$(free -m | awk 'NR==2{printf "%d\n",$3*100/$2}') ;;
	"CPU") resource_value=$(mpstat 1 2 | awk 'END{print 100-$NF}') ;;
esac

if [ "$resource_value" -gt "$threshold" ]; then
	top -bn1 -o\%$resource | head -30
fi
