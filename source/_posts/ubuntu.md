---
title: 우분투
date: 2020-05-27 01:21:55
categories: [Ubuntu]
tags: [Ubuntu, Basic]
---

```
ssh agd@192.168.1.211
ssh: connect to host 192.168.1.211 port 22: Connection refused
```


PC2에 고정 IP가 구성되어 있습니다. 그리고 WiFi를 통해 PC2에 SSH를 시도하면 작동합니다.

다른 스레드에 대한 몇 가지 가이드를 참조하여 시도했습니다.

```
sudo service ssh status
```

모든 것이 포트 22를 듣고 있습니다.

그런 다음 시도했습니다

```
sudo apt-get purge openssh-server 
sudo apt-get install openssh-server
```

그것도 잘 갔다. 상태를 확인할 때 포트 22 청취

그런 다음 시도했습니다

```
sudo service ssh restart
```

문제 없다

그런 다음 두 PC에서 모두 시도했습니다.

```
ufw allow 22
```

하지만 같은 네트워크 망에있으면 ssh 로 접근 불가능하였다.

```
ssh-keygen -R 192.168.0.7 #shh-keygen 초기화
```

[해결](https://cpuu.postype.com/post/30065)

# root권한을 주는 것과 동시에 외부접속 root계정은 x

[자세히](https://www.hanumoka.net/2019/09/26/ubuntu-20190926-ubuntu-grant-root/)

[자세히](https://studyforus.tistory.com/235)

[자세히](https://www.hanumoka.net/2019/09/26/ubuntu-20190926-ubuntu-grant-root/)

일단 일반 계정에 root권한 부여

```
sudo su #관리자로 로그인
adduser <계정명> #계정 추가
usermod -aG sudo <계정명> #sudo 그룹에 원하는 계정을 추가
su - <계정명> # 계정전환
groups     #잘 등록되었나 확인
su - <계정명> # 계정전환
```

만약 정말 외부접속부터 root계정과 똑같이 쓰고싶다면(sudo사용안해도됨, 권한부여)

(추천하지않는다. 위험)

```
vi /etc/ssh/sshd_config #이동후 
#파일안에
#PermitRootLogin without-password #이부분을 yes로 수정, root계정으로 로그인이 가능하도록

service ssh restart #반드시 재시작해야 적용됨

vim /etc/sudoers #이동

#파일안에서
root All=(ALL:ALL) ALL 
일반계정명 All=(ALL:ALL) ALL   <-  이렇게 추가하자.

vim /etc/passwd #이동
root:x 뒤에 0:0 가 보일것이다.

앞의 0은 uid(유저아이디) 뒤의 0는 gid(그룹아이디)를 의미하는데, 슈퍼유저의 uid는 0 슈퍼유저의 gid도 0이다.

root의 권한이 필요한 일반계정의 uid와 gid를 0:0으로 변경해주자.
lostcatbox:x:0:0:lostcatbox:/home/lostcatbox

vim /etc/group #이동
root:x:0: 를 root:x:0:<일반계정명> 으로 수정해주자.

#확인
 sudo 없이 명령어가 실행되는지 확인해보자.
```

기존에는 sudo docker ps 로 실행 해야 했지만, 이제는 docker ps 로 바로 명령어가 실행되는 것을 확인 할 수 있다.

