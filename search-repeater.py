import webbrowser, time, urllib.parse
from configparser import ConfigParser
import tkinter as tk
from tkinter import ttk, font

### config

# parse config
config = ConfigParser()
config.read('config.ini')

sites_available = list(config.items('sites'))
sites_selected = []

### handle submit

def submit(event=None):
    q = query.get()
    urls = []

    for i, site in enumerate(sites_selected):
        if site.get() != '0':
            url, encode_type = sites_available[i][1].split('\n')

            if encode_type == 'quote_plus':
                encoded_query = urllib.parse.quote_plus(q)

            urls.append(url.replace('QUERY', encoded_query))


    # open new window and first tab
    webbrowser.open_new(urls[0])

    # wait for window and open other tabs
    time.sleep(0.5)
    for url in urls[1:]:
        webbrowser.open_new_tab(url)

### ui

# window
root = tk.Tk()
root.wm_title("search repeater")
query = tk.StringVar(root)

# fonts
box_font = font.Font(size=20)
btn_font = font.Font(size=14)
ttk.Style(root).configure("TButton", font=btn_font)

# elements
ttk.Entry(root, textvariable=query, font=box_font).grid(column=1, row=0)
ttk.Button(root, text='search', command=submit, style="TButton").grid(column=2, row=0)

for i, site in enumerate(sites_available):
    sites_selected.append(tk.StringVar())
    sites_selected[-1].set(0)
    tk.Checkbutton(root, text=site[0], variable=sites_selected[-1], onvalue=1, offvalue=0).grid(column=1, columnspan=2, row=3+i, sticky="w")

# events
root.bind('<Return>', submit)

# padding
root.grid_columnconfigure((0, 3), weight=1, minsize=100)
root.grid_rowconfigure(0, weight=1, minsize=100)
root.grid_rowconfigure(3+len(sites_available), weight=1, minsize=50)

# run
root.mainloop()