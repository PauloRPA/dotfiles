#!/bin/bash

# Terminate already running bar instances. IPC Call:
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

if type "xrandr"; then
  for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$monitor polybar --reload bar-main 2>&1 | tee -a /tmp/polybar1.log & disown
  done
else
  polybar --reload bar-main 2>&1 | tee -a /tmp/polybar1.log & disown
fi

echo "Bars launched..."
