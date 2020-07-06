---
title: DRF 기본편 1
date: 2020-01-07 12:13:37
categories: API
tags: [API, DRF]
---

# API 기초

API 서버 만들기

### API 서버란?

앱/웹 서비스를 만드는 개발자들이 이용하는 데이터 위주의서비스

시간이 지나도 호환성 유지를 위해 API버전 개념을 둔다

### API는 즉 REST API?? NO!!!!!!!!!!!

REST API라고 부르는 것들은 단순히 HTTP프로토콜을 통한 API, 즉 HTTP API라고 부르는게 맞음

대부분의 REST API라는 API들은 ~~REST 아키텍처 스타일~~

### 우리는 이번 코스를 통해...

- 설계의 영역에 대해 다루지 않음
- 널리 쓰여지는 django rest freamework에 대해서 자세히 익혀보는 시간을 가집니다. 
- 본 코스를 통해 만들어지는 API를 활용하는 Android앱 샘플을 제공,

django rest framework는 아래 REST API컨셉을 쉽게 만들수 있도록 도와줍니다. 이것이 REST API의 전부는 아닙니다

- URI는 http://{serviceRoot}/{collection}/{id} 형식이여야 한다
- GET, PUT, DELETE, POST, HEAD, PATCH, OPTIONS를 지원해야한다.(예시:request.method =="POST")
- API 버저닝은 Magor.minor로 하고, URI에 버전정보를 포합시킨다

### 시작하기 전에

django rest framework 에 대해 보다 심도있는 이해를 하기위해서는 장고의 Model/form에 대한 이해 필요!!

### CRUD

- 위키백과
- 모든 데이터는 기본적으로 "추가/조회/수정/삭제"액션으로 관리될 수 있습니다
  - C: 생성> 새 레코드 생성
  - R: 조회> 레코드 목록 조회, 특정 레코드 조회
  - U: 수정> 특정 레코드 수정
  - D: 삭제> 특정 레코드 삭제

## REST API 식의 URL 예

한 Post 모델에 대한 API 서비스를 제공할 때, 다음 기능이 필요할 것입니다.

- 새 포스팅 내용을 받아 등록하고, 확인 응답
- 포스팅 목록 및 검색 응답
- 특정 포스팅 내용 응답
- 특정 포스팅 내용 갱신하고, 확인 응답
- 특정 포스팅 내용 삭제하고, 확인 응답

이에 대해 URL을 설계한다면, 다음과 같이 설계해볼 수도 있습니다.

- 새 포스팅 내용을 받아 등록하고, 확인 응답 : /post/new/ 주소로 POST 요청
- 포스팅 목록 및 검색 응답 : /post/ 주소로 GET 요청
- 10번글 포스팅 내용 응답 : /post/10/ 주소로 GET 요청
- 10번글 포스팅 내용 갱신하고, 확인 응답 : /post/10/update/ 주소로 POST 요청
- 10번글 포스팅 내용 삭제하고, 확인 응답 : /post/10/delete/ 주소로 POST 요청

이를 REST API 식의 URL로 다시 설계해본다면, 다음과 같이 해볼 수 있습니다.

- /post/ 주소
  - GET 방식 요청 : 목록 응답
  - POST 방식 요청 : 새 글 생성하고, 확인 응답
  - ~~PUT/PATCH 방식 요청~~
  - ~~DELETE 방식 요청~~
- /post/1/ 주소
  - GET 방식 요청 : 1번 글 내용 응답
  - ~~POST 방식 요청~~
  - PUT 방식 요청 : 1번 글 갱신하고, 확인 응답
  - DELETE 방식 요청 : 1번 글 삭제하고, 확인 응답

위 API를 장고로 구현함에 있어서, URL이 2개 이므로 2개의 뷰를 구현하지만, 실제로는 5개의 로직을 구현해야 합니다. 다음처럼 말이죠. 아래는 이해를 돕기위해 구현한 코드일 뿐. 실제로 동작할려면 추가로 구현해야할 코드가 많습니다.

```python
#
# myapp/models.py
#
from django.db import models

class Post(models.Model):
    message = models.TextField()

#
# myapp/forms.py
#
from django import forms

class PostForm(forms.ModelForm):
    class Meta:
        model = Post
        fields = '__all__'

# myapp/views.py

def post_list(request):
    if request.method == 'POST':
        # 새 글 저장을 구현
        form = PostForm(request.POST, request.FILES)
        if form.is_valid():
            post = form.save()
            return JsonResponse(post)
        return JsonResponse(form.errors)
    else:
        # 목록 응답을 구현
        return JsonResponse(Post.objects.all())

def post_detail(request, pk):
    post = get_object_or_404(Post, pk=pk)

    if request.method == 'PUT':
        # 특정 글 갱신을 구현
        put_data = QueryDict(request.body)
        form = PostForm(put_data, instance=post)  # put_data는 request.PUT같은 영할, instance넘어가면 수정하는것 (???)
        if form.is_valid():
            post = form.save()
            return JsonResponse(post)
        return JsonResponse(form.errors)
    elif request.method == 'DELETE':
        # 특정 글 삭제를 구현
        post.delete()
        return HttpResponse()
    else:
        # 특정 글 내용 응답을 구현
        return JsonResponse(post)
```

뭔가 정형화되어있는 듯한 구현이지요? django rest framework는 REST API 구현을 도와주는 Class Based View를 제공해주는 프레임워크입니다. 다음과 같은 코드로 줄여볼 수 있겠습니다. 아래 코드는 위 코드와 동일한 동작을 수행하는 코드입니다.

```python
#
# myapp/models.py
#
from django.db import models

class Post(models.Model):
    message = models.TextField()

# myapp/serializers.py
from rest_framework import serializers   # form역할대신
from .models import Post

# ModelForm 대신에 ModelSerializer
class PostSerializer(serializers.ModelSerializer):  # form으로 생각
    class Meta:
        model = Post
        fields = '__all__'

# myapp/views.py
from rest_framework import viewsets

class PostViewSet(viewsets.ModelViewSet):     # 위에 뷰 2개,  crud모두 구현됨
    queryset = Post.objects.all()
    serializer_class = PostSerializer

# myapp/urls.py
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'posts', views.PostViewSet) # 이렇게 posts는 url프리픽스로 지정하면 posts/하면 목록나오고 posts/{pk}하면 특정 글에대해 열림

urlpatterns = [
    url(r'', include(router.urls)),
]
```

우리는 이번 코스를 통해, 위 코드에 대해서 하나 하나 자세히 살펴볼 것입니다. ;)

## API 호출

API 뷰 호출은 다양한 클라이언트 프로그램에 의해서 호출될 수 있습니다.

- 웹 프론트엔드에서 JavaScript를 통한 호출
- Android/iOS 앱 코드를 통한 호출
- 브라우저를 통한 호출 : 유저가 웹페이지를 탐색할 때, selenium을 통해 자동화를 할 때 등
- 웹요청 개발 프로그램을 통한 호출
  - GUI 프로그램 : Postman [#home](https://www.getpostman.com/) : Powerful API Client
  - CLI 프로그램 : cURL, HTTPie [#home](https://httpie.org/)
  - 라이브러리 : requests

우리는 이 중에 HTTPie를 통해, 실습을 진행토록 하겠습니다.

### HTTPie를 통한 HTTP 요청

pip명령으로 간단하게 설치하실 수 있습니다.

```
쉘> pip3 install --upgrade httpie
```

CLI 프로그램에서 http 명령을 통해 사용하실 수 있어요. 다음은 HTTPie명령의 사용예입니다.

```
쉘> http GET 요청할주소 GET인자명==값 GET인자명==값
쉘> http --json POST 요청할주소 GET인자명==값 GET인자명==값 POST인자명=값 POST인자명=값    #json 방식 (디폴트임)
쉘> http --form POST 요청할주소 GET인자명==값 GET인자명==값 POST인자명=값 POST인자명=값    #multipartform방식
쉘> http PUT 요청할주소 GET인자명==값 GET인자명==값 PUT인자명=값 PUT인자명값
쉘> http DELETE 요청할주소 GET인자명==값 GET인자명==값
```

이 중에 POST요청은 2종류로 구분됩니다. 서버로 요청이 전달될 때, 전달 데이터를 어떻게 인코딩하느냐의 차이입니다.

- `--form` 옵션 지정 시 : multipart/form-data 요청 : HTML Form과 동일합니다.
- `--json` 옵션을 지정하거나 생략 시 : application/json 요청 : 요청 데이터를 JSON포맷으로 직렬화해서 전달합니다(request body에다가 실어서넘김.

GET/POST/PUT/DELETE 요청을 날려볼 서버가 필요한데, 우리는 아직 서비스를 만들지 않았어요. 그렇다고 해서 서버를 만들때까지 기다릴 순 없구요. [httpbin.org](http://localhost:8889/notebooks/httpbin.org) 서비스로 쏴보겠습니다. API개발을 도와주는 서비스로서, 요청내역에 대한 상세정보를 응답으로 줍니다. 요청내역을 디버깅하고자 할 때 유용하게 사용하실 수 있습니다.

GET 요청

```
쉘> http GET httpbin.org/get x==1 y==2

HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 296
Content-Type: application/json
Date: Sat, 14 Oct 2017 18:37:49 GMT
Server: meinheld/0.6.1
Via: 1.1 vegur
X-Powered-By: Flask
X-Processed-Time: 0.000959157943726

{
    "args": {
        "x": "1",
        "y": "2"
    },
    "headers": {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate",
        "Connection": "close",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/0.9.9"
    },
    "origin": "221.148.61.230",
    "url": "http://httpbin.org/get?x=1&y=2"
}
```

POST 요청

```
http POST http://localhost:8000/sample/posts/ message="세번째 글"

HTTP/1.1 201 Created
Allow: GET, POST, HEAD, OPTIONS
Content-Length: 34
Content-Type: application/json
Date: Tue, 07 Jan 2020 08:54:39 GMT
Server: WSGIServer/0.2 CPython/3.8.1
Vary: Accept, Cookie
X-Content-Type-Options: nosniff
X-Frame-Options: DENY

{
    "id": 3,
    "message": "세번째 글"
}

이런식으로 생성, 검토 가능
```

PUT 요청

```
쉘> http PUT httpbin.org/put hello=world

HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 452
Content-Type: application/json
Date: Sat, 14 Oct 2017 18:37:05 GMT
Server: meinheld/0.6.1
Via: 1.1 vegur
X-Powered-By: Flask
X-Processed-Time: 0.00133204460144

{
    "args": {},
    "data": "{\"hello\": \"world\"}",
    "files": {},
    "form": {},
    "headers": {
        "Accept": "application/json, */*",
        "Accept-Encoding": "gzip, deflate",
        "Connection": "close",
        "Content-Length": "18",
        "Content-Type": "application/json",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/0.9.9"
    },
    "json": {
        "hello": "world"
    },
    "origin": "221.148.61.230",
    "url": "http://httpbin.org/put"
}
```

DELETE 요청

```
쉘> http DELETE "httpbin.org/delete"

HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 351
Content-Type: application/json
Date: Sat, 14 Oct 2017 18:42:44 GMT
Server: meinheld/0.6.1
Via: 1.1 vegur
X-Powered-By: Flask
X-Processed-Time: 0.000683069229126

{
    "args": {},
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate",
        "Connection": "close",
        "Content-Length": "0",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/0.9.9"
    },
    "json": null,
    "origin": "221.148.61.230",
    "url": "http://httpbin.org/delete"
}
```

## Django를 통한 API 구현 샘플

Django에서는 데이터 유효성 검사 및 처리를 Form/ModelForm를 통해 처리하고, JSON 직렬화는 DjangoJSONEncoder [#doc](https://docs.djangoproject.com/en/1.11/topics/serialization/#djangojsonencoder)를 사용하거나 직접 변환합니다.

__API를 위한 별도 인증 및 사용량 통제 등의 기능은 기본 제공되지 않습니다.__  (django는 api를 만들라고만든것이아니므로)

__djangorestframework는 `장고의 Form/CBV을 컨셉을 그대로 가져왔습니다.` 고로 장고 Form/CBV를 잘 이해한다면djangorestframework에 대해서도 보다 깊은 이해가 가능할 것입니다__

Django에서 기본제공해주는 Model/ModelForm/View를 통해 다음 5가지 API를 구현해보고, 이어서 동일한 기능을 `django-rest-framework`를 통해 구현해보도록 하겠습니다.

- 새 포스팅 내용을 받아 등록하고, 확인 응답 : /post/new/ 주소로 POST 요청
- 포스팅 목록 및 검색 응답 : /post/ 주소로 GET 요청
- 10번글 포스팅 내용 응답 : /post/10/ 주소로 POST 요청
- 10번글 포스팅 내용 갱신하고, 확인 응답 : /post/10/update/ 주소로 POST 요청
- 10번글 포스팅 내용 삭제하고, 확인 응답 : /post/10/delete/ 주소로 POST 요청

장고 프로젝트를 먼저 생성하고, myapp 앱을 먼저 생성/등록해주세요.

__구현해봅시다.__

### 소스 구현

#### 모델 구현 : myapp/models.py

```python
from django.db import models

class Post(models.Model):
    message = models.TextField()
```

#### 폼 구현 : myapp/forms.py

```python
from django import forms
from .models import Post

class PostForm(forms.ModelForm):
    class Meta:
        model = Post
        fields = '__all__'
```

#### 뷰 구현 : myapp/views.py

```python
from django.http import HttpResponse, JsonResponse
from django.http import QueryDict
from django.shortcuts import get_object_or_404
from django.views.decorators.csrf import csrf_exempt
from .models import Post
from .forms import PostForm


@csrf_exempt    #api서버에서 요청할떄는 csrf토큰없으므로 예외로줌
def post_list(request):
    if request.method == 'GET':
        qs = Post.objects.all()
        data = [{'pk': post.pk, 'message': post.message} for post in qs]  # 수동 JSON 직렬화!!, 직렬화란, 어떠한 객체를 문자열 형태로 변환함.
        return JsonResponse(data, safe=False)
    elif request.method == 'POST':
        form = PostForm(request.POST)
        if form.is_valid():
            post = form.save()
            return HttpResponse(status=201)
        data = form.errors
        return JsonResponse(data, status=400)


@csrf_exempt
def post_detail(request, pk):
    post = get_object_or_404(Post, pk=pk)

    if request.method == 'GET':
        return JsonResponse({'pk': post.pk, 'message': post.message})
    elif request.method == 'PUT':
        put = QueryDict(request.body)
        form = PostForm(put, instance=post)
        if form.is_valid():
            post = form.save()
            data = {'pk': post.pk, 'message': post.message}
            return JsonResponse(data=data, status=201)
        return JsonResponse(form.errors)
    elif request.method == 'DELETE':
        post.delete()
        return HttpResponse('', status=204)
```

#### URLConf 구현 : myapp/urls.py

```python
from django.conf.urls import url
from .views import post_list, post_detail

urlpatterns = [
    url(r'^post/$', post_list, name='post-list'),
    url(r'^post/(?P<pk>\d+)/$', post_detail, name='post-detail'),
]
```

Slide Type-SlideSub-SlideFragmentSkipNotes

#### __요청 테스트__

```
쉘> http :8000                                       # 목록 조회
쉘> http --form POST :8000 message="hello world"     # 새 포스팅 등록
쉘> http :8000/1/                                    # 1번 포스팅 조회
쉘> http --form PUT :8000/1/ message="hello django"  # 1번 포스팅 수정
쉘> http :8000/1/                                    # 1번 포스팅 수정
쉘> http DELETE :8000/1/                             # 1번 포스팅 삭제
쉘> http :8000                                       # 목록 조회
```

## django-rest-framework를 통한 API 구현 샘플

설치

```
pip3 install djangorestframework
```

settings.py 에 앱 추가

```python
INSTALLED_APPS = [
    # 중략
    'rest_framework',
]
```

위에서 django의 ModelForm/View를 통해 직접 구현했던 API 인터페이스를 django-rest-framework를 통해 구현해봅시다.

아래의 PostViewSet은 Class Based View로서 위에서 장고로 구현했던 모든 기능을 일괄 제공해줍니다.

### 구현

#### 모델 : myapp/models.py

```python
from django.db import models

class Post(models.Model):
    title = models.CharField(max_length=100)
```

#### Serializer : myapp/serializers.py (Form과 유사기능)

```python
from rest_framework import serializers
from .models import Post

class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = '__all__'
```

#### 뷰 : myapp/views.py

```python
from rest_framework import viewsets
from .models import Post
from .serializers import PostSerializer

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
```

#### URL : myapp/urls.py

```python
from django.conf.urls import include, url
from rest_framework.routers import DefaultRouter
from .views import PostViewSet

router = DefaultRouter()
router.register(r'post', PostViewSet)

urlpatterns = [
    url(r'', include(router.urls)),
]
```

위에서 실습한 `http 요청`을 실습해보세요. 동일하게 잘 동작할 것입니다.

지금부터 `django-rest-framework`에 대해서 차근차근 살펴보도록 하겠습니다.