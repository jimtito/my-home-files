#!/bin/bash

echo "Artist: `mpc current -f %artist%`"
echo "Album: `mpc current -f %album%`"
echo -n "Year: `mpc current -f %date%`"
