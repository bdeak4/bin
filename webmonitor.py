#!/usr/bin/env python3

import os, requests, csv, pathlib, hashlib
from bs4 import BeautifulSoup

rootpath = pathlib.Path(__file__).parent.absolute()
configpath = os.path.join(rootpath, 'config.csv')
historypath = os.path.join(rootpath, 'history.csv')

with open(configpath, 'r') as configfile:
    configreader = csv.reader(configfile)
    for row in configreader:
        url, selectors = row

        html = requests.get(url, headers = {'User-agent': 'webmonitor'}).text
        if selectors:
            soup = BeautifulSoup(html, 'html.parser')
            for selector in selectors.split('|'):
                for tag in soup.select(selector):
                    tag.decompose()
            html = soup.prettify()
        htmlhash = hashlib.sha256(html.encode('utf-8')).hexdigest()

        changed = True
        if pathlib.Path(historypath).is_file():
            with open(historypath, 'r') as historyfile:
                historyreader = csv.reader(historyfile)
                for row in historyreader:
                    historyurl, historyhash = row
                    if url == historyurl and htmlhash == historyhash:
                        changed = False

        if changed:
            with open(historypath, 'a') as historyfile:
                historyfile.write(f"{url},{htmlhash}\n")

            print(url)
