#!/bin/bash
sudo apt install ufw 
sudo apt install net-tools
sudo apt install auditd audispd-plugins
sudo apt install libpam-cracklib

sudo ufw enable
sudou ufw logging on 

sudo passwd -l root

sudo systemctl enable auditd 
sudo auditctl -e 1 
sudo sed -i '$ a -w /etc/shadow -p wa -k shadow_file_change' /etc/audit/rules.d/audit.rules 
sudo sed -i '$ a -w /etc/passwd -p wa -k passwd_file_change' /etc/audit/rules.d/audit.rules 
sudo sed -i '$ a -w /etc/group -p wa -k group_file_change' /etc/audit/rules.d/audit.rules 
sudo sed -i '$ a -w /etc/sudoers -p wa -k shadow_file_change' /etc/audit/rules.d/audit.rules 
sudo service auditd restart 

for ext in mp3 txt wav wma aac mp4 mov avi gif jpg png bmp img eze msi bat sh 
	do 
	   sudo find /home -iname *.$ext
	done 

sudo apt update 
sudo apt upgrade