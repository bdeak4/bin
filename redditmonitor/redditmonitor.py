#!/usr/bin/env python3

import os, requests, json, csv, pathlib, urllib.parse

rootpath = pathlib.Path(__file__).parent.absolute()
configpath = os.path.join(rootpath, 'config.csv')
historypath = os.path.join(rootpath, 'history')

with open(configpath, 'r') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        subreddit, keyword = row

        query = urllib.parse.quote_plus(keyword)
        res = requests.get(
            f"https://old.reddit.com/r/{subreddit}/search.json?q={query}&sort=new&restrict_sr=on",
            headers = {'User-agent': 'redditmonitor'}
        )
        data = json.loads(res.text)

        items = data['data']['children']
        for item in items:
            found = False
            if pathlib.Path(historypath).is_file():
                with open(historypath, 'r') as historyfile:
                    for line in historyfile:
                        if line == item['data']['permalink'] + '\n':
                            found = True

            if not found:
                with open(historypath, 'a') as historyfile:
                    historyfile.write(item['data']['permalink'] + '\n')

                print('https://old.reddit.com' + item['data']['permalink'])
