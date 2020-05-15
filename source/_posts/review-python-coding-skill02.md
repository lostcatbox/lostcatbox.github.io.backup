---
title: 파이썬 코딩의 스킬 리뷰 2
date: 2020-02-23 19:15:33
categories: [Python]
tags: [Review, Tip, Skill]
---

# 2장 - 함수

함수는 큰 프로그램을 작고 단순한 조각으로 나눌 수 있게 해준다.

함수를 사용하면 가독성이 높아지고 코드를 더 이해하기 쉬워진다. 재사용 + 리팩토링까지 가능

파이썬에서 제공하는 함수들에는 다양한 부가 기능이 있다.

이러한 부가기능들은 함수의 목적을 분명하게 하고, 불필요한 요소 제거, 호출자의 의도를 보여주며, 찾기 어려운 버그를 줄여준다.

## None을 반환하기보다는 예외를 일으키자

파이썬 프로그래머들은 유틸리티 함수를 작성할 때 반환 값 None에 특별한 의미를 부여하는 경향이 있다.

```

# Example 1
def divide(a, b):
    try:
        return a / b
    except ZeroDivisionError:
        return None

assert divide(4, 2) == 2
assert divide(0, 1) == 0
assert divide(3, 6) == 0.5
assert divide(1, 0) == None # 분모로 0은 ZeroDivisionError가 남
```

그런데 분자가 0이 되어버리면 반환값도 0이 되어버린다

즉  __빈 문자열, 빈 리스트, 0이 모두 암시적으로 False로 인식__ 되어버린다.

오류인지 알아내려고 None 대신 실수로 False에 해당하는 값을 검사할 수 있다(???)

```
x, y = 0, 5   #x, y = 5,0 만 zerodivisionError로서 None받아서 not result의도함.
result = divide(x, y)
if not result:
    print('Invalid inputs')
  
```

위에 코드처럼 0/5도 0을 반환하면서 false취급되므로 Invalid inputs이 결과값이 되어버린다.

위에 예시는 None에 특별한 의미가 있을 떄 파이썬 코드에서 흔히 하는 실수다.

바로 이 상황이 함수에서 None을 반환하면 오류가 일어나기 쉬운 이유다.

다음 두가지 방법을 통해 이런 오류상황을 줄일수있다

- 첫 번쨰 방법은 반환 값을 두개로 나눠서 튜플에 담는 것이다.

  처음 파라미터에서 에서 작업을 성공했는지 알려주고, 두번째 파라미터에서 계산된 실제 결과를 반환한다.

  ```
  def divide(a, b):
      try:
          return True, a / b
      except ZeroDivisionError:
          return False, None
  ```

  이렇게 하면 분자가 0인 경우 True에 0값이 리턴된다.

  이 함수를 호출하는 쪽에서 튜플을 풀어야한다.!!!

  ```
  x, y = 5, 0
  success, result = divide(x, y)
  if not success:
      print('Invalid inputs')
  ```

  문제는 호출자가 (파이썬에서 사용하지 않을 변수에 붙이는 관례인 밎줄 변수 이름을 사용해서) 튜플의 첫 번째 파라미터의 첫 번째 부분을 쉽게 무시할 수 있다는 점이다

  얼핏 보기에는 괜찮아보이지만, 결과는 그냥 None을 반환하는 것만큼이나 나쁘다.

  ```
  x, y = 5, 0
  _, result = divide(x, y)
  if not result:
      print('Invalid inputs')  # This is right
      
  x, y = 0, 5
  _, result = divide(x, y)
  if not result:
      print('Invalid inputs')  
      
  # This is wrong, 결국 문제 또 발생 result가0이므로
  Invalid inputs
  ```

- 두 번째 방법은 절대로 None을 반환하지 않는 것이다

  대신 호출하는 쪽에 예외를 일으켜서 호출하는 쪽에서 그 예외를 처리하게 하는 것이다.

  여기서는 호출하는 쪽에 입력값이 잘못됏음을 알리려고 ZeroDivisionError를 ValueError로 변경하였다.

  ```
  def divide(a, b):
      try:
          return a / b
      except ZeroDivisionError as e:
          #오류메세지와, 에러명 변경
          raise ValueError('Invalid inputs') from e 
  ```

  이제 호출하는 쪽에서는 잘못된 입력에 대한 예외를 처리해야 한다.

  (이런 동작에 대해서는 "모든 함수, 클래스, 모듈에 docstring을 작성하자" 참고)

  호출하는 쪽에서 더는 함수의 반환값을 조건식으로 검사할 필요가 없다. 함수가 예외를 일으키지 않는다면 반환 값은 문제가 없다. 예외를 처리하는 코드 또한 깔끔해진다.

  ```
  x, y = 5, 2
  try:
      result = divide(x, y)
  except ValueError:  #divide함수에서 ZeroDivisionError발생시 ValueError로 뜸
      print('Invalid inputs')
  else:
      print('Result is %.1f' % result)
  ```

  __반드시 특별한 상황을 알릴 떄 None값을 반환하는 대신 예외를 읽으키자, 문서화 되어있다면 호출하는 코드에서 예외를 적절하게 처리할 것이다__

## 클로저가 변수 스코프와 상호 작용하는 방법을 알자(???)

숫자 리스트를 정렬할 때 특정 그룹의 숫자들이 먼저 오도록 우선순위를 매기려고 한다.

이런 패턴은 사용자 인터페이스를 표현하거나, 다른 것보다 중요한 메세지나 예외 이벤트를 먼저 보여줘야 할 떄 유용하다. 

이렇게 만드는 일반적인 방법은 리스트의  sort 메서드에 헬퍼 함수를 key 인수로 넘기는 것이다. 헬퍼의 반환 값은 리스트에  있는 각 아이템을 정렬하는 값으로 사용된다. 헬퍼는 주어진 아이템이 중요한 그룹에 있는지 확인하고 그에 따라 정렬 키를 다르게 할 수 있다.

```
def sort_priority(values, group):
    def helper(x):
        if x in group:  #x가 특정한 그룹에있다면
            return (0, x)
        return (1, x)
    values.sort(key=helper)
```



```
numbers = [8, 3, 1, 2, 5, 4, 7, 6]
group = {2, 3, 5, 7}
sort_priority(numbers, group)
print(numbers)
```

솔직히 아무것도 이해못해서 "아래와 중요한 참고 사항" 다시 정리했다.

함수가 예상대로 동작한 이유는 세 가지다.

- 파이썬은 클로저(closure)를 지원하다. 클로저란 자신이 정의된 범위(스코프)에 있던 변수를 참조하는 함수다. 바로  이 점 덕분에 helper 함수가 sort_priority의 group인수에 접근할 수 있다.(??? 함수안에 함수에서 안에있는 함수가 변수를 쓸수있다는이야기???)
- __함수는 파이썬에서 일급 객체(first-class object)다. 이 말은 함수를 직접 참조하고, 변수에 할당하고, 다른 함수의 인수로 전달하고, 표현식과 if 문 등에서 비교할 수 있다는 의미다.__ 따라서 sort 메서드에서 클로저 함수를 key인수로 받을 수 있다
- 파이썬에서 튜플을 비교하는 특정한 규칙이 있다. 먼저 인덱스 0으로 아이템을 비교하고 그 다음으로 인덱스 1, 다음은 인덱스 2와 같이 진행한다. helper 클로저의 반환 값이 정렬 순서를 분리된 두 그룹으로 나뉘게 한 건이 규칙 떄문이다. (여기서 말하는 인덱스는 튜플 안에 왼쪽부터 인덱스 0라고 부르는듯.)

함수에서 우선순위가 높은 아이템을 발견했는지 여부를 반환해서 사용자 인터페이스 코드가 그에 따라 동작하게 하면 좋을 것이다.

이런 동작을 추가하는 일은 쉬워 보인다. 이미 각 숫자가 어느 그룹에 포함되어 있는지 판별하는 클로저 함수가있다.

우선순위가 높은 아이템을 발견했을때 플래그(아래 예시에서 found객체)를 뒤집는 데도 클로저(현재 자신이 정의된 범위(스코프)에 있던 변수를 참조하는 해서 변경역할하는 함수임)를 사용하는 건 어떨까? 그러면 함수는 클로저가 수정한 플래그 값을 반환할 수 있다.

```
def sort_priority2(numbers, group):
    found = False #플래그
    def helper(x): #클로저
        if x in group:
            found = True  # Seems simple #클로저의 역할
            return (0, x)
        return (1, x)
    numbers.sort(key=helper)
    return found
```

사용해보자

```
found = sort_priority2(numbers, group)
print('Found:', found)
print(numbers)


Found: False
[2, 3, 3, 4, 1, 6, 7, 8]
```

__왜 found값이 false가 나와버렸을까?__

__표현식에서 변수를 참조할 때__ 파이썬 인터프리터는 참조를 해결하려고 다음과 같은 수서로 유효 범위(scope)를 탐색한다.

1. 현재 함수의 스코프
2. (현재 스코프를 담고있는 다른 함수 같은) 감싸고 있는 스코프
3. 코드를 포함하고 있는 모듈의 스코프(전역 스코프라고도함)
4. (len이나 str 같은 함수를 담고 있는) 내장 스코프

이 주 어느 스코프에도 참조한 이름으로 된 변수가 정의되어 있지 않으면 NameError 예외가 일어난다

__변수에 값을 할당할 때__는 다른 방식으로 동작한다. 변수가 이미 현재 스코프에 정의되어 있다면 새로운 값을 얻는다

__파이썬은 변수가 현재 스코프에 존재하지 않으면 변수 정의로 취급한다. __

__새로 정의되는 변수의 스코프는 그 할당을 포함하고 있는 함수가 된다.__

__(즉, 새로 정의된 변수는 정의되었던 스코프밖을 나가지못함, 지금은 found=True가 helper함수 밖을 나가지 못함 )__

즉, sort_priority2함수의 반환 값이 잘못된이유는 found변수는 helper 클로저에서 True로 할당되도록 설계하려고 햇으나, 실제로 클로저 할당은 sort_priority2에서  일어나느 할당이 아닌 helper함수아 안ㅇ데서 일어나는 새 변수 정의가 되어버렸기때문이다.

이런 점은 초보자들을 놀라게한다. ('스코프 버그'라고함)

하지만 이 동작은 함수의 지역 변수가 자신을 포함하는 모듈을 오염시키는 문제를 막아준다. 그렇지 않았다면 함수 안에서 일어나는 모든 할당이 전역 모듈 스코프에 쓰레기를 넣는 결과로 이어졌을 것이다.

그렇게 되면 불필요한 할당에 그치지 않고 결과로 만들어지는 전역 변수들의 상호 작용으로 알기 힘든 버그가 생긴다.

### 데이터 얻어오기

파이썬 3에는 클로저에서 >>> 데이터를 얻어오는 특별한 문법이 있다. nonlocal문은 특정 변수 이름에 할당할 때 __스코프 탐색이 일어나야 함을 나타낸다. __(이렇게 하면 탐색후 할당)

유일한 제약은 nonlocal이 (전역 변수 오염 피하려고) 모듈 수준 스코프까지는 탐색할 수 없다는 점이다.

다음은 nonlocal을 사용하여 같은 함수를 다시 정의한 예다.

(nonlocal문을 사용하여 클로저를 감싸는 스코프의 변수를 수정할 수있음을 알린다.)

```
def sort_priority3(numbers, group):
    found = False
    def helper(x):
        nonlocal found
        if x in group:
            found = True  #nonlocal이라고 알려줬기때문에 탐색 먼저진행 후 값 바뀜
            return (0, x)
        return (1, x)
    numbers.sort(key=helper)
    return found
    
    
found = sort_priority3(numbers, group)
print('Found:', found)
print(numbers)

```

nonlocal 문은 클로저에서 데이터를 다른 스코프에 할당하는 시점을 알아보기 쉽게 해준다.

nonlocal문은 변수 할당이 모듈 스코프에 직접 들어가게 하는 global문을 보안한다(모듈 스코프는안됨.)

__하지만 전역 변수의 안티패턴(anti-pattern)과 마찬가지로 간단한 함수 이외에는 nonlocal을 사용하지 않도록 주의해야 한다. nonlocal의 부작용은 알아내니가 상당히 어렵다.__

특히 nonlocal문과 관련 변수에 대한 할당이 멀리 떨어진 긴 함수에서는 이해하기가 더욱 어렵다

nonlocal을 사용할 때 복잡해지기 시작하면 헬퍼 클래스로 상태를 감싸는 방법을 이용하는 게 낫다.

이제 nonlocal을 사용할 때와 같은 결과를 얻는 클래스를 정의해 보자

코드는 약간 더 길지만 이해하기는 훨씬 쉽다("인터페이스가 간단하면 클래스 대신 함수를 받자"에서 \_\_call\_\_ 이라는 특별한 메서를 자세히 설명한다.) (???)

```
class Sorter(object):
    def __init__(self, group):
        self.group = group
        self.found = False

    def __call__(self, x):
        if x in self.group:
            self.found = True
            return (0, x)
        return (1, x)

sorter = Sorter(group)
numbers.sort(key=sorter)
assert sorter.found is True
print('Found:', found)
print(numbers)
```

### 파이썬2의 스코프

nonlocal지원안함.. pass

found = [False]로 줘서 수정가능한 helper함수안에 found[0] = Ture를 하면 탐색이 일어나므로 변경은 가능....

### 중요한 참고 사항

[클로저 자세히](https://yes90.tistory.com/50)

#### list 본체 정렬

- reverse : 리스트를 거꾸로 뒤집는다. desc 정렬이 아님

```
>>> a = [1, 10, 5, 7, 6]
>>> a.reverse()
>>> a
[6, 7, 5, 10, 1]
```

- sort : 정렬, 기본값은 오름차순 정렬, reverse옵션 True는 내림차순 정렬

```python
>>> a = [1, 10, 5, 7, 6]
>>> a.sort()
>>> a
[1, 5, 6, 7, 10]
>>> a = [1, 10, 5, 7, 6]
>>> a.sort(reverse=True)
>>> a
[10, 7, 6, 5, 1]
```

- __sort의 key 옵션, key 옵션에 지정된 함수의 결과에따라 정렬, 아래는 원소의 길이__

```
>>> m = '나는 파이썬을 잘하고 싶다'
>>> m = m.split()
>>> m
['나는', '파이썬을', '잘하고', '싶다']
>>> m.sort(key=len)
>>> m
['나는', '싶다', '잘하고', '파이썬을']
```

#### list 정렬된 결과 반환

- 정렬된 결과를 반환하는 함수는 본체는 변형하지 않습니다.
- sorted : 순서대로 정렬, 정렬된 리스트를 반환

```
>>> x = [1 ,11, 2, 3]
>>> y = sorted(x)
>>> x
[1, 11, 2, 3]
>>> y
[1, 2, 3, 11]
```

- reversed : 거꾸로 뒤집기, iterable한 객체를 반환, 확인을 위해서는 list로 한번 더 변형 필요

```
>>> x = [1 ,11, 2, 3]
>>> y = reversed(x)
>>> x
[1, 11, 2, 3]
>>> y
<list_reverseiterator object at 0x1060c9fd0>
>>> list(y)
[3, 2, 11, 1]
```



## 리스트를 반환하는 대신 제너레이터를 고려하자(B16)

> 일련의 결과를 생성하는 함수에서 택할 가장 간단한 방법은 아이템의 리스트를 반환하는 것이다. 

예를 들어 문자열에 있는 모든 단어의 인덱스를 출력하고 싶다(띄어쓰기를 기준으로 나누면됨)

다음 코드에서 append 메서드로 리스트에 결과들을 누적하고 함수가 끝날 때 해당 리스트를 반환한다.

```python
def index_words(text):
    result = []
    if text:
        result.append(0)
    for index, letter in enumerate(text):
        if letter == ' ':
            result.append(index + 1)
    return result
```

샘플 입력이 몇 개뿐일 때는 함수가 기대한 대로 동작한다.

```python
address = 'Four score and seven years ago our fathers brought forth on this continent a new nation, conceived in liberty, and dedicated to the proposition that all men are created equal.'
result = index_words(address)
print(result[:3])


[0, 5, 11]

```

하지만 index_words 함수에는 두 가지 문제가 있다.

- 첫 번째 문제는 코드가 약간 복잡하고 깔끔하지 않다는 것이다. 새로운 결과가 나올 때마다 append 메서드를 호출해야 한다. 메서드 호출(result.append)이 많아서 리스트에 가하는 값(index+1)이 덜 중요해 보인다. 결과 리스트를 생성하는 데 한 줄이 필요하고, 그 값을 반환하는 데도 한 줄이 필요하다. 함수 몸체에 문자가 130개 가량(공백 제외)있지만 그중에서 중요한 문자는 약 75개다

  이 함수를 작성하는 더 좋은 방법은 제너레이터(generator)를 사용하는것이다

  

  __제너레이터는 yield 표현식을 사용하는 함수다.__ 

  __제너레이터 함수는 호출되면 실제로 실행하지 않고 바로 이터레이터(iterator)를 반환한다. __

  __내장 함수 next를 호출할 때마다 이터레이터는 제너레이터가 다음 yield 표현식으로 진행하게 한다.__
  
   제너레이터에서 yield에 전달한 값을 이터레이터가 호출하는 쪽으로 반환한다.
  
  동일결과를 내는 제너레이터 함수
  
  ```python
  def index_words_iter(text):
      if text:
          yield 0
      for index, letter in enumerate(text):
          if letter == ' ':
              yield index + 1
              
  my_result = index_words_iter("고양이 최고 귀엽다") #1
  print my_result # 호출안되고 누군가 값을 물어보기를 기다리는 대기상태 #1
print next(my_result) #이때 호출됨
  
  
  <generator object index_words_iter at 0x10c4aa7d0>
  0
  ```
  
  제너레이터는 자신이 리턴할 모든 값을 메모리에 저장하지 않기 때문에 조금 전 일반 함수의 결과와 같이 한번에 리스트로 보이지 않는 것입니다. __제너레이터는 한 번 호출될때마다 하나의 값만을 전달(yield)합니다.__ 즉, 위의 #1까지는 아직 아무런 계산을 하지 않고 누군가가 다음 값에 대해서 물어보기를 기다리고 있는 상태입니다.
  
  
  
  결과 리스트와 연동하는 부분이 사라져서 훨씬 이해하기 쉽다. 결과는 리스트가 아닌 yield 표현식으로 전달된다.
  
  제너레이터 호출로 반환되는 이터레이터를 내장 함수 list에 전달하면 손쉽게 리스트로 변환할 수 있다.(B9 참조)
  
  ```python
  myresult=list(index_words_iter('rhdiddlsms 최고다 rhddd'))
  ```

- 두번째 문제는

  반환하기 전에 모든 결과를 리스트에 저장해야한다는 점이다. 입력이 매우 많다면 프로그램 실행 중에 메모리가 고갈되어 동작을 멈추는 원인이 된다. 반면 __제너레이터로 작성한 버전은 다양한 길이의 입력에도 쉽게 이용가능__

다른 예시로 또 차이를 보자

아래 함수는 파일에서 입력을 한 번에 한 줄씩 읽어서 한 번에 한 단어씩 출력을 내어주는 제너레이터다. 이 함수가 동작할 때 사용하는 메모리는 입력 한 줄의 최대 길이까지다.

```
def index_file(handle):
    offset = 0
    for line in handle:
        if line:
            yield offset
        for letter in line:
            offset += 1
            if letter == ' ':
                yield offset
                


from itertools import islice
with open ('파일경로/rhdiddl.txt', 'r') as f:
    re=islice(index_file(f),0,3)              
    print(list(re))
    
>>>
[0, 11, 15]

```

> islice는 이터레이너 객체가 반환하는 제너레이터를 처음(0), 마지막(3)으로  슬라이스침
>
> 이터레이터는 반복가능한 객체를 말한다(next()가 가능한 객체)
>
> 제너레이터(반복가능한 객체를 만들어주는 행위)
>
> yield(제너레이터에서의 return과 동일한 역할을 수행,, )

이와 같이 제너레이터를 정의할 때 알아둬야 할 단 하나는 반환되는 이터레이터에 상태가 있고 재사용할 수 없다는 사실을 호출하는 쪽에서 알아야 한다는 점이다(B17 참조)

### 정리

- 제너레이터에서 반환한 이터레이터는 제너레이터 함수의 본문에 있는 yield 표현식에 전달된 값들의 집합이다.(???)
- 제너레이터는 모든 입력과 출력을 메모리에 저장하지 않으므로 입력값의 양을 알기 어려울 때도 연속된 출력을 만들 수 있다.

## 인수를 순회할 때는 방어적으로 하자(B17) (???)

파라미터로 객체의 리스트를 받는 함수에서 리스트를 여러 번 순회해야 할 때가 종종있다.

예를 들어 미국 텍사스주의 여행자 수를 분석하자

데이터 집합은 각 도시의 방문자수라고 하자

각 도시에서 전체 여행자 중 몇 퍼센트를 받아들이는지 알고 싶을 것이다

이런 작업을 하려면 정규화 함수가 필요하다. 정규화 함수에서는 입력을 합산해서 연도별 총 여행자 수를 구한다.

그러고 나서 각 도시의 방문자 수를 전체 방문자 수로 나누어 각 도시가 전체에서 차지하는 비중을 알아낸다.

```
def normalize(numbers):
    total = sum(numbers)  #여기서도 numbers호출
    result = []
    for value in numbers:   #여기서도 numbers호출
        percent = 100 * value / total
        result.append(percent)
    return result
```

방문 리스트를 확대하려면 모든 도시가 들어 있는 파일에서 데이터를 읽어야한다.

모든 데이터의 리스트를 메모리에 넣는건 무리..

나중에 같은 함수를 재사용하여 더 큰 데이터 세트인 전 세계의 여행자 수를 계산할 수 있기 때문에 리스트보다 제너레이터로구현한다

```
def read_visits(data_path):
    with open(data_path) as f:
        for line in f:
            yield int(line)
```

```
it = read_visits('my_numbers.txt')
percentages = normalize(it)
print(percentages)
```

위 함수를 해보면 안된다. 그 이유는 이터레이터가 결과를 한 번만 생성하기 때문이다

이미 StopIteration 예외를 일으킨 이터레이터나 제너레이터를 순회하면 어떤 결과도 얻을수없다. 아래 참조하자

```
it = read_visits('my_numbers.txt')
print(list(it))   #정상 데이터리스트
print(list(it))  #결과는 빈 리스트가 나와버림
```

이를 해결하려면 입력 이터레이터를 명시적으로 소진하고 전체 콘텐츠의 복사본을 리스트에 저장해야 한다.

(없어지는 값을 일단 복사)

```python
def normalize_copy(numbers):
    numbers = list(numbers)  # Copy the iterator
    total = sum(numbers)
    result = []
    for value in numbers:
        percent = 100 * value / total
        result.append(percent)
    return result
```

이 방법의 문제점은 입력받은 이터레이터 콘텐츠의 복사본이 클 수도 있다는 점이다

이런 이터레이터를 복사하면 프로그램의 메모리가 고갈되어 동작을 멈출 수도있다.

이런 문제를 피하는 한가지 방법은 호출될 떄마다 새 이터레이터를 반환하는 함수를 받게 만드는 것이다

```python
def normalize_func(get_iter):
    total = sum(get_iter())   # New iterator
    result = []
    for value in get_iter():  # New iterator 
        percent = 100 * value / total
        result.append(percent)
    return result
```

`normalize_func` 을 사용하려면 제너레이터를 호출해서 매번 새 이터레이터를 생성하는 람다 표현식을 넘겨주면 된다.

(위에 나왔던방식은 이터레이터가 한번만 소모될수있었으므로 안됬으니까 이렇게 함수안에서 호출을 두번 새롭게 해주면된다.)

```python
percentages = normalize_func(lambda: read_visits(path)) 
#lambda로 임시 함수를 만들었으니까 normalize_func안에서는 호출해야됨 그게 get_iter() 에서  ()가 붙은이유
print(percentages)
```

코드가 잘 동작하긴 하지만, 이렇게 람다 함수를 넘겨주는 방법은 세련되지 못하다. 같은 결과를 얻는 더 좋은 방법은 이터레이터 프로토콜을 구현한 새 컨테이너 클래스를 제공하는 것이다.

이터레이터 프로토콜은 파이썬의 for 루프와 관련 표현식이 컨테이너 타입의 콘텐츠를 탐색하는 방법을 나타낸다

파이썬은 `for x in foo`  같은 문장을 만나면 실제로는 iter(foo)를 호출한다. 그러면 내장 함수 iter는 특별한 메서드인 foo.\_\_iter\_\_ 를 호출한다.  \_\_iter\_\_ 메서드는 (\_\_next\_\_ 라는 특별한 메서드를 구현하는) 이터레이터 객체를 반환해야 한다. 마지막으로 for 루프는 이터레이터를 모두 소진할 때까지 (그래서 StopIteration 예외가 발생할 때까지) 이터레이터 객체에 내장 함수 `next` 를 계속 호출한다. [자세히](https://dojang.io/mod/page/view.php?id=2406)

```
#__iter__ 써보자
class Counter:
    def __init__(self, stop):
        self.current = 0    # 현재 숫자 유지, 0부터 지정된 숫자 직전까지 반복
        self.stop = stop    # 반복을 끝낼 숫자
 
    def __iter__(self):
        return self         # 현재 인스턴스를 반환
 
    def __next__(self):
        if self.current < self.stop:    # 현재 숫자가 반복을 끝낼 숫자보다 작을 때
            r = self.current            # 반환할 숫자를 변수에 저장
            self.current += 1           # 현재 숫자를 1 증가시킴
            return r                    # 숫자를 반환
        else:                           # 현재 숫자가 반복을 끝낼 숫자보다 크거나 같을 때
            raise StopIteration         # 예외 발생
 
for i in Counter(3): 
    print(i, end=' ')
###아래 내용은 추측.
# __init__는 클래스 객체 생성할때.
# __iter__는 for문에서 iter(x)를 처음에 호출하므로 이때 메서드가 호출된다. 즉 이때 반환되는 객체가 이터레이터(돌수있는것)이여야한다.
# __next__는 for문에서 루프는 __next__를 호출하면서 
```



복잡해 보이지만 사실 클래스의 \_\_iter\_\_ 메서드를 제너레이터로 구현하면 이렇게 동작을 만들 수 있다.

다음은 여행자 데이터를 담은 파일을 읽는 이터러블(iterable:순회가능)컨테이너 클래스다

```
class ReadVisits(object):  #object는 필요없지안나???
    def __init__(self, data_path):
        self.data_path = data_path
    def __iter__(self):
        with open(self.data_path) as f:
            for line in f:
                yield int(line)
```

새로 정의한 컨테이너 타입은 원래의 함수에 수정을 가하지 않고 넘겨도 제대로 동작한다.

```
visits = ReadVisits("rhdiddl.txt")
percentages = normalize(visits)
print(percentages)
```

normalize를 쓸수있는 이유는 normalize의 sum메서드가 새 이터레이터 객체를 할당하려고 ReadVisits.\_\_iter\_\_ 를 호출하기때문이다. (새 이터레이터 만듬)

또한 숫자를 정규화하는 for 루프도 두 번째 이터레이터 객체를 할당할때 \_\_iter\_\_ 를 호출한다. 따라서 두 이터레이터는 독립적으로 동작하므로 각각의 순회 과정에서 모든 입력 데이터 값을 얻을 수 있다. 이 방법의 유일한 단점은 입력 데이터를 여러번 읽는다는 점이다

이제 ReadVisits와 같은 컨테이너의 작동방법을 안다.

파라미터가 단순한 이터레이터가 아님을 보장하는 함수를 작성할 차례다.

프로토콜에 따르면 내장 함수 iter에 이터레이터를 넘기면 이터레이터 자체가 반환된다. 반면 iter에 컨테이너 타입을 넘기면 매번 새 이터레이터 객체가 반환된다. 따라서 이 동작으로 입력값을 테스트해서 이터레이터면 TypeError를 일으켜 거부하게 만들면 된다.

```
def normalize_defensive(numbers):
    if iter(numbers) is iter(numbers):  # 이터레이터 거부
        raise TypeError('Must supply a container')
    total = sum(numbers)
    result = []
    for value in numbers:
        percent = 100 * value / total
        result.append(percent)
    return result
```

normalize_defensive는 normalize_copy처럼 입력 이터레이터 전체를 복사하고 싶지 앉지만, 입력 데이터를 여러번 순회해야 할 때, 사용하면 좋다. 이 함수는 list와 ReadVisits를 입력으로 받으면 입력이 컨테이너이므로 기대한 대로 동작한다. 이터레이터 프로토콜을 따르면 어떤 컨테이너 타입에 대해서도 제대로 동작할 것이다.

```
visits = [15, 35, 80]
normalize_defensive(visits)  # No error
visits = ReadVisits(path)
normalize_defensive(visits)  # No error
```

하지만 입력이 이터러블이어도 컨테이너가 아니면 예외를 일으킨다

>  이 함수를 사용할때 그냥 이터레이터가 들어오면 순환하지 못하므로 그것을 방지하기위해 if절로 구별함

```
it = iter(visits)
normalize_defensive(it)

>>>
TypeError
```



### 정리

- 입력 인수를 여러번 순회하는 함수를 작성할 때 주의하자. 입력인수가 이터레이터라면 이상하게 동작(한번만 호출되고 사라지므로)해서 값 잃어버림
- 파이썬의 이터레이터 프로토콜은 컨테이너와 이터레이터가 내장함수 iter, next와 for 루프 및 관련 표현식과 상호작용하는 방법을 정의한다
-  \_\_iter\_\_ 메서드를 제너레이터로 구현하면 자신만의 이터러블 컨테이너 타입을 쉽게 정의할 수있다
- 어떤 값에 iter를 두번 호출했을때 같은 결과(위치까지같고, 변한게없음)가 나오고 내장 함수 next로 전진시킬 수 있다면 그 값은 컨테이너가 아닌 이터레이터다.

## 가변 위치 인수로 깜끔하게 보이게 하자(B18)

선택적인 위치 인수(이런 파라미터의 이름을 보통 *arg라 한다. 'star args'라고도함)를 받게 만들면 함수 호출을 더 명확하게 할 수 있고 보기에 방해가 되는 요소를 없앨 수 있다.

예를 들어 디버그 정보 몇 개를 로그남기자. 인수의 개수가 고정되어 있다면 메시지와 값 리스트를 받는 함수를 구현

```python
def log(message, values):
    if not values:
        print(message)
    else:
        values_str = ', '.join(str(x) for x in values)
        print('%s: %s' % (message, values_str))

log('My numbers are', [1, 2])
log('Hi there', [])
```

로그로 남길 값이 없을 때 빈 리스트를 넘겨야 한다는 것은 불편함.

두 번 째 인수를 아예 남겨주면 좋을 것이다. 파이썬에서의 *기호를 마지막 위치 파라미터 이름 앞에 붙이면된다.

로그 메세지(log함수의 message인수)를 의미하는 첫 번째 파라미터는 필수지만, 다음의 나오는 위치 인수는 몇개든 선택적이다. 

```python
def log(message, *values):
    if not values:
        print(message)
    else:
      
        values_str = ', '.join(str(x) for x in values)
        print('%s: %s' % (message, values_str))
        
log('My numbers are', 1, 2) #여기서 중간에 values를 보면 튜플로 가져오는것을 볼수있다(1,2)
log('Hi there')  #훨씬 간결함

#아래처럼 실행하면 리스트 풀리고 튜플로 다시 묶여서 진행하는것확인
favorites = [7, 33, 99]
log('Favorite colors', *favorites)

```

가변 개수의 위치 인수를 받는 방법에는 두 가지 문제가 있다

첫번째는 가변 인수가 함수에 전달되기에 앞서 항상 튜플로 변환된다는 점이다.

이는 함수를 호출하는 쪽에서 제너레이터에 *연상자를 쓰면 제너레이터가 모두 소진될 떄까지 순회됨을 의미한다. 결과로 만들어지는 튜플은 제너레이터로부터 생성된 모든 값을 담으므로 메모리를 많이 차지해서 프로그램 망가짐.

```python
def my_generator():
    for i in range(10):
        yield i

def my_func(*args):
    print(args)

it = my_generator()
my_func(*it)
```

*arg를 받는 함수는 인수 리스트에 있는 입력의 수가 적당히 적다는 사실을 아는 상황에서 가장 좋은 방법이다. 이런 함수는 많은 리터럴이나 변수 이름을 한꺼번에 넘기는 함수 호출에 이상적이다. 개발자들을 편하게하고 가독성 높임

두 번째는 추후에 호출 코드를 모두 변경하지 않고서는 새 위치 인수를 추가할 수 없다는 것이다. 인수 리스트의 앞쪽에 위치 인수를 추가하면 기존의 호출 코드가 수정 없이는 이상하게 동작함(사용법까지 바꿔야함)

```python
#앞에 sequence인수추가
def log(sequence, message, *values):  
    if not values:
        print('%s: %s' % (sequence, message))
    else:
        values_str = ', '.join(str(x) for x in values)
        print('%s: %s: %s' % (sequence, message, values_str))

log(1, 'Favorites', 7, 33)      # New usage is OK
log('Favorite numbers', 7, 33)  # Old usage breaks
```

이 코드의 문제는 두 번째 호출이 sequence인수를 받지 못했기때문에 7을 message파라미터로 사용해버렸다. 이런 버그는 예외를 발생시키지 않으면 찾기 매우 어렵다. 완전히 없애려면 \*arg를 받는 함수를 확장할 때 키워드 전용(\*krewg)인수를 사용해야한다(B21참조)

### 정리

- def문에서 \*arg사용시 가변 개수의 위치 인수를 받을수있다
- 제너레이터와 \*연산자를 같이 사용시 메모리 부족으로 프로그램망가짐가능
- \*args를 받는 함수에 새 위치 파라미터를 추가하면 찾기 어려운 버그생성가능

## 키워드 인수로 선택적인 동작을 제공하자 (B19)

대부분의 프로그래밍 언어처럼 파이썬에서도 함수를 호출시 인수를 위치로 전달할 수 있다.

```python
def remainder(number, divisor):
    return number % divisor

assert remainder(20, 7) == 6
```

파이썬 함수의 위치 인수를 모두 키워드로 전달도 가능하다. 이때 인수의 이름을 함수 호출의 광호 안에 있는 할당문에서 사용한다.

```python
remainder(20, 7)
remainder(20, divisor=7)
remainder(number=20, divisor=7) #키워드 인수로 전달됨.
remainder(divisor=7, number=20)
```

위치 인수는 반드시 키워드 인수 앞에서 먼저 지정되어야한다

````python
remainder(number=20,2) #말도안되는짓
````

키워드 인수의 유연성은 세 가지 중요한 이점이 있다.

첫번째는 코드를 보는 사람이 함수 호출을 명확하게 이해할수있다

두번째는 함수를 정의할 때 기본값을 설정할수있다.(덕분에 다들 기본값써서 간결하게 호출가능)

아래와 같이 period값을 호출시 주어지지않아도 함수는 동작할수있다.

```python
def flow_rate(weight_diff, time_diff, period=1):
    return (weight_diff / time_diff) * period
```

동적 기본 인수를 지정하려면 (B20참조)

세번째는 기존의 호출 코드와 호환성을 유지하면서도 함수의 파라미터를 확장할 수 있는 강력한 수단이 된다는 점이다.(*args와 큰 차이)

> 이러면 반대로 인수들이 깔끔해보이지 않는데 더 좋은 방법으로 키워드 전용 인수를 활용하자(B21참조)

### 정리

- 함수의 인수를 위치나 키워드로 지정가능
- 위치 인수만으로는 이해하기 어려울때 키워드쓰면 목적명확
- 키워드 인수에 기본값을 지정하면 호출이 쉬워짐
- 선택적인 키워드 인수는 항상 위치가 아닌 키워드로 넘겨야 한다

## 동적 기본 인수를 지정하려면 None과 docstring을 이용하자(B20)

키워드 인수의 기본값으로 비정적타입을 사용해야 할 때가 있다.

예를 들어 이벤트 발생시각까지 포함해 로깅 메세지를 출력한다고하자

```python
from time import sleep
from datetime import datetime

def log(message, when=datetime.now()):
    print('%s: %s' % (when, message))

log('Hi there!')
sleep(0.1)
log('Hi again!')

```

위 코드에 문제는 datetime.now는 함수를 정의할 때 딱 한번만 실행되므로 타임스탬프가 동일하게 출력된다. 기본 인수의값은 모듈이 로드될 때 한 번만 평가되며 프로그램 시작시 일어난다. 모듈이 로드된후 그때 딱 한번만 평가되고 기본 인수인 datetime.now를 다시 평가하지 않는다. 

파이썬에서 우리가 기대한 결과가 나오게 하려면 기본값을 None으로 설정하고 docstring(문서화 문자열)으로 실제 동작을 문서화하는 게 관례다 (B49참조)

코드에서 인수 값으로 None이 나타나면 알맞는 기본값을 할당하면 된다

```python
from time import sleep
from datetime import datetime
def log(message, when=None):
    """Log a message with a timestamp.

    Args:
        message: Message to print.
        when: datetime of when the message occurred.
            Defaults to the present time.
    """
    when = datetime.now() if when is None else when
    print('%s: %s' % (when, message))
```

기본 인수 값으로 None을 사용하는 방법은 인수가 수정가능(mutable)할 때 특히 중요하다.

예를 들어 JSON데이터로 인코드된 값을 로드한다고 해보자. 데이터 디코딩이 실패하면 기본값으로 빈 딕셔너리를 반환하려고 한다.

```python
import json

def decode(data, default={}):
    try:
        return json.loads(data)
    except ValueError:
        return default
```

위의 코드에는 datetime.now 예제와 같은 문제가 있다. 기본 인수 값은 (모듈이 로드될 때) 딱 한번만 평가되므로, 기본값으로 설정한 딕셔너리를 모든 decode 호출에서 공유한다. 이 문제가 나타는 오류를 보자

```python
foo = decode('bad data')
foo['stuff'] = 5
bar = decode('also bad')
bar['meep'] = 1
print('Foo:', foo)
print('Bar:', bar)
assert foo is bar
```

아마 각각 단일 키와 값을 담은 서로 다른 딕셔너리 두 개를 예상했을 것이다.

하지만 하나를 수정하면 다른 하나도 수정되는 것처럼 보인다. 이런 문제의 원인은 foo와 bar 둘다 기본 파라미터와 같다는 점이다. 즉, 이 둘은 같은 딕셔너리 객체이다.

```python
assert foo is bar
```

키워드 인수의 기본값을 None으로 설정하고 함수의 docstring에 동작을 문서화해서 이 문제를 고친다.

```python
def decode(data, default=None):
    """Load JSON data from a string.

    Args:
        data: JSON data to decode.
        default: Value to return if decoding fails.
            Defaults to an empty dictionary.
    """
    if default is None:
        default = {}
    try:
        return json.loads(data)
    except ValueError:
        return default
```

위에 코드를 보면 알수있는것은 default=None이 모듈 로딩 때 객체 하나의 객체가됨. 그래서 decode(data, 1)이렇게 입력하면 1을 default=1이 그때 메모리에 할당하고, decode(data)를 하면 default=None으로 함수호출됨(메모리에 없음).

```python
foo = decode('bad data')
foo['stuff'] = 5
bar = decode('also bad')
bar['meep'] = 1
print('Foo:', foo)
print('Bar:', bar)
```

### 정리

- 기본 인수는 모듈 로드 시점에 함수 정의 과정에서 딱 한번만 평가된다. 따라서 {},[]같은 동적 값에는 이상하게 작동가능
- 값이 동적인 키워드 인수에는 기본값으로 None을 사용하자. 그러고 나서 함수의 docstring에 실제 기본 동작을 문서화하자

## 키워드 전용 인수로 명료성을 강요하자 (B21)

키워드로 인수를 넘기는 방법은 파이썬 함수의 강력한 기능이다 (B19 참조)

이 덕분에 쓰임새가 분명한 코드를 작성가능

예를 들어 어떤 숫자를 다른 숫자를 나눈다고 해보자. 하지만 특별한 경우를 매우 주의해야한다. 때로는 ZeroDivisionError예외를 무시하고 무한대 값을 반환하고 싶을 수 있다. 어떨 때는 OverflowError예외를 무시하고 0을 반환하고 싶을수있다.

```python
def safe_division(number, divisor, ignore_overflow,
                  ignore_zero_division):
    try:
        return number / divisor
    except OverflowError: #산술 연산의 결과가 너무 커서 표현할 수 없을 때 발생합니다. 
        if ignore_overflow:
            return 0
        else:
            raise
    except ZeroDivisionError: #영으로 나눌때 에러
        if ignore_zero_division:
            return float('inf')  #float는 소수점 존재 숫자, float('inf')는 양의 무한대를 나타내는 데이터를 나타내는법
        else:
            raise
```

위의 함수 사용은 함수 호출은 나눗셈에서 일어나는 float오버플로우를 무시하고 0을 반환한다.

```python
result = safe_division(1.0, 10**500, True, False)
print(result)
assert result is 0

result = safe_division(1.0, 0, False, True)
print(result)
assert result == float('inf')
```

각각의 예시를 실행하면 assert가 뜨지않는다

문제는 예외 무시 동작을 제어하는 두 불 인수의 위치를 혼동하기 쉽다. 따라서 키워드 인수를 사용하자.(가독성도 높아짐)

```python
def safe_division_b(number, divisor, ignore_overflow=False,
                  ignore_zero_division=False):
  #...
```

````python
safe_division_b(1.0, 10**500, ignore_overflow=True)
````

위처럼 위치상관없이, 선택적인 동작이라서 함수를 호출하는 쪽에 키워드 인수로 의도를 명확하게 드러내라고 강요할 방법이 없다는점이 문제이다. 여전히 위치 인수로도 사용이 가능하기때문이다.

이처럼 복잡한 함수를 작성할 때는 호출하는 쪽에서 의도를 명확히 드러내는 인수를 넘기도록 요구하는 것이 좋다.

__파이썬3에서는 키워드 전용 인수로 함수를 정의해서 의도를 명확히 드러내도록 요구할수있다.(키워드 전용 인수는 키워드로만 넘길 뿐, 위치로는 절대 넘길 수 없다)__

다음은 키워드 전용 인수로 safe_division_c 함수를 다시 정의한 버전이다. __인수 리스트에 있는 `*` 기호는 위치 인수의 끝과 키워드 전용 인수의 시작을 가르킨다.__

```python
def safe_division_c(number, divisor, *,
                    ignore_overflow=False,
                    ignore_zero_division=False):
    try:
        return number / divisor
    except OverflowError:
        if ignore_overflow:
            return 0
        else:
            raise
    except ZeroDivisionError:
        if ignore_zero_division:
            return float('inf')
        else:
            raise
```

이제 키워드 인수가 아닌 위치 인수를 사용하는 함수 호출은 동작못한다

```python
safe_division_c(1.0, 10**500, ignore_overflow=True)

>>>
TypeError: safe_division_c() takes 2 positional arguments but 4 were given
```

### 파이썬 2의 키워드 전용 인수

인수 리스트에 `**` 연산자를 사용해 올바르지 않은 함수 호출을 할 때 TypeError를 일으키는 방법으로 같은 동작을 만들 수 있다. 가변 개수의 위치 인수 대신에 키어드 인수를 몇 개든 받을수있다는 점만 빼면  `**` 연산자는 `*` 연산자와 비슷하다(B 18 참조 )

```python
def print_args(*args, **kwargs):
    print ('Positional:', args)
    print ('Keyword:', kwargs)

print_args(1, 2, foo='bar', stuff='meep')

>>> 
Positional: (1, 2)
Keyword: {'foo': 'bar', 'stuff': 'meep'}
```

파이썬2에서는 safe_division이 **kwargs를 받게 만들어서 키워드 전용 인수를 받게 한다. 그런 다음 pop메서드로 kwargs딕셔너리에서 원하는 키워드 인수를 꺼낸다. 키가 없을 때의 기본값은 pop메서드의 두번째 인수로 지정한다. 마지막으로 kwargs에 더는 남아 있는 키워드가 없을을 환이하여 호출하는 쪽에서 올바르지 않는 인수를 넘기지 않게 한다.

```python
def safe_division_d(number, divisor, **kwargs):
    ignore_overflow = kwargs.pop('ignore_overflow', False)
    ignore_zero_div = kwargs.pop('ignore_zero_division', False)
    if kwargs:
        raise TypeError('Unexpected **kwargs: %r' % kwargs)
    try:
        return number / divisor
    except OverflowError:
        if ignore_overflow:
            return 0
        else:
            raise
    except ZeroDivisionError:
        if ignore_zero_div:
            return float('inf')
        else:
            raise

assert safe_division_d(1.0, 10) == 0.1
assert safe_division_d(1.0, 0, ignore_zero_division=True) == float('inf')
assert safe_division_d(1.0, 10**500, ignore_overflow=True) is 0
```

이렇 구성하면 키워드 인수를 위로 넘기려 하면 파이썬 3와 마찬가지로 제대로 동작하지 않습니다.

### 정리

- 키워드 인수는 함수 호출의 의도를 더 명확하게 해준다
- 불 플래그를 여러 개 받는 함수처럼 햇갈리기 휘운 함수는 키워드 전용 인수를 사용하자
- 파이썬 3는 함수의 키워드 전용 인수 문법을 명시적으로 지원한다
- 파이썬 2에선 **kwargs를 사용하고 TypeError에외를 직접 일으키는 방법으로 함수의 키워드 전용 인수를 흉내 낼수있다







