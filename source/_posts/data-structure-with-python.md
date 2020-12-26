---
title: 자료구조 공부 (파이썬활용)
date: 2020-12-26 17:01:20
categories: [Coding]
tags: [Coding, Python,Basic]
---

# 왜?

코테를 풀다보니 자연스레 자료구조를 알맞게 활용할수록, 

코드 테스트에서 효율과 정확도가 뛰어난 상승을 경험하고 필요성을 느껴, 공부하게됬다.

어떤 문제를 만났을때, 알맞은 자료구조를 한번에 찾으면 얼마나 기분 좋을까?

# 자료구조

[자세히](https://blog.yena.io/studynote/2018/11/14/Algorithm-Basic.html)

![스크린샷 2020-12-26 오후 5.37.55](https://tva1.sinaimg.cn/large/0081Kckwgy1gm1ci1f3t9j30zu0rk0yr.jpg)

**자료**의 조직, 관리, 저장을 의미한다. 더 정확히 말해, **데이터 사이의 관계를 반영한 저장구조 및 그 조작 방법을 뜻한다.** 

이중 알고리즘 문제에 자주 활용되는것은 

- 선형 자료구조 : 한 종류의 데이터가 선처럼 길게 나열된 자료구조.
- 비선형 자료구조 : 선형 자료구조가 아닌 모든 자료구조. i 번째 값을 탐색한 뒤의 i+1이 정해지지 않은 구조.

# 큐/스택

[자세히](https://devuna.tistory.com/22)

## 큐

First In First Out

아래가 뚫린 바구니에 위로 요소를 넣고 아래로 뺀다

줄을 서서 기다리는 것을 생각하면된다.

스택과 다르게 정해진 한쪽에서 삽입, 삭제가 아닌 한쪽은 삽입, 한쪽은 삭제 작업을 한다.

- 큐의 가장 첫 원소를 front, 삭제연산만 수행되는 곳
- 가장 끝 원소를 rear,  삽입연산만 이루어지는 곳
- 큐는 들어올 때 rear로 들어오지만 나올때는 front부터 빠지는 특성
- 큐의 리어에서 이루어지는 삽입연산을 **인큐 (enQueue)**
- 프론트에서 이루어지는 삭제연산을 **디큐 (dnQueue)**

![스크린샷 2020-12-26 오후 5.25.18](https://tva1.sinaimg.cn/large/0081Kckwgy1gm1c4uybm5j31060fatdl.jpg)

__절대로 리스트로 구현하지말자__

리스트 같은경우 leftpop()을 한다면 모든 요소의 메모리의 인덱스값을 한칸씩 당기고있다..비효율적

deque를 사용한다면, CPython으로 구현되어있어서 위와같은 O(n)의 시간복잡도를 피할수있다.

```python
from collections import deque
que= deque()
que.append(0)
que.append(1)
que.append(2)
que.popleft()
print(que)
```



## 스택

Last In First Out

아래가 막힌 바구니에 위로 요소를 넣고 위로 요소를 뺀다

정해진 방향으로만 쌓을수있다.

~~스택이 넘치면 stack overflow, 없다면 stack underflow~~

### 예시

- 웹 브라우저 방문기록 (뒤로 가기) : 가장 나중에 열린 페이지부터 다시 보여준다.
- 역순 문자열 만들기 : 가장 나중에 입력된 문자부터 출력한다
- 실행 취소 (undo) : 가장 나중에 실행된 것부터 실행을 취소한다.
- 후위 표기법 계산
- 수식의 괄호 검사 (연산자 우선순위 표현을 위한 괄호 검사)

```python
# 스택을 활용할때는 그냥 리스트를 활용하자
stack = []
stack.append(1)
stack.pop()
```





