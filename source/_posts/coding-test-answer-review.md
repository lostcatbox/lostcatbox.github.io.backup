---
title: 코테 준비 오답노트
date: 2020-10-30 17:53:00
categories: [Codingtest]
tags: [Codingtest]
---

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
  
  for i in range(0, len(day_pay)-team_cnt):
pay_sum = sum(day_pay[i:i+team_cnt])

avgs.append(pay_sum/team_cnt)
avgs.append((pay_sum+day_pay[i+team_cnt])/(team_cnt+1))

  result = min(avgs)

  print("%.11f"%result)
```

