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

