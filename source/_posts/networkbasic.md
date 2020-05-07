---
title: networkbasic
date: 2020-05-07 12:47:12
categories: [Network]
tags: [Network, Tip, Basic]
---

네트워크는 기기간, 기기와 서버간 통신

http, https는 통신 규격으로서 애플리케이션 단에서 풀리고 압축됨. 또한 application(가장 추상적) 에서 통신을 위해서 01010바이너리데이터로 BIT까지 내려가야됨. 그와중에 TCP/IP들의 양식을 통해 Network Data Link Layer에서 요청과 응답간의 통신이 어디로 향해야하는지 정확히 도착했는지에 대한 정보가 다 들어가있다. 

![스크린샷 2020-05-07 오후 12.50.45](https://tva1.sinaimg.cn/large/007S8ZIlgy1gejqy66v23j310k0smkh6.jpg)

하지만 UDP/IP(최근 추세)로 http/3로 점점 진화중인데 구글아 부탁해

하여튼 양파처럼 생각하면된다. application에서 밖으로 통신에 필요한 정보들을 layer규격으로 하나씩 감싸고 서버에서는 어디로 보내야할지 알아야하므로 Network layer까지 풀었다가 다시 압축해서 통신을 보낸다. 

라우터와 루트 등의 개념도 들어감

