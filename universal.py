#!/usr/bin/env python

import requests
from bs4 import BeautifulSoup


# requests.post('https://ezy.hr/', data=login_data)

# search_data = {
# 	"action": "upit",
# 	"u": "modem"
# }
# r = requests.get('https://ezy.hr/katalog.aspx', params=search_data)


# with open('out.txt', 'w') as f:
# 	f.write(r.text)


text = ''

with open('out.txt', 'r') as f:
	text = f.read()

soup = BeautifulSoup(text, 'html.parser')
# soup = BeautifulSoup(r.text, 'html.parser')

for item in soup.select('#GridView1 tr:not([bgcolor])'):
	if (a := item.select('[rel="iframe"]')):
		title = a[0].contents[0]
		url = a[0].get('href')
		img = item.find('img').get('src')
		price = item.select('span')
		print(title)
		print(url)
		print(img)
		print(price)

	# search_price_selector: '#GridView1_ctl02_Label7',
	# search_quantity_selector: '#GridView1_ctl05_Label8',