---
title: 소켓을 이용한 실시간 채팅 만들기 (심화편)
date: 2020-08-04 15:12:47
categories: [Chatting]
tags: [Network, Socket, Threading]
---

[실시간 채팅 구현 참조](https://lidron.tistory.com/44)

[serversocket문서](https://python.flowdas.com/library/socketserver.html)

# 왜?

채팅을 소켓을 통해 만들었지만, 실시간으로 방을 참여하고, 많은 사람들이 채팅을 할 수있게 만들고싶었다.

위에 해당하는 구현이 끝난다면, 이제 url을 연결하여 id값을 접속할때마다 부여하며 채팅방을 만들고, 그 url을 원하는 사람들에게 공유하고 유저들이 접속한다면 원하는 사람들만 일회용으로 간단히 사용할수있지 않을까 생각하였다.

# 실시간 채팅 구현

## 서버

```python
import socketserver
import threading

HOST = ''
PORT = 9009
lock = threading.Lock()  # syncronized 동기화 진행하는 스레드 생성, 즉, 단 하나의 프로세스나, 스레드만 접근해서 데이터를 수정함!


class UserManager:  # 사용자관리 및 채팅 메세지 전송을 담당하는 클래스
    # ① 채팅 서버로 입장한 사용자의 등록
    # ② 채팅을 종료하는 사용자의 퇴장 관리
    # ③ 사용자가 입장하고 퇴장하는 관리
    # ④ 사용자가 입력한 메세지를 채팅 서버에 접속한 모두에게 전송

    def __init__(self):
        self.users = {}  # 사용자의 등록 정보를 담을 사전 {사용자 이름:(소켓,주소),...}

    def addUser(self, username, conn, addr):  # 사용자 ID를 self.users에 추가하는 함수
        if username in self.users:  # 이미 등록된 사용자라면
            conn.send('이미 등록된 사용자입니다.\n'.encode())
            return None

        # 새로운 사용자를 등록함
        lock.acquire()  # 스레드 동기화를 막기위한 락
        self.users[username] = (conn, addr)
        lock.release()  # 업데이트 후 락 해제

        self.sendMessageToAll('[%s]님이 입장했습니다.' % username)
        print('+++ 대화 참여자 수 [%d]' % len(self.users))

        return username

    def removeUser(self, username):  # 사용자를 제거하는 함수
        if username not in self.users:
            return

        lock.acquire()
        del self.users[username]
        lock.release()

        self.sendMessageToAll('[%s]님이 퇴장했습니다.' % username)
        print('--- 대화 참여자 수 [%d]' % len(self.users))

    def messageHandler(self, username, msg):  # 전송한 msg를 처리하는 부분
        if msg[0] != '/':  # 보낸 메세지의 첫문자가 '/'가 아니면
            self.sendMessageToAll('[%s] %s' % (username, msg))
            return

        if msg.strip() == '/quit':  # 보낸 메세지가 'quit'이면
            self.removeUser(username)
            return -1

    def sendMessageToAll(self, msg):
        for conn, addr in self.users.values():
            conn.send(msg.encode())


class MyTcpHandler(socketserver.BaseRequestHandler):#접속시 일어나는것들, self.request로 socket instance접근가능
    userman = UserManager() #이렇게 정의하면 self.userman으로 클래스접근가능

    def handle(self):  # 클라이언트가 접속시 클라이언트 주소 출력
        print('[%s] 연결됨' % self.client_address[0])

        try:
            username = self.registerUsername()
            msg = self.request.recv(1024)
            while msg:
                print(msg.decode())
                if self.userman.messageHandler(username, msg.decode()) == -1:
                    self.request.close()
                    break
                msg = self.request.recv(1024)

        except Exception as e:
            print(e)

        print('[%s] 접속종료' % self.client_address[0])
        self.userman.removeUser(username)

    def registerUsername(self):
        while True:
            self.request.send('로그인ID:'.encode())
            username = self.request.recv(1024)
            username = username.decode().strip()
            if self.userman.addUser(username, self.request, self.client_address):
                return username


class ChatingServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    pass


def runServer():
    print('+++ 채팅 서버를 시작합니다.')
    print('+++ 채텅 서버를 끝내려면 Ctrl-C를 누르세요.')

    try:
        server = ChatingServer((HOST, PORT), MyTcpHandler)
        server.serve_forever()
    except KeyboardInterrupt:
        print('--- 채팅 서버를 종료합니다.')
        server.shutdown()
        server.server_close()


runServer()
```

### 의문점

__스레딩을 위한 코드가 보이지 않는다.서버와 클라이언트가 있을때 서버는 스레드로 관리해야하는것아닌가(병렬처리..)__

> 스레딩을 하기위해 `ChatingServer(socketserver.ThreadingMixIn, socketserver.TCPServer)` 상속을 사용하였다.메서드를 재정의하므로, 믹스인 클래스가 먼저 옵니다. 다양한 어트리뷰트를 설정하면 하부 서버 메커니즘의 동작도 변경됩니다.
>
> MRO에 따르면 클래스 상속의 순서는 뒤에서부터가 먼저임

__Break조건을 두면 함수까지 탈출하나?__

>1. python 에서 함수안에서 return이 되면 그 즉시 함수끝
>
>2. while True조건에서는 계속 반복하다가 break조건만나면 바로 탈출
>
>   ```python
> def cat():
>     while True:
>         cat = input('>>>')
>         print(cat)
>         if cat == '/quit':
>             return "rhdiddl"
> catest =cat()
> print(catest)
>   ```
> 

__서버 코드에서 self.request가  socket 인스턴스와 같이 사용되는이유?__

request.send()가 가능한이유는 TCPServer에서 `request, client_address = self.get_request()` connect_socket을 request로 받음

## 클라이언트

```python
import socket
from threading import Thread

HOST = 'localhost'
PORT = 9009

def rcvMsg(sock):
    while True:
        try:
            data = sock.recv(1024)
            if not data:
                break
            print(data.decode())
        except:
            pass


def runChat():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.connect((HOST, PORT))
        t = Thread(target=rcvMsg, args=(sock,))
        t.daemon = True
        t.start()

        while True:
            msg = input()
            if msg == '/quit':
                sock.send(msg.encode())
                break

            sock.send(msg.encode())
            
            
runChat()
```

