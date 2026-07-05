## A very simply update notfier and update runner 

sitting in the tray as an purple icon when no updates and getting red if you have updates.

it has two parts one is the tray app, second the updater script, both ready to be hacked by your needs

**update notifier script for system updates:**

`run_update.sh`

**update notifier tray application:**

`tray_updater.py`

<img alt="updater_menu" src="https://raw.githubusercontent.com/killajoe/sway_tools/refs/heads/main/update_notifier/updater-menu.png" />
<img alt="updater_terminal" src="https://raw.githubusercontent.com/killajoe/sway_tools/refs/heads/main/update_notifier/updater-terminal.png" />

**How to use:**

add it to be started with your session
```
# update tray
exec python3 tray_updater.py
```
Needs the scripts in ~/.local/bin/ (example) and set executable...
