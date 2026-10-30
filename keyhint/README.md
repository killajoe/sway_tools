# Sway Tools - KeyHint

A set of keybinding helper utilities for Sway on EndeavourOS. This directory contains two distinct tools: a static GUI cheat sheet powered by YAD and a dynamic interactive keybinding launcher powered by Rofi.

## 1. Quick Overview Sheet (`keyhint`)

A lightweight GTK/YAD overview window that displays essential default EndeavourOS Sway keybindings in a compact list.

![KeyHint YAD Overview](https://raw.githubusercontent.com/killajoe/sway_tools/refs/heads/main/keyhint/keyhint-yad.avif)

### Features

* **Compact Layout**: Displays common shortcuts with icon indicators and customized window borders (`--borders=15`).
* **Quick Reference**: Ideal for binding to panel applets or quick keyboard shortcuts.

### Usage

```bash
keyhint
```

---

## 2. Interactive Searcher (`keyhint-2`)

A dynamic Bash script that parses keybindings directly from your Sway configuration file in real time and presents them in a searchable Rofi menu. Selecting an entry executes the associated command immediately via `swaymsg`.

![KeyHint Interactive Rofi Searcher](https://raw.githubusercontent.com/killajoe/sway_tools/refs/heads/main/keyhint/keyhint2.avif)

### Features

* **Live Configuration Parsing**: Automatically extracts `bindsym` entries from `~/.config/sway/config`.
* **Modifier Formatting**: Cleanly formats `$mod`, `Shift`, and `Control` into readable key combinations (`Mod`, `⇧`, `Ctrl`).
* **Theme Fallback Hierarchy**: Loads user-defined themes first (`~/.config/rofi/rofikeyhint.rasi`), with automatic fallback to system defaults (`/usr/share/sway_tools/rofi/rofikeyhint.rasi`) and inline default styles.

### Usage

```bash
keyhint-2
```

---

## Prerequisites

Make sure the following packages are installed on your system:

```bash
sudo pacman -S sway yad rofi libnotify
```

---

## Sway Integration Example

Add the following lines to your `~/.config/sway/config`:

```swayconfig
# Open static cheat sheet
bindsym Mod+Shift+Question exec keyhint

# Open interactive shortcut searcher
bindsym F1 exec keyhint-2
```