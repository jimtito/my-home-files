#!/bin/sh
sleep 5
while true
do
	echo "0 widget_tell bottom disk text | /home: `df -Ph /home | grep -v Use | awk '{ print $5 }'` | "
	echo ""
	sleep 360
done | awesome-client
