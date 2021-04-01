# Polybar

Polybar is an [Übersicht](https://github.com/felixhageloh/uebersicht) widget that tries to recreate the same behavior as [polybar](https://github.com/jaagr/polybar) on macOS for [yabai](https://github.com/koekeishiya/yabai)

This widget is based on the [polybar-kwm](https://github.com/CaptnBlubber/Polybar-kwm) but adapted for yabai.

## Screenshots
![Polybar-kwm](https://i.imgur.com/CQd6ILB.png)

## Modules

- Workspaces
  - with highlight of current active space
- Volume
- CPU Usage
- Disk Usage
- Current Connected Wifi
- Battery
- Date
- Time


## Installation

```bash
git clone git@github.com:knazarov/ubersicht-polybar-widget.git "~/Library/Application Support/Übersicht/widgets/polybar"
```

Download (or clone) this repository and place the contents inside a folder called `polybar` in your Übersicht widgets directory. By default the widget folder is located here: `~/Library/Application Support/Übersicht/widgets`

## Prerequisites

This widget requires `yabai` and `jq`. Yabai is required because this wiget is made specifically for it, and jq is needed to filter the output of yabai command line.

```bash
brew install jq
```

## Configuration
The Bar will display where the macOS default menu bar is located. Therefore you have to configure the bar to hide itself:
System Preferences -> General -> Automatically hide and show the menu bar

Make sure your namespaces are named in yabai. Example:
``` 
yabai -m space 1 --label web
yabai -m space 2 --label code
yabai -m space 3 --label term
yabai -m space 4 --label conf
```

Additionally I recommend to set a top spacing in kwm. My configuration:
```
yabai -m config top_padding                  58
yabai -m config bottom_padding               24
yabai -m config left_padding                 24
yabai -m config right_padding                24
```


