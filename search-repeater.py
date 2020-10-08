import webbrowser, os, time, urllib.parse
from configparser import ConfigParser
import tkinter as tk
from tkinter import ttk, font


### config

# parse config
config = ConfigParser()
config.read('config.ini')

sites_available = list(config.items('sites'))
site_selections = []

settings = dict(config.items('settings'))
browser = webbrowser.get(settings['browser'])

### handle submit

def submit(event=None):
    query = search_input.get()
    urls = []

    for i, site in enumerate(site_selections):
        if site.get() != '0':
            url, encode_type = sites_available[i][1].split(',')

            if encode_type == 'quote_plus':
                encoded_query = urllib.parse.quote_plus(query)

            urls.append(url.replace('QUERY', encoded_query))

    os.system(settings['browser'])
    time.sleep(0.3)

    for url in urls:
        browser.open(url)


### ui

root = tk.Tk()
root.wm_title("search repeater")
root.tk.call('wm', 'iconphoto', root._w, tk.PhotoImage(file='icon.png'))
search_input = tk.StringVar(root)

# fonts
box_font = font.Font(size=20)
btn_font = font.Font(size=16)
ttk.Style(root).configure("TButton", font=btn_font)
check_font = font.Font(size=14)

# elements
ttk.Entry(root, textvariable=search_input, font=box_font).grid(column=1, row=0)
ttk.Button(root, text='search', command=submit, style="TButton").grid(column=2, row=0)

for i, site in enumerate(sites_available):
    site_selections.append(tk.StringVar())
    site_selections[-1].set(0)
    tk.Checkbutton(root, text=site[0], variable=site_selections[-1], onvalue=1, offvalue=0, font=check_font
    ).grid(column=1, columnspan=2, row=3+i, sticky="w")

# events
root.bind('<Return>', submit)

# padding
root.grid_columnconfigure((0, 3), weight=1, minsize=100)
root.grid_rowconfigure(0, weight=1, minsize=100)
root.grid_rowconfigure(3+len(sites_available), weight=1, minsize=50)

root.mainloop()