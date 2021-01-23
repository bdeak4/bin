#!/usr/bin/env bash

resource=${1^^}
threshold=${2}

if [ "$#" -ne 2 ]; then
	echo "$0 <resource> <threshold>"; exit 1
fi

case $resource in
	"MEM") resource_value=$(free -m | awk 'NR==2{printf "%d\n",$3*100/$2}') ;;
	"CPU") resource_value=$(mpstat 1 2 | awk 'END{printf "%d\n",100-$NF}') ;;
	"DISK") resource_value=$(df | awk '$NF=="/"{printf "%d\n",$5}') ;;
	*) echo "$0 <resource> can be MEM, CPU or DISK"; exit 2 ;;
esac

if [ "$threshold" -lt 0 ] || [ "$threshold" -gt 100 ]; then
	echo "$0 <threshold> can be between 0 and 100"; exit 2
fi

if [ "$resource_value" -gt "$threshold" ]; then
	sleep 5
	case $resource in
		"MEM") top -bn1 -o\%MEM | head -30 ;;
		"CPU") top -bn1 -o\%CPU | head -30 ;;
		"DISK") df -h ;;
	esac
fi
