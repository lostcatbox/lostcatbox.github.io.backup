---
title: 우분투 ssh,ftp,sftp 설정
date: 2020-05-27 01:21:55
categories: [Ubuntu]
tags: [Ubuntu, Basic]
---

# ssh 적용

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

# 비번없이 ssh 로그인하기

[자세히]([https://employee.tistory.com/entry/%EB%B9%84%EB%B0%80%EB%B2%88%ED%98%B8-%EC%97%86%EC%9D%B4-ssh-%EB%A1%9C%EA%B7%B8%EC%9D%B8](https://employee.tistory.com/entry/비밀번호-없이-ssh-로그인))

## ssh의 공개 키 인증 방식

공개 키 (Public Key)로 암호화 한 문자열은 비공개 키 (Private Key)로 복호화가 가능하다. 반대로 비공개 키로 암호화한 문자열은 공개 키로 복호화가 가능하다.

1. 클라이언트가 접속을 요청하면 서버는 임의의 문자열을 클라이언트에게 전달한다.
2. 클라이언트는 이 문자열을 비공개 키로 사인하여 공개 키와 함께 보내준다.
3. 서버는 공개 키가 .ssh/authorized_keys에 등록되어있는지 확인한 후 공개키를 이용하며 문자열을 해독하여 인증을 종료한다.

위의 방식은 클라이언트는 비공개 키와 공개 키를 만들어 공개 키를 ssh 서버에 저장해 두었다고 가정한다. 이 작업이 선행되지 않으면 공개 키 기반 인증이 작동하지 않는다. 즉, 최초 1회는 암호를 이용한 접속을 하여 공개키를 서버에 저장해 두어야 한다. 혹은 관리자가 서버를 설치할 때 id_rsa 파일을 복사해 둬야 한다.

## 공개 키, 비공개 키 생성

다음 명령어를 입력해 키를 생성한다.

```
$ ssh-keygen
```

 

`-t` 옵션을 주지 않으면 rsa 알고리즘으로 키를 생성한다.



아래와 같이 저장 장소, passphrase를 묻는다. passphrase는 비밀 키를 한 번 더 암호화 할 때 사용되는 문자열이다. passphrase를 사용한다면 서버 접속 시 아래와 같이 passphrase를 입력해야 한다.

```
$ ssh username@domain.name
Enter passphrase for key '~/.ssh/id_rsa':
```

 

passphrase를 사용하지 않았을 때 비공개 키 파일인 id_rsa가 유출이 된다면 해커는 암호 임력 없이도 서버에 접속할 수 있다.

## id_rsa.pub를 authorized_keys에 추가

sftp를 이용해도 되지만, 터미널에서 명령어 2줄 이면 가능하다.

### athorized_keys 생성

접속하고자 하는 서버에 authorized_keys 파일이 없다면 생성해주자.

```
$ ssh username@domain.name mkdir .ssh
```

### id_rsa.pub 추가

```
$ cat ~/.ssh/id_rsa.pub | ssh username@domain.name 'cat >> .ssh/authorized_keys'
```

### 퍼미션 설정

.ssh 폴더와 authorized_keys 퍼미션을 적절하게 바꿔줘야 로그인이 가능하다.

```
$ ssh username@domain.name 'chmod 700 .ssh; chmod 640 .ssh/authorized_keys'
```

## 설정 완료

이제 password 없이 서버에 접속이 가능하다.



# sftp 설정

```
sudo vi /etc/ssh/sshd_config  
```



```
# sshd_config 내용중에

Port 22      #22번 포트열어줌
PermitRootLogin yes   #루트 권한자 로그인 가능(파일쓰기,읽기 모두 ftp에서 필요했음)
```



```
sudo /etc/init.d/ssh restart   #반드시 재시작필요
```

