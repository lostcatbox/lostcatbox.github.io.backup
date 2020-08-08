---
title: HTTP,Ajax,Websocket
date: 2020-08-01 15:04:41
categories: [Network]
tags: [Network, HTTP, Ajax, Websocket]
---

[자세히]([https://medium.com/@chullino/http%EC%97%90%EC%84%9C%EB%B6%80%ED%84%B0-websocket%EA%B9%8C%EC%A7%80-94df91988788](https://medium.com/@chullino/http에서부터-websocket까지-94df91988788))

#  HTTP

http는 OSI  layer에서의  데이터 통신 프로토콜이다.

웹브라우저가 URL에 접속한다면 HTTP규약에 따라 요청하게되고 이는 해당서버가 해당 요청에 응답하며, 그 결과인 html문서가 브라우저 창에 나타난다.

하지만 HTTP규약을 그대로 개발한다면 반드시 사용자의 요청이 선행되어야하며 또한 페이지 내용을 고친다면 모든 페이지를 새로고침해야한다.

이를 해결하기위한 것이 __Ajax__

__![스크린샷 2020-08-01 오후 3.18.56](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghbae3uphmj31200is4c0.jpg)__

# Ajax(비동기적 JS And Xml)

HTTP 프로토콜안에서 ajax는 서버와 소통하기 위한 기술이다.

http 문서에서의 DOM과 이를 컨트롤할수있는 Javascript를 이용한다.

즉 유저는 새로운 HTML을 서버로부터 받는것이 아니라, 그 웹페이지 내에서 DOM을 변경하게된다.

사용자의 이벤트로부터 Javascript는 해당 이름과 내용이 쓰여진 DOM을 읽습니다. 그리고는 XMLHttpRequest 객체를 통해 웹서버에 해당 이름과 내용을 전송합니다. 웹서버는 요청을 처리하고 XML, Text 혹은 JSON을 XMLHttpRequest 객체에 전송합니다. 그러면, Javascript가 해당 응답 정보를 DOM에 씁니다. 그렇게 결과페이지가 만들어집니다.

AJAX를 쓰면 새로운 HTML을 서버로부터 받아야 하는 것이 아닙니다. 동일한 페이지의 일부를 수정할 수도 있는 가능성이 생깁니다. 결과적으로 사용자 입장에서는 페이지 이동이 발생되지 않고 페이지 내부 변화만 일어나게 됩니다. HTML 페이지 전체를 다 바꿔야 하는 것이 아니라 부분만 바꿀 수 있게 되는 것입니다.

- 나이브한 HTTP는 웹브라우저가 서버에 요청합니다.
- AJAX는 XMLHttpRequest 객체가 서버에 요청합니다.

![스크린샷 2020-08-01 오후 3.19.19](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghbaegmlb0j311e0n4wu1.jpg)

하지만 이 또한 한계가 있다.클라이언트의 요청이 있고 그 다음 서버로부터 응답을 받아야하는 상황이므로, 서버가 push할수는 없다.(서버는 응답밖에하지못한다.)

예를 들면 채팅을 만든다고 하였을때는 사람들이 한명씩 같은 채팅방에 접속한다고 했을때, A씨가 처음에 들어올때는 요청, 응답이 이뤄져서 문제없지만 B씨가 채팅방에 접속하면 A씨의 웹에서는 B씨가 들어왔다는 것을 서버가  A에게 push  할수없으므로 한계가있다.

# Websocket

[자세히]([https://medium.com/@icehongssii/%EA%B9%9C%EC%B0%8D%ED%95%9C-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EB%93%A4%EC%9D%84-%EC%9C%84%ED%95%9C-%EA%B0%84%EB%8B%A8%ED%95%9C-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D-%EC%83%81%EC%8B%9D-2-2-http%EB%A5%BC-%EB%84%98%EC%96%B4%EC%84%9C-%EC%8B%A4%EC%8B%9C%EA%B0%84-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%82%B9websocket-c49125e1b5a0](https://medium.com/@icehongssii/깜찍한-프로그래머들을-위한-간단한-프로그래밍-상식-2-2-http를-넘어서-실시간-네트워킹websocket-c49125e1b5a0))

웹소켓은 HTTP의 문제를 해결해주는 약속이다. HTTP에서 원리적으로 해결할 수 없었던 문제는 “__클라이언트의 요청이 없음에도__, 그 다음 서버로부터 응답을 받는 상황”이었는데요.웹소켓은 HTTP가 해결할 수 없었던 이 문제를 해결하는 새로운 약속(프로토콜)이었습니다. 즉, 브라우저가 서버에 데이터를 요청하고 서버가 브라우저에 데이터를 보내기 위해 별다른 제약이 없습니다.

웹소켓 약속 하에서는 실시간 소통이 편안해지게 됩니다. 웹에서도 채팅이나 게임, 실시간 주식 차트와 같은 실시간이 요구되는 응용프로그램의 개발을 한층 효과적으로 구현할 수 있게 되었습니다. 가상화폐의 분산화 기술의 핵심도 web socket으로 구현할 수 있다는 점 언급해두고 싶습니다.









