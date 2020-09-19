import os
from dotenv import load_dotenv

load_dotenv('.env')

def settings():
	return {
		'ezy': {
			'url': 'https://ezy.hr',		
			'login': {
				'username': {
					'selector': '#top1_1_login',
					'value': os.getenv('EZY_USER'),
				},
				'password': {
					'selector': '#top1_1_lozinka',
					'value': os.getenv('EZY_PASS'),
				},
				'submit': {
					'selector': '#top1_1_ImageButton1',
				}
			},
			'search': {
				'query': {
					'selector': '#meni2_upit',
				},
				'submit': {
					'selector': '#meni2_ImageButton1',
				}
			},
			'items': {
				'item': {
					'selector': '#GridView1 > tbody > tr',
					'command': 'if(!item.querySelector(".katalog_slika_razmak")) continue'
				},
				'img': {
					'command': 'item.querySelector("img").src'
				},
				'name': {
					'command': 'item.querySelector("a[rel=iframe]").textContent'
				},
				'price': {
					'command': 'item.querySelector(":nth-child(3)").textContent.trim()'
				},
				'discount': {
					'command': 'item.querySelector(":nth-child(4)").textContent.trim()'
				},
				'quantity': {
					'command': 'item.querySelector(":nth-child(5)").textContent.trim()'
				},
				'url': {
					'command': 'item.querySelector("a[rel=iframe]").href'
				}
			}
		},
		'pioneer': {
			'url': 'https://pioneer.hr',		
			'login': {
				'username': {
					'selector': '',
					'value': '',
				},
				'password': {
					'selector': '',
					'value': '',
				},
				'submit': {
					'selector': '',
				}
			},
			'search': {
				'query': {
					'selector': '#search_query_top',
				},
				'submit': {
					'selector': '[name=submit_search]',
				}
			},
			'items': {
				'item': {
					'selector': '#product_list .product-image-container',
					'command': ''
				},
				'img': {
					'command': 'item.querySelector("img").src'
				},
				'name': {
					'command': 'item.querySelector("[itemprop=url]").title'
				},
				'price': {
					'command': 'item.querySelector(".old-price").textContent'
				},
				'discount': {
					'command': 'item.querySelector(".price").textContent'
				},
				'quantity': {
					'command': '"informacija nije dostupna"'
				},
				'url': {
					'command': 'item.querySelector("[itemprop=url]").href'
				}
			}
		}

	}