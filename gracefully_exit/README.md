# gracefully_exit

Gracefully close all open windows in Sway
with visible notifications, before running `swaymsg exit` `reboot` `poweroff` to quit the session.

In case application has unsaved file it will give a warning and does not exit the session.

# Usage: 
./exit-sway.sh {exit|reboot|poweroff}


to be used instead of simple run `swaymsg exit` `reboot` `poweroff` in your [powermenu](https://github.com/killajoe/sway_tools/tree/main/powermenu) or for keybind.


![gracefull_exit notifications](https://raw.githubusercontent.com/killajoe/sway_tools/refs/heads/main/gracefully_exit/graceful_exit.png)

![gracefull_stop notifications](https://raw.githubusercontent.com/killajoe/sway_tools/refs/heads/main/gracefully_exit/gracefully_stop.png)
