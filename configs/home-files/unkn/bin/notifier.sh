#!/bin/bash
cat - | {
nt_icon="gtk-dialog-info"
nt_time=5000
nt_head="Notify"
nt_text="Error Occured"
nt_type="Message"
while read k v
do
	case $k in
		TYPE) nt_type=$v;;
		ICON) nt_icon=$v;;
		CONTENT) nt_text=$v;;
		TIMEOUT) nt_time=$v;;
		SUBJECT) nt_head=$v;;
	esac
done
notify-send -i "$nt_icon" -c "$nt_type" -t $nt_time -- "$nt_head" "$nt_text"
}
