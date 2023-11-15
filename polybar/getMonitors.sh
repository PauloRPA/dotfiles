#!/bin/bash

#List monitors
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      echo Monitor: $m
  done
else
    echo "Nenhum monitor encontrado"
fi

echo "Monitores listados."
