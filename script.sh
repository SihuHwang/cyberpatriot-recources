#!/bin/bash
sudo apt install ufw 
sudo apt install net-tools
sudo apt install auditd 
sudo apt install libpam-cracklib

sudo ufw enable
sudou ufw logging on 

sudo passwd -l root

sudo auditctl -e 1 
sudo sed -i '$ a -w /etc/shadow -p wa' /etc/audit/audit.rules
sudo sed -i '$ a -w /etc/passwd-p wa' /etc/audit/audit.rules
sudo sed -i '$ a -w /etc/group -p wa' /etc/audit/audit.rules
sudo sed -i '$ a -w /etc/sudoers -p wa' /etc/audit/audit.rules

for ext in mp3 txt wav wma aac mp4 mov avi gif jpg png bmp img eze msi bat sh 
	do 
	   sudo find /home -iname *.$ext
	done 

sudo apt update 
sudo apt upgrade