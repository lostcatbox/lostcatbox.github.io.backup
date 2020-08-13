---
title: nginx-proxy
date: 2020-08-12 11:11:53
categories: [Network]
tags: [Nginx, Network, Proxy]
---

[nginx-proxy, ssl자동갱신까지 라이브러리](https://github.com/nginx-proxy/docker-letsencrypt-nginx-proxy-companion)

[nginx기초부터하고싶다면](https://velog.io/@minholee_93/Nginx-Overview-Install)

[프록시 구성](https://velog.io/@jeff0720/2018-11-18-2111-%EC%9E%91%EC%84%B1%EB%90%A8-iojomvsf0n)

[nginx공식문서](http://nginx.org/en/docs/http/ngx_http_upstream_module.html)

# 왜?

채팅앱을 만들다가 https에서는 `ws://<ip>` 를 사용하지 못하고 `wss://<ip>` 를 통해 websocket요청을 해야하는 것을 알았다.

즉, ssl인증서가 필요했고, https로 통신이 가능해야하였다. 하지만 지금까지 내 서버는 포트포워딩으로 http로만 통신을 하는 앱을 만들었기때문에 문제가되었다. 또한 포트포워드의 한계는 요청하는 곳에서도 포트를 지정해줘야하는데 cloudflare곳에서는 ip에 도메인을 등록하는 방법이였다. 따라서 내 서버의 1개의 ip주소로는 웹서비스 1개만 제공이 가능하게되었다.

ip주소는 1개인데 어떻게 다양한 서비스를 한 서버에서 제공할수있을까? 고민하던중 nignx로 reverse-proxy를 도메인 기준으로하면 같은 ip주소로 요청을 보내더라도 요청한 도메인이 서로 다르기에 그것을 기준으로 해당 서비스를 연결해줄수있었다.

# Nginx로 프록시서버 만들기

## Nginx의 디렉터리 의미를 간단하게 알아봅시다.

- /etc/nginx: 해당 디렉터리는 Nginx를 설정하는 디렉터리입니다.모든 설정을 이 디렉터리 안에서 합니다.
- /etc/nginx/nginx.conf: Ngnix의 메인 설정 파일로 Nginx의 글로벌 설정을 수정 할 수 있습니다.
- /etc/nginx/sites-available: 해당 디렉터리에서 프록시 설정 및 어떻게 요청을 처리해야 할지에 대해 설정 할 수 있습니다.
- /etc/nginx/sites-enabled: 해당 디렉터리는 sites-available 디렉터리에서 연결된 파일들이 존재하는 곳 입니다.이 곳에 디렉터리와 연결이 되어 있어야 nginx가 프록시 설정을 적용합니다.
- /etc/nginx/snippets: sites-available 디렉터리에 있는 파일들에 공통적으로 포함될 수 있는 설정들을 정의할 수 있는 디렉터리 입니다.

## 연습

디렉토리 및 파일 구성은 다음과 같다

![스크린샷 2020-08-13 오후 5.14.22](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghp96u7sa3j30vo0kadk4.jpg)

실험으로 docker-compose.yml로 한번에 만드는 것이지, 결국에는 reverse-proxy역할하는 nginx는 따로 두고 관리하는게 편할것이다. 외부에서볼떄 가장 프론트의 nginx가 모든 요청을 받고 포트, 도메인, ip를 기준으로 포워딩할수있다.

### Dockerfile

```
# cbv_prac/Dockerfile
FROM python:3.7.6
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip install pip --upgrade
RUN pip install -r requirements.txt
COPY . /code/
```

내가 구성한 Dockerfile을 기준으로 이미지를 생성해 docker-compose에 반영할것이다.

### docker-compose.yml

```
# docker-compose.yml

version: '3' #docker-compose버전을 나타냄
services:
  proxy: #서비스 이름
    image: nginx:latest #기준 이미지
    ports: #docker 호스트에 개방할 포트
      - "80:80" 
    volumes:
      - ./proxy/nginx.conf:/etc/nginx/nginx.conf
  web:
    build: ./cbv_prac #Dockerfile의 경로 
    command: python manage.py runserver 0.0.0.0:8080
    expose: #같은 내부망에서는 expose해주면됨.  즉, web:8080하면접근가능
      - "8080"
    volumes: #외부와 마운트
      - ./cbv_prac:/code
```

> Dockerfile를 사용할때  __build__임을 주의하자

### reverse-proxy 서버의 nginx의 nginx.conf

```
# proxy/nginx.conf

user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    upstream docker-nginx {
        server web:8080;
    }
    server {
        listen 80;
        server_name 192.168.88.244;
        location / {
            proxy_pass         http://docker-nginx;
            proxy_redirect     off;
            proxy_set_header   Host $host;
            proxy_set_header   X-Real-IP $remote_addr;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    keepalive_timeout  65;
    include /etc/nginx/conf.d/*.conf;
}
```

#### nginx upstream

upstream은 [proxy_pass](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) , [fastcgi_pass](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass) , [uwsgi_pass](http://nginx.org/en/docs/http/ngx_http_uwsgi_module.html#uwsgi_pass) , [scgi_pass](http://nginx.org/en/docs/http/ngx_http_scgi_module.html#scgi_pass) , [memcached_pass](http://nginx.org/en/docs/http/ngx_http_memcached_module.html#memcached_pass) 및 [grpc_pass](http://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_pass)의 지시자에 대해서 참조할 수 있는 서버 그룹을 정의 하는데 사용합니다. 

(그리고 nginx가 받았던 리퀘스트를 해당 서버에 넘김)

```
    upstream docker-nginx {
        server web:8080;
    }
```

web은  docker-compose.yml에서 정의한 웹서버 이름이다. 

#### server

```
    server {
        listen 80;
        server_name 192.168.88.244;
        location / {
            proxy_pass         http://docker-nginx;
            proxy_redirect     off;
            proxy_set_header   Host $host;
            proxy_set_header   X-Real-IP $remote_addr;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        }
```

이는 reverse proxy 서버는 80번 포트를 listen하고 server_name은 192.168.88.244로 지정했다.

__이를 도메인으로 지정할  경우 포트는 같지만 도메인기준으로 proxy_pass도 가능해진다__

proxy\_pass설정을 보면 `/ `로 들어올경우 위에서 정의한 upstream docker-nginx(web이라는이름을 가진 container의 8080포트)로  proxy한다.

