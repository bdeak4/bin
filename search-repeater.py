import webbrowser
import time

urls = [
    'https://ezy.hr/katalog.aspx?action=upit&u=modem',
    'https://www.bdeak.net/',
    'https://git.bdeak.net/',
]

webbrowser.open_new(urls[0])

time.sleep(0.5)

for url in urls[1:]:
    webbrowser.open_new_tab(url)
