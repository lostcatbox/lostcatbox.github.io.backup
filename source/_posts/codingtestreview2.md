---
title: (코테) 2렙 프로그래머스 리뷰노트
date: 2020-11-26 19:49:09
categories: [Coding]
tags: [Coding, Python]
---

# 문제풀이하면서 놓친부분들

- 완전 작은 경우, 완전 큰경우, 조금큰경우를 입력해서 알고리즘의 부족한 부분을 찾아내자
- 아이디어중 나누고 나머지, 몫을 이용하는 것이 꽤있다

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
# 5:45
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

```
1. 인쇄 대기목록의 가장 앞에 있는 문서(J)를 대기목록에서 꺼냅니다.
2. 나머지 인쇄 대기목록에서 J보다 중요도가 높은 문서가 한 개라도 존재하면 J를 대기목록의 가장 마지막에 넣습니다.
3. 그렇지 않으면 J를 인쇄합니다.
```

위에 규칙을 따라야한다. 

묻는 것은 내가 인쇄를 요청한 문서가 몇 번째로 인쇄되는 지를 return한다.

즉, 처음 목록 순서를 알고있고, 이를 1,2,3을 통해 최종 리스트를 만들면 된다.. 

최종 리스트를 만들때  list_x는  deque로 하면 leftpop() 이 훨씬 빨라질수있다.

## 계획

## 구현

## 리뷰

다른사람의 답안

```python
def solution(priorities, location):
    queue =  [(i,p) for i,p in enumerate(priorities)]
    answer = 0
    while True:
        cur = queue.pop(0)
        if any(cur[1] < q[1] for q in queue):
            queue.append(cur)
        else:
            answer += 1
            if cur[0] == location:
                return answer
```

> __any(iterableValue)__
>
> - 전달받은 자료형의 element중 하나라도 True일경우 True로 반환한다.
>
> - 내부로직
>
>   ```python
>   def any(iterable):
>     for element in iterable:
>       if element:
>         return True
>     return False
>   ```



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

좀더 빠르게풀기위해서는 모든 경우의 수를 써보자

# 멀쩡한 사각형

https://programmers.co.kr/learn/courses/30/lessons/62048

## 첫 답안

```python
def solution(w,h):
    sum=0
    func_y = lambda x:x*h/w
    for position_x in range(1,w):
        sum+=int(func_y(position_x))

    return sum*2
```

효율성 테스트를 통과하지 못하는 것이 종종 발생하였다.

## 재정의

## 계획

## 구현

## 리뷰

남들은 최대 공약수를 이용하였다

https://leedakyeong.tistory.com/entry/%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EC%8A%A4-%EB%A9%80%EC%A9%A1%ED%95%9C-%EC%82%AC%EA%B0%81%ED%98%95-in-python

# 다리를 지나는 트럭

https://programmers.co.kr/learn/courses/30/lessons/42583

## 첫 답안

```python
#2:55
from collections import deque

def solution(bridge_length, weight, truck_weights):
    loss_time =0
    
    depue_truck=deque(truck_weights)
    bridge_list= deque()
    while depue_truck:
        count_time=0

        if sum(bridge_list)<weight:
            bridge_list.append(depue_truck.popleft())
            loss_time+=1
        count_time+=1

        if count_time%bridge_length==0:
            count_time=0
            bridge_list.popleft()
    
    answer = len(truck_weights)*bridge_length+1-loss_time
    return answer

print(solution(100, 100, [10, 10, 10, 10, 10, 10, 10, 10, 10, 10]))
```

실패했다. 여러가지 문제점이보인다.

아이디어는 다리위에 겹치는 것이 있으면 그 겹쳤던 횟수만큼 오리지널 값에서 빼면 답이 나오는것이였다. 하지만 겹치는 횟수를 잘못 생각하였다.

## 재정의

FIFO인 큐 문제로 보인다.

큐 안에있는 총 트럭의 무게의 합은 항상 weight를 넘지 않아야하며, 한번들어오면 bridge_length초만큼 흘러야 큐를 나간다. 

최소 시간을 구하는법?

큐/스택 문제이다.

## 계획

## 구현

## 리뷰

[자세히](https://velog.io/@devjuun_s/%EB%8B%A4%EB%A6%AC%EB%A5%BC-%EC%A7%80%EB%82%98%EB%8A%94-%ED%8A%B8%EB%9F%AD-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EC%8A%A4)

```python
def solution(bridge_length, weight, truck_weights):
    time = 0
    q = [0] * bridge_length
    
    while q:
        time += 1
        q.pop(0)
        if truck_weights:
            if sum(q) + truck_weights[0] <= weight:
                q.append(truck_weights.pop(0))
            else:
                q.append(0)
    
    return time
```

남의 답지이다. FIFO를 이런식으로 구현하였다. q= [0,0,0] 으로 시작했다면, while문에서 시간이 지날때마다 leftpop()을 하고, 만약 이상태에서 기존 다리위에 숫자와 truck_weights[0]의 숫자의 합이  weight보다 작을경우 q.append로 추가해주고, 아니라면 0을 추가해준다. 이런식으로 q는 시간에 따라 [0,0,0]>>[0,0,버스무게]>>[0,버스무게,0]>>[버스무게,0,0]>> 자연스레 흘러갈것이다.

q에있는 모든것이 사라지면, 다 건넜다는것을 뜻

# 접두사 찾기 문제

왠지모르게 하나가 계속 오류였다..

```python
def solution(strs):
    answer = ""
    for j in range(len(strs[0])):
        for i in range(len(strs)):
            if i==0:
                befor_w=strs[i][j]
            elif befor_w==strs[i][j]:
                if i == len(strs)-1:
                    answer= answer+strs[i][j]
            else:
                return answer
    return answer
```

# 가장 높게 중고차 팔기

이 문제는 만점나왔다

prices는 리스트인데 중고차 가격이 나와있다. 단한번 매수, 매도할수있으며 최대이윤을 return 하면된다.

```python
def solution(prices):
    min_n=prices[0]
    max_n=prices[0]
    highest_n=0

    for x in prices:       
        if x < min_n:
            min_n=x
            max_n=0

        if x > max_n:
            max_n=x
            if highest_n<max_n-min_n:
                highest_n=max_n-min_n
    result=highest_n


    return result
```

# 시간 12시에서 24시로 바꾸기+ N초후에 24시간표시?

어떻게 접근해야할까?

# (Mysql 쿼리문제) 찾기

왜 안됫을까?



```mysql
SELECT date_format(CREATED_AT,'%m') as "월",count(*) as "결제 건수",sum(AMOUNT) as "사용 금액"
from CARD_USAGES
where CATEGORY=0 and "2018-06-01"<= CREATED_AT and CREATED_AT<="2018-12-31"
group by date_format(CREATED_AT,'%m');
```

# 기능 개발

## 첫 답안

```python
# 기능 개발
# 순서가 중요하고
# 나와야하는것의 처리일보다 작은애들은 같이 나온다고 보면됨
# 나와야하는것의 처리일보다 큰애들애서 다시 포인트

#그럼 일단 남은 일수 계산 딱나눠떨어지지않는다면 +1데이하기
#처리소요일수로 return 값 리스트만들기

def solution(progresses,speeds):
    answer=[]
    fin_answer=[0]
    u_progresses= [100-x for x in progresses]
    for i,p in enumerate(u_progresses):
        s=speeds[i]
        if p%s==0:
            answer.append(p//s)
        else:
            answer.append(p//s+1)

    before=answer[0]
    i=0
    for a in answer:
        if before>= a:
            fin_answer[i]+=1
        else:
            i+=1
            fin_answer.append(1)
            before=a
    return fin_answer


print(solution([93,30,55],[1,30,5]))
```

## 재정의



## 계획

## 구현

## 리뷰

내가 부족했던것은 동시에 for문을 돌릴떄 쓰는 zip()이라는 함수가 필요했다 다만 두 자료형의 길이가 같이야한다.

```python
def solution(progresses, speeds):
    Q=[]
    for p, s in zip(progresses, speeds):
        if len(Q)==0 or Q[-1][0]<-((p-100)//s):
            Q.append([-((p-100)//s),1])
        else:
            Q[-1][1]+=1
    return [q[1] for q in Q]
```

> `-((p-100)//s)` 를 쓴이유는 올림을 하기위해서다 몫을 추출핼때 음수는 내림해버림.

좀더 현실적인 코드는 다음과같다 time+=1이 매우 인상적이다. 

```python
def solution(progresses, speeds):
    print(progresses)
    print(speeds)
    answer = []
    time = 0
    count = 0
    while len(progresses)> 0:
        if (progresses[0] + time*speeds[0]) >= 100:
            progresses.pop(0)
            speeds.pop(0)
            count += 1
        else:
            if count > 0:
                answer.append(count)
                count = 0
            time += 1
    answer.append(count)
    return answer
```

# 삼각 달팽이(???)

https://programmers.co.kr/learn/courses/30/lessons/68645

## 첫 답안

풀지못했다

각 리스트 별로 규칙성을 찾으려했다

그래서 n=6이면 맨 바깥이 6,5,4 이며 나머지가 다시 같은 방식으로 3,2,1 이였다.

## 재정의

## 계획

## 구현

## 리뷰

[자세히](https://m.post.naver.com/viewer/postView.nhn?volumeNo=29530578&memberNo=33264526)

1. n*n 크기의 2d 리스트를 생성한다
2. 이중 for 문을 돌며, 삼각형 모양의 이동을 아래와 같이 정의했다
   - 나머지가 0인경우=y좌표 값만 1증가(아래로 이동)
   - 나머지가 1인 경우=x좌표값만 1 증가(오른쪽으로 이동)
   - 나머지가 2인 경우=y와 x좌표 모두 1감소(위로 이동)
3. chain으로 2d 리스트를 flatten한뒤, 0인 값을 전부 제거한다.

```python
from itertools import chain
def solution(n):
    maps = [[0 for _ in range(n)] for _ in range(n)] #정사각형 모양의 배열임
    y, x = -1, 0
    number = 1
    for i in range(n):
        for j in range(i, n):
            if i % 3 == 0:
                y += 1
            elif i % 3 == 1:
                x += 1
            elif i % 3 == 2:
                y -= 1; x -= 1
            maps[y][x] = number
            number += 1
    result = [i for i in chain(*maps) if i != 0] #0은 뺴주는과정도필요
    return result
```

문제를 해석해보면 결국 3가지 일을 반복적으로 처리함을 알수있다.

__일진행후 판단을 내려야할 부분의 로직을 짠다! 고 생각하면 다음에는 좀더 빠른접근이 가능할것이다__

아래로, 우로 ,대각선 위로 이것에서 힌트를 얻었다면 좋았을 것같다

> __chain(\*map)__
>
> chain은 이터레이터를 반환하는데, 매개변수들을 순서대로 경계없이 하나씩 반환하는 이터레이터
>
> *map을 언팩해서 전체리스트를 벗겨낸것을 반환한다.



# 문자열 압축

https://programmers.co.kr/learn/courses/30/lessons/60057

## 첫 답안

```python
#12:55
#(문자반복횟수)(해당문자), 1개는 1생략
#자르다가 마지막에 나머지는 그냥 써주면된다.
#반복단위는 전체길이/2 까지만 검증해주면된다.
#return 압축 문자열의 len값 최소값!
# "aabbaccc"	7
# "ababcdcdababcdcd"	9
# "abcabcdede"	8
# "abcabcabcabcdededededede"	14
# "xababcdcdababcdcd"	17

def solution(s):
    result=len(s)
    for split_n in range(1,len(s)//2+1):  #반만해보면됨
        list_x=[s[i:i+split_n] for i in range(0,len(s),split_n)]

        same=1
        count_s=[]
        print(list_x)
        for index in range(0,len(list_x)-1): #바로 직전까지 순환

            if index==len(list_x)-2:
                if list_x[index] == list_x[index+1]:
                    same+=1
                    count_s.append(same)
                    count_s.append(list_x[index])
                

                else:
                    count_s.append(same)
                    count_s.append(list_x[index])
                
                    same=1
                    count_s.append(same)
                    count_s.append(list_x[index+1])
                

                break

            if list_x[index] == list_x[index+1]:
                same+=1

            else:
                count_s.append(same)
                count_s.append(list_x[index])
                same=1

            
        count_s = "".join([str(x) for x in count_s if x!=1])
        if result>len(count_s):
            result=len(count_s)

    return result                       

print(solution("xxxxxxxxxxyyy"))
```

디버깅 정말 다른사람 실수 못봤으면 오래걸렸을뻔했다

처음에 짠코드들은 예제는 모두통과했는데 실전에서 문제가있었다.

`print(solution("xxxxxxxxxxyyy"))` 에 관해서 간과한것이있었다. str으로 count_s을 바로 계산해버리니까 10이 넘어가는것에 대해 처리를 제대로 하지못하였다. 따라서 count_s를 리스트로 바꾸고 나중에 1만빼주고 str으로 바꿔줘서 해결하였다.

## 재정의

## 계획

## 구현

## 리뷰

다음은 다른 사람이 짠 코드이다. 아름답다,.. zip() 쓸생각은했었는데.

원리는 같은것같다. 코드를 읽기좀 힘들다

```python
def compress(text, tok_len):
    words = [text[i:i+tok_len] for i in range(0, len(text), tok_len)]
    res = []
    cur_word = words[0]
    cur_cnt = 1
    for a, b in zip(words, words[1:] + ['']):
        if a == b:
            cur_cnt += 1
        else:
            res.append([cur_word, cur_cnt])
            cur_word = b
            cur_cnt = 1
    return sum(len(word) + (len(str(cnt)) if cnt > 1 else 0) for word, cnt in res)

def solution(text):
    return min(compress(text, tok_len) for tok_len in list(range(1, int(len(text)/2) + 1)) + [len(text)])
```

