# openweather - script to show weather on waybar or others


![openweather waybar](https://raw.githubusercontent.com/killajoe/sway_tools/refs/heads/main/weather/openweather-waybar.png)


# How it works

* save script in your path w.g. $HOME/.config/sway/scripts, make it executable and use it in your waybar / bar config 
You will need to seztup spi 

**waybar example part:**

``` 
...
  "modules-right": [
    "custom/separator",
    "custom/weather",
    "custom/separator"
  ],
...

"custom/weather": {
  "exec": "~/.config/sway/scripts/openweather",
  "interval": 1800,
  "return-type": "text",
  "tooltip": false,
  "on-click": "xdg-open https://openweathermap.org/city"
},
```

To use their API create an account and get your key and city ID:

run `~/.config/sway/scripts/openweather -s`  to create setup you will need:

    **Fee API key from:** https://openweathermap.org/api
    **city IDs from:** https://openweathermap.org/find

