---
title: letsencrypt
date: 2020-12-05 16:17:53
categories: [Network]
tags: [Basic, Ssl,Network]
---

```
sudo certbot certonly -a webroot -m lostcatbox@gmail.com -w /home/lostcatbox2/proxy/data/certbot/www -d home.lostcatbox.com  #내가 설정한 www폴더와 인증
```

생성된 인증서 위치 : /etc/letsencrypt/live/[도메인명]

해당 인증서로 접근

cd /etc/letsencrypt/live/[도메인명]



