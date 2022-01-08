#!/bin/bash

#installation of programs 
sudo apt install ufw -y
sudo apt install net-tools -y 
sudo apt install auditd audispd-plugins -y 
sudo apt install libpam-cracklib -y 

#firewall settings 
sudo ufw enable 
sudo ufw logging on 

#disabling root account 
sudo passwd -l root 


#audit policies
sudo systemctl enable auditd
sudo auditctl -e 1
sudo sed -i '$ a -w /etc/shadow -p wa -k shadow_file_change' /etc/audit/rules.d/audit.rules
sudo sed -i '$ a -w /etc/passwd -p wa -k passwd_file_change' /etc/audit/rules.d/audit.rules
sudo sed -i '$ a -w /etc/group -p wa -k group_file_change' /etc/audit/rules.d/audit.rules
sudo sed -i '$ a -w /etc/sudoers -p wa sudoers_file_change' /etc/audit/rules.d/audit.rules
sudo service auditd restart 


#password policies  
sudo sed -i -e '/pam_unix.so/s/obscure use_authtok/obscure use_authtok remember=5 minlen=10/' /etc/pam.d/common-password
sudo sed -i -e '/pam_cracklib.so/s/retry=3 minlen=8 difok=3/retry=3 minlen=8 difok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/' /etc/pam.d/common-password

sudo sed -i '$ a auth required pam_tally2.so deny=5 onerr=fail unlock_time=1800' /etc/pam.d/common-auth

sudo sed -i -e '/PASS_MAX_DAYS/s/99999/90/' /etc/login.defs
sudo sed -i -e '/PASS_MIN_DAYS/s/0/10/' /etc/login.defs
sudo sed -i -e '/PASS_WARN_AGE/s/7/7/' /etc/login.defs


#sysctl configurations
sudo cp /etc/sysctl.conf /etc/sysctl.conf.orig
sudo sed -i '$ a net.ipv4.tcp_syncookies=1' /etc/sysctl.conf
sudo sed -i '$ a net.ipv4.ip_forward=0' /etc/sysctl.conf
sudo sed -i '$ a net.ipv4.conf.all.send_redirects=0' /etc/sysctl.conf
sudo sed -i '$ a net.ipv4.conf.default.send_redirects=0' /etc/sysctl.conf
sudo sed -i '$ a net.ipv4.conf.default.accept_redirects=0' /etc/sysctl.conf
sudo sed -i '$ a net.ipv4.conf.all.secure_redirects=0' /etc/sysctl.conf
sudo sed -i '$ a net.ipv4.conf.default.secure_redirects=0' /etc/sysctl.conf

sudo sysctl -p

#users
sudo getent passwd {999..60000} >> /home/$USER/users 
sudo cat /etc/group |grep sudo > /home/$USER/users


#runs updates
sudo apt update -y
sudo apt upgrade -y 


#finds unauthorized programs  
sudo find / -type f \( -iname  "*.mp3" -o -iname "nc*" -o -iname "nmap*" -o -iname "*shark" -o -iname "*netcat*" -o -iname "*.pl" -o -iname "*ghidra*" \) > /home/$USER/unauthorized_programs

#finds unauthroized files 
for ext in mp3 txt wav wma aac mp4 mov avi gif jpg png bmp img exe msi bat ogg h264 mpg mpeg
	do 
		sudo find /home -iname *.$ext > /home/$USER/unauthroized_files
	done 
exit 
