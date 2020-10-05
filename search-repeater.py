import webbrowser
import time, urllib.parse

from configparser import ConfigParser
config = ConfigParser()
config.read('config.ini')

query = 'testiranje čć'

selected_sites = [ 'ezy' ]

for site, settings in config.items('sites'):
    if site not in selected_sites:
        continue

    url, encode_type = settings.split('\n')

    if encode_type == 'quote_plus':
        encoded_query = urllib.parse.quote_plus(query)

    url = url.replace('QUERY', encoded_query)

    print(site)
    print(url)

exit()

urls = [
    'https://ezy.hr/katalog.aspx?action=upit&u=modem',
    'https://www.bdeak.net/',
    'https://git.bdeak.net/',
]

webbrowser.open_new(urls[0])

time.sleep(0.5)

for url in urls[1:]:
    webbrowser.open_new_tab(url)
