#!/usr/bin/env bash

repositories=$(find . -type d -name .git -prune -exec dirname {} \;)

for repository in $repositories; do
	echo $repository:

	if [ "$1" = "stats" ]; then
		unpushed=$(git -C "$repository" log --branches --not --remotes --oneline | wc -l)
		untracked=$(git -C "$repository" ls-files --others --exclude-standard | wc -l)
		modified=$(git -C "$repository" diff --name-only | wc -l)
		staged=$(git -C "$repository" diff --name-only --cached | wc -l)


		if [ "$unpushed" -gt 0 ] || [ "$untracked" -gt 0 ] || [ "$modified" -gt 0 ] || [ "$staged" -gt 0 ]; then
			echo $unpushed unpushed, $untracked untracked, $modified modified, $staged staged
		fi
	else
		git -C "$repository" $@
	fi
done
