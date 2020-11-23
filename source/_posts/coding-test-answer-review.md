---
title: 코테 준비 오답노트
date: 2020-10-30 17:53:00
categories: [Codingtest]
tags: [Codingtest]
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

