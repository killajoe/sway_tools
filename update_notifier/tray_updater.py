#!/usr/bin/env python3
import os
import subprocess
import time
import threading
from PIL import Image, ImageDraw
from pystray import Icon, Menu, MenuItem

# Configuration
CHECK_INTERVAL = 1800  # 30 minutes
TERMINAL_EMULATOR = "kitty"  # Adjust to your preferred terminal
SCRIPT_PATH = os.path.expanduser("~/.config/sway/scripts/run_update.sh")  # Updated path
RGB_THRESHOLD = 4  # Trigger red profile if repo updates strictly exceed 4 (> 4) (Number of packages)

def create_circle_image(color, size=64):
    """Generates a simple color circle image."""
    image = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    draw.ellipse((4, 4, size - 4, size - 4), fill=color)
    return image

class UpdateCheckerTray:
    def __init__(self):
        # State colors
        self.icon_no_updates = create_circle_image("purple")
        self.icon_updates_available = create_circle_image("red")

        self.icon = Icon("Update Checker", icon=self.icon_no_updates, title="Checking updates...")
        self.icon.menu = Menu(
            MenuItem("Run Update", self.trigger_update),
            MenuItem("Check Now", self.manual_check),
            MenuItem("Exit", self.exit_action)
        )
        self.update_available = False
        self.lock = threading.Lock()

    def count_updates(self):
        """Checks both official repositories and AUR for pending updates without duplication."""
        try:
            repo_count = len(subprocess.check_output(["checkupdates"]).decode().splitlines())
        except subprocess.CalledProcessError:
            repo_count = 0

        try:
            aur_count = len(subprocess.check_output(["yay", "-Qu", "--aur"]).decode().splitlines())
        except (subprocess.CalledProcessError, FileNotFoundError):
            try:
                aur_count = len(subprocess.check_output(["paru", "-Qu", "--aur"]).decode().splitlines())
            except (subprocess.CalledProcessError, FileNotFoundError):
                aur_count = 0

        return repo_count, aur_count

    def _set_rgb_profile(self, repo_count):
        """Controls OpenRGB profiles based on the repository update count only."""
        profile = "Updates_RED" if repo_count > RGB_THRESHOLD else "Updates_GREEN"
        try:
            subprocess.Popen(["openrgb", "--profile", profile], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except FileNotFoundError:
            pass

    def _perform_check(self):
        """Internal helper to execute the check and update the UI state."""
        with self.lock:
            repo_count, aur_count = self.count_updates()
            total_updates = repo_count + aur_count

            if total_updates > 0:
                self.update_available = True
                self.icon.icon = self.icon_updates_available
                self.icon.title = f"Updates: {total_updates} (Repo: {repo_count} | AUR: {aur_count})"
            else:
                self.update_available = False
                self.icon.icon = self.icon_no_updates
                self.icon.title = "System up to date"

            # Execute RGB profile switch based strictly on repository updates
            self._set_rgb_profile(repo_count)

    def check_loop(self):
        """Background loop to periodically verify update status."""
        while True:
            self._perform_check()
            time.sleep(CHECK_INTERVAL)

    def manual_check(self):
        threading.Thread(target=self._perform_check, daemon=True).start()

    def _watch_update_process(self):
        """Blocks until the terminal process ends, then forces a verification."""
        try:
            proc = subprocess.Popen([TERMINAL_EMULATOR, "-e", SCRIPT_PATH])
            proc.wait()
        except Exception:
            pass
        self._perform_check()

    def trigger_update(self):
        """Launches the update script and monitors its lifecycle execution."""
        threading.Thread(target=self._watch_update_process, daemon=True).start()

    def exit_action(self):
        self.icon.stop()

    def run(self):
        threading.Thread(target=self.check_loop, daemon=True).start()
        self.icon.run()

if __name__ == "__main__":
    tray = UpdateCheckerTray()
    tray.run()
