---
title: 파이썬 코딩의 스킬 리뷰 1
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

하루 최소 10페이지씩 읽고 이해한다. (시작일20.02.18~)

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

할당을 사용하면 슬라이스는 원본 리스트에서 지정한 범위를 대체한다. 튜플 할당과 달리 슬라이스 할당의 길이는 달라도된다.

리스트는 새로 할당된 값에 맞춰 늘어나거나 줄어든다.

```
>>>
a

['red', 'orange', 'yellow', 'green', 'blue', 'purple']

>>>
a[2:4] = [1,2,3,4,5]

>>>
a

['red', 'orange', 1, 2, 3, 4, 5, 'blue', 'purple']

>>>
b = a[:]  #start, end index모두 생략시, 새 리스트를 할당하지 않고!!, 슬라이스의 전체 내용을 참조대상의 복사본으로 대체한다
print(b)

['red', 'orange', 1, 2, 3, 4, 5, 'blue', 'purple']
```

위에서 즉 한 데이터에 b = a 라고했을때 a가 가르키는 저장위치에 b도 태그로 붙었다라고 볼수있다. 따라서 a와 b는 같은 데이터를 가르키므로 a를 바꾸면 b도 출력되는 데이터가 바뀌는 것을 확인할수있다.

```
In [29]: print('Before', a)
    ...: a[:] = [101,102,103]
Before [101, 102, 103]

In [30]: assert a is b

In [31]: print('After', a)
After [101, 102, 103]

In [33]:  a is b
Out[33]: True

In [34]: b
Out[34]: [101, 102, 103]
```

## 한 슬라이스에 start, end, stride를 함께 쓰지 말자

슬라이싱 문법은 `somelist[start:end:stride]` 인데 stride를 사용하면 슬라이스 간격을 설정할수있다. 

즉, stride는 매 n번째 아이템을 가져오는 것이다.

```
In [40]: a = ['red', 'orange', 1, 2, 3, 4, 5, 'blue', 'purple']

In [41]: odds = a[::2] #편하게 짝수번째 아이템들만 가져올수있다

In [42]: odds
Out[42]: ['red', 1, 3, 5, 'purple'] 
```

문제는 stride 문법이 버그를 만들어낸다.

예를 들면 파이썬에서 바이트 문자열을 역순으로 만드는 일반적인 방법은 스트라이드 -1로 문자열을 슬라이스하는 것이다.

```
In [43]: x = b'mongoose' #byte 데이터로 지정은 b'~~'임

In [44]: y = x[::-1]

In [45]: y
Out[45]: b'esoognom'
```

위의 코드는 바이트 문자열이나 아스키 문자에서는 잘 동작하지만, UTF-8 바이트 문자열로 인코드된 유니코드 문자에는 원하는 대로 동작하지 않는다.

```
In [46]: w = '고양이'

In [47]: x = w.encode('utf-8')

In [48]: y = x[::-1]

In [49]: y.decode('utf-8')
---------------------------------------------------------------------------
UnicodeDecodeError                        Traceback (most recent call last)
<ipython-input-49-afdc29402324> in <module>
----> 1 y.decode('utf-8')
```

슬라이스 stride 응용

```
a[2::2]
a[-2::-2] #마지막 두번째부터 거꾸로 2간격으로
```

하지만 이렇게 start, end, stride까지 써버리면 코드읽는사람이 햇갈릴수있으므로 하나씩쓰자

```
b = a[::2]
c = b[1:-1]
```

슬라이싱하고 stride하면 데이터의 얕은 복사본이 추가로 생긴다(메모리사용하게됨)

메모리 줄이고 싶다면 "내장 알고리즘과 자료 구조를 사용하자" 참조하자 

(참조 내용 중 islice메서드는 start, end stride에 음수 값을 허용하지 않는다)

## map과 filter 대신 리스트 컴프리헨션을 사용하자

파이썬에는 한 리스트에서 다른 리스트를 만들어내는 간결한 문법 존재!

이를 __list comprehension__ 이라고한다

```
>>>
a = [1,2,3,4,5,6,7,8,9,10]
squares = [x**2 for x in a]
print(squares)

[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

 비슷하게 map은 리스트의 요소를 지정된 함수로 처리해주는 함수입니다(map은 원본 리스트를 변경하지 않고 새 리스트를 생성합니다) 

문법: `list(map(함수, 리스트))`

하지만 map과 달리 list comprehension을 사용하면 조건을 걸고 바로 걸러내서 출력할수있다 

```
>>>
even_squares = [x**2 for x in a if x%2==0]

[4, 16, 64, 100]
```

물론 내장함수 filter를 mmap과 연계해서 사용해도 같은 결과지만 복잡하다

```
In [62]: alt = list(map(lambda x: x**2, filter(lambda x: x%2==0, a)))

In [63]: print(alt)
[4, 16, 36, 64, 100]
```

딕셔너리와 세트에도 list comprehension표현식 지원. 

쓰자! 알고리즘을 작성할 떄 파생되는자료 구조를 쉽게 생성가능

```
>>>
chile_ranks = {'ghost': 1, 'habanero': 2, 'cayenne': 3}
rank_dict = {rank: name for name, rank in chile_ranks.items()}
chile_len_set = {len(name) for name in rank_dict.values()}
print(rank_dict)
print(chile_len_set)

{1: 'ghost', 2: 'habanero', 3: 'cayenne'}
{8, 5, 7}
```



## 리스트 컴프리헨션에서 표현식을 두개 넘게 쓰지 말자

리스트안에 리스트 내용들을 하나의 평평한 리스트로 나타내는 예시, 표현식은 왼쪽에서 오른쪽으로 실행됨

```
>>>
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat = [x for row in matrix for x in row]
print(flat)

[1, 2, 3, 4, 5, 6, 7, 8, 9]
```

행렬의 각 셀에 있는 값의 제곱구함

```
>>>
squared = [[x**2 for x in row] for row in matrix]
print(squared)

[[1, 4, 9], [16, 25, 36], [49, 64, 81]]
```

다른 루프를 넣는다면 리스트 컴프리헨션이 여러 줄로 구별해야할정도로 길어짐

```
>>>
my_lists = [
    [[1, 2, 3], [4, 5, 6]],
    [[7, 8, 9], [10, 11, 12]],
]
flat = [x for sublist1 in my_lists
        for sublist2 in sublist1
        for x in sublist2]
print(flat)
```

이번엔 일반 루프문으로 같은 결과가능, 들여쓰기로 위에보다는 이해가 쉽다

```
flat = []
for sublist1 in my_lists:
    for sublist2 in sublist1:
        flat.extend(sublist2)
print(flat)
```

리스트 컴프리헨션도 다중 if 조건 지원한다. 같은 루프 레벨에 여러 조건이 있으면 암묵적으로 and표현식이된다.

예를 들어 숫자로 구성된 리스트에서 4보다 큰 짝수 값만 가지고 온다면 다음 두 리스트 컴프리헨션은 동일하다.

```
>>>
a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
b = [x for x in a if x > 4 if x % 2 == 0]
c = [x for x in a if x > 4 and x % 2 == 0]
print(b)
print(c)

[6, 8, 10]
[6, 8, 10]
```

조건은 루프의 각 레벨에서 for 표현식 뒤에 설정할 수 있다. 합이 10이상이고 3으로 나누어 떨어지는 숫자를 셀로 구한다고 하자

```
>>>
filterd = [[x for x in row if x%3==0] for row in matrix if sum(row)>10]
print(filterd)

[[6], [9]]
```

하지만 이런식으로 표현식이 두개를 넘어가면 피하는 게 좋다. 조건 두개, 루프 두개 혹은 조건 한개와 루프 한개가 적당하다.

이것보다 복잡해지면 if, for문을 사용하고 헬퍼 함수("리스트를 반환하는 대신 제너레이터를 고려하자" 참조)로 작성하자

## 컴프리헨션이 클 때는 제너레이터 표현식을 고려하자

리스트 컴프리헨션의 문제점은 입력 시퀀스에 있는 각 값별로 아이템을 하나씩 담은 새 리스트를 통째로 생성한다는 점이다. 이는 작업이 많으면 메모리를 많이 소모해서 프로그램을 망가뜨릴수있다.

에를 들어 파일을 읽어 각 줄에 있는 글자수를 리스트로 반환하고 싶다면

```
value = [len(x) for x in open('/~/~/cats.txt')]
print(value)

[100,57, 15, 1, 12, 75, 5, 86, 89, 11]
```

파이썬은 이 문제를 해결하려고 리스트 컴프리헨션과 제너레이터를 일반화한 제너레이터 표현식을 제공한다. (generator expression)

제너레이터 표현식은 실행될 떄 출력 시퀀스를 모두 구체화(여기서는 메모리에 로딩)하지 않는다. 대신에 표현식에서 한 번에 한 하이템을 내주는 이터레이터(iterator)로 평가된다.

제너레이터 표현식은 () 문자 사이에 리스트 컴프리헨션과 비슷한 문법을 사용하여 생성한다.

위에 예제와 비슷하지만 제너레이터 표현식은 즉시 이터레이터로 평가되므로 더는 진행되지 않는다

```
it = (len(x) for x in open('/~/~/cats.txt'))
print(it)

<generator object <genexpr> at 0x10f625e10>
```

필요할 때 제너레이터 표현식에서 다음 출력을 생성하려면 내장함수 next로 반환받은 이터레이터를 한 번에 전진시키면 된다.

```
>>>
print(next(it))
print(next(it))

100
57
```

> 주요 용어
>
> __이터레이터__는 여러개의 요소를 가지는 컨테이너(리스트, 튜플, 셋, 사전, 문자열)에서 각 요소를 하나씩 꺼내 어떤 처리를 수행하는 간편한 방법을 제공하는 객체입니다.!(즉, 요소하나씩만 빼오므로 메모리 부담이없다.)
>
> ```
> In [73]: s = 'abc'
> 
> In [74]: it = iter(s)   #이터레이터 객체로 만듬
> 
> In [75]: it
> Out[75]: <str_iterator at 0x10f625e10>
> 
> In [76]: next(it)
> Out[76]: 'a'
> 
> In [77]: next(it)
> Out[77]: 'b'
> 
> In [78]: next(it)
> Out[78]: 'c'
> 
> In [79]: next(it)
> 
> StopIteration
> ```

제너레이터 표현식의 또 다른 제너레이터 표현식과 함께 사용가능한것이다. 

예시는 앞의 제너레이터 표현식이 반환한 이터레이터를 다른 제너레이터 표현식의 입력으로 사용한 예다.

```
>>>
roots = ((x, x**0.5) for x in it) #it은 이터레이터
print(next(roots))

(15, 3.872983346207417) #왜냐면 다음 it에서 나오는 것이 아이템 15였기때문

```

이처럼 만약 큰 입력 스트림에 동작하는 기능을 결합하는 방법을 찾을 때는 제너레이터 표현식이 최선의 도구다. 

제너레이터 표현식은 서로 연결되어 있을 때 매우 빠르게 실행된다.

단, 제너레이터 표현식이 반환한 이터레이터에는 상태가 있으므로 이터레이터를 한 번 넘게 사용하지 않도록 주의해야 한다. 

("인수를 순회할 때는 방어적으로 하자" 참조)



## range보다는 enumerate를 사용하자

내장 함수 range는 정수 집합을 순회(iterate)하는 루프를 실행할 때 유용하다.

이는 리스트에서 현재 아이템의 인덱스(위치)를 알고 싶은 경우가 있을 때 range을 사용하면 편리하다.

```
>>>
flavor_list = ['vanilla', 'chocolate', 'pecan', 'strawberry']
for flavor in flavor_list:
    print('%s is delicious' % flavor)

vanilla is delicious
chocolate is delicious
pecan is delicious
strawberry is delicious

>>>
for i in range(len(flavor_list)):
    flavor = flavor_list[i]
    print('%d: %s' % (i + 1, flavor))

1: vanilla
2: chocolate
3: pecan
4: strawberry
```

하지만 위에 코드는 세련되지 못하다. 리스트길이정보와 배열을 인덱스로 접근해야 하며, 읽기 불편하다.

파이썬은 이런 상황을 처리하려고 내장함수 enumerate를 제공한다.

enumerate는 지연 제너레이터(lazy generator)로 이터레이터를 감싼다. (???)

이 제너레이터는 이터레이터에서 루프 인덱스와 다음 값을 한쌍으로 가져와 넘겨준다.



```
>>>
for i, flavor in enumerate(flavor_list):
    print('%d: %s' % (i + 1, flavor))

1: vanilla
2: chocolate
3: pecan
4: strawberry

>>>
for i, flavor in enumerate(flavor_list, 1):   #세기 시작숫자는 1부터 시작할꺼다!! 분명 0번째지만 i는 1로받음
    print('%d: %s' % (i, flavor))
    
```

즉, enumerate는 이터레이터를 순회하면서 이터레이터에서 각 아이템의 인덱스를 얻어오는 간결한 문법을 제공하낟.

tip: enumerate의 두번째 파라미터는 세기 시작할 숫자를 지정할 수 있다.



## 이터레이터를 병렬로 처리하려면 zip을 사용하자

파이썬에서 관련 객체로 구성된 리스트를 많이 사용한다.

리스트 컴프로헨션을 사용하여 소스 리스트(source list)에 표현식을 적용하여 파생 리스트(derived list)를 쉽게 얻을수있다

("map과 filter 대신 리스트 컴프리헨션을 사용하자" 참조)

```
>>>
names = ['Cecilia', 'Lise', 'Marie']
letters = [len(n) for n in names]
print(letters)
```

현재 예시에서는 파생 리스트의 아이템과 소스 리스트의 아이템은 서로의 인덱스로 연관되어 있다. 따라서 두 리스트를 병렬로 순회하려면 소스 리스트인 names의 길이만큼 순회하면 된다.

```
>>>
longest_name = None
max_letters = 0

for i in range(len(names)):  #len(names) 3임
    count = letters[i]
    if count > max_letters:
        longest_name = names[i]
        max_letters = count

print(longest_name)

Cecilia
```

문제는 전체 루프문이 별로 보기 안 좋다는 것이다. names와 letters를 인덱스로 접근하면 코드를 읽기어려워진다.

루프의 인덱스 i로 배열에 접근하는 동작이 두번 일어난다. enumerate를 사용하면 조금 개선가능하다

```
>>>
for i, name in enumerate(names):
    count = letters[i]
    if count > max_letters:
        longest_name = name
        max_letters = count
```

파이썬은 위 코드를 좀더 명료하게 하는 내장함수 zip을 제공한다.

파이썬3에서 zip은 지연 제너레이터로 이터레이터 두 개 이상을 감싼다.

zip 제너레이터는 각 이터레이터로부터 다음 값을 담은 튜플 얻어온다.

zip 제너레이터를 사용한 코드는 다중 리스트에서 인덱스로 접근하는 코드보다 휠씬 명료하다.

```
>>>
longest_name = None
max_letters = 0
for name, count in zip(names, letters):
    if count > max_letters:
        longest_name = name
        max_letters = count
print(longest_name)
```

__내장 함수 zip을 사용할때는 두가지 문제점 존재__

- 파이썬2에서 제공하는 zip이 제너레이터가 아니라는 점, 따라서 제공한 이터레이터를 완전히 순회해서 모든 튜플을 반환한다.

  이과정에서 메모리 너무 사용함. (해결은 "내장 알고리즘과 자료 구조를 사용하자" 참조)

- 입력 이터레이터들의 길이가 다르면 zip이 이상하게 동작한다는 점이다. 

  예를 들면 names리스트에는 다른 이름을 추가했지만 letters에는 없다면 그건 그냥 빼고 연산해버린다.(그냥 버려버림)

  리스트의 길이가 같다고 확신 할 수 없다면 대신 내장 모듈 itertools의 zip_longest를 사용하는 방안을 고려해보자(파이썬2에서는 izip_longest)

## for와 while 루프 뒤에는 else블록을 쓰지말자

파이썬의 루프에는 다른 프로그래밍 언어에는 없는 추가적인 기능이 있다. 루프에서 반복되는 내부 블록 바로 다음에 else 블로을 둘 수 있는 기능이다.

```
>>>
for i in range(3):
    print('Loop %d' % i)
else:
    print('Else block!')
```

for구문이 종료되면 else가 실행되는것처럼보인다.(if/else구문에서 if블록이 실행되지 않으면 else블록이 실행된다는 느낌)

> try/exept 문에서는 except도  '이전블록에서 실패하면 이 블록이 실행된다' 는 의미
>
> try/except/else는 '이전 블록이 실패하지 않으면 실행해라'는 의미
>
> try/finally 는 '이전 블록을 실행하고 항상 마지막에 실행하라'는 의미

처음 접하면 for/else에서 for문이 실행되지 않으면 else가 실행된다고 생각할텐데 이 생각은 틀렸다

```
>>>
for i in range(3):
    print('Loop %d' % i)
    if i == 1:
        break
else:
    print('Else block!')
    
    
Loop 0
Loop 1
```

위와 같이 `for x in []:` ,`while False`: 를 해도 else구문 실행된다. 

이렇게 동작하는 이유는 루프 다음에 오는 else블록은 루프로 뭔가를 검색할 떄 유용하기 때문이다. 

예를 들어 두 숫자가 서로소(공약수가하나임)인지를 판별한다고 하자.

```
>>>
a = 4
b = 9

for i in range(2, min(a, b) + 1):   #python 내장함수 min은 최소값을 반환한다.
    print('Testing', i)
    if a % i == 0 and b % i == 0:
        print('Not coprime')
        break
else:
    print('Coprime')   #for을 다 돌았는데도 없다면 a,b는 최소 서로소


Testing 2
Testing 3
Testing 4
Coprime
```

실제로 이런 코드를 작성하면 안된다. 대신에 이런 계산을 하는 헬퍼 함수를 작성하는 게 좋다

이런 헬퍼 함수는 두가지 일반적인 스타일로 작성한다

- 첫 번째 방법은 찾으려는 조건을 찾았을 때 바로 반환

  루프가 실패로 끝나면 기본 결과(True)반환한다

  ```
  >>>
  def coprime(a, b):
      for i in range(2, min(a, b) + 1):
          if a % i == 0 and b % i == 0:
              return False
      return True
  print(coprime(4, 9))
  print(coprime(3, 6))
  ```

- 두 번째 방법은 루프에서 찾으려는 대상을 찾았는지 알려주는 결과 변수를 사용하는 것이다, 

  뭔가를 찾았으면 즉시 break로 루프를 중단한다.

  ```
  >>>
  def coprime2(a, b):
      is_coprime = True
      for i in range(2, min(a, b) + 1):
          if a % i == 0 and b % i == 0:
              is_coprime = False
              break
      return is_coprime
  print(coprime2(4, 9))
  print(coprime2(3, 6))
  ```

이 두 가지 방법을 적용하면 낯선 코드를 접하는 개발자들이 코드를 휠씬 쉽게 이해할 수 있다.

__루프 뒤에는 절대 else블록 쓰지 말자__

## try/except/else/finally 에서 각 블록의 장점을 이용하자(중요)

파이썬에는 예외 처리 과정에서 동작을 넣을 수 있는 네 번의 구분되는 시점이 있다. 

__try, except, else, finally 블록 기능으로 각 시점을 처리한다. 

각 블록은 복합문에서 독자적인 목적이 있으며, 이 블록들을 다양하게 조합하면 유용하다.

("루트 Exception을 정의해서 API로부터 호출자를 보호하자" 참조)



### finally 블록

에외를 전달하고 싶지만, 예외가 발생해도 정리 코드를 실행하고 싶을 때

__try/finally__ 를 사용하면 된다.

예를 들어, 파일 핸들러를 제대로 종료하는 작업이다

("재사용 가능한 try/finally 동작을 만들려면 contextlib와 with문을 고려하자" 참조)

```
import logging
from pprint import pprint
from sys import stdout as STDOUT

>>>
handle = open('random_data.txt', 'w', encoding='utf-8') #현재 경로에서 txt파일 만들어짐
handle.write('success\nand\nnew\nlines') #내용을 적음 한줄뛰기로 적용됨
handle.close()
handle = open('random_data.txt')  # May raise IOError
try:
    data = handle.read()  # May raise UnicodeDecodeError
finally:
    handle.close()        # Always runs after try:
```

read 메서드에서 발생한 예외는 항상 호출 코드까지 전달되며, handle의 close 메서드 또한 finally 블록에서 실행되는 것이 보장된다.

파일이 없을 때 IOError처럼, 파일을 열 때  일어나는 예외는 finally블록에서 처리하지 않아야 하므로 try블록 앞에서 open을 호출해야한다.

### else 블록

코드에서 어떤 예외를 처리하고 어떤 예외를 전달할지를 명확하게 하려면 __try/except/else__ 를 사용해야 한다.

__try: 블록이 예외를 읽으키지 않으면 다음 else 블록이 실행된다(else블록을 사용하면 try블록 최소화 +가독성상승 가능)__

__except: try블록에서 예외가 발생하면 실행됨(else는 실행안됨!!)__

예를 들어 문자열에서 JSON 딕셔너리 데이터를 로드하여 그 안에 든 키의 값을 반환한다고 하자.

```
import json

def load_json_key(data, key):
    try:
        result_dict = json.loads(data)  # May raise ValueError
    except ValueError as e:
        raise KeyError from e
    else:
        return result_dict[key]         # May raise KeyError
```

데이터가 올바른 JSON이 아니라면 json.loads로 디코드할때 ValueError가 일어난다.

 이 예외는 except블록에서 발견되어 처리된다

디코딩이 성공하면 else블록에서 키를 찾는다. 

키를 찾을 때 에외가 일어나면 그 예외는 try블록 밖에 있으므로 호출 코드까지 전달된다.(터미널에 에러코드가 뜬다는말인듯???)

else절은 try/except 다음에 나오는 처리를 시각적으로 except블록과 구분해준다. 그래서 예외 전달 행위를 명확하게 한다.



## 모두 함께 사용하기(??? json정리후 다시읽어보기)

복합문 하나로 모든 것을 처리하고 싶다면 __try/except/else/finally__ 를 사용하면 된다.

예를 들어 파일에서 수행할 작업 설명을 읽고 처리한 후 즉석에서 파일을 업데이트한다고 하자.

여기서 try 블록은 파일을 읽고 처리하는데 사용한다.

except 블록은 try 블록에서 일어난 예외를 처리하는데 사용한다.

else 블록은 파일을 즉석에서 업데이트하고 이와 관련한 예회가 전달되게 하는 데 사용한다.

finally블록은 파일 핸들을 정리하는 데 사용한다.

[참고](https://docs.python.org/ko/3/library/json.html)

```
import json
UNDEFINED = object()

def divide_json(path):
    handle = open(path, 'r+')   # May raise IOError
    try:
        data = handle.read()    # May raise UnicodeDecodeError
        op = json.loads(data)   # May raise ValueError
        value = (
            op['numerator'] /
            op['denominator'])  # May raise ZeroDivisionError
    except ZeroDivisionError as e:
        return UNDEFINED
    else:
        op['result'] = value
        result = json.dumps(op)
        handle.seek(0)
        handle.write(result)    # May raise IOError
        return value
    finally:
        handle.close()          # Always runs
```

이 레이아웃은 모든 블록이 직관적인 방식으로 엮여서 동작하므로 특히 유용하다.

예를 들어 결과 데이터를 재작성하는 동안에 else 블록에서 예외가 일어나도 finally블록은 여전히 실행되어 파일 핸들을 닫는다.

__else 블록은 try 블록의 코드가 성공적으로 실행된 후 finally블록에서 공통 정리 코드를 실행하기 전에 추가 작업을 하는데 사용할수 있다__











```

import json

def load_json_key(data, key):
    try:
        result_dict = json.loads(data)  # May raise ValueError
    except ValueError as e:
        raise KeyError from e
    else:
        return result_dict[key]         # May raise KeyError

# JSON decode successful
assert load_json_key('{"foo": "bar"}', 'foo') == 'bar'
try:
    load_json_key('{"foo": "bar"}', 'does not exist')
    assert False
except KeyError:
    pass  # Expected

# JSON decode fails
try:
    load_json_key('{"foo": bad payload', 'foo')
    assert False
except KeyError:
    pass  # Expected


# Example 3
import json
UNDEFINED = object()

def divide_json(path):
    handle = open(path, 'r+')   # May raise IOError
    try:
        data = handle.read()    # May raise UnicodeDecodeError
        op = json.loads(data)   # May raise ValueError
        value = (
            op['numerator'] /
            op['denominator'])  # May raise ZeroDivisionError
    except ZeroDivisionError as e:
        return UNDEFINED
    else:
        op['result'] = value
        result = json.dumps(op)
        handle.seek(0)
        handle.write(result)    # May raise IOError
        return value
    finally:
        handle.close()          # Always runs

# Everything works
temp_path = 'random_data.json'
handle = open(temp_path, 'w')
handle.write('{"numerator": 1, "denominator": 10}')
handle.close()
assert divide_json(temp_path) == 0.1

# Divide by Zero error
handle = open(temp_path, 'w')
handle.write('{"numerator": 1, "denominator": 0}')
handle.close()
assert divide_json(temp_path) is UNDEFINED

# JSON decode error
handle = open(temp_path, 'w')
handle.write('{"numerator": 1 bad data')
handle.close()
try:
    divide_json(temp_path)
    assert False
except ValueError:
    pass  # Expected



```



# 출처

출처: https://freestrokes.tistory.com/71 [FREESTROKES DEVLOG]