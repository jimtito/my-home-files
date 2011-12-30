#!/bin/bash

wait=0
while true
 do
	$HOME/bin/irssi-notify-client-minivan.pl

	let wait=$wait+5
	if [ $wait -ge 30 ]
	 then
		sleep 30
	else
		sleep $wait
	fi
done
