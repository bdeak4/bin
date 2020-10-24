#!/usr/bin/env python3

import os, requests, csv, pathlib, hashlib

rootpath = pathlib.Path(__file__).parent.absolute()
configpath = os.path.join(rootpath, 'config')
historypath = os.path.join(rootpath, 'history')

with open(configpath, 'r') as configfile:
    for line in configfile:
        url = line.rstrip()

        html = requests.get(url, headers = {'User-agent': 'webmonitor'}).text
        htmlhash = hashlib.sha256(html.encode('utf-8')).hexdigest()

        changed = True
        if pathlib.Path(historypath).is_file():
            with open(historypath, 'r') as historyfile:
                reader = csv.reader(historyfile)
                for row in reader:
                    historyurl, historyhash = row
                    if url == historyurl and htmlhash == historyhash:
                        changed = False

        if changed:
            with open(historypath, 'a') as historyfile:
                historyfile.write(f"{url},{htmlhash}\n")

            print(url)
