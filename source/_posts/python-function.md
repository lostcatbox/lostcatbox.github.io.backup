---
title: python 함수
date: 2020-11-04 15:16:41
categories: [Python]
tags: [Coding, Python, Basic]
---

# map

 map은 반복가능한 객체의 요소를 지정된 함수로 처리해주는 함수입니다. iterable하면 수행가능

- **list(map(함수, 리스트))**
- **tuple(map(함수, 튜플))**

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
```

또한 맵 객체는 unpack을 지원한다

```python
b,c = a  #b,c에 각각 10, 20이 들어간다
```

# sys.stdin.readline()

[자세히](https://velog.io/@gouz7514/%ED%8C%8C%EC%9D%B4%EC%8D%AC-input-vs-sys.stdin.readline)

input()과의 차이점들을 정리하고, 다음 알고리즘 문제 풀때 시간을 줄일수있을것이라고 판단된다

input()은  사용자의 입력을 받고` → `문자열로 변환` → `추가 strip 진행의 과정을 거친다. (strip은 추가 개행(/n)에 대해서 일어난다)

__`sys.stdin.readline()`은 사용자의 입력을 받지만 개행 문자도 입력을 받을 수 있다.__

`input()`과 가장 큰 차이점은 `input()` 은 **내장 함수**로 취급되는 반면 `sys` 에 속하는 메소드들은 **file object**로 취급된다. __즉, 사용자의 입력만을 받는 buffer를 하나 만들어 그 buffer에서 읽어들이는 것이다.__

`input()`은 더 이상 입력이 없는데도 수행될 경우 EOFerror를 뱉어내는 반면 `sys.stdin.readline()`은 빈 문자열을 반환한다.

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

