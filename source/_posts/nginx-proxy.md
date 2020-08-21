---
title: Nginx로 Reverse-proxy 서버 구성 +SSL인증서 (Docker로 구성)
date: 2020-08-12 11:11:53
categories: [Network]
tags: [Nginx, Network, Proxy, Ssl, Docker]
---

[nginx-proxy, ssl자동갱신까지 라이브러리](https://github.com/nginx-proxy/docker-letsencrypt-nginx-proxy-companion)

[nginx기초부터하고싶다면](https://velog.io/@minholee_93/Nginx-Overview-Install)

[프록시 구성](https://velog.io/@jeff0720/2018-11-18-2111-%EC%9E%91%EC%84%B1%EB%90%A8-iojomvsf0n)

[nginx공식문서](http://nginx.org/en/docs/http/ngx_http_upstream_module.html)

[upstream](https://opentutorials.org/module/384/4328)

[웹소캣 wss로 nginx에 물리기](https://stackoverflow.com/questions/12102110/nginx-to-reverse-proxy-websockets-and-enable-ssl-wss)

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
- /etc/nginx/con.d : 해당 디렉터리는 nginx\-enabled와 마찬가지다.

> nginx의 잡지식
>
> nginx\-available디렉토리의 파일들은  자동으로 nginx\-enabled에 추가되며 이것을nginx\-enabled에서 삭제하면 disable과 able을 구별할수있도록된다.
>
> conf.d 디렉토리의 파일들은 nginx\-enabled와 마찬가지다. 하지만 disable로 만들라면 con.d에서 삭제하거나 이동해야해야한다는 단점이있다.
>
> 즉 구조적측면이 아니라면 그냥 conf.d 디렉토리 쓰자
>
> ```
> #nginx.conf  파일에서 아래와 같이 활용하면된다.
> 
> http {
>     include /etc/nginx/conf.d/*.conf;
>     include /etc/nginx/sites-enabled/*.conf;
>     include /etc/nginx/sites-enabled/my_own_conf;
> ...
> }
> ```
>
> 

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

# Nginx reverse proxy에 SSL 적용하기

[도커+Let's Encrypt](https://medium.com/@pentacent/nginx-and-lets-encrypt-with-docker-in-less-than-5-minutes-b4b8a60d3a71)

아래는 최종 nginx reverse proxy구성 tree이다

![스크린샷 2020-08-20 오후 8.15.39](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghxhquo285j30qm0g8dgv.jpg)

## 구성

### docker-compose.yml

certbot과 nginx를 모두 컨테이너로 올려서 자동 ssl 인증서 연장까지 구현할 것이므로 docker-compose.yml은 다음과같다

```
# docker-compose.yml

version: '3'
services:
  nginx:
    image: nginx:1.18-alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./data/nginx.conf:/etc/nginx/nginx.conf
      - ./data/nginx:/etc/nginx/conf.d
      - ./data/certbot/conf:/etc/letsencrypt
      - ./data/certbot/www:/var/www/certbot
    command: "/bin/sh -c 'while :; do sleep 6h & wait $${!}; nginx -s reload; done & nginx -g \"daemon off;\"'"

  certbot:
    image: certbot/certbot
    volumes:
      - ./data/certbot/conf:/etc/letsencrypt
      - ./data/certbot/www:/var/www/certbot
    entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"
```

-  services>nginx>volumes와 services> certbox>volumes에서 `./data/certbot/conf:/etc/letsencrypt`, `./data/certbot/www:/var/www/certbot` 를 보면 certbot의 인증서 발급에  관해서 nginx컨테이너와 certbot컨테이너가 동시에 마운트되어있다.

### nginx.conf

nginx.conf파일은 추후에 프록시 서버, 로드밸런서를 설정할 때 중요하므로 volume해놓았다.

```
# nginx.conf
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

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    keepalive_timeout  65;
    include /etc/nginx/conf.d/*.conf;
}
```

### app.conf

내 채팅앱에 대해 리버스 프록시는 다음과 같은 구성이 되어있다.

```
# app.conf

server {
    listen 80;
    server_name chatting.lostcatbox.com;
    location / {
        return 301 https://$host$request_uri;
    }
    location /.well-known/acme-challenge/ {
         root /var/www/certbot;
    }
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}

upstream chatting-html {
        server htmldeploy;
}

server {
    listen 443 ssl;
    server_name chatting.lostcatbox.com;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    proxy_connect_timeout 1d;
    proxy_send_timeout 1d;
    proxy_read_timeout 1d;

    location / {
        proxy_pass http://chatting-html/; #for demo purposes
        proxy_redirect     off;
    }
    location /websocket/ {
        proxy_pass http://172.29.0.6:7777/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    ssl_certificate /etc/letsencrypt/live/chatting.lostcatbox.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/chatting.lostcatbox.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}

```

- 아래는 certbot이 ssl을 발급할때 위의 해당주소/.well-known/acme-challenge/ 를 통해 인증하므로 반드시 필요하다.(???)

  ```
  location /.well-known/acme-challenge/ {
       root /var/www/certbot;
  ```

- nginx에서 HTTPS프로토콜에 이용될 ssl인증서 경로

  ```
  ssl_certificate /etc/letsencrypt/live/chatting.lostcatbox.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/chatting.lostcatbox.com/privkey.pem;
  ```

  

- Let’s also add them to our config file. This will score you a straight A in the [SSL Labs test](https://www.ssllabs.com/index.html)! (???)

  ```
  include /etc/letsencrypt/options-ssl-nginx.conf;
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
  ```

### init-letsencrypt.sh

앞서 과정만 진행을 하고 `docker-compose up`을 실행한다면 실패한다. 왜냐하면 nginx에 ssl인증서가 발급되어있지않으므로 파일이 존재하지않기때문이다. 

즉, create dummy certificate>start nginx, delete dummy and request the real certificates 과정을 거쳐야한다.

아래는 init-letsencrypt.sh 내용이다. 

__반드시 domains, email, data_path란에 해당 서비스로 수정해야한다.__

권한부여 후  `chmod +x init-letsencrypt.sh`

실행하자  `sudo ./init-letsencrypt.sh`

```
#!/bin/bash

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

domains=(example.org www.example.org)
rsa_key_size=4096
data_path="./data/certbot"
email="" # Adding a valid address is strongly recommended
staging=0 # Set to 1 if you're testing your setup to avoid hitting request limits

if [ -d "$data_path" ]; then
  read -p "Existing data found for $domains. Continue and replace existing certificate? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    exit
  fi
fi


if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$data_path/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$data_path/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$data_path/conf/ssl-dhparams.pem"
  echo
fi

echo "### Creating dummy certificate for $domains ..."
path="/etc/letsencrypt/live/$domains"
mkdir -p "$data_path/conf/live/$domains"
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '$path/privkey.pem' \
    -out '$path/fullchain.pem' \
    -subj '/CN=localhost'" certbot
echo


echo "### Starting nginx ..."
docker-compose up --force-recreate -d nginx
echo

echo "### Deleting dummy certificate for $domains ..."
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/$domains && \
  rm -Rf /etc/letsencrypt/archive/$domains && \
  rm -Rf /etc/letsencrypt/renewal/$domains.conf" certbot
echo


echo "### Requesting Let's Encrypt certificate for $domains ..."
#Join $domains to -d args
domain_args=""
for domain in "${domains[@]}"; do
  domain_args="$domain_args -d $domain"
done

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
if [ $staging != "0" ]; then staging_arg="--staging"; fi

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal" certbot
echo

echo "### Reloading nginx ..."
docker-compose exec nginx nginx -s reload

```

### 자동으로 인증서 재발급

`docker-compose.yml`파일에서 certbot 아래를 추가해주자(12시간마다 재발급)

```
entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"
```

`docker-compose.yml`파일에서 nginx 아래를 추가해주자(6시간마다 nginx reload)

```
command: "/bin/sh -c 'while :; do sleep 6h & wait $${!}; nginx -s reload; done & nginx -g \"daemon off;\"'"
```



## 네트워크 구성

네트워크는 `docker-compose up`을 통해 `proxy_default` 가 자동으로 생성될것이다. 

따라서 reverse-proxy를 원하는 컨테이너를 `proxy_default`망에 추가하고  쓸때는 해당 `컨테이너이름:[포트]`로 nginx의 conf파일에 지정해주면 외부컨테이너와 연결가능하다.

예시) `docker run -d --expose 7777 --name chattingserver chatting server:v5`


# Nginx websocket wss:// 적용하기

https에서는 wss가 필수이므로 반드시 ssl적용이 필요했다.

upstream부터 `server { }를` 따로 설정해줄수있지만 1.1.3버전부터 nginx에서는 이미 websocket에 대해 따로 지원을 해준다. 

```
upstream pythonchattingserver {
        server chattingserver:7777;
}

server {   
    ##아래와 같은 양식으로 추가
    location /websocket/ {
        proxy_pass http://pythonchattingserver/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
    }
}
```

```javascript
// js로 요청하는 방법
var webSocket = new WebSocket("wss://chatting.lostcatbox.com/websocket/");
```

# 오류

## nginx에서 소캣을 자동 삭제

Nginx의 기본 Keepalive 구성으로 인해 75 초 (또는 그 정도)마다 웹 소켓 연결을 삭제하는 것 같습니다.

### 해결

프록시 연결을 1일로 유지함.

```
proxy_connect_timeout 1d;
proxy_send_timeout 1d;
proxy_read_timeout 1d;
```



