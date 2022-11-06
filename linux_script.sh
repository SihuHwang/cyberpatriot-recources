#!/bin/bash
#installation of programs

sudo apt install ufw -y
sudo apt install auditd audispd-plugins -y     
sudo apt install libpam-cracklib -y


#firewall settings 
sudo ufw enable
sudo ufw logging on
sudo ufw deny 1337

#disabling root account 
sudo passwd -l root
sudo usermod -L root

sudo mkdir -p /home/$USER/Desktop/backups

#sets /etc/hosts to default
sudo cp /etc/hosts /home/$USER/Desktop/backups/hosts
sudo printf > /etc/hosts
echo -e "127.0.0.1 localhost\n127.0.1.1 $USER\n::1 ip6-localhost ip6-localhost ip6-loopback\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters" >> /etc/hosts 
sudo chmod 644 /etc/hosts 

#makes /etc/passwd to correct permissions 
sudo cp /etc/passwd /home/$USER/Desktop/backups/passwd
sudo chown -R root:root /etc/passwd
sudo chmod 604 /etc/passwd

#makes /etc/shadow to correct permissions 
sudo cp /etc/shadow /home/$USER/Desktop/backups/shadow
sudo chown -R root:root /etc/shadow
sudo chmod 600 /etc/shadow

#makes .bash_history to correct permissions 
sudo cp .bash_history /home/$USER/Desktop/backups/bash_history 
sudo chmod 640 .bash_history

#removes all startup scripts 
sudo cp /etc/rc.local /home/$USER/Desktop/backups/rc.local 
sudo echo > /etc/rc.local 
echo 'exit 0' >> /etc/rc.local 

#audit policies
sudo systemctl enable auditd
sudo auditctl -e 1
sudo cp /etc/audit/rules.d/audit.rules /home/$USER/Desktop/backups/audit.rules
sudo sed -i '$ a -w /etc/shadow -p wa -k shadow_file_change' /etc/audit/rules.d/audit.rules
sudo sed -i '$ a -w /etc/passwd -p wa -k passwd_file_change' /etc/audit/rules.d/audit.rules
sudo sed -i '$ a -w /etc/group -p wa -k group_file_change' /etc/audit/rules.d/audit.rules
sudo sed -i '$ a -w /etc/sudoers -p wa -k sudoers_file_change' /etc/audit/rules.d/audit.rules
sudo service auditd restart 


#password policies  
sudo cp /etc/pam.d/common-password /home/$USER/Desktop/backups/common-password
sudo sed -i -e '/pam_unix.so/s/obscure use_authtok/obscure use_authtok remember=5 minlen=10/' /etc/pam.d/common-password
sudo sed -i -e '/pam_cracklib.so/s/retry=3 minlen=8 difok=3/retry=3 minlen=8 difok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/' /etc/pam.d/common-password

sudo cp /etc/pam.d/common-auth /home/$USER/Desktop/backups/common-auth
sudo sed -i '$ a auth required pam_tally2.so deny=5 onerr=fail unlock_time=1800' /etc/pam.d/common-auth

sudo cp /etc/login.defs /home/$USER/Desktop/backups/login.defs
sudo sed -i -e '/PASS_MAX_DAYS/s/99999/90/' /etc/login.defs
sudo sed -i -e '/PASS_MIN_DAYS/s/0/10/' /etc/login.defs
sudo sed -i -e '/PASS_WARN_AGE/s/7/7/' /etc/login.defs


#sysctl configurations
sudo cp /etc/sysctl.conf /home/$USER/Desktop/backups/sysctl.conf
sudo sed -i '$ a net.ipv4.tcp_syncookies=1' /etc/sysctl.conf
sudo sed -i '$ a net.ipv4.ip_forward=0' /etc/sysctl.conf
sudo sed -i '$ a net.ipv4.conf.all.send_redirects=0' /etc/sysctl.conf
sudo sed -i '$ a net.ipv4.conf.default.send_redirects=0' /etc/sysctl.conf
sudo sed -i '$ a net.ipv4.conf.default.accept_redirects=0' /etc/sysctl.conf
sudo sed -i '$ a net.ipv4.conf.all.secure_redirects=0' /etc/sysctl.conf
sudo sed -i '$ a net.ipv4.conf.default.secure_redirects=0' /etc/sysctl.conf

sudo sysctl -p

#clears aliases 
unalias -a 

#users
echo "Did you enter users from README as /home/$USER/Desktop/READMEusers.txt?(y/n)" 
read README


if [ $README = "y" ];
then	
	cat /home/$USER/Desktop/READMEusers | sort > readme
	sudo rm /home/$USER/Desktop/READMEusers
	awk -F: '($3 >= 1000 && $3 <= 60000) {printf $1"\n"}' /etc/passwd | sort >> /home/$USER/Desktop/users
	diff -y readme users
	echo "DELETE ALL UNAUTHORIZED USERS IN A NEW TERMINAL AND CHECK SUDO" 

fi

echo "Finished? (y/n)" 
read result 
if [ $result = 'y' ]
 continue 
fi 

#passwords
awk -F: '($3 >= 1000 && $3 <= 60000) {printf $1"\n"}' /etc/passwd | sort > /home/$USER/Desktop/passwords
filename=/home/$USER/Desktop/passwords
n=1 
while read line; do 
if [ $line != $USER ]
then 
	 echo -e "BoiseBee#1\nBoiseBee#1" |sudo passwd $line
else 
	continue
fi
n=$((n+1))
done < $filename

#misc. 
echo "exit 0" > /etc/rc.local
sudo apt update openssl libssl-dev 
sudo apt-cache policy openssl libssl-dev



<<com
#removes hacking tools 
list=(netcat netcat-openbsd netcat-traditional ncat pnetcat socat sock socket sbd john john-data hydra hydra-gtk aircrack-ng fcrakzip lcrack ophcrack ophcrack-cli pdfcrack pyrit rarcrack sipcrack irpas zeitgeist-core zeutgeist-datahub python-zeitgeist rhythmbox-plugin-zeitgeist zeitgeist wireshark)
echo 'Remove hacking tools,files and crontab? Have you read README and Forensics?(y/n)' 
read hacking
if [ $hacking == "y" ]
then
	for name in ${list[@]};
	do 	
		sudo apt remove $name 
	done


	
fi
com

sudo rm /usr/bin/nc  
sudo find /bin/ -name "*.sh" -type f -delete
#clears crontab 
crontab -l > /home/$USER/Desktop/backups/user_crontab 
crontab -r 
sudo crontab -l > /home/$USER/Desktop/backups/root_crontab
sudo crontab -r
cd /etc/ 
sudo rm -f cron.deny at.deny 
echo root >cron.allow
echo root >at.allow
sudo chown root:root cron.allow at.allow 
sudo chmod 400 cron.allow at.allow 
cd ~



#finds unauthorized programs  
sudo find / -type f \( -iname  "*.mp3" -o -iname "nc*" -o -iname "nmap*" -o -iname "*shark" -o -iname "*netcat*" -o -iname "*ghidra*" \) >> /home/$USER/prohibited_files

#finds unauthroized files 
for ext in mp3 txt wav wma aac mp4 mov avi gif jpg png bmp img exe msi bat ogg h264 mpg mpeg
	do 
		sudo find /home -iname *.$ext >> /home/$USER/unauthroized_files
	done 

echo "Start Updates?(y/n) Remove Unauthorized programs first to save time!"
read update 
if [ $update = "y"]
then 
	sudo apt autoremove -y 

	#runs updates
	sudo apt update -y
	sudo apt upgrade -y 
	sudo apt dist-upgrade -y
fi
exit
