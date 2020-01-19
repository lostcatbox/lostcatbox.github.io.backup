---
title: api 기본편 4
date: 2020-01-17 18:48:51
categories: API
tags: [API, DRF]
---

# EP 04 - ViewSet과 Router

## ViewSet

ViewSet은 **일반적인 장고 CBV**는 아닙니다. 2개의 뷰를 만들어주는 **보다 확장된 형태의 CBV**입니다. "View + Set" 즉, **다수 View를 지원하는 CBV**.

모든 뷰셋은 `.as_view({'http_method': '처리할멤버함수'})`를 호출하여, 해당 `http_method`를 지원하는 뷰 함수를 생성합니다. **1개의 뷰 함수**를 생성하므로, **하나의 URL**만을 처리할 수 있습니다.

`rest_framework/viewsets.py`에서는 다음 2가지 뷰셋을 지원하고 있습니다.

```
viewsets.ReadOnlyModelViewSet
```

: 목록 조회, 특정 레코드 조회를 지원 => 2개의 URL 지원

- 특정 Record 조회 : `mixins.RetrieveModelMixin`을 통해 `retrieve()`함수 지원
- 리스트 조회 : `mixins.ListModelMixin`을 통해 `list()`함수 지원

```
viewsets.ModelViewSet
```

: 목록 조회, 생성, 특정 레코드 조회/수정/삭제 지원 => 2개의 URL 지원

- 리스트 조회 : `mixins.ListModelMixin`을 통해 `list()`함수 지원
- 특정 Record 조회 : `mixins.RetrieveModelMixin`을 통해 `retrieve()`함수 지원
- 새 Record 생성 : `mixins.CreateModelMixin`을 통해 `create()`함수 지원
- 특정 Record 수정 : `mixins.UpdateModelMixin`을 통해 `update()`함수 및 `partial_update()`함수 지원
- 특정 Record 삭제 : `mixins.DestroyModelMixin`을 통해 `destroy()`함수 지원

다음 코드에서 보듯이, `PostViewSet`에서 `list/create/retrieve/update/partial_update/destory` 함수를 모두 지원한다고 하여, 이 함수들을 하나의 URL에서 처리할 수 없습니다. 일반적인 `REST API`설계에서 벗어나기 때문입니다. >>결국 url 2개 지원해야함

### REST API 규격에 맞춰, URL 매핑을 해봅시다.

__list route__(Pk값 필요없음)

```
# list/create를 쌍으로 주로 씁니다. (URL 예 - "/posts/", "/article/")
post_list = PostViewSet.as_view({
    # GET요청이 들어오면 get함수가 호출이 될 것이며, 이어 list함수를 통해 처리하려 합니다.
    'get': 'list',

    # POST요청이 들어오면 post함수가 호출이 될 것이며, 이어 create함수를 통해 처리하려 합니다.
    'post': 'create',
})
```

__detail route__(Pk값 필요함)

```
# retrieve/update/partial\_update/destory를 쌍으로 주로 씁니다. (URL 예 - "/posts/10/", "/article/hello-world/")
post_detail = PostViewSet.as_view({
    # GET요청이 들어오면 get함수가 호출이 될 것이며, 이어 retrieve 통해 처리하려 합니다.
    'get': 'retrieve',
    # PUT요청이 들어오면 put 호출이 될 것이며, 이어 update함수를 통해 처리하려 합니다.
    'put': 'update',
    # PATCH요청이 들어오면 patch함수가 호출이 될 것이며, 이어 partial_update함수를 통해 처리하려 합니다.
    'patch': 'partial_update',
    # DELETE요청이 들어오면 delete함수가 호출이 될 것이며, 이어 destroy함수를 통해 처리하려 합니다.
    'delete': 'destroy',
})
```

이렇게 만들어진 뷰 함수는 다른 FBV(함수 기반 뷰)와 동일하게 URLConf에 매핑할 수 있습니다.

```python
urlpatterns = [
    url(r'^post/', post_list),
    url(r'^post/(?P<pk>\d+)/$', post_detail),
]
```

읽기 전용 뷰가 필요할 경우, 다음과 같이 매핑하실 수 있습니다.

```python
post_list = PostViewSet.as_view({
    'get': 'list',
})

post_detail = PostViewSet.as_view({
    'get': 'retrieve',
})
```

## Router 활용

Router를 활용하면, 관례(Convention)에 기반하여 URL매핑을 손쉽게 할 수 있습니다. 아래 코드에서 보듯이 `PostViewSet`을 `Router`에 등록하면, **해당 뷰셋이 지원하는 메소드/함수들에 한해서 URL매핑을 수행**합니다. 뷰는 등록할 수 없습니다. __뷰셋만 등록가능합니다.__

하나의 Router에 다수 뷰셋을 등록하실 수 있습니다.

디폴트 매핑은 위에서 수행한 내역대로 리스트/디테일 라우팅을 수행합니다.

- list route에서는 /prefix/주소가 지정되며, URL Reverse 이름으로서 ```모델명소문자-list```

  가 사용됩니다.

  - get => list
  - post => create

- detail route에서는 /prefix/pk/ 주소가 지정되며, URL Reverse 이름으로서 ```모델명소문자-detail``` 이 사용됩니다.

  - get => retrieve
  - put => update
  - patch => partial_update
  - delete => destroy

```python
# myapp/urls.py
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'prefix', PostViewSet)  #prefix가 'prefix'로 지정됨

# 이제, router.urls를 urlpatterns에 등록(include)시키면 OK
urlpatterns = [
    url(r'', include(router.urls)),  # 셋업된 라우팅 URLConf는 router.urls를 통해 제공받습니다.
]
```

### 예1)

다음과 같이 register될 경우

```python
router.register(r'post', PostViewSet)  #prefix가 post로 지정됨
```

- `/post/` 주소에 대해 URL Reverse 이름은 `post-list`이 등록됩니다.(name=post-list임)
- `/post/10/` 류의 주소에 대해 URL Reverse 이름은 `post-detail`이 등록됩니다.

```
python3 manage.py shell  #장고 쉘 부름
>>> from django.urls import reverse
>>> reverse('ep04:post-list')      # 데이터이름소문자
'/ep04/post/'    # post는 prefix이름따라감.
>>> reverse('ep04:post-detail', args=[100])    #pk 값을 줌, 데이터이름소문자
'/ep04/post/100/'   # post는 prefix이름따라감.
```

Tip: 아래는 rest-framework에 routers.py 내용중 하나이다, 보면queryset에서 model가져와서  _meta데이터에서 이름가져와서 소문자로 받는것을 알수있다. basename은 결국 위에 reverse name인 post-list, post-detail에서 post가 데이터이름에 따라 바뀔수있다는것임

```
def get_default_basename(self, viewset):
        """
        If `basename` is not specified, attempt to automatically determine
        it from the viewset.
        """
        queryset = getattr(viewset, 'queryset', None)

        assert queryset is not None, '`basename` argument not specified, and could ' \
            'not automatically determine the name from the viewset, as ' \
            'it does not have a `.queryset` attribute.'

        return queryset.model._meta.object_name.lower()
```



### 예2)

다음과 같이 register될 경우

```python
router.register(r'hello', PostViewSet)  #prefix이름 hello
```

- `/hello/` 주소에 대해 URL Reverse 이름은 `post-list`가 등록됩니다.
- `/hello/10/` 류의 주소에 대해 URL Reverse 이름은 `post-detail`이 등록됩니다.

### router를 쓸 경우는 `api-root`뷰를 통한 지원 ViewSet 목록 조회

Router에서는 추가로 현 Router에 등록된 ViewSet내역을 조회할 수 있는 `api-root` 뷰를 추가로 지원합니다. `router.urls`가 매핑된 주소로 브라우저 접속 혹은 GET요청을 날려보세요. ;)

```
현재 예시에서는
http://127.0.0.1:8000/ep04/
```

# ViewSet에 추가 API는 어떻게 추가할 .. 수 있죠 ??

물론입니다. list route로서 `list/create`함수와 detail route로서 `retrieve/update/partial_update/delete`외에 추가로 구현하여 매핑하실 수 있습니다. 이때 추가할 API가 list route에 등록할 것인지, detail route에 등록할 것인지를 결정해야합니다.(pk값필요유무차이)

구현은 해당 ViewSet 클래스 내에 멤버함수로서 구현하고 `list_route` 장식자 혹은 `detail_route` 장식자로 꾸며주면 끄읕 !!! URL매핑은 Router에서 알아서 해줍니다.

Django-rest-framework 3.8버전이상부터는 action으로 통합됨

```
Replace detail_route uses with @action(detail=True).
Replace list_route uses with @action(detail=False).
```

`PostViewSet`에 다음 2개 API를 추가해봅시다. 아래 예시는 Post모델에 `is_public=models.BooleanField()`가 있음을 가정한 코드입니다.

```python
#views.py

from rest_framework.decorators import list_route, detail_route
from rest_framework.response import Response


class PostViewSet(ModelViewSet):
    queryset = PostViewSet.objects.all()
    serializer_class = PostSerializer
    
    # /ep04/post/ => list() 함수
    # /ep04/post/public_list/ => public_list() 함수  # 즉 함수명으로 url뒤에붙음
    @action(detail=False)  # 목록 단위로 적용할 API이기에, list_route 장식자 사용
    def public_list(self, request):
        qs = self.queryset.filter(is_public=True)  # Post모델에 is_public 필드가 있을 경우
        #serializer = self.serializer(qs, many=True) 써도되지만 viewset에 구현되어있는 함수 get_serializer를 이용했음
        serializer = self.get_serializer(qs, many=True)
        return Response(serializer.data)
      
    # /ep04/post/10/ => retrieve() 함수가 호출
    # /ep04/post/10/set_public/ => set_public()함수가 호출
    @action(methods=['patch'], detail=True)  # Record 단위로 적용할 API이기에, detail_route 장식자 사용
    def set_public(self, request, pk):
        #viewset에는 이미 get_object_or_404(Post, pk=pk)가 이미구현된 get_object()함수가 존재
        instance = self.get_object()
        instance.is_public = True
        instance.save()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)
```

## `PostViewSet`의 `public_list` API

- URL 매핑은 `/prefix/함수명/`으로서 `/post/public_list/`가 됩니다.
- methods가 지정되지 않았으므로 GET요청에 응답합니다. 이는 `list_route/detail_route`의 디폴트 처리입니다.
- 함수명이 `public_list`이므로, URL Reverse 이름은 `모델명-함수명`으로서 `post-public-list`가 됩니다. 언더바(`_`)는 하이픈(`-`)으로 변경하여 처리됩니다.

요청 예시

```
쉘> http http://localhost:8000/ep04/post/public_list/
```

## PostViewSet의 set_public API

- URL 매핑은 `/prefix/{pk}/함수명/`으로서 `/post/{pk}/set_public/`이 됩니다.
- methods이 patch로 지정되었으므로, patch 요청에 응답합니다.
- 함수명이 `set_public`이므로, URL Reverse 이름은 `모델명-함수명`으로서 `post-set-public`이 됩니다. 언더바(`_`)는 하이픈(`-`)으로 변경하여 처리됩니다.

요청 예시

```
쉘> http PATCH http://localhost:8000/ep04/post/{pk}/set_public/
```

본 API는 `detail_route`예로서 작성한 것일 뿐, 다음과 같이 `PATCH`요청을 통한 `partial_update`을 이용해도 충분합니다.

```
쉘> http --form PATCH http://localhost:8000/ep04/post/{pk}/ title="수정된 제목" is_public=true
```

Tip: `PUT`을 통한 수정에서는 모든 필수(required) 필드를 지정하여야 하며, `PATCH`를 통한 수정에서는 "부분수정"으로서 수정할 필드만 지정하면 됩니다.

## 관련 공식문서

- http://www.django-rest-framework.org/tutorial/6-viewsets-and-routers/
- http://www.django-rest-framework.org/api-guide/routers/