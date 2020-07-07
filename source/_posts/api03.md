---
title: DRF 기본편 3
date: 2020-01-11 18:36:55
categories: API
tags: [API, DRF]
---

# EP 03 - JSON 응답뷰 만들기 (부제 - APIView부터 ViewSet까지)

Tip: render= parser=>구조화된 객체로 만들어줌

장고에서는 뷰를 통해 HTTP요청을 처리합니다.

장고의 기본 함수기반뷰/클래스기반뷰를 활용하셔도 API를 충분히 만드실 수 있습니다. 하지만 `rest_framework`를 쓰신다면, `APIView`/`ViewSet`을 활용하시면, API뷰를 보다 적은 양의 코드로 효율적으로 작성하실 수 있습니다.

그에 앞서 장고 기본 뷰에서의 `Serializer` 활용코드를 먼저 살펴보겠습니다.

## Serializer를 통한 뷰처리

`rest_framework`의 `Serializer`는 장고의 Form과 유사한 역할을 합니다. __데이터 유효성 검사 및 데이터베이스로의 저장을 지원해줍니다.__

Serializer를 통한 뷰처리는 다음과 같습니다.

```python
class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ['title', 'content']

# views 직접만듬 , data가 첫번째 인자가 아니므로data= 반드시 필요
serializer = PostSerializer(data=request.POST)
if serializer.is_valid():
    serializer.save()
    return JsonResonse(serializer.data, status=201)
return JsonResponse(serializer.errors, status=400)
```

Serializer에 대해서는 [Serializer를 통한 유효성 검사 및 저장](https://nomade.kr/vod/apiserver/164/) 에피소드에서 자세히 살펴보겠습니다.

## APIView 클래스와 api_view 장식자(3가지꼭잘다루기)

APIView클래스와 api_view 장식자는 뷰에 여러 기본 설정을 부여합니다. [관련코드](https://github.com/encode/django-rest-framework/blob/3.7.1/rest_framework/views.py#L100)

- 직렬화 클래스 지정 :

   

  ```
  renderer_classes
  ```

   

  속성 (list)

  - 디폴트
    - `rest_framework.renderers.JSONRenderer` : JSON 직렬화
    - `rest_framework.renderers.TemplateHTMLRenderer` : HTML 페이지 직렬화

- 비직렬화 클래스 지정 :

   

  ```
  parser_classes
  ```

   

  속성 (list)

  - 디폴트
    - `rest_framework.parsers.JSONParser` : JSON 포맷 처리
    - `rest_framework.parsers.FormParser`
    - `rest_framework.parsers.MultiPartParser`

- __인증 클래스 지정__ :

   

  ```
  authentication_classes
  ```

   

  속성 (list)

  - 디폴트
    - `rest_framework.authentication.SessionAuthentication` : 세션에 기반한 인증(세션에 로그인되어있다고기록된상태봄)
    - `rest_framework.authentication.BasicAuthentication` : HTTP Basic 인증

- __사용량 제한 클래스 지정__ : (초당 몇회, 요청 가능 제한가능, 골드 맴버쉽은 만회, 일반 멤버쉽은 100회처럼)

   

  ```
  throttle_classes
  ```

   

  속성 (list)

  - 디폴트 : 빈 튜플

- __권한 클래스 지정__ :

   

  ```
  permission_cla sses
  ```

   

  속성 (list)

  - 디폴트
    - `rest_framework.permissions.AllowAny` : 누구라도 접근 허용

- 요청에 따라 적절한 직렬화/비직렬화 클래스를 선택 :

   

  ```
  content_negotiation_class
  ```

   

  속성 (문자열)

  - 같은 URL로의 요청이지만, JSON응답을 요구하는 것이냐 / HTML응답을 요구하는 것인지 판단
  - 디폴트 : `rest_framework.negotiation.DefaultContentNegotiation`

- 요청 내역에서 API 버전 정보를 탐지할 클래스 지정 :

   

  ```
  versioning_class
  ```

   

  속성

  - 디폴트 : `None` : API 버전 정보를 탐지하지 않겠다.
  - 요청 URL에서, GET인자에서, HEADER에서 버전정보를 탐지하여, 해당 버전의 API뷰를 호출토록 합니다.

### 장고에는 FBV와 CBV가 있어요.

장고에는 FBV와 CBV가 있어요. 둘 다 많이 사용합니다. FBV는 Legacy가 아니예요.

- FBV (함수 기반 뷰, Function Based View)
  - 함수로 구현한 뷰
  - **Specialize 한 뷰는 FBV로 구현하는 것이 훨씬 간단**
- CBV (클래스 기반 뷰, Class Based View)
  - 클래스로 구현한 뷰
  - 재사용성에 포커스 : 여러 뷰에 걸쳐서, 반복되는 루틴이 있다면 **클래스 상속**문법을 통해 중복을 줄여갈 수 있어요.

`rest_framework`에서 지원해주는 API 뷰를 구현하기 위해 다음 2가지를 지원해줍니다.

- `APIView` : CBV
- `api_view` : FBV >>파이썬 장식자

### APIView [#tutorial](http://www.django-rest-framework.org/tutorial/3-class-based-views/) 샘플

APIView는 django-rest-framework 규격의 Class Based View입니다.

아래는 만들것

1. 하나의 Class Based View이므로, 한 URL에 대해서만 처리할 수 있습니다.

   `/post/`에 대한 CBV일 경우

   - get요청 : 포스팅 목록 요청
   - post요청 : 새 포스팅 등록 요청

   `/post/10/`에 대한 CBV일 경우

   - get요청 : 10번 포스팅 내용 요청
   - put요청 : 10번 포스팅 수정 요청
   - delete요청 : 10번 포스팅 삭제 요청

2. 요청 method에 맞게 멤버함수를 정의하면, 해당 method 요청이 들어올 때 호출이 됩니다.

   - `def get(self, request)`
   - `def post(self, request)`
   - `def put(self, request)`
   - `def delete(self, request)`

3. 각 method가 호출될 때, 다음 처리가 이뤄집니다.

   - 직렬화/비직렬화
   - 인증 처리 : 인증 체크
   - 사용량 제한 체크 : 호출 허용량 범위인지 체크
   - 권한 클래스 지정 : 비인증유저/인증유저에 대해 해당 API 호출을 허용할 것인지를 결정
   - 요청된 API 버전 문자열을 탐지하여 `request.version`에 저장

APIView 클래스를 활용하여, 다음과 같이 글목록응답/새글등록을 처리해주는 CBV를 만들어보겠습니다.

```python
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Post
from .serializers import PostSerializer

class PostListAPIView(APIView):
    def get(self, request):
        # 모델 serializer에서는 queryset또는 model인스턴스 넣을수있는데 queryset이면 many=True를 해줘야함
        serializer = PostSerializer(Post.objects.all(), many=True) 
        return Response(serializer.data)

    def post(self, request):
        serializer = PostSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)
```

새글 터미널에서 생성해보기(httpie이용)

```
http --form http://localhost:8000/ep03/post/ title='제목' content='내용'
```



APIView 클래스를 활용하여, 다음과 같이 특정 글의 내용응답/수정/삭제를 처리해주는 CBV를 만들어보겠습니다.

```python
from django.shortcuts import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Post
from .serializers import PostSerializer

class PostDetailAPIView(APIView):
    def get_object(self, pk):
        return get_object_or_404(Post, pk=pk)

    def get(self, request, pk, format=None):
        post = self.get_object(pk)
        serializer = PostSerializer(post)
        return Response(serializer.data)

    def put(self, request, pk):
        post = self.get_object(pk)
        serializer = PostSerializer(post, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) #여기 그냥 400써도무방

    def delete(self, request, pk):
        post = self.get_object(pk)
        post.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
```

Slide Type-SlideSub-SlideFragmentSkipNotes

POST요청을 받기 위해 별도로 `csrf_exempt` 처리를 해줄 필요가 없습니다. `APIView.as_view()`에서 이미 `csrf_exempt`(장식자)처리된 뷰를 만들어주고 있기 때문입니다.(settings.py에 middleware에서 csrfviewmiddleware처리를예외처리)

```python
# rest_framework/views.py
from django.views.decorators.csrf import csrf_exempt

class APIView(View):
    # 중략

    @classmethod
    def as_view(cls, **initkwargs):
        # 중략
        return csrf_exempt(view)  # HERE !!!
```

파이썬의 장식자활용법은 다음과 같이 활용할 수 있습니다.

```python
# 장식자 문법으로 써도 되고,(어떤 뷰에대해)
@csrf_exempt
def myview1(request):
    return HttpResponse('hello askdjango')

# 장식자는 실제로 다음과 같이 동작합니다.!! 한번 래핑하는원리
def myview2(request):
    return HttpResponse('hello askdjango')
myview2 = csrf_exempt(myview2)
```

### `@api_view` 장식자 샘플

`api_view`는 django-rest-framework 규격의 Function Based View를 세팅해주는 **장식자 (Decorator)**입니다.

참고) 장식자에 대한 자세한 내용은 [파이썬 차근차근 시작하기 - 장식자](https://nomade.kr/vod/python/102/)를 참고해보세요.

위에서 구현한 CBV버전의 `PostListAPIView`를 FBV로 구현하면 다음과 같습니다.

```python
from django.http import get_object_or_404
from rest_framework import status, Response
from rest_framework.decorators import api_view
from .models import Post
from .serializers import PostSerializer

@api_view(['GET', 'POST']) #cbv와 달리, 하나 함수안에 각각 방식을 모름.
def post_list(request):
    if request.method == 'GET':
        serializer = PostSerializer(Post.objects.all(), many=True)
        return Response(serializer.data)
    else:
        serializer = PostSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)
```

어떤가요? CBV에 비해서 조금 직관적이죠? :)

`@api_view`에서는 허용할 **http method**를 지정해줘야하는 것이 조금 다릅니다.

위에서 구현한 CBV버전의 `PostDetailAPIView`를 FBV로 구현하면 다음과 같습니다.

```python
from rest_framework.decorators import api_view

@api_view(['GET', 'PUT', 'DELETE'])
def post_detail(request, pk):
    post = get_object_or_404(Post, pk=pk)

    if request.method == 'GET':
        serializer = PostSerializer(post)
        return Response(serializer.data)
    elif request.method == 'PUT':
        serializer = PostSerializer(post, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    else:
        post.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
```

## mixins [#src](https://github.com/encode/django-rest-framework/blob/master/rest_framework/mixins.py) 상속을 통한 APIView 로직 재사용

위에서 구현한 APIView에서는 직접 `Serializer`를 처리를 해줬어야했습니다. 그런데 여러 `Serializer`에 대해서 구현을 하다보면 필연적으로 중복이 발생하게 됩니다. 이를 줄여보고자 하는 데요.

`APIView`는 클래스이기 때문에 클래스 상속을 통해 로직을 재활용할 수 있습니다.

`rest_framework.mixins`에서는 다음 Mixin을 통해 __위에서 구현한 기능__들을 모두 지원합니다. 참고로 파이썬에서 Mixin 문법이 따로 있는 것이 아니라, 문법적으로는 단순히 파이썬 클래스입니다. [관련코드](https://github.com/encode/django-rest-framework/blob/master/rest_framework/mixins.py) (즉, 저렇게 뷰의 로직을 직접 해줄필요없다 이미 다 비슷하기때문에 상속받아서쓰자,)

- `CreateModelMixin` : `create` 함수
- `ListModelMixin` : `list` 함수
- `RetrieveModelMixin` : `retrieve` 함수
- `UpdateModelMixin` : `update` 함수
- `DestroyModelMixin` : `destroy` 함수

이렇게 여러 Mixin이 준비만 되어있습니다. 이 함수들이 호출되기 위해서는 직접 연결해주셔야 합니다.

`PostListAPIView`를 다음과 같이 구현해봅시다. :D

```python
from rest_framework import generics
from rest_framework import mixins

class PostListAPIView(mixins.ListModelMixin, mixins.CreateModelMixin,
                   generics.GenericAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)
```

`PostDetailAPIView`를 다음과 같이 구현해봅시다. :D

```python
from rest_framework import generics
from rest_framework import mixins

class PostDetailAPIView(mixins.RetrieveModelMixin, mixins.UpdateModelMixin,
                     mixins.DestroyModelMixin, generics.GenericAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    def get(self, request, *args, **kwargs):
        return self.retrieve(request, *args, **kwargs)

    def put(self, request, *args, **kwargs):
        return self.update(request, *args, **kwargs)

    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)
```

자. 어떤가요? 코드가 훨씬 간결해졌죠?

FBV만 쓰다가 처음으로 CBV를 썼을 때의 감동이 밀려오는 듯 하네요. :D

## generics APIView를 통한 로직 재사용

위에 연결과정 조차 이미 다 만들어놓은것도있다.

REST API에서는 목록조회와 생성을 하나의 URL에서 처리합니다. 그래서 이를 하나로 묶은 CBV도 `rest_framework`에서 지원합니다.

```python
# rest_framework/generics.py
class ListCreateAPIView(mixins.ListModelMixin,
                        mixins.CreateModelMixin,
                        GenericAPIView):

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)
```

그래서 이를 활용하면, 코드가 이렇게 간단해져요 :D

```python
from rest_framework import generics

class PostListAPIView(generics.ListCreateAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
```

그리고 특정 레코드의 조회/수정/삭제도 하나의 URL에서 처리를 합니다. 그래서 이를 하나로 묶은 CBV도 지원합니다.

```python
# rest_framework/generics.py
class RetrieveUpdateDestroyAPIView(mixins.RetrieveModelMixin,
                                   mixins.UpdateModelMixin,
                                   mixins.DestroyModelMixin,
                                   GenericAPIView):

    def get(self, request, *args, **kwargs):
        return self.retrieve(request, *args, **kwargs)

    def put(self, request, *args, **kwargs):
        return self.update(request, *args, **kwargs)

    def patch(self, request, *args, **kwargs):
        return self.partial_update(request, *args, **kwargs)

    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)
```

그래서 이를 활용하면, 코드가 이렇게 간단해지죠. :D

```python
from rest_framework import generics

class PostDetailAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
```

위에서 살펴본 generics 외에도, 다음 generics가 추가로 지원됩니다. 모두 `GenericsAPIView`를 상속받으므로 추가로 상속받으실 필요가 없습니다.

- `generics.CreateAPIView` : 생성만 지원
- `generics.ListAPIView` : 목록만 지원
- `generics.RetrieveAPIView` : 조회만 지원
- `generics.DestroyAPIView` : 삭제만 지원
- `generics.UpdateAPIView` : 수정만 지원
- `generics.RetrieveUpdateAPIView` : 조회/수정 지원
- `generics.RetrieveDestroyAPIView` : 조회/삭제 지원

## 최종병기 ViewSet

__하나의 Model에 대해서 기본적인 REST API는 목록/생성/조회/수정/삭제인데요. 이를 지원할려면 2개의 URL, 즉 다음과 같이 2개의 뷰가 필요합니다.__

```python
from rest_framework import generics

class PostListAPIView(generics.ListCreateAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

class PostDetailAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
```

2개의 뷰 모두 `queryset`, `serializer_class`를 동일하게 지정하고 있습니다. 이를 한 번에 처리해주면 좋겠어요.

그것이 **ViewSet**입니다. ViewSet은 CBV가 아닙니다. 2개의 뷰를 만들어주는 **헬퍼 클래스**일 뿐입니다. ViewSet은 다음 2가지가 지원되고 있습니다.

- `viewsets.ReadOnlyModelViewSet` : 목록 조회, 특정 레코드 조회를 지원 => 2개의 URL 지원
- `viewsets.ModelViewSet` : 목록 조회, 생성, 특정 레코드 조회/수정/삭제 지원 => 2개의 URL 지원

조회만 지원하는 API를 만들어볼까요? ㅎㅎ

가입한 회원 목록에 대한 API가 제공된다면 **조회 기능**만 제공하는 것이 좋을 듯 하네요. "회원 생성" 기능은 별도의 가입기능을 활용해야겠죠? :)

다음과 같이 `UserViewSet`를 만들었다면, 목록조회/특정유저조회 API를 제공받으실 수 있습니다.

Tip: 장고에서 기본지원 User모델 get_user_model()로 인자부름 get_user_model().objects.all()가능

```python
from rest_framework import viewsets

class UserViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
```

이렇게 만들어진 `UserViewSet`을 URLConf에 등록해야겠죠?

다음과 같이 `UserViewSet`을 통해, 개별 View를 생성하실 수도 있습니다.

```python
#views.py

user_list = UserViewSet.as_view({
    'get': 'list',  # 호출될 함수와 호출할 함수를 지정합니다.
})

user_detail = UserViewSet.as_view({
    'get': 'retrieve',
})
```

하지만 이렇게 하지 않아도 `Router`를 통해 일괄적으로 URLConf에 등록하실 수 있습니다.

```python
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'user', views.UserViewSet)
# router.register(r'post', views.PostViewSet)  # PostViewSet이 있다면, 다음과 같이 추가등록하실 수 있습니다.

# 아래처럼 등록하면 결국엔 각 url이 user/, user/<pk>이런 Url에 대응하는것을 만들어줌
urlpatterns = [
    url(r'', include(router.urls)),
]
```