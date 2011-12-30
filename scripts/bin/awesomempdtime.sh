#!/bin/sh
sleep 5
while true
do
	echo "0 widget_tell bottom mpdtime text  `mpc | grep playing | cut -c 21-37` "
	echo ""
	sleep 3
done | awesome-client 
