---
title: api 기본편 13
date: 2020-01-26 14:08:46
categories: API
tags: [API, DRF]
---

# EP 13. Token **인증**

## DRF**에서 지원하는 인증** 

- rest_framework.authentication.SessionAuthentication
  - 외부서비스/앱에서세션인증을못쓰죠.

- rest_framework.authentication.BasicAuthentication
  - 외부서비스/앱에서 매번요청시 username/password를넘기는것은보안상위험하고,못할 짓.

- __rest_framework.authentication.TokenAuthentication__ (강추)
  - 초기에username/password으로 Token을발급받고,(유저마다 하나의 토큰이며, 언제든 폐기가능)
  - 이Token을 매API요청에 담아서 보내어 인증을처리

## **시작하기전에**-**기본코드**

```
# 앱/models.py

class Post(models.Model):
    #이미 다른 앱에서도 usermodel참고하고있으므로 reverse가 지정불가, related_name지정필요한데 '+'값을 주면 사용안됨
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=CASCADE, related_name='+')
    message = models.TextField(blank=True)
    photo = models.ImageField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
# 앱/serializers.py
from rest_framework.fields import ReadOnlyField
from rest_framework.serializers import ModelSerializer 

class PostSerializer(ModelSerializer):
    author_username = ReadOnlyField(source='author.username')
    
        class Meta:
            model = Post
            fields = ('id', 'author_username', 'message', 'photo')
```

```
# 앱/views.py
from rest_framework.authentication import TokenAuthentication 
from rest_framework.permissions import IsAuthenticated
from rest_framework.viewsets import ModelViewSet

class PostModelViewSet(ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer 
    authentication_classes = [TokenAuthentication]  #세션인증, basic에 유저인증 은 안됨
    permission_classes = [IsAuthenticated] #인증이 되어야만 처리
    
    def perform_create(self, serializer):
    		serializer.save(author=self.request.user)
    		
# 앱/urls.py
router = DefaultRouter()
router.register('post', PostModelViewSet)

urlpatterns = [
		url(r'', include(router.urls)),
]
```

## Token**인증설정하기**

```
# settings
INSTALLED_APPS = ( 'rest_framework.authtoken',
)
```

- migrate가 필요합니다.
- rest_framework.authtoken.Token모델에 대한 테이블을 생성해야 합니다



## Token**모델**

- 각 User에 대해 1:1 Relation => OneToOneField
- 각User별 Token인스턴스가자동생성되지않습니다.(모델생성했다고 자동생성절대안됨)
- Token은 유저 별로 Unique합니다. Token만으로 인증을 수행합니다.

```
# rest_framework/authotken/models.py

class Token(models.Model): # 모델 코드에서 주요부분만 발췌
    key = models.CharField(max_length=40, primary_key=True) 
    user = models.OneToOneField(settings.AUTH_USER_MODEL, related_name='auth_token')
```

## Token생성
### **방법**1) ObtatinAuthToken**뷰를 통한 획득** or **생성**

token 획득 API 뷰에서 Token 획득/생성을 아래 코드와 같이 처리하므로, **Token** **재생성**이 아니라면 특별히 처리해줄 필요는 없습니다.

```
# rest_framework/authtoken/views.py

class ObtainAuthToken(APIView):
    def post(self, request, *args, **kwargs):
    # 중략
    token, created = Token.objects.get_or_create(user=user)
    return Response({'token': token.key})
```

### **방법**2) Signal**을 통한 자동 생성** (**필수는 아님**)(이벤트헨들러느낌)

```
from django.conf import settings
from django.db.models.signals import post_save 
from django.dispatch import receiver
from rest_framework.authtoken.models import Token

@receiver(post_save, sender=settings.AUTH_USER_MODEL) # post_save 처럼 save가 일어나는건데 그게 AUTH_USER_MODEL일어날 경우 끝나고 아래 함수 실행
def create_auth_token(sender, instance=None, created=False, **kwargs):
		if created:  #save할때가 created or updated중에 created일때 작동
				Token.objects.create(user=instance)
```

### **방법**3) Management **명령을 통한 생성**

```
# 본 명령은 생성된 Token을 변경하지 않습니다. 필수는 아님. 
python3 manage.py drf_create_token <username>
# 강제로 Token 재생성하기
python3 manage.py drf_create_token -r <username>
```

## Token **획득을** API ENDPOINT로 노출하기

post만 처리가능함

```
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns += [
		url(r'^api-token-auth/', obtain_auth_token),
]
```

### HTTPie**를 통한** Token 획득

```
쉘> http POST http://주소/api-token-auth/ username="유저명" password="암호"
```

```
HTTP/1.0 200 OK
Allow: POST, OPTIONS
Content-Type: application/json
Date: Fri, 01 Dec 2017 06:49:35 GMT Server: WSGIServer/0.2 CPython/3.6.1
{
		"token": "9cdd705c0a0e5adb8671d22bd6c7a99bbacab227"
}
```

### HTTPie **예제** (**맥**/**리눅스**)

-헤더에 토큰값 넣어서 요청 보내야함(띄어쓰기 잘하기)

```
http http://localhost:8000/api/post/ "Authorization: Token <TOKEN값입력>" 
```



```
#환경변수를 설정해서 편하게 이용하자
export HOST="http://localhost:8000"
export TOKEN="d7ec115d8370de00f06c50ec5b61bd519b1038ae" 

# Post List
http $HOST/api/post/ "Authorization: Token $TOKEN"

# Post Create
http POST $HOST/api/post/ "Authorization: Token $TOKEN" message="hello" 

# Post Create with Photo
http --form POST $HOST/api/post/ "Authorization: Token $TOKEN" message="hello" photo@"f1.jpg"   # httpie 문법임, 현재 프로젝트전체폴에경로에존재하는 사진파일

# Post#16 Detail
http GET $HOST/api/post/16/ "Authorization: Token $TOKEN"

# Post#16 Update
http PATCH $HOST/api/post/16/ "Authorization: Token $TOKEN" message="patched" http PUT $HOST/api/post/16/ "Authorization: Token $TOKEN" message="updated"

# Post#16 Delete
http DELETE $HOST/api/post/16/ "Authorization: Token $TOKEN"
```

## **파이썬 코드를 통한** Token **획득**

``` 
import requests

HOST = 'http://localhost:8000'

res = requests.post(HOST + '/api-token-auth/', {
    'username': '유저명', # FIXME: 기입해주세요.
    'password': '암호',  # FIXME: 기입해주세요.
}) 
res.raise_for_status()

token = res.json()['token'] 

print(token)

이제 모든 요청에는 다음 인증헤더를 붙여주셔야 합니다. 

headers = {
		'Authorization': 'Token ' + token, # 필히 띄워쓰기 꼭 ㄴ필요
}
```

```
# Post List
res = requests.get(HOST + '/api/post/', headers=headers) res.raise_for_status()
print(res.json())

# Post Create
data = {'message': 'hello requests'}
res = requests.post(HOST + '/api/post/', data=data, headers=headers) print(res)
print(res.json())

# Post Create with Photo
files = {'photo': open('f1.jpg', 'rb')}
data = {'message': 'hello requests'}
res = requests.post(HOST + '/api/post/', files=files, data=data, headers=headers) 
print(res)
print(res.json())
```

```
# Post#16 Detail
res = requests.get(HOST + '/api/post/', headers=headers) 
res = requests.get(HOST + '/api/post/16/', headers=headers) res.raise_for_status()
print(res.json())

# Post#16 Patch
res = requests.patch(HOST + '/api/post/16/', headers=headers, data={'message': 'hello'}) 
res.raise_for_status()
print(res.json())

# Post#16 Update
res = requests.put(HOST + '/api/post/16/', headers=headers, data={'message': 'hello'}) 
res.raise_for_status()
print(res.json())

# Post#16 Delete
res = requests.delete(HOST + '/api/post/16/', headers=headers, data={'message': 'hello'}) 
res.raise_for_status()
print(res.ok)
```

### 실제 터미널

```
In [1]: import requests

In [3]: res = requests.post('http://localhost:8000/api-auth-token/', {'username'
   ...: :'tester', 'password': 'rhdiddl486'})

In [4]: res = requests.post('http://localhost:8000/api-token-auth/', {'username'
   ...: :'tester', 'password': 'rhdiddl486'})

In [5]: res
Out[5]: <Response [200]>

In [6]: res.text
Out[6]: '{"token":"d7ec115d8370de00f06c50ec5b61bd519b1038ae"}'

In [7]: res.json()
Out[7]: {'token': 'd7ec115d8370de00f06c50ec5b61bd519b1038ae'}

In [8]: res.json()['token']
Out[8]: 'd7ec115d8370de00f06c50ec5b61bd519b1038ae'

In [9]: token = res.json()['token']

In [10]: headers = {
    ...:     'Authorization': 'Token ' + token,
    ...:     }

In [11]: headers
Out[11]: {'Authorization': 'Token d7ec115d8370de00f06c50ec5b61bd519b1038ae'}

In [12]: res = requests.get('http://localhost:800/api/post/', headers=headers)

In [13]: res = requests.get('http://localhost:8000/api/post/', headers=headers)

In [14]: res
Out[14]: <Response [200]>

In [15]: res.text
Out[15]: '[{"id":1,"author_username":"tester","message":"Hello","photo":null},{"id":2,"author_username":"tester","message":"Hello","photo":null},{"id":3,"author_username":"tester","message":"Hello","photo":null},{"id":4,"author_username":"tester","message":"Hello","photo":null},{"id":5,"author_username":"tester","message":"Hello","photo":null},{"id":6,"author_username":"tester","message":"Hello","photo":null},{"id":7,"author_username":"tester","message":"Hello","photo":null},{"id":8,"author_username":"tester","message":"Hello","photo":null},{"id":9,"author_username":"tester","message":"Hello","photo":null},{"id":10,"author_username":"tester","message":"Hello","photo":null},{"id":11,"author_username":"tester","message":"Hello","photo":null},{"id":12,"author_username":"tester","message":"Hello","photo":"http://localhost:8000/api/post/a_7Y7nc8e.jpg"}]'

In [16]: res.json()
Out[16]:
[{'id': 1, 'author_username': 'tester', 'message': 'Hello', 'photo': None},
 {'id': 2, 'author_username': 'tester', 'message': 'Hello', 'photo': None},
 {'id': 3, 'author_username': 'tester', 'message': 'Hello', 'photo': None},
 {'id': 4, 'author_username': 'tester', 'message': 'Hello', 'photo': None},
 {'id': 5, 'author_username': 'tester', 'message': 'Hello', 'photo': None},
 {'id': 6, 'author_username': 'tester', 'message': 'Hello', 'photo': None},
 {'id': 7, 'author_username': 'tester', 'message': 'Hello', 'photo': None},
 {'id': 8, 'author_username': 'tester', 'message': 'Hello', 'photo': None},
 {'id': 9, 'author_username': 'tester', 'message': 'Hello', 'photo': None},
 {'id': 10, 'author_username': 'tester', 'message': 'Hello', 'photo': None},
 {'id': 11, 'author_username': 'tester', 'message': 'Hello', 'photo': None},
 {'id': 12,
  'author_username': 'tester',
  'message': 'Hello',
  'photo': 'http://localhost:8000/api/post/a_7Y7nc8e.jpg'}]

In [17]: for post in res.json():
    ...:     print(post['message'])
    ...:

In [17]: for post in res.json():
    ...:     print(post['message'])
    ...:
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello
Hello

In [19]: for post in res.json():
    ...:     print('{id}: {message}'.format(**post))
    ...:
    ...:
    ...:
1: Hello
2: Hello
3: Hello
4: Hello
5: Hello
6: Hello
7: Hello
8: Hello
9: Hello
10: Hello
11: Hello
12: Hello

```

# python pack unpack 반드시 알아보기 (???)