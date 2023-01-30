#!/usr/bin/env python

import sys
import requests
import json
import time

list_id = sys.argv[1]
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
        "year": record["year"],
    }
    record_cache[record["resource_url"]] = data

    with open("record_cache.json", "w") as f:
        json.dump(record_cache, f)

    time.sleep(1)

# process data
genres, styles = {}, {}
years, decades = {}, {}
for record in record_cache.values():
    for genre in record["genres"]:
        genres[genre] = genres[genre] + 1 if genre in genres else 1

    for style in record["styles"]:
        styles[style] = styles[style] + 1 if style in styles else 1

    year = record["year"]
    years[year] = years[year] + 1 if year in years else 1
    decade = int(year / 10) * 10
    decades[decade] = decades[decade] + 1 if decade in decades else 1

# display results
print("GENRES:")
for genre, count in sorted(genres.items(), key=lambda x: x[1], reverse=True):
    print(count, genre)

print()

print("STYLES:")
for style, count in sorted(styles.items(), key=lambda x: x[1], reverse=True):
    print(count, style)

print()

print("YEARS:")
for year, count in sorted(years.items(), key=lambda x: x[1], reverse=True):
    print(count, year)

print()

print("DECADES:")
for decade, count in sorted(decades.items(), key=lambda x: x[1], reverse=True):
    print(count, decade)
