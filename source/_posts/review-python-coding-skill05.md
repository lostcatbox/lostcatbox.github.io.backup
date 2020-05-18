---
title: 파이썬 코딩의 스킬 리뷰 5
date: 2020-05-14 21:45:47
categories: [Python]
tags: [Review, Tip, Skill]
---

# 병행성과 병렬성

병행성(concurrency)이란 컴퓨터가 여러 일을 마치 동시에 수행하는 것을 말한다.(실제는 아님) 

예를 들어 CPU코어가 하나인 컴퓨터에서 운영체제는 단일 프로세서에서 실행하는 프로그램을 빠르게 변경한다. 이 방법으로 프로그램을 교대로 실행하여 프로그램들이 동시에 실행하는 것처럼 보이게 한다.

병렬성(parallelism)은 실제로 여러 작업을 동시에 실행하는 것이다. CPU코어가 여러 개인 컴퓨터는 여러 프로그램을 동시에 실행할 수 있다. 각 CPU 코어가 각기 다른 프로그램의 명령어(instruction)를 실행하여 각 프로그램이 같은 순간에 실행하게 해준다.

단일 프로그램 안에서 병행성이라는 도구를 이용하면 특정 유형의 문제를 더욱 쉽게 해결할 수 있다. 병행 프로그램은 별개의 여러 실행 경로를 동시에 독립적으로 실행하는 것처럼 진행하게 해준다.

병렬성과 병행성 사이의 가장 큰 차이점은 속도 향상이다. __한 프로그램에서 서로 다른 두 실행 경로를 병렬로 진행하면 전체 작업에 걸리는 시간이 절반으로 준다.__(병렬성) 반면에 병행 프로그램은 수천 가지 실행 결로를 병렬로 수행하는 것처럼 보이게 해주지만 전체 작업 속도는 향상되지 않는다.(병행성)

파이썬을 쓰면 병행 프로그램을 쉽게 작성할 수 있다. 시스템 호출, 서브프로세스, C 확장을 이용한 병렬 작업에도 파이썬을 쓸 수 있다. __그러나 병행 파이썬 코드를 실제 병렬로 실행하게 만드는 건 정말 어렵다.__ 이런 미묘한 차이가 생기는 상황에서 파이썬을 최대한 활용하는 방법을 알아야 한다.

## 자식 프로세스를 관리하려면 subprocess를 사용하자 (B36)

파이썬은 실전에서 단련된 자식 프로세스 실행과 관리용 라이브러리를 갖추고 있다. 따라서 명령줄 유틸리티 같은 다른 도구들을 연계하는 데 아주 좋은 언어다. 기존셸 스크립트가 시간이 지나면서 점점 복잡해지면, 자연히 파이썬 코드로 재작성하여 가독성과 유지보수성을 확보하려고 하기 마련이다

파이썬으로 시작한 자식 프로세스는 병렬로 실행할 수 있으므로, 파이썬을 사용하면 머신의 CPU 코어를 모두 이용해 프로그램의 처리량을 극대화할 수 있다. 파이썬 자체는 CPU 속도에 의존할 수도 있지만(B37참조), 파이썬을 사용하면 CPU를 많이 사용하는 작업을 관리하고 조절하기 쉽다.

수년간 파이썬에는 popen, popen2, os.exec\* 를 비롯하여 서브프로세스를 실행하는 방법이 여러 개 있었다. 요즘의 파이썬에서 자식 프로세스를 관리하는 최선이자 가장 간단한 방법은 내장 모듈 subprocess를 사용하는 것이다.

subprocess로 자식 프로세스를 실행하는 방법은 간단하다. 다음 코드에서는 Popen생성자가 프로세스를 시작한다. communicate 메서드는 자식 프로세스의 출력을 읽어오고 자식 프로세스가 종료할 때까지 대기한다.

```python
import subprocess
proc = subprocess.Popen(
    ['echo', 'Hello from the child!'],
    stdout=subprocess.PIPE)
out, err = proc.communicate()
print(out.decode('utf-8'))
```





(작성중 하지만 2020.05.14 현재 책의 뒷부분을 더 소화하는것은 필요없다고 판단하고 중단한다.)

(앞에 파이썬 스킬 리뷰를 복습하고 체득하는것으로 목표를 변경한다.)
