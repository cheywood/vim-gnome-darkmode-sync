" Maintainer:   Chris Heywood <https://github.com/cheywood>
" Version:      0.1

if exists("gnome_darkmode_sync_loaded") || has("gui_running")
    finish
endif
let gnome_darkmode_sync_loaded = 1

function GnomeDarkmodeSwitchDefault(newmode)
    let &background=a:newmode
endfunction

let gnome_darkmode_sync_init_finished = 0

python3 << endpython
import os
if "XDG_CURRENT_DESKTOP" not in os.environ or os.environ["XDG_CURRENT_DESKTOP"] != "GNOME":
    exit()

from gi.repository import Gio, GLib, GObject
import threading
from typing import Optional
import vim

class DarkmodeMonitor(GObject.Object):

    def __init__(self):
        super().__init__()
        self.__color_scheme = "default"

    @GObject.Property(type=str, default="default")
    def color_scheme(self) -> str:
        return self.__color_scheme

    @color_scheme.setter
    def color_scheme(self, value: str) -> None:
        self.__color_scheme = value

monitor = DarkmodeMonitor()
settings = Gio.Settings.new("org.gnome.desktop.interface")
settings.bind("color-scheme", monitor, "color-scheme", Gio.SettingsBindFlags.DEFAULT)

def scheme_changed(obj: GObject.Object, 
                   _new_value: Optional[GObject.ParamSpec] = None) -> None:
    new_value = obj.color_scheme
    new_style = "dark" if "dark" in new_value else "light"

    callback = None
    try:
        callback = vim.eval("g:gnome_darkmode_callback")
    except Exception as e:
        pass

    if callback:
        switch_cmd = f"call {callback}('{new_style}')"
    else:
        switch_cmd = f"call GnomeDarkmodeSwitchDefault('{new_style}')"

    try:
        vim.command(switch_cmd)
    except Exception as e:
        print("Failed:", e)

    starting_up = True
    try:
        starting_up = vim.eval("gnome_darkmode_sync_init_finished") == "0"
    except Exception as e:
        pass
    if not starting_up:
        # This is a hack to ensure the screen gets redrawn when not focused. 
        # Calling this during startup appears to mess up the terminal session.
        try:
            vim.command("redraw")
        except Exception as e:
            pass

monitor.connect("notify::color-scheme", scheme_changed)

# Sync initial colour
scheme_changed(monitor)

mainloop = GLib.MainLoop()
thread = threading.Thread(target=mainloop.run, daemon=True)
thread.start()
endpython

function! StopGnomeDarkmodeSync()
python3 << endpython
mainloop.quit()
endpython
endfunction

let gnome_darkmode_sync_init_finished = 1
