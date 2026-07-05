## A very simply update notfier and update runner 

sitting in the tray as an purple icon when no updates and getting red if you have updates.

it has two parts one is the tray app, second the updater script, both ready to be hacked by your needs.

By default it uses `eos-update --aur` 

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

Options in the tray app:


**Configuration**
```
CHECK_INTERVAL = 1800  # 30 minutes
TERMINAL_EMULATOR = "kitty"  # Adjust to your preferred terminal
SCRIPT_PATH = os.path.expanduser("run_update.sh")
RGB_THRESHOLD = 4  # Trigger red profile if repo updates strictly exceed 4 (> 4) (Number of packages)
```
