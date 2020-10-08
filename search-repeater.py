

import webbrowser
import time, urllib.parse

from configparser import ConfigParser
config = ConfigParser()
config.read('config.ini')


import tkinter as tk
from tkinter import ttk, font




def submit(event=None):
    q = query.get()
    print(q)

### ui

# window
root = tk.Tk()
root.geometry('600x200')
root.wm_title("search repeater")
query = tk.StringVar(root)

# fonts
box_font = font.Font(size=20)
btn_font = font.Font(size=14)
ttk.Style(root).configure("TButton", font=btn_font)

# elements
box = ttk.Entry(root, textvariable=query, font=box_font).grid(column=1, row=0)
btn = ttk.Button(root, text='search', command=submit, style="TButton").grid(column=2, row=0)

# events
root.bind('<Return>', submit)

# center
root.grid_columnconfigure((0, 3), weight=1)
root.grid_rowconfigure(0, weight=1)

# run
root.mainloop()



exit()




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
