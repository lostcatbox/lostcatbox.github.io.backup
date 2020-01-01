---
title: Django 기본 첫번째이야기
date: 2019-11-01 15:01:55
tags: [Basic, Django]
categories: Django
---

# 장고

## 웹서비스 기본구조

- 백엔드개발(django) -focus!
- 프론트엔드 개발
- 백엔드 서버 운영: 다양한 클라우드
- 앱개발

## 웹 애플리케이션 기본 구조

- 클라이언트단: 웹브라우저 - 웹서버(django) - 데이터베이스서버(MySQL)
- 클라이언트가 웹서버에 요청
- 장고에서 URL(URLConf)을 기준(미리 URL별로 호출할 함수 등록해둠)> 뷰(함수)- return >URL>웹브라우져
- 뷰에서 DB가 필요할 경우 __모델(파이썬코드로 데이터베이스처리함)__ 통해서 가져옴!!
- 웹브라우저는 html을 요구함. 템플릿(HTML응답을 효과적으로 주기위한 HTML응답소스)을 통해 html로 넘길수있다



## 장고 따라가기

- dev> django-admin startproject askdjango 

  Django 프로젝트 생성 

- dev> cd askdjango

- dev/askdjango> python3 manage.py migrate

-  dev/askdjango> python3 manage.py createsuperuser 

- dev/askdjango> python3 manage.py runserver 

  디렉토리 이동 (cd : change directory) 

  Model 내역을 데이터베이스에 반영
  Superuser 계정 생성
   개발서버 구동 

# Django App, URLConf, Template

- 장고는 원프로젝트, 멀티 앱
- python3 manage.py startapp 이름 해서 앱생성후 프로젝트디렉토리 안에 인서트.py에 꼭 추가하기__(마지막 , 꼭쓰기)__

- 템플릿을 쓸때는 무조건 앱이름/post_list.html 방식으로쓰기(관리용이)

- import include, url 해서 url(r'^blog/', include('blog.urls')) 하면 url로 들어오면 blog에 urls.py를 실행

- 장고를 runserver를 할때 템플릿 다 읽고 시작하므로 새로 만들면다시 시작해야함

-  python3 manage.py runserver 0.0.0.0:8000 하면 로컬 서버 주소바꾸기가능

- ifconfig로 현재 자신의 있는 네트워크 ip주소알수있다. en0 >inet

- 외부망을 통해 다른기기에서 접속은 ngrok 쓰자 (로컬서버에 접속가능) (외부망설정 귀찮)__(./ngrok http 8000)(forwarding 주소로 ㄲ)__ (프로젝트에 setting.py > ALLOWED_HOSTS 에 앞에 주소 추가해주기, *로하면 모든 도메인 허용임)(ngrok는 주소는 변경됩니다. 고정은 유로임. )(테스트용)

- 하지만 모바일용에 적합하지 않으므로 템플릿에 추가하기( meta테그에 아래것추가) 

- 
  ```
  <meta name="viewport" content="width=device-width,initial-scale=1.0, minimum-scale=1.0,maximum-scale=1.0, user-scalable=no" />
  ```



- __앱추가시 꼭해야하는것: 프로젝트에 setting.py에 앱추가, urls.py 에 include, 새로한 앱안에 urls.py 만들기__
- 모든 view함수는 첫번쨰인자 (request)

# URLConf and Regular Expression

## 정규표현식(Regular Expression)

- 문자열의 패턴, 규칙을 정의하는 방법 을 통해 문자열 검색이나 치환작업을 간편하게 처리가능

- 파이썬3 정규표현식 라이브러리 (r)

- 다양한 정규표현식 패턴 예시
  
  > -  최대3자리숫자:"[0-9]{1,3}"혹은"\d{1,3}" 
  > -  휴대폰번호:"010[1-9]\d{7}"
  > -  한글이름2글자혹은3글자:"[ᄀ-힣]{2,3}"
  > -  성이"이"인이름:"이[ᄀ-힣]{1,2}" 

```
  val = "01092330203"
  
  if val.startswith("010") and len(11) == 11 and val[:3] in ("010", "011", "016"):
      print("ok")
  
  import re
  if re.match('^01[1-9]\d{6,7}$', val):
      print("matched")
  else:
      print("invalid")
  
  같은 것 수행
```

- > - 숫자 1글자 : "[0123456789]" 또는 "[0-9]" 또는 "\d"
  >
  > - > 알파벳 소문자 1글자 : "[abcdefghijklmnopqrstuvwxyz]" 혹은 "[a-z]"
  >   >
  >   >  알파벳 대문자 1글자 : [ABCDEFGHIJKLMNOPQRSTUVWXYZ]" 혹은 "[A-Z]" 
  >   >
  >   > 알파벳 대/소문자 1글자 : "[a-zA-Z]"
  >   >
  >   >  16진수 1글자 : "[0-9a-fA-F]"
  >   >
  >   >  문자열의 시작을 지정 : "^"
  >   >
  >   >  문자열의 끝을 지정 : "$"
  >   >
  >   >  한글 1글자 : "[ᄀ-힣]" 
  >
  > __한글자를 표현할때 그중한글자의 정보를 []에 담는다__ ex) "01[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]"
  >
  > - **반복횟수 지정** 
  >
  >   >  "\d?" : 숫자 0회 또는 1회
  >   >  "\d*" : 숫자 0회 이상
  >   >  "\d+" : 숫자 1회 이상
  >   >  "\d{m}" : 숫자 m글자
  >   >  "\d{m,n}" : 숫자 m글자 이상, n글자 이하 
  >   >
  >   > - 주의:정규표현식은띄워쓰기하나에도민감합니다.
  >   >
  >   > - \가 들어갈경우 맨앞에 r쓰고 "^~~~~~~~$"쓰기 (이걸해줘야 \ \ d 로 인식함)
  >
  > 



## URLConf

- 프로잭트/setting.py 에 최상위 URLConf모듈을 지정 (Root_urlconf 항목에 기본으로 프로젝트의 urls.py가 지정되있다)

  Root_url에서 서브로 url.py와 연결

- 특정URL과뷰매핑List 

- Django 서버로 Http 요청이 들어올 때마다, URLConf 매핑 List 를 처 

  음부터 끝까지 순차적으로 훝으며 검색합니다. 

- 매칭되는 URL Rule 을 찾지못했을 경우, 404 Page Not Found 응답 

  을 발생시킵니다.

  

## URLConf **정규표현식 매핑 연습**  

 

- (?P ) : 이 영역의 문자열에 정규표현식을 적용해서 !!!
- \d+ : \d+ 패턴에 부합된다면 
- <x> : x 라는 변수명으로 인자를 넘기겠다.
   • __뷰의인자로넘겨받은값들은모두문자열타입입니다.__ 

```
Example #4 하나의 뷰에 3개의 URL연결
url(r'^sum/(?P<x>\d+)/(?P<y>\d+)/(?P<z>\d+)/$', views.mysum) url(r'^sum/(?P<x>\d+)/(?P<y>\d+)/$', views.mysum) url(r'^sum/(?P<x>\d+)/$', views.mysum)
# views.py
def mysum(request, x, y=0, z=0):
return HttpResponse(int(x) + int(y) + int(z))Example #4 하나의 뷰에 3개의 URL연결
url(r'^sum/(?P<x>\d+)/(?P<y>\d+)/(?P<z>\d+)/$', views.mysum) url(r'^sum/(?P<x>\d+)/(?P<y>\d+)/$', views.mysum) url(r'^sum/(?P<x>\d+)/$', views.mysum)
# views.py
def mysum(request, x, y=0, z=0):
return HttpResponse(int(x) + int(y) + int(z))

result = sum(map(int, numbers.split("/"))) *#map은 리스트의 요소를 지정된 함수로 처리해주는 함수입니다
```

만약 넣은 것에 //100/234//45이라면 빈문자열이 생기므로 int""은 에러가뜸 

빈문자열을 없애줘야하므로  sum(map(lambda s: int(s or 0), numbers.split("/"))) 해야함 #or표현은 s가 거짓일떄 0으로 치환됨





# View

- URLConf에 매핑된 Callable Object
   • 첫번째인자로HttpRequest인스턴스를받습니다. • 필히HttpResponse인스턴스를리턴해야합니다. 

- 크게 Function Based View와 Class Based View로 구분 

- 요청에 대한 리턴값으로는 무조건 HttpResponse 인자값이여야함로 html을 직접써서 하던가, 템플릿을 활용한다

- >  from django.shortcuts import render
  >
  > render사용하여 render(request, 'myapp/post_list.html', {'name': name})  (템플릿!)

- 파일다운로드 

- 
```
def excel_download(request): 'FBV: 엑셀 다운로드 응답하기' 
  
  filepath = '/other/path/excel.xls' 
  filename = os.path.basename(filepath) 
  
  with open(filepath, 'rb') as f:
     # 필요한 응답헤더 세팅 
     response = HttpResponse(f, content_type='application/vnd.ms-excel') 
  
     response['Content-Disposition'] = 'attachment; filename="{}"'.format(filename) return response 
```



## 함수기반view 응답만드는4가지

- HttpResponse
- render(템플릿)
- json
- 파일 다운로드 



## 클래스기반 view

- ​    함수기반 뷰를 생성해주는 클래스

```
class SampleTemplateView(object):
 @classmethod
     def get(self, request):
         wejpfojwopejfw
         ewfpojwepfojwe
         wejfopwejopfew
         
     def as_view() #만들어줘야 함수처럼 다룰수있다
 
 예시@@@@@실행
 
fbv_view = SampleTemplateView.as_view()
```



# Model and Model Fields

## SQL (Structured Query Language) (꼭별도공부)

• Query : 정보 수집에 대한 요청에 쓰이는 컴퓨터 언어 (위키백과) 

• SQL : 관계형 데이터베이스 관리 시스템(RDBMS) (Relational Database Management System) 의 데이터를 관리하기 위해 설계된 특수 목적 으로 프로그래밍 언어 (위키백과) 

• RDBMS 종류 : PostgreSQL, MySQL, MariaDB 등

• 장고 모델은 RDBMS만을 지원 

• 장고 모델을 통해 SQL을 생성/실행 (이런것을ORM이라고함)

- Django 내장 ORM
- SQL을 직접작성하지않아도 장고 모델을 통해 데이터베이스로의 접근(조회추가수정삭제)
- __SQL을 몰라도 된다느 것은 아님. 최소한 내가 짠 코드가 어떤 SQL을 만들어내는지검증해야함__ 



##  DjangoORM 개념

- 엑셀처럼 하나 시트를 테이블이라함 = 이 DB테이블과의 매핑이 Model
- Model Instance= DB 테이블의 1 Row (엑셀에 행!!!!!!!)
- 엑셀의 여러 시트들 !!= DB



## Django Model 커스텀 모델 정의 (특정앱/models.py)

- 데이터베이스 테이블 구조/타입을 먼저 설계를 한 다음에 모델 정의 모델 클래스명은 단수형(Posts가 아니라, Post)

- 
```
  from django.db import models
       class Post(models.Model):
            title = models.CharField(max_length=100)
            content = models.TextField()
            created_at = models.DateTimeField(auto_now_add=True)
            updated_at = models.DateTimeField(auto_now=True)
   
```

-  **- DataBase의 구성요소**

  

  ![img](https://tva1.sinaimg.cn/large/006y8mN6gy1g88bng7r29j30id03cweo.jpg)

  

   

   파란색 박스 : 행 or 로우(raw) or 레코드(record)

   빨간색 박스 : 열 or 컬럼(column) or 필드(field)

- AutoField, BooleanField, CharField, DateTimeField, FileField, ImageField, TextField, ForeignKey, ManyToManyField, OneToOneField 많이 쓰는 필드임 

- 데이터베이스 데이터타입과  파이썬 데이터타입을 매핑

  >  AutoField (int), BinaryField (bytes), BooleanField (bool), NullBooleanField (None, bool), CharField/TextField/ EmailField/GenericIPAddressField/SlugField/URLField (str) 

-  같은 파이썬 데이터타입에 매핑되더라도, "데이터 형식" 에 따라 여러 Model Field Types 로 나뉨

- 자주 쓰는 필드 옵션(모든 데이터필드가능)(연습필요,, 진짜 유용함)

- > • null (DB 옵션) : DB 필드에 NULL 허용 여부 (디폴트 : False)(null의미는 데이터존재x)
  >
  > • unique (DB 옵션) : 유일성 여부
  >
  > • blank : 입력값 유효성 (validation) 검사 시에 empty 값 허용 여부 (디폴트 : False) 
  >
  > • default : 디폴트 값 지정. 값이 지정되지 않았을 때 사용. • 인자없는 함수 지정 가능. 함수 지정 시에는 매 리턴값이 필요할 때마 다 함수를 호출하여 리턴값을 사용
  >
  > • choices (form widget 용) : select box 소스로 사용 
  >
  > • validators : 입력값 유효성 검사를 수행할 함수를 다수 지정
  >
  > > - 각 필드마다 고유한 validators 들이 이미 등록되어있기도 함
  > >
  > > - ex) 이메일만 받기, 최대길이 제한, 최소길이 제한, 최대값 제한, 최소 값 제한, etc. 
  >
  > • verbose_name : 필드 레이블. 지정되지 않으면 필드명이 쓰여짐.
  >
  > • help_text (form widget 용) : 필드 입력 도움말 
  >
  > (~/nomade/django/askdjango/blog/models.py)

- 데이터 정의 후에는 makemigrations, migrate 통해 DB에 반영하고 해당 앱에 admin에서

```
  from .models import Post
  
  admin.site.register(Post) 
```

- (지금까지과정이 모델정의  정의후에 이대로 DB생성후 admin에 모델에 모델에Post라는 클래스로 등록시킴)





# Migration

## 관련 명령

쉘> python manage.py makemigrations   <app-name>마이그레이션 파일 생성 #앱이름 꼭적기.. 이것만 하니까.

쉘> python manage.py migrate <app-name>  #마이그레이션 적용  (이미적용한 마이그레이션은 지우지마라 헬게이트)

쉘> python manage.py showmigrations  <app-name>#마이그레이션 적용 현황 

쉘> python manage.py sqlmigrate <app-name> <migration-name or 유일한 일부의 미그레이션 파일 이름>  #지정 마이그레이션의 SQL내역 ex) 0002



## 마이그레이션 파일 생성 및 적용

- makemigrations로 마이그레이션 파일(작업 지시서)(__적용전에 무조건까서확인해야함!__ )(SQL용어로도 확인하면좋음)
- migrate로 데이터베이스에 마이그레이션 파일을 반영함
- 참고로 현재 sqlite3를 쓰고있는데 DB형태 변경은 프로젝트 dir에 setting.py 에 DATABASES 확인 변경
- 눈으로 DB보고싶으면 DBLiteBrowser설치



## Migration 정방향(forward) 역방향(reverse)

- 마이그레이션 적용된것이 blog/0007인상태에서 역방향가고싶으면  (내 현재위치기준으로 정, 역 정해짐)

- 
```
  python3 manage.py migrate blog 0006 #zero라고하면 모든 마이그레이션 적용모두 취소
```



## id필드는 왜 기본임?

 • 모든 데이터베이스 테이블에는 각 Row 의 식별기준인 "기본키 (Primary Key)" 가 필요

 • Django 에서는 기본키로서 id 필드(AutoField)가 디폴트 지정

 • 기본키는 줄여서 pk 로도 접근 가능 (primary key)



## 기존 모델 클래스에 필수필드를 추가하여 makemigrations 수행

필수필드는 인자가있어야만 DB에저장할수잇는것 

(blank, null가 기본적으로 False이므로 따로True지정안하는이상 필수필드됨임)

필수필드를 추가하므로, 기존 Row들에 필드를 추가할때, 반드시 채워넣어야하므로 어떤 값으로 채워넣을 지 묻습니다

> 선택1) 지금 값을 입력!!! 새로생기는 필드의기존빈것들전체동일적용됨 (반드시 필드타입확인후 같은 타입 입력 (int str,,,등)
>
> 선택2) 모델 클래스를 수정하여 디폴트 값을 제공



# Django Shell

장고 모듈등을 사용할려면 필히 장고 환경에 접근해야하므로 (일반 파이썬셀은 접근불가함)(장고프로젝트에 setting.py에존재)

```
python3 manage.py shell #장고환경 접근가능!
pip3 install "ipython[notebook]" #쥬피터랑 아이파이선 둘다 설치됨
```

## Jupyter Notebook 으로 장고쉘 띄우기

```
pip3 install django-extensions 설치후에 프로젝트 settings.py내 INSTALLED_APPS에 django_extensions추가해야함 !!! 이것은 앱형태이므로!!!
```

실행하려면

```
python manage.py shell_plus #쉘에서 필요한것 자동으로 import해줌
python manage.py shell_plus--notebook  #쉘에서필요한것 자동으로 import해줌
```

__쥬피터 노트북이 유리한이유는 log남길수있고 이미지등도 확인할수있고 즉각적이라 더욱 좋다__

```
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproj.settings') # FIXME: 경로 확인
import django
django.setup()
# 지금부터 모든 장고환경에 접근 가능
from blog.models import Post
하면 일반 셀에서도 가능
```





# Django Admin

staff/superuser만 접근가능 (Users에서 권한 부여가능)

모델 클래스만 등록하면, 조회/추가/삭제 가능 (#ModelCls 는 모델에 클래스 이름을 적으면됨)

```
admin에 DB등록하는 법!
1.

관리하고 싶은 앱에 admin.py에 가서 
 from .models import ModelCls  #클래스이름

admin.site.register(ModelCls)  #클래스이름    
#이미등록되어있다면 unregister(Post)다음에 재등록해야함
하면 admin에서 접근가능함


2.해당 앱에 admin에서
class PostAdmin(admin.ModelAdmin):
      list_display = ['id', 'title', 'content']
admin.site.register(Post, PostAdmin) # 참고: 같은 모델 중복 등록은 불가 #이렇게하면 admin에 필드로추가됨

2. 장식자 형태로 지원
@admin.register(Post) #이부분이 바로위에 코드 대신해서 씀. 같은 역할
class PostAdmin(admin.ModelAdmin):
       list_display = ['id', 'title', 'content']
      
```



##  ModelAdmin Options (admin.ModelAdmin)

• list_display  : Admin 목록에 보여질 필드 목록. 

• list_display_links  : 목록 내에서 링크로 지정할 필드 목록. #이를 지정하지 않으면, 첫번째 필드에만 링크가 적용

• list_editable  : 목록 상에서 수정할 필드 목록 

• list_per_page  (디폴트 : 100) : 페이지 별로 보여질 최대 갯수

• list_filter: 필터 옵션을 제공할 필드 목록

• actions : 목록에서 수행할 action 목록 

위에가 쉽게 쓰임.

• fields: add/change 폼에 노출할 필드 목록

• fieldsets: add/change 폼에 노출할 필드 목록 (fieldset) 

• formfield_overrides : 특정 Form Field 에 대한 속성 재정의 

• form : 디폴트로 모델 클래스에 대한 Form Class 지정



### list_display 옵션

- 모델 인스턴스 필드명/속성명/함수명 뿐만 아니라, ModelAdmin 내 맴버 함수도 지정가능

  
```
  @admin.register(Post)
  class PostAdmin(admin.ModelAdmin):
   list_display = ['id', 'title', 'content']
   def content_size(self, post):
   return '{}글자'.format(len(post))
   content_size.short_description = '내용 글자수'
   #강조하고싶다면 mark_safe을 import해서 해보기  #이렇게 따로 지정해줘야하는이유는 <tag></tag>가 유저가 사용하면 html에서 변형되어 태그 그대로 나오지 않도록 방지하므로 태그이스케이프기능이 켜져있다.
```

### Admin Actions

대개 선택된 Model Instance 들에 대해 Bulk Update 용도 구현 #한번에 여러개 인스턴스 업데이트

1. ModelAdmin 클래스내 멤버함수로 action 함수를 구현
   - 멤버함수.short_description 을 통해, action 설명 추가 
2. ModelAdmin actions 내에 등록 #모든액션 첫번째인자는 request 두번째 queryset

아래는 이페이지 완성될때 model.py에 모델클래스

```
from django.db import models
import re
from django.forms import ValidationError

def lnglat_validator(value):
     if not re.match(r'^([+-]?\d+\.?\d*).([+-]?\d+\.?\d*)$', value):
          raise ValidationError('Invalid LngLat Type')



class Post(models.Model):
    STATUS_CHOICES = (
        ('d', "Draft"),
        ('p', 'Published'),
        ('w', 'Withdrawn'),
    )
    title = models.CharField(max_length=100, verbose_name="제목",
    help_text="포스팅 제목을 입력해주세요",
    choices = (
        ('제목1', '제목1 레이블'), #('저장될 값', 'UI에 보여질 레이블')
        ('제목2', '제목ㅈ 레이블'),
        ('제목4', '제목ㄷ 레이블'),
    )) #길이 제한이 있는 문자열
    tags = models.CharField(max_length=100, blank=True)
          #blank 디폴트는 false임 즉, 기본은 필수요소임
    Inglat = models.CharField(max_length=50, blank=True,
    validators=[lnglat_validator],
    help_text="경도/위도 포맷으로 입력")
    content = models.TextField(verbose_name="내용") #길이 제한이 없는 문자열 #DB는 문자열길이차이에서 구별필요하므로 속도차이
    status = models.CharField(max_length=1, choices=STATUS_CHOICES)
    created_at = models.DateTimeField(auto_now_add=True) #날짜시간 필드
    updated_at = models.DateTimeField(auto_now=True)


    def __str__(self):
        return self.title

    class Meta:
        ordering = ['-id'] #이 필드에 대해서 내림차순 정렬
```







# CRUD



## Model Manager

- 데이터베이스 질의 인터페이스를 제공

- 디폴트 Manager로서 ModelCls.objects가 제공 ex) post.objects.all()

- 
```
  ModelCls.objects.all() # 특정 모델의 전체 데이터 조회
  ModelCls.objects.all().order_by('-id')[:10] # 특정 모델의 최근 10개 데이터 조회
  ModelCls.objects.create(title="New Title") # 특정 모델의 새 Row 저장
```





## QuerySet (알아서 SQL언어로 변경해줌)

- SQL을 생성해주는 인터페이스!
- Model Manager 를 통해, 해당 Model 에 대한 QuerySet 을 획득
-  Post.objects.all() 는 "SELECT * FROM post;" 와 같은 SQL 을 생성하여, 데이터베이스로의 질의를 수행
-  Post.objects.create(...) 는 "INSERT INTO ...;" 와 같은 SQL을 생성하여, 데이터베이스로의 질의를 수행
- __Chaining 지원__ : QuerySet 수행 리턴값이 다시 QuerySet



## 데이터베이스에 데이터 조회 요청 (retrieve)

- QuerySet을 통한 AND 조회 조건 추가 (아래 예시들은 모두 AND조건으로추가됨) (ModelCls는 내가쓴 모델클래스이름)

- 
```
  queryset = ModelCls.objects.all() #아래예시는 모두 이어지는것 #filter대신 exclude쓰면 and조건으로제외
  queryset = queryset.filter(조건필드1=조건값1, 조건필드2=조건값2) 
  #Chaining지원이므로 쿼리셋리턴값 퀴리셋임
  queryset = queryset.filter(조건필드3=조건값3) #계속 퀴리셋으로 추가됨
  queryset = queryset.filter(조건필드4=조건값4, 조건필드5=조건값5) 
  #여기까지하면 즉 queryset이 모두1,2,3,4,5 조건필드1,2,3,4,5에 각자 맞는 조건값을 가진것이 and조건을 찾는 SQL명령어생성됨, 실행은 아직안됨
```

-  or조건으로 할려면 

- 
```
  from django.db.models import Q
  Post.objects.filter(Q(title__icontains='1')|Q(title__endswith="3")) #|가 or를 뜻하지
```

- queryset은 명령을 대기중이며 실제로 DB접근하는건 다른 명령이 수행될때임 즉위에코드는 계속 명령작성추가하는거임




- render에서 *render에 3번쨰 인자로 딕셔너리 형태로 다양한 인자들을 넘겨줄수있다,*

```
blog/view.py
def post_list(request):
    qs = Post.objects.all()

    q = request.GET.get('q', '') #검색이라는 요청에 새로고침되면서 request에서 나오는 q인자  있다면 q가져오고 없다면 ''으로가져와 객체 q로함 
    if q: #q가 True이면 
        qs = qs.filter(title__icontains=q)

    return render(request, 'blog/post_list.html', {'post_list':qs, 'q':q}) 
    #render에 3번쨰 인자로 딕셔너리 형태로 다양한 인자들을 넘겨줄수있다
    # 템플릿에서 q라는 이름의 인자를 넘겨주는걸만들었으므로 
    
템플릿.blog.post_list.html은


<form action="" method="get">
       <input type="text" name="q" value="{{q}}" />
       <input type="submit" value= "검색" />


</form>
되어있어서 submit일어나면 새로고침되면서 주소에마지막에 /q=  가 생기면서 input받았던걸 q인자로 views.py다시시작
```



# 데이터베이스에 특정 필드로 정렬 조건 추가

- queryset내 기본정렬은 모델내 Meta.ordering설정을 따릅니다. 

```
  - class Post(models.Model):  (필드 정의 생략)
  
           class Meta: ordering = ['id']       (클래스안에클래스)
  
  
```

  

  

- 필드명만 지정시 오름차순 정렬 요청, "-필드명" 지정시 내람차순 정렬 요청 정렬 미지정시에는 데이터베이스 측에서 임의정렬 

```
  # 모델 Meta.ordering 을 무시하고, 직접 정렬조건 지정하는법
  queryset = queryset.order_by('field1') # 지정 필드 오름차순 요청 
  queryset = queryset.order_by('-field1') # 지정 필드 내림차순 요청 queryset = queryset.order_by('field2', 'field3') # 1차기준, 2차기준
```

  

  # 슬라이싱을 통한 범위 조건 추가

  

  queryset = queryset[:10]     # 현재 queryset에서 처음10개만 가져오는 조건을 추가한 queryset queryset = queryset[10:20]      # 현재 queryset에서 처음10번째부터 20번째까지를 가져오는 조건을 추가한 queryset 

  -  리스트 슬라이싱과 거의 유사하나, 역순 슬라이싱은 지원하지 않음 

    > queryset = queryset[-10:]  (AssertionError 예외 발생 AssertionError: Negative indexing is not supported.)

  -  이때는 먼저 특정 필드 기준으로 내림차순 정렬을 먼저 수행한 뒤, 슬라이싱 

    > queryset = queryset.order_by('-id')[:10]

  # 지정 조건으로 DB로부터 데이터를 Fetch(가져오기)

  - __지정 조건의 데이터 Row를 순회__

    >  for model_instance in queryset:
    >
    > ​            print(model_instance)

  - 지정 조건 내에서 특정 인덱스 데이터 Row를 Fetch 

    >  model_instance = queryset[0] # 갯수 밖의 인덱스를 요청할 경우 IndexError 예외 발생 model_instance = queryset[1]

  -  __특정 조건의 데이터 Row 1개 Fetch (1개!! 2개이상말고 1개!! 0개말고 1개!!)__

    > model_instance = queryset.get(id=1) 
    >
    > model_instance = queryset.get(title='my title')

  - queryset.get은 예상되는 데이터가 1개일떄만 에러안뜨고 정상 처리

  - qureyset.first() 혹은 queryset.last() 

    > 지정 조건 내에서 첫번째/마지막 데이터 Row를 Fetch, 지정 조건에 맞는 데이터 Row가 없더라도, DoesNotExist 예외가 발 생하지 않고, None을 반환

  # 데이터베이스에 데이터 추가 요청 (create)

  

(필수 필드1를 모두 지정을 하고, 데이터 추가가 이뤄져야합니다. • 그렇지 않으면, IntegrityError 예외 발생)



- 방법 #1) 각 Model Instance 의 save 함수를 통해 저장

```
  >>> model_instance = ModelCls(field1=value1, field2=value2) # New Model Instance
  >>> print(model_instance.id) # 데이터베이스 저장 전이므로, None값을 가진다.
  None
  >>> model_instance.save() # 데이터베이스에 저장을 시도하고, DB로부터 id할당받음
  >>> print(model_instance.id) # 자동증가된 값이 지정
```

  

- 방법 #2) 각 Model Manager 의 create 함수를 통해 저장

```
  >>> 인스턴스 = ModelCls.objects.create(필드명1=값1, 필드명2=값2) # DB에 저장을 시도
  >>> print(인스턴스.id) # DB로부터 id할당받음
```

  



# 데이터베이스에 데이터 갱신 요청



- 방법 1) 각 Model 인스턴스 속성을 변경하고, save 함수를 통해 저장 • 각 Model 인스턴스 별로 SQL 이 수행 • 다수 Row 에 대해서 수행 시에는 성능저하가 발생할 수 있음

```
  >>> post = Post.objects.get(id=1)
  >>> post.tags = 'Python, Django'
  >>> post.save()
  >>> queryset = Post.objects.all()
  >>> for post in queryset:
  >>> post.tags = 'Python, Django'
  >>> post.save() # 각 Model Instance 별로 DB에 update 요청
```

  

- 방법 2) QuerySet 의 update 함수에 업데이트할 속성값을 지정하여 일괄 수정 하나의 SQL 로서 동작하므로, 동작이 빠르다.

```
  >>> queryset = Post.objects.all()
  >>> queryset.update(tags="Python, Django") # 일괄 update 요청
  
  • Tip : 데이터베이스에는 UPDATE SQL이 전달
  UPDATE blog_post SET tags='Python, Django';
```



# 데이터베이스에 데이터 삭제 요청

- 방법 1) 각 Model 인스턴스의 delete 함수를 호출하여, 데이터베이스 측의 관련 데이터를 삭제

```
• 각 Model 인스턴스 별로 SQL 이 수행
• 다수 Row 에 대해서 수행 시에는 성능저하가 발생할 수 있음
>>> post = Post.objects.get(id=1)
>>> post.delete()
>>> queryset = Post.objects.all()
>>> for post in queryset:
>>> post.delete() # 각 Model Instance 별로 DB에 delete 요청
```



- 방법 2) QuerySet 의 delete 함수를 호출하여, 데이터베이스 측의 관 련 데이터를 삭제

```
하나의 SQL 로서 동작하므로, 동작이 빠르다.
>>> queryset = Post.objects.all()
>>> queryset.delete() # 일괄 delete 요청
• Tip : 데이터베이스에는 DELETE SQL이 전달
DELETE FROM blog_post;
```



# 웹서비스, 각 요청 반응속도에서의 병목

> 데이터베이스 : 아주 중요
>
>  • DB로 전달/실행되는 SQL갯수를 줄이고 
>
> • 각 SQL의 성능/처리속도 최적화가 필요
>
>  • 로직의 복잡도 : 중요 • 프로그래밍 언어의 종류 : 대개는 미미

tip

> django-debug-toolbar
>
>  • 현재 request/response 에 대한 다양한 디버깅 정보를 보여줍니다.
>
>  • SQLPanel을 통해 각 요청 처리 시에 발생한 SQL 내역 확인 가능      • 웹서비스 성능과 직결 = 응답속도
>
> > \# 프로젝트/settings.py
> >
> > INSTALLED_APPS = [..., "debug_toolbar"]
> >
> >  MIDDLEWARE = ["debug_toolbar.middleware.DebugToolbarMiddleware", ...]
> >
> >  INTERNAL_IPS = ["127.0.0.1"] 
> >
> > \#프로젝트/urls.py
> >
> >  from django.conf import settings
> >
> >  from django.conf.urls import include, url
> >
> > if settings.DEBUG: 
> >
> > ​         import debug_toolbar 
> >
> > ​           urlpatterns += [ url(r'^__debug__/', include(debug_toolbar.urls)), ]
> >
> > > /<body>/</body>  꼭 바디테그가 필요함( 바디테그에 대입해서 툴바가 나오므로)









