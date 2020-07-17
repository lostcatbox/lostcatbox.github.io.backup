---
title: nginx,DRF로 웹서비스 배포
date: 2020-07-17 15:23:46
categories: [Server]
tags: [Nginx,Wsgi,Network, Server, DRF]
---

> nginx의 설정에 대해 자세히 보고싶으시다면 
>
> nginx에 해당하는 포스팅을 참고해주세요

[자세히](https://brownbears.tistory.com/16)

[자세히2](https://twpower.github.io/41-connect-nginx-uwsgi-django)

[pyenv](https://twpower.github.io/38-install-pyenv-and-virtualenv-on-ubuntu) (가상환경구성가능, 파이썬버전에 따라 가상환경 구성가능!)

# 왜?

서버를 구성하고 웹서버환경을 구축하려면 nginx가 필요하다. 이를 DRF와 연결까지하여 실제로 JSON을 주고 받아보자

# 웹서버 구조

![스크린샷 2020-07-17 오후 5.48.19](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggu2fr84f3j30yy0bq79u.jpg)

# Nginx

## Nginx 설치

nginx를 설치하는 방법에는 apt-get을 통한 방식과 직접 소스코드를 내려받아서 컴파일하는 2가지 방식이 있습니다. 더 편하고 빠른 방식은 package를 통한 방식이라 apt-get을 이용해서 설치하겠습니다.

> - `Apache` : 요청마다 스레드 혹은 프로세스 생성 및 처리
> - `Nginx` : 요청마다 비동기 이벤트를 발생시켜 처리

```
$ sudo apt-get install nginx #
$ nginx -v #버전 확인
$ sudo service nginx start #시작
$ sudo service nginx restart #재시작
$ sudo service nginx stop #중지
$ sudo service nginx status #상태
$ sudo service nginx reload #리로드
```

## Nginx의 간단한 파일구성

### 설정 파일들 경로

nginx 설치 방법에는 2가지 방법이 있다고 했다. 각 설치법에 따라서 환경설정 파일의 위치가 다르다.

- package(apt-get을 통한 설치)의 경우 : /etc/nginx에 위치
- 직접 compile한 경우 : /usr/local/nginx/conf, /usr/local/etc/nginx

### 설정 파일들

- `nginx.conf` : nginx와 그 모듈들이 작동하는 방식에 대한 설정 파일입니다. `sites-enabled`안에 각각 서버에 대한 conf파일들을 만들고 이 안에 첨부하여 웹서버를 운영할 수 있습니다. conf 파일안을 보시면 `http`, `server`, `location`, `upstream`과 같이 나누어져 있는데 이를 블록이라 하며 `server`는 가상 서버 혹은 일반 서버를 호스팅 할 때 사용되며 `location`의 경우 특정 폴더 밑 파일에 대한 경로를 지정해주고 `upstream`의 경우 Reverse Proxy 설정을 위해서 사용됩니다.
- `sites-enabled` : 위에서 말한 nginx.conf에 첨부해서 실제로 서버를 운영할 설정 파일들이 들어있는 폴더입니다. 실제로 코드를 보면 nginx.conf에서 여기 폴더에 있는 모든 파일들을 불러옵니다.
- `fastcgi_params`, `scgi_params`, `uwsgi_params` : uwsgi와 같이 웹 서버와 애플리케이션 서버 사이에서 인터페이스 역할을 해줄 때 필요한 파일들입니다.

## 접속확인

Welcome to nginx”가 나와야합니다.

Web Client <-> Web Server(Nginx) 구조이다

# pyenv

## 필요한 패키지들 설치

[Common build problems](https://github.com/pyenv/pyenv/wiki/Common-build-problems)를 참고하면 Build 관련해서 문제가 생길 때 설치해야 할 패키지와 어떻게 pyenv version package를 지우고 재설치해야 하는지가 나와있습니다. 이 때 나온 패키지들을 미리 설치해주면 나중에 생길 문제를 미리 방지 할 수 있겠죠? :)

```
$ sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git libedit-dev python
```

## pyenv 설치

git에서 `~/` 폴더안에 `.pyenv`이름으로 직접 clone을 합니다.

```
$ git clone https://github.com/pyenv/pyenv.git ~/.pyenv
```

추가를 마치고 환경변수까지 추가합니다.

```
$ echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
$ echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
$ echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
$ source ~/.bash_profile
```

환경 변수를 추가하고나서 pyenv를 찾을 수 없다고 하여 컴퓨터를 reboot하였습니다.

만약 이렇게 reboot을 했음에도 진행이 되지 않는다면 다음 링크를 참고한다.(https://github.com/pyenv/pyenv/wiki/Common-build-problems)

## pyenv-update 설치

pyenv를 업데이트 해줄 수 있도록 다음 아래 명령어를 통해 pyenv-update를 설치합니다.

```
$ git clone git://github.com/pyenv/pyenv-update.git ~/.pyenv/plugins/pyenv-update
```

업데이트를 합니다.

```
$ pyenv update
```

## 설치 가능한 python version들 확인

설치 가능한 python version들을 확인하고 설치합니다.

```
pyenv install --list
```

## 필요한 python version 설치

저는 3.6.2를 설치하였습니다. pyenv에 설치된 python version들은 `pyenv versions`를 통해서 확인 가능합니다.

```
$ pyenv install 3.6.2
```

## pyenv-virtualenv 설치

git에서 `~/.pyenv/plugins/` 폴더안에 `pyenv-virtualenvwrapper`이름으로 직접 clone을 합니다.

```
$ git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
```

추가를 마치고 환경변수까지 추가합니다.

```
$ echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile
$ source ~/.bash_profile
```

똑같이 환경변수를 추가하고 로드하였는데도 안되면 다시 shell을 껐다가 켭니다.

## 가상환경 생성

이전에 포스팅한 [[Mac\] Mac에서 pyenv, virtualenv 그리고 autoenv 사용하기](https://twpower.github.io/27-pyenv-virtualenv-autoenv-in-mac)에 나와있는 것과 사용법은 똑같습니다.

사용법

```
$ pyenv virtualenv [python version] [virtual environment name]
```

예시

```
$ pyenv virtualenv 3.6.2 LinkU
```

## 가상환경 사용

이 부분도 포스팅한 [[Mac\] Mac에서 pyenv, virtualenv 그리고 autoenv 사용하기](https://twpower.github.io/27-pyenv-virtualenv-autoenv-in-mac)에 나와있는 것과 사용법은 똑같습니다.

```
$ pyenv activate [virtual environment name]
(virtual environment name)$ pyenv deactivate
```

# Nginx uWSGI DRF 연결

## [선택] pyenv와 virtualenv를 통해서 가상환경 설정하기

우선 uWSGI를 pip를 통해서 전체에서 설정을 해도 되지만 가상환경을 직접 설정해서 설치하고 돌려보겠습니다 우선 만드시려는 python 환경 프로젝트를 virtualenv를 통해서 생성해줍니다.

관련 생성은 위에 있는 링크를 타고 가시면 참고 하실 수 있으며 pyenv와 virtualenv가 설칭되어있다고 가정할 때 간단한 예시는 아래와 같습니다.

```
$ pyenv virtualenv [python version] [project virtualenv name]
```

프로젝트 가상환경의 이름이 `LinkU`이고 python version이 `3.5.2`일 때는 아래와 같습니다.

```
$ pyenv virtualenv 3.5.2 LinkU
```

가상환경 실행

```
pyenv activate LinkU #LinkU에는 설정하신 가상환경 이름들어가면됨
```

## 프로젝트 환경에 uWSGI 설치하기

uWSGI는 pip를 통해서 설치가 가능합니다.

```
(LinkU)$ pip install uwsgi
```

## uWSGI를 통해서 Django 서버 돌리기

사용했던 `python manage.py runserver` 대신에 `uWSGI`명령어를 통해서 실행 해보도록 하겠습니다. 생성한 Django 프로젝트로 이동해서 `manage.py` 있는곳으로 가줍니다.

다음 아래와 같은 방식을

```
(LinkU)$ python manage.py runserver
```

다음처럼 할 수 있습니다. linku.wsgi는 wsgi.py를 포함하고 있는 폴더명으로 해주시면 됩니다.

```
# linku.wsgi는 wsgi.py를 포함하고 있는 폴더명으로 해주시면 됩니다.
(LinkU)$ uwsgi --http :8000 --module linku.wsgi
```

명령어에 대해 설명하면

- http는 http 통신을 하겠다는 의미이며 8000포트를 사용한다는 것입니다.
- http가 아닌 Nginx와 함께 UNIX Socket 방식을 사용하고 싶다면 `--socket :[port number]`의 형태로 이용하면 되며 아래에 더 자세한 예제가 나옵니다.
- module은 wsgi 모듈을 통해서 실행하겠다는 의미이며
- 단순하게 파일을 사용하려면 `--wsgi-file [app.py(python 실행 파일 이름)]`의 형태로도 사용가능합니다.

조금 더 추가적인 설명을 드리자면

- 외부에서 8000 포트로 들어온 http요청을 uWSGI가 받아서
- 그 요청을 처리하는 애플리케이션에(이 경우에는 Django 혹은 Django Rest Framework) 넘겨주고 처리를 해준 후에 응답을 해줍니다.
- 현재 구조 : web Client <-> uWSGI(port 8000) <-> Django

## Nginx에 upstream 설정해주기

이제 외부에서 특정포트로 Nginx를 통해 http 요청을 받았을 때 그 요청을 uWSGI를 통해서 Django로 넘겨 봅시다.

### 프로젝트 폴더에 uwsgi_params 추가

Nginx 설정 파일들 폴더(`/etc/nginx`)에 있는 `uwsgi_params`파일을 복사해서 `manage.py`가 있는 프로젝트 폴더에 복사해 추가합니다.

package를 통해서 설치한 경우에는 다음과 같습니다.

```
$ cp /etc/nginx/uwsgi_params [Django project folder]
```

### nginx에서 사용 할 conf 파일 만들기

이제 nginx에서 사용할 설정 파일을 만들어서 `/etc/nginx/sites-available` 폴더에 추가해봅시다.

- `/etc/nginx/sites-available`로 이동해서 아래와 같이 파일을 생성해줍니다.

```
(LinkU) $ touch linku_backend_nginx.conf // 설정 파일의 이름은 자유입니다.
```

해당 파일을 vim 혹은 에디터를 통해서 아래처럼 설정해줍니다.

- 프로젝트 이름과 가상환경 사용할 port에 따라서 설정 파일이 다를수도 있습니다! (당연한 이야기)

*linku_backend_nginx.conf*

```
# linku_backend_nginx.conf

# upstream(proxy) 설정
upstream django{
    #1 uWSGI를 이용한 django 서버가 listening 할 ip주소와 port 번호를 적어주시면 됩니다. upstream에 다른 외부 서버를 연결할수도 있지만 여기서는 로컬에 있는 django에 보내니 주소가 127.0.0.1이고 포트는 8001로 설정하였습니다.
    server 127.0.0.1:8001;
}

# configuration of the server
server {
    #2 django가 아니라 외부에서 어떤 port를 listening 할지 정해줍니다.
    listen      [Port Number];
    #3 실행하는 서버의 IP주소 혹은 Domain을 적어주시면 됩니다.
    #4 이 server_name을 여러개 만들어서 subdomain도 각각 다르게 처리 가능합니다.
    server_name [IP Address];
    charset     utf-8;

    # max upload size
    client_max_body_size 75M;   # adjust to taste

    #5 Django media파일 경로
    location /media  {
        alias /home/linku/LinkU/linku_backend/media;
    }

    #6 Django static파일 경로
    location /static {
        alias /home/linku/LinkU/linku_backend/static;
    }

    #7 media와 static을 제외한 모든 요청을 upstream으로 보냅니다.
    location / {
        #8 uwsgi_pass [upstream name] (위에 upstream으로 설정한 block의 이름)
        uwsgi_pass  django;
        #9 uwsgi_params의 경로
        include /home/linku/LinkU/linku_backend/uwsgi_params;
    }
}
```

- []로 만들어 놓은 부분은 개인의 작성하시는 분에 따라서 직접 넣어주셔야 합니다.
- \#1 uWSGI를 이용한 django 서버가 listening 할 ip주소와 port 번호를 적어주시면 됩니다. upstream에 다른 외부 서버를 연결할수도 있지만 여기서는 로컬에 있는 django에 보내니 주소가 127.0.0.1이고 포트는 8001로 설정하였습니다.
- \#2 django가 아니라 외부에서 어떤 port를 listening 할지 정해줍니다.
- \#3 실행하는 서버의 IP주소 혹은 Domain을 적어주시면 됩니다.
- \#4 이 server_name을 여러개 만들어서 subdomain도 각각 다르게 처리 가능합니다.
- \#5 Django media파일 경로
- \#6 Django static파일 경로
- \#7 media와 static을 제외한 모든 요청을 upstream으로 보냅니다.
- \#8 uwsgi_pass [upstream name](https://twpower.github.io/위에 uptream으로 설정한 block의 이름)
- \#9 uwsgi_params의 경로

### nginx 설정파일들이 있는 폴더로 이동

[Ubuntu에서 apt-get을 통해 nginx 설치하기 및 간단한 정리](https://twpower.github.io/39-install-nginx-on-ubuntu-by-using-apt-get-and-brief-explanation)에 기록을 해두었지만 `sites-enabled`와 `nginx.conf`를 통해서 nginx의 설정이 가능합니다.

해당 폴더와 파일의 경로는 위 문서에 기록한 것처럼 `/etc/nginx`,`/usr/local/nginx/conf`, `/usr/local/etc/nginx`중에 하나에 위치합니다.

### sites-enabled에 conf파일에 대한 symlink 추가하기

symlink는 쉽게 생각해 바로가기와 같다고 보면 편합니다.(자동실행됨)

```
$ sudo ln -s /etc/nginx/sites-available/mysite_nginx.conf /etc/nginx/sites-enabled/
```

지금까지 진행한 linku_backend_nginx.conf에 대해서 symlink를 만드는 경우의 예시는 아래와 같습니다.

```
$ sudo ln -s /etc/nginx/sites-available/linku_backend_nginx.conf /etc/nginx/sites-enabled/
```

## Static file들 모으기

Django 프로젝트 폴더에 있는 `settings.py`에 아래와 같은 코드를 추가합니다. media에 관한 설정도 안되어 있다면 같이 해주도록 합시다.

*settings.py*

```
...
STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'static')

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
...
```

프로젝트 폴더에서 collectstatic 명령어을 통해서 static file들을 모아줍니다.

```
$ python manage.py collectstatic
```

## 설정파일 적용 및 테스트

#### nginx 재시작

```
# 다음 3가지 명령어 중에 하나만 하시면 됩니다.
$ sudo service nginx restart
$ sudo systemctl restart nginx
$ sudo /etc/init.d/nginx restart
```

아래와 같이 OK가 뜬다면 제대로 실행이 된것입니다.

#### uWSGI 실행

- 여기서 Port 번호는 위에 conf파일에 있는 upstream 블록의 Port 번호와 같아야합니다.

```
(LinkU)$ uwsgi --socket :8001 --module linku.wsgi
```



이제 도메인을 통해서 domain.com:port를 통해서 접속하면 `여기서의 Port는 위에 conf파일에 있는 server 블록에 있는 Port번호 입니다.` 장고에서 해당하는 응답을 보여줌을 확인 할 수 있습니다.

#### uWSGI가 실행이 되지 않는다면

nginx error log(/var/log/nginx/error.log)를 확인해서 아래와 같은 오류가 나온다면

```
connect() to unix:///path/to/your/mysite/mysite.sock failed (13: Permission denied)
```



다음 아래 두 명령어중에 하나를 시도해보시면 됩니다. 권한 떄문에 생기는 문제인데 nginx의 사용자 그룹에 현재 접속한 유저를 추가해주셔야 됩니다.

```
uwsgi --socket mysite.sock --wsgi-file test.py --chmod-socket=666 # (very permissive)
```

또는

```
wsgi --socket mysite.sock --wsgi-file test.py --chmod-socket=664 # (more sensible)
```

## 완료된 상황 및 구조

현재까지 완료된 상황을 보면 아래와 같습니다.

- Web Client <-> Nginx(Web Server) <-> uWSGI(port:8001) <-> Django(Application Server)