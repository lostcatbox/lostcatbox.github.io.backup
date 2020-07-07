---
title: DRF 기본편 12
date: 2020-01-24 14:41:53
categories: API
tags: [API, DRF]
---

# EP 12. PostAPIView **차근차근 응답시간 줄여보기**

## 관련 문서

원문 : Web API performance: profiling Django REST framework 장고 공식문서

- Performance and optimization
- Database access optimization

## **왜 최적화를 해야하나요**?

- 보다빠르게동작하는프로그램을위해!!!
  - 보다낮은CPU타임
  - 보다낮은메모리소모

- 개발비용이가장큰리소스입니다.=>개발시간+인건비

- 최적화를통해성능은높아지지만,유지관리성이낮아질수도있습니다.=>가성비를 체크해보세요.

- 한영역의개선이다른부분을희생시킬수있습니다.

  ex) CPU 연산을 아꼈는데, 메모리 소모가 늘었다.



## **시작하기에 앞서**

Throttle와 Pagination은 꺼주시고, 현재, DB Record갯수가 적기에 ... **뻥튀기**

```
from ep08.models import Post

post = Post.objects.first()

for i in range(100):
 post.id = None # Django Model은 id=None일 경우, CREATE를 수행합니다.

post.save()
```

__주의: 실제 서비스에서는 id=None과 같은 코드는 절대 쓰지 마세요.__

## **측정** Metric

다음 코드를 통해, 요청 처리시의 각 부분에 대한 시간을 측정해보겠습니다.

- Database Lookup (db_time) : 데이터베이스 Fetch 수행시간(DB에서 가져오는시간)
- Serialization (serializer_time) : Serializer 직렬화 수행시간
- API View (api_view_time) : APIView 수행시간(인증관련처리, 페이징처리등등)
- Response rendering (render_time) : Response 렌더링 수행시간
- Django request/response : request/response 수행시간

![스크린샷 2020-01-24 오후 2.45.00](https://tva1.sinaimg.cn/large/006tNbRwgy1gb7loazfo9j30yn0u0avm.jpg)

total시간은 요청이 요청되고 응답이 다생성되고 닫기까지의 시간

각자 시간이 계산되서 적힘.

## **수행시간 비교** (**단위**:**초**)

![스크린샷 2020-01-24 오후 2.45.34](https://tva1.sinaimg.cn/large/006tNbRwgy1gb7louarl1j31d80io0vr.jpg)

(미들웨어는 웹페이지를 위한 미들웨어들을 제거, 뷰를 부를때는 미들웨어가반드시 포함되므로 제거할수록 빨라짐)(HttpResponse를 상속받은 Response를 쓰지않고 원본인 HttpResponse 씀)

## 측정을 위한 코드 코드 [측정코드](https://gist.github.com/nomadekr/200cb7aba56de5949b40b7de53c46259)

- 코드1/3

```
import time
from rest_framework.response import Response

class PostViewSet(ModelViewSet): 
    queryset = Post.objects.all() 
    serializer_class = PostSerializer
    
        def dispatch(self, request, *args, **kwargs):
            global cbv
            cbv = self
            dispatch_start = time.time()
            response = super().dispatch(request, *args, **kwargs)
            
            render_start = time.time()
            response.render()
            self.render_time = time.time() - render_start
            
            self.dispatch_time = time.time() - dispatch_start
            self.api_view_time = self.dispatch_time - (self.render_time + self.serializer_time + self.db_time)
            
            return response
```

- 코드 2/3

```
        def list(self, request, *args, **kwargs): 
            db_start = time.time()
            post_list = list(self.queryset) #원래 queryset은 lazy 작동하지만 list등으로 변환을 줘서 즉시 DB Fetch를 이루워지게함 #실제 프로젝트에서는 lazy한게좋다
            self.db_time = time.time() - db_start

            serializer_start = time.time()
            serializer = self.get_serializer(self.queryset, many=True) 
            data = serializer.data
            self.serializer_time = time.time() - serializer_start

            return Response(data)
```

- 코드3/3

  주의 : 아래코드는 Single Request에서만 동작합니다. 동시 요청에서는 제대로

  동작하지 않습니다.

```
from django.core.signals import request_started, request_finished

def started_fn(sender, **kwargs): global started
    started = time.time()
    
def finished_fn(sender, **kwargs):
    request_response_time = (time.time() - started) - cbv.dispatch_time
    
    total = cbv.db_time + cbv.serializer_time + cbv.api_view_time + cbv.render_time + request_response_time
    
    print('Database Lookup    - db_time             : {:.6f}s, {:>4.1f}%'.format(cbv.db_time, 100*(cbv.db_time/total)))
    print('Serialization      - serializer_time     : {:.6f}s, {:>4.1f}%'.format(cbv.serializer_time, 100*(cbv.serializer_time/total)))
    print('API View           -api_view_time.       : {:.6f}s, {:>4.1f}%'.format(cbv.api_view_time, 100*(cbv.api_view_time/total)))
    print('Response rendering - render_time         : {:.6f}s,{:>4.1f}%'.format(cbv.render_time, 100*(cbv.render_time/total))) 
    print('Django request/response           : {:.6f}s,{:>4.1f}%'.format(request_response_time, 100*(request_response_time/total)))
   

   


    
    request_started.connect(started_fn)      # 요청 처리 시작
    request_finished.connect(finished_fn)    # 요청 처리 끝
    

```

## **기본 코드**, 수행


"GET /ep08/post/?format=json HTTP/1.1" 200 6497

![스크린샷 2020-01-24 오후 3.05.28](https://tva1.sinaimg.cn/large/006tNbRwgy1gb7m9igfb1j31fi0dimzz.jpg)

=> DB Lookup 및 DRF Serializer의 시간비율이 가장 높네요.

## Serializer**를 제거해봅시다**.

하지만 개발생산성이있으므로, Serializer를 쓰더라도 적절한 캐싱을 통해서 성능뽑기가능

QuerySet.values(**필드명**)**를 통해**, **원하는 필드만 가져오기**

```
def list(self, request, *args, **kwargs):
    db_start = time.time()
    # post_list = list(self.queryset)
    data = self.queryset.values('author__username', 'message') #DB에서그냥 바로 목록가져오게함
    self.db_time = time.time() - db_start
    
    # serializer_start = time.time()
    # serializer = self.get_serializer(self.queryset, many=True) 
    # data = serializer.data
    # self.serializer_time = time.time() - serializer_start 
    self.serializer_time = 0
    
    return Response(data))
```

### 수행결과

"GET /ep08/post/?format=json HTTP/1.1" 200 6598

![스크린샷 2020-01-24 오후 3.06.54](https://tva1.sinaimg.cn/large/006tNbRwgy1gb7mb0e80zj31b20bwtb3.jpg)

=> 해당 부분이 0.8초에서 0.00019초로 줄었네요.

__Tip: 하지만, Serializer으로 얻는 막대한 개발생산성이 있으며, Serializer를 쓰더라도 적절한 캐싱을 통해 극복할 수 있습니다.__

## DB/Serializer 대신에 캐싱

**데이터가 변경되지 않는다면**, **캐싱을 통해 성능을 높일 수 있습니다**.

cache는 django에서 기본설정으로 django.conf.global_settings.py에서 cache를 보면 locmemcache인 것을 알수있다.

```
from django.core.cache import cache  #cache 접근

# 중략

    def list(self, request, *args, **kwargs): 
        db_start = time.time()
        
        data = cache.get('post_list_data')   #값이 있다면 가져오고 아니면 None반환됨
        
        if data is None:  #None이라면 
            data = self.queryset.values('author__username', 'message')  #data를 DB에서 가져오고
            cache.set('post_list_data', data, 60) #그 값을 cache에다가 넣음

        self.db_time = time.time() - db_start

        self.serializer_time = 0

        return Response(data)
```

### 수행결과

![스크린샷 2020-01-24 오후 3.08.59](https://tva1.sinaimg.cn/large/006tNbRwgy1gb7md6kfqtj318a0iydjx.jpg)

Tip: 코드 최적화가 먼저입니다. 캐시는 적당히. 무분별한 캐시는 마약과도 같습니다.

## APIView에 필요한 설정만 넣기

```
from rest_framework.negotiation import BaseContentNegotiation
from rest_framework.renderers import JSONRenderer

class IgnoreClientContentNegotiation(BaseContentNegotiation): 
    def select_parser(self, request, parsers):
   		 	"Select the first parser in the `.parser_classes` list."
        return parsers[0]

    def select_renderer(self, request, renderers, format_suffix): 
        "Select the first renderer in the `.renderer_classes` list." 
        return (renderers[0], renderers[0].media_type)
        
class PostViewSet(ModelViewSet): #디폴트값들 없앰, 최소한으로
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    permission_classes = []
    authentication_classes = []
    renderer_classes = [JSONRenderer] 
    content_negotiation_class = IgnoreClientContentNegotiation
```

### 수행결과

![스크린샷 2020-01-24 오후 3.11.09](https://tva1.sinaimg.cn/large/006tNbRwgy1gb7mfg96hdj31bi0l4n1o.jpg)

## 미들웨어 제거하기
__본 프로젝트가 API 기능만 할 경우, 장고 웹페이지를 위한 기능을 꺼볼 수 있겠습니다.__



```
# 프로젝트/settings.py
INSTALLED_APPS = [
		# 'debug_toolbar',
]

MIDDLEWARE = [
    # 'debug_toolbar.middleware.DebugToolbarMiddleware',
    # 'django.middleware.security.SecurityMiddleware',
    # 'django.contrib.sessions.middleware.SessionMiddleware',
    # 'django.middleware.common.CommonMiddleware',
    # 'django.middleware.csrf.CsrfViewMiddleware',
    # 'django.contrib.auth.middleware.AuthenticationMiddleware', 
    # 'django.contrib.messages.middleware.MessageMiddleware',
    # 'django.middleware.clickjacking.XFrameOptionsMiddleware',
]
```

### **수행결과**

![스크린샷 2020-01-24 오후 3.12.16](https://tva1.sinaimg.cn/large/006tNbRwgy1gb7mgon1qvj31ae0l8jvt.jpg)

## Django **기본** HttpResponse **쓰기**

```
import json
from django.http import HttpResponse

def list(self, request, *args, **kwargs): 
    db_start = time.time()
    data = cache.get('post_list_data')
    if data is None:
    		data = list(self.queryset.values('author__username', 'message'))   # QuerySet은 JSON 직렬화 불가, 따라서 list로 바꿔줌>>이제 json직렬화가능해짐
    		cache.set('post_list_data', data, 60)
    		

    self.db_time = time.time() - db_start
    
    self.serializer_time = 0
    
    #json으로 직렬화해주는것이 가능한 data타입을 줘야함
    return HttpResponse(json.dumps(data), content_type='application/json; charset=utf-8') 
```

### 수행 결과

![스크린샷 2020-01-24 오후 3.15.39](https://tva1.sinaimg.cn/large/006tNbRwgy1gb7mk55zofj31ba0m0aeg.jpg)

## 정리

- 필요에따라Serializer/Response를쓰지않고직접처리 
  - 생산성을통한성능의희생
- 조회요청의경우,적절한캐싱은 성능을높여줍니다.
  - __주의) 로직으로캐싱된내용을적절히만료시켜야만합니다.__ (예를 들면 만약 지워지거나하면 다시캐싱해줘야함)
- 어떤설정이적용되는지정확히알고,필요한설정만적용하기.
  - APIView 설정 최소화
  - 미들웨어제거

- __제일 중요한것은 DB query를 필요한 만큼 요청하고 생성하는지만 체크하는 것(성능폭풍상승)__