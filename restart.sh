#!/bin/bash
sleep 5
while true; do
	FILE=/bin/network/ssh.py
	if test -f "$FILE"; then 
		continue 
	else 
		reboot 
	fi 
done

