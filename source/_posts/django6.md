---
title: Django 기본 여섯번째이야기
date: 2019-11-26 18:46:46
categories: Django
tags: [Basic, Django]
---

#  User Authentication Custom

## 회원가입 UserCreationForm 커스텀

- case 1) 기존 username/password만 입력. email 추가 입력받기

```
# accounts/forms.py
from django import forms
from django.contrib.auth.forms import UserCreationForm
class SignupForm(UserCreationForm):
 	class Meta(UserCreationForm.Meta):
 			fields = UserCreationForm.Meta.fields + ('email',)
```

 accounts.views.signup 뷰 Form Class를 SignupForm으로 변경

(그냥 class Meta로 할경우 기존 Meta정보를 다 삭제후 적는것이므로 model도 지정안되있음)

(따라서 class Meta(UserCreationForm.Meta)로 상속받은후 오버라이딩 필요)



__이미 user 데이터베이스에는 기본으로 email 필드가있으므로 가능__





- case 2) phone_number 추가 입력받기

  ModelForm은 하나의 모델만 지원합니다. 따라서 Profile 모델 정의하고, User 모델 인스턴스 생성 시 에 Profile 모델 인스턴스도 같이 생성해줍시다.!!

```
# accounts/models.py
from django.conf import settings
from django.core.validators import RegexValidator
from django.db import models

class Profile(models.Model):
   user = models.ForeignKey(settings.AUTH_USER_MODEL)
   phone_number = models.CharField(max_length=20, validators=[RegexValidator(r'^010[1-9]\d{7}$')])
   
# accounts/forms.py
from django import forms
from django.contrib.auth.forms import UserCreationForm

class SignupForm(UserCreationForm): 
   phone_number = forms.CharField()
         def save(self):
             user = super().save()
             profile = Profile.objects.create(
             user=user,phone_number=self.cleaned_data['phone_number'])
             return user
```





## 로그인 AuthenticationForm 커스텀

- username/password 와 더불어, 숫자 퀴즈를 맞혀야 로그인

```
# accounts/forms.py
from django import forms
from django.contrib.auth.forms import AuthenticationForm

class LoginForm(AuthenticationForm):
   answer = forms.IntegerField(label='3+3=?')

   def clean_answer(self):
       if self.cleaned_data.get('answer', None) != 6:
             raise forms.ValidationError('땡~!!!')
 
# accounts/urls.py
url(r'^login/$', auth_views.login, name='login', kwargs={
     'authentication_form': LoginForm,
     'template_name': 'accounts/login_form.html',
})
```

form.is_valid() 작업시 모든 필드가 유효성검사 통과 해야하므로 모든 필드명 true해야함, 폼클래스에 clean_필드명 함수를 해놔야함,  이미 AuthenticationForm을 상속받았기때문에 다른 로그인관련된인자는 이미 유효성검사할수있음. 내가 추가해준 필드만 검사로직 추가해주면됨



# select_related와 prefetch_related

## 웹서비스, 각 요청 반응속도에서의 병목 (django debugtool쪽에 설명참조)

- __데이터베이스__ : 아주 중요 , DB로 전달/실행되는 SQL갯수를 줄이고
  - 절대적인 SQL갯수를 줄이고(__조회 SQL의 경우 "JOIN"을 통해 쿼리갯수를 줄일 수 있음__)
  - 각 SQL의 성능/처리속도 최적화가 필요 

- __로직의 복잡도 : 중요__
- 프로그래밍 언어의 종류 : 대개는 미미

\# 현재장고는 Model이 SQL구문을 생성해주고 이 SQL이 DB가 처리함.그리고 SQL로 돌려줌



## DB단/파이썬단 조인을 통한 조회쿼리 성능 향상

HOW ?

- ForeignKey 혹은 OneToOneField 관계

  - QuerySet.select_related()

    (ForeignKey예시: class Comment안에 post = ForeignKey(Post)같이 외래키가 Post이므로 Comment에서 Post를 찾아들어갈때를 .select_related() )

- ManyToManyField 혹은 ForeignKey의 reverse relation

  - QuerySet.prefetch_related()

    ( ForeignKey의 reverse relation 예시: Post측에는 외래키정해져있지않은데 외래키를 찾아들어가는것이므로 Post에서 Comment찾아들어감 .prefetch_related() )

- 사용이유는 106SQL 쿼리인게 위에 두개 사용하면 6SQL에 시간은 5배줄어든다



## QuerySet.select_related()

(ForeignKey 혹은 OneToOneField관계시 사용)

```
from blog.models import Comment    #Post와 1:N의 관계

qs = Comment.objects.all()      #DB에 아직 접근안함, qs만작성됨
for comment in qs: # 첫 Fetch시에 DB 쿼리 : 1건  #DB  접근! 필요하니까, 모든것조회
 print(comment) # 이미 로딩되어있기 때문에, 추가 DB 쿼리 없음.
 print(comment.post) # comment별로 post 획득을 위해 DB 쿼리 : N건 (필요할떄 DB접근이므로 각 comment별로 전부 접근함 N번)
 
SQL 수행내역 : 1개 + Comment갯수

-- 처음 1회 수행
SELECT * FROM "blog_comment" ORDER BY "blog_comment"."id" DESC;

   -- 매 comment마다 수행
   SELECT * FROM "blog_post" WHERE "blog_post"."id" = 개별_post_id;
```



```
tip: DB에 대량생산후 저장

for i in range(100):
    ...:     comment = Comment()
    ...:     comment.post = random.choice(post_list)
    ...:     comment.author = 'spicyhoro'
    ...:     comment.message = 'bluk comment'
    ...:

```

### QuerySet.select_related() 적용

- ForeignKey/OneToOneField 관계에서 Lazy하게 쿼리하지 않고, INNER JOIN 으로 쿼리할 수 있습니다.

```
from blog.models import Comment

qs = Comment.objects.all().select_related('post') # ('필드명')써주기
for comment in qs: # 첫 Fetch시에 DB 쿼리 : 1건
   print(comment) # 이미 로딩되어있기 때문에, 추가 DB 쿼리 없음.
   print(comment.post) # 첫 DB 쿼리 시에 이미 post record까지 로딩했기 때문에, 추가 DB 쿼리 없음.
 
 
SQL 수행내역 : 1개

SELECT * FROM "blog_comment"
 INNER JOIN "blog_post" ON ("blog_comment"."post_id" = "blog_post"."id")
 ORDER BY "blog_comment";
```

## QuerySet.prefetch_related()

(ManyToManyField 혹은 ForeignKey의 reverse relation)

#Post:Comment=1:N관계에서 comment쪽에서는 comment.post하면 접근가능하지만

post쪽에서는 인자가 없으므로 post.comment_set이렇게 하면 접근가능하다.

(Comment.objects.filter(post=post)와 완전히 같다)

```
from blog.models import Post

qs = Post.objects.all()
for post in qs:
     print(post)
     print(post.comment_set.all())  #ForeignKey의 reverse relationship
     print(post.tag_set.all()) #ManyToMany!
     
SQL 수행내역 : 1개 + Post갯수 * 2

-- 처음 1회 수행
SELECT * FROM "blog_post";
-- 매 post마다 수행
SELECT * FROM "blog_comment" WHERE "blog_comment"."post_id" = 개별_post_id;
SELECT * FROM "blog_tag"
 INNER JOIN "blog_post_tag_set" ON ("blog_tag"."id" = "blog_post_tag_set"."tag_id")
 WHERE "blog_post_tag_set"."post_id" = 개별_post_id;
```

```
# 클래스 기반 뷰에서는 (queryset=Post.objects.all().prefetch_related())를 따로 지정하므로써 디폴트값에서 바꿀수있다.
#첫번째 방법
post_list = ListView.as_view(model=Post,
                             queryset=Post.objects.all().prefetch_related('tag_set', 'comment_set'),
                             paginate_by=10)
                             
#두번째 방법 
class PostListView(ListView):
        model = Post
        queryset = Post.objects.all().prefetch_related('tag_set', 'comment_set')
        paginate_by = 10
        
post_list = PostListView.as_view() 
해도됨
```

## django admin에 적용

### select_related

방법1) ModelAdmin.list_select_related 옵션 적용(장고가자동으로)

```
class CommentAdmin(admin.ModelAdmin): 
       list_select_related = ['post'] 
```

방법2) ModelAdmin.get_queryset 멤버함수 재정의를 통해 적용

```
 class CommentAdmin(admin.ModelAdmin): 
  		def get_queryset(self, request):
      		qs = super().get_queryset(request)  
      		return qs.select_related('post')
```



### prefetch_related

ModelAdmin.get_queryset 멤버함수 재정의를 통해 적용

```
class PostAdmin(admin.ModelAdmin):
    def get_queryset(self, request):
         qs = super().get_queryset(request)
         return qs.prefetch_related('commet_set')
```





```
#admin.py

@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ['id', 'title', 'tag_list', 'status', 'content_size','created_at', 'updated_at']
    actions = ['make_draft','make_published']

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        return qs.prefetch_related('tag_set')

    def tag_list(self, post):
        return ','.join(tag.name for tag in post.tag_set.all()) #리스트로 가져오는 문법
```





# Error Logging

## 로그

특정 형식으로 현 상황을 기록하는 문자열 기록 

- 디버그 로그 : 디버깅을 목적으로 자세하게 로깅 

- 웹서버 ACCESS LOG / ERROR LOG 

  [09/Feb/2017 07:04:26] "GET /blog/1/ HTTP/1.1" 200 18314  \#(시간, 방식, url, http버전 응답상태 응답사이즈)

  [09/Feb/2017 07:04:33] "GET /blog/6/ HTTP/1.1" 200 12314

- 오류 로그 : 오류에 대한 자세한 정보를 로깅 (절대 상상하지 마세요.)
-  그 외 다양한 상황을 기록



## logging

파이썬 빌트인 logging #ref 모듈을 통해 지원 장고 로깅 설정은 logging.config.dictConfig #ref 포맷을 사용

- Loggers
- Handlers
- Filters
- Formatters: LogRecord 속성 지원

### logger

named bucket을 지정하여, 현 모듈에서 쓸 logger 획득 지원 

Level(경고메세지 레벨지정) : debug, info, warning, error, critical



```
# myapp/views.py
import logging
logger = logging.getLogger('myapp.views') #뒤에이름을 가진 logger가 생성됨(namespace역할)

def post_list(request):
 		logger.error('Something went wrong!') # error레벨로 메세지 남김
```

### named bucket

- 마침표로 parent/child 계층 구분

   ex) django.security.csrf 로그: django.security(자식)와 django(부모)에 전파, 정보둘다가짐

- 부모 namespace로의 전파를 막을려면, 해당 handlers에 propagate=False 설정

- django에서 사용중인 named bucket

  > •  django • django.contrib.gis • django.db.backends • django.db.backends.schema • django.request • django.security.csrf • django.server • django.template • etc



## sentry(오류로깅 처리해줌)

- Error 로깅은 Sentry 를 이용하시면 편리
  - 지원 언어/플랫폼 : Python, JavaScript, PHP, Ruby, Java, Cocoa, C#, Go, Elixir 
- 실 서버 배포했을 때, 오류현황을 모아서 볼 수 있고, 이메일 알림도 지원
- 서비스 버전 pricing 및 설치 버전



### sentry 서비스, 장고설정

1. 설정방법

   쉘> pip install raven

```
https://sentry.io/organizations/spicyhoro/issues/1362602338/?project=1838267&query=is%3Aunresolved#
```

2. 연동테스트

   

   

## 참고) logging.config.dictConfig 포맷

example : #1, #2 

version: dictConfig 포맷 버전. 1로 지정

 root : 최 상위 핸들러 정의

 loggers : named bucket 별 수행할 "log 핸들러" 지정 

handlers : 핸들러 별 수행할 Handler 클래스 지정 

formatters : 로그 문자열 포맷 정의 

filters : 핸들러가 호출될 조건 정의



#  OAuth 회원가입과 동시에 로그인

## OAuth 

- OpenID 로 개발된 표준 인증 방식 
- 각 서비스 별로 제 각각인 인증방식을 표준화한 인증방식 
- 인증을 공유하는 애플리케이션끼리는 별도의 인증이 필요없음.
- 하지만 회사별로 OAuth Provider에 따라 조금씩 다름



## 다양한 장고 OAuth 라이브러리

- django-allauth 
- django-oauth-toolkit
-  python-social-auth #ref

## django-allauth

- 라이브러리 설치: 라이브러리 설치 : pip3 install "django-allauth==0.31.0"



- 다양한 로그인 방법 (Provider) 지원
  - daum, kakao, naver, facebook, google, linkedin 등

- 적용할 Provider를 settings/INSTALLED_APPS 에 추가하고, admin 페이지를 통해 SocialApplication 등록 (client key/secret)(이것이 SocialApplication에 등록되어있다

### 설정법

```
# 프로젝트/settings.py

아래 설정을 추가한 후에, migrate 필요

#앱 등록 및 사용할 Provider 등록
INSTALLED_APPS = [
 # 중략
 'django.contrib.sites',  #무조건 필요
 'allauth',
 'allauth.account',
 'allauth.socialaccount',
 'allauth.socialaccount.providers.facebook',
 'allauth.socialaccount.providers.kakao',
 'allauth.socialaccount.providers.naver',
]

AUTHENTICATION_BACKENDS = [
 'django.contrib.auth.backends.ModelBackend', # 기본 인증 백엔드
 'allauth.account.auth_backends.AuthenticationBackend', # 추가 
 ]
 
 
# 디폴트 SITE의 id
# 등록하지 않으면,각 요청 시에 host명의 Site 인스턴스를 찾습니다.
SITE_ID =1   #멀티사이트도가능(장고가 프로젝트하나에 여러 도메인 가질수있으므로)

# 이메일 확인을 하지 않음.
SOCIALACCOUNT_EMAIL_VERIFICATION = 'none' (가입확인 메일을 보내지않음)
(우리는 바로 가입시킬꺼임, 중복이아니라면)
```

<br></br>

```
# 프로젝트/urls.py

urlpatterns = [
 path('accounts/', include('allauth.urls')),
]

주의 : include 시에는 url pattern 끝에 $를 붙이지 마세요.
```



<br></br>

```
# accounts/views.py

settings.py에 세팅된 Provider별 설정현황을 social_app 속성으로 지정, 즉 로그인페이지에 보여 

from django.contrib.auth.views import login as auth_login
from allauth.socialaccount.models import SocialApp
from allauth.socialaccount.templatetags.socialaccount import get_providers
from .forms import LoginForm
def login(request):
   providers = []
   for provider in get_providers(): #settings/INSTALLED_APPS내에서 활성화된 provider의 목록
       
       
       try:
       #실제 Provider 별 Client id/secret 이 등록이 되어있는가?
       # social_app속성은 provider에는 없는 속성입니다.
           provider.social_app = SocialApp.objects.get(provider=provider.id, sites=settings.SITE_ID)
       except SocialApp.DoesNotExist:
           provider.social_app = None
       providers.append(provider)
   
   #auth_login함수를 통해 몇가지필요한 요소만 설정하고 provider의 list를 템플릿으로 보내줌!
   return auth_login(request
       authentication_form=LoginForm,
       template_name='accounts/login_form.html',
       extra_context={'providers': providers})
```

<br></br>

```
{% extends "accounts/layout.html" %}
{% load socialaccount %} #socialaccount에 커스텀테그존재(provider_login_url)

    {% block content %}
     <form action="" method="post">
         {% csrf_token %}
         <table>
         {{ form.as_table }}
         </table>
         <input type="submit" />
         </form>
         
     <h3>Social Login</h3>
     
     <ul>
     {% for provider in providers %}
         <li>
             {% if provider.social_app %}
                 #커스텀태그!!!!!!!!!
                 <a href="{% provider_login_url provider.id %}">  
                 {{ provider.name }}
             </a>
             {% else %}
             <a>
                 Provider {{ provider.name }} 설정이 필요합니다.
             </a>
             {% endif %}
         </li>
     {% endfor %}
     </ul>
{% endblock %}
```

### 프로필 이미지 노출

```
# first.get_avatar_url라는함수를 통해 프로필 사진도가져옴
# accounts/templates/accounts/profile.html
{% raw %}
<img src="{{ user.socialaccount_set.all.first.get_avatar_url }}" />
{% endraw %}


```



## 플랫폼별 로그인

### 페이스북 로그인, 적용순서

- facebook for developers 에서 "새 앱" 등록 

- 새로이 생성된 앱의 app_id, app_secret 키를 복사

-  "Facebook 로그인" 설정에서 "유효한 OAuth 리다이렉션 URI" 세팅 

  - 로그인을 수행할 사이트의 호스트명을 다수 입력

    ex) http://localhost:8000 

- 장고 admin 페이지에서 Facebook Provider에 대해,

  새로운 SOCIAL ACCOUNTS에 Social applications에 등록

- 등록시 더 폼을 이용해 받을수있으므로 나중에 해보기(allauth)

- 유효한 OAuth 리디렉션 URI:

  https://호스트명/accounts/facebook/login/callback/

### 네이버 로그인, 적용순서(오래되서 바뀐듯)

-  "로그인 오픈 API" 활성화 • 이용목적 : "로그인 오픈 API (네이버 아이디로 로그인)" 체크 
- 로그인 오픈 API 서비스 환경 : "웹" 체크
  - PC 웹
    - 서비스 URL : http://localhost:8000 
    - 네이버 아이디로 로그인 Callback URL : http://localhost:8000/accounts/naver/login/ callback/ 
- 애플리케이션 개발 상태 : 릴리즈 시에 "서비스 적용" 체크 
  - "개발 중" 상태일 경우, 로그인 가능한 아이디 제한 (최대 20개)

### 카카오 로그인, 적용순서

- Kakao Developers / 내 애플리케이션에서 앱 등록

- 특이사항 : 카카오 oauth 설정에서는 시크릿키는 없습니다.

- 사이트 도메인에 다음 추가

  - 플렛폼추가
  - http://localhost:8000 

  - 그리고, 실제 서비스 주소

  - rest API키를 client id로 등록하고 secret키는 따로 제공안함

  - #### Redirect URI: http://localhost:8000/accounts/kakao/login/callback/



### [그외의 providers](https://django-allauth.readthedocs.io/en/latest/providers.html)
