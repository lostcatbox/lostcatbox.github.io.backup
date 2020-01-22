---
title: api 기본편 5 + 6 + 7
date: 2020-01-18 14:31:37
categories: API
tags: [API, DRF]
---

# EP 05 - format 인자와 다양한 Renderer

`rest_framework.response.Response`에서는 2가지 타입의 응답을 할 수 있습니다. (response.py에서 Response클래스)

APIView를 쓸때는 Response()의 인자로 응답을 하게되는데 Response는 Renderer속성을 참조함 >> renderer 기본으로 2가지포맷을만 활성화되어있다.

- `api` : API Endpoint에 브라우저를 통해 접근할 때, 웹UI로 API를 조회할 수 있습니다.
- `json` : 보통의 API 접근 시

API 요청에서는 `format=json`으로 디폴트 처리되며, 웹브라우저를 통해 요청될 때에는 `format=api`로 디폴트 처리됩니다.

APIView에서는 출력포맷을 결정하는 format인자를 다음 3가지 형태로 받을 수 있습니다.

- Accept 헤더
- GET인자 format
- URL끝에 ".포맷"

지정 예) JSON 응답 요청

```
http :8000/ep04/ Accept:application/json
http :8000/ep04/?format=json
http :8000/ep04/.json     #router에서 url
```

지정 예) HTML 응답 요청>>이 형태가 브라우저로들어갈때의 rest-framework가 보여주는api

```
http :8000/ep04/ Accept:text/html
http :8000/ep04/?format=api
http :8000/ep04/.api      #router에서 url
```

헤더와 GET인자를 활용하는 방법은 별도의 URL Conf 설정이 필요없습니다. 하지만 `:8000/.json`의 경우에는 "인자 Capture"가 필요하므로 별도의 URL Conf 설정이 필요하며 뷰에서도 `format` 이름의 인자를 받을 수 있어야 합니다.

Tip: 인자 capture란 url에서 \<int:pk\>/edit 같이 숫자인자를 capture하는것처럼 추출하는것

URLConf에서 format인자에 대한 패턴을 직접 정의할 필요는 없습니다. 기존 URL Conf설정을 활용하여 format 인자 지원을 `rest_framework`에서 도와줍니다. 만약 다음 2가지 URL이 있다면 (router쓰지않고)

- `/post/`
- `/post/1/`

다음 URL도 사용토록 도와줍니다.

- `/post.json` : 포스팅 목록 (JSON 포맷)
- `/post/1.json` : 1번 포스팅 (JSON 포맷)
- `/post.api` : 포스팅 목록 (HTML 포맷)
- `/post/1.api` : 1번 포스팅 (HTML 포맷)

실제 코드를 살펴봅시다.

```python
# myapp/urls.py

from rest_framework.urlpatterns import format_suffix_patterns

urlpatterns = [
    # 이미 여러 url pattern이 등록되어있을 것입니다.
]

# 기존 urlpatterns 끝에 추가합니다. 이를 통해 인자로 넘겨진 urlpatterns에 suffix지원을 추가해줍니다.
urlpatterns = format_suffix_patterns(urlpatterns)
```

하지만, `DefaultRouter`를 사용하고 계시다면, 위 `format_suffix_patterns`처리를 추가로 하실 필요가 없습니다. `DefaultRouter`내에서 이미 처리되어있습니다.

`ViewSet`에서는 별도로 신경써줄 것은 없으며, `@api_view`장식자를 적용한 함수 뷰에서는 `format인자`를 받을 수 있도록 `Keyword 인자`를 필히 지정해줘야합니다. 인자만 받을 수 있도록 할 뿐 추가로 구현해야할 것은 없습니다. `api_view`와 `Response`를 통해 `format`인자가 처리됩니다.

Tip: url에서 capture해서 keyword agrument로 format이라는 인자로 뷰로 넘겨주는데, 함수뷰에는 format을 받을수있어야하므로 format=none필요 

```python
# myapp/views.py

from rest_framework.decorators import api_view

@api_view(['GET', 'POST'])
def post_list(request, format=None):
    # Response 활용

@api_view(['GET', 'PUT', 'DELETE'])
def post_detail(request, pk, format=None):
    # Response 활용
```

이제, 다음 URL을 통해 format인자를 지정해보세요.

- `http :8000/ Accept:application/json`
- `http :8000/?format=json`
- `http :8000/.json`
- `http :8000/ Accept:text/html`
- `http :8000/?format=api`
- `http :8000/.api`

Tip: 

```
http 'http://localhost:8000/ep04/?format=api' # ?가 인식이되므로 문자열로 보내줘야실행됨
```

__즉 내가 어떤 상태에서 어떤 요청을 하냐에따라 다양한 renderer가 사용됨__

# 기본 지원되는 Renderer 몇 가지(DRF에서)

- **`JSONRenderer`** (디폴트 지정) : `json.dumps`를 통한 JSON 직렬화
  - `format`: `json`
- `BrowsableAPIRenderer` (디폴트 지정) : self-document HTML 렌더링
  - `format`: `api`
- `TemplateHTMLRenderer` : 지정 템플릿을 통한 렌더링 (api인데 왜 html을부르냐,,차라리 django쓰자)
  - `format`: `html`
  - `template_name`: 지정 필요
  - 템플릿을 찾는 순서
    - Response에서 `template_name` 찾기 : `return Response({}, template_name='mytempalte.html')`
    - Renderer에서 `template_name` 찾기
    - 뷰 클래스에서 `get_template_names` 함수 찾기
    - 뷰 클래스에서 `template_name` 속성 찾기

Tip: json만으로 renderer 응답해주고싶다면 재정의를 이용하여 BrewsableAPIRenderer를 뺴주면됨

```
# settings.py 

REST_FRAMEWORK = {
    'DEFAULT_RENDERER_CLASSES': (
        'rest_framework.renderers.JSONRenderer',
        #'rest_framework.renderers.BrowsableAPIRenderer'
    )
}


```



## API를 사용하는 HTML 페이지 만들기

참고: http://www.django-rest-framework.org/topics/html-and-forms/

Django Form을 사용하지 않고, DRF를 통해 HTML페이지에서; 폼처리를 할 수는 있습니다. 하지만 이 부분은 DRF를 쓰기보다 Django Form을 사용하는 것이 보다 효율적인 듯 해서, 다루진 않겠습니다.

언젠가 Django Form과 Serializer가 합쳐지는 날이 오지 않을까 싶네요.





# EP 06 - 필터링

목록조회 APIView(`ListAPIView`)에서는 조건에 따라 QuerySet을 필터링이 필요할 수 있습니다.(특정 유저에게 보여줄것이 다를때 등등) `APIView`는 `View`를 상속받은 `CBV`이므로, `CBV`에서 하던 대로 필터링을 수행할 수 있습니다.

### 필터링에 필요한 인자 획득

`self.request`를 통해 `HttpRequest`객체를 참조할 수 있습니다.

- `self.request.user` : 현재 로그인 유저 Instance. 로그아웃 시에는 AnonymousUser(모델클래스가있는 일반 파이썬 클래스이므로 유저 모델 인스턴스에 필터못해, 일반 파이썬 클래스이므로 ???) 인스턴스
- `self.request.GET` : 요청 `GET인자` (QueryDict타입)
- `self.request.query_params` : __`GET인자`와 동일한 값입니다. `rest_framework`에서는 보다 가독성높은 이름으로서 이 속성을 지원__하고 있습니다.

```python
urlpatterns = [
    url(r'^(?P<username>\w+)/$', views.PostListAPIView.as_view()),
    url(r'^$', views.PostListAPIView.as_view()),
]
```

그리고,FBV에선 url에서 넘어오는 값을 현재 username으로 인자를 받고 지금은 `CBV`이기에 `self.kwargs`를 통해 `URL Capture`된 인자를 획득할 수 있습니다.(사전형식으로 모두 넘어옴,) 아래와 같이 URL패턴이 정의되어있을 경우, `self.kwargs['username']`으로 해당 값을 참조할 수 있습니다. 

```
self.kwargs.get('username', '') #사전에서 지원해주는 동작, 있다면 가져오고 없다면 빈문자열 가져옴
```

```
# 상관없는 내용ㅇ foreignkey복습필요, user_model보기
from django.db import models
from django.conf import settings

class Post(models.Model, on_delete=models.CASCADE):
    author = models.ForeignKey(settings.AUTH_USER_MODEL)
    title = models.CharField(max_length=100)
    content = models.TextField()
    is_public = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

```

foreignkey에 대해서는 django에서 현재 [On_delete](https://lee-seul.github.io/django/backend/2018/01/28/django-model-on-delete.html) 를 반드시 지정해야함

### get_queryset을 통한 쿼리셋 필터링

`ListAPIView`에는 `queryset`인자를 지정하고, 상황에 따라 필터링이 필요한 경우에는 `get_queryset`함수를 재정의해서 구현할 수 있습니다.

```python
from rest_framework import generics

class PostListAPIView(generics.ListAPIView):
    queryset = Post.objects.all()

    def get_queryset(self):
        qs = super().get_queryset()
        qs = qs.filter(...)  # 직절히 필터링
        return qs
```

예시

```
#views.py

from django.shortcuts import render
from ep04.models import Post
from ep04.serializers import PostSerializer
from rest_framework.viewsets import ModelViewSet

class PostViewSet(ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    def get_queryset(self):
        qs = super().get_queryset()
        if self.request.user.is_authenticated:  #로그인상태라면
            qs = qs.filter(
                author=self.request.user
            )
        else:
            qs = qs.none() #empty result 나옴


        return qs

```

## Search 구현(브라우저에서접속하는 api환경에서 ui생성)

[Django Admin의 Search기능](https://docs.djangoproject.com/en/dev/ref/contrib/admin/#django.contrib.admin.ModelAdmin.search_fields)(즉, 장고 admin.py에서 search_fields = ('title', 'content')추가하면 admin환경에서 검색기능 활성화되는것처럼..)과 유사하게 제공합니다. 이는 별도의 검색엔진을 사용하는 것이 아니라, __DBMS의 LIKE/ILIKE 조건절을 활용합니다.__ (순수 DB에 query한다)

```python
from rest_framework.filters import SearchFilter

class PostListAPIView(generics.ListAPIView):
    # 중략

    filter_backends = [SearchFilter]
    search_fields = ['title']  # 검색 키워드를 지정했을 때, 매칭을 시도할 필드
```

검색시

```
GET /ep06/post/?search=%EC%B2%AB%EB%B2%88%EC%A7%B8

In [6]: '첫번째'.encode('utf-8')
Out[6]: b'\xec\xb2\xab\xeb\xb2\x88\xec\xa7\xb8'
```

요청주소가 나오는데 결국 get인자 search라는 이름으로 '첫번째'.encode('utf-8') 



```
로그인상태 구별하는것 주석처리후 httpie를 이용하여
 http localhost:8000/ep06/post/ search=='첫'
 검색됨
```



아래방법은 그냥 기본적인 검색

```
    def get_queryset(self):
        qs = super().get_queryset()

        search = self.request.GET.get('search','')

        if search:
            qs = qs.filter(title__icontains=search)
        if self.request.user.is_authenticated:  #로그인상태라면
            qs = qs.filter(
                author=self.request.user
            )
        else:
            qs = qs.none() #empty result 나옴


        return qs

```

# EP 07. Pagination 처리(ep03앱을 이용)

레코드 갯수가 많은 경우 목록을 하나의 API 요청만으로 받는 것은 피해야할 것입니다. 이럴 때 여러 페이지에 나눠서 요청을 처리할 수 있겠는 데요. 이에 대해 `rest_framework`에서는 여러 페이징 기법을 지원해주고 있습니다.

- ```PageNumberPagination```:```page```인자를 통해 페이징 처리 (page는 페이지수, page_size는 page당 post수)
  - `http://api.example.org/accounts/?page=4`
  - `http://api.example.org/accounts/?page=4&page_size=100`
- ```LimitOffsetPagination```:```limit```인자를 통한 페이징 처리(offset은 레코드정렬순서기준 400번째부터~, limit 까지, limit만 지정시 처음부터 limit까지)
  - `http://api.example.org/accounts/?limit=100`
  - `http://api.example.org/accounts/?offset=400&limit=100`

`rest_framework/generics.py` 내 `GenericAPIView`에는 이미 `pagination_class = PageNumberPagination` 설정이었습니다. 하지만, `3.7.0`버전부터는 `디폴트 None`으로 지정으로 변경되었습니다. 현재 (2017년 11월) 최신 버전은 `3.7.3`버전입니다.



```
# 버전확인
pip3 freeze | grep djangorestframework
```

```
#models.py 에서 순서 꼭 지정해주기 ordering

class Post(models.Model):
    title = models.CharField(max_length=100)
    content = models.TextField()ㄴ
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ('-id',)  #,가 튜플이라는 증거

```



__Tip: `3.7.0`버전부터 디폴트 페이징 클래스 설정이 `None`으로 [디폴트 설정이 변경](https://github.com/encode/django-rest-framework/commit/107e8b3d23a933b8cdc1f14045d7d42742be53a9#diff-f9716c39348a77db61afdaa2ed35cd87R54)되기에, 낮은 버전을 쓰고 계시더라도 다음과 같이 전역설정을 해두시는 것이 좋습니다. ;) 기본 페이징사이즈도 넣어주는게 좋음__

```python
# settings.py

REST_FRAMEWORK = {
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 3,
}
```



## 커스텀으로 pagination

```python
from rest_framework.pagination import PageNumberPagination

class GenericAPIView(ApiView):
    pagination_class = PageNumberPagination  # 디폴트 지정
```

하지만 디폴트 설정으로 `PAGE_SIZE`인자가 `None`으로 설정되어있기 때문에, 리스트 처리에서 페이징처리가 되지 않습니다. 다음과 같이 전역으로 `PAGE_SIZE`설정을 하셔도 되구요.

```
# 프로젝트/settings.py

REST_FRAMEWORK = {
    'PAGE_SIZE': 20,  # 디폴트 값은 None으로서 페이징 비활성화
}
```

각 API별로 `PAGE_SIZE`설정을 다르게 할 수도 있지만, 이는 `Pagination`의 역할이기에 `Pagination`을 커스텀하셔야 합니다.

```python
from rest_framework.pagination import PageNumberPagination

class PostPageNumberPagination(PageNumberPagination):
    page_size = 20

class PostViewSet(..):
    pagination_class = PostPageNumberPagination
```

