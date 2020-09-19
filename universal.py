#!/usr/bin/env python

import time
from selenium.webdriver import Firefox, FirefoxOptions
import geckodriver_autoinstaller
from pathlib import Path


login_username_value = ''
login_username_selector = '#top1_1_login'
login_password_value = ''
login_password_selector = '#top1_1_lozinka'
login_submit_selector = '#top1_1_ImageButton1'

search_query_selector = '#meni2_upit'
search_query_value = 'unifi'
search_submit_selector = '#meni2_ImageButton1'

geckodriver_autoinstaller.install()

options = FirefoxOptions()
options.headless = True
driver = Firefox(options=options)

driver.get('https://ezy.hr')

driver.execute_script('document.querySelector("%s").value = "%s"' % (login_username_selector, login_username_value))
driver.execute_script('document.querySelector("%s").value = "%s"' % (login_password_selector, login_password_value))
driver.execute_script('document.querySelector("%s").click()' % (login_submit_selector))
driver.execute_script('document.querySelector("%s").value = "%s"' % (search_query_selector, search_query_value))
driver.execute_script('document.querySelector("%s").click()' % (search_submit_selector))

item_selector = '#GridView1 > tbody > tr'
item_img_selector = 'querySelector("img").src'
item_name_selector = 'querySelector("a[rel=iframe]").textContent'
item_price_selector = 'querySelector(":nth-child(3)").textContent.trim()'
item_discount_selector = 'querySelector(":nth-child(4)").textContent.trim()'
item_quantity_selector = 'querySelector(":nth-child(5)").textContent.trim()'
item_url_selector = 'querySelector("a[rel=iframe]").href'

while (len(driver.execute_script('return document.querySelectorAll("%s")' % (item_selector))) == 0):
	time.sleep(1)

items = driver.execute_script('''
const items = document.querySelectorAll("%s")
const out = []
const len = items.length < 10 ? items.length : 10

for(let i = 1; i < len; i += 2) {
	const item = {
		image:    items[i].%s,
		name:     items[i].%s,
		price:    items[i].%s,
		discount: items[i].%s,
		quantity: items[i].%s,
		url:      items[i].%s,
	}
	out.push(item)
}
return out
''' % (item_selector, item_img_selector, item_name_selector, item_price_selector, item_discount_selector, item_quantity_selector, item_url_selector))

url = driver.execute_script('return window.location.href')

html = '<h1>ezy.hr</h1>'
html += '<table><tbody>'

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

Path('index.html').write_text(html)

driver.quit()

