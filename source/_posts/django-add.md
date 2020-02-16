---
title: Django 더알아보기
date: 2020-02-15 14:49:56
categories: [Django]
tags: [Django, Advanced]
---

# 기능에 따라

## django DEBUG=False

django 프로젝트의 디폴트값은 DEBUG=True이다.

개발이 종료되면 DEBUG=False로 변경한다. 이때 달라지는점을 정리한다.

- ALLOWED_HOSTS에 필요한 IP, DNS를 추가해줘야 서비스가능

  ```
  ALLOWED_HOSTS = ['127.0.0.1'] 로 설정 후
  >> http://localhost:8000/ 로 접속시
  Bad Request (400)
  >> http://127.0.0.1:8000/ 로 접속시
  접속됨
  
  ALLOWED_HOSTS = ['localhost'] 로 설정 후
  
  >>http://localhost:8000/ 로 접속시
  접속됨
  
  ALLOWED_HOSTS = ['*']
  로 하여 모든 곳으로 부터의 접속을 허용할 수도 있습니다.
  ```

  

  DEBUG=False로 지정되면 파일 경로, 구성 옵션 등은 서버단에서 바꿔줘야 할수있다.

  다시 말해, Nginx나 Apache에서 /static과 /media 경로와 연결되는 디렉토리를 지정해주어야 한다.

  [예시](https://joonas.tistory.com/58)

  

- [`DEBUG`](https://docs.djangoproject.com/en/3.0/ref/settings/#std:setting-DEBUG)=True에서는 Django가 켜진 상태에서 실행할 때 실행되는 모든 SQL 쿼리 를 기억한다는 점도 기억해야 합니다. 디버깅 할 때 유용하지만 프로덕션 서버에서 메모리를 빠르게 소비합니다.



# 작동방식에 따라