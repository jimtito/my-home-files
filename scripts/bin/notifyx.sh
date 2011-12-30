#!/bin/bash
DISPLAY=:0
XAUTH=$HOME/.Xauthority
export DISPLAY XAUTH

notify-send $1 "$2"
