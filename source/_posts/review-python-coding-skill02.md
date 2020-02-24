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

## 클로저가 변수 스코프와 상호 작용하는 방법을 알자



