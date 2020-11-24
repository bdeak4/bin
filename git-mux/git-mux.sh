#!/usr/bin/env bash

repositories=$(find . -type d -name .git -prune -exec dirname {} \;)

for repository in $repositories; do
	unpushed_commits=$(git -C "$repository" log --branches --not --remotes --oneline | wc -l)
	untracked_files=$(git -C "$repository" ls-files --others --exclude-standard | wc -l)
	modified_files=$(git -C "$repository" diff --name-only | wc -l)
	staged_files=$(git -C "$repository" diff --name-only --cached | wc -l)

	if [ "$unpushed_commits" -gt 0 ] || [ "$untracked_files" -gt 0 ] ||
		[ "$modified_files" -gt 0 ] || [ "$staged_files" -gt 0 ]; then
		echo $repository:,$unpushed_commits unpushed,$untracked_files untracked,\
			$modified_files modified,$staged_files staged
	fi
done | column -t -s ,
