#!/usr/bin/env python3

import requests, json

subreddit = 'croatia'
keyword = 'programiranje'

r = requests.get(
        'https://old.reddit.com/r/%s/search.json?q=%s&sort=new&restrict_sr=on' % (subreddit, keyword),
        headers = {'User-agent': 'redditmonitor'}
)
json = json.loads(r.text)

items = json['data']['children']

for item in items:
    print(item['data']['title'])

