# Deep Purple Rofi Theme

A sleek, dark purple theme for Rofi designed for EndeavourOS Sway setups, featuring rounded corners and soft contrast accents.

## Features

* **Rounded Corners**: Modern window styling with `border-radius: 15px`.
* **Soft Palette**: Dark purple background combined with clean highlight tones.
* **Universal Support**: Works seamlessly as a base theme for standard launcher modes (`drun`, `run`, `window`).

## Installation

### User Installation

Copy `deep-purple.rasi` into your local XDG data folder for Rofi themes:

```bash
mkdir -p ~/.local/share/rofi/themes
cp deep-purple.rasi ~/.local/share/rofi/themes/
```


## Usage

Test or apply the theme directly by name (Rofi automatically detects themes in `~/.local/share/rofi/themes/`):

```bash
rofi -show drun -theme deep-purple
```

Or set it as your default theme inside `~/.config/rofi/config.rasi`:

```rasi
configuration {
    /* ... your configuration options ... */
}

@theme "deep-purple"
```