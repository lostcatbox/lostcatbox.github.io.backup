---
title: docker
date: 2020-05-21 14:21:23
categories: [Docker]
tags: [Docker, Basic]
---

# 출처

[자세히](https://subicura.com/2017/01/19/docker-guide-for-beginners-1.html)

[자세히2](https://subicura.com/2017/01/19/docker-guide-for-beginners-2.html)

[자세히3](https://subicura.com/2017/01/19/docker-guide-for-beginners-2.html)

[아주 기본적인 django+MySQL세팅](https://medium.com/@minghz42/docker-setup-for-django-on-mysql-1f063c9d16a0)

# 도커 명령어

[자세히](https://docs.docker.com/engine/reference/commandline/docker/)

```
docker exec -it ec1 /bin/bash #container에 접속해 bash열기
docker exec -it mysql bash #mysql깔린컨테이너로 접속
docker ps #  현재 실행중인 컨테이너 목록
docker ps -a #  모든 컨테이너 목록 표시, stop된것까지
docker stop <컨테이너 ID> #앞에조금만입력해도가능
docker rm [OPTIONS] <컨테이너 ID>  #컨테이너를 완전히 삭제
docker rm -v $(docker ps -a -q -f status=exited) #중지된 컨테이너들 모두 삭제
docker images  #도커 이미지 목록 확인
docker pull [OPTIONS] <NAME>[:TAG|@DIGEST] #pull은 보통 이미지가 있지만 최신으로업뎃할때사용
docker rmi [OPTIONS] <IMAGE>  #이미지 제거, 많은 레이어로 이뤄져있기때문에 DELETED여러개
docker logs [OPTIONS] <CONTAINER> #컨터이너 로그값 확인
docker logs --tail 10 <CONTAINER_ID> #마지막 10줄 로그값 확인
docker logs -f <CONTAINER_ID> #실시간 로그값 확인
docker exec [OPTIONS] CONTAINER COMMAND [ARG...] # 실행중인 커테이너에 들어가보거나, 컨테이너 파일을 실행하고싶을때 사용.ssh권장안함.
```

>__중요!!__
>
>프로그램마다 로그 파일은 제각각 생길텐데, docker가 표시해주는 로그는? 표준스트림중 stdout, stderr를 수집합니다. 따라서 프로그램의 로그 설정을 파일이 아닌 표준출력으로 바꿔줘야함@, 출력방식 꼭 바꾸기. 
>
>\+ 컨테이너의 로그파일은 json방식으로 어딘가에 저장됩니다. 로그가 많으면 파일이 차지하는 용량이 커지므로 주의! 규모 커지면 기본적인 방식 대신 로그 서비스를 이용고려
>
>exec팁
>
>```
>docker exec -it mysql mysql -uroot #완전한 권한 얻는 예시, mysql실행후바로 뒤에 적어놓은 명령 수행
>docker exec -it mysql bash #두줄이위와같은 명령임
>mysql -uroot #bash안에서 입력하면 mysql로 진입
>```

```
 docker stop $(docker ps -a -q) #구동중인 모든 도커 컨테이너들을 중지

 docker rm $(docker ps -a -q) 구동중인 모든 도커 컨테이너들을 삭제

 docker rmi $(docker images -q) #모든 도커 이미지 삭제
```





 ## 도커 Run options

도커를 실행하는 명령어는 다음과 같습니다.

```
docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]
```

다음은 자주 사용하는 옵션들입니다.

| 옵션  | 설명                                                   |
| :---- | :----------------------------------------------------- |
| -d    | detached mode 흔히 말하는 백그라운드 모드              |
| -p    | 호스트와 컨테이너의 포트를 연결 (포워딩)               |
| -v    | 호스트와 컨테이너의 디렉토리를 연결 (마운트)           |
| -e    | 컨테이너 내에서 사용할 환경변수 설정                   |
| –name | 컨테이너 이름 설정                                     |
| –rm   | 프로세스 종료시 컨테이너 자동 제거                     |
| -it   | -i와 -t를 동시에 사용한 것으로 터미널 입력을 위한 옵션 |
| –link | 컨테이너 연결 [컨테이너명:별칭]                        |

# 도커란?

> 간단히 말해서 이미지는 프로그램  묶음
>
> 컨테이너는 프로그램을 실행, 실행대기 상태로 해놓은것

도커는 **컨테이너 기반의 오픈소스 가상화 플랫폼**입니다.

컨테이너는 격리된 공간에서 프로세스가 동작하는 기술입니다. 가상화 기술의 하나지만 기존방식과는 차이가 있습니다.

기존의 가상화 방식은 주로 **OS를 가상화**하였습니다.(비주얼박스같이 OS위에 OS)

Server>Host OS> Guest OS>Bins/Libs>App 방식에서

Server>Host OS> Docker Engine>Bins/Libs>App

 **프로세스를 격리** 하는 방식이 등장합니다.

리눅스에서는 이 방식을 리눅스 컨테이너라고 하고 단순히 프로세스를 격리시키기 때문에 가볍고 빠르게 동작합니다. CPU나 메모리는 딱 프로세스가 필요한 만큼만 추가로 사용하고 성능적으로도 거어어어어의 손실이 없습니다.

> 도커의 기본 네트워크 모드는 `Bridge`모드로 약간의 성능 손실이 있습니다. 네트워크 성능이 중요한 프로그램의 경우 `--net=host` 옵션을 고려해야 합니다.

하나의 서버에 여러개의 컨테이너를 실행하면 서로 영향을 미치지 않고 독립적으로 실행되어 마치 가벼운 VMVirtual Machine을 사용하는 느낌을 줍니다. 실행중인 컨테이너에 접속하여 명령어를 입력할 수 있고 `apt-get`이나 `yum`으로 패키지를 설치할 수 있으며 사용자도 추가하고 여러개의 프로세스를 백그라운드로 실행할 수도 있습니다. CPU나 메모리 사용량을 제한할 수 있고 호스트의 특정 포트와 연결하거나 호스트의 특정 디렉토리를 내부 디렉토리인 것처럼 사용할 수도 있습니다.

도커에서 가장 중요한 개념은 컨테이너와 함께 이미지라는 개념입니다.

<그림 전부가 도커 이미지>

![docker-image](https://subicura.com/assets/article_images/2017-01-19-docker-guide-for-beginners-1/docker-image.png)

이미지는 **컨테이너 실행에 필요한 파일과 설정값등을 포함하고 있는 것**으로 상태값을 가지지 않고 변하지 않습니다(Immutable). 컨테이너는 이미지를 실행한 상태라고 볼 수 있고 추가되거나 변하는 값은 컨테이너에 저장됩니다. 같은 이미지에서 여러개의 컨테이너를 생성할 수 있고 컨테이너의 상태가 바뀌거나 컨테이너가 삭제되더라도 이미지는 변하지 않고 그대로 남아있습니다.

ubuntu이미지는 ubuntu를 실행하기 위한 모든 파일을 가지고 있고 MySQL이미지는 debian을 기반으로 MySQL을 실행하는데 필요한 파일과 실행 명령어, 포트 정보등을 가지고 있습니다.

말그대로 이미지는 컨테이너를 실행하기 위한 모든 정보를 가지고 있기 때문에 더 이상 의존성 파일을 컴파일하고 이것저것 설치할 필요가 없습니다. 이제 새로운 서버가 추가되면 미리 만들어 놓은 이미지를 다운받고 컨테이너를 생성만 하면 됩니다. 한 서버에 여러개의 컨테이너를 실행할 수 있고, 수십, 수백, 수천대의 서버도 문제없습니다.

도커 이미지는 [Docker hub](https://hub.docker.com/)에 등록하거나 [Docker Registry](https://docs.docker.com/registry/) 저장소를 직접 만들어 관리할 수 있습니다. 현재 공개된 도커 이미지는 50만개가 넘고 Docker hub의 이미지 다운로드 수는 80억회에 이릅니다. 누구나 쉽게 이미지를 만들고 배포할 수 있습니다.

# 레이어(layer)

유니온 파일 시스템을 이용하여 여러개의 레이어를 하나의 파일시스템으로 사용할 수 있게 해줍니다. 이미지는 여러개의 읽기 전용read only 레이어로 구성되고 파일이 추가되거나 수정되면 새로운 레이어가 생성됩니다.

ubuntu 이미지가 `A` + `B` + `C`의 집합이라면, ubuntu 이미지를 베이스로 만든 nginx 이미지는 `A` + `B` + `C` + `nginx`가 됩니다. webapp 이미지를 nginx 이미지 기반으로 만들었다면 예상대로 `A` + `B` + `C` + `nginx` + `source` 레이어로 구성됩니다. webapp 소스를 수정하면 `A`, `B`, `C`, `nginx` 레이어를 제외한 새로운 `source(v2)` 레이어만 다운받으면 되기 때문에 굉장히 효율적으로 이미지를 관리할 수 있습니다. ~~(개이득)~~

컨테이너를 생성할 때도 레이어 방식을 사용하는데 기존의 이미지 레이어 위에 읽기/쓰기read-write 레이어를 추가합니다. 이미지 레이어를 그대로 사용하면서 컨테이너가 실행중에 생성하는 파일이나 변경된 내용은 읽기/쓰기 레이어에 저장되므로 여러개의 컨테이너를 생성해도 최소한의 용량만 사용합니다.

가상화의 특성상 이미지 용량이 크고 여러대의 서버에 배포하는걸 감안하면 단순하지만 엄청나게 영리한 설계입니다.

# 이미지 경로

![image-url](https://subicura.com/assets/article_images/2017-01-19-docker-guide-for-beginners-1/image-url.png)

이미지는 url 방식으로 관리하며 태그를 붙일 수 있습니다. ubuntu 14.04 이미지는 `docker.io/library/ubuntu:14.04` 또는 `docker.io/library/ubuntu:trusty` 이고 `docker.io/library`는 생략가능하여 `ubuntu:14.04` 로 사용할 수 있습니다. 이러한 방식은 이해하기 쉽고 편리하게 사용할 수 있으며 태그 기능을 잘 이용하면 테스트나 롤백도 쉽게 할 수 있습니다.

# Dockerfile

[자세히](https://blog.naver.com/PostView.nhn?blogId=alice_k106&logNo=220646382977&parentCategoryNo=7&categoryNo=&viewDate=&isShowPopularPosts=true&from=search)

[만드는과정자세히](https://subicura.com/2017/02/10/docker-guide-for-beginners-create-image-and-deploy.html)

```dockerfile
# vertx/vertx3 debian version
FROM subicura/vertx3:3.3.1
MAINTAINER chungsub.kim@purpleworks.co.kr


ADD build/distributions/app-3.3.1.tar /
ADD config.template.json /app-3.3.1/bin/config.json
ADD docker/script/start.sh /usr/local/bin/
RUN ln -s /usr/local/bin/start.sh /start.sh


EXPOSE 8080
EXPOSE 7000


CMD ["start.sh"]
```

도커는 이미지를 만들기 위해 `Dockerfile`이라는 파일에 자체 DSLDomain-specific language언어를 이용하여 이미지 생성 과정을 적습니다. 추후에 문법에 대해 자세히 다루겠지만 위 샘플을 보면 그렇게 복잡하지 않다는 걸 알 수 있습니다.

이것은 굉장히 간단하지만 유용한 아이디어인데, 서버에 어떤 프로그램을 설치하려고 이것저것 의존성 패키지를 설치하고 설정파일을 만들었던 경험이 있다면 더 이상 그 과정을 블로깅 하거나 메모장에 적지 말고 `Dockerfile`로 관리하면 됩니다. 이 파일은 소스와 함께 버전 관리 되고 원한다면 누구나 이미지 생성과정을 보고 수정할 수 있습니다.

```
#이미지 생성 명령어
docker build --tag echoalpine:1.0 . #tag는 리포지토리 이름, 태그로 1.0 사용
docker run echoalpine:1.0 #만든 이미지 실행
```

다. 빌드 컨텍스트는 빌드를 실행할 때 사용할 파일 집합이다. docker build 명령어는 도커 데몬에 빌드 컨텍스트를 전송한다. 빌드 컨텍스트는 빌드 명령을 실행하는 디렉토리와 그 하위 디렉토리에 포함된 전체 파일이다.

빌드 컨텍스트에는 COPY나 ADD에서 사용하지 않는 파일도 포함되므로 빌드 컨텍스트에는 필요한 파일만 포함해야 한다. 부득이하게 빌드 과정에서 사용하지 않는 파일이 존재할 경우 .dockerignore 파일을 만들어 컨텍스트에서 제외할 대상을 지정하면 된다.

## dockerfile언어

```
FROM # 이미지를 생성할 때 사용할 기반 이미지를 지정한다.

RUN # 이미지를 생성할 때 실행할 코드를 지정한다. bash 쉘에서 입력하는것과 동일하다고 생각하면 된다.


WORKDIR #작업 디렉토리를 지정한다. 해당 디렉토리가 없으면 새로 생성한다. 작업 디렉토리를 지정하면 그 이후 명령어는 해당 디렉토리를 기준으로 동작한다. (ADD, COPY는 절대경로적기)

ADD # build 명령 중간에 호스트의 파일 시스템으로부터 파일을 가져오는 것이다. 말 그대로 이미지에 파일을 더한다(ADD)., COPY명령어와 매우 유사하나 몇가지 추가 기능이 있습니다. src에 파일 대신 URL을 입력할 수 있고 src에 압축 파일을 입력하는 경우 자동으로 압축을 해제하면서 복사됩니다.

COPY # 파일이나 폴더를 이미지에 복사한다.첫번째를 두번째로 복사

ENV # 이미지에서 사용할 환경 변수 값을 지정한다. 

ENTRYPOINT "실행명령어", "인자1", "인자2", ... ] # 컨테이너를 구동할 때 실행할 명령어를 지정한다. 배열에서 첫 번째는 실행할 명령어이다. 두 번째부터는 명령어의 인자로 전달된다.

CMD #도커 컨테이너가 실행되었을 때 실행되는 명령어를 정의합니다. 여러 개의 CMD가 존재할 경우 가장 마지막 CMD만 실행됩니다

EXPOSE # 도커 컨테이너가 실행되었을 때 요청을 기다리고 있는(Listen) 포트를 지정합니다. 여러개의 포트를 지정할 수 있습니다.

VOLUME  #컨테이너 외부에 파일시스템을 마운트 할 때 사용합니다. 반드시 지정하지 않아도 마운트 할 수 있지만, 기본적으로 지정하는 것이 좋습니다.
```



# 설치 및 세팅

맥환경: [Docker for mac](https://docs.docker.com/docker-for-mac/)

[리눅스](https://subicura.com/2017/01/19/docker-guide-for-beginners-2.html)

## Linux

자동 설치 스크립트를 이용

```
curl -fsSL https://get.docker.com/ | sudo sh
```

**sudo 없이 사용하기**

docker는 기본적으로 root권한이 필요합니다. root가 아닌 사용자가 sudo없이 사용하려면 해당 사용자를 `docker`그룹에 추가합니다.

```
sudo usermod -aG docker $USER # 현재 접속중인 사용자에게 권한주기
sudo usermod -aG docker your-user # your-user 사용자에게 권한주기
```

사용자가 로그인 중이라면 다시 로그인 후 권한이 적용됩니다.

## docker 실습

### 버전확인

```
docker version #도커 버전 확인
```

> 버전정보가 클라이언트와 서버로 나뉘어져 있습니다. 도커는 하나의 실행파일이지만 실제로 클라이언트와 서버역할을 각각 할 수 있습니다. 도커 커맨드를 입력하면($docker run xxx) 도커 클라이언트가 도커 서버로 명령을 전송하고 결과를 받아 터미널에 출력해 줍니다.
>
> 기본값이 도커 서버의 소켓을 바라보고 있기 때문에 사용자는 의식하지 않고 마치 바로 명령을 내리는 것 같은 느낌을 받습니다. 이러한 설계가 mac이나 windows의 터미널에서 명령어를 입력했을때 가상 서버에 설치된 도커가 동작하는 이유입니다.

### 우분투, redis

```
docker run --rm -it ubuntu:16.04 /bin/bash #rum을 하면 없다면 깔리고, 우분투 bash에 -it조건으로 현재쓰고있는 터미널이 우분투 터미널과 연결됨, --rm은 프로세스 종료하면  컨터이너 자동제거
$ cat /etc/issue #우분투 내부에서 하면 버전 알수있음

#docker run -d -p 1234:6379 redis #이는 redis이미지를 실행하는데, -d백그라운드에서 실행하며, -p는 포트연결로 localhost1234로 접속시 포트 포워딩으로 컨테이너의 6379포트로 연결
```

### MySQL

\-e옵션을 통해 환경변수를 설정하고 --name옵션으로 컨테이너ID값대신 쉬운 이름을 부여해보겠다.

[MySQL Docker hub](https://hub.docker.com/_/mysql/) (MySQL에 -e 옵션은 다양하다. 참고해보자)

```
docker run -d -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=true --name mysql mysql:5.7 #참고로 root계정에 패스워드 없이 만드는 환경변수옵션true임

docker exec -it mysql bash #mysql깔린컨테이너로 접속
$ mysql -h127.0.0.1 -uroot #mysql에 root계정으로 접근
mysql> show databases;
mysql> quit
```

# Docker 컨테이너 업데이트 및 데이터 볼륨

도커에서 컨테이너를 업데이트 하려면 새 버전의 이미지를 다운(`pull`)받고 기존 컨테이너를 삭제(`stop`, `rm`) 한 후 새 이미지를 기반으로 새 컨테이너를 실행(`run`)하면 됩니다.

 컨테이너 삭제시 유지해야하는 데이터는 반드시 컨테이너 내부가 아닌 외부 스토리지에 저장해야 합니다. 가장 좋은 방법은 [AWS S3](http://docs.aws.amazon.com/ko_kr/AmazonS3/latest/dev/Welcome.html)같은 클라우드 서비스를 이용하는 것이고 그렇지 않으면 데이터 볼륨Data volumes을 컨테이너에 추가해서 사용해야 합니다. 데이터 볼륨을 사용하면 해당 디렉토리는 컨테이너와 별도로 저장되고 컨테이너를 삭제해도 데이터가 지워지지 않습니다.

데이터 볼륨을 사용하는 방법은 몇가지가 있는데 여기서는 호스트의 디렉토리를 마운트해서 사용하는 방법에 대해 알아봅니다. `run`명령어에서 소개한 옵션중에 `-v` 옵션을 드디어 사용해 보겠습니다. MySQL이라면 `/var/lib/mysql`디렉토리에 모든 데이터베이스 정보가 담기므로 호스트의 특정 디렉토리를 연결해주면 됩니다.

```
# before
docker run -d -p 3306:3306 \
  -e MYSQL_ALLOW_EMPTY_PASSWORD=true \
  --name mysql \
  mysql:5.7

# after
docker run -d -p 3306:3306 \
  -e MYSQL_ALLOW_EMPTY_PASSWORD=true \
  --name mysql \
  -v /my/own/datadir:/var/lib/mysql \ # <- volume mount
  mysql:5.7
```

위 샘플은 호스트의 `/my/own/datadir`디렉토리를 컨테이너의 `/var/lib/mysql`디렉토리로 마운트 하였습니다. 이제 데이터베이스 파일은 호스트의 `/my/own/datadir`디렉토리에 저장되고 컨테이너를 삭제해도 데이터는 사라지지 않습니다. 최신버전의 MySQL 이미지를 다운받고 다시 컨테이너를 실행할 때 동일한 디렉토리를 마운트 한다면 그대로 데이터를 사용할 수 있습니다. ~~만세!~~

# Docker Compose

[자세히](http://raccoonyy.github.io/docker-usages-for-dev-environment-setup/)

지금까지 도커를 커맨드라인에서 명령어로 작업했습니다. 지금은 간단한 작업만 했기 때문에 명령이 길지 않지만 컨테이너 조합이 많아지고 여러가지 설정이 추가되면 명령어가 금방 복잡해집니다.

도커는 복잡한 설정을 쉽게 관리하기 위해 [YAML](https://en.wikipedia.org/wiki/YAML)방식의 설정파일을 이용한 [Docker Compose](https://docs.docker.com/compose/)라는 툴을 제공합니다. 깊게 파고들면 은근 기능이 많고 복잡한데 이번에는 아주 가볍게 다루고 지나가도록 하겠습니다.

## 설치하기

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# test
docker-compose version
```

## 실습

기존에 명령어로 만들었던 wordpress를 compose를 이용해 만들어 보겠습니다.

먼저 빈 디렉토리를 하나 만들고 `docker-compose.yml`파일을 만들어 설정을 입력합니다.

```

version: '2'

services:
   db:
     image: mysql:5.7
     volumes:
       - db_data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: wordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     volumes:
       - wp_data:/var/www/html
     ports:
       - "8000:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_PASSWORD: wordpress
volumes:
    db_data:
    wp_data:
```

```
docker-compose up #실행
```

