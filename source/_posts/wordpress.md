---
title: 워드프레스 도커활용하여 배포하기(https포함)
date: 2020-09-25 09:14:20
categories: [ETC]
tags: [Wordpress, Basic, Docker, Https]
---

# 왜?

컴퓨터 비전공자인데, 학교생활을 하다보면 웹사이트를 구축하는 방법에 대해서 배운다. wordpress..

물론 교수님은 도메인도 사주신다고하시고, 카페 24에서 모든것을 세팅해주기때문에 쉽게도 해결할수있는 과제였지만...

나는 아쉽게도 도메인, 개인서버를 가지고있으며, nginx를 맛봤기때문에 충분히 구축할수있을것같았다.

그래서 해봤다. Docker를 이용하여 nginx로 리버스 프록시하는 과정을 본다

[실제 홈페이지 만든것](home.lostcatbox.com)

ssl 인증서 포함

# 네트워크 구성

아래는 reverse-proxy에 conf파일이다.

도커에서 워드 프레스는 reverse-proxy와 같은 네트워크에 있어야한다.(당연)

```
upstream wordpress-html {
        server wordpress:80;
}
server {
    listen 80;
    server_name home.lostcatbox.com;
    location / {
        return 301 https://$host$request_uri;
    }
    location /.well-known/acme-challenge/ {
         root /var/www/certbot;
    }
}
server {
    listen 443 ssl;
    server_name home.lostcatbox.com;
    ssl_certificate /etc/letsencrypt/live/home.lostcatbox.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/home.lostcatbox.com/privkey.pem;
        location / {
        proxy_set_header        X-Real-IP         $remote_addr;
        proxy_set_header        X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header        Host              $host;
        proxy_set_header        X-Forwarded-Proto https;
        proxy_set_header        X-Forwarded-Port  443;
        proxy_pass              http://wordpress-html/;
        }
}
```

home.lostcatbox.com요청주소로 80번 포트로 들어오면 https로 리다이렉트해준다

> __letsencrypt에 관한 설명__
>
> [자세히](https://cnisoft.tistory.com/168)
>
> [자세히2](https://kscory.com/dev/nginx/https)
>
> letsencrypt가 ssl 발급해줄때 80번포트로 /.well-known/acme-challenge/접근하므로 위와 같이 구성해야한다.
>
> 443 ssl로 들어왔을경우  
>
> ssl_certificate 
>
> ssl_certificate_key
>
> 의 경로를 지정해줘야하는데 나는 reverse-proxy 또한 도커이므로 해당경로 마운트된 폴더에 home.lostcatbox.com 폴더 안에 `fullchain.pem`,`privkey.pem` 를 발급해넣었다.
>
> 발급하는 자세한 방법은 https://certbot.eff.org/ 확인해보자
>
> 우분투 20.04 +nginx 라면 https://certbot.eff.org/lets-encrypt/ubuntufocal-nginx
>
> ```
> certbot certonly --webroot -w /var/www/example -d www.example.com -d example.com -w /var/www/other -d other.example.net -d another.other.example.net
> ```

## 생각할 것

[자세히](https://www.popit.kr/proxy-%EB%92%A4%EC%97%90%EC%84%9C-docker%EC%9D%98-wordpress-https-%EC%A0%81%EC%9A%A9/)

아래 부분은  nginx(리버스프록시역할)과 docker의 wordpress의 연결에서 발생하는 문제점이다(이 포스팅덕분에 그래도 쉽게 해결한것같다. 감사합니다.)

```
        location / {
        proxy_set_header        X-Real-IP         $remote_addr;
        proxy_set_header        X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header        Host              $host;
        proxy_set_header        X-Forwarded-Proto https;
        proxy_set_header        X-Forwarded-Port  443;
        proxy_pass              http://wordpress-html/;
        }
```

`proxy_set_header        X-Forwarded-Proto https;` 가 반드시 필요하다. wordpress-apach에서 apach는 http로 보내버리고, 그럼 wordpress의 https=on가 되지않으므로(내부 설정) 리다이렉트 되는거같다.(무한반복됨.)

즉, apach에 요청할때 헤더값을 https로 고정해줄필요가있었다.



# Wordpress in docker



docker-compose.yml파일은 다음과 같다

```
version: '3.3'
services:
   wordpressdb:
     container_name: wordpressdb
     image: mysql:5.7
     expose:
       - "3306"
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: 비번
       MYSQL_DATABASE: wordpress
       MYSQL_USER: 아이디
       MYSQL_PASSWORD: 비번

   phpmyadmin:
     depends_on:
       - wordpressdb
     image: phpmyadmin/phpmyadmin
     restart: always
     ports:
       - "8888:80"
     expose:
       - "80"
     environment:
       PMA_HOST: wordpressdb
       MYSQL_ROOT_PASSWORD: 비번

   wordpress:
     depends_on:
       - wordpressdb
     container_name: wordpress
          image: wordpress:latest
     expose:
       - "80"
     restart: always
     volumes:
       - ./data/html:/var/www/html/
     environment:
       WORDPRESS_DB_HOST: wordpressdb:3306
       WORDPRESS_DB_USER: 아이디
       WORDPRESS_DB_PASSWORD: 비번
       WORDPRESS_CONFIG_EXTRA: |
           define('FS_METHOD', 'direct');
           define('WP_HOME', 'https://home.lostcatbox.com/');
           define('WP_SITEURL', 'https://home.lostcatbox.com/');
```

나는 이미 reverse-proxy에 네트워크가 있었으므로 external을 docker-compose파일에 external network값을 포함했다. (위에서는 제거함.)

\+ports 를 사용하지않고 expose를 사용하였다.

또한 wordpressdb가 먼저 구성되어야하므로 depend on을 사용하였다.

# 생각할 것



__`WORDPRESS_CONFIG_EXTRA` 안에 설정값이 필요이유 설명__

플러그인에서 php관리자와 wordpress간의 오류를 경험하고 싶지 않다면 다음과 같은 설정을 고려하자.

`define('FS_METHOD', 'direct' );`WordPress에서 파일을 직접 쓰도록 강요한다.



### wp-config.php 편집

수동으로 사이트 주소를 변경하는 방법이 있습니다. 이 방법은 wp-config.php 파일의 내용을 추가하는 방법으로 이루어진다

워드프레스가 설치된 곳 최상위에서 wp-config.php 파일을 찾으신 뒤에 해당 파일에 아래와 같은 코드를 추가해 준다.

변경하려는 사이트의 주소가 https://home.lostcatbox.com/인 경우 아래와 같이 2줄을 추가하여 준다.



```
define('WP_HOME','https://home.lostcatbox.com/');
define('WP_SITEURL','https://home.lostcatbox.com/');
```