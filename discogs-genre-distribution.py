#!/usr/bin/env python

import requests
import json
import time

list_id = "1192264"
base_url = "https://api.discogs.com"

# load cache if it exists
record_cache = {}
try:
    with open("record_cache.json") as f:
        record_cache = json.load(f)
except:
    pass

# fetch list of records
records_res = requests.get(f"{base_url}/lists/{list_id}")
if not records_res.ok:
    raise Exception("Failed to get list")

# fetch record genres and styles
records = records_res.json()["items"]
for record in records:
    if record["resource_url"] in record_cache:
        continue

    record_res = requests.get(record["resource_url"])
    if not record_res.ok:
        raise Exception("Failed to get record")

    record = record_res.json()
    data = {
        "genres": record["genres"] if "genres" in record else [],
        "styles": record["styles"] if "styles" in record else [],
    }
    record_cache[record["resource_url"]] = data

    with open("record_cache.json", "w") as f:
        json.dump(record_cache, f)

    time.sleep(1)

# process data
genres = {}
styles = {}
for record in record_cache.values():
    for genre in record["genres"]:
        if genre in genres:
            genres[genre] += 1
        else:
            genres[genre] = 1

    for style in record["styles"]:
        if style in styles:
            styles[style] += 1
        else:
            styles[style] = 1

# display results
print("GENRES:")
for genre, count in sorted(genres.items(), key=lambda x: x[1], reverse=True):
    print(count, genre)

print("STYLES:")
for style, count in sorted(styles.items(), key=lambda x: x[1], reverse=True):
    print(count, style)
