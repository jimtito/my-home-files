#!/bin/bash

PID=$(pgrep offlineimap)

# the only time offlineimap has been still running after 3 minutes for 
# me is if it's frozen... we'll kill it and resync
[[ -n "$PID" ]] && kill $PID

offlineimap -o -u quiet &>/dev/null &

exit 0
