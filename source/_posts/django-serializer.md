---
title: django-serializer
date: 2021-01-19 14:36:00
categories: [DRF]
tags: [Django, DRF, Serializer]
---

# 왜?

장고의 serializer는 잘만 활용하면, 효율적으로 valid 검사부터, 쿼리셋에서 불러오는것까지 간단히 구현가능하다. 자세히 알수록 활용하기 쉬워질것같다.

장고의 form과 비슷한점이 매우많다고 생각한다.

[공식문서](https://www.django-rest-framework.org/api-guide/serializers/#serializers)

[참고블로그](https://seulcode.tistory.com/199?category=722928)

# Serializer

> 직렬화를 하는 직렬변환기?
>
> __Serialize(직렬화)__
>
> __쿼리셋,모델 인스턴스  등의 complex type(복잡한 데이터)를__ JSON, XML등의 컨텐트 타입으로 쉽게 변환 가능한 __python datatype으로 변환시켜줌__
>
> > Serializer는 우리가 Django 에서 사용하는 파이썬 객체나 queryset 같은 복잡한 객체들을 REST API에서 사용할 json 과 같은 형태로 변환해주는 어댑터 역할을 한다.
>
> __Deserialize__
>
> __받은 데이터(크롤링시 parse사용>python datatype)를 validating 한 후에 parsed data를 complex type으로 다시 변환__
>
> 이때는 반드시  is\_valid()를 호출하여 검사하자

## serializer 구성해보기

DB와 DB인스턴스 생성 예시

```python
#DB
from datetime import datetime

class Comment:
    def __init__(self, email, content, created=None):
        self.email = email
        self.content = content
        self.created = created or datetime.now()

#원하는곳에서의 인스턴스생성
comment = Comment(email='leila@example.com', content='foo bar')
```

serializer 생성, django form과 매우 흡사(is_valid()도 체크됨)

```python
#serializers.py
from rest_framework import serializers

class CommentSerializer(serializers.Serializer):
    email = serializers.EmailField()
    content = serializers.CharField(max_length=200)
    created = serializers.DateTimeField()
```

## serializer 사용해보기

__serialize 해보기__

- DB인스턴스를 직렬화하는것을 볼수있음

```python

serializer = CommentSerializer(comment)
serializer.data
# {'email': 'leila@example.com', 'content': 'foo bar', 'created': '2016-01-27T15:17:10.375877'}
```

__deserialize 해보기__

- Parsing된 데이터(Python datatype)을 is\_valid()해주고 추후 save()시에 qs로 가능

```python
import io
from rest_framework.parsers import JSONParser

stream = io.BytesIO(json) #JSON 문자열을 바이트 타입으로 바꾸고, ByteIO 객체로 바꾼다.
data = JSONParser().parse(stream) #JSONParser 의 parser() 메서드를 이용하여 딕셔너리 형태로 변환한다.
serializer = CommentSerializer(data=data)
serializer.is_valid()
# True
serializer.validated_data
# {'content': 'foo bar', 'email': 'leila@example.com', 'created': datetime.datetime(2012, 08, 22, 16, 20, 09, 822243)}

```

## Saving  instances

create()나 update()메소드를 오버라이딩가능

```python
class CommentSerializer(serializers.Serializer):
    email = serializers.EmailField()
    content = serializers.CharField(max_length=200)
    created = serializers.DateTimeField()

    def create(self, validated_data):
        return Comment(**validated_data)

    def update(self, instance, validated_data):
        instance.email = validated_data.get('email', instance.email)
        instance.content = validated_data.get('content', instance.content)
        instance.created = validated_data.get('created', instance.created)
        return instance
```

이후 data를 deserializing할떄  save()를 호출해서 저장 가능. save는 instance가 존재하면 update, 아니면 create 해줌

> ```python
> # .save() will create a new instance.
> serializer = CommentSerializer(data=data)
> 
> # .save() will update the existing `comment` instance.
> serializer = CommentSerializer(comment, data=data)
> ```
>
> ```python
> serializer.save()
> ```

- save()에  추가적인 attribute 사용가능

  `serializer.save(owner=request.user)`

- save()를 직접  오버라이딩가능

  ```python
  class ContactForm(serializers.Serializer):
      email = serializers.EmailField()
      message = serializers.CharField()
  
      def save(self):
          email = self.validated_data['email']
          message = self.validated_data['message']
          send_email(from=email, message=message)
  ```

## Validation

data를 deserializing할 때, instance.save()하기전에 반드시  is_valid()를 호출해야함. 에러발생시  \.errors로 에러 메세지  호출가능

`{'field name': ['error message']}`

- `Raise_exception`는 is_valid()메소드에서 optional로 raise\_exception=True일때,400에러 반환

  ```python
  # Return a 400 response if the data was invalid.
  serializer.is_valid(raise_exception=True)
  ```

- Field-level validation: 각 필드별로 validate생성

  ```python
  from rest_framework import serializers
  
  class BlogPostSerializer(serializers.Serializer):
      title = serializers.CharField(max_length=100)
      content = serializers.CharField()
  
      def validate_title(self, value):
          """
          Check that the blog post is about Django.
          """
          if 'django' not in value.lower():
              raise serializers.ValidationError("Blog post is not about Django")
          return value
  ```

- Object-level validation: object 전역에 validate

  이건 멀티 필드에 대해 validation필요할때 .validate()사용

  ```python
  from rest_framework import serializers
  
  class EventSerializer(serializers.Serializer):
      description = serializers.CharField(max_length=100)
      start = serializers.DateTimeField()
      finish = serializers.DateTimeField()
  
      def validate(self, data):
          """
          Check that start is before finish.
          """
          if data['start'] > data['finish']:
              raise serializers.ValidationError("finish must occur after start")
          return data
  ```

- validator: 따로 validator를 만들어 field정의시

  ```python
  def multiple_of_ten(value):
      if value % 10 != 0:
          raise serializers.ValidationError('Not a multiple of ten')
  
  class GameRecord(serializers.Serializer):
      score = IntegerField(validators=[multiple_of_ten])
      ...
  ```

  Meta에  넣어서 완성된 field data에 적용시킬수도있다

  ```python
  class EventSerializer(serializers.Serializer):
      name = serializers.CharField()
      room_number = serializers.IntegerField(choices=[101, 102, 103, 201])
      date = serializers.DateField()
  
      class Meta:
          # Each room only has one event per day.
          validators = [
              UniqueTogetherValidator(
                  queryset=Event.objects.all(),
                  fields=['room_number', 'date']
              )
          ]
  ```

## [Accessing the initial data and instance](https://www.django-rest-framework.org/api-guide/serializers/#accessing-the-initial-data-and-instance)

## Partial updates

default로 모든 required fields를 넣어주지 않으면 validation error.

partial  arg를 통해서 업데이트 가능

```python
# Update `comment` with partial data
serializer = CommentSerializer(comment, data={'content': 'foo bar'}, partial=True)
```

## [Dealing with nested objects](https://www.django-rest-framework.org/api-guide/serializers/#dealing-with-nested-objects)

다른 serializer class를 field로 받을 수 있음

```python
class UserSerializer(serializers.Serializer):
    email = serializers.EmailField()
    username = serializers.CharField(max_length=100)

class CommentSerializer(serializers.Serializer):
    user = UserSerializer()
    content = serializers.CharField(max_length=200)
    created = serializers.DateTimeField()
```

required=False, many=True로 사용가능

## [Writable nested representations](https://www.django-rest-framework.org/api-guide/serializers/#writable-nested-representations)

nested된 serializer data에서 error발생시 nested된 field name으로 나옴.

validated\_data도 마찬가지

```python
serializer = CommentSerializer(data={'user': {'email': 'foobar', 'username': 'doe'}, 'content': 'baz'})
serializer.is_valid()
# False
serializer.errors
# {'user': {'email': ['Enter a valid e-mail address.']}, 'created': ['This field is required.']}
```

### nested\_data를 처리하는 방법을 써놓음(???)

- create: profile에 해당하는 데이터를 pop으로 뺴고, 해당하는 다른 DB에 저장하는게 핵심

  ```python
  class UserSerializer(serializers.ModelSerializer):
      profile = ProfileSerializer()
  
      class Meta:
          model = User
          fields = ['username', 'email', 'profile']
  
      def create(self, validated_data):
          profile_data = validated_data.pop('profile')
          user = User.objects.create(**validated_data)
          Profile.objects.create(user=user, **profile_data)
          return user
  ```

- update: 복잡하다. 만약에 관계가 있는 field가 None일 경우

  - relationship을 DB에서 NULL처리?
  - 연관된 instance을 삭제?
  - 데이터를 무시하고 instance를 그래도 놔두기?
  - validation Error

  ```python
      def update(self, instance, validated_data):
          profile_data = validated_data.pop('profile')
          # Unless the application properly enforces that this field is
          # always set, the following could raise a `DoesNotExist`, which
          # would need to be handled.
          profile = instance.profile
  
          instance.username = validated_data.get('username', instance.username)
          instance.email = validated_data.get('email', instance.email)
          instance.save()
  
          profile.is_premium_member = profile_data.get(
              'is_premium_member',
              profile.is_premium_member
          )
          profile.has_support_contract = profile_data.get(
              'has_support_contract',
              profile.has_support_contract
           )
          profile.save()
  
          return instance
  ```

  __create, update가 모호하고 related model간에서 복잡한 의존도가 필요하기 때문에 REST에서는 항상 method를 명시적으로 사용해야함__

__Handling saving related instance in model manager  class__

related instance를  여러개 저장하는 다른 방법은 custom model manager를사용하는 방법

```python
class UserManager(models.Manager):
    ...

    def create(self, username, email, is_premium_member=False, has_support_contract=False):
        user = User(username=username, email=email)
        user.save()
        profile = Profile(
            user=user,
            is_premium_member=is_premium_member,
            has_support_contract=has_support_contract
        )
        profile.save()
        return user
```

위에서 create를 재정이 한후에

```python
def create(self, validated_data):
    return User.objects.create(
        username=validated_data['username'],
        email=validated_data['email'],
        is_premium_member=validated_data['profile']['is_premium_member'],
        has_support_contract=validated_data['profile']['has_support_contract']
    )
```

이런식으로 model manager에서 정의한 create를 호출해서 사용가능

자세한 내용은 django model  manager문서 보자

## Dealing with mutiple objects

serializer는 object들의  list도 serializing/deserializing 가능

__여러 objects serializing__

- many=True flag를 추가, 퀴리셋이나  리스트를 serializing가능

  ```python
  queryset = Book.objects.all()
  serializer = BookSerializer(queryset, many=True)
  serializer.data
  # [
  #     {'id': 0, 'title': 'The electric kool-aid acid test', 'author': 'Tom Wolfe'},
  #     {'id': 1, 'title': 'If this is a man', 'author': 'Primo Levi'},
  #     {'id': 2, 'title': 'The wind-up bird chronicle', 'author': 'Haruki Murakami'}
  # ]
  ```

__여러 objects deserializing__

- multiple create는 가능,  update는 불가능, 아래 [ListSerializer](https://www.django-rest-framework.org/api-guide/serializers/#listserializer)에서 자세히 설명

## Including extra context

serializer를 처음 만들 때 context arg로 다른  context를 추가 가능하다.

```python
serializer = AccountSerializer(account, context={'request': request})
serializer.data
# {'id': 6, 'owner': 'denvercoder9', 'created': datetime.datetime(2013, 2, 12, 09, 44, 56, 678870), 'details': 'http://example.com/accounts/6/details'}
```

