# App Menu (Rofi)

A customized, balanced 4-column application menu configuration for **Rofi**, designed for Sway.

![App Menu](https://raw.githubusercontent.com/killajoe/sway_tools/refs/heads/main/app_menu/images/app_menu.avif)


## Features

- **Optimized Layout**: Uses a 4-column grid layout with 55% relative window width, ensuring long application names fit without truncation.
- **Flexible Theming**: Supports dynamic theme switching via `rofi-theme-selector`, or allows binding to a specific fixed theme file.
- **Clean Spacing**: Subtle row spacing and padding for improved readability and navigation.
- **Icon Support**: Fully compatible with icon themes (default: `Qogir-Dark`) using `Noto Sans Regular`.

## Prerequisites

Make sure you have the following packages installed:
- `rofi`
- `qogir-icon-theme` (or any preferred icon theme)
- `noto-fonts`

## Installation

1. Place the configuration file into your Rofi configuration directory (e.g., `~/.config/rofi/app_menu.rasi`).
2. Adjust the import line at the top depending on your setup:
   - **Dynamic (via Rofi Theme Selector):** Keep the import pointing to `config.rasi`, which is automatically managed when you save a theme via `rofi-theme-selector`.
     ```rasi
     @import "~/.config/rofi/config.rasi"
     ```
   - **Fixed Theme:** If you do not use the Theme Selector and want a permanent, hardcoded theme, point the import directly to your desired `.rasi` theme file (located in `~/.local/share/rofi/themes/` or `/usr/share/rofi/themes/`):
     ```rasi
     @import "~/.local/share/rofi/themes/deep-purple.rasi"
     ```

![Rofi Theme Selector](https://raw.githubusercontent.com/killajoe/sway_tools/refs/heads/main/app_menu/images/rofi-theme-selector.avif)

## Usage

Launch the application menu via your Sway keybinding:

```bash
rofi -show drun -config ~/.config/rofi/app_menu.rasi
