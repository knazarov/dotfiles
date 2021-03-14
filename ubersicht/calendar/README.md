# Ubersicht calendar widget

This widget allows you to display a nice-looking calendar on your desktop. Works especially well with tiling window managers like [yabai](https://github.com/koekeishiya/yabai)

## Screenshot
![Ubersicht-calendar](https://github.com/knazarov/ubersicht-calendar-widget/blob/master/screenshot-full.png?raw=true)

## Installation

```bash
git clone git@github.com:knazarov/ubersicht-calendar-widget.git '~/Library/Application Support/Übersicht/widgets/calendar'
```

To get information from the MacOS calendar, this widget needs [icalBuddy](http://hasseg.org/icalBuddy/). You can install it like this:

```bash
brew install ical-buddy
```

## Customization

You can customize the size of the widget in the `calendar.coffee` file. It contains the `CUSTOMIZE ME` section in the beginning, that has a few variables you can tune.
