# flameshot_on_sway:
As of i do really need something like flamshot to do screenshots,

add markings and hints or blur parts e.t.c

And no it is not working on sway!


So I wrote a stupid little script that saves a rectangular selection as a screenshot 

with grim and slurp and then opens it in swappy so that you can add your markers, 

the edited screenshot is then saved in the screenshot directory ($HOME/Pictures/screenshots)


![animation](https://raw.githubusercontent.com/killajoe/sway_tools/refs/heads/main/flameshot_on_sway/screenshot-flamshotalike.gif)

``` 
# of the focused window
bindsym $mod+Print exec  --no-startup-id ~/.config/sway/scripts/screenshot-select

bindsym --release Print exec --no-startup-id ~/.config/sway/scripts/screenshot
```
