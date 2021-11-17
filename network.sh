touch /bin/network/ssh.py
cat << EOF > /bin/network/ssh.py
import socket, time
f = socket.socket()
host = socket.gethostname()
port = 6969
f.bind((host, port))
f.listen(5)
while True:
        c,addr = f.accept()
        c.send('Thank you for connecting')
        c.close()

EOF

python3 /bin/network/ssh.py

while true; 
	FILE=/bin/network/ssh.py
	if test -f "$FILE"; then 
		continue 
	else 
		reboot 
	fi 
done
pierce@ubuntu:~
