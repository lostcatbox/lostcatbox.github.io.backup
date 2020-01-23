---
title: api 기본편 10
date: 2020-01-23 15:52:04
categories: API
tags: [API, DRF]
---

# EP 10 - Throttling

공식문서 : http://www.django-rest-framework.org/api-guide/throttling/

## 용어정리

- Rate : 지정 기간 내의 최대 호출 횟수 (10/m 1분에 최대 10번)
- Scope : 각 Rate에 대한 별칭 (alias)
- Throttle : 특정 조건 하에 최대 호출 횟수를 결정하는 클래스

### 기본 제공 Throttle

- AnonRateThrottle
  - 인증요청에는 제한을 두지 않고, 비인증 요청에는 IP 별로 횟수 제한
  - Throttle 클래스별로 scope을 1개만 지정할 수 있습니다.
  - 디폴트 scope: 'anon'
- UserRateThrottle
  - 인증요청에는 유저 별로 횟수를 제한하고, 비인증 요청에는 IP 별로 횟수 제한
  - Throttle 클래스별로 scope을 1개만 지정할 수 있습니다.
  - 디폴트 scope: 'user'
- ScopedRateThrottle
  - 인증요청에는 유저 별로 횟수를 제한하고, 비인증 요청에는 IP 별로 횟수 제한
  - 여러 APIView내 throttle_scope값을 읽어들여, APIView별로 다른 Scope을 적용해줍니다.

디폴트 settings

```python
REST_FRAMEWORK = {
    'DEFAULT_THROTTLE_CLASSES': [],
    'DEFAULT_THROTTLE_RATES': {
        'anon': None,
        'user': None,
    },
}
```

## APIView에 커스텀 Throttle

```python
# 프로젝트/settings.py
REST_FRAMEWORK = {
    'DEFAULT_THROTTLE_CLASSES': [
        'rest_framework.throttling.UserRateThrottle',
    ],
    'DEFAULT_THROTTLE_RATES': {
        'user': '10/day',
    },
}
```

이제, 모든 APIView에 걸쳐, `최대호출 횟수`제한이 걸립니다.

### 혹은 APIView 별로 지정도 할 수 있습니다.

```python
from rest_framework.throttling import UserRateThrottle

class PostViewSet(ViewSet):
    throttle_classes = UserRateThrottle
```

### API 요청 시에 제한을 넘어선다면?

429 Too Many Requests 응답을 받습니다.

```
쉘> http :8000

HTTP/1.0 429 Too Many Requests

{
    "detail": "Request wat throttled. Expected available in 86326 seconds."
}
```

예외 메세지에 API 활용이 가능한 시점을 알려줍니다. 이는 Throttle의 `wait`멤버함수를 통해 계산합니다.

## Rates 포맷

- "숫자/간격"
- 숫자 : 지정 간격내의 최대 요청 제한 횟수
- 간격 : 지정 문자열의 첫 글자만 봅니다. 즉 "d", "day", "ddd" 모두 Day를 뜻합니다.
  - "s": 초
  - "m": 분
  - "h": 시
  - "d": 일

## Rates 제한 메커니즘

1. SingleRateThrottle에서는 요청한 시간의 scope별로 timestamp를  list로 유지
2. 매 요청 시마다
   1. cache 에서 현재 scope에  timestamp list를 가져옵니다.
   2. 체크범위 밖의 timestamp값은 모두 버립니다.
   3. timestamp list의 크기가 허용범위보다 클 경우, 요청을 거부합니다.
   4. timestamp list의 크기가 허용범위보다 작을 경우, 현재 timestamp를 timestamp list에 추가하고, cache에 다시 저장합니다.

## 클라이언트 IP

`X-Forwarded-For` 헤더값과 `REMOTE_ADDR` WSGI 변수값을 참조해서, 클라이언트 IP를 확정합니다.

`X-Forwarded-For` 헤더값이 `REMOTE_ADDR` 값에 우선합니다.

```python
# 주요 코드
xff = request.META.get('HTTP_X_FORWARDED_FOR')
remote_addr = request.META.get('REMOTE_ADDR')
# (중략)
if xff:
    client_ip = ''.join(xff.split()) 
else:
    client_ip = remote_addr
```

## API 별로 서로 다른 Rate 적용하기

API 별로 서로 다른 Rate를 적용하기 할려면 어떻게 해야할까요? 매 API마다 새로운 Throttle 클래스를 만들어서 지정해야할까요? 일단 다음과 같이 해볼 수 있겠습니다.

```python
# 프로젝트/settings.py
REST_FRAMEWORK = {
    'DEFAULT_THROTTLE_CLASSES': [],
    'DEFAULT_THROTTLE_RATES': {
        'contact': '1000/day',
        'upload': '20/day',
    },
}

# myapp/throttles.py
class CotactRateThrottle(UserRateThrottle):
    scope = 'contact'

class UploadRateThrottle(UserRateThrottle):
    scope = 'upload'

# myapp/views.py
class ContactListView(APIView):
    throttle_classes = [CotactRateThrottle]

class ContactDetailView(APIView):
    throttle_classes = [ContactRateThrottle]

class UploadView(APIView):
    throttle_classes = [UploadRateThrottle]
```

위 코드도 잘 동작하긴 합니다만, __ScopedRateThrottle를 통해 코드를 줄이실 수 있습니다. __ScopedRateThrottle는 APIView의 `throttle_scope`값을 읽어들여 적용해줍니다. 커스텀 Throttle를 만드실 필요가 없습니다. 아래 코드는 위 코드의 대체 코드입니다.

```python
# 프로젝트/settings.py
REST_FRAMEWORK = {
    'DEFAULT_THROTTLE_CLASSES': [
        'rest_framework.throttling.ScopedRateThrottle',
    ],
    'DEFAULT_THROTTLE_RATES': {
        'contact': '1000/day',
        'upload': '20/day',
    },
}

# myapp/views.py
class ContactListView(APIView):
    throttle_scope = 'contact'

class ContactDetailView(APIView):
    throttle_scope = 'contact'

class UploadView(APIView):
    throttle_scope = 'upload'
```

어떤가요? 훨씬 코드보기가 좋아졌죠?

## 유저별로 Rate 다르게 적용하기

프로젝트/settings.py

```python
REST_FRAMEWORK = {
    'DEFAULT_THROTTLE_RATES': {
        'premium_user': '1000/day',  # premium 유저는 하루에 1000회 요청 제한
        'light_user': '10/day',      # light 유저는 하루에 10회 요청 제한
    },
}
```

myapp/throttling.py

```python
from rest_framework.throttling import UserRateThrottle

class PremiumThrottle(UserRateThrottle):
    # 본 Throttle에서는 생성자에서 get_rate가져오는 것은 불필요하므로
    # 생서자 오버로딩을 통해 루틴 제거
    def __init__(self):
        pass

    def allow_request(self, request, view):
        premium_scope = getattr(view, 'premium_scope', None)
        light_scope = getattr(view, 'light_scope', None)

        if request.user.profile.is_premium_user:  # Profile모델에 is_premium_user 필드가 있을 경우
            if not premium_scope:  # premium_scope 미지정 시에는 Throttling제한을 하지 않습니다.
                return True
            self.scope = premium_scope
        else:
            if not light_scope:  # light_scope 미지정 시에는 Throttling제한을 하지 않습니다.
                return True
            self.scope = light_scope

        self.rate = self.get_rate()
        self.num_requests, self.duration = self.parse_rate(self.rate)

        return super().allow_request(request, view)
```

myapp/views.py

```python
from rest_framework import viewsets
from .serializers import PostSerializer
from .throttling import PremiumThrottle
from .models import Post

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    throttle_classes = [PremiumThrottle]
    premium_scope = 'premium_user'
    light_scope = 'light_user'

    def perform_create(self, serializer):
        print(self.request.FILES)
        serializer.save(author=self.request.user)
```

## Cache (휘발성있는 데이터저장시켜줌)

매 요청시마다 cache에서 `timestamp list`값을 get/set하므로, cache의 성능이 중요합니다.

SimpleRateThrottle에는 다음 코드와 같이 장고 디폴트 cache를 쓰도록 설정되어있습니다.

```python
# rest_framework/throttling.py

from django.core.cache import cache as default_cache

class SimpleRateThrottle(BaseThrottle):
    cache = default_cache
```

장고 프로젝트 디폴트 설정으로 `CACHES`는 "로컬 메모리 캐쉬"가 설정되어있습니다. 이는 서버가 재시작되면 캐쉬가 모두 초기화됩니다. 이 외에도 장고에서는 수많은 Cache를 지원합니다.

- Memcached 서버 지원 (보통사용)
  - django.core.cache.backends.memcached.MemcachedCache
  - django.core.cache.backends.memcached.PyLibMCCache
- 데이터베이스 캐시
  - django.core.cache.backends.db.DataabseCache
- 파일 시스템 캐시
  - django.core.cache.backends.filebased.FileBasedCache
- 로컬 메모리 캐시
  - django.core.cache.backends.locmem.LocMemCache
- 더미 캐시 : 캐시 인터페이스를 제공해주지만, 캐시를 수행하지 않습니다.
  - django.core.cache.backends.dummy.DummyCache

장고 Cache([공식문서](https://docs.djangoproject.com/en/1.11/topics/cache/))에 대해서는 별도 문서/VOD를 통해 살펴보도록 하겠습니다.