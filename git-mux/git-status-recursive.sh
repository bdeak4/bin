#!/usr/bin/env bash

repositories=$(find . -type d -name .git -prune -exec dirname {} \;)

for repository in $repositories; do
	#printf "\e[36m%s\e[0m:\n" "$dir"
	unpushed=$(git -C "$repository" log --branches --not --remotes --oneline | wc -l)
	#printf "%s unpushed commits\n" "$unpushed"
	git -C "$repository" status --short
	echo
done
