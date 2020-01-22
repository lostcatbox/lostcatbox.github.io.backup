---
title: api08
date: 2020-01-21 22:04:50
categories: API
tags: [API, DRF]
---

## EP 08 - Serializer를 통한 유효성 검사 및 저장

### Serializer의 생성자

Serializer는 Django Form과 컨셉/사용법이 유사합니다. 하지만 생성자를 지정할 때, 인자 구성이 조금 상이한데요.

__Django Form의 생성자 Signature는 다음과 같습니다. 첫번째 인자로 data를 받습니다.__

```python
# django/forms/forms.py

class BaseForm:
    def __init__(self, data=None, files=None, auto_id='id_%s', prefix=None,
                 initial=None, error_class=ErrorList, label_suffix=None,
                 empty_permitted=False, field_order=None, use_required_attribute=None, renderer=None):

class Form(BaseForm):
    pass
```

ModelForm에서는 `instance`인자가 추가로 지정되어 있구요.(instance인자를 주면 지정 instance 저장을 수행가능하게내부적으로 설정됨)

```python
# django/forms/models.py

class BaseModelForm(BaseForm):
    def __init__(self, data=None, files=None, auto_id='id_%s', prefix=None,
                 initial=None, error_class=ErrorList, label_suffix=None,
                 empty_permitted=False, instance=None, use_required_attribute=None):
```

그래서, 뷰 내에서 Form생성자를 호출할 때에는 다음과 같은 코드가 가능합니다.

```python
form = MyForm(request.POST)  # 생성자의 첫번째 인자가 data 입니다.
form = MyForm(request.POST, request.FILES)
form = MyForm({'title': 'my title'})

form = MyModelForm(request.POST, instance=my_instance)
```

많이 익숙하신 코드죠? :)

----

__그런데, Serializer의 생성자 Signature는 다음과 같습니다. 첫번째 인자로 `instance`를 받으며, 두번째 인자로 `data`를 받습니다.__

```python
# rest_framework/serializers.py

class BaseSerializer(Field):
    def __init__(self, instance=None, data=empty, **kwargs):

class Serializer(BaseSerializer):
    pass
```

__Django Form의 Signature가 조금 다릅니다. `data`인자만 지정하실 때에는 `MySerializer(data=mydata)`처럼 필히 keyword를 지정해주셔야 합니다.__

```python
serializer = MySerializer(my_instance)
serializer = MySerializer(my_instance, request.POST)
serializer = MySerializer(data=request.POST)
```

참고) 파이썬의 함수 인자에 대해서는 "[파이썬 차근차근 시작하기 - 함수편](https://nomade.kr/vod/python/91/)" 에서 자세히 다루고 있습니다.

`data=` 인자가 주어지면, 다음 순서로 처리됩니다.

1. `.is_valid()`가 호출이 되면
2. `.initial_data` 필드에 접근할 수 있고,
3. `.validated_data` (사전형태)를 통해 유효성 검증에 통과한 값들에 대한 사전. `.save()`시에 사용됩니다.(cleaned_data같은느낌)
4. `.errors` : 유효성 검사에 대한 오류 내역
5. `.data` : 유효성 검사 후에, 갱신된 인스턴스에 대한 필드값 사전(restframework에서 특정 인스턴스의 필드내역을 응답할떄 사용)

`serializer.save(**kwargs)` 호출이 이뤄질 때 (form.save느낌)

- DB에 저장된 관련 모델 인스턴스를 리턴
- `.validated_data`와 `kwargs`사전을 합쳐서, `.update` 함수/`.create`함수를 통해 관련 필드에 값을 할당하고, DB로의 저장을 시도합니다.
  - `.update()` : `self.instance` 인자가 지정되었을 때
  - `.create()` : `self.instance` 인지가 지정되지 않았을 때

```python
Signature 알아보자

from rest_framework.fields import Field

class BaseSerializer(Field):
    def __init__(self, instance=None, data=empty, **kwargs):
        pass

    def create(self, validates_data):
        raise NotImplementedError
        # return instance

    def update(self, instance, validatd_data):
        raise NotImplementedError
        # return instance

    def save(self, **kwargs):
        # 생성자에서 self.instance 지정 여부에 따라 update 혹은 create를 호출
        return self.instance


class Serializer(BaseSerializer):
    # create/update 구현이 필요
    pass


class ListSerializer(BaseSerializer):
    def create(self, validated_data):
        return [
            self.child.create(attrs) for attrs in validated_data
        ]

    def update(self, instance, validated_data):
        # 여러 레코드에 대한 추가/삭제 처리가 필요한데, 디폴트로는 미지원
        # 필요하다면, 직접 구현하면 됩니다.
        raise NotImplementedError()


class ModelSerializer(Serializer):
    def create(self, validated_data):
        # 중략
        instance = ModelClass.objects.create(**validated_data)
        return instance

    def update(self, instance, validated_data):
        # 중략
        info = model_meta.get_field_info(instance)

        for attr, value in validated_data.items():
            if attr in info.relations and info.relations[attr].to_many:
                field = getattr(instance, attr)
                field.set(value)
            else:
                setattr(instance, attr, value)
        instance.save()

        return instance


class HyperlinkedModelSerializer(ModelSerializer):
    # id필드 대신에 url필드를 사용
    pass
```

## Validators

[장고 기본 validators](https://github.com/django/django/blob/master/django/core/validators.py)과 더불어, django-rest-framework에서는 유일성 여부 체크를 도와주는 Validator를 제공해주며, queryset 범위를 제한하여 지정 범위 내에서의 유일성 여부를 체크할 수 있습니다.

1. __UniqueValidator : 지정 필드가 지정 QuerySet범위에서 Unique한지 체크__
   - 모델 필드 unique=True 설정에 대응하여, 자동 추가
2. __UniqueTogetherValidator__
   - 모델 클래스.Meta.unique_together 속성에 대응하여, 자동 추가
3. UniqueForDateValidator
   - 모델 필드 unique_for_date=True 설정에 대응하여, 자동 추가
4. UniqueForMonthValidator
   - 모델 필드 unique_for_month=True 설정에 대응하여, 자동 추가
5. UniqueForYearValidator
   - 모델 필드 unique_for_year=True 설정에 대응하여, 자동 추가

## 유효성 검사 예외

`rest_framework.exceptions.ValidationError`를 기본으로 사용합니다. 이는 응답 상태코드 `400`으로 처리합니다.

장고 기본에서 제공하는 `django.core.exceptions.ValidationError`를 사용할 수도 있습니다. 이를 사용하면, `rest_framework`측 예외로 변환되어 처리됩니다.

## Serializer에서 유효성검사 함수 지정하기

__Tip: ModelSerializer를 사용하신다면, 유효성 검사 함수는 모델 측에 지정하시는 것이 관리측면에서 좋습니다.__

(그렇게 하면 django.admin에서도, api에서도, model자체에서도 유효성검사되므로)

- 필드 정의 시에 `validators`인자 지정하기
- Field-level 검사 : 특정 필드에 대한 검사
  - __Form에서는 `clean_필드명`의 함수를 구현하지만, `rest_framework`에서는 `validate_필드명`를 구현해줍니다.__
  - 함수 인자로 해당 값이 전달됩니다.(value)
  - DjangoForm과 마찬가지로, 본 함수의 리턴값을 통해 값을 변환할 수도 있습니다.

```python
class PostSerializer(serializers.Serializer):
    title = serializers.CharField(max_length=100)

    def validate_title(self, value):
        if 'django' not in value:
            raise ValidationError('제목에 필히 django가 포함되어야합니다.')
        return value
```

- Object-level 검사 : 다수 필드에 대한 검사

  (예시로 게임에서 아이디 중복을 검사할때 어떤 서버에서 어떤이름 중복를 찾아야하므로 서버와 이름을 동시에 유효성검사)

```python
class PostSerializer(serializers.Serializer):
    title = serializers.CharField(max_length=100)

    def validate(self, data):
        if 'django' not in data['title']:
            raise ValidationError('제목에 필히 django가 포함되어야합니다.')
        return data
```

## DB로의 반영과 Mixins의 `perform_` 계열 함수

__(예시:ModelViewSet도 까보면 아래에 mixin들 이용함)__

API수행결과를 DB에 반영하는 create/update/destroy를 커스텀하고 싶으시다면, `perform_` 계열 함수에 주목하세요.

- 저장할 때
  - 아이피 저장하기
  - 유저 정보 기록하기

```python
# rest_framework/mixins.py

class CreateModelMixin(object):
    def create(self, request, *args, **kwargs):             # CREATE 요청이 들어오면,
        serializer = self.get_serializer(data=request.data) # Serializer 인스턴스를 만들고
        serializer.is_valid(raise_exception=True)           # 유효성 검사를 수행합니다. 실패하면바로예외발생 !!!
        self.perform_create(serializer)                      # DB로의 저장을 수행합니다.(유효성검사통과한상태)
        headers = self.get_success_headers(serializer.data)  # 필요한 헤더를 뽑고
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)  # 응답을 합니다.

    def perform_create(self, serializer):                    # CREATE 커스텀은 이 함수를 재정의하세요.
        serializer.save()

    # 생략


class UpdateModelMixin(object):
    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)               # 부분 업데이트 여부(patch요청일때임)
        instance = self.get_object()                         # 수정할 모델 객체를 획득하고
        serializer = self.get_serializer(instance, data=request.data, partial=partial)  # Serializer 인스턴스를 만들고
        serializer.is_valid(raise_exception=True)            # 유효성 검사를 수행합니다. 실패하면 예외발생 !!!
        self.perform_update(serializer)                      # DB로의 저장을 수행합니다.

        if getattr(instance, '_prefetched_objects_cache', None):
            # If 'prefetch_related' has been applied to a queryset, we need to
            # forcibly invalidate the prefetch cache on the instance.
            instance._prefetched_objects_cache = {}

        return Response(serializer.data)

    def perform_update(self, serializer):                    # UPDATE 커스텀은 이 함수를 재정의하세요.
        serializer.save()


class DestroyModelMixin(object):
    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response(status=status.HTTP_204_NO_CONTENT)

    def perform_destroy(self, instance):                     # DELETE 커스텀은 이 함수를 재정의하세요.
        instance.delete()
```

### `create`시에 추가로 필드 설정하기

`CREATE`기능을 수행하는 APIView에서는 `rest_framework.mixins.CreateModelMixin`을 상속받습니다. `CREATE`시에 추가로 필드를 설정할려면, `perform_create`를 통해 수행되는 `serializer.save()`함수에 키워드 인자를 지정해주세요.

```python
@views.py

from django.shortcuts import render
from .serializers import PostSerializer
from rest_framework.viewsets import ModelViewSet
from .models import Post

class PostViewSet(ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    def perform_create(self, serializer):
        serializer.save(ip=self.request.META['REMOTE_ADDR'])

# Create your views here.

```

현재 오류가 나오는 이유 serializers.py 에서는 fields에서 특정 필드만 지정했으모로 유효성 검사를 잘 통과해도

마지막에 serializer.save()가 들어갈때 다른 필수 field가 지정되어있지 않다면 not null constraint failed가 뜰수밖에없다.