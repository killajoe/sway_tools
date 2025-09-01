
# joekamprad sway screencast helper (swaycast):

needed packages: `sudo pacman -Syu --needed slurp wl-screenrec xdg-user-dirs`

wl-screenrec currently only in AUR will be added to EndeavourOS repo in case of release

this tool let you select rectangle area of your screen [$mod+shift+y],and start recording that area. 

to stop press [$mod+shift+x] it will save automatically to video $HOME dir.

[![Watch the video](https://img.youtube.com/vi/_xo14TCYZDk/hqdefault.jpg)](https://youtu.be/_xo14TCYZDk)

# How it works

    The script now accepts an argument:
        No argument → starts recording
        Argument “stop” → stops recording

Setting up keybinds in Sway

If you use Sway’s config (usually ~/.config/sway/config), you can bind keys to run the script with or without the stop argument.
Example:
Shell

# Start recording (select area)
bindsym $mod+Shift+y exec ~/path/to/screencast-select

# Stop recording
bindsym $mod+Shift+x exec ~/path/to/screencast-select stop

Replace ~/path/to/screencast-select with the actual path to your script.
