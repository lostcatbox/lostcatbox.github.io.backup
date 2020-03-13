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

## 현재 해야할것 (TO-DO_LIST)

- aws 구축



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
    - 홈페이지에서 회원가입 후 회원관리에서 강사는 등록 강사등록 후 클래스 등록에 뜸
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

  - 이용약관넣기 # TODO?

  

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
- is_active
- created_at = models.DateTimeField()

#### teacher(강의자)

- user = OneToOne(User)
- profile_image
- teacher_name
- teacher_sns # <- Facebook/Twitter등 여러 요소일 경우에는?
- teacher_detail
- created_at = models.DateTimeField()

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
        abstract = True # 이런식으로 메타클래스로 만들어줘야 함, makemigration할때 해당클래스는 안잡히고 따라서 상속받은애들만 구성요소가진 테이블 생성됨
       
```

## mainpage app

### Main Pages(file, m2m???)

- top_image
- top_text
- course(4개까지 클래스 앞에 띄울수있음)(클래스 id 값입력하면 바로 ㄲ) - ManyToMany(Course)

## 수업 app

### Course(클래스를 이렇게치환시킴, 클래스 상세페이지내용)

- course_infor

- curriculum(그냥 lecture에있는 거 뷰 단에서 다 쿼리셋가져오면되지않나?)(???)

- teacher_infor = onetoone(Teacher)

  

### Course Review(클래스후기)

- user = models.OneToOneField(Account)
- course_id = models.OneToOneField(Course)  (어차피 review는 한사람당 한개니까)
- is_visible = models.BooleanField()
- content = models.TextField()

### Course Ticket(발급난수)

- userid = onetoone(Account)
- course_id = onetoone(Course)
- ticket(자동발급) = model.charfield # UUID Field 이용할 것
- created_date

### Lecture(강의들, 각 강의의 구성요소)

- course_id = foreignkey(Course)  (관리자 페이지에서  코스안에 들어가면 자동입력가능? )
- lecture_id = models.AutoField(primary_key=True)
- lecture_purpose(강의목적) =models.TextField
- lecture_file = filefield()

### Lecture QnA

- foreignkey(Lecture)
- userid
- content
- created_date
- id (???)
- 답글작성 구현,,
- [링크참조](https://stackoverflow.com/questions/44837733/how-to-make-add-replies-to-comments-in-django) (장고로 대댓글 만들기)

### Course History

- userid =onetoone
- lecture_history = textfield() (???) (여기에다가 리스트에 lecture_id 값을 넣으면 되나?)(???)

# 구현

## User

### 상황

기본auth.user에다가 OnetoOne으로 연결해서 student와 teacher을 만들려고 하니까 

모델이 각자 따로있으면서 장점도 있지만 그에따라 user가 같이 생성이 무조건되어야만 onetoone관계가 되므로

이건 무조건 forms.py에서 auth.user와 student 또는 auth.user와 teacher을 동시에 입력받아야함

그럼 회원 가입 페이지는 한개인데 multiform이용해서 어렵게 구성해야함. 따라서 Account모델에 통합하기함



### 해결

일단 필요한 정보 Account앱으로 바꿈(당연히 auth.user에서 accounts.Account로 바꿔줘야함, 로그인 회원가입에 사용되는 모델지정)

로그인 등등 모두 Account앱으로 할수있도록 만듬

추후 강사로 지정할수있는 버튼을 회원관리에다가 만들겠음

회원관리에서 강사는 is_teacher(True변경)후 클래스 등록에 뜸

```
class Account(AbstractUser):
    event_confirm = models.BooleanField('이용약관', default=False)
    event_receive = models.BooleanField('광고선택', default=False)
    is_teacher = models.BooleanField('강사', default=False)
    created_at = models.DateTimeField('생성날', auto_now_add=True)
    

class Teacher(models.Model):
    user = models.OneToOneField(Account, on_delete=models.CASCADE, blank=False)
    profile_image = models.FileField()
    teacher_name = models.CharField('강사이름', max_length=30, blank=False)
    teacher_sns = models.CharField('sns주소', max_length=100)
    teacher_detail = models.TextField('강사소개')
    created_at = models.DateTimeField('생성날짜', auto_now_add=True)
```

### 상황

django.admin에서 model inline model을 지원 안함

### 해결 

[nested-inline](https://github.com/s-block/django-nested-inline) 라이브러리를 사용하여 구축하였다.(사용법은 README.md 참조)

```
class LevelOneInline(NestedStackedInline):
    model = Lecture
    extra = 1
    fk_name = 'course_id'

class TopLevelAdmin(NestedModelAdmin):
    model = Course
    inlines = [LevelOneInline]

admin.site.register(Course, TopLevelAdmin)
```











# 결론

- 요즘에는 프론트페이지는 가만히 있고 JS를 이용하여 각 동기적으로 움직이게 하며 요청 응답을 api를 통해 연결해주면

  JSON으로 응답받으면서 계속 표시해주고 반응하는 형태로 넘어가고있다(새 페이지 호출없어도됨)

- ajax는 비동기 구현하는 방식을 뜻함. 라이브러리이름아님 > 쌩JS보다 Jquery가 ajax더 쓰기쉬움

# 파이썬 문법

- *args는 복수의 인자를 받으면 그것을 튜플형태로 전달

  ```
  In [6]: def name(*args):
     ...:     for i in args:
     ...:         print(i)
    
    
  name("고양이1", "고양이2")
  ```

  

- **kwargs는 (키워드=특정값) 형태로 함수를 호출할수있습니다.

  그것은 그대로 딕셔너리 형태로 {'키워드':'특정값'}으로 함수 내부로 전달됩니다.

  ```
  In [16]: def name_number(**kwargs):
      ...:     for i, n in kwargs.items():
      ...:
      ...:         print(i, n)
      ...:
      
  name_number(rhdiddl="싫어", 사랑해="고양이")
  ```

# MySQL

## 설치 방법

[자세히](https://junhobaik.github.io/mac-install-mysql/)

```
1. MySQL 서버 시작 : mysql.server start

2. MySQL DB 로그인 : mysql -u root -p  (u유저, p패스워드)
(mysql -h localhost -u root -p)(로컬호스트로 접속)(위에랑 같음)
(mysql -h opentutorials.org -P3306 -u root -p)(다른컴퓨터 주소로 접속, 3306번포트로접속)


3. MySQL DB 로그아웃 : exit 또는 quit

4. MySQL 서버 종료 : mysql.server stop

5. 완전 제거 "sudo rm -rf /usr/local/bin/mysql*" 
```

## 기본 구조

table(표와같음): row(행)와 column(열) 로 구성됨

같은 앱에서 사용되는 연관된 table들을 묶어서 database(table의 디렉토리와같음)라고함

즉, 하나의 애플리케이션이 하나의 db와 대응됨

하나의 컴퓨터 안에 여러 애플리케이션이 있으므로 DB도 여러 개임 이런 DB를 묶어서 DB server(예시:opentutorial.org:3306)라고 함

그래서 사용자가 user가 DB server에 접속한다면 (opentutorial.org라는 컴퓨터에 있는 3306번을 리스닝하고있는 DBserver로 접속)

사용자는 자신의 id, password를 사용하여 DB server에 접속후 해당 DB로 접속후 테이블에 접근

![스크린샷 2020-03-10 오후 1.11.27](https://tva1.sinaimg.cn/large/00831rSTgy1gcoph5l5juj31080kiadr.jpg)

## MySQL django 적용

```
~/pip3 install pymysql

# settings.py
import pymysql

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql', #mysql로 바꿔주기
        'NAME': 'impactstation', #테이블이름
        'USER': 'impactstation', #유저이름
        'PASSWORD': 'save2020!', #유저비번
        'HOST': 'localhost', #서버호스트
        'POST': '3306', #기본 포트 3306임
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'"
        },

    }
}
```



## MySQL 사용

```
mysql> create database o2;  #o2라는 DB생성
mysql> show databases; #현재 DB모두 보여줌
mysql> use o2 #o2 Db로 접근
mysql> show tables; #테이블 조회
Empty set (0.00 sec)

mysql> create table `topic` ( `id` int(11) NOT NULL AUTO_INCREMENT,     `title` varchar(100) NOT NULL,     `description` text NOT NULL,     `author` varchar(30) NOT NULL,     PRIMARY KEY (id) ) ENGINE=InnoDB DEFAULT CHARSET=utf8;   #테이블 생성

mysql> INSERT INTO topic (title, description, author) VALUES('java','Computer language', 'eogo'); #행 추가

SELECT * FROM topic #테이블 모든 행가져옴 조회

mysql> SELECT * FROM topic WHERE id=2; # id=2인 행 가져옴

mysql> UPDATE topic SET title='npm' WHERE id=2; # 수정  #where문 빠트리면 큰일난다.

DELETE From topic where id=2; #삭제



```

### 유저 생성 및 권한 부여

```
키마를 mysql 로 변경하겠습니다.

mysql>use mysql;

mysql>select host,user from user  #모든 유저확인
 
권한없다고할떄
mysql>CREATE USER ‘아이디’@’localhost’ IDENTIFIED BY ‘비번’;
mysql>GRANT ALL PRIVILEGES ON *.* TO ‘user’@’localhost’ WITH GRANT OPTION;  #*.*는 필요에 따라 DB명.테이블명 을 지정해서 권한을 줄수있음
mysql>flush privileges;

delete from user where user='아이디'; #유저 삭제
```

```
# 장고와 mysql연동시 에러 발생 처리
migrate에서 에러코드 2059가 뜨고 막히더라구요... 결국 고민하다가 결과가 8.04버전 이상부터는 플러그인 방식이 달라서 생기는 오류였습니다. (버전 8.04 MySQL은 이전에 mysql_native_password를 쓰지않고 caching_password를 기본 인증 플러그인을 쓰니까 그랬습니다.)
mysql의 다운그레이드 혹은 mysql에서 ALTER USER '유저이름'@'유저호스트정보' IDENTIFIED WITH
mysql_native_password BY '비밀번호'; 로 유저 비밀번호 플러그인 변경후 migrate 재시도하니까 됩니다.
```

# AWS RDS

MySQL을 기준으로 설명합니다

https://ap-northeast-2.console.aws.amazon.com/rds/home

접속후에 DB 인스턴스 생성 >> 추가 정보 눌러서 꼭 DB이름지정하고 포트 맞는지 확인

파라미터 검색 및 편집에서 아래와 같이 속성 수정하고 생성했던 DB에 속성에서 이 파라미터속성으로 적용

```
character_set_client: UTF-8
character_set_connection: UTF-8
character_set_database: UTF-8
character_set_filesystem: UTF-8
character_set_results: UTF-8
character_set_server: UTF-8
```

__접속 권한설정까지하면 이제 외부에서 접속도 가능하게된다 (내 컴퓨터에서 workbench를 쓰기위해)__

EC2관리 콘솔>보안그룹>인바운드>편집>MySQL추가하기(여기에서 외부모두허용)

이제 DB로 다시가서 속성에서 위에 보안그룹으로 변경 + 보안 그룹에 외부의 EC2인스턴스 접근 '예'로 설정해놔야함(혹여나 다른지확인)

이제 MySQL workbench로 원격접속

```
HostName: 앤드포인트
post: 포트번호 (deflualt:3306)
Username: 사용자명
password: 사용자 pw
```

그리고 migrate해보면

오류를 볼수있다 (mysql 5.7이하만.)

이 오류는 strict mode를 켜는 것을 권장하는것이다(mysql이 마음대로 값을 넣어버리는것을 방지함)

```
WARNING
?: (mysql.W002) MySQL Strict Mode is not set for database connection 'default'
	HINT: MySQL's Strict Mode fixes many data integrity problems in MySQL, such as data truncation upon insertion, by escalating warnings into errors. It is strongly recommended you activate it. See: https://docs.djangoproject.com/en/3.0/ref/databases/#mysql-sql-mode
```

해결

```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'impactstation1',
        'USER': 'impactstation',
        'PASSWORD': 'save2020!',
        'HOST': 'database-1.cfmnthdcxoyk.ap-northeast-2.rds.amazonaws.com',
        'POST': '3306',
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'", # strict mode 설정 추가
        }

    }
}

```



[자세히](https://solt.tistory.com/61)

접속권한 [자세히](https://solt.tistory.com/61)

# Django static 파일 서비스

## static 경로 설정

```
우선 장고에서 static 파일들을 처리할 수 있도록 settings.py 를 설정을 해주자.

# settings.py

import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# static files
STATIC_URL = '/static/'  # STATIC_URL 이 선언되어 있는데, 이건 static 파일을 불러올 때의 URL이다
STATIC_DIR = os.path.join(BASE_DIR, 'static')
STATICFILES_DIRS = [
    STATIC_DIR,
]
지금까지는 위와 같이 설정해주고 static 폴더 안에 정적 파일들을 넣어 적용시켰었다.
이제 이 상태로 scp 로 서버에 업로드하면 css가 적용되어 있을까?
프로젝트 폴더에 static 폴더를 만들고 아무 내용이나 작성한 test.txt 파일을 하나 넣어두자.
일단 로컬에서 runserver 를 실행하고 localhost:8000/static/test.txt 로 접속하면 아래와 같이 test.txt 의 내용을 확인할 수 있다.
```

## STATICFILES_DIRS 경로 설정(static파일들이 어딧는지알려줘야하니까.)

```python
STATICFILES_DIRS = (
    os.path.join(BASE_DIR, "static"), # Root의 static 파일
    '/mainpages/static/',	# mainpages App의 static 파일
)
```

요청한 static 파일을 위에 설정한 경로 순서대로 찾게된다

## 불러오기

현재 /static 으로 불러오면 `/mainpages/static` 폴더를 찾아볼 것이다.

여기서 namespace로 불러오기 위해서 `/mainpages/static`폴더 안에 `mainpages` 폴더를 하나 더 만들고

, 그 안에서 static 파일을 불러올 것이다

```
mainpages/static/garden/style.css
body {
  background-color: red;
}
```

static 파일은 작성했고, 이제 Django 템플릿에서 불러보자

```
template.html
<html>
  <head>
    <title>Static 테스트</title>
    {% load static %}
    <link rel="stylesheet" href="{% static 'mainpages/style.css' %}">
  </head>
```

이렇게 static 앱을 load 하고 불러오면 된다

## 정적 파일 모으기

css파일 등과 같은 정적 파일들은 장고 내에 여러 폴더에 분산되어 있다.

예를 들어, 장고 관리자 페이지에 적용되는 정적 파일들은 아래 경로에 저장되어 있다.

```
/home/che1/.pyenv/versions/ec2_deploy/lib/python3.6/site-packages/django/contrib/admin/static/admin
```

또, 우리가 만든 정적 파일들은 아래 경로에 저장된다.

```
/home/che1/Projects/Django/EC2_Deploy_Project/mysite/static
```

이렇게 하나의 프로젝트에서 사용하는 정적 파일들은 여기저기에 분산되어 있기 때문에 요청이 들어왔을 때 필요한 정적 파일을 돌려주려면 많은 경로들을 다 찾아보아야 하며 이는 매우 비효율적일 것이다.

그래서 사용하는 모든 정적 파일을 하나의 경로로 모아주는 작업이 필요하다.
`runserver` 는 개발자가 개발에만 집중할 수 있도록 이 작업을 알아서 해준다. runserver는 알게모르게 알아서 해주는 편의기능이 아주 많다.
하지만 실제 서비스를 배포할때는 runserver를 사용하지 않으므로 직접 모아주어야 하며, 이 때 사용하는 것이 `collectstatic` 명령이다.

### collectstatic

`collectstatic` 파일은 프로젝트에서 사용하는 css, font, javascript 등 모든 정적 파일들을 모아서 하나의 경로에 모아준다.
collectstatic을 실행하기 위해서는 먼저 파일들을 __모을 경로를 지정__해주어야 하며 이 경로는 `settings.py` 의 `STATIC_ROOT` 라는 변수로 지정한다.

```
import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# static files
STATIC_URL = '/static/'
STATIC_DIR = os.path.join(BASE_DIR, 'static')
STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
#    'django.contrib.staticfiles.finders.DefaultStorageFinder',
)
STATICFILES_DIRS = [
    STATIC_DIR,
]

STATIC_ROOT = os.path.join(BASE_DIR, 'static')
```

프로젝트 루트의 상위 폴더에 `static` 라는 폴더를 생성하고 그곳으로 모든 정적 파일들을 모으도록 설정하였다.

 static  <-- collectstatic을 실행하면 생성될 폴더

collectstatic은 `settings.py` 의 `INSTALLED_APPS` 목록에 등록된 앱이 사용하는 모든 정적 파일들과 `STATICFILES_DIRS` 리스트에 명시된 경로에 있는 모든 정적 파일들을 한 곳에 모은다.
AWS 서버에 접속한 뒤 `manage.py` 가 있는 경로로 이동한 다음 아래 명령을 실행하여 정적 파일들을 모아보자.

`.static_root` 라는 폴더가 생성된 것을 볼 수 있으며 그 내용물은 아래와 같다.

```
├── admin
│   ├── css
│   ├── fonts
│   ├── img
│   └── js
└── test.txt
```

장고 관리자 페이지의 정적 파일들은 물론이고 우리가 만들었던 `static` 폴더 내의 내용물인 `test.txt` 파일도 가져와진 것을 볼 수 있다.

이 폴더의 내용물들은 이미 어딘가에 있는 정적 파일들을 __복사__해온 것이므로, 버전 컨트롤에서 제외시켜야 한다.
`.gitignore` 파일을 열어 `.static_root/` 를 추가해준다.

이제 서버에서 정적 파일을 요청하는 URL을 처리할 수 있게 해주어야한다

[자세히](https://nachwon.github.io/django-deploy-7-s3/)





-------------------

#### Django App의 Static 폴더

필요에 따라 각각의 Django App마다 App별 정적 파일을 담는 별도의 "static" 폴더를 둘 수도 있다. 이를 위해서는 settings.py 파일 안에 STATICFILES_FINDERS을 설정하고 그 값으로 AppDirectoriesFinder을 추가해 주어야 한다. 각 App의 static 폴더는 그 폴더명을 "static" 으로 지정해 주어야 하며, 일반적으로 App명/static/App명 과 같이 각 App의 static 폴더 안에 다시 "App명"" 서브폴더를 둘 것을 권장한다. 이는 Deployment 시 collectstatic 을 실행할 때, 각 static 폴더 밑의 내용을 그대로 복사하므로 동명 파일들이 충돌하지 않게 하기 위함이다.

```
STATICFILES_FINDERS ``=` `(``  ``'django.contrib.staticfiles.finders.FileSystemFinder'``,``  ``'django.contrib.staticfiles.finders.AppDirectoriesFinder'``,``)
```

참고로 위의 FileSystemFinder는 STATICFILES_DIRS 에 있는 경로들로부터 정적 파일을 찾을 수 있게 한다.

#### 3. Static 파일 사용

Static 파일들은 주로 템플릿에서 사용되는데, settings.py 설정을 마친 후 static 파일들을 사용하기 위해서는, 템플릿 상단에 {% load staticfiles %} 태그를 먼저 명시해 주어야 한다. 그리고, 실제 static 파일을 가리키기 위해서는 아래 link 태그에서 보이듯이 "{% static '리소스명' %}" 와 같이 static 템플릿 태그를 사용하여 해당 리소스를 지정한다. 이때 리소스명에는 "static/" 폴더명 다음의 경로만 지정한다.

```
{% load staticfiles %}

<html lang="en">
<head>
    <link rel="stylesheet" href="{% static 'bootstrap/css/bootstrap.min.css' %}">
</head>
<body>
</body>
</html>
```

#### 4. collectstatic

Django 프로젝트를 Deploy할 때, 흩어져 있는 Static 파일들을 모아 특정 디렉토리로 옮기는 작업을 할 수 있는데, 이 작업은 위해 "./manage.py collectstatic" 명령을 사용한다. 즉, collectstatic 명령은 Django 프로젝트와 각 Django App 안에 있는 Static 파일들을 settings.py 파일 안에 정의되어 있는 STATIC_ROOT 디렉토리로 옮기는 작업을 수행한다.

예를 들어, settings.py 에 다음과 같이 STATIC_ROOT 가 설정되어 있을 때,

```
STATIC_ROOT = '/var/www/myweb_static'
```

아래 collectstatic 명령은 모든 정적 파일들을 /var/www/myweb_static 디렉토리에 복사해 준다.

```
(venv1) /var/www/myweb $ ./manage.py collectstatic
```



