---
title: DockerFile,Docker-compose,Deploy
date: 2020-07-21 12:31:13
categories: [Docker]
tags: [Docker, Django, DRF]
---

[자세히](https://blog.cloud66.com/how-to-get-code-into-a-docker-container/)

# 왜?

도커는 이미지와 컨테이너로 굉장히 많은 일을 기록하여 다음에는 단순화 할수있다.

특히 이미지를 가져와 내가 원하는 구성을 안에 넣고 필요한 명령어(`pip install -r requirements.txt`,`python manage.py makemigrations`,`python manage.py migrate`,`python manage.py runserver`까지 실행을 하도록 기록해놓고 이를 이미지로 생성한다. 

그럼다음부터는 해당 이미지만 실행하면 모든것이 기록한대로 동작한 결과가 컨테이너로 동작한다.

그렇다면 이 위에 이미지들을 다양하게 써서 전체 그림을 구성하여 모두를 각각의 컨테이너로 만들어주는 것도 있다.(한번의 명령으로DB, django를 각 컨테이너로 구성하여 연결하여 바로 서비스가 가능하도록!)

\+ 배포,관리에 있어서는 컨테이너가 격리되었다는 사실을 인지해야한다.

현재 컨테이너에 업데이트, 배포 관리하려고 여러가지 방법을 찾던 중 개발서버에서 유용한 volume으로 컨테이너에 외부폴더를 마운트 할수있다는 것을 알았다. 즉 git에 해당하는 파일들을 push, pull하면서 컨테이너에 반영할수있도록 하였다.

하지만 위와 같은방법은 코드 버전을 표시할수없으므로

프로덕션 환경에서는 공유 볼륨을 사용하는 것이 아닌 Docker 이미지 내에 발생시켜야 맞다.

# Docker -v

```
docker run -d -P --name <name of your container> -v /path/to/local/directory:/path/to/container/directory <image name>
```

만약에 `python manage.py runserver` 와 같은 명령에서 manage.py 파일이 -v가 되어지는 로컬쪽에 있다해도 run을 수행하며 마운트가 먼저일어나고  이미지가 실행되기때문에  이미지안에 `python manage.py `runserver  는 로컬의 파일로 정상수행된다.

-v의 기본은 읽기/쓰기 모두 가능하다.





#  docker-compose

[실습](https://docker-compose.tistory.com/1)

[실습2](https://docker-compose.tistory.com/1)

