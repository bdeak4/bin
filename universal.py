#!/usr/bin/env python

import sys, time
from selenium.webdriver import Firefox, FirefoxOptions
import geckodriver_autoinstaller
from pathlib import Path
from settings import settings
from helpers import fill_input, click_button

geckodriver_autoinstaller.install()
options = FirefoxOptions()
# options.headless = True

settings = settings()
query = sys.argv[1]
pages = sys.argv[2].split(',')

html = ''

for page in pages:
	if not page in settings:
		continue

	driver = Firefox(options=options)

	driver.get(settings[page]['url'])

	# login

	if (u := settings[page]['login']['username'])['value']:
		fill_input(driver, u['selector'], u['value'])

	if (p := settings[page]['login']['password'])['value']:
		fill_input(driver, p['selector'], p['value'])

	time.sleep(5)

	if (s := settings[page]['login']['submit'])['selector']:
		click_button(driver, s['selector'])

	time.sleep(5)

	if page == 'asbis':
		driver.execute_script("document.querySelector('form').submit()")

	time.sleep(5)

	# search

	if (q := settings[page]['search']['query'])['selector']:
		fill_input(driver, q['selector'], query)

	if (s := settings[page]['search']['submit'])['selector']:
		click_button(driver, s['selector'])

	# aggregate results

	while (len(driver.execute_script('return document.querySelectorAll("%s")' % 
				(settings[page]['items']['item']['selector']))) == 0):
		time.sleep(1)

	items = driver.execute_script('''
	let items = document.querySelectorAll("%s")
	%s
	const out = []
	let j = 0
	for(let i = 0; i < items.length; i++) {
		const item = items[i]
		%s
		if(j < 5) j++ 
		else continue
		out.push({
			image: %s,
			name: %s,
			price: %s,
			discount: %s,
			quantity: %s,
			url: %s,
		})
	}
	return out
	''' % (
		settings[page]['items']['item']['selector'], 
		settings[page]['items']['item']['selector_command'],
		settings[page]['items']['item']['command'], 
		settings[page]['items']['img']['command'],
		settings[page]['items']['name']['command'], 
		settings[page]['items']['price']['command'],
		settings[page]['items']['discount']['command'],
		settings[page]['items']['quantity']['command'], 
		settings[page]['items']['url']['command']))

	url = driver.execute_script('return window.location.href')

	# build html

	html += '<h1>%s</h1>' % (page)
	html += '<table><thead><tr>'
	html += '<th>Slika</th>'
	html += '<th>Naziv</th>'
	html += '<th>Cijena/VPC</th>'
	html += '<th>Cijena s popustom/rabatom</th>'
	html += '<th>Količina</th>'
	html += '</tr></thead><tbody>'
	
	for item in items:
		html += '<tr>'
		html += '<td><img src="%s"></td>' % (item['image'])
		html += '<td><a href="%s">%s</a></td>' % (item['url'], item['name'])
		html += '<td>%s</td>' % (item['price'])
		html += '<td>%s</td>' % (item['discount'])
		html += '<td>%s</td>' % (item['quantity'])
		html += '</tr>'
	
	html += '</tbody></table>'
	html += '<a href="%s">Prikazi sve &rarr;</a>' % (url)

	# driver.quit()

Path('index.html').write_text(html)