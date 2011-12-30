#!/bin/sh
sleep 5
while true
do
	echo "0 widget_tell bottom mpd text `mpc --format ' %artist% - %title%' | head -n1`"
	echo ""
	sleep 10
done | awesome-client
