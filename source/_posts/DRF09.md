---
title: DRF 기본편 9
date: 2020-01-22 12:35:36
categories: API
tags: [API, DRF]
---

## EP 09 - Authentication과 Permissions

이제 API 요청을 처리할 때 접근제한을 지원해봅시다. 아무나 다른 사람의 글을 수정/삭제할 수 있어서는 안 되겠습니다.

Django에서는 `auth`앱을 통해 `User`모델을 지원해주고 있습니다.

`User`모델을 통해 `Post`모델에 작성자를 기록해봅시다. (현재 ep08에서작업중)

```python
# myapp/models.py
from django.conf import settings  # 추가
from django.db import models

class Post(models.Model):
  author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='ep08_post_set')  # 추가
  title = models.CharField(max_length=100)
```

오류는 이미 ep04에서 ForeignKey이미 똑같이 사용중이므로 여기에서 reverse를 할때 둘중무엇을 돌려줘야할지겹쳐버리게된다. 따라서 `related_name='ep08_post_set'`를 지정해주면 ep04에서는 `user.post_set.all()`  으로 관련 포스트에 대한 쿼리 모두가져올수있고, ep08모델에서는  `user.ep08_post_set.all()` 으로 관련 포스트에 대한쿼리 모두 가져올수있다.

```
쉘> python3 manage.py makemigrations myapp

You are trying to add a non-nullable field 'author' to post without a default; we can't do that (the database needs something to populate existing rows).
Please select a fix:
 1) Provide a one-off default now (will be set on all existing rows with a null value for this column)
 2) Quit, and let me add a default in models.py
Select an option: 1
Please enter the default value now, as valid Python
The datetime and django.utils.timezone modules are available, so you can do e.g. timezone.now
Type 'exit' to exit this prompt
>>> 1

쉘> python3 manage.py migrate myapp
```

필수필드로서 `author` 필드를 추가했기 때문에 `makemigrations` 명령 수행 시에 질문이 나옵니다. 마이그레이션에 대해서 가물가물하신 분은 "[장고 기본편 Migration](https://nomade.kr/vod/django/9/)" VOD 에피소드를 참고하세요.

이제 json api 요청을 하면, author부분은 Primary Key값이 지정되어 다음과 같은 응답이 옵니다.

```
쉘> http GET :8000/1/

{
    "author": 1,
    # 중략
}
```

## 사용자 인증을 처리해봅시다. (Authentication)

지원하는 인증의 종류 (`rest_framework/authentication.py`)

- SessionAuthentication (웹브라우저에서 로그인시 세션에 로그인기록을 통해 인증)
  - 세션을 통한 인증 여부 체크
  - APIView를 통해 디폴트 지정 (우선순위 1)
- BasicAuthentication  (http의 인증헤더 사용)
  - Basic 인증헤더를 통한 인증 수행 (ex: `Authorization: Basic YWxsaWV1czE6MTAyOXNoYWtl`)
  - APIView를 통해 디폴트 지정 (우선순위 2)
- TokenAuthentication  (api에서 주로 사용)(django에서 유저마다 1:1로 token값가짐,재발급가능)
  - Token 헤더를 통한 인증 수행 (ex: `Authorization: Token 401f7ac837da42b97f613d789819ff93537bee6a`)
- RemoteUserAuthentication
  - User 정보가 다른 서비스에서 관리될 때, Remote 인증 ([장고 공식문서](https://docs.djangoproject.com/en/1.11/howto/auth-remote-user/))
  - Remote-User 헤더를 통한 인증 수행

인증 처리 순서

1. 매 요청 시마다 APIView의 dispatch(request) 호출
2. APIView의 initial(request) 호출
3. APIView의 perform_authentication(request) 호출
4. Request의 user Property 호출 (self.request.user 사용)
5. Request의 _authenticate() 호출
   - APIView를 통해 지정된 Authentication 호출

포스팅을 저장할 때, 현재 인증된 유저 정보를 기록토록 해보겠습니다. author필드를 API를 통해 지정되지 않도록 `PostSerializer`의 `Meta.fields`에서 author필드를 제외시켜주세요.

```python
# myapp/serializers.py

class PostSerializer(...):
    class Meta:
        model = ...
        fields = ['pk', 'title', 'content']
```

이제 API를 통해 Post 저장 시에 현재 인증된 유저를 지정해봅시다.

```python
# myapp/views.py
class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    def perform_create(self, serializer):  # 추가
        serializer.save(author=self.request.user)  # 추가
```

`perform_create` 함수는 `rest_framework/mixins.py`내 `CreateModelMixin` 클래스에서 `create`시에 호출을 하고 있습니다. 원래 구현은 단순히 `serializer.save()` 이지만, 메소드 오버라이딩을 통해 저장할 필드를 추가로 지정해줬습니다. `serializer.save(**kwargs)`함수는 `kwargs` 항목을 통해, 추가로 저장할 필드를 지정할 수 있습니다.

다음과 같이 요청해보면 500 에러응답을 받습니다. API 요청 시에 인증정보를 제공하지 않았기 때문에 `self.request.user`에 AnonymouseUser 인스턴스가 할당되어 모델저장에 실패한 것입니다. 외래키에는 "모델 객체"가 아닌 "파이썬 객체"는 할당할 수 없습니다.(로그인이 안되어있다면 userModel 인스턴스가 아니라 AnonymouseUser인스턴스가 할당되므로)

```
쉘> http --form POST :8000 title=t1 content=c1
HTTP/1.0 500 Internal Server Error
```

`perform_create` 호출 전에 인증여부를 체크하는 것이 필요하겠습니다만, 이는 뒤에서 살펴보겠습니다.

다음 명령으로 API 요청 시에 **HTTP Basic 인증헤더**를 제공해봅시다. `--auth` 인자로 웹로그인 아이디/암호를 지정해주세요.

```
쉘> http --auth username:password --form POST :8000 title=t1 content=c1
```

__이 요청에서 `"username:password"` 문자열은 base64로 인코딩되어 Authorization 헤더로 전달되고, 이 헤더를 BasicAuthorization에서 인지하여 인증을 처리합니다.__ `httpbin.org`를 통해 헤더를 확인해봅시다. 

```
쉘> http -a username:password --form POST httpbin.org/post

{
    "args": {},
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate",
        "Authorization": "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
        "Connection": "close",
        "Content-Length": "0",
        "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/0.9.9"
    },
    "json": null,
    "origin": "221.148.61.230",
    "url": "http://httpbin.org/post"
}
```

base64 인코딩은 파이썬에서는 다음과 같이 확인해보실 수 있습니다.

In [7]:

```
from base64 import b64encode

b64encode(b'username:password')
```

Out[7]:

```
b'dXNlcm5hbWU6cGFzc3dvcmQ='
```

base64 인코딩된 문자열은 손쉽게 디코딩해서 원본 문자열을 확득할 수 있습니다.

In [9]:

```python
from base64 import b64decode

b64decode(b'dXNlcm5hbWU6cGFzc3dvcmQ=')
```

Out[9]:

```python
b'username:password'
```

### 웹브라우저를 통한 API 접근에서 로그인/로그아웃 지원하기

django-rest-framework는 웹브라우저를 통한 API 접근도 지원해주기에, 웹브라우저를 통한 로그인/로그아웃도 지원해주고 있습니다. 이는 `auth`앱의 `login`/`logout`뷰를 그대로 활용하고 있으며, 템플릿만 `rest_framework/login.html`로 변경해서 적용되어있습니다.

웹브라우저로 `http://localhost:8000`에 접속해보시면, 화면 우상단에 `'Login'`버튼이 없습니다. `프로젝트/urls.py`에 다음과 같이 URLConf 설정을 변경해주세요.

```python
from django.conf.urls import include  # 추가가 안 되어있다면, 추가

# 중략

urlpatterns += [
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
]  #prefix이름은 바뀌어도 상관없음
```

이제 Login버튼이 보여집니다. 클릭해서 로그인을 수행해보세요. :D

### 권한 (Permission) 시스템 - 비인증 요청에 한해서 읽기권한만 부여하기

`django-rest-framework`에서는 Permission 시스템을 제공해주고 있습니다.

권한 체크는 다음 기본 룰을 가집니다. (django만으로 진행한다면)

- (userModel에서 필드가) is_superuser=True 유저는 별도 Permission을 지정하지 않아도 모든 권한이 허용
- is_staff=True 유저는 /admin/ 접속만 가능할 뿐, 일반 유저와 동일하게 허용된 권한만 가능
- is_active=False 유저는 권한 지정여부에 상관없이, 모든 권한 **불허** (is_active=True인경우에만 로그인가능)

`django-rest-framework`에서 기본 제공하는 Permission는 다음과 같습니다.

1. AllowAny : 인증여부에 상관없이, 뷰 호출 허용 (디폴트 지정)
2. __IsAuthenticated : 인증된 요청에 한해서, 뷰 호출 허용__
3. IsAdminUser : Staff 인증 요청에 한해서, 뷰 호출 허용
4. __IsAuthenticatedOrReadOnly : 비인증 요청에게는, 읽기 권한만 허용__
5. DjangoModelPermissions : 인증된 요청에 한해서만 뷰 호출을 허용하고, 추가로 유저별 인증 권한체크를 수행
6. DjangoModelPermissionsOrAnonReadOnly : DjangoModelPermissions과 유사하나, 비인증 요청에 대해서는 읽기 권한만 허용
7. DjangoObjectPermissions
   - 비인증된 요청은 거부
   - 인증된 요청에 한, Record 접근에 대한 권한체크를 추가로 수행

APIView 클래스에서는 permission_classes 속성을 통해 API별로 권한 체크를 다르게 가져갈 수 있습니다. ViewSet은 APIView를 상속받았으므로 동일하게 지정가능합니다. 다음과 같이 `IsAuthenticated`를 지정해보세요.

```python
from rest_framework.permissions import AllowAny, IsAuthenticated

class PostViewSet(viewsets.ModelViewSet):
    permission_classes = [
        # AllowAny, # 디폴트값임
        IsAuthenticated,
    ]
    # 생략
```

이제 인증되지 않은 모든 요청에 대해서는 모두 거부 403 Forbidden 응답을 받게됩니다.

```
쉘> http :8000/1/
HTTP/1.0 403 Forbidden
중략
{
    "detail": "Authentication credentials were not provided."
}
```

다음과 같이 인증에 통과하면, 해당 API요청은 정상적으로 처리됩니다.

```
쉘> http --auth username:password :8000/1/

HTTP/1.0 200 OK
중략
{
    "content": "c1",
    "pk": 1,
    "title": "t1"
}
```

### 커스텀 Permission 만들기

`django-rest-framework`에서 기본 제공해주는 Permission만으로도 대개 충분합니다만, 필요에 의해 커스텀 Permission을 만들고 싶을 수 있습니다.

모든 Permission 클래스는 다음 2가지 함수를 선택적으로 구현합니다.

- `has_permission(request, view)`: 뷰 호출 접근권한
  - APIView 접근 시, 체크
  - 이를 구현한 Permission 클래스 : IsAuthenticated, IsAdminUser, IsAuthenticatedOrReadOnly, DjangoModelPermissions, DjangoModelPermissionsOrAnonReadOnly

- `has_object_permission(request, view, obj)`: 개별 Record 접근권한
  - APIView의 get_object함수를 통해 object 획득 시, 체크 - 개별 GET/PUT/DELETE 요청
  - 브라우저를 통한 API 접근에서 CREATE/UPDATE Form 노출 여부 확인 시에, 체크
  - 이를 구현한 Permission 클래스 : DjangoObjectPermissions

기본 Permission 클래스 코드를 살펴보면, Permission 구현에 대한 이해도를 보다 높일 수 있습니다.

```python
# rest_framework/permissions.py

# 안전한 메소드 종류. 이 METHOD만으로는 단순 조회만 될 뿐, 데이터를 파괴 (추가/수정/삭제) 하지 못합니다.
SAFE_METHODS = ('GET', 'HEAD', 'OPTIONS')

# 인증여부에 상관없이, 뷰 호출 허용
class AllowAny(BasePermission):
    def has_permission(self, request, view):
        return True

# 인증된 요청에 한해서, 뷰 호출 허용
class IsAuthenticated(BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_authenticated

# Staff 인증 요청에 한해서, 뷰 호출 허용
class IsAdminUser(BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_staff

# 비인증 요청에게는, 읽기 권한만 허용
class IsAuthenticatedOrReadOnly(BasePermission):
    def has_permission(self, request, view):
        # 안전한 METHOD요청이면, 인증여부에 상관없이, 뷰 호출 허용
        if request.method in SAFE_METHODS:
            return True
        # 안전하지 않은 METHOD일 경우, 인증유저에게만, 뷰 호출 허용
        elif request.user and is_authenticated(request.user):
            return True
        # 안전하지 않은 METHOD일 경우, 비인증유저에게는, 뷰 호출 제한
        return False
------------------------------------------------------------------------
      
# 인증된 요청에 한해서만 뷰 호출을 허용하고, 추가로 유저별 인증 권한체크를 수행합니다.
# Django에서는 유저/그룹 별로 add/change/delete 권한을 세팅할 수 있습니다.
class DjangoModelPermissions(BasePermission):
    # 디폴트 설정으로, 인증된 유저에 한해서 권한 체크
    authenticated_users_only = True

    # perms_map을 통해, METHOD별로 체크할 권한을 지정합니다.
    perms = {
        # GET/OPTIONS/OPTIONS에 대해서는 별도 권한 체크를 하지 않습니다.
        'GET': [],
        'OPTIONS': [],
        'GET': [],

        # POST 요청 : 해당 모델에 대한 add 권한 체크
        'POST': ['%(app_label)s.add_%(model_name)'],

        # PUT/PATCH 요청 : 해당 모델에 대한 change 권한 체크
        'PUT': ['%(app_label)s.add_%(model_name)'],
        'PATCH': ['%(app_label)s.add_%(model_name)'],

        # DELETE 요청 : 해당 모델에 대한 delete 권한 체크
        'DELETE': ['%(app_label)s.add_%(model_name)'],
    }

    def has_permission(self, request, view):
        # 뷰에 '_ignore_model_permissions' 플래그가 True일 경우, 별도 체크없이, 모든 뷰 호출 허용
        if getattr(view, '_ignore_model_permissions', False):
            return True

        # 중략

        # 1) 현재 유저의 권한 체크
        has_perms = request.user.has_perms(perms)

        # 2) authenticated_users_only=True일 때에만, 유저의 인증여부 체크
        is_auth = (not authenticated_users_only) or (request.user and request.user.is_authenticated)

        return has_perms and is_auth


# DjangoModelPermissions과 유사하나, 비인증 요청에 대해서는 읽기 권한만 부여합니다.
class DjangoModelPermissionsOrAnonReadOnly(DjangoModelPermissions):
    authenticated_users_only = False


# DjangoModelPermissions의 has_permissions을 먼저 수행하고 권한이 있을 경우
#   (인증된 요청에 한해서만 권한 체크를 수행합니다.)
# 추가로 Record 접근에 대한 권한체크를 추가로 수행합니다.
class DjangoObjectPermissions(DjangoModelPermissions):
    def has_object_permissions(self, request, view, obj):
        # 중략
        if not user.has_perms(perms, obj):
            # 404 Not Found 응답을 할 지, 403 Forbidden(권한없음) 응답을 할지 결정

            # 현재 요청이 SAFE METHOD라면 404 처리
            # 읽기 권한에 대해서는 이미 체크되었고, 거부되었기에 더 이상의 체크가 필요없습니다.
            if request.method in SAFE_METHODS:
                raise Http404

            # 중략

            # GET METHOD 에 대해서도 권한이 없다면 404 처리
            if not user.has_perms(read_perms, obj):
                raise Http404

            # 403 응답
            return False

        return True
```

#### __포스팅 작성자에 한해서, 수정/삭제 권한 부여해봅시다.__

```python
from rest_framework import permissions

class IsAuthorOrReadonly(permissions.BasePermission):
    # 인증된 유저에 한해, 목록조회/포스팅등록을 허용
    def has_permission(self, request, view):
        return request.user.is_authenticated

    # 작성자에 한해, Record에 대한 수정/삭제 허용
    def has_object_permission(self, request, view, obj):
        # 조회 요청(GET, HEAD, OPTIONS) 에 대해서는 인증여부에 상관없이 허용
        if request.method in permissions.SAFE_METHODS:
            return True

        # PUT, DELETE 요청에 대해, 작성자일 경우에만 요청 허용
        return obj.author == request.user
```

#### 포스팅 작성자에 한해서, 수정 권한은 부여하되 삭제권한은 superuser에게만 부여해봅시다.

```python
from rest_framework import permissions

class IsAuthorUpdateOrReadonly(permissions.BasePermission):
    # 인증된 유저에 한해, 목록조회/포스팅등록을 허용
    def has_permission(self, request, view):
        return request.user.is_authenticated

    # superuser에게는 삭제 권한만 부여하고
    # 작성자에게는 수정 권한만 부여해봅시다.
    def has_object_permission(self, request, view, obj):
        # 조회 요청(GET, HEAD, OPTIONS) 에 대해서는 인증여부에 상관없이 허용
        if request.method in permissions.SAFE_METHODS:
            return True

        # 삭제 요청의 경우, superuser에게만 허용
        if (request.method == 'DELETE'):
            return request.user.is_superuser  # request.user.is_staff

        # PUT 요청에 대해, 작성자일 경우에만 요청 허용
        return obj.author == request.user
```

## 포스팅 조회 응답에 작성자 필드를 추가해봅시다.

__포스팅 조회 응답에 작성자 정보는 꼭 필요합니다. 이는 직렬화의 영역이므로 PostSerializer를 수정해야 합니다. PostSerializer.Meta.fields에 외래키인 author를 지정한다면 생성/수정 시에 author 지정이 가능해집니다. 그런데 author는 서버에서 인증에 의해서만 지정이 되어야합니다. 이때 `serializers.ReadOnlyField(source='참조할필드명.속성명')`을 써보세요.__

(굉장히 위험하므로 꼭 위에 내용참조해야됨)

```python
from rest_framework import serializers
from .models import Post

class PostSerializer(serializers.ModelSerializer):
    author_username = serializers.ReadOnlyField(source='author.username')  # 추가 foreignkey로 속성명 가져옴

    class Meta:
        model = Post
        fields = ['pk', 'author_username', 'title', 'cotnent']  # 'author_username' 추가
```

이제 조회해보면 `author_username` 필드가 조회됨을 확인하실 수 있습니다.

```
쉘> http :8000/1/

{
    "author_username": "askdjango",
    "content": "c1",
    "pk": 1,
    "title": "t1"
}
```

