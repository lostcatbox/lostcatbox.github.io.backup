---
title: aws부터 drf 설정까지
date: 2020-12-23 17:07:50
categories: [Server]
tags: [Aws, Drf]
---

# 왜?

앞으로도 서버 구성을 하며, aws 보안 설정 등의 과정을 지속적으로 해야하므로 정리해놨다

# aws EC2 인스턴스 생성

프리티어로 설정시 무료

인스턴스 생성시 해당하는 키-페어에 대해 .pem을 주는데 이것은 프라이빗 키라고 생각하면된다. 

이를 

`~/.ssh` 라는 폴더에 옮겨준다. (없을경우 `mkdir ~/.ssh/` 생성후)

pem파일을 해당 폴더의 소유주만 읽을 수 있도록 권한변경해준다. 

```bash
$ chmod 400 ~/.ssh/[yourkeyfile].pem
```

# 해당 인스턴스에 접속

```bash
$ ssh -i <키 페어 경로> <유저내임>@<퍼블릭 DNS 주소>
```

> 유저네임은 ubuntu로 해보자

이제 우리가 일반적으로 사용하는 커널명령어가 먹히도록 몇가지 설치하자 sudo 필수

```bash
$ sudo apt-get update
$ sudo apt-get dist-upgrade
$ sudo apt-get install python3-pip
```

> ubuntu계정에게 폴더 권한을 주기 위해서
>
> `sudo chown -R ubuntu:ubuntu /srv/`
>
> 하지만 위에 과정은 우분투 공유 폴더이용하는방법이고 나는 간단히 myproject 디렉토리생성후작업

```bash
$ mkdir myproject
cd myproject
git clone <원하는 링크>
```

 # 인스턴스에 requirements.txt설치

```bash
$ source venv/bin/activate
$ pip3 install -r requirements.txt
```

> 가상환경으로 프로젝트를 진행해서 git에 venv폴더가 올라가있을경우를 말한다
>
> 없다면 그냥 `pip3 install -r requirements.txt` 해주자

# 인스턴스 보안 설정

인스턴스 정보창에서 보안 보안그룹을 찾아보자 

Security groups!

해당 링크를 누르고 edit inbound rules로 보안 그룹 설정해주자

22포트만 열려있으니까!

나는 개인적으로 8080 포트를 이용할것이므로 8080에 모든 IP에대해 오픈했다

![스크린샷 2020-12-23 오후 5.59.10](https://tva1.sinaimg.cn/large/0081Kckwgy1glxw9a9z7ej30u00woe38.jpg)

# mysql 설치

> sudo apt-get install mysql-server
>
> sudo ufw allow mysql #iptable에서 3306포트열기
>
> sudo systemctl start mysql # mysql 실행
>
> sudo systemctl enable mysql #서버재시작해도 자동 다시시작
>
> sudo /usr/bin/mysql -u root -p #sql 에 접속
>
> mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'COLCTveCNfY8'; #root계정 비번생성

만약 mysql에서 deny당한다면, 

```mysql
UPDATE user SET plugin='mysql_native_password' WHERE User='root'; # 플러그인형식바꾸기
flush privileges; #적용
```

# aws접속하기

인스턴스 정보에 퍼블릭 주소 + :8080 포트로 접속하면 원하는 접속 끝