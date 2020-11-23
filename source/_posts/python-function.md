---
title: python 함수
date: 2020-11-04 15:16:41
categories: [Python]
tags: [Coding, Python, Basic]
---

__표기방법:__

- < >안에있는 것들은 반드시 들어가야하는 요소

- [ ]안에 있는 것들은 옵션

# 함수

## map

map은 반복가능한 객체의 요소를 지정된 함수로 처리해주는 함수입니다. 

iterable하면 수행가능

- `list(map(함수, 리스트))`
- `tuple(map(함수, 튜플))`

```python
a = [1.2, 2.5, 3.7, 4.6]
for i in range(len(a)):
     a[i] = int(a[i])

>>>a
[1, 2, 3, 4]
```

각 요소에 적용할 함수를 적용할수있다

```python
a = [1.2, 2.5, 3.7, 4.6]
a = list(map(int, a))

>>>a
[1, 2, 3, 4]
```

__\+ input().split() 과 map으로 활용해보자__

```python
a=input().split() #split을 적용하면 리턴값은 리스트, 입력은 10 20 으로했다고 가정

>>>a
["10", "20"]
```

map을 활용하면 간단히 정수로 반환가능하다

```python
a = map(int, input().split()) #10 20 입력


>>>a
<map object at 0x03DFB0D0> #map 객체가 만들어졌다 (맵 객체역시 iterable객체이다)
>>>list(a)
[10, 20]  #리스트로 출력

>>>print(list(map(int, "1 2 3".split())))
[1,2,3]
```

또한 맵 객체는 unpack을 지원한다

```python
b,c = a  #b,c에 각각 10, 20이 들어간다
```



## filter()

filter에 인자로 사용되는 function은 처리되는 각각의 요소에 대해 Boolean 값을 반환합니다. True를 반환하면 그 요소는 남게 되고, False 를 반환하면 그 요소는 제거 됩니다.

```python
foo = [2, 18, 9, 22, 17, 24, 8, 12, 27]
list(filter(lambda x: x % 3 == 0, foo))

[18, 9, 24, 12, 27]
```



## sys.stdin.readline()

[자세히](https://velog.io/@gouz7514/%ED%8C%8C%EC%9D%B4%EC%8D%AC-input-vs-sys.stdin.readline)

input()과의 차이점들을 정리하고, 다음 알고리즘 문제 풀때 시간을 줄일수있을것이라고 판단된다

input()은  사용자의 입력을 받고` → `문자열로 변환` → `추가 strip 진행의 과정을 거친다. (strip은 추가 개행(/n)에 대해서 일어난다)

__`sys.stdin.readline()`은 사용자의 입력을 받지만 개행 문자도 입력을 받을 수 있다.(`\n`도 포함된다)__

`input()`과 가장 큰 차이점은 `input()` 은 **내장 함수**s로 취급되는 반면 `sys` 에 속하는 메소드들은 **file object**로 취급된다. __즉, 사용자의 입력만을 받는 buffer를 하나 만들어 그 buffer에서 읽어들이는 것이다.__

`input()`은 더 이상 입력이 없는데도 수행될 경우EOFerror를 뱉어내는 반면 `sys.stdin.readline()`은 빈 문자열을 반환한다.

다음 예시를 해석해보자

(알고리즘문제에서 이것때문에 입력을 못받았다)

다음과 같이 입력되는 알고리즘 문제였다

```
2
6 3
1 2 3 1 2 3 
6 2 
1 2 3 1 2 3
```

풀이중 입력 다루는 코드

```python
import sys

case = int(sys.stdin.readline())
for i in range(case):
    n, l = map(int, sys.stdin.readline().split())  # n=대여일 수, l=공연팀 수
    borlist = list(map(int, sys.stdin.readline().split()))  # 대여비용 입력받음
```

`sys.stdin.readline()` 하면 2 /n까지 모두 가져가지만 int()로 둘려쌓여있으니... case=2 였다. 



## sorted()

정렬할때 많이 쓰는것 sort와 차이보기

 `<list>.sort()`를 하면 list객체 자체가 바껴버림(원본손실)

sorted()는 이와다르게 key를 기준으로 하여 정렬하고 __반환__합니다

- `sorted(<iterable>, key=lambda x:len(x))` 

  `key`로 함수를 후크, `reverse=True`를 넣어줄경우 내림차순 정렬

## reversed()

 `<list>.reverse()`를 하면 list객체 자체가 바껴버림(원본손실)

reversed()는 이와다르게 순서가 거꾸로 뒤집힌 리스트를 __반환__합니다

- `list(reversed(<list>))`





# 문법



## root()

```python
# root 쓰기
2**0.5
```

## lambda

[자세히](https://offbyone.tistory.com/73)

함수 자체를 임시적으로 간단하게 만들수있다

- `lambda 인수들:표현식(로직)`

람다 정의에는 return 문이 포함되어있지 않다. 

lambda 함수를 어떤 변수에 할당할 필요조차 없습니다. 즉각적으로 사용할 수 있고 더 이상 필요하지 않을 때 잊어 버릴 수 있습니다.

```python
>>> def inc(n):
      return lambda x: x + n

>>> f = inc(2)
>>> g = inc(4)
>>> print(f(12))
14

>>> print(g(12))
16

>>> print(inc(2)(12))
14
```

## list comprehension

[자세히](https://ychae-leah.tistory.com/48)

- 단일  for문

  ```python
  [i*2 for i in list1]
  ```

- 이중 for문

  ```python
  [i*j for j in list1 for i in list1]
  ```

- if 문 (else없다면) 뒤에적기

  ```python
  [i*j for j in list1  for i in list1 if i> 1]
  ```

- if 문 (else존재) 앞에적기

  ```python
  [i*j if i> 1 else 0 for j in list1 for i in list1]
  ```

  

# 자료형 특성

## Set

중복불가 셋은 순서가 없는 자료형이다.

즉, a~z, 1~ 이런식으로 나타난다.

index가없으므로 slice를 사용할수없다.

__set을 사용한다고 해서 자동으로 오름차순으로 정렬되지 않습니다. Python의 set은 BBST가 아니라 HashSet의 형태__

> 사용시 
>
> ```python
> s = {} #이것은 자동 dict 자료형으로 생성된다. set 아님
> s = {1,2,3} #이것은 set 자료형이다
> s = set() #이것도 가능하다
> ```

## List

### join

List를 특정 구분자를 포함해 문자열으로 반환

- `"<구분자>".join(<list>)`





## String

### split

문자열을 특정 "구분자"를 기준으로 리스트로 반환

- <리스트>.split("<구분자>")

### upper <>lower

upper는 문자열을 대문자로 

lower는 문자열을 소문자로

- <문자열>.upper()
- <문자열>.lower()

## Dict

```python
names={"rhdiddl":10010, "rhdiddl2":10202, "rhdiddl3":9999}

#  dict- value 기준으로 내림차순
sorted(names.items(), key=lambda x:x[1], reverse=True)
```









