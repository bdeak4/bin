#!/bin/sh

echo Ask HN top this week
curl -s 'https://uj5wyc0l7x-dsn.algolia.net/1/indexes/Item_production/query?x-algolia-agent=Algolia%20for%20JavaScript%20(4.0.2)%3B%20Browser%20(lite)&x-algolia-api-key=8ece23f8eb07cd25d40262a1764599b1&x-algolia-application-id=UJ5WYC0L7X' -H 'User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:88.0) Gecko/20100101 Firefox/88.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'content-type: application/x-www-form-urlencoded' -H 'Origin: https://hn.algolia.com' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://hn.algolia.com/' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' --data-raw '{"query":"ask hn","analyticsTags":["web"],"page":0,"hitsPerPage":20,"minWordSizefor1Typo":4,"minWordSizefor2Typos":8,"advancedSyntax":true,"ignorePlurals":false,"clickAnalytics":false,"minProximity":8,"numericFilters":["created_at_i>'"$(date -d last-sunday +%s)"'"],"tagFilters":["story",[]],"typoTolerance":true,"queryType":"prefixLast","restrictSearchableAttributes":["title","comment_text","url","story_text","author"],"getRankingInfo":false}' | jq -j '.hits[] | .title + " (https://news.ycombinator.com/item?id=" + .objectID + ")\n"'
