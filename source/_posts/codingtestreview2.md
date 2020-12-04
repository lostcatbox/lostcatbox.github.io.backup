---
title: (코테) 2렙 프로그래머스 리뷰노트
date: 2020-11-26 19:49:09
categories: [Coding]
tags: [Coding, Python]
---

# 원칙

첫 번째 풀고 답안지를 업로드하고 리뷰후

분석

두번째 답안지 작성(남의 것)

> 분석의 단계
>
> 1. 문제를 읽고 이해한다.
>
>    (문제의 궁극적인 목적+사소한 제약 조건 모두이해)
>
> 2. 문제를 익숙한 용어로 재정의한다
>
>    (재정의:내가아는 용어로 변경, 추상화: 문제의 본질만 남겨놓고 축약)
>
> 3. __어떻게 해결할지 계획을 세운다__
>
>    어떻게 해결할지 계획(알고리즘, 자료 구조 선택).. 곧장 안떠오르는 경우 무식하게 풀기 시작
>
>    > - 비슷한 문제를 풀어본적있나?
>    >
>    > - 단순한 방법으로 시작가능?
>    >
>    >   (가장 단순한 알고리즘 만드는것)(시도후 개선)
>    >
>    > - __예제의 문제 푸는 과정을 그대로 따라가서 수식화 가능?__
>    >
>    >   반드시 로직으로 끝까지 따라가보기
>    >
>    > - 문제를 단순화 못할까? 문제의 제약 조건없애보기, 다차원 1차원으로 줄여표현
>    >
>    > - 그림 그려볼수있을까?
>    >
>    > - 문제를 분해 할수있을까? 한개의 복잡한 조건보다 여러 개의 단순한 조건이 다루기 쉽다
>    >
>    >   (A==B)==>(A>=B and A<=B )
>    >
>    > - 뒤에서부터 생각해서 문제풀수있어? A>>B로풀이를반대로
>    >
>    > - 순서를 강제해서 풀수있을까? 1번부터 내가 시작강제
>    >
>    > - 내가 아는 문제 유형 그룹에있나?
>
>    
>
> 4. 계획을 검증한다.
>
>    설계한 알고리즘이 모든 경우에 요구 조건에 정확히 수행하는지 증명하기(키보드x)
>
> 5. 프로그램으로 구현한다
>
>    >- 적극적으로 코드 재사용(같은 코드 세번이상? 헬퍼함수로빼)
>    >- 표준 라이브러리 공부하기(내가 직접짜지말고 표준 쓰자)
>    >- 항상 같은 형태로 프로그램 작성(같은 유형 내가 쓰는 코드 유형쓰기)
>    >- 일관적인 명명법 사용(`def isInsideCircle` 좌표가 원안에있다는 `True` 반환하는함수 명확함)
>    >- 코드와 데이터 분리하기
>
>    
>
> 6. __어떻게 풀었는지 돌아보고, 개선할 방법이 있는지 찾아본다__
>
>    실력이 올라가는 단계
>
>    문제 한번만 풀면 내것이 아니다
>
>    2번째 풀면서 더 효율적인 알고리즘을 찾거나 간결한코드작성, 같은 알고리즘을 유도하는 직관적인 방법 탐색, 자신이 문제 해결 기술을 어떻게 사용하는지 개선해야함
>
>    __문제 해결 과정을 기록해놓는것이 중요__

> __문제를 풀지 못할때?__
>
> 초보때는 일정 시간이 지나고 안풀리면 다른사람의 소스 코드 풀이참조 원칙!
>
> __나는 왜 이 풀이를 떠올리지 못했는가? 내 접근이 틀렸나? 해답찾기__
>
> 당연히 처음보는 기술, 접근은 어렵지만 지속적사용이 실력 업

# 구성

## 첫 답안

## 재정의

## 계획

## 구현

## 리뷰

# 프린트

https://programmers.co.kr/learn/courses/30/lessons/42587

## 첫 답안

```python
def solution(priorities, location):
    list_x=[(i,x) for i,x in enumerate(priorities)]
    final_list =[]
    
    while list_x:
        numbers=[n[1] for n in list_x]
        if  list_x[0][1]<max(numbers):
            list_x.append(list_x[0])
            list_x.pop(0)
        else:
            final_list.append(list_x[0])
            list_x.pop(0)
                    
    for i in range(len(final_list)):
        if final_list[i][0]==location:
            return i+1
```

## 재정의

## 계획

## 구현

## 리뷰

# 124 나라의 숫자

https://programmers.co.kr/learn/courses/30/lessons/12899

## 첫 답안

3진법을 이용한다는것은 알았느데 결국 못품

## 재정의

## 계획

## 구현

```python
def solution(num):
    answer = ""
    while num:
        num, nam = divmod(num, 3)  #몫 나머지 반환
        answer = "412"[nam] + answer
        if not nam:
            num -= 1
            
    return answer
```

## 리뷰

[참조](https://itholic.github.io/kata-124-world/)

3진법은 기본적으로 생각은 했지만 여기에서 0을 4로 바꾸고 자릿수하나를 줄인다! 라는 생각을하는것이 부족했다.

# 주식가격

https://programmers.co.kr/learn/courses/30/lessons/42584

## 첫 답안

```python
# 19:14
def solution(prices):
    answer = [0]*len(prices)
    for i in range(len(prices)):
        for j in prices[i+1:len(prices)]:
            answer[i]+=1
            if prices[i]>j:
                break
    return answer
```

효율성이 큐보다 훨씬 나쁘다. 예제가 좀만 더 빡세면 통과못한 코드 O(N^2)

리뷰 코드보다 3배더 느림

## 재정의

## 계획

## 구현

## 리뷰

각 시간대별 주식가격이 떨어지지 않은 기간이 몇 초인지를 구하는 문제다. 간단한 스택/큐 문제로 큐를 이용하면 쉽게 문제를 풀 수 있다.

prices 리스트를 큐로 바꿔 pop해주고, 큐 리스트에 남아있는 요소들과 하나씩 비교 한다.

이 때 가격이 떨어지지 않은 기간을 answer 리스트에 넣어줘야 하기 때문에 몇 초인지를 나타내는 변수에 값을 1씩 늘려준다. 가격이 떨어졌을 경우 반복문을 종료하고 최종적인 기간을 answer 리스트에 추가해주면 끝난다.

아래는 코드 전문이다. 

```python
from collections import deque

def solution(prices):
    answer = []
    que_prices = deque(prices)
    
    while que_prices :
        price = que_prices.popleft()
        up_time = 0
        for n in que_prices :
            up_time += 1
            if price > n :
                break
        answer.append(up_time)
        
    return answer
```

que_prices라는 큐를 만들어주고 popleft()를 이용하여 좌측요소를 빼주고 up_time은 가격이 떨어지지 않은 기간을 나타내는 변수다.

똑같은 O(N^2)이다

## 속도 차이 이유

slice는 costly operation이다. 왜냐면 기존 list를 복사하고, 새로 만들기 때문이다.

deque는 the start of the list pointer and "forgets" the oldest item이다

이것은 사소한차이지만 효율성 테스트에서는 엄청 차이가 심하다.

> python에서 큐/스택을 활용해야하는 이유 (속도차이)
>
> python에서 `list.pop(0)` 실행시 맨앞에 있는 요소를 빼고 나머지를 모든 데이터를 한칸씩 앞으로 당기는 작업이 수반된다. 즉 시간복잡도가 O(N)이다.
>
> 하지만 `from collection import deque` 사용한다면 CPython으로 구현되어있기 때문에 퍼포먼스 차이가 심하게난다.

> 추가적으로 중요한점은 python list는 동적 배열이라는것이다
>
> 필요에 따라 크기가 변하는 배열, 크기를 알아서 조절한다.
>
> ```python
> def append(A, value):
>    if A.capacity == A.n: #만약 A의 용량이 가득 차게 되면
>       allocate a new list B with larger memory and
>       update B.capacity and B.n
>       #B라는 새로운 리스트를 생성한다(단, B's capacity > A's capacity)
>       for i in range(n): 
>          B[i] = A[i] #새로운 리스트 B에다가 A를 싹 옮긴다
>       dispose A #용량이 넘 작은 옛날 리스트 A는 버린다
>       A = B #B리스트의 이름을 A로 변경한다
> ```
>
> resize된다면, 결국 O(N)이되어 수행시간이 늘어날수밖에없다.

# 스킬트리

https://programmers.co.kr/learn/courses/30/lessons/49993

## 첫 답안

```python
#50분 걸림
def solution(skill, skill_trees):
    count=0
    for tree in skill_trees:
        iter_skill=list(skill)
        for spell in list(tree):
                if spell in list(skill):
                    if not spell == iter_skill.pop(0):
                        break
                        
                if spell == list(tree)[-1]:
                    count+=1
                    print(tree)
                    break
    return count
```

## 재정의

skill에있는 순서대로 skill_tree가 나와야하며,  skill의 적혀있지않은 다른 알파벳들은 순서와 상관없다

이떄 skill을 지킨 스킬트리 갯수 리턴

## 계획

2가지 경우가 나올수있다고 생각했다

skill트리에 해당하는 것이 나왔을때와 skill트리에 해당하지 않는것이 나왔을때를 생각했다.

skill트리 나왔을때

- 현재 해당해야하는 알파벳과 맞지 않으면 break

skill트리 안나왔을때

- 마지막 문자라면 앞에  break문이 안일어난것이니까 count+=1함

## 구현

## 리뷰

남의 답지

```python
def solution(skill, skill_trees):
    answer = 0

    for skills in skill_trees:
        skill_list = list(skill)

        for s in skills:
            if s in skill:
                if s != skill_list.pop(0):
                    break
        else:
            answer += 1

    return answer
```

for else 문은 와...for가 끝까지 돌면 이터레이터 에러가뜨고 그럼 else문이 실행된다. 즉, 마지막까지 정상적으로  for문이 돌았다면 else문을 실행할수있는것이다. 중간에break걸린다면 else문은 실행되지않는다.

아름답다

__접근은 비슷했다__

하지만 내 코드가 구려보인다.

순서와 정확히 안맞으면 break걸고 나머지는 모두 answer+=1이라는 생각을 못했다.

하지만 list.pop(0)는 전에 문제처럼 효율성문제는 항상 생각하자

