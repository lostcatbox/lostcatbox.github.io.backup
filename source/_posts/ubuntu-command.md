---
title: 우분투 자주 쓰는 명령어
date: 2020-09-27 15:25:09
categories: [Ubuntu]
tags: [Ubuntu, Basic]
---

[포스팅할것](https://cragy0516.github.io/Expand-Hard-Disk-in-VMWare/)

# ubuntu?

UNIX>Linux>ubuntu로 발전되어왔으며, 특히 Linux를 기반으로 ubuntu와 같은 파생 os들이 많아졌다.



# 자주 쓰는 명령어(세부옵션 제외)

[자세히](https://vaert.tistory.com/103)

[자세히](https://aonenetworks.tistory.com/644)

```
shutdown : 시스템 종료

halt : 시스템 종료

init 0 : 시스템 종료

poweroff : 시스템 종료

reboot : 시스템 재부팅

init 6 : 시스템 재부팅

shutdown -r now : 시스템 재부팅




pwd : 현재 자신이 위치하는 디렉토리

cd : 디렉토리 이동

ls : 자신이 속해있는 폴더 내에서의 파일 및 폴더들을 표시

mkdir : 디렉토리 생성 ( 폴더 생성 )  == 앞으로 폴더를 디렉토리로 쓰겠습니다.

rmdir : 디렉토리 삭제



touch : 파일크기가 0인 파일 생성 ( 잘 쓰진 않지만, 파일 시간 정보를 변경하는 용도로 쓰이거나, 하드디스크의 오류를 판단할 때 쓰입니다)

cp : 파일 복사  ( 디렉토리 내부까지 복사하기 위해서는 cp -R 이라는 옵션을 붙여줍니다 )

mv : 파일 이동, 이름변경으로도 활용가능

rm : 파일 삭제 ( 디렉토리를 삭제할 경우는 rmdir 보다 rm -R을 많이 씁니다 )

cat : 파일의 내용을 화면에 출력

more : 화면 단위로 보기좋게 내용 출력

less : more 의 단점을 조금 보완한 명령어

find : 특정한 파일을 찾는 명령어입니다.(아래 옵션 참조)

grep : 특정 패턴을 이용해서 파일을 찾는 명령어

>>  : 리다이렉션 ( 파일의 끼워넣기 등등에 이용 )

awk : grep 과 같게 패턴형식으로 찾긴 하지만 공부할 필요성이 있음 ( 사용이 조금 힘듦 )

file : 파일의 종류를 확인

which : 특정 명령어의 위치를 찾아주는 명령어

 



ping : 컴퓨터를 공부하시는 분이시면 잘 아실 겁니다.

top : 리눅스 시스템의 운영상황을 실시간으로 전반적인 상황을 모니터링하거나 프로세스 관리를 할 수 있는 유틸리티이다. 

ps : 현재 실행중인 프로세스 목록과 상태를 보여준다


ifconfig : Windows 의 ifconfig

netstat : 네트워크의 상태

nbtstat : IP 충돌이 발생할 경우, 충돌 된 컴퓨터를 찾기 위한 명령어

traceroute : Windows 의 tracert  : 알고자 하는 목적지까지의 경로를 찾아주는 명령어

route : 리눅스 시스템의 라우팅 테이블 구성 상태

 



clock : CMOS 의 시간을 조절하는 명령어

date : 시간과 날짜 출력 및, 시간과 날짜 변경

rdate : 원격지의 타임서버로부터 날짜와 시간을 받아와서 , 시스템에 설정

 



rpm : rpm 패키지를 설치하고 삭제 또는 관리하는 명령어

yum : 인터넷을 통하여 rpm 패키지가 저장된 서버에 접속하여 설치하고자 하는 rpm 패키지를 설치

          // 다른 rpm 필요 패키지까지 다 알아서 다운받아주는 정말 유용한 명령어

 



free: 시스템 메모리의 정보 출력

ps : 현재 실행되고 있는 프로세스 목록 출력

pstree : 프로세스의 정보를 트리 형식으로 출력

top : 리눅스 시스템의 운용상황을 실시간으로 전반적인 상황을 모니터링 하는 기능

kill : 특정 프로세스에게 특정 시그널(signal) 을  보내는 명령어

killall : 특정 프로세스를 모두 종료

killall5 : 모든 프로세스 종료 [ 절대 사용 X ]

 



tar

bzip2

gzip    // 이렇게 3개는 파일 압축 형식을 묶거나 푸는 명령어들

 



chmod : 특정 파일 또는 디렉토리의 퍼미션 수정

chown : 파일이나 디렉토리의 소유자, 소유 그룹 수정

chgrp  : 파일이나 디렉토리의 소유 그룹 수정

   >> 이게 왜 나뉘어졌냐면, 소유자를 수정하면 보안적인 문제가 있어서 그룹, 사용자 둘 다 수정 가능, 그룹만 수정 가능 두 개로 나뉘는거에요 명령어 ~

 



umask : 파일 생성시의 퍼미션값을 변경하는 명령어 ( 후에 자세히 포스팅 )

 



at: 정해진 시간에 작업을 하나만 수행 할 수 있는 명령어

crontab : 반복적인 작업을 수행하는 명령어

 // 실무에서 많이 쓰입니다. 미리 지정해서 디스크 최적화를 위한 반복적인 로그 파일 삭제 등등 이러한 것들이 있어요

 



useradd : 새로운 사용자 계정 생성

password : 사용자 계정의 비밀번호 설정

userdel : 계정 지우기

usermod : 사용자 계정 정보 수정

 



fg : foreground

bg : background

jobs : 실행되는 job들 나열

 



groupadd : 그룹 생성

groupdel : 그룹 삭제

groups : 그룹 확인

newgrp : 자신이 속한 그룹 변경

 



mesg : 메시지 응답 가능 및 불가 설정
talk : 로그인한 사용자끼리 대화
wall : 시스템에 로그인한 모든 사용자에게 메시지 보내기
write : 로그인한 사용자에게 메시지 전달

 



dd : 블럭단위로 파일을 복사하거나 파일의 변환을 할 수 있는 명령어

```

```
vi 모드에서 단축키
i # 편집모드
dd #한줄삭제
uu #되돌아가기
:q! #수정사항저장안하고 끝
:wq! # 수정사항 저장하고 끝
```

# 예시

```
# cat으로 출력한 것을 ssh로 접속후에 ''안에명령어로 해당파일에 추가
cat ~/.ssh/aws-eb.pub | ssh lostcatbox2@192.168.88.244 'cat >> .ssh/authorized_keys'
```

# find

[자세히](https://recipes4dev.tistory.com/156)

| [현재 디렉토리에 있는 파일 및 디렉토리 리스트 표시](https://recipes4dev.tistory.com/156#31-현재-디렉토리에-있는-파일-및-디렉토리-리스트-표시) | `find`                   |
| ------------------------------------------------------------ | ------------------------ |
| [대상 디렉토리에 있는 파일 및 디렉토리 리스트 표시](https://recipes4dev.tistory.com/156#32-대상-디렉토리에-있는-파일-및-디렉토리-리스트-표시) | `find [PATH]`            |
| [현재 디렉토리 아래 모든 파일 및 하위 디렉토리에서 파일 검색](https://recipes4dev.tistory.com/156#33-현재-디렉토리-아래-모든-파일-및-하위-디렉토리에서-파일-검색) | `find . -name [FILE]`    |
| [전체 시스템(루트 디렉토리)에서 파일 검색](https://recipes4dev.tistory.com/156#34-전체-시스템루트-디렉토리에서-파일-검색) | `find / -name [FILE]`    |
| [파일 이름이 특정 문자열로 시작하는 파일 검색](https://recipes4dev.tistory.com/156#35-파일-이름이-특정-문자열로-시작하는-파일-검색) | `find . -name "STR*"`    |
| [파일 이름에 특정 문자열이 포함된 파일 검색](https://recipes4dev.tistory.com/156#36-파일-이름에-특정-문자열이-포함된-파일-검색) | `find . -name "**STR**"` |
| [파일 이름이 특정 문자열로 끝나는 파일 검색](https://recipes4dev.tistory.com/156#37-파일-이름이-특정-문자열로-끝나는-파일-검색-파일-확장자로-검색) | `find . -name "*STR"`    |

# grep

[자세히](https://recipes4dev.tistory.com/157)

기본적으로 정규 표현식으로 검색하므로 다양하게 활용가능

`cat rhdiddl/rhdiddl22|grep "hello"` 보통 이렇게 `|` 다음에 쓰면서 활용성이 더 높아짐

기본 `grep` 명령어 양식

`$ grep [OPTION] [PATTERN] [FILE]`

| grep 사용 예                                                 | 명령어 옵션                |
| ------------------------------------------------------------ | -------------------------- |
| [대상 파일에서 문자열 검색](https://recipes4dev.tistory.com/157#31-대상-파일에서-문자열-검색) | `grep "STR" [FILE]`        |
| [현재 디렉토리 모든 파일에서 문자열 검색](https://recipes4dev.tistory.com/157#32-현재-디렉토리-모든-파일에서-문자열-검색) | `grep "STR" *`             |
| [특정 확장자를 가진 모든 파일에서 문자열 검색](https://recipes4dev.tistory.com/157#33-특정-확장자를-가진-모든-파일에서-문자열-검색) | `grep "STR" *.ext`         |
| [대소문자 구분하지 않고 문자열 검색](https://recipes4dev.tistory.com/157#34-대소문자-구분하지-않고-문자열-검색) | `grep -i "STR" [FILE]`     |
| [매칭되는 PATTERN이 존재하지 않는 라인 선택](https://recipes4dev.tistory.com/157#35-매칭되는-pattern이-존재하지-않는-라인-선택) | `grep -v "STR" [FILE]`     |
| [단어(Word) 단위로 문자열 검색](https://recipes4dev.tistory.com/157#36-단어word-단위로-문자열-검색) | `grep -w "STR" [FILE]`     |
| [검색된 문자열이 포함된 라인 번호 출력](https://recipes4dev.tistory.com/157#37-검색된-문자열이-포함된-라인-번호-출력) | `grep -n "STR" [FILE]`     |
| [하위 디렉토리를 포함한 모든 파일에서 문자열 검색](https://recipes4dev.tistory.com/157#38-하위-디렉토리를-포함한-모든-파일에서-문자열-검색) | `grep -r "STR" *`          |
| [최대 검색 결과 갯수 제한](https://recipes4dev.tistory.com/157#39-최대-검색-결과-갯수-제한) | `grep -m 100 "STR" FILE`   |
| [검색 결과 앞에 파일 이름 표시](https://recipes4dev.tistory.com/157#310-검색-결과-앞에-파일-이름-표시) | `grep -H "STR" *`          |
| [문자열 A로 시작하여 문자열 B로 끝나는 패턴 찾기](https://recipes4dev.tistory.com/157#311-문자열-a로-시작하여-문자열-b로-끝나는-패턴-찾기) | `grep "A.*B" *`            |
| [0-9 사이 숫자만 변경되는 패턴 찾기](https://recipes4dev.tistory.com/157#312-0-9-사이-숫자만-변경되는-패턴-찾기) | `grep "STR[0-9]" *`        |
| [문자열 패턴 전체를 정규 표현식 메타 문자가 아닌 일반 문자로 검색하기](https://recipes4dev.tistory.com/157#313-문자열-패턴-전체를-정규-표현식-메타-문자가-아닌-일반-문자로-검색하기) | `grep -F "*[]?..." [FILE]` |
| [정규 표현식 메타 문자를 일반 문자로 검색하기](https://recipes4dev.tistory.com/157#314-정규-표현식-메타-문자를-일반-문자로-검색하기) | `grep "\*" [FILE]`         |
| [문자열 라인 처음 시작 패턴 검색하기](https://recipes4dev.tistory.com/157#315-문자열-라인의-처음-시작-패턴-검색하기) | `grep "^STR" [FILE]`       |
| [문자열 라인 마지막 종료 패턴 검색하기](https://recipes4dev.tistory.com/157#316-문자열-라인-마지막-종료-패턴-검색하기) | `grep "$STR" [FILE]`       |

