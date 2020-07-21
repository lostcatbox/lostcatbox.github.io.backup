---
title: DockerFile,Docker-compose,Deploy
date: 2020-07-21 12:31:13
categories: [Docker]
tags: [Docker, Django, DRF]
---

[자세히](https://blog.cloud66.com/how-to-get-code-into-a-docker-container/)

[자세히](https://siner308.github.io/2019/02/25/django-docker-custom-image/)

[자세히](https://www.slideshare.net/raccoonyy/django-164557454)

# 왜? (작성중)

도커는 이미지와 컨테이너로 굉장히 많은 일을 기록하여 다음에는 단순화 할수있다.

특히 이미지를 가져와 내가 원하는 구성을 안에 넣고 필요한 명령어(`pip install -r requirements.txt`,`python manage.py makemigrations`,`python manage.py migrate`,`python manage.py runserver`까지 실행을 하도록 기록해놓고 이를 이미지로 생성한다. 

그럼다음부터는 해당 이미지만 실행하면 모든것이 기록한대로 동작한 결과가 컨테이너로 동작한다.

그렇다면 이 위에 이미지들을 다양하게 써서 전체 그림을 구성하여 모두를 각각의 컨테이너로 만들어주는 것도 있다.(한번의 명령으로DB, django를 각 컨테이너로 구성하여 연결하여 바로 서비스가 가능하도록!)

\+ 배포,관리에 있어서는 컨테이너가 격리되었다는 사실을 인지해야한다.

현재 컨테이너에 업데이트, 배포 관리하려고 여러가지 방법을 찾던 중 개발서버에서 유용한 volume으로 컨테이너에 외부폴더를 마운트 할수있다는 것을 알았다. 즉 git에 해당하는 파일들을 push, pull하면서 컨테이너에 반영할수있도록 하였다.

하지만 위와 같은방법은 코드 버전을 표시할수없으므로

프로덕션 환경에서는 공유 볼륨을 사용하는 것이 아닌 Docker 이미지 내에 발생시켜야 맞다.

# Dockerfiles

서버에서 준비해야할 모든 작업을 나열한 파일

```
FROM python:3.6

COPY . /app  # 나의 Django 코드를 컨테이너에 복사합니다.
RUN pip install -r /app/requirements.txt  # requirements.txt에 적혀있는 pip 패키지들을 설치합니다.
RUN chmod +x /app/start  # start 파일을 실행 가능권한변경
WORKDIR /app  # 워킹디렉토리를 /app으로 합니다.
EXPOSE 8000  # 8000번 포트를 expose합니다.

ENTRYPOINT ["/app/start"]  # /app/start 파일을 실행시킵니다.
```

`ENTRYPOINT`는 Dockerfile 하나에 `한번밖에` 호출할 수 없는데, 파일을 사용함으로써 여러 명령어를 한번에 실행시킬 수 있게 합니다.(아래는 start파일내용)

위와 같이 명령 스크립트를 따로 둘경우 수정이 필요할때 Dockerfiles파일을 건드리지 않아도 수정가능해서 편해진다

```
#!/bin/bash   #shebang 반드시 필요.유닉스 계열 운영 체제에서 셔뱅이 있는 스크립트는 프로그램으로서 실행

python manage.py makemigrations
python manage.py migrate

python manage.py runserver 0.0.0.0:8000 #반드시 0.0.0.0
```

> 0.0.0.0인 이유는 컨테이너 외부 요청을 듣기위해서다
>
> 127.0.0.1 이면 컨테이너 내부요청만 받겠다는 의미이므로 컨테이너 외부의 요청은 듣지않는다.
>
> [자세히](https://stackoverflow.com/questions/59179831/docker-app-server-ip-address-127-0-0-1-difference-of-0-0-0-0-ip)

## __주의하기__

> docker-compose.yml를 사용할때는 dockerfiles에서 마지막CDM `python manage.py runserver` 부분은 docker-compose.yml의 command부분으로 빼자. 
>
> 이유는 docker-compose에서 volumes: - .:/app 을 해놨는데 이는 
>
> dockerfiles의 CMD runserver 다음에 일어남으로 오류가 나타났다.
>
> 따라서 마운트된후 runserver가 일어나야하므로 docker-compose.yml 에서 command: `python manage.py runserver` 해주자
>
> > 참고 Dockerfile의 cmd,entrypoint와 거의 같습니다. 하지만 Dockerfile의 entrypoint보다 docker-compose의 entrypoint가 우선 순위가 높습니다. (나는 compose에 entrypoint가없어서 일어난 문제)

```
#dockerfile
FROM python:3.7.6

COPY . /app
RUN pip install -r /app/requirements.txt
WORKDIR /app

EXPOSE 8000
```

```
#docker-compose.yml
version: '3'

services:
        drf:
                build: .
                command: python manage.py runserver 0.0.0.0:8000
                ports:
                        - "8000:8000"
                volumes:
                        - .:/app
```



# Docker -v

DB컨테이너가 없어져도 DB의 정보는 살아있어야하므로 volume을 반드시이용하자.

```
docker run -d -P --name <name of your container> -v /path/to/local/directory:/path/to/container/directory <image name>
```

만약에 `python manage.py runserver` 와 같은 명령에서 manage.py 파일이 -v가 되어지는 로컬쪽에 있다해도 run을 수행하며 마운트가 먼저일어나고  이미지가 실행되기때문에  이미지안에 `python manage.py `runserver  는 로컬의 파일로 정상수행된다.

\-v의 기본은 읽기/쓰기 모두 가능하다.





#  docker-compose

[실습](https://docker-compose.tistory.com/1)

[실습2](https://docker-compose.tistory.com/1)

[실습3](https://www.daleseo.com/docker-compose-django/)

