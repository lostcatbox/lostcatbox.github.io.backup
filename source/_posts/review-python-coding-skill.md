---
title: 파이썬 코딩의 스킬 리뷰
date: 2020-02-18 01:44:48
categories: [Python]
tags: [Review, Tip, Skill]
---

# 왜 읽는가?

파이썬을 쓰다보면 내가 짜는것이 효율적인지, 비효율적인지 따질수없었다.

코딩 스킬이 좋다라는 기준이 나에게는 없으니 내가 편한대로 짜버린 프로젝트가 whereMyPost였다.

지금 들어가봐도 엉망이다. 하지만 일단 작동은 하니까 항상 어지럽다.

하지만 다른 Django 같은 라이브러리를 보면 tree형식으로 각자의 디렉토리 안에  파일의 코드들이 역할에는 BaseCode들이 많고 이를 상속받아서 기능을 추가하는 방식으로 구현해서 기능을 추가, 수정하기도 편리하고, 누가 코드를 뜯어볼때도 편해진다.

코드를 잘짜면 모두가 편하고, 단점이없다.(물론 처음짤때부터 완벽한 구성을 하는것도 미련하다생각한다.) 

즉, 내게는 지금 잘짜여진코드와 이를 어떻게 짜야하는지 그 기준을 알려줄 것이 필요해서 이 책을 선택하게되었다.

# 목표

하루 최소 15페이지씩 읽고 이해한다. (시작일20.02.18~)

# 1장 - 파이썬다운 생각

파이썬다운것은 다음과같다

```
>>>import this #이거하면 답나옴
```

## 사용중인 파이썬 버전알기

```
$ python --version 

#python 안에서
import sys

sys.version # 파이썬에 내장된 sys모듈 안의 값을 조사하여 런타임에 사용중인 파이썬버전체크가능
```

## PEP8 스타일 가이드를 따르자

파이썬 개선 제안서(PEP)가이드 참조하자

 [자세히](https://www.python.org/dev/peps/pep-0008/)  [자세히(번역)](https://kongdols-room.tistory.com/18)

### 화이트 스페이스

파이썬에서 화이트 스페이스(공백)은 문법적으로 의미가 크다. 잘지켜야함

- 문법적으로 의미있는 곳은 탭 아닌 스페이스4번으로 들여쓰기
- 한 줄의 문자 길이가 79자 이내
- 표현식이 길어서 다음 줄로 이어지면 일반적인 들여쓰기 수준에 추가로 스페이스 4번
- 파일에서 함수와 클래스는 빈 줄 두개로 구분
- 클래스에서 메서드는 빈 줄 하나로 구분
- 리스트 인덱스, 함수 호출, 키워드 인수 할당에는 스페이스를 사용하지않는다
- 변수 할당 앞뒤에 스페이스를 하나만 사용한다

### 명명

독자적 명명 스타일을 제안한드. 스타일을 따르면 코드를 읽을 때 각 이름에 대응하는 타입을 구별하기 쉽다.

- 함수, 변수, 속성은 lowercase_underscore 형식을 따른다

- 보호(protected) 인스턴스 속성은 _leading_underscore 형식을 따른다

- 비공개(private) 인스턴스 속성은 __double_leading_usderscore 형식을 따른다

- 클래스와 예외는 CapitalizedWord형식을 따른다

- 모듈 수준 상수는 ALL_CAPS형식을 따른다

- 클래스의 인스턴스 메서드에서는 첫 번째 파라미터(해당 객체를 참조)의 이름을 self로 지정한다

- 클래스 메서드에서는 첫 번째 파라미터(해당 클래스를 참조)의 이름을 cls로 지정한다 

  @classmothed

### 표현식과 문장

- 긍정 표현식의 부정(if not a is b)대신에 인라인 부정(if a is not b)을 사용한다

- 길이를 확인(if len(somelist) == 0)하여 빈 값을 확인하지 않는다.

  if not somelist를 사용하고, 빈 값은 암시적으로 False가 된다고 가정한다.

- 비어 있지 않은 값([1] 또는 'hi')에도 위와 같은 방식이 적용된다. 값이 비어있지 않으면 if somelist 문이 True 반환됨

- 한 줄로 된 if 문, for와 while 루프, except 복합문을 쓰지 않는다. 이런 문장은 여러 줄로 나눠서 명료하게 작성한다.

- 항상 파일의 맨 위에 import문을 놓는다.

- 모듈을 import할때는 항상 모듈의 절대 이름을 사용하며 상대 경로로 된 이름을 사용하지 않는다.

  (from bar import foo) #bar패키지의 foo모듈사용시

- 상대적인 import를 해야한다면 명시적인 구문을 써서 한다

  (from . import foo)

- import는 '표준 라이브러리 모듈, 서드파티 모듈, 자신이 많은 모듈' 섹션 순으로 구분해야 한다. 각각의 하위 섹션에서 알바벳 순서로 import한다

> 핵심은 결국 PEP를 따르며 작성하면 보기편하며, 수정, 추가 등등 생산성 높아지므로 지키자

### bytes, str, unicode의 차이점을 알자

__파이썬 3__에서는 bytes와 str 두 가지 타입으로 문자 시퀀스를 나타낸다.

bytes 인스턴스는 raw 8비트 값을 저장한다.

str 인스턴스는 유니코드 문자를 저장한다.

__파이썬 2__는 각각 str, unicode를 8비트, 유니코드 문자를 저장

유니코드 문자를 바이너리 데이터(raw 8비트 값)로 표현하는 방법은 많다. 가장 일반적인 인코딩은 UTF-8이다. 중요한건 파이썬 3의 str인스턴스와 파이썬2의 unicode인스턴스는 연관된 바이너리 인코딩이 없다는 점이다. 유니코드 문자를 바이너리 데이터로 변환하려면 encode 메서드를 사용해야한다. 바이너리 데이터를 유니코드 문자로 변환하려면 decode 메서드를 사용 해야 한다. 

파이썬 프로그래밍을 할떄 외부에 제공할 인터페이스에서는 유니코드를 인코드하고 디코드해야 한다. 유니코드 문자 타입(파이썬3 는 str, 2는 unicode)을 사용하고, 문자 인코딩에 대해서는 어떤 가정도 하지 말아야한다. 이렇게 하면 출력 텍스트 인코딩(UTF-8)을 엄격하게 유지하면서도 다른 텍스트 인코딩(예로 Big5)을 쉽게 사용가능 

> __주요 용어__
>
> **인코딩과 디코딩 (Encoding & Decoding)**
>
> 컴퓨터는 문자를 인식할 수 없기 때문에 숫자로 변환되어 저장됩니다. 변환해주기 위해서는 기준이 있어야하는데 이것을 문자 코드라고 하며 대표적으로 __ASCII코드 또는 유니코드__가 있습니다.
>
> 이렇게 문자 코드를 기준으로 문자를 코드로 변환하는 것을 **문자 인코딩(encoding)** 이라하고 코드를 문자로 변환하는 것을 **문자 디코딩(decoding)** 이라고 합니다.
>
> __바이너리 데이터와 텍스트 데이터__: 우리의 관점에서는 각각의 파일은 그저 일련의 바이트들입니다. 일반적으로 모든 파일은 **바이너리 파일**입니다(이미지도가능). 그러나 파일 안의 데이타가 오직 텍스트(문자,숫자,기호들)만 들어있고 여러 행들로 구성되어 있다면, 우리는 그 파일을 **텍스트 파일**로 간주합니다.(텍스트만가능)
>
> str을 encode하면 byte형이 되고 byte형을 decode하면 str이 됩니다.
>
> ```
>   >>> s = 'Vi er så glad for å høre og lære om Python!'
>   >>> b = s.encode('utf-8')
>   >>> b
>   b'Vi er s\xc3\xa5 glad for \xc3\xa5 h\xc3\xb8re og l\xc3\xa6re om Python!'
>   >>> b.decode('utf-8')
>   'Vi er så glad for å høre og lære om Python!'
> ```

문자 타입이 분리되어있기 때문에 나타나는 파이썬 코드에서 2가지 상황에 부딪침

- UTF-8(혹은 다른 인코딩)으로 인코드된 문자인 8비트 값을 처리하려는 상황
- 인코딩이 없는 유니코드 문자를 처리하려는 상황

이 두 경우 사이에서 변환하고 코드에서 원하는 타입과 입력값의 타입이 정확히 일치하게 하려면 헬퍼 함수 두 개가 필요하다

파이썬 3에서는 먼저 str이나 bytes를 입력으로 받고 str을 반환하는 메서드가 필요하다

```
def to_str(bytes_or_str):
    if isinstance(bytes_or_str, bytes):
        value = bytes_or_str.decode('utf-8')
    else:
        value = bytes_or_str
    return value # str 인스턴스
```

그리고 str이나 bytes를 받고 bytes를 반환하는 메서드도 필요하다.

```
def to_str(bytes_or_str):
    if isinstance(bytes_or_str, str):
        value = bytes_or_str.encode('utf-8')
    else:
        value = bytes_or_str
    return value # bytes 인스턴스
```

> 파이썬2에서는 생략한다. 위와 형식이 같다

파이썬에서 raw 8비트 값과 유니코드 문자를 처리할 때는 중대한 이슈 2개를 알아두자

- 첫번째는 파이썬 2에서 str이 7비트 아스키 문자만 포함하고 있다면 unicode와 str인스턴스가 같은 타입처럼 보인다는 점이다

  - 이런 str과 unicode를 + 연산자로 묶을 수 있다.
    - equality와 inequality 연산자로 이런 str과 unicode를 비교할수있다
    - '%s'같은 포맷 문자열에 unicode인스턴스를 사용할 수 없다.

  이런 모든 동작은 7비트 아스키만 처리하는 경우 str또는 unicode를 받는 함수에 str이나 unicode인스턴스를 넘겨도 문제 없이 동작함을 의미한다.

- 두번째는 파이썬 3에서 내장 함수 open이 반환하는 파일 핸들을 사용하는 연상은 기본적으로 UTF-8 인코딩을 사용한다는 것이다. (파이썬2는 바이너리 인코딩을 사용). 

  ```
  with open('~/cat/cats.bin', 'w') as f:
      f.write(os.urandom(10))
      
  >>> TypeError
  ```

  

  문제의 이유는 파이썬 3의 open에 새 encoding인수가 추가되었고 이 파라미터의 기본값은 'utf-8'이다. 따라서 파일 핸들을 사용하는 read나 write 연산은 바이너리 데이터를 담은 bytes인스턴스가 아니라 유니코드 문자를 담은 str 인스턴스를 기대한다.

  위 코드가 문제없이 동작할려면 데이터를 바이너리 쓰기 모드로 오픈해야한다('wb')

  ```
  with open('~/cat/cats.bin', 'wb') as f:
      f.write(os.urandom(10))
      
  >>> TypeError
  ```

  __즉, 바이너리 데이터를 파일에서 읽거나 쓸 때는 파일을 바이너리 모드로 오픈한다!__

  

## 복잡한 표현식 대신 헬퍼 함수를 작성하자



파이썬의 간결한 문법으로 많은 로직을 표현식 한 줄로 쉽게 작성가능하다. 

예를 들어 URL에서 쿼리 문자열을 디코드해야 한다고 하자.

(인코드>>부호화, 디코드>>부호에서 원본으로)

(쿼리 문자열은 get인자들 주소창에 표현될때 생각하면됨)



```
from urllib.parse import parse_qs
my_values = parse_qs('red=5&blue=0&green=',
                      keep_blank_values=True)
                      
print(repr(my_values))   # (repr , str유사)

>>>{'red': ['5'], 'blue': ['0'], 'green': ['']}

#파라미터는 존재하지만 값이 비어있을수있다. get메서드를 사용하면 더 보기편하다
print('Red:    ', my_values.get('red'))

>>> Red:     ['5']
```

비여있는 경우 None보다는 False가 나오는것이 좋다. 불 표현식으로 쉽게 처리하자

이때 사용하는 트릭은 __빈 문자열, 빈 리스트, 0이 모두 암시적으로 False로 평가되는점"__이다. 

```
# Example 3
# For query string 'red=5&blue=0&green='

# get에 첫번째 인자에 맞는 것이 없다면 빈리스트 반환, 
# 빈리스트는 false이므로 or의 0이 반환됨
red = my_values.get('red', [''])[0] or 0 
green = my_values.get('green', [''])[0] or 0
opacity = my_values.get('opacity', [''])[0] or 0
print('Red:     %r' % red)
print('Green:   %r' % green)
print('Opacity: %r' % opacity)



>>> 
Red:     '5'
Green:   0
Opacity: 0
```

위에 처럼 겹쳐쓰고 저기에다가 int()로 둘러버리면 너무 읽는 사람이 복잡해진다.

따라서 아래처럼 간결하게 표현가능하다

```
green = my_values.get('green', [''])
if green[0]:
    green = int(green[0])
else:
    green = 0
print('Green:   %r' % green)
```

이는 반복되면 메서드이므로 헬퍼 함수를 만들어 버리는게 재사용성이 올라간다.

```
def get_first_int(values, key, default=0):
    found = values.get(key, [''])
    if found[0]:
        found = int(found[0])
    else:
        found = default
    return found
    
    
green = get_first_int(my_values, 'green')
print('Green:   %r' % green)
```

즉, 표현식이 복잡해지기 시작하면 최대한 빨리 해당 표현식을 작은 조각으로 분할하고 로직을 헬퍼 함수로 옮기는 방안을 고려해야 한다. 무조건 짧은 코드보다는 가독성을 선택하는 편이 낫다. 

## 시퀀스를 슬라이스하는 방법을 알자

파이썬은 시퀀스를 slice해서 조각으로 만드는 문법 제공한다. 이를 사용하여 시퀀스의 부분 subset에 접근가능하다.

slice대상은 내장 타입인 list, str, bytes를 기본으로 \_\_getitem\_\_, \_\_setitem\_\_ 이라는 특별한 메서드를 구현하는 파이썬의 클래스에도 슬라이싱을 적용할수 있다. ("커스텀 컨테이너 타입은 collections.abc의 클래스를 상속받게 만들자" 참조)

슬라이싱 문법의 기본 형태는 somelist[start:end]이며, 범위는 start포함 end비포함이다. ()

```
>>>
a = ['red', 'orange', 'yellow', 'green', 'blue', 'purple']
odds = a[:2]
evens = a[1:2]
print(odds)
print(evens)

['red', 'orange']
['orange']

>>>
odds = a[:-2]   #-number 잘 활용하기 -가 붙으면 뒤에서부터 셈
evens = a[-0:]

['red', 'orange', 'yellow', 'green']
['red', 'orange', 'yellow', 'green', 'blue', 'purple']
```













# 출처

출처: https://freestrokes.tistory.com/71 [FREESTROKES DEVLOG]