# Sway Tools

![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg) ![Platform: Linux](https://img.shields.io/badge/Platform-Linux-green.svg) ![CI: GitHub Actions](https://img.shields.io/github/actions/workflow/status/killajoe/sway-tools/ci.yml?branch=main)

A collection of simple Bash scripts to enhance **Sway** without adding unnecessary complexity.

---

## Features

- Lightweight Bash scripts, no heavy dependencies
- Enhance Sway with useful utilities and UI tweaks
- Easy to install and configure
- Focused on usability and workflow improvements

---

## Tools Overview
             
* keymap_selector - keyma/locale setup tool using dialog
* new_workspace  - open a new empty workspace 
* power_profiles_switcher  - check and set power profiles
* swaycast  - screencast on sway
* weather - opemweather integration for waybar   
* powermenu - powermenu (rofi)
* swayshot - screenshot tool
* waybar_toggle - togle waybar off and on with a shortcut (also for realoding it on changes)


Each tool is independent and can be used also in wayland based Desktops.


## Installation

1. Clone the repository:
```
git clone https://github.com/killajoe/sway-tools.git
cd sway-tools
````

2. Make scripts executable:

```
chmod +x *.sh
```

## Contributing

Contributions are welcome! If you want to:

* Add new scripts
* Improve existing ones
* Fix bugs or enhance documentation

Please submit a pull request or open an issue.


## License

This project is licensed under the **GPL-3.0-or-later** license. See [LICENSE](LICENSE) for details.
