
# joekamprad sway screencast helper (swaycast):

needed packages: `sudo pacman -Syu --needed slurp xdg-user-dirs`

wl-screenrec currently only in AUR:

`yay -S wl-screenrec`

this tool let you select rectangle area of your screen [$mod+shift+y],and start recording that area. 

to stop press [$mod+shift+x] it will save automatically to video $HOME dir.

[![Demo](swaycast-demo.gif)

# How it works

Setting up keybinds in Sway

If you use Sway’s config (usually `$HOME/.config/sway/config`), you can bind keys to run the script with or without the stop argument.
Example:

``` 
# Start recording (select area)
bindsym $mod+Shift+y exec ~/path/to/screencast-select

# Stop recording
bindsym $mod+Shift+x exec ~/path/to/screencast-select stop
```

Replace `~/path/to/screencast-select` with the actual path to your script.
