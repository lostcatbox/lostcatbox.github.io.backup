---
title: 우분투 유저, 권환 관련
date: 2020-09-27 15:28:43
categories: [Ubuntu]
tags: [Ubuntu, Basic]
---

# 권한 문제해결 전에

[자세히](https://zetawiki.com/wiki/%EB%A6%AC%EB%88%85%EC%8A%A4_%ED%8C%A8%EC%8A%A4%EC%9B%8C%EB%93%9C_%ED%8C%8C%EC%9D%BC_/etc/passwd)

먼저 linux의 GID, UID에 대해 알아야한다.

UID는 리눅스에서 사용자를 식별하는 유저 아이디로 구분할때 쓰는 것으로 0~32767(16비트)까지 사용한다. 0은 모두 슈퍼유저(root)

UID는 /etc/passwd 파일과 관련이 깊다. 여기에는 사용자의 uid,gid등이 담겨있기때문이다.(패스워드 정도는 없다.) >>초기에는 가지고있었으니 모두 x로 처리되고 패스워드 해시값은 /etc/shadow 파일로 분리되었다.

아래는 passwd파일안의 내용이다.

![스크린샷 2020-09-27 오후 5.22.52](https://tva1.sinaimg.cn/large/007S8ZIlgy1gj5aanokj7j30u00xhgv4.jpg)

[임의로 UID, GID변경시 고려해야될것](https://m.blog.naver.com/koromoon/220577110840)

터미널에서

```
id   # 현재 사용자의 정보들 출력
id -g  # 사용자의 그룹 id만 출력
id -G  #추가 그룹의 id만 출력
id -u  #사용자의 UID출력
```

# 파일 권한 이슈 해결

[자세히](https://conory.com/blog/19194)

읽기, 쓰기 권한 조회

```
ls -al #현재위치에 있는 파일들을 자세히 보여줌
```

그럼 다음과 같은 결과를 볼수있다

```
drwxr-xr-x 10 lostcatbox2 lostcatbox2  4096 Sep 25 03:50 .
drwxr-xr-x  4 root        root         4096 Jul 18 06:46 ..
-rw-------  1 lostcatbox2 lostcatbox2 26816 Sep 25 04:45 .bash_history
-rw-r--r--  1 lostcatbox2 lostcatbox2   220 Jul 18 06:46 .bash_logout
-rw-r--r--  1 lostcatbox2 lostcatbox2  3771 Jul 18 06:46 .bashrc
drwx------  2 lostcatbox2 lostcatbox2  4096 Jul 18 06:55 .cache
```

__파일Type|퍼미션정보|링크수|소유자|소유그룹|용량|생성날짜|파일이름__ 형식이다

- 파일Type : "**d**" -> 디렉토리 , "**l**" -> 링크파일 , "**-**" -> 일반파일 등등..

- 퍼미션정보: 해당 파일에 어떠한 퍼미션이 부여되어있는 지 표시!

  - 읽기 ( r ) : 파일의 읽기권한

  - 쓰기 ( w ) : 파일의 쓰기권한

  - 실행 ( x ) : 파일의 실행권한

  - 읽는 방법은 다음과 같다

    3자리씩 나눠서 "**소유자 :** rwx , **그룹 :** r-x , **공개 :** r-x" 

    > rwx  r-x  r-x라면
    >
    > 이 파일에 대해서 소유자는 읽기(r),쓰기(w),실행(x)을 허용하고, 
    >
    > 파일의 소유그룹에 속하고 있는 사용자들은 읽기(r),실행(x)만 허용하고,
    >
    > 이외에 나머지 모든 사용자들도 읽기(r),실행(x)만 허용한다. 

  

- 링크수: 해당 파일이 링크된 수! 링크는 윈도우의 "바로가기"와 같습니다. "**in [대상파일] [링크파일]**" 명령으로 링크파일을 만듭니다.

- 소유자: 해당 파일의 소유자이름! (누구껀지?)

- 소유그룹: 해당 파일을 소유한 그룹이름! 특별한 변경이 없을 경우 소유자가 속한 그룹이 소유그룹으로 지정됩니다.

- 용량: 파일의 용량

## 퍼미션 변경하기

파일이 생성될때 기본적인 퍼미션이 부여된다.

하지만, 퍼미션을 변경하고 싶을 때가 있습니다. (가령 이 파일을 모두에게 공개한다거나 하는...)

`chmod [변경될 퍼미션값] [변경할 파일]`

> 그럼 퍼미션 값은 어떻게 구할까?
>
> - 각 퍼미션 기호를 숫자로 변환 합니다. ( r = 4 , w = 2 , x = 1 )
>
>   r  -  x 인 경우 4  0  1
>
> - 변환한 숫자를 합산합니다.
>
>   예) 4  0  1 인 경우  4+0+1 = 5
>
>   rwxr-xr-x 이면 rwx  r-x  r-x 세자리씩 끊고, 4+2+1  | 4+0+1 | 4+0+1  숫자변환 뒤 합산하면 "755" 라는 퍼미션값이 나온다.

`chmod 755 conory.text` 명령을 실행하면 conory.text 파일이 755에 해당되는 퍼미션으로 변경된다.

디렉토리의 경우 "-R" 옵션을 사용하면 하위 디렉토리의 모든 디렉토리및 파일의 퍼미션이 변경된다.

`chmod -R 777 conory` 명령은 conory 디렉토리의 하위에 위치한 모든 파일및 디렉토리 퍼미션이 777로 변경된다.

## 소유자 변경하기

`chown [변경할 소유자] [변경할 파일]`

이 명령으로 소유자뿐만 아니라 소유그룹도 변경할 수 있다.

[변경할 소유자]란에 ".그룹이름" 형식으로 입력한다. " .conory "

예를 들어 conory.text의 소유자를 "conory"로, 소유그룹을 "conory2"로 동시에 변경할 경우 " **chown conory.conory2 conory.text** "

# root권한, 외부접속x

[자세히](https://www.hanumoka.net/2019/09/26/ubuntu-20190926-ubuntu-grant-root/)

[자세히](https://studyforus.tistory.com/235)

[자세히](https://www.hanumoka.net/2019/09/26/ubuntu-20190926-ubuntu-grant-root/)

root권한을 주는 것과 동시에 외부접속 root계정은 x

일단 일반 계정에 root권한 부여(sudo 사용이 가능하도록한다.)

```
sudo su #관리자로 로그인
adduser <계정명> #계정 추가
usermod -aG sudo <계정명> #sudo 그룹에 원하는 계정을 추가
su - <계정명> # 계정전환
groups     #잘 등록되었나 확인
su - <계정명> # 계정전환
```

만약 정말 외부접속부터 root계정과 똑같이 쓰고싶다면

(sudo사용안해도됨, 권한부여)

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



