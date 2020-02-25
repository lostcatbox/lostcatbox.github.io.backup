---
title: review-python-coding-skill02
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

## 리스트를 반환하는 대신 제너레이터를 고려하자







#### 중요한 참고 사항

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

```
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

