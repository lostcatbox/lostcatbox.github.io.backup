---
title: 소켓을 이용한 실시간 채팅 만들기 (기본편)
date: 2020-07-31 13:01:31
categories: [Chatting]
tags: [Network, Socket]
---

# 왜?

현재 계획중인 프로젝트가 채팅기능이 들어가있다. 

네트워크 공부도 할겸, 간단한 채팅기능을 처음 구현해볼겸

[자세히](https://seolin.tistory.com/97) 를 따라해보았다.

# 소캣이란?

OSI 7계층에서 프로그램 개발에서는 보통 애플리케이션 계층을 건드린다. 하지만 UDP, TCP의 프로토콜로 구현되는 인터넷을 구현할려면 결국 Tranport계층에 접근해야한다. 애플리케이션 계층에서 트랜스포트 계층을 조작하는 방법이 바로 Socket이라고 불리는 인터페이스이다.  UNIX에서 등장했으며, OS에서 제공하는 인터페이스이고, 어떤 종류의 프로그램이라하더라도 이 소켓에 접근하여 외부 네트워크와 통신할수있다.

## 소캣의 작동방식

소켓은  OS에서 제공하는 인터페이스이다. 소켓에 관련된 작업을 수행하면, OS는 그 요청을 받아들여서 새로운 소켓을 만들어주고, 우리는 오로지 이 소켓으로만 외부 네트워크로 통신이 가능하다. 코코아톡이라는 프로그램자체 외부 네트워크와 아무런 정보도 받지 않는다. __실제 통신은 소켓들이다__. 애플리케이션입장에선 소켓을 통해서 정보를 보내거나 받을 수 있다.

send()함수를 이용하면 자신의 socket에 메시지를 보내게된다. recv()함수를 이용하면 자신의 socket에서 메시지가 있으면 가져온다. (즉, 소켓은 우체통과 비슷하다.)

![스크린샷 2020-07-31 오후 2.26.59](https://tva1.sinaimg.cn/large/007S8ZIlgy1gha39rsnvjj312m0dmgmx.jpg)

## 실습

- socket을 통한 인터넷 사용시 어드레스 패밀리 = AF_INET은 IPv4 or AF_INET6는 IPv6 
- 소켓 타입은 여러가지이지만 주로 SOCK_STREAM, SOCK_DGRAM 사용됨

### 서버소켓 세팅

- bind()

  이 작업이 의미하는 바는 생성된 소켓의 번호와 실제 어드레스 패밀리를 연결해주는 것, bind 함수 내에 튜플을 입력했다는 점을 유의하셔야 합니다. bind('',8080)가 아니라 bind(('',8080))입니다. 앞서 말한대로 bind는 소켓과 AF를 연결하는 과정이라 하였으므로, 이 인자는 어드레스 패밀리가 됩니다. 앞부분은 ip, 뒷부분은 포트로 (ip, port) 형식으로 한 쌍으로 구성된 튜플이 곧 어드레스 패밀리인 것이죠.

- listen

  서버소켓에서만 쓰임, bind가 끝나면 listen 단계가 필요하다. 상대방의 접속을 기다리는 단계,  이는 해당 소켓이 총 몇개의 동시접속까지를 허용할 것이냐는 이야기입니다

- accept()

  이로서 서버 소켓은 상대방의 접속이 올 때까지 계속 대기하는 상태가 됩니다. 그럼 접속을 수락하고, 그 후에 통신을 하기 위해선 어떻게 해야할까요? 이 경우엔 accept를 사용하게 됩니다. accept()는 소켓에 누군가가 접속하여 연결되었을 때에 비로소 결과값이 return되는 함수입니다. 즉, 소스코드 내에 serverSock.accept()가 있더라도, 누군가가 접속할 때까지 프로그램은 바로 이 부분에서 계속 멈춰있게 된단 이야기죠. 상대방이 접속함으로써 __accept()가 실행되면, return 값으로 새로운 소켓과, 상대방의 AF를 전달__해주게 됩니다.
  #접속이 연결된다면 connectionSock이라는 새로운 소캣이 반환되므로 이 소캣과 상대방의 클라이언트 소캣을 사용하여 통신을 구현하자.

```python
#server.py
from socket import *

serverSock = socket(AF_INET, SOCK_STREAM) #두가지인자는 어드레스 패밀리, 소켓 타입 
serverSock.bind(('', 8080)) #서버 소켓에서는 bind해줘야함, 
# ''이므로 8080번 포트에서 모든 인터페이스에게 연결하도록 한다.

serverSock.listen(1) #서버소켓에서만 쓰임,해당 소켓이 총 몇개의 동시접속까지를 허용수 인자

connectionSock, addr = serverSock.accept() 
print(str(addr),'에서 접속이 확인되었습니다.')

data = connectionSock.recv(1024)
print('받은 데이터 : ', data.decode('utf-8'))

connectionSock.send('I am a server.'.encode('utf-8'))
print('메시지를 보냈습니다.')
```

> 만약 재실행을 햇다면 이미 사용중이라며 오류가 뜰것이다
>
> 해결방법은 mac os에서라면 `netstat -ltnp` 이 리눅스처럼 동작하지않는다.\-p가 포트를 뜻하게되어있기때문이다 따라서 아래방법처럼 진행한다.
>
> ```
> sudo lsof -i :8080  #현재 소켓 포트 조회
> sudo kill -9 <PID>  #해당 PID 소켓 제거
> ```
>
> server.py  후에 client.py 실행한다면 소켓을 조회해보면 3개를 볼수있다. 서버소켓은 listen(bind된 소캣계속 유지), ESTABLISHED(새로만들어준 서버소캣), 클라이언트 소켓은 ESTABLISHED(클라이언트 소캣)
>
> [문제해결](https://junho85.pe.kr/1595)
>
> [문제해결2](https://stackoverflow.com/questions/12397175/how-do-i-close-an-open-port-from-the-terminal-on-the-mac)

### 클라이언트 소켓 세팅

```python
#client.py

from socket import *

clientSock = socket(AF_INET, SOCK_STREAM)
clientSock.connect(('127.0.0.1', 8080)) 


print('연결 확인 됐습니다.')
clientSock.send('I am a client'.encode('utf-8'))

print('메시지를 전송했습니다.')

data = clientSock.recv(1024)
print('받은 데이터 : ', data.decode('utf-8'))
```

bind와 listen, accept 과정이 빠지고 대신 connect가 추가되었습니다. 클라이언트에서 서버에 접속하기 위해선 connect()만 실행해주면 됩니다. 여기에도 어드레스 패밀리가 인자로 들어가고, 호스트 주소와 포트번호로 구성된 튜플이 요구됩니다. 127.0.0.1은 자기 자신을 의미하므로, 위의 어드레스 패밀리는 자기 자신에게 8080번 포트로 연결하란 소리가 되겠네요.

__하지만 위에 실습 내용은 연속적으로 주고받지못하며, 프로세스가 실행되면, socket만 남고 프로세스자체가 종료된다__

## 실습2

이제 연속적으로 채팅프로그램처럼 send(), recv()함수를 실시간으로 실행시켜서 소켓을 통해 지속적으로 실시간채팅해보자

### 서버 세팅

- 스레드는 간단히 설명하면 프로세스 내부에서 병렬 처리를 하기 위해, 프로세스의 소스코드 내부에서 특정 함수만 따로 뽑아내어 분신을 생성하는 것입니다. 즉, 원래라면 하나의 절차를 따르며 해야하는 일들도, 스레드를 생성해서 돌릴 경우엔 동시 다발적으로 일을 할 수 있단 소리죠.
- 헬퍼함수로 send(), receive() 작성후 while True를 넣어준다. 이유는 스레드는 자신의 일이 끝나면 사라지므로 계속 존재하며 역할을 수행히기위해서다
- listen()함수는 요청을 계속 기다리게된다, recv()함수도 응답받는것을 계속 기다리게된다.
- 마지막에 time.sleep으로 전체 프로세스 실행이 끝나지 않도록 유지 시켰다. 이유는 아무리 스레드가 남아있더라도 파이썬 파일의 실행이 모두 실행되면  종료되므로 스레드도 남지않게되므로, while True를 써서 파이썬 파일의 프로세스 자체도 유지시켰다. 연산은 너무 자주 일어나지않게 time.sleep걸었다.

```python
#server.py
import threading
import time
from socket import *

serverSock = socket(AF_INET, SOCK_STREAM)
serverSock.bind(('', 8080))
serverSock.listen(1)
connectionSock, addr = serverSock.accept() 
print(str(addr),'에서 접속이 확인되었습니다.')

def send(sock):
    while True:
        senddata=input('>>>')
        sock.send(senddata.encode('utf-8'))
        print('전송완료')


def receive(sock):
    while True:
        recvdata = sock.recv(1024)
        if recvdata.decode('utf-8') == '/quit':
          sock.close()
          break
         
        print('받은 데이터:', recvdata.decode('utf-8'))

sender = threading.Thread(target=send, args=(connectionSock,))
sender.daemon = True  #메인프로세스 종료시 같이 종료
receiver = threading.Thread(target=receive, args=(connectionSock,))
receiver.daemon = True

sender.start()
receiver.start()

while True:
    time.sleep(1)
    pass
```



### 클라이언트 세팅

- 위와 동일

```python
#client.py

import threading
import time
from socket import *

clientSock = socket(AF_INET, SOCK_STREAM)
clientSock.connect(('127.0.0.1', 8080)) 

def send(sock):
    while True:
        senddata=input('>>>')
        sock.send(senddata.encode('utf-8'))
        print('전송완료')
        if senddata == '/quit':
          print('연결정상종료')
          break
    
def receive(sock):
    while True:
        recvdata = sock.recv(1024)
        if not recvdata:
          sock.close()
          break

        print('받은 데이터:', recvdata.decode('utf-8'))


sender = threading.Thread(target=send, args=(clientSock,))
sender.daemon = True
receiver = threading.Thread(target=receive, args=(clientSock,))
receiver.daemon = True

sender.start()
receiver.start()

while True:
    time.sleep(1)
    pass
```

## 오류

while구문을 조심하자

socket.close()를 처음하는 것은 서버나 클라이언트 모두가 가능하다

하지만  반드시  처음으로 close() 요청하는 것을 active open, 처음받는 쪽을  passive  open으로 정의한다.

따라서 passive의 close()가 제대로 동작하지 않는다면 active쪽 소켓을 없어지나 passive의 소켓은 CLOSE_WAIT상태로 유지되며 TIME_OUT시간도없어서 자동으로 사라지지않는다(이런 상태면 반드시 프로세스 자체가 종료되어야함)

따라서 반드시 passive쪽의 소켓의 close()를 제대로 호출해주자!

참고로 close()요청을 받는 passive에서 recv()의 리턴값은 0이므로 `if not recvdata:` 를 사용하여 예시에서는 적용하였다.

![스크린샷 2020-08-04 오후 10.38.54](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghf3yvsar3j30vu0u047v.jpg)

[채팅 심화](https://lidron.tistory.com/44)

[채팅 심화](https://docs.python.org/ko/3.7/howto/sockets.html)