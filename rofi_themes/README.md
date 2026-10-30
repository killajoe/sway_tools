# Rofi Themes

A collection of themes for Rofi

## Available Themes

### 1. Deep Purple (`deep-purple.rasi`)

![Deep Purple Theme](https://raw.githubusercontent.com/killajoe/sway_tools/refs/heads/main/rofi_themes/images/deep-purple.avif)

A sleek, dark purple theme featuring rounded corners (`border-radius: 15px`), soft contrast accents, and a clean, modern aesthetic.

#### Features

* **Rounded Corners**: Modern window styling with `border-radius: 15px`.

* **Soft Palette**: Dark purple background combined with clean highlight tones.

* **Universal Support**: Works seamlessly as a base theme for standard launcher modes (`drun`, `run`, `window`).

[more will follow or not?]
---

## Installation

### User Installation (Recommended)

Copy the desired `.rasi` theme files into your local XDG data folder for Rofi themes:

```
mkdir -p ~/.local/share/rofi/themes
cp rofi_themes/*.rasi ~/.local/share/rofi/themes/

```

### System-wide Installation

For system-wide availability (e.g. via PKGBUILD), place the theme files into `/usr/share/rofi/themes/` or `/usr/share/sway_tools/rofi/`.

---

## Usage

### Test a Theme Directly

Test or apply any theme directly by name (Rofi automatically detects themes stored in `~/.local/share/rofi/themes/`):

```
rofi -show drun -theme deep-purple

```

### Set as Default Theme

Set your preferred default theme inside `~/.config/rofi/config.rasi`:

```
configuration {
    /* ... your configuration options ... */
}

@theme "deep-purple"

```

---

## Adding New Themes

To contribute or add new themes to this directory:

1. Place your `.rasi` file in `rofi_themes/`.

2. Add a screenshot or preview image in `rofi_themes/images/`.

3. Add a new subsection under **Available Themes** in this `README.md` following the same format.
