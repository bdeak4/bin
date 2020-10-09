from cx_Freeze import setup, Executable

# Dependencies are automatically detected, but it might need
# fine tuning.
build_options = {
    'packages': [], 
    'excludes': [], 
    'build_exe': './/dist',
    'include_files': ['icon.ico', 'config.ini']
}

import sys
base = 'Win32GUI' if sys.platform=='win32' else None

executables = [
    Executable('search-repeater.py', base=base, icon="icon.ico")
]

setup(name='search repeater',
      version = '1.0',
      description = '',
      options = {'build_exe': build_options},
      executables = executables)
