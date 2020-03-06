---
title: outsoucing_impactstation
date: 2020-03-05 10:01:25
categories: [Outsourcing]
tags: [Outsourcing, Django]
---

# 처음 외주를 시작하며

인강 사이트를 외주 받으며

구현에 문제점과 오류을 기록하고

필요한 기능들, 이를 위해 습득해야될 것들, 나머지 어려웟던 것들을 어떻게 해결했는지를 종합적으로 정리해놓을 겁니다.

__과정__ 

- 설계(DB단(UML)과 홈페이지기준으로 두개를 계획후 이어지게함)

  - DB설계

    - app>model>field순으로 하나씩 생각하면서 기획서 3번보는것 추천 

      모든것이 구현이 될만한 게 일단 생각하면서 모두 추가해놓기

    - UML 그려보기

  - 브라우저 페이지 기준 설계

    - 페이지 별로 GET, POST등등을 어떻게 할것인지 생각

- 나중에 프론트와 연결



## 구현시 팁

- 회원가입

  - 탈퇴 가능
  - 비번 변경시 이메일로 재설정링크보내기

- 메일 템플릿 구현

  - Django 템플릿에서 {% raw %} `{% if %}` {% endraw %} 사용하면 페이지에서 생기고 없애기 쉬움

- 메인 구현

  - 이미지만 구현
  - 고정 다 없앰

- 클래스 상세 페이지

  - 클래스 상세 페이지에서 (클래스소개, 강사소개, 클래스후기 등등) href태그로 스크롤하기__\<a herf\=\#a\>__(js 안쓰기위해)

  - 클래스후기 등등 더보기 구현 연습해보기(나중에)

- 마이페이지

  - 마이페이지에서 강사가 QnA 누르면 해당 강의 페이지 열림

    __강사는 자신의 클래스만 답변 가능__(이 클래스를 연 사람인지 확인)

  - 나의 클래스의 내가 듣고 있는 강의만 뜸

  - 티켓 입력 추가(티켓 입력시 자동으로 해당 클래스 수강가능 회원됨)

- 클래스 수강 페이지

  - 별점 클릭시 리뷰 작성
  - 커리큘럼, QnA 도 모두 문서로 js안 쓰고 바로 구현

- 관리자 페이지

  - 메인화면 관리
  - 클래스 관리
    - 강의 추가 (여러개 뜸 or 계속 추가 가능)
  - 티켓관리
  - 회원관리
  - 강사관리(내가 임의로 추가)
  - 후기관리 
    - 노출, 비노출 선택가능
  - QnA 관리
    - 노출, 비노출 선택가능

- DB구성 팁

  - 강사진 4명, 따로 모델 만듬, 클래스 등록시 강의리스

- 나머지 요구 사항 및 참고 사항

  - 리뷰 작성 페이지에서 modal을 써야하나(쌩JS) 그냥 url로 이동후 다시 와도되나? (후자가 개발속도 빠름)

  - 기획서 p.37에서 JS로 답글쓰기 만들어야함(JQuery, Js)

  - 수강하기클릭시>와디즈결제url이동>관리자가 정보 알아냄

    \> 직접 관리자페이지로 개별등록> 티켓값과 함께 이메일발송(메일템플릿사용) >사용자가 직접입력

  - 수강 기록있는지 확인하는 프로세서 필요함 따라서 수강안했던것 표시

  - 키보드 반응형 안함, 스크롤 왠만하면 안함, 클래스 예정날짜 모두제거, 휴대폰 번호 기록들 삭제

  - 데이터 있고 없을때 django에서 템플릿에서 if문 else 쓰면 편할듯

  

# 설계

## accounts app

### User

#### student(수강생)

- user = OneToOne(User)
- name
- email
- phone_number
- 이용약관(boolen)(강제)
- 이벤트 및 할인소식(boolen)(choose)

#### teacher(강의자)

- user = OneToOne(User)
- profile_image
- teacher_name
- teacher_sns # <- Facebook/Twitter등 여러 요소일 경우에는?
- teacher_detail

```
이후에 들어가는 부분은 모두
created_at = models.DateTimeField()
updated_at = models.DateTimeField()
이 두개를 추가해 둬야 함. 이 2개 항목은 생성일시 수정일시로 모든 모델에 기본적으로 들어가있어야 함.
따라서 

class DateTimeModel(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        abstract = True # 이런식으로 메타클래스로 만들어줘야 함
       
```

## 수업 app

- 이용약관넣기 # TODO?

### Main Pages(file, m2m???)

- top_image
- top_text
- course(4개까지 클래스 앞에 띄울수있음)(클래스 id 값입력하면 바로 ㄲ) - ManyToMany(Course)

### Course(클래스를 이렇게치환시킴, 클래스 상세페이지내용)

- 수강

### Lecture(강의들, 각 강의의 구성요소)

- lecture_id()
- lecture_purpose(강의목적)
- foreginKey(Course)
- 강의자료는..?

### Course Comments(댓글)

- user = ForeignKey(User)
- foreignkey(Course)
- content # 본문 어디감?

### Lecture Comments

- lecture = foreignkey(Lecture)
- user = ForeignKey(User)
- content

### Course Review(클래스후기)

- userid
- foreignkey(course)
- is_visible(노출여부 boolen)
- content (본문 어디감?)

### Course Ticket

- userid
- course_id
- ticket(자동발급) # UUID Field 이용할 것

### Lecture QnA

- foreignkey(Lecture)
- userid
- content

### Corse History

- userid
- lecture_history = 숫자담기



# 결론

- 요즘에는 프론트페이지는 가만히 있고 JS를 이용하여 각 동기적으로 움직이게 하며 요청 응답을 api를 통해 연결해주면

  JSON으로 응답받으면서 계속 표시해주고 반응하는 형태로 넘어가고있다(새 페이지 호출없어도됨)

- ajax는 비동기 구현하는 방식을 뜻함. 라이브러리이름아님 > 쌩JS보다 Jquery가 ajax더 쓰기쉬움

- 