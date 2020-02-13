---
title: HTTPie 사용법
date: 2020-02-13 15:23:14
categories: [HTTPie]
tags: [HTTPie, WebBasic]
---

# HTTPie

## 기능

[httpie](https://github.com/jkbrzt/httpie) 는 python 으로 개발된 콘솔용 http client 유틸리티로 [curl ](https://www.lesstif.com/pages/viewpage.action?pageId=14745703)대신 http 개발 및 디버깅 용도로 사용 가능하며 다음과 같은 특징이 있다.

## 왜 사용해야하는가?

- 요청과 응답이 어떻게 들어갔는지 볼수있고 다양한 기능을 내장함
- curl 에 비해 사용이 쉬움
- json 지원 기능 내장
- 출력을 포맷팅하여 보여주므로 가독성이 뛰어남
- Form 과 file 업로드가 쉬움
- HTTP 인증 및 커스텀 헤더 설정등
- 강력한 세션기능과 인증 기능을 제공함

## 설치

```
brew install httpie
```

## 기본 사용법

```
http [flags] [METHOD] URL [ITEM [ITEM]]
```

- flags : 실행시 전달할 옵션으로 *–* 로 시작(Ex: *--json*, --a, --form)
- METHOD : HTTP 메소드로 생략시 GET.
- URL: 연결할 url
-  '='이면 post인자, '=='이면 get인자

- 사용할만한 옵션

  - --verbose, -v(요청값, 응답값 모두 보여줌)
          Verbose output. Print the whole request as well as the response. Also print

  - --headers, -h(헤더만 보여줌)
          Print only the response headers. Shortcut for --print=h.

  - --json, -j (요청한 내용 json으로 직렬화)
          (default) Data items from the command line are serialized as a JSON object.
          The Content-Type and Accept headers are set to application/json
          (if not specified).

  - --form, -f(요청한 내용 보편화된 type으로 요청, file있으면 multipart로 전환)
          Data items from the command line are serialized as form fields.

          The Content-Type is set to application/x-www-form-urlencoded (if not
          specified). The presence of any file fields results in a
          multipart/form-data request.

  - --auth, -a 옵션 뒤에 인증 정보를 전달

    ```
    http -a username:password example.org
    ```

  - 커스텀 HTTP 헤더를 전송하려면 `Header:Value`

    ```
     http httpbin.org/headers Accept: User-Agent:
     
      http httpbin.org/headers 'Header;' 이렇게하면 header가 빈값
    ```

    

### 예시 

보낸값

```
http --json -v POST  httpbin.org/post  body=HTTPheart 
```

응답값

```
POST /post HTTP/1.1
Accept: application/json, */*
Accept-Encoding: gzip, deflate
Connection: keep-alive
Content-Length: 23
Content-Type: application/json
Host: httpbin.org
User-Agent: HTTPie/2.0.0

{
    "body": "HTTP :heart"
}
--------------위에가 요청값---------------

HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 502
Content-Type: application/json
Date: Thu, 13 Feb 2020 07:17:24 GMT
Server: gunicorn/19.9.0

{
    "args": {},
    "data": "{\"body\": \"HTTP :heart\"}",
    "files": {},
    "form": {},
    "headers": {
        "Accept": "application/json, */*",
        "Accept-Encoding": "gzip, deflate",
        "Content-Length": "23",
        "Content-Type": "application/json",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/2.0.0",
        "X-Amzn-Trace-Id": "Root=1-5e44f804-97caa420351ee528e0990858"
    },
    "json": {
        "body": "HTTP :heart"
    },
    "origin": "221.148.49.27",
    "url": "http://httpbin.org/post"
}
```

## 세션 유지하기

HTTPie를 사용하는 동안 각 요청은 다른 요청과 독립적입니다. 다른 HTTP 요청에 대해 세션을 유지하고 싶은 경우에 대비해 세션을 유지할 수 있습니다. 세션을 유지하려면 다음과 같이 명명된 세션을 만들기만 하면 됩니다.

```
http --session=roy -a roy:mypass www.myservice.com
```

위 명령은 세션 이름을 사용해 다른 요청에도 사용할 수 있는 `roy`라는 세션을 만듭니다. 다음은 `roy` 세션을 사용하는 예입니다.

```
http --session=roy www.myservice.com
```

참고로 이 파일은  `~/.httpie/sessions/<host>/<name>.json`에 저장됩니다.

### 세션 파일 활용가능

이름 대신 세션 파일의 경로를 직접 지정할 수도 있습니다. 이를 통해 여러 호스트에서 세션을 재사용 할 수 있습니다.

```
http --session = /tmp/session.json example.org
http --session = /tmp/session.json admin.example.org
http --session = ~ / .httpie / sessions / another.example.org
http --session-read-only = /tmp/session.json example.org
```

## HTTPie**를 통한** Token 획득 및 요청

```
쉘> http POST http://주소/api-token-auth/ username="유저명" password="암호"
```

```
http http://localhost:8000/api/post/ "Authorization:Token <TOKEN값입력>"
```

```
#환경변수를 설정해서 편하게 이용하자
export HOST="http://localhost:8000"
export TOKEN="d7ec115d8370de00f06c50ec5b61bd519b1038ae" 

# Post List
http $HOST/api/post/ "Authorization: Token $TOKEN"

# Post Create
http POST $HOST/api/post/ "Authorization: Token $TOKEN" message="hello" 

# Post Create with Photo
http --form POST $HOST/api/post/ "Authorization: Token $TOKEN" message="hello" photo@"f1.jpg"   # httpie 문법임, 현재 프로젝트전체폴에경로에존재하는 사진파일

# Post#16 Detail
http GET $HOST/api/post/16/ "Authorization: Token $TOKEN"

# Post#16 Update
http PATCH $HOST/api/post/16/ "Authorization: Token $TOKEN" message="patched" 

http PUT $HOST/api/post/16/ "Authorization: Token $TOKEN" message="updated"

# Post#16 Delete
http DELETE $HOST/api/post/16/ "Authorization: Token $TOKEN"
```

