---
title: Django 기본 두번째이야기
date: 2019-11-05 15:01:10
tags: [Basic, Django]
categories: Django
---

# HTTP Status Code

웹서버는 적절한 상태코드로서 응답해야합니다. 대표적 HTTP 응답 상태 코드

• 200 : 성공. 서버가 요청을 잘 처리했다. (OK)

• 302 : 임시 URL로 이동했다. (Redirect) 

• 404 : 서버가 요청한 페이지를 찾을 수 없음. (Not Found)

• 500 : 서버 오류 발생 (Server Error)

\#   아래 3종류가 200받는 형식 

```
from django.http import HttpResponse, JsonResponse 
from django.shortcuts import render 

def view1(request): 

          return HttpResponse('안녕하세요.')

 def view2(request): 
          return render(request, 'template.html') 

def view3(request):   

          return JsonResponse({'hello': 'world'})
```

\#   아래 3종류가 302(임시url, redirect)

``` 
from django.http import HttpResponseRedirect
from django.shortcuts import redirect, resolve_url
def view1(request):
       return HttpResponseRedirect('/blog/')
def view2(request):
        url = resolve_url('blog:post_list') # 후에 배울 URL Reverse 적용 #뷰에 함수에 url을 return
        return HttpResponseRedirect(url)
def view2(request):
        return redirect('blog:post_list')   #위에것 줄인 형태
```

\# 404발생시키기 

``` 
from django.http import Http404, HttpResponseNotFound
from django.shortcuts import get_object_or_404
def view1(request):
      raise Http404 # Exception Class #직접발생
def view2(request):
        post = get_object_or_404(Post, id=100) # 없는 id에 접근할 경우 Http404 예외 발생 
         # 생략
def view3(request):
         return HttpResponseNotFound() # 잘 쓰지 않는 방법
```

\# 500으로 응답하기

이는 서버에서 요청 처리 중에 예기치못한 오류 (코드오류, 설정오류) 가 발 생할 경우

(IndexError, KeyError, django.db.models.ObjectDoesNotExist, ... 등)

## 지정 Record가 없는 것은 서버오류가 아닙니다 (!= 500)

html은 개행문자(엔터) 무시하므로 <p>구문으로 일일히 해줘야하지만 변환해주는 것있다

``` 
{{post.content|linebreaks}} 하면 <p> 구문으로 나눠주고
{{post.content|linebreaksbr}} 하면 <br>구문으로 나눠줌
```

내가 데이터를 지워버리면 500이떠버림 (404가 떠야함 뜨게 만들어야함)(서버오류가 아니라 not found page이므로)

따라서 try: 

except: 

​       raise Http404하면됨.

하지만 맨날 이럴수없음



```
#try:
     #   post = Post.objects.get(id=id)
    #except Post.DoesNotExist:
    #    raise Http404
        
 post = get_object_or_404(Post, id=id) #위에 4줄이랑 같은 역할., id=id 자리에는 다른조건들 추가가능
```





# Model Relationship Fields  (관계형 데이터베이스)





포스팅과 댓글, 포스팅과 글쓴이, 포스팅과 카테고리 등의 정보를 RDBMS (관계형 데이터베이스, Relational Database management System) 에 저장하기 위해서는, Relation에 대한 이해가 필요 

__관계가 있는 Record끼지 서로 연결(Link) __

> • ForeignKey - 1:N 관계를 표현 
>
> • ManyToManyField - M:N 관계를 표현 
>
> > 중간 테이블이 생성되며, ForeignKey 관계로 참조
>
> • OneToOneField - 1:1 관계를 표현



## 데이터베이스 정규화

- 정규화: RDBMS 설계에서 중복을 최소화하게 데이터를 구조화하는 프로세스

- 충분히 정규화하지 않는다면, 중복 정보가 복수 개의 Row/Column에 혼재

  Record 갱신/삭제 시에 관련 Row/Column에 대해서 처리되지 않을 경우, 논리적 모순 발생

- 경우에 따라 비정규화 과정이 필요.

 ## 1:N - 포스팅과 댓글

```
from django.db import models
class Post(models.Model):
     title = models.CharField(max_length=100)
     content = models.TextField()
class Comment(models.Model):
     post = models.ForeignKey(Post, on_delete=models.CASCADE) 
     # !!! POINT #Post모델에대해서 1:n이다 선언함!
     
     message = models.TextField()
```

\# on_delete=models.CASCADE 이거는 ForeignKey쓸떄 2번쨰 파라미터에입력!

__\# post필드는 실제 sql 데이터보면 필드가 post_id라는 것으로 입력되어있다(ForeignKey)__

- 글에 댓글을 달아놓은것을 볼수있게함 (admin페이지에서 관리함)

- 
```
  @admin.register(Comment)
  
  class CommentAdmin(admin.ModelAdmin):
  
    pass  
```

## M:N - Relation없이 포스팅과 태그

```
class Post(models.Model):
 content = mdoels.TextField()
 tag_set = models.ManyToManyField('Tag')
class Tag(models.Model):
 name = models.CharField(max_length=20)
# ManyToManyField 필드 정의는 Tag모델 측에 둘 수도 있습니다.
```

__tip__ : 모델에 relation지정하는 필드들을 ('Tag')처럼 문자열로도 클래스 부르느것가능

\# 중간테이블이 자동으로 생성됨 blog_post_tag_set테이블이 생김. 이어주는역할

\# post쪽 tag쪽둘다 줄수있음.



## 1:1 - User와 Profile

Django 에서는 django.contrib.auth.models.User 모델을 기본 제공 User에 대한 부가적인 정보(전화번호, 주소 등)를 저장하기 위해, Profile 모델을 1:1 관계로 설계 가능



```
from django.contrib.auth.models import User

class Profile(models.Model):
    user = models.OneToOneField(User)
    phone = models.CharField(max_length=20)
    address = models.CharField(max_length=100)
```

> 복습하면 startapp하면 settings.py에 앱 이름 추가하고 앱에 urls.py만들어서 from django.conf.urls import url 하고 아래에 urlpatterns = [] 추가하고
>
> 프로젝트에 urls.py에서 이 url연결 include만들기



## ForeignKey와 Onetoone차이

- 생성되는 필드명은 같으나 유일성의 차이

```
  class Post(models.Model):
     user = models.ForeignKey(User)
     
     # 필드 SQL: "user_id" integer NOT NULL REFERENCES "auth_user"("id")
     #즉, User 하나에 post여러개 존재가능
  class Profile(models.Model):
       user = models.OneToOneField(User)
       # 필드 SQL: "user_id" integer NOT NULL UNIQUE REFERENCES "auth_user" ("id")
       
      # 즉, User하나에 하나 profile
```

  

## 알아야할것

```
import Comment
comment = Comment.objects.first()
#처음에 대한 정보를 가져오는 쿼리,
comment.post를 하게되면
지금 class Comment를 보면 post = models.ForeignKey(Post) 이기때문에 
post_id필드에서 정보를 가져와 Post 테이블에 접근하여 정보를 가져오는 쿼리가됨
```

## 참고 : auth.User 모델과 관계를 맺을 때

```
from django.conf import settings
from django.contrib.auth.models import User
# 방법1) 비추천
user = models.OneToOneField(User)
# 방법2) 비추천
user = models.OneToOneField('auth.User') #앱이름.모델명
# 방법3) 추천
user = models.OneToOneField(settings.AUTH_USER_MODEL)
• 장고 사용자 인증에 사용되는 User모델 변경을 지원 
(auth.user는 불가)(다른user모델 사용가능)
# 위에서 AUTH_USER_MODEL==auth.User
```





## ForeignKey.on_delete 옵션

- 1측의 Row가 삭제될 경우, N측의 Row의 처리에 대한 동작을 지정 (즉 post하나삭제시 댓글들 데이터동작지정)

  > • CASCADE : 연결된 Row 를 일괄 삭제 (디폴트 동작)
  >
  > • PROTECT : ProtectedError 예외를 발생시키며, post 삭제 방지 
  >
  > • SET_NULL : null=True 설정이 되어있을 때, 삭제되면 해당 필드를 null 설정
  >
  > • SET_DEFAULT : 필드에 지정된 디폴트값으로 설정
  >
  > • SET : 값이나 함수를 지정. 함수의 경우 호출결과값을 지정
  > • ~~DO_NOTHING : 대개의 DB에서는 오류발생의 가능성이 있습니다.~~
  >
  > ​     sqlite3는 엄격하지 않음

## ForeignKey에서 related_name 지정의 필요성

- 1:N 관계에서 1측에서 N측으로 접근 시의 속성명 : 모델명소문자_set

```
  Comment.objects.create(post=post, author="양승원", message="댓글#3")
  
  post = Post.objects.first()
  # 이 post에 해당하는 comment들 불러오는 방법 2가지
  
  print(Comment.objects.filter(post=post)) 
  #방법 #1 #comment
  
  print(post.comment_set.all()) #방법 #2 related name 사용 1쪽에서 comment불러옴
  
```

  

# related_name 이름 중복이 발생

- user_instance.post_set 은 어떤 앱 (blog/shop) 의 Post인가?

-  related_name이 중복되지 않도록 지정을 해야만, makemigrations 명령이 동작

(아래예시는 post라는 모델클래스가 겹쳐서 migrate에러가뜬다.)

```
# blog/models.py
class Post(models.Model):
 user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='blog_post_set') 
 #즉 나중에 호출시 user.blog_post_set.all()
# shop/models.py
class Post(models.Model):
 user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='shop_post_set')
  #즉 나중에 호출시 user.shop_post_set.all()
```

- 혹은 related_name을 쓰지 않도록 지정도 가능 : "+" (related_name='+')
- 



## save되지 않은 모델 인스턴스와 Relation은 불가

Relation은 pk로 관계를 맺는데, 초기 save() 전에는 pk 미할당 상태

 • pk는 primary key를 뜻하며, 현재 id필드가 primary key이다

__왜냐하면 relation을 하는것은 pk값기준으로 하기때문에 먼저존재해야되므로__



- ManyToManyField

- 
```
  # 사전작업 : 관련 Object 획득
  post = Post.objects.first()   #인스턴스
  tag1 = Tag.objects.all()[0]   #인스턴스
  tag2 = Tag.objects.all()[1]   #인스턴스
  tag3 = Tag.objects.all()[2]  #인스턴스
  tag_qs = Tag.objects.all()[:3]  #쿼리
  # 관계에 추가
  post.tag_set.add(tag1)
  post.tag_set.add(tag1, tag2)
  post.tag_set.add(tag1, tag2, tag3)
  post.tag_set.add(*tag_qs)
  # 관계에서 제거
  post.tag_set.remove(tag1)
  post.tag_set.remove(*tag_qs) #쿼리셋으로 여러개 변경 개꿀
  
```

  ## 갯수 카운트하는 2가지 방법

```
  from blog.models import Post
  from django.db import connection
  # 방법1) len(QuerySet) - 모든 Record를 메모리에 로드하여, 카운트
  # 'SELECT "blog_post"."id", "blog_post"."title","blog_post"."content",
  # "blog_post"."tags", "blog_post"."lnglat", "blog_post"."created_at",
  # "blog_post"."test_field" FROM "blog_post"
  print(len(Post.objects.all()))
  
  
  # 방법2) QuerySet.count() - 해당 Record갯수를 DB에게 질의
  # 'SELECT COUNT(*) AS "__count" FROM "blog_post"
  print(Post.objects.all().count())  
  
  #성능차이는 애가더빠름 해당 record갯수를 질의질문함
  
```

  

#  Django Template Inheritance

- 여러 템플릿 파일 별로 필연적으로 발생하는 중복을 상속을 통해 중복 제거 상속은 여러 번 이뤄질 수 있다
- __부모 템플릿은 전체 레이아웃을 정의하며, 자식 템플릿이 재정의할 block 을 다수 정의해야 한다__

- __자식 템플릿은 부모 템플릿을 상속받은 후에 부모 템플릿의 block 영역에 대해 재정의만 가능하며 그 외 코드는 무시__

- 템플릿 상속 문법 : 항시 자식템플릿 코드 내, __최상단__에 쓰여져야합니다. 

 ``` {% extends "부모템플릿경로" %} ```

- 즉 상속을 사용하면 중복을 피해서 템플릿들 작성가능

- 부모 탬플릿 (자식  재정의할곳 block)

- 
```
  <!doctype html> 
  <html> 
  <head>
  
          <meta charset="utf-8" />
  
           <title>AskDjango Blog</title>
  </head>
  <body>
  
        <h1>AskDjango Blog</h1>
        {% block content %} #block 이름이 content이므로 템플릿내에서유일한이름임
        {% endblock %}
  
         <hr/>
          &copy; 2017. AskDjango
  </body>
  </html>
```

- 자식 탬플릿이 간단해짐 (block영역만 지정가능, 나머지 것들은 모두 무시됨)

- 

```
 {% raw %}
 {% extends "blog/layout.html" %} #최상단 무조건해야함
    {% block content %}
      {% for post in post_list %}
           <a href ="{% url "blog:post_detail" post.id %}">
           {{post.title }}
           </a>
      {% endfor %}
  {% endblock %}
{% endraw %}
```


## 2단계의 상속을 추천

프로젝트 전반적인 레이아웃 템플릿 : askdjango/templates/layout.html 

장고는 하나의 프로젝트(하나의 사이트) 다수의 앱(기능들) 비슷한 레이아웃 즉, 

프로젝트에서 레이아웃>>각 앱별 레이아웃 템플릿>> 각 템플릿

tip: 프로젝트 디렉토리 안에 templates폴더만들고 넣으면 정리쉬움. 경로는 setting.py에 템플릿에 경로 추가해줘야함('DIRS': [

​      os.path.join(BASE_DIR, 'askdjango', 'templates')

​    ],)

tip: 부모를 건드리거나 내용 추가하면 아래것들 다 추가되서 편함

- 각 앱 별 레이아웃 템플릿 #1 : blog/templates/blog/layout.htm
  - l - 각 템플릿 #1 : blog/templates/blog/post_list.html 
  - 각 템플릿 #2 : blog/templates/blog/post_detail.html 
  - 각 템플릿 #3 : blog/templates/blog/post_form.html 
  - 각 앱 별 레이아웃 템플릿 #2 : shop/templates/shop/layout.html
  -  각 템플릿 #4 : shop/templates/shop/item_list.html 
  - 각 템플릿 #5 : shop/templates/shop/item_detail.html 
  - 각 템플릿 #6 : shop/templates/shop/item_order_form.html



Template Loader에 대한 이해가 필요 (at EP13)

<자식탬플릿에서 추가하고 싶은것은 똑같은 ```{% block 이름 %}``` 쓰면 적용됨 ```{% endblock %}```






#  Django Template Loader 꼭알자

다수 디렉토리 목록에서 지정 상대경로를 가지는 템플릿을 찾음

 •__app_directories.Loader 와 filesystem.Loader __

위 Loader를 통해, 템플릿 디렉토리가 있을 후보 디렉토리 리스트를 작성 합니다. 이는 장고 서버 초기 시작시에만 1회 작성됩니다.



주로 아래 함수를 통해 Template 파일들을 활용합니다
 • render : 템플릿을 렌더링은 문자열로 __HttpResponse 객체를 리턴__ 

• render_to_string : 템플릿 렌더링한 __문자열을 리턴 __ 즉 str 리턴

```

response = render(request, 'blog/post_list.html', context_params)     

# 3번째인자는 dic형태로 인자들을 받음(인자들을 템플릿에줌)

welcome_message = render_to_string('accounts/signup_welcome.txt', context_params)  
# 상대 템플릿경로를 받고, 2번쨰인자로  dic형태로 인자들을 받음


```



## app_directories.Loader

settings.INSTALLED_APPS에 설정된 __앱 디렉토리 내 templates 경로 에서 템플릿 파일을 찾습니다.__ ( 'APP_DIRS': True,이므로 자동으로 찾음)

앱 디렉토리 별로 각 앱을 위한 템플릿 파일을 위치 

- blog앱용 템플릿은 blog/templates/ 경로에 두는 것이 관리성 좋음
- shop앱용 템플릿은 shop/templates/ 경로에 두는 것이 관리서 좋음



## filesystem.Loader

프로젝트 전반적으로 쓰일 템플릿 파일은 "특정앱/templates/" 경로가 아닌 별도의 경로에 저장이 필요(프로젝트 settings.py 에 템플릿에 DIR에 리스트형식으로추카 )

```
# 프로젝트/settings.py 에 후보지 디렉토리 경로 지정
TEMPLATES = [{
 # 중략
 'DIRS': [
 os.path.join(BASE_DIR, '프로젝트명'
, 'templates'),
 ],
 # 중략
}]
```



- 실행과정

  render 혹은 render_to_string 함수가 호출되면, 미리 작성된 템플릿 후 보 디렉토리들을 차례대로 순회하며 템플릿 파일을 찾습니다. render(request, 'blog/post_list.html') 이 호출되면

   blog/templates/blog/post_list.html 파일 체크, 없으면 다음 shop/templates/blog/post_list.html 파일 체크, 없으면 다음 diary/templates/blog/post_list.html 파일 체크, 없으면 다음

  프로젝트명/templates/blog/post_list.html 파일 체크, 없으면

   다음 마지막까지 검사해서 없을 경우, TemplateDoesNotExist 예외 발생

  순서대로 있는지 검사하므로 blog에 있다면 shop에있는 같은 이름의 템플릿은 평생못부름따라서 템플릿디렉토리안에 앱명디렉토리안에 템플릿넣어놓자

  

  __따라서 습관적으로 blog_post_list.html 을 만들기 or 템플릿디렉토리안 해당 앱이름으로 디렉토리 만들고 그안에 템플릿 쓰면됨.__

```
  예시
  - blog/templats/blog/post_list.html : blog/post_list.html 경로로 찾습니다.
  - shop/templats/shop/post_list.html : shop/post_list.html 경로로 찾습니다.
```

  

  

`render(request, "blog/post_list.html") 로 호출시킴`

  __장고 앱은 재사용할려고 만듬 즉 거의 모든 파일은 앱 디렉토리 안에 넣어놓자__

  전반적으로 쓸 템플릿은 프로젝트 레벨에 쓸 템플릿을 넣는것은 프로젝트 디렉토리에 템플릿에 넣자 그리고 꼭 settings.py 에 템플릿에 dir에 경로 추가해줘야함 (자동추가x)

  

  ## render_to_string 샘플(템플릿으로 html, 이메일, JS 등등가능)

  accounts/signup_welcome.txt

```
  안녕하세요. {{ name }}님. {{ name }}님께서는 {{ when }}에 가입하셨습니다.
  감사드립니다. - AskDjango
```

  만들기

  

  # URL Reverse

   urls.py 변경만으로 "각 뷰에 대한 URL"이 변경되는, 유연한 URL시스템

```
  urlpatterns = [
       url(r'^blog/$', blog_views.post_list, name='post_list'),
       url(r'^blog/(?P<id>\d+)/$', blog_views.post_detail, name='post_detail'),
  ]
```

  을 아래와 같이 바꾼다

```
  urlpatterns = [
   url(r'^weblog/$', blog_views.post_list, name='post_list'),
   url(r'^weblog/(?P<id>\d+)/$', blog_views.post_detail, name='post_detail'),
  ]
  # 이제 "/weblog/", "/weblog/1/" 주소로 서비스하게 됩니다.
```

  이것이 URL Reverse의 힘!!

  

  ## URL Reverse 의 혜택(템플릿>url찾음)

  • 개발자가 일일이 URL을 계산하지 않아도 됩니다. 만세 ~~~

  ​    (뷰는 안바뀌고 url주소만바뀜)

  • URL이 변경되더라도, URL Reverse가 변경된 URL을 추적 

  • 누락될 일이 없어요. 

  - 예시

  - > 내가 list를 만들고 싶음
    >
    >  blog앱 Post목록을 볼려면 post_list뷰를 호출해야되니깐, URLConf 뒤 적뒤적거리며 URL계산계산 @_@;;; /blog/ 주소로 접근하면 되겠네.
    >
> ```
    > <!-- blog/templates/blog/layout.html -->
    > <a href="/blog/">블로그 글 목록</a>
    > <!-- blog/templates/blog/post_form.html -->
    > <a href="/blog/">블로그 글 목록</a>
    > <!-- blog/templates/blog/comment_form.html -->
    > <a href="/blog/">블로그 글 목록</a>
> ```
    >
    > 문제점은 blog앱을 다른 프로젝트에 쓸려고 옮겼는데, r'^blog/' 에서 r'^weblog/'로 다시 다 변경해야함

  ##  뷰 url계산은 장고! 시키자

  URL이 변경될 때마다, 이 URL을 참조하고 있는 코드를 일일이 찾아서 변 경하는 것은 너무 번거롭고, 수정건을 누락시킬 여지도 많다

  각각의 url패턴이란? url(~~)형식을 말함 

  이때 urls.py 에서 url(~~ ,~~, name='post_detail') 라고 url이름을 달아주면

```
  {% raw %}
  <a href="/blog/detail/{{post.id}}/">
       {{post.title}}
       </a> 
       #이렇게 써야하는것을 줄일수있다
       
  <a href="{% url "post_detail" post.id %}">  중요! id라는 인자도넘김
       {{post.title}}
       </a> 
       #으로 줄일수있고 거기다 url을 수동으로 바꿔줄필요가없다.
       #즉 url패턴을 바로 대려와서 필요한 인자 넘기고 실행하는 링크가된듯
       #네임이 중요
       {% endraw %}
```

  

  ## URL Reverse를 수행하는 4가지 함수

  • reverse 함수 : 매칭 URL이 없으면 NoReverseMatch 예외 발생 (str리턴)

  >reverse('blog:post_detail', kwargs={'id': 10})
  >
  >reverse("blog:post_detail", args=[10])

  • resolve_url 함수 : 매칭 URL이 없으면 "인자 문자열"을 그대로 리턴  (str리턴)

  > 내부적으로 reverse 함수를 사용 
  >
  > resolve_url('blog:post_detail', 10)

  • redirect 함수 : 매칭 URL이 없으면 "인자 문자열"을 URL로 판단 (HttpR리턴)

  > 내부적으로 resolve_url 함수를 사용 

  • url template tag : 내부적으로 reverse 함수가 사용 (str)

  

  

  ### 예시(프로젝트 안에 이름동일하면 네임스페이스 지정!)

  - 네임스페이스는 

    path()쓰자 그리고 네임 스페이스는 이제 그해당 앱에 url에 

    app_name = "blog" 추가하면 그게 네임 스페이스가됨
    
    이렇게 include안에 지정하면 이제 하위에 url패턴 이름이 겹쳐도 사용가능

템플릿에서 사용시{% raw %} {%url "blog:post_detail" post.id %} {% endraw %} post.id는 넘겨줄인자

  - tip: 인자 넘겨줄때 포지션args or 키워드args존재.

    reverse("blog:post_detail", args=[10])

    reverse('blog:post_detail', kwargs={'id': 10})




## URL Reverse, 뷰 이름을 지정하는 2가지 방법 (2) 와 의 조합

- <include() namespace>
- <url() name>



## 모델 클래스내 get_absolute_url 멤버함수

__강추기능__



해당 post인스턴스의 디테일을 볼수있는 url을 아는방법이 예시임

models.py 파일에 post모델 클래스에

def get_absolute_url(self):

​    return reverse('blog:post_detail', args=[*self*.id])

추가하기



이제 얻는 방법은 4가지 

```
from blog.models import Post
post = Post.objects.first()
print(reverse('blog:post_detail', args=[post.id]))
print(resolve_url("blog:post_detail", post.id))
print(post.get_absolute_url())

print(resolve_url(post)) 
#resolve_url()은 포스트인자안에 get_absolute_url정의되어있다면 바로반환함
```



즉 어떠한 데이터 모델에 디데일뷰를 만들게되면 습관적으로 넣어놓는것이 편하다



## 그 외 활용

• CreateView, UpdateView 에 success_url을 제공하지 않을 경우, 해당 model instance 의 get_absolute_url 주소로 이동이 가능한지 체크하고, 이동이 가능할 경우 이동 • 생성/수정하고나서 Detail화면으로 이동하는 것은 자연스러운 시나 리오 

특정 모델에 대한 Detail뷰를 작성할 경우, Detail뷰에 대한 URLConf설 정을 하자마자, 필히 get_absolute_url설정을 해주세요. 코드가 보다 간 결해집니다
