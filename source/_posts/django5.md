---
title: Django 기본 다섯번째이야기
date: 2019-11-25 13:25:05
categories: Django
tags: [Basic, Django]
---

#  User Authentication

- django.contrib.auth 앱을 통한 회원가입/로그인/로그아웃

## 관련 디폴트 settings

```
# 기본 로그인 페이지 URL 을 지정
# login_required 장식자 등에 의해서 사용
LOGIN_URL = '/accounts/login/'

# 로그인 완료 후에 next 인자가 지정되면 해당 URL 로 페이지 이동
# next 인자가 없으면 본 URL 로 이동
LOGIN_REDIRECT_URL = '/accounts/profile/'

# 로그아웃 완료 후에   (# get인자에서 next 인자, next_page 인자가 지정됨)
# - next_page 인자가 지정되면 next_page URL 로 페이지 이동
# - next_page 인자가 없으면 LOGOUT_REDIRECT_URL 이 지정되었을 경우 해당 URL로 이동
# - next_page 인자가 지정되지 않고 LOGOUT_REDIRECT_URL이 None일 경우
# redirect를 수행하지 않고 'registration/logged_out.html' 템플릿 렌더링
LOGOUT_REDIRECT_URL = None

# 인증에 사용할 커스텀 User 모델 지정, '앱이름.모델명'
AUTH_USER_MODEL = 'auth.User' #auth가 앱이름 User가모델명
```

## 주요 모델의 주요 필드 살펴보기

```
#django/contrib/auth/models.py
#우리가 아래에서 사용하는 모델클래스는 User(AbstractUser)를 상속받음
AbstractUser를 분석해보면 아래와 같이 PermissionsMixin, AbstractBaseUser를 또 상속받고 즉, 상속된 필드+ 자신의 필드를 가지고있다. 이것을 User클래스가 상속받게한다,

class AbstractBaseUser(models.Model):
     password = models.CharField(max_length=128) # (필수) 해싱된 암호
     last_login = models.DateTimeField(blank=True, null=True) # 마지막 로그인 일시
 # 생략
class PermissionsMixin(models.Model):
     is_superuser = models.BooleanField(default=False) # superuser 여부
     # 생략
class AbstractUser(AbstractBaseUser, PermissionsMixin):
     username = models.CharField(max_length=150, unique=True) # (필수) 로그인 아이디
     first_name = models.CharField(max_length=30, blank=True) # first name
     last_name = models.CharField(max_length=30, blank=True) # last name
     email = models.EmailField(blank=True) # email
     is_staff = models.BooleanField(default=False) # staff 여부 (admin페이지 접속 허용 여부)
     is_active = models.BooleanField(default=False) # 로그인 허용 여부
     date_joined = models.DateTimeField(default=timezone.now) # 가입일시
```

#아래가 우리가 쓰는것

```
class User(AbstractUser): #우리가 사용하는 User모델
    #생략
    
class AnonymousUser: # 로그아웃 유저를 표현하기 위한 파이썬 클래스 (모델아님. 파이썬 클래스임) #로그아웃 유저표현!
     id = None
     pk = None
     username = ''
     is_staff = False
     # 생략
```

## AbstractUser 클래스, 주요 속성/멤버함수

- __.is_authenticated__ - 로그인 여부 (property) (로그인상태시 True)

- .is_anonymous - 로그아웃 여부 (property) (로그인상태시 False)

- __.set_password(raw_password)__ - 지정 암호를 암호화해서 (비번 문자열 입력하면 암호화)

  password 필드에 저장. save함수를 호출하진 않습니다.(.save함수를 호출해야 DB에 쿼리보내서 저장)

- .check_password(raw_password) - 저장된 암호가 맞는 지 여부 

- .set_unusable_password() - 로그인 불가 암호로 세팅

   (데이터값에 '!'가맨앞이므로어떤값이든 매칭 불가

- .has_unusable_password() - 로그인 불가 암호 설정 여부

### 로그인 불가 암호로 세팅한다는 것을 의미

- 암호를 통한 로그인을 허용하지 않겠다(페이스북이랑연동이면 페이스북을 꼭갔다와야함)
- 외부 서비스 인증(OAuth)에 의한 유저일 경우
  - 주로 Django-allauth 라이브러리나 python-social-auth 라이브러리를 통해 외부 서비스 인증 연동 



## password 해싱 절차

```
from django.contrib.auth.models import User #안좋은방법
>>> from django.contrib.auth import get_user_model #커스텀 User모델써도 get_user_model 쓰면 그 커스텀 인스턴스 가져올수있다.!!
>>> User = get_user_model()
>>> User.objects.first().password
'pbkdf2_sha256$30000$zTKberfHpgkf$hbwaZtAFTA73fCT/c8OtekfRwFYU/WAbJrZRVRgzpaA='
```

pbkdf2_sha256 해싱(함수)을 

seed 값으로 "zTKberfHpgkf"을 써서 

총 30000회 수행하여 

 "hbwaZtAFTA73fCT/c8OtekfRwFYU/WAbJrZRVRgzpaA=" 계산



## User 모델 클래스 획득하는 방법

방법1) 직접 User모델 import (BAD) 

- 인증 User모델을 다른 모델로 변경할 수 있기 때문

```
from django.contrib.auth.models import User User.objects.all()
```


방법2) helper 함수를 통해 모델 클래스 참조 (GOOD)

```
from django.contrib.auth import get_user_model
User = get_user_model()
User.objects.all()
```

## User관련 추가 속성을 정의하고 싶다면

- 방법1) Profile 모델을 만들고, User모델과 1:1 관계 매핑 (추천) 
- 방법2) Custom User Model 만들기
  - django.contrib.auth.models.AbstractUser 상속
  - Custom User Model의 '앱이름.모델명'을 settings.AUTH_USER_MODEL으로 지정 (디폴트: 'auth.User')

Tip:

- 인증 User 모델 클래스는 변경될 수 있으며

   관계 지정시 User 모델클래스 참조는 settings.AUTH_USER_MODEL

```
from django.conf import settings
from django.contrib.auth.models import User # BAD
from django.db import models

class Post(models.Model):
 author = models.ForeignKey(User) # BAD #모델 커스텀으로 바뀔수있음
 author = models.ForeignKey('auth.User') # BAD #모델 커스텀으로 바뀔수있음
 author = models.ForeignKey(settings.AUTH_USER_MODEL) # GOOD #이렇게하면 settings에 저거 경로만 바꿔주면됨.
```

- User 모델클래스 획득은 django.contrib.auth.get_user_model

```
from django.contrib.auth import get_user_model
User = get_user_model()
print(User.objects.all())
```



## 뷰에서 현재 로그인 유저 획득

- 뷰 FBV에서 request.user, 뷰 CBV에서 self.request.user 
  - 로그인 상태 : settings.AUTH_USER_MODEL 클래스 인스턴스 
  - 로그아웃 상태 : django.contrib.auth.models.AnonymousUser (just 파이썬 함수임)
    - __모델 인스턴스가 아니므로, 다른 모델과 관계 불가__



## 모든 템플릿에서 편하게 값쓰기!



- context_processors를 통해 user 제공(템플릿에서 그냥 user를 써도 바로호출가능한이유)

  (Setting.py에서 context_processors가 역할수행)

  ``` 
  #템플릿 렌더전에 함수들이 리턴한 디렉토리형식으로 모든 값을 템플릿에 전달
  따라서 blog.context_processors.blog 추가후에
  내가 더 추가하여 모든 템플릿에서 blog함수의 리턴값(디렉토리)(무조건) 를 쓸수있다
  TEMPLATES = [
      {
          'BACKEND': 'django.template.backends.django.DjangoTemplates',
          'DIRS': [
              os.path.join(BASE_DIR, 'askdjango', 'templates')
          ],
          'APP_DIRS': True,
          'OPTIONS': {
              'context_processors': [
                  'django.template.context_processors.debug',
                  'django.template.context_processors.request',
                  'django.contrib.auth.context_processors.auth',
                 'django.contrib.messages.context_processors.messages',
              ],
              
   
  ```

  





#  User Authentication Implementation

- 회원가입/로그인/로그아웃/프로필

- 코드 구현에 앞서, accounts 앱을 생성

```
python manage.py startapp accounts

settings.INSTALLED_APPS 에 "accounts" 추가

# accounts/urls.py
from django.conf.urls import url
urlpatterns = []

# askdjango/urls.py
from django.conf.urls import include, url

urlpatterns += [
     # django.contrib.auth 앱 내에서는 namespace를 쓰지 않는 것으로
     # 이미 구현이 되어있기 때문에, 이를 따라 본 accounts앱에서는
     # namespace를 절대 적용하지 않습니다.
     url(r'^accounts/', include('accounts.urls')),
]
```



## d.contrib.auth.forms 내 Form Class



- UserCreationForm #ref : 회원 가입 
  - 쓰고 있는 뷰가 없음. 
- AuthenticationForm #ref : 로그인
  - d.c.auth.views.login 뷰의 디폴트 Form Class 
- PasswordResetForm #ref : 암호변경 리셋 요청
  - d.c.auth.views.password_reset 뷰의 디폴트 Form Class
- PasswordChangeForm #ref : 암호변경
  - d.c.auth.views.password_change 뷰의 디폴트 Form Class 
- SetPasswordForm #ref : 암호 설정 
  - d.c.auth.views.password_reset_confirm 뷰의 디폴트 Form Class



### 회원가입 구현 /UserCreationForm 활용

```
# accounts/urls.py
urlpatterns += [
 url(r'^signup/$', views.signup, name='signup'),
]

# accounts/views.py
from django.contrib.auth.forms import UserCreationForm

def signup(request):
   if request.method == 'POST':
       form = UserCreationForm(request.POST)
       if form.is_valid():
           form.save()
           return redirect(settings.LOGIN_URL) # 회원가입에 성공하면, LOGIN 페이지로 이동 #default : "/accounts/login/"
   else:
   form = UserCreationForm()
   return render(request, 'accoutns/signup_form.html', { # 템플릿은 일반적인 form template
   'form': form,
 })
```



### 로그인/로그아웃 구현

```
# accounts/urls.py
from django.conf import settings
from django.contrib.auth import views as auth_views

urlpatterns += [
   url(r'^login/$', auth_views.login, name='login',
   kwargs={'template_name': 'accounts/login_form.html'}),
   url(r'^logout/$', auth_views.logout, name='logout',
   kwargs={'next_page': settings.LOGIN_URL}),
  ]
```

- 위에형식은 views.py에 뷰정의안하고 기본 장고 view에서 뷰함수 가져다씀

- 템플릿은 일반적인 form template

- 함수를 불러올때 안에 인자들을 kwargs인데 이것을 바꿔줄려면 위에 형식처럼 바꿔줄수있다.

  (즉, def login(request, template name='registration/login.html',..)되어있지만

  이 인자를 바꿔줄려면 kwargs={'template_name': 'accounts/login_form.html'}같이 path 인자에 써주면 바꿀수있다. 

- 로그인 성공하면 next인자가 주어지지않으면 settings.LOGIN_REDIRECT_URL로 이동하며,

```
http://localhost:8000/accounts/login/?next=/blog/1
이런주소에서 next인자가 주어진상태에서 로그인성공하면 바로 next인자로 이동
```

```
{% raw %}  
  #프로젝트/templates/layout.html
  # 로그인상황이 False이면 아래것 보여주고 로그인상황이면 프로필 로그아웃 보여줌
  {% if not user.is_authenticated %}
             <li><a href="#">회원가입</a></li>
             <li><a href="#"> 로그인</a></li>
             <li><a href="#">{{ user }}</a></li>

  {% else %}
             <li><a href="#">프로필</a></li>
             <li><a href="#">로그아웃</a></li>

  {% endif %}
                    
{% endraw %}
```

만약 로그인 후 해당 페이지로 다시 돌아가는것을 해주고 싶다면 next인자를 활용하자

```
{% raw %}
#프로젝트/templates/layout.html

{% if not user.is_authenticated %}
                        <li><a href="{% url "signup" %}">회원가입</a></li>
                        <li><a href="{% url "login" %}?next={{ request.path }}"> 로그인</a></li>
                        <li><a href="#">{{ user }}</a></li>

                    {% else %}
                        <li><a href="{% url "profile" %}">프로필</a></li>
                        <li><a href="{% url "logout" %}?next={{ request.path }}">로그아웃</a></li>

                    {% endif %}
                    
{% endraw %}
```





## Profile 뷰 구현

(로그인 유저의 프로필 정보 보여주기)

- settings.LOGIN_REDIRECT_URL 에 맞춰, /accounts/profile/ 주소를 처리토록 accounts.views.profile 뷰를 구 성해봅시다.

```
# accounts/urls.py

from . import views
urlpatterns += [
 url(r'^profile/$', views.profile, name='profile'),
]

# accounts/views.py
@login_required #데코레이터!장식자! 아래함수가 로그인 환경일때만 가능
def profile(request):
	 return render(request, 'accounts/profile.html')
```

```
#accounts/templates/accounts/profile.html
<h1>{{ user }}'s Profile</h1>
<ul>
   <li>email : {{ user.email }}</li>
   <li>name : {{ user.first_name }}, {{ user.last_name }}</li>
   <li>is_staff : {{ user.is_staff }}</li>
   <li>is_superuser : {{ user.is_superuser }}</li>
   <li>{{ user.date_joined }}</li>
</ul>
```

- login 뷰에서는 next 인자 지원 : 로그인을 성공하면, 로그인을 요청했던 페이 지로 다시 돌아오기



## 장식자를 통한 뷰 접근 제한

- 로그아웃 상태일 때, 해당 뷰에 접근하면 settings.LOGIN_URL 로 이동

```
from django.contrib.auth.decorators import login_required

@login_required
def profile(request):
 	return render(request, 'accounts/profile.html')
```



- 체킹 루틴을 함수로 지정 가능

```
#아래 설정으로 포인트가 50000이상이며 로그인되어있는 경우만 아래 함수 실행

from django.contrib.auth.decorators import user_passes_test

@user_passes_test(lambda user: user.is_authenticated() and user.point > 50000)
def gold_membership(request):
	 return render(request, 'app/gold_membership.html')
```





