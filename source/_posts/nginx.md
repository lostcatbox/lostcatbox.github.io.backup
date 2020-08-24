---
title: Nginx 자세히
date: 2020-08-24 23:04:52
categories: [Network]
tags: [Nginx, Network, Proxy, Ssl, Docker]
---

[자세히](https://sarc.io/index.php/nginx/61-nginx-nginx-conf)

# 왜?

nginx를 통해 proxy로 사용하거나 다른 웹프레임워크와의 연결할때 nginx.conf 및 app.conf를 작성할 때 상당히 많은 기능들을 제공하고있으며, 필요한 기능은 정리하고 익숙해지고싶었다.

반드시 설정파일 작성을 적용하는 것을 까먹지 말자

`nginx -s reload`

> docker 환경이라면
>
> `docker container exec <container> nginx -s reload`

# 시작하기에 앞서

nginx의 conf파일들의 경로를 자세히 정리하겠다

- `/etc/nginx/nginx.conf` 에 존재하며 다음의 conf.d 디렉토리에 있는 `*.conf` 파일들을 http{ } 안에 서 include 한다.

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

- `/etc/nginx/conf.d` 안에 원하는 `.conf` 

  ```
  server {
      listen 80;
      server_name chatting.lostcatbox.com;
      location / {
          return 301 https://$host$request_uri;
      }
  }
  ```

- `/etc/nginx/conf.d` 안에는 `default.conf` 가 기본으로 제공되므로 80번포트로 들어오는것을 변경하거나 수정하고, 서비스하는것을 개발단계에서 localhost 80번 포트로 이뤄진다면 app.conf작성후 default.conf파일을 삭제하는것이 중요하다. ~~(원하는대로 안되서 이게 원인이였음)~~

  > 간단하게 html만 서비스를 하고싶다면 root 경로를 변경하거나 index.html을 대체해서 쓸수있다.

  

  ```
  server {
      listen       80;
      listen  [::]:80;
      server_name  localhost;
  
      #charset koi8-r;
      #access_log  /var/log/nginx/host.access.log  main;
  
      location / {
          root   /usr/share/nginx/html;
          index  index.html index.htm;
      }
  		error_page   500 502 503 504  /50x.html;
  		location = /50x.html {
      		root   /usr/share/nginx/html;
  		}
  }
  ```

##  static file 관련

### 파일 지정 방법

root 경로 + /ticket이 최종 URi의 바라보게되는 경로이다.

/usr/share/nginx/html/ticket/index.html

```
location /ticket {
    root /usr/share/nginx/html;
    index index.html;
}
```

만약 location URI first를 삭제하고싶다면(위에서 root경로) `alias`를 이용하자

/usr/share/nginx/html/index.html

```
location /ticket {
    alias /usr/share/nginx/html;
    index index.html;
}
```



## proxy_pass

같은 80번 포트의 요청이라도 도메인기준으로 응답서버를 다르게할수있다.

nginx1.appsroot.com이 요청은 root  /home/nginx1에서 index.html을 응답한다.

nginx2.appsroot.com/start 요청은 root /home/nginx2 + /start 경로에서 start.html을 응답한다.

(아래 설정은 default.conf에 추가했다고 가정한다)

```
server {
		listen       80;
    server_name  localhost;
    
    #charset koi8-r;
    #access_log  logs/host.access.log  main;
    location / {
        root   /home/nginx;
        index  index.html index.htm;
    }
        .....    
}

server {
    listen       80;
    server_name  nginx1.appsroot.com;
    
    location / {
       root   /home/nginx1;
       index  index.html;
    }
}

server {
    listen       80;
    server_name  nginx2.appsroot.com;
    
    location /start {
        root   /home/nginx2;
        index  start.html;
    }
}
```



# log 경로

별도로 access log 설정을 하지 않으면 하나의 `logs/access.log` 파일로 쌓입니다.

해당 .conf의 server에 다음과 같이 작성한다.

그리고 해당경로의 `/var/log/nginx/`에 `mkdir <서버이름>` 해줘야한다(해당 디렉토리존재해야함)

```
server {
  access_log /var/log/nginx/<서버이름>/access.log
  error_log /var/log/nginx/<서버이름>/error.log
}
```

> nginx.conf의 기본 설정은 /var/log/nginx/error.log access.log가 존재한다



