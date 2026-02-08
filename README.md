# VIM GNOME darkmode sync

Archived, used [vim-lumen](https://github.com/vimpostor/vim-lumen) instead.

------------

Aims to provide a mechanism to sync dark-style mode into running non-GUI local
VIM instances under a GNOME desktop. This is likely a stop gap fix until a
better approach is available.

## Installation

If you use [vim-plug](https://github.com/junegunn/vim-plug), then add the
following line to your `vimrc` file:

```vim
Plug 'cheywood/vim-gnome-darkmode-sync'
```

Or use some other plugin manager:
- [vundle](https://github.com/gmarik/vundle)
- [neobundle](https://github.com/Shougo/neobundle.vim)
- [pathogen](https://github.com/tpope/vim-pathogen)

## Requirements

Only works under GNOME; the plugin will check the `XDG_CURRENT_DESKTOP` 
environment varible. Python 3 is used to connect to the GNOME dark style
preference, requiring the Python 3 bindings for gobject-introspection
libraries (`python3-gi` on Debian-based distros).

## Usage

The plugin runs logic upon startup and any change of the dark style preference.
By default that logic sets the background light or dark.

If a callback is configured that function will be called with either "dark" or
"light" allowing custom logic to be applied. When a custom function is used
that replaces the default logic.

## Configuration

```vim
" Run custom logic upon dark mode switch. Function is called with 'light' or 
" 'dark'
let g:gnome_darkmode_callback = 'CustomDarkmodeChangeFunctionName'
```

## Disclaimer

This is a fairly quick rough cut. There are likely far better ways to do some of
this. Use at your own risk, PRs are welcome :)

## License

This script is licensed with GPLv3.
