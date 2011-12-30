#!/bin/sh
sleep 5
while true
do
	echo "0 widget_tell bottom clock text `date '+%R %A, %B %d, Week %W | '`"
	echo ""
	sleep 60
done | awesome-client
