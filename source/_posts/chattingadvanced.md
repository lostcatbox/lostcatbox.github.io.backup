---
title: 소켓을 이용한 실시간 채팅 만들기 (심화편)(wss적용)
date: 2020-08-04 15:12:47
categories: [Chatting]
tags: [Network, Socket, Threading]
---

[실시간 채팅 구현 참조](https://lidron.tistory.com/44)

[serversocket문서](https://python.flowdas.com/library/socketserver.html)

[웹소켓 JSON값](https://websockets.readthedocs.io/en/stable/intro.html)

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

# Websocket을 이용한 실시간채팅구현

[자세히](https://nowonbun.tistory.com/674)

[자세히]([https://igotit.tistory.com/entry/%ED%8C%8C%EC%9D%B4%EC%8D%AC-%EC%9B%B9%EC%86%8C%EC%BC%93-WbeSocket-%EA%B5%AC%ED%98%84](https://igotit.tistory.com/entry/파이썬-웹소켓-WbeSocket-구현))

이제 웹소켓이 필요해졌다

웹으로 배포한것으로 실시간 채팅을 구현하는 것이 목표이기 때문이다.

\+ 추후 성능을 위해 [쓰레드]([http://pythonstudy.xyz/python/article/24-%EC%93%B0%EB%A0%88%EB%93%9C-Thread](http://pythonstudy.xyz/python/article/24-쓰레드-Thread)) 포스팅도 합니다.

__멀티스레드와 비동기는 다른 개념이다__(추후포스팅 분리하기)

> [자세히](https://qastack.kr/programming/34680985/what-is-the-difference-between-asynchronous-programming-and-multithreading)
>
> # 멀티 스레드
>
> 작업자에 관한 개념이다. 달걀과 토스트 주문이 하나 들어오면 이를 작업자1명을 둘것인가 2명을 둘것인가에 따라 다른것이다. 멀티 스레드를 쓴다면 동일한 일을 2개이상의 스레드가 처리한다.
>
> # 비동기
>
> [자세히](https://dojang.io/mod/page/view.php?id=2469)
>
> [공식문서](https://docs.python.org/ko/3/library/asyncio-eventloop.html)
>
> [꼭다시읽기](https://dojang.io/mod/page/view.php?id=2469)
>
> [꼭다시읽기2](https://websockets.readthedocs.io/en/stable/intro.html)
>
> 작업!에 관한 개념이다. 달걀과 토스트 주문이 하나 들어오면 달걀을 구우며 타이머 해놓고, 토스트 돌리며 타이머를 해놓고 나머지는 청소가 가능하다. 즉, 단일 스레드를 중지하지 않고 계속 다른일을 시키는 것이다.
>
> `asyncio` 는 python의 비동기 처리를 위한 라이브러리이다.
>
> async와 await가 핵심이다.

# 연습

### 서버

```python
#websockettest.py

import asyncio
# 웹 소켓 모듈을 선언한다.
import websockets


# 클라이언트 접속이 되면 호출된다.
async def accept(websocket, path):
    while True:
        # 클라이언트로부터 메시지를 대기한다.
        data = await websocket.recv()
        print("receive : " + data)
        # 클라인언트로 echo를 붙여서 재 전송한다.
        await websocket.send("echo : " + data)

# 웹 소켓 서버 생성.호스트는 localhost에 port는 9998로 생성한다.
start_server = websockets.serve(accept, "localhost", 9998)

# 비동기로 서버를 대기한다.
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
```

웹 브라우져에서 위에 작성한 html를 실행시키면 javascript에서 python websocket서버로 접속을 합니다. 그리고 hello와 test의 메시지를 작성해서 보냈는데 server측에서는 hello와 test의 메시지를 받아서 콘솔에 출력을 했고 브라우저에서는 echo : 가 붙은 메시지가 표시가 되었습니다.

### 웹 구성

```html
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    </head>
<body>
    <form onsubmit="return false;">
        <!-- 서버로 메시지를 보낼 텍스트 박스 -->
        <input id="textMessage" type="text">
        <!-- 전송 버튼 -->
        <input onclick="sendMessage()" value="Send" type="button">
        <!-- 접속 종료 버튼 -->
        <input onclick="disconnect()" value="Disconnect" type="button">
    </form>
    <br />
    <!-- 출력 area -->
    <textarea id="messageTextArea" rows="10" cols="50"></textarea>
    <script type="text/javascript">
        // 웹 서버를 접속한다.
        var webSocket = new WebSocket("ws://localhost:9998");
        // 웹 서버와의 통신을 주고 받은 결과를 출력할 오브젝트를 가져옵니다.
        var messageTextArea = document.getElementById("messageTextArea");
        // 소켓 접속이 되면 호출되는 함수
        webSocket.onopen = function(message){
        messageTextArea.value += "Server connect...\n";
        };
        // 소켓 접속이 끝나면 호출되는 함수
        webSocket.onclose = function(message){
        messageTextArea.value += "Server Disconnect...\n";
        };
        // 소켓 통신 중에 에러가 발생되면 호출되는 함수
        webSocket.onerror = function(message){
        messageTextArea.value += "error...\n";
        };
        // 소켓 서버로 부터 메시지가 오면 호출되는 함수.
        webSocket.onmessage = function(message){
        // 출력 area에 메시지를 표시한다.
        messageTextArea.value += "Recieve From Server => "+message.data+"\n";
        };
        // 서버로 메시지를 전송하는 함수
        function sendMessage(){
            var message = document.getElementById("textMessage");
            messageTextArea.value += "Send to Server => "+message.value+"\n";
            //웹소켓으로 textMessage객체의 값을 보낸다.
            webSocket.send(message.value);
            //textMessage객체의 값 초기화
            message.value = "";
            }
        function disconnect(){
                webSocket.close();
            }
    </script>
    </body>
</html>
```

### python파일로 client구성

```python
import asyncio
# 웹 소켓 모듈을 선언한다.
import websockets

async def my_connect():
# 웹 소켓에 접속을 합니다.
    async with websockets.connect("ws://localhost:9998") as websocket:
    # 10번을 반복하면서 웹 소켓 서버로 메시지를 전송합니다.
        for i in range(1,10):
            await websocket.send("hello socket!!")
            # 웹 소켓 서버로 부터 메시지가 오면 콘솔에 출력합니다.
            data = await websocket.recv()
            print(data)
# 비동기로 서버에 접속한다.
asyncio.get_event_loop().run_until_complete(my_connect())
```



# Nginx websocket wss:// 적용하기

https에서는 wss가 필수이므로 반드시 ssl적용이 필요했다.

upstream부터 `server { }를` 따로 설정해줄수있지만 1.1.3버전부터 nginx에서는 이미 websocket에 대해 따로 지원을 해준다. 

```
upstream pythonchattingserver {
        server chattingserver:7777;
}

server {   
    ##아래와 같은 양식으로 추가
    location /websocket/ {
        proxy_pass http://pythonchattingserver/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
    }
}
```

```javascript
// js로 요청하는 방법
var webSocket = new WebSocket("wss://chatting.lostcatbox.com/websocket/");
```

# 



# 오류 해결

모든 브라우저에서 예상대로 종료해주기를 바라는 건 욕심이였다. 모바일 크롬에서만 하면 모두가 채팅이 불가능하게 되었다...

왜그랬을까?

server의 소캣은 user에 기록되어있었지만 실제로는 연결이 끊기 소캣에 대해서는 send()를 해도 오류가 발생하였다.

이를 해결하기위해 try, except 구문을 통해 메세지를 보낼때 만약 전체메시지 전송도중에 오류가 발생하면 self.removeUser(username)함수를 통해 그 등록된 유저와 소캣을 제거하고, pass를 하여 메세지를 모두에게 보내는 함수의 for문이 끊기지 않도록 하여 해결하였다

__[`send()`](https://websockets.readthedocs.io/en/stable/api.html#websockets.protocol.WebSocketCommonProtocol.send) raises a [`ConnectionClosed`](https://websockets.readthedocs.io/en/stable/api.html#websockets.exceptions.ConnectionClosed) exception when the client disconnects, which breaks out of the `while True` loop.__



