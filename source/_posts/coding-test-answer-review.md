---
title: [코테] 1렙 프로그래머스 리뷰노트
date: 2020-10-30 17:53:00
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
>    > - 예제의 문제 푸는 과정을 그대로 따라가서 수식화 가능?
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

# 페스티벌 문제

https://algospot.com/judge/problem/read/FESTIVAL

내 1차 코드

```python
# 이전 답지
class Logic():
    def __init__(self, for_count, L_score):
        self.for_count = for_count
        self.L_score = L_score

    def function(self):
        n = 0
        result_list = []
        while not self.for_count == 1:  # 4시작 l_score 3시작
            target_list = rent_cost_list[n:n + self.L_score]
            self.for_count -= 1
            n += 1
            print(target_list)
            result_list.append(sum(target_list) / len(target_list))
        return min(result_list)


def check_answer(for_count, L_score):
    before_result = Logic(for_count, L_score).function()  # 4,3
    while True:  # 다음과정은 
        for_count -= 1
        L_score += 1
        after_result = Logic(for_count, L_score).function()
        if before_result < after_result:
            print(before_result)
            break
        else:
            before_result = after_result  # before을 after로 업데이트
            pass


case_count = int(input("전체 케이스"))

rent_cost_list = []
for x in range(case_count):
    input_score = input("공연장으 대여할수있는 날N +L").split(" ")
    N_score, L_score = int(input_score[0]), int(input_score[1])

    # L이상의 공연을 진행해야함
    input_list = input("날짜별로 대여 비용")
    rent_cost_list2 = input_list.split(" ")
    print(rent_cost_list2)
    for x in rent_cost_list2:
        y = int(x)
        rent_cost_list.append(y)
    print(rent_cost_list)

    for_count = N_score - L_score + 1  # 돌아야하는 나눠서 횟수 

    check_answer(for_count, L_score)
```

완전 잘못되었다. 접근법이 메모리를 너무 많이 잡아먹고, 비효율적이다

다른접근법을 생각해보자면 시작점을 for문으로 돌면서 시작점으로부터 L만큼 합의 평균과과 그 다음값을 비교하면서 다음값보다 평균이 크다면 확장하는 방식으로 해결해야될거같다.

```python
import sys

lr = lambda: sys.stdin.readline()

event_cnt = int(lr())

for event in range(event_cnt):

    day_cnt, team_cnt = map(int, lr().split())
    day_pay = [int(x) for x in lr().split()]

    avgs = []

    for i in range(day_cnt-team_cnt+1):
        pay_sum = sum(day_pay[i:i+team_cnt])
        avgs.append(pay_sum/team_cnt)

        for t in range(day_cnt-i-team_cnt):
            pay_sum+=day_pay[i+team_cnt+t]
            avgs.append(pay_sum/(team_cnt+t+1))
    result = min(avgs)
    print("%.11f" % result)
```

완벽히 풀었다.

아이디어는 결국 같을수밖에없었다

하지만 위에 문제점들을 해결할수있는 키를 생각했고 결론에 도달했다는 것에 의미를 갖는다.

모든 경우의 수를 계산할수있으면서, 효율적으로 코드를 업데이트하였다

다음에는 좀더 깔끔한 코드를 짤수있게 노력하자.

# 두 개 뽑아서 더하기

[문제](https://programmers.co.kr/learn/courses/30/lessons/68644)

## 첫 답안

```python
listx =[]
def solution(numbers):
    for x in range(len(numbers)):
        num_x=numbers[x]
        sum =0
        for y in range(x+1,len(numbers)):
            num_y=numbers[y]
            sum = num_x+num_y
            if not sum in listx:
                listx.append(sum)
    answer=sorted(listx)
    
    print(answer)
    return answer
```

## 재정의

numbers의 길이는 2이상 100이하이고, numbers의 모든 수는 0이상 100이하이다. 중복이 없이 2개를 뽑아 조합이 가능한 수를 나열한 리스트를 반환하면된다.

## 계획

완전 탐색 이용, for문 안에 for문을 사용해서 모든 조합을 탐색하여, 조합을 set()에다가 넣는다면 중복방지를 구현할수있다. 순서가 없는 자료형이므로 인덱스, slice를 사용하지못한다. 마지막으로 sorted()로 감싸준다. 오름차순!

## 구현

```python
def solution(numbers):
    set_x=set()
    for x in range(len(numbers)):
        for y in range(x+1,len(numbers)):
            set_x.add(numbers[x]+numbers[y]) #set에다 바로박음    
    return sorted(list(set_x)) #마지막 리턴은 리스트여야하므로
```

## 리뷰

다른 사람들을 보면 list_x=[]를 먼저 사용하고 마지막 최종 답을 return 할떄 sorted(list(set(list_x)))를 하였다. 이 문제말고 다른 문제들은 인덱스를 활용해야할수있으므로 바로 set을 활용하는거보다 리스트로 활용후 최종적으로 잠깐 set활용하는것이 더 나은 방법이다.

> set을 사용한다고 해서 자동으로 오름차순으로 정렬되지 않습니다. Python의 set은 BBST가 아니라 HashSet의 형태

# 크레인 인형뽑기 게임

[문제](https://programmers.co.kr/learn/courses/30/lessons/64061)

## 첫 답안

```python
def solution(board, moves):
    basket=[]
    count=0
    for crane in moves:
        for i in board:
            if not i[crane-1] ==0:
                basket.append(i[crane-1])
                i[crane-1]=0  #꺼낸후 0으로 초기화
                break
        if len(basket)>1:
            if basket[-1]==basket[-2]:
                count+=2
                del basket[-1]
                del basket[-1]
            
    return count
```

## 재정의



NxN크기의 박스에서 바구니에 옮기는것.

가장 아래칸부터 차곡차곡 쌓어있는 인형.

바구니에서 두개의 인형이 겹치면 터지고 없어짐

박스에 크레인이 내려가는 곳에 아무런 인형이 없다면 아무일도 일어나지않음

__주어진 매개변수__

board는 박스 내부, 숫자의 의미는 인형의 종류의미

moves는 크레인 픽업 위치

__예시__

| board                                                        | moves             | result |
| ------------------------------------------------------------ | ----------------- | ------ |
| [[0,0,0,0,0],[0,0,1,0,3],[0,2,5,0,1],[4,2,4,4,2],[3,5,1,3,1]] | [1,5,3,5,1,2,1,4] | 4      |

박스는 2차원배열로 생각하고, 크레인 좌표가 들어가며, 터트려 사라진 인형을 반환하면된다. 

## 계획

2차원배열에서 인형을 뽑고,  board는 첫번째 행부터 마지막행까지 행기준으로 나타내고있다. 크레인은 같은 열에 가장  위있는 것을 가져오면서 그것을 0으로 대체시킴. 

바구니에 쌓이면서 같은것이 있으면 터지는 것을 구현해야함. 매번 담을 때 검사하면 변수없다.

## 구현

올바른 답안이였다.

스택을 활용한 알고리즘이므로..

`del list[i]`  보다는 `list.pop(i)` 를 선호하도록하자

## 리뷰



# 완주하지 못한 선수

[문제](https://programmers.co.kr/learn/courses/30/lessons/42576)

## 첫 답안

```python
def solution(participant, completion):
    sort_participant = sorted(participant)
    sort_completion = sorted(completion)
    for i in range(len(sort_completion)):
        if sort_participant[i] != sort_completion[i]:
            return sort_participant[i]
    return sort_participant[-1]
```

## 재정의

A 와 B리스트에서 겹치는 이름도 존재하며, A는  존재하고 B에는존재하지 않는 이름을 찾으면 된다

## 계획

 정렬후에 만약  다른것이 나타난다면,리턴하면되지않을까?

하나만다르기때문에  A를 기준으로 돌다가 인덱스가 A와 B가 틀리면 그 위치에 A를 반환하면될것이다

## 구현

```python
import collections


def solution(participant, completion):
    answer = collections.Counter(participant) - collections.Counter(completion)
    return list(answer.keys())[0]
```

## 리뷰

collections.Counter 모듈을 써서 간단히 아래처럼  요소들을 count할수있었다.

```python
Counter({'leo': 1, 'kiki': 1, 'eden': 1})
Counter({'eden': 1, 'kiki': 1})
Counter({'leo': 1})
```

# 모의고사

https://programmers.co.kr/learn/courses/30/lessons/42840

## 첫 답안

```python
import math

def solution(answers):
    count_person1,count_person2, count_person3 =0,0,0
    len_answers = len(answers)
    person1_answers = [1,2,3,4,5]*math.ceil(len(answers)/5)
    person2_answers = [2,1,2,3,2,4,2,5]*math.ceil(len(answers)/8)
    person3_answers = [3,3,1,1,2,2,4,4,5,5]*math.ceil(len(answers)/10)
    for x in range(len(answers)):
        if person1_answers[x] == answers[x]:
            count_person1 +=1
    for x in range(len(answers)):
        if person2_answers[x] == answers[x]:
            count_person2 +=1
            
    for x in range(len(answers)):
        if person3_answers[x] == answers[x]:
            count_person3 +=1
    count_result_list=[count_person1,count_person2,count_person3]
    m = max(count_result_list)
    result = [i+1 for i, j in enumerate(count_result_list) if j == m]
    
    return result
```

## 재정의

수포자는 패턴을 반복하고

answer와 비교하여 몇개를 맞췄는지보고 높은 사람을 반환한다(1,2,3이라는 사람)

동점이라면 오름차순 반환

## 계획

## 구현

```python
from itertools import cycle

def solution(answers):
    giveups = [
        cycle([1,2,3,4,5]),
        cycle([2,1,2,3,2,4,2,5]),
        cycle([3,3,1,1,2,2,4,4,5,5]),
    ]
    scores = [0, 0, 0]
    for num in answers:
        for i in range(3):
            if next(giveups[i]) == num:
                scores[i] += 1
    highest = max(scores)

    return [i + 1 for i, v in enumerate(scores) if v == highest]
```

답안을 참조했다. cycle은 이터레이터를 반환한다. next()를 활용해서 계속 번호가 순환할수있다.

## 리뷰

`from iterloop import cycle`에 꼭 주목하자

패턴을 generator로 처리하여 가독성, 공간복잡도도 줄였다.

문제의 접근방법에 대해서는 다르지 않았다.

cycle을 사용하지 않고 더 간단한 방법은 나머지를 이용하는 방법으로 계속 참조하는것이다.

```python
def solution(answers):
    pattern1 = [1,2,3,4,5]
    pattern2 = [2,1,2,3,2,4,2,5]
    pattern3 = [3,3,1,1,2,2,4,4,5,5]
    score = [0, 0, 0]
    result = []

    for idx, answer in enumerate(answers):
        if answer == pattern1[idx%len(pattern1)]:
            score[0] += 1
        if answer == pattern2[idx%len(pattern2)]:
            score[1] += 1
        if answer == pattern3[idx%len(pattern3)]:
            score[2] += 1

    for idx, s in enumerate(score):
        if s == max(score):
            result.append(idx+1)

    return result
```



# K번째 수

https://programmers.co.kr/learn/courses/30/lessons/42748

## 첫 답안

```python
def solution(array, commands):
    result=[]
    for lists in commands: 
        i,j,k = lists[0]-1, lists[1] ,lists[2] -1
        result.append(sorted(array[i:j])[k])
    
    return result
```

> 위에 코드중 i,j,k 는 그냥 i,j,k = lists 만해도 모두 알맞게 들어간다~

## 재정의

자르고, 정렬, 해당숫자!

## 계획

## 구현

```python
def solution(array, commands):
    return list(map(lambda x:sorted(array[x[0]-1:x[1]])[x[2]-1], commands))
```

```python
def solution(array, commands):
    return [sorted(array[i-1:j])[k-1] for i,j,k in commands]
```

## 리뷰

아래것은 내가 생각해서 짠것이다

마찬가지로 접근방식은 동일했지만, map이용과 lambda 를 적절히 활용해서 좋은 코드를 만들었다

# 체육복

https://programmers.co.kr/learn/courses/30/lessons/42862

## 첫 답안

```python
def solution(n, lost, reserve):
    saved_number = 0
    xx = []
    for x in lost:
        if x in reserve:
            reserve.pop(reserve.index(x))
            
            saved_number+=1
        else:
            xx.append(x)

    for x in xx:
        if x-1 in reserve:
            reserve.pop(reserve.index(x-1))
            saved_number+=1
        elif x+1 in reserve:
            reserve.pop(reserve.index(x+1))
            saved_number+=1
    
    
    answer = n - len(lost) + saved_number
    return answer
```

## 재정의

n 전체 학생수(1부터시작)

lost 읽어버린 사람들(1명이상)

reserve 여벌의 체육복의 학생

바로 앞번호나 바로 뒷번호의 학생에게만 체육복을 발려줄수있다.

return 최대한 많은 학생이 수업들을수있는 수

혹시 reserve와 lost에 동시에있는 숫자는 제거해야한다

## 계획

remove를 사용하여 요소를 제거하면 혹시라도있을 중복도 해결가능

## 구현

```python
def solution(n, lost, reserve):
    count=0
    up_reserve=[x for x in reserve if not x in lost]
    up_lost=[x for x in lost if not x in reserve]
    for number in up_lost:
        if number-1 in up_reserve:
            up_reserve.remove(number-1)
            count+=1
        
        elif number+1 in up_reserve:
            up_reserve.remove(number+1)
            count+=1
            
    answer=n-len(up_lost)+count
    return answer
```

## 리뷰

나와 완전 비슷한것이 답안 이였다. 이럴때가 진짜 행복하다

단지 reserve와 lost 위치를 바꿨다...더 줄일수있었다. 마지막 남은 lost 길이를 빼면되니까!

```python
def solution(n, lost, reserve):
    _reserve = [r for r in reserve if r not in lost]
    _lost = [l for l in lost if l not in reserve]
    for r in _reserve:
        f = r - 1
        b = r + 1
        if f in _lost:
            _lost.remove(f)
        elif b in _lost:
            _lost.remove(b)
    return n - len(_lost)
```

`list(set(reserve) - set(lost))` 한정적이여도 이 방법도 생각해보자

set()으로 중복을 없애고 빼주고 리스트화함

# 2016년

https://programmers.co.kr/learn/courses/30/lessons/12901

## 첫 답안

```python
def solution(a, b):
    monthlydate=[31,29,31,30,31,30,31,31,30,31,30,31]
    remain_date = 0
    if a>1:
        for x in monthlydate[:a-1]:
            remain_date+=x
    remain_date+=b
    y = remain_date%7
    print(y)
    answer = ["THU","FRI","SAT","SUN","MON","TUE","WED"][y]
    return answer
```

## 재정의

2016년 1월 1일은 금요일

2016년  a월 b일은 무슨요일?

없는날은 주어지지않는다

## 계획

데이터와 로직을 분리하자

`["THU","FRI","SAT","SUN","MON","TUE","WED"]`

`[31,29,31,30,31,30,31,31,30,31,30,31]`

## 구현

```python
def solution(a, b):
    dn=["THU","FRI","SAT","SUN","MON","TUE","WED"]
    dtn=[31,29,31,30,31,30,31,31,30,31,30,31]
    sum=0
    for i in range(a-1):
        sum+=dtn[i]
    answer=dn[(sum+b)%7] 
    return answer
```

## 리뷰

로직은 똑같지만 좀더 간결하게 가능했다

```python
return dn[(sum(dtn[:a-1])+b)%7]
```

리스트 연속으로합할떄 for문 돌지말로 slice치고 sum()부는것 좋은아이디어!



# 같은 숫자는 싫어

https://programmers.co.kr/learn/courses/30/lessons/12906

## 첫 답안

```python
def solution(arr):
    result = [] 
    first = arr[0]
    result.append(first)
    for x in range(1,len(arr)):
        second=arr[x]
        if first == second:
            pass
        else:
            result.append(second)
        first=arr[x]

    return result
```

## 재정의

배열 arr, 각 원소 0~9까지

return 배열에서 중복숫자 제거후 숫자 배열순서는 유지

## 계획

set를 활용하면 위치  index가없기때문에 배열순서 유지못한다.

for문을 돌면서 다음것과 같으면 건너뛰고 append()를 활용하면되지않을까?

## 구현

```python
def solution(arr):
    result=[]
    for i in range(len(arr)):
        if i ==len(arr)-1:
            result.append(arr[i])
            break
        if not arr[i] == arr[i+1]:
            result.append(arr[i])
    return result
```

## 리뷰

```python
def solution(arr):
    result=[]
    for x in arr:
        if not result[-1:]==[x]:
            result.append(x)
    return result
```

slice의 특성을 이용하자.. 와 대박 문자열 비어있어도 slice는 오류안내고 빈리스트 반환함.



