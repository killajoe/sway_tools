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
