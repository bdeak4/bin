#!/usr/bin/env bash

dirs=$(find . -type d -name .git -prune -exec dirname {} \;)

for dir in $dirs; do
	printf "\e[36m%s\e[0m:\n" "$dir"
	unpushed=$(git -C "$dir" log --branches --not --remotes --oneline | wc -l)
	printf "%s unpushed commits\n" "$unpushed"
	git -C "$dir" status --short
	echo
done
