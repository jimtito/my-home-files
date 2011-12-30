#!/bin/sh
sleep 5
while true
do
	echo "0 widget_tell bottom load text `cut -d' ' -f 3 /proc/loadavg` |"
	echo ""
	sleep 300
done | awesome-client
