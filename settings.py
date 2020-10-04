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
					'selector_command': '',
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
					'selector_command': '',
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
		},
		'asbis': {
			'url': 'https://www.it4profit.com/shop/login.xhtml',
			'login': {
				'username': {
					'selector': '.login-panel-username-label ~ input',
					'value': os.getenv('ASBIS_USER'),
				},
				'password': {
					'selector': '.login-panel-password-label ~ input',
					'value': os.getenv('ASBIS_PASS'),
				},
				'submit': {
					'selector': 'button[type=submit]',
				}
			},
			'search': {
				'query': {
					'selector': '.simple-search-panel input',
				},
				'submit': {
					'selector': '.simple-search-panel button[type=submit]',
				}
			},
			'items': {
				'item': {
					'selector': '.cs-data-item',
					'selector_command': '''
					if(!items.length && !document.querySelector("ui-datatable-empty-message")) {
						let out = []
						let spec = document.querySelector('.compare-prod-spec')

						let first_row = spec.querySelector("dl:nth-child(1)")
						let second_row = spec.querySelector("dl:nth-child(2)")
						let fourth_row = spec.querySelector("dl:nth-child(4)")
						let sixth_row = spec.querySelector("dl:nth-child(6)")

						let imgs = first_row.querySelectorAll('img')
						let names = second_row.querySelectorAll('.compare-prod-spec-val')
						let prices = fourth_row.querySelectorAll('.product-retail-price')
						let discounts = fourth_row.querySelectorAll('.product-customer-price')
						let quantities = sixth_row.querySelectorAll('.compare-prod-spec-val')

						let j = 0
						for(let i = 0; i < imgs.length; i++) {
							if(j < 5) j++
							else continue
							out.push({
								image: imgs[i].src,
								name: names[i].textContent,
								price: prices[i].textContent,
								discount: discounts[i].textContent,
								quantity: quantities[i].textContent.trim(),
								url: imgs[i].parentElement.parentElement.href,
							})
						}

						return out
					} else {
						btn = document.querySelector('.svt-to-grid')
						if (btn !== null) btn.click()
						items = document.querySelectorAll(".cs-data-item")
					}
					''',
					'command': ''
				},
				'img': {
					'command': 'item.querySelector("img").src'
				},
				'name': {
					'command': 'item.querySelector(".cs-product-name").textContent'
				},
				'price': {
					'command': 'item.querySelector(".product-retail-price").textContent'
				},
				'discount': {
					'command': 'item.querySelector(".product-customer-price").textContent'
				},
				'quantity': {
					'command': 'item.querySelector(".products-stock-container").textContent.trim()'
				},
				'url': {
					'command': 'item.querySelector("a").href'
				}
			}
		}

	}