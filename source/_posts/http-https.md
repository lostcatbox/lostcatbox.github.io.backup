---
title: Http/Https
date: 2020-06-28 17:44:56
categories: [Network]
tags: [Network,Http,Https,Basic]
---

[자세히](https://aaasssddd25.tistory.com/18?category=617816)

[자세히2](https://gmlwjd9405.github.io/2019/01/28/http-header-types.html)

# HTTP

- Hyper Text Transfer Protocol

- 서버의 80번 포트로 확립된 소켓상에서 HTTP요청과 응답을 교환함으로써 통신이 이뤄짐

- 클라이언트는 가져오려는 HTML 파일이나 이미지를 지정하기 위해서 URI(Uniform 
   Resource Identifier)를 이용

- URI는 인터넷에서 가져오는 리소스를 지정하기 위한 표준 기술 형식
   -> 프로토콜 : //호스트명:포트번호/파일경로(위치)?쿼리문자열

  ex) http://www.naver.com/Website/Default.aspx?uid=godffs&pwd=12345

- URL에 :8080과 같이 포트번호를 별도로 지정하지 않을 경우, HTTP의 디폴트 TCP 80번
   포트를 사용 (웹 주소에는 전부 있는 셈치고 생략되어있음)

- 웹 서버는 클라이언트로부터의 HTTP 요청 메시지를 수신하면 메소드에 따라 처리를 하고
   그 결과를 나타낸 응답 코드를 추가한 HTTP 응답 메시지를 회신함



- HTTP의 요청 메시지는 명령을 지정하는 메소드에 이어, 보다 상세하게 지정하기 위한
   HTTP의 일반 헤더나 요청 헤더를 갖추고 있음

  -> 어떤 문서를 가져올지 지정 가능

  [자세히](https://gmlwjd9405.github.io/2019/01/28/http-header-types.html)(요청응답 헤더가 모두 가질수있는값,요청 헤더만,응답 헤더만)

  ![image-20200630231753265](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggaoejz00mj30zq0jgn01.jpg)

  ![image-20200630231855814](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggaofl5koej31120jcado.jpg)

  ```
  GET /home.html HTTP/1.1  #메소드 헤더
  Host: developer.mozilla.org
  User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:50.0) Gecko/20100101 Firefox/50.0
  Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/ *;q=0.8
  Accept-Language: en-US,en;q=0.5
  Accept-Encoding: gzip, deflate, br
  Referer: https://developer.mozilla.org/testpage.html
  Connection: keep-alive
  Upgrade-Insecure-Requests: 1
  If-Modified-Since: Mon, 18 Jul 2016 02:36:04 GMT
  If-None-Match: "c561c68d0ba92bbeb8b0fff2a9199f722e3a621a"
  Cache-Control: max-age=0
  https://gmlwjd9405.github.io/2019/01/28/http-header-types.html
  ```

  > 아래 예시들을 보고싶다면, wireshark를 참고하자

- 요청에 대한 응답코드 해석![image-20200630231904689](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggaofpzp27j31720gsjvc.jpg)

- 주요 응답 헤더

  ![image-20200701173930457](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggbk8ue8pij31120jc77q.jpg)

- ![image-20200701175444405](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggbkokt6z4j318i0ni0yv.jpg)

# HTTPS

[자세히]([https://medium.com/@shaul1991/%EC%B4%88%EB%B3%B4%EA%B0%9C%EB%B0%9C%EC%9E%90-%EC%9D%BC%EC%A7%80-http-%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C%EC%9D%98-%EC%9D%B4%ED%95%B4-3-https-ssl-%EC%9D%B8%EC%A6%9D%EC%84%9C-ad677cf5492a](https://medium.com/@shaul1991/초보개발자-일지-http-프로토콜의-이해-3-https-ssl-인증서-ad677cf5492a))

[자세히2](https://jeong-pro.tistory.com/89)

- HTTP의 보안이 강화된 버전이다.
- SSL 프로토콜을 통해 세션 데이터를 암호화 한다.
- 사용자 컴퓨터와 방문한 사이트 간에 전송되는 사용자 데이터의 무결성과 기밀성을 유지할 수 있게 해주는 인터넷 통신 프로토콜이다.
- 데이터
  \- 암호화 (도청 / 추적 / 도용에 대한 보호)
  \- 무결성 (변조 / 손상 방지)
  \- 인증 (요청에 대한 신뢰 보장)

![스크린샷 2020-07-01 오후 6.02.54](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggbkx51sraj30xu0hmn7m.jpg)

암호학을 공부하는게 아니니 공개키 알고리즘을 간단하게만 소개하겠다.

암호화, 복호화시킬 수 있는 서로 다른 키 2개가 존재하는데 이 두 개의 키는 서로 1번 키로 암호화하면 반드시 2번키로만 복호화할 수 있고 2번 키로 암호화하면 반드시 1번키로만 복호화할 수 있는 룰이 있는 것이다.

그 중에서 하나 키는 모두에게 공개하는 공개키(1번 키)로 만들어서 공개키 저장소에 등록해놓는다.

서버는 서버만 알 수 있는 개인키(2번 키)를 소유하고 있으면 된다.

그러면 1번키로 암호화된 http 요청, 즉 HTTPS 프로토콜을 사용한 요청이 온다면 서버는 개인키(2번 키)를 이용하여 1번키로 암호화된 문장을 해독하게 된다.

서버는 요청이 무엇인지 알게되고 요청에 맞는 응답을 다시 개인키(2번 키)로 암호화해서 요청한 클라이언트에게 보내주게 된다.

그리고 응답을 받은 클라이언트는 공개키(1번 키)를 이용해서 개인키(2번 키) 암호화된 HTTPS 응답을 해독하고 사용하는 시나리오다. **(\* 공개키 암호화 방식에 대한 이해를 위한 설명일 뿐 더 정확한 HTTPS 연결 과정은 아래에 따로 정리 했습니다.)**

HTTPS를 지원하는 서버에 요청(Request)을 하려면 공개키가 필요하다는 것을 알 수 있다.

그러면 그 공개키는 공개키 저장소에 있다는 것은 알겠는데 어떻게 공개키 저장소에서 가져올까?

추가적으로 공개키는 누구나 얻을 수 있고 공개키를 알면 서버가 주는 데이터(Response)는 알 수 있는데 보안상에 의미가 있을까?

보안상의 의미는 없다.

대신 얻을 수 있는 이점은 **해당 서버로부터 온 응답임을 확신**할 수 있다. 왜? 공개키로 해독이 가능했으니까 반드시 해당 서버의 개인키로 암호화했다는 것을 보장하기 때문이다.

>**조금 더 자세한 HTTPS 통신 흐름**
>
>아까 의문을 가졌던 것을 다시 생각해보자.
>
>공개키가 공개키 저장소에 있는데 어떻게 가져올 수 있을까?
>
>HTTPS 통신 흐름에 대해서 자세히 들여다보면 알 수 있다.
>
>일단 공개키 저장소라고 부르던 곳이 원래 명칭은 CA(Certificate Authority)다.
>
>CA는 민간기업이지만 아무나 운영할 수 없고 신뢰성이 검증된 기업만 CA를 운영할 수 있다.
>
>1. 먼저 애플리케이션 서버(A)를 만드는 기업은 HTTPS를 적용하기 위해서 공개키와 개인키를 만듭니다.
>
>2. 그 다음에 신뢰할 수 있는 CA 기업을 선택하고 그 기업에 내 공개키를 관리해달라고 계약하고 돈을 지불합니다.
>
>3. 계약을 완료한 CA 기업은 또 CA 기업만의 공개키와 개인키가 있습니다.
>
>   CA 기업은 CA기업의 이름과 A서버의 공개키, 공개키의 암호화 방법 등의 정보를 담은 인증서를 만들고, 해당 인증서를 CA 기업의 개인키로 **암호화해서** A서버에게 제공합니다.
>
>4. A서버는 암호화된 인증서를 갖게 되었습니다. 이제 A서버는 A서버의 공개키로 암호화된 HTTPS 요청이 아닌 요청(Request)이 오면 이 암호화된 인증서를 클라이언트에게 줍니다.
>
>5. 이제 클라이언트 입장에서, 예를 들어 A서버로 index.html 파일을 달라고 요청했습니다. 그러면 HTTPS 요청이 아니기 때문에 **CA기업이 A서버의 정보를 CA 기업의 개인키로 암호화한 인증서**를 받게되겠지요.
>
>6. 여기서 중요합니다. **세계적으로 신뢰할 수 있는 CA 기업의 공개키는 브라우저가 이미 알고 있습니다!**
>
>7. 브라우저가 CA 기업 리스트를 쭉 탐색하면서 인증서에 적혀있는 CA기업 이름이 같으면 해당 CA기업의 공개키를 이미 알고 있는 브라우저는 해독할 수 있겠죠? 그러면 해독해서 A서버의 공개키를 얻었습니다.
>
>8. 그러면 A서버와 통신할 때는 A서버의 공개키로 암호화해서 Request를 날리게 되겠죠.

