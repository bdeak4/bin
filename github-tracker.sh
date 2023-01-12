#!/bin/sh
#
#

created_at=${1:-$(date --rfc-3339=seconds -d '-1 day' --utc | cut -d'+' -f1)}
users=$(cat - | paste -s | sed "s/\t/','/g")

curl -s 'https://play.clickhouse.com/?user=play' \
  -X POST \
  --data-raw "
  SELECT created_at, actor_login, event_type, concat('https://github.com/', repo_name)
  FROM github_events
  WHERE actor_login IN ('$users')
    AND created_at >= '$created_at'
  ORDER BY created_at
  " \
| column -t -s '	' -o '    '
