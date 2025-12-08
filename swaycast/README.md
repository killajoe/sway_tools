
# joekamprad sway screencast helper (swaycast):

needed packages: `sudo pacman -Syu --needed slurp xdg-user-dirs`

wl-screenrec currently only in AUR:

`yay -S wl-screenrec`

this tool let you select rectangle area of your screen [$mod+shift+y],and start recording that area. 

to stop press [$mod+shift+x] it will save automatically to video $HOME dir.

![Demo](swaycast-demo.webp)

# How it works

Setting up keybinds in Sway

If you use Sway’s config (usually `$HOME/.config/sway/config`), you can bind keys to run the script with or without the stop argument.
Example:

``` 
# ---- Screencast keybindings ----------------------------------------------

# Start recording (select area, no audio)
bindsym --release $mod+Shift+y exec $HOME/.config/sway/scripts/swaycast

# Start recording (select area, with audio)
bindsym --release $mod+Shift+a exec $HOME/.config/sway/scripts/swaycast --audio

# Stop active recording
bindsym --release $mod+Shift+x exec $HOME/.config/sway/scripts/swaycast --stop

# Fullscreen recording (optional)
# bindsym --release $mod+Shift+f exec $HOME/.config/sway/scripts/swaycast --full

# Fullscreen + audio (optional)
# bindsym --release $mod+Shift+g exec $HOME/.config/sway/scripts/swaycast --full --audio

```

Replace `~/path/to/swaycast` with the actual path to your script.
