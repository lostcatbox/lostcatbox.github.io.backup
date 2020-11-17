---
title: 알고리즘 문제 해결 전략 책 요약
date: 2020-10-27 21:17:10
categories: [Review]
tags: [Coding, Skill, Basic]
---

# 왜?

코테 준비

![스크린샷 2020-10-27 오후 9.16.29](https://tva1.sinaimg.cn/large/0081Kckwgy1gk45ocdb2sj30oe18wx6p.jpg)

이대로 그대로 따라갈것이다

3장 부터는 꼼꼼히 보다는 제 방식대로 정리하고끝냈다. 시간이없으니 여기서부터 최대한 요약했어요.

그리고 python에 해당하는 내용만 담으로고 노력했어요.

# 2장

문제를 푸는 것이 중요한 것이 아니라 문제를 푸는 기술을 연마하는 것이중요하다

이를 위해서는 자신이 문제를 어떤 방식으로 해결하는지를 의식하고 어느 부분이 부족한지, 어떤 부분을 개선해야 할지 파악해야 합니다. 실력을 늘리기 위해서는 문제 푸는 과정을 여러 부분으로 나눠 보고 각 과정을 자신이 잘하고 있는지, 그리고 잘하지 못하는 것이 있다면 어떤 방향으로 개선해야 하는지를 끈임없이 파악해야한다. 

## 2.2 문제 해결 과정

리처드 파인만이 사용한 알고리즘. 칠판에 문제를 적는다>생각한다>칠판에 답안을 적는다. 문제풀이를 단계별로 나눈다는 아이디어를 얻어내자. 특히, 문제를 적는다는 단계는 문제를 읽고 이해한 뒤 자신의 언어를 이용해 재정의를 해야하기 때문에 중요하다. 

### 6단계 문제 해결 알고리즘

1. 문제를 일고 이해한다
2. 문제를 익숙한 용어로 재정의한다
3. 어떻게 해결할지 계획을 세운다
4. 계획을 검증한다.
5. 프로그램으로 구현한다
6. 어떻게 풀었는지 돌아보고, 개선할 방법이 있는지 찾아본다

### 문제를 읽고 이해하기

강조강조.. 문제를 일고 이해하는것. 모든 대회 참가자들이 공통으로 하는 실수가 있다면 바로 문제를 잘못 읽는 실수떄문이다. 조급한 마음>곁눈질>그림만봄>큰대가를 치룬다. 

문제의 궁극정인 목적부터 사소한 제약 조건까지 모두 이해하고 넘어가야한다. ~~큰 댓가를 치기 싫다면~~

### 재정의와 추상화

자신이 다루기 쉬운 개념을 이용해서, 문제를 자신의 언어로 풀어 쓰는 것이다. 문제가 요구하는 바를 직관적으로 이해하기 위해 꼭 필요, 복잡한 문제일수록 더 중요함.

문제의 추상화: 현실을 본질만 남겨두고 축약하여 다루기 쉽게 표현하는 것.

문제의 본질을 어떤 방식으로 재구성하느냐에 따라 같은 일을 하는 프로그램이라도 전혀 다른 문제로 받아들여질 수 있습니다. 추상화의 방법에 따라 어려운문제>쉽게품 or 쉬운문제>어렵게품..

어떤 부분을 추상화할 것인지를 선택하는 작업과 문제를 재정의하는 방법들에 대한 고찰은 필수과정이다. 반드시 연습하자

### 계획 세우기

__가장 중요한 단계__ 

문제를 어떻게 해결할지 계획을 세우는 것이다. 문제를 어떤 방식으로 해결할지 결정하고, 사용할 알고리즘과 자료 구조를 선택한다. 아마 문제를 보고 어떻게 해결해야 할지 곧장 떠오르지 않는 어려운 문제의 경우 이 과정에서 가장 많은 고민함. (2.3)

### 계획 검증하기

계획후에 키보드x

구현을 시작하기 전에 계획을 검증하는 과정을 거쳐야한다.

우리가 설계한 알고리즘이 모든 경우에 요구 조건을 정확히 수행하는지를 증명하고, 수행에 걸리는 시간과 사용하는 메모리가 문제의 제한 내에 들어가는지 확인해야한다. (4,5장)

### 계획 수행하기

프로그램을 작성, 구현이 부정확하거나 비효율적이면 프로그램은 쓰레기다

(3장)

### 회고하기

__장기적으로 가장 큰 영향을 미치는 단계__

자신이 문제를 해결한 과정을 돌이켜 보고 개선하는 과정... 문제를 한번만 풀어서는 그 문제에서 배울 수 있는 것들을 다 배우지못한다.

2번째 풀때는 더 효율적인 알고리즘을 찾거나 간결한 코드를 작성, 같은 알고리즘을 유도할 수 있는 더 직관적인 방법을 찾을 수도있다. 자신이 문제 해결 기술을 어떻게 사용하고 있는지를 돌이켜보고 개선해야한다

효과적으로 회고하는 방법은 문제를 풀때마다 코드와 함께 자신의 경험을 기록으로 남기는 것이다.

__간단한 해법,어떤 방식 접근, 문제의 해법을 찾는 데 결정적인 깨달음을 간단히 기록해보기__ 

반대로 한 번에 맞추지 못한 경우에도 오답 원인도 꼭 적는 것이좋다. 실수를 통해 배우기. 반복하게 되는 실수를 확인하고 이를 인지하면 실수를 줄이는 노력을 하게된다. 기록을 쌓는다.

마지막 공통된 회고 방법은 같은 문제를 해결한 다른 사람의 코드를 보는 것이다. 같은 문제를 비슷한 알고리즘으로 해결한 사람의 코드도 다다르다. 다른 사람과 함께 하자. 다른 통찰을 얻을 수 있다.

__문제를 풀지 못할 때__

문제를 직접 풀기 전에는 절대로 답안을 참조하지 말라는 말도 있지만, 초보 시절에는 한 문제에 너무 매달려 있는 것도 좋지 않다. 일정 시간이 지나도록 고민해도 안되면 다른 사람의 소스 코드나 풀이를 참조하자는 원칙을 세우고 접근하자

다른 사람의 소스 코드나 풀이를 참조할때 반드시 나를 돌아봐야한다. __나는 왜 이 풀이를 떠올리지 못했는가?, 내가 했던 접근은 틀렸나?__ 는 질문들의답을 찾아야한다.

처음 보는 기술이나 접근을 한번만에 자신의 것으로 하기는 힘들지만, 여러번 반복해서 이용하며 풀다보면 비슷한 문제는 해당 기법이 떠오를 것이다

## 문제 해결 전략 (계획 세우기 단계)

자신이 알고 있는 기술을 직접적으로 적용할수 있는 단순한 문제 말고 어려운 문제일수록 다양한 방법을 시도해 보면서 답안을 찾아야합니다. 답안을 읽을 때 어떤 방식으로 접근했는지를 눈여겨보자

### 직관과 체계적인 접근

가장 중요한 것은 __문제와 답의 구조에 대한 직관의 중요성이다.__ 직관은 해당 문제를 해결하는 알고리즘이 대략적으로 어떤 형태를 가질지 짐작하게해준다. 이 기술은 막막한 문제들을 해결하며 경험을 쌓아야한다. 그럼 막막한 문제는 어떻게 처음해결할까? 그냥 아이디어가 떠오르길 기대하면서 멍하게 있기보다는, 좀더 체계적으로 생각해보는것이다. 문제 해결의 좋은 시작점역할이될수있다.

### 체계적인 접근을 위한 질문들

문제를 해결할 때  유용한 질문목록!(가장 도움많이되는 질문순), 문제마다 사용처 제한이있을수도있음

__비슷한 문제를 풀어본 적이 있나?__

문제의 원리르 완전히 이해해야 변형되어도 비슷한 문제로 인식후 풀수있다.

문제의 형태가 비슷하지 않더라도 문제의 목표가 같은 경우 또한 비슷한 문제다. 

__단순한 방법에서 시작할 수 있을까?__

비슷한 문제를 본적없거나 적용되지않는다면, 무식한 방법으로 풀수있을까? 질문을 합니다. 시간과 공간 제약을 생각하지 않고 문제를 해결할 수 있는 가장 단순한 알고리즘을 만드는것. 이 전략 목표는 간단하게 풀수있는 문제를 너무 복잡하게 생각해서 어렵게 푸는 실수를 예방하는 것.  또한 효율적인 알고리즘이라도 단순한 알고리즘을 기반으로 구성된 경우가 많이 때문이다. 이런 경우 좀더 효율적인 자료 구조를 사용하거나, 계산 과정에서 같은 정보를 두번 중복으로 계산하지 않는 등의 최적화를 적용해서 빨라질 때 까지 알고리즘을 개석하는 식으로 문제 풀수있다. 사고 과정의 큰 도약을 필요하지않고, __어려운 문제를 접했을때 한번쯤 시도해 볼만하다.__

또한 단순한 방법은 알고리즘 효율성을 체크할수있다. 새로운 알고리즘이 단순한 알고리즘에 비해 얼마나 개선되었는지 재는 용도로 사용해보자. 

이런 기법을 사용하는 풀이의 예로 쿼드 트리 뒤집기(7장 연습문제)가 있다

__내가 문제를 푸는 과정을 수식화할 수 있을까?__

점진적인 접근 방식이 만능은 아니다. 처음 생각한 것과 완전히 다른, 새로운 방향에서 접근해야 풀리는 문제들도 있다. __번뜩이는 영감이 필요한 문제를 만났을때는 그냥 손으로 문제에 주어진 예제 입력을 직접 해결해 보는 것이다. 자신이 문제를 해결한 과정을 공식화해서 답을 만드는 알고리즘을 만들수있다. 또한 이과정에서 어떤 점을 고려해야 하는지 알게 된다.__

프로그램 다 작성하고, 디버깅하는도중에 어떤 점을 고려해야하는지 놓쳤다면 처음부터 다시 다짜는 비극이 나올수도ㅠㅠ

__문제를 단순화할 수 없을까?__

또 다른 강력한 문제 해결 도구는 주어진 문제의 좀더 쉬운 변형판을 먼저 풀어 보는것이다. 문제를 쉽게 변형하는 방법은 여러가진다

__문제의 제약 조건을 없애보기, 계산해야 하는 변수의 수를 줄이기, 다차원의 문제를 1차원으로 줄여 표현__

위에 방법들은 단순화된 문제의 해법이 원래 문제의 해법에 대한 직관을 제공, 직접적으로 이용해 원래 문제를 풀수도있다.

__그림으로 그려볼 수 있을까?__

문제에 관련된 그림을 그려 보는 것이다. 도형이 직관적으로 받아들이기 때문이다. 

__수식으로 표현할 수 있을까?__

편문으로 쓰여 있는 문제를 수식으로 표현하는 것도 도움된다. 수식을 전개하거나 축약하는 것은 도움을 준다

__문제를 분해할 수 있을까?__

더 다루기 쉬운 형태로 문제를 변형 하는것이다

예를 들어 문제의 제약 조건을 분해하는 방법

즉, 한개의 복잡한 조건보다 여러 개의 단순한 조건이 다루기 쉽기 때문에 변형한다.

예를 들면 A 전체 기록과 B 달리기 전체 기록이 겹칠확률이 있을라면 결국 Aworst>=Bbest 아니면서 동시에 Bworst>=Abest 가 아니라면 기록은 겹칠수밖에없다. 조건 두개로 나눔!

__뒤에서부터 생각해서 문제를 풀수 있을까?__

문제에 내재된 순서를 바꿔 보는 것이다

A에서 B로 가는 방법을 찾기 어렵지만 B에서 A로 가는 방법을 찾기 쉬울때

__순서를 강제할 수 있을까?__

순서가 없는 문제에 순서를 강제해서 문제를 푸는 방법도 있다. 

__특정 형태의 답만을 고려할 수 있을까?__

순서를 강제하는 기법의 연장선으로 정규화 기법이 있다. 정규화란 우리가 고려해야 할 답들 중 형태가 다르지만 결과적으로 똑같은 것들을 그룹으로 묶은 뒤, 각 그룹의 대표들만 고려하는방법이다.

# 3장

## 3.1

알고리즘과 자료구조를 모두알기도힘들고, 특정 문제에서 쓰인다. 하지만 코딩은 모든 문제풀이에 쓰이므로 중요하다. 코드는 일기 쉬운 코드를 목표로 작성해야한다. 디버깅도 쉬워지고, 한번에 정확하게 작성하기 어렵기때문이다. 자신의 코드 스타일을 간결하고 일관되게 다듬으려고 노력해야한다. 

## 3.2 좋은 코드를 짜기 위한 원칙



### 간결한 코드 작성

가장 간결한 코드를 작성하자. 코드가 짧을수록 오타나 단순한 버그가 생길 우려가 줄어들고, 디버깅도 쉬워진다.

모든 부분은 일반적인 회사에서 잘 짠 코드와 같은 지향점을 가지고 있지만 프로그래밍 대회에서 더 좋은 도구도있다. 예를 들면 전역 변수의 광범위한 사용이다. 매크로를 사용(C++에 해당)

### 적극적으로 코드 재사용하기

코드를 모듈화 하자! 

같은 코드가 반복된다면 이들을 함수나 클래스로 분리해서 재사용하는 것이다. __같은 코드가 세 번 이상 등장한다면 항상 해당 코드를 함수로 분리해 재사용하는 것을 기본 윈칙으로하자__. 디버깅 시간도 엄청나게 줄어든다.

이상적인 세계에서는 한 함수가 두가지 이상의 일을 해서는 안된다고 말한다. 입력을 읽어들이는 함수, 입력을 처리하기 쉬운 형태로 바꾸는 함수, 실제 문제를 푸는 함수 각각 분리되어 있어야한다는 소리다. 하지만 대부분 프로그래밍 대회에서는 이정도로 엄격하게 안한다.

### 표준 라이브러리 공부하기

내가 배열, 큐, 스택, 리스트, 딕셔너리를 직접짜기보다는(이해는 필요), 표준 라이브러리를 사용하자.

### 항상 같은 형태로 프로그램을 작성하기

문제를 풀다보면 여러 종류의 코드를 반복적으로 짜게된다. 이분법, 그래프의 너비 우선 탐색,,,알고리즘, 자료구조등.. 매우 자주 작성하게된다

 for while문도 바꾸고, 크기 가로 순으로 전달하다가 가로, 세로 순으로 전달하고 코드작성할때마다 바뀔수도있다. 하지만 이는 디버깅에 불리하다. 한번 검증된 과정 코드가 있다면 작성하고 이것만 꾸준히 사용하자.

### 일관적이고 명명법 사용하기

사용하는 언어의 표준 라이브러리에서 사용하는 명명 규약을 익히자. 모호한 명명법은 때로 잡아내기 힘든 오류를 만들어낸다

```python
def judge(y,x,cy,cx,cr)
```

judge함수는 언제 `true` 를 반환할지모른다. 디버깅할때 힘들수도있다

```python
def isInsideCircle(y,x,cy,cx,cr)
```

이렇게 함수명을 정의한다면 점이 원안에 있을때 `ture`  를 반환한다고 알수있다.

### 모든 자료를 정규화해서 저장하기

같은 자료를 두 가지 형태로 저장하지 않는 것이 중요하다. 예를 들어 유리수를 표현하는 클래스(C++기준)을 작성한다고하면, 이때 입력받는 유리수를 항상 약분해 기약 분수로 표현하는 것이 좋다. 그렇지 않는 다면 9/6, 3/2를 표현하는 변수가 따로 존재하게된다. 

다른 예로는 시간은 UTC시간, 문자열을 다루는 프로그램은 외부에서 문자열을 읽어들이자마자 UTF-8 인코딩으로 변환해야만 문자열을 다루기 훨씬 편해진다.

__즉, 정규화는 프로그램이 외부에서 자료를 입력받거나 계산하자마자 곧장 이뤄저야한다.__ 

### 코드와 데이터를 분리하기

날짜를 다루는 프로그램을 작성하는데, 날짜를 출력할떄 월을 숫자가 아니라 영문 이름으로 출력해야한다하자.. 초보자는 12줄 짜리 if문을 써서 하겠지..

코드의 논리와 상관 없는 데이터는 가능한 부리하는 것이좋다. 각 월의 영어 이름을 다음과 같은 테이블로 만드는 것으로 해결가능하다.

```python
month_name = ["January", "Februray"....]

#다른예시로 체스 기사가 움직일수있는 상대좌표8가지
knight= [2,2,-2,-2,1,1,-1,-1]
```

### 자주하는 실수

__같은 실수를 반복하지말고, 실수에서 배우는 것이 좋고, 남의 실수로부터 배워 유사한 실수를 저지르지 않는것이 최고다__

자주하는 실수모음

__산술 오버플로__

실수를 계산 과정에서 변수의 표현 범위를 벗어나는 값을 사용하는것. (3.5참조)

__배열 범위 밖 원소에 접근__

배열 범위 밖의 원소에 접근하는 오류!

__일관되지 않은 범위 표현 방식 사용하기__

배열의 잘못된 위치를 참조하는 오류가 발생하는 큰 원인중 하나로, 프로그램 내에서 여러 가지의 범위 표현 방식을 섞어 쓰는 경우가 있다. 

예를 들면 1~12의 수의 범위를 나타낼때 닫힌 범위인 1<=x<=12를 사용하고 (공집합표현시 어려움), 열린범위는 0<x<13임을 잘 고려해야한다. (시작이 0일때는 -1로 써야하므로 어색해진다)

우리는 첫번째 시작하는 값은 포함하고 마지막 값은 포함하지 않게 쓰자

1<=x<13으로 쓰자!     Like `[1,13)`

`python의 range(x,y)` 범위는 x<=x<y와 같다. 

> __장점 3가지__
>
> - x,y를 같은 값으로 줄경우 공집합이 된다
> - 두 구간이 연속해 있는지 알기쉽다. range(a,b)와 range(c,d)가있을때 b=c 혹은  a=d인지만 확인하면된다.
> - 구간 크기를 쉽게 알수있다. b-a하면 자연수의 수가 된다

__off-by-one오류__

off-by-one 오류는 계산의 큰 줄기는 맞지만 하나가 모자라거나 하나가 많아서 틀리는 코드의 오류들을 가리킨다. 예를들면 100미터인 담장에 10미터 간격으로 울타리 기둥을 세우면 필요한 기둥은 10개가 아니라 11개이다.

이런 오류는 < > <= >=를 생각하지 않고 풀었기 때문이다. 따라서 실수를 방지하려면 최소 입력이 주어졌을 때 이 코드가 어떻게 동작할지 되새겨 보는것이다.

답장의 길기아 0미터라도 기둥하나는 박아야되는것처럼!

__컴파일러가 잡아주지 못하는 상수 오타__

변수명이나 함수명에서 낸 오타는 컴파일러가 잡아주지만, 각종 사수를 잘못 입력해서 내는 오답 처리는 쉽게 잡아내기 힘들다. 

> - 반드시 코드와 데이터를 분리하자. 데이터를 별도 상수 배열에 저장도 마찬가지이다.
> - weird로 출력해야하는것을 wierd로 출력하는 것도 결국 실력이다. 소문자 대문자도 많이 틀린다
> - 데이터에서의 0의 갯수 틀림
> - (C++기준)64비트 정수형으로 들어야할것들을 64비트라고 저장하지않고, 기본 32비트로 저장...

__스택 오버플로__

프로그램의 실행 중 콜 스택이 오버플로해서 프로그램이 강제종료되는 것 또한 흔히 하는 실수다. (C++)에선 지역 변수로 선언한 배열이나 클래스 인스턴스가 기본적으로 스택 메모리를 사용하기때문.

__다차원 배열 인덱스 순서 바꿔 쓰기__

평소에 2차원 이상의 다차원 배열을 사용할 일이 많지 않지만, 가끔 대회에서 4,5차원의 고차원 배열 쓰게된다. 이때는 실수를 줄이기위해 가능한 한 특정 배열에 접근하는 위치를 하나로 통일 하는 것이 좋다

__잘못된 비교 함수 작성__

정수의 집합들을 다루는 프로그램에 정수의 집합을 저장하는 `intergerSet` 클래스가 있다고하자.   프로그램안에 `vecter<intergerSet>` 에 담긴 집합들을 순서대로 처리하는 것인데, 집합 A가 B의 진부분집합이라면 A는 항상 B보다 먼저 처리되어야합니다. 따라서 `intergerSet` 의 배열을 정렬하려고 한다. 사용자가 작성한 클래스를 정렬할 떄는 정렬 함수에 비교 함수를 전달하거나, 연산자 오버로딩을 이용해 < 연산을 오버로딩해야된다. 

![스크린샷 2020-11-04 오후 12.02.32](https://tva1.sinaimg.cn/large/0081Kckwgy1gkcyl2v99tj313k0n2e81.jpg)

> **오버로딩(Overloading)** : 같은 이름의 메서드 여러개를 가지면서 매개변수의 유형과 개수가 다르게하여 다양한 유형의 호출에 응답할수있게하는것
>
> **오버라이딩(Overriding)** : 상위 클래스가 가지고 있는 메서드를 하위 클래스가 재정의해서 사용, 재정의는 즉 ,부모클래스의 메서드는 무시하고, 자식 클래스의 메서드 기능을 사용하겠다는 것

위에 3.1코드에서 잘못짠것은 바로 operator <의 오버로딩이다. C++의 표준 라이브러리가 예상하는 일관된 답을 코드3.1 이 반환하지 않아서 문제가된다. 

![스크린샷 2020-11-04 오후 12.29.12](https://tva1.sinaimg.cn/large/0081Kckwgy1gkczcqg9oij315c0kk7wh.jpg)

특히 코드3.1에 대해서는 표준 라이브러리의 < 오퍼레이터의 4. 규칙에 맞지않는다. 예를 들면 {1},{2},{2,3} 이 있다면 코드 3.1에 대해서 {2}<{2,3}만 참이고 나머지는 모두거짓이다. 하지만 4번 규칙에 의해 a<b,b>a가 모두 성립하면 a=b라는 것으로 인지하므로 {1}={2}, {1}={2,3}이다. 따라서 {1}={2}={2,3}으로 판단하고 {2}<{2,3}으로 판단되므로 세 원로를 정렬할수없다.

올바른 비교함수 작성을 위한 방법은 a,b가 완전히 같은 경우를 제외하고는 어느 때도 두 집합이 같다고 판단하지 않는것이다. 이를 위해 우리가 원하는 포함 관계가 성립되지 않는 두 집합에 대해서도 어떤 별도의 순서를 정해줘야한다. 

특히, 이 별도의 순서는 우리가 원래 정하려 했던 순서와 모순이 되어선 안된다. 예시로 {1,3},{3},{2}가 주어진다면 사전순으로는 {1,3},{2},{3}이지만 포함관계로는 {3},{1,3}순으로 되어야한다. __서로 모순된다__

a와 b의 크기(집합크기)를 비교하여 같을때만 사전순으로 비교하면 된다. 

![스크린샷 2020-11-04 오후 12.48.35](https://tva1.sinaimg.cn/large/0081Kckwgy1gkczwwriqwj31180n4b29.jpg)

__최소, 최대 예외 잘못 다루기__

예외란 우리가 예상한 입력의 규칙에 들어맞지 않는 모든 입력이다. 이는 너무 광범위하므로 자주실수하면 예외를 보자면, 바로 가장 작은 입력과 가장 큰 입력에 대해 제대로 동작할지를 생각해 보면 오류를 잡을 수 있는 경우가 많다.

![스크린샷 2020-11-04 오후 12.52.30](https://tva1.sinaimg.cn/large/0081Kckwgy1gkd00zsueaj318a0myb29.jpg)

여기서 잘못된부분 두가지는 작은 소수 2를 판단못하는것과 1도 true로 출력됨으로 잘못된것을 알수있다.

__연산자 우선순위 잘못 쓰기__

사칙연산의 우선순위를 잘알고 의도된 대로 동작핟도록 코드를 짜자

```python
b =0
if (b and 1 ==0):
    print("실행됨")
```

얼핏보면 b=0일때 실행될것같지만 실제로는 비교연산자(==)보다 and 논리연산자의 우선순위가 낮다.

```python
b =0
if (b and (1 ==0):
    print("실행됨")
```

이것과 같다, 결과적으로 조건문은 항상 거짓이다.

▼ **표 47-3** 파이썬 연산자 우선순위

| 우선순위 | 연산자                                          | 설명                                                 |
| -------- | ----------------------------------------------- | ---------------------------------------------------- |
| 1        | (값...), [값...], {키: 값...}, {값...}          | 튜플, 리스트, 딕셔너리, 세트 생성                    |
| 2        | x[인덱스], x[인덱스:인덱스], x(인수...), x.속성 | 리스트(튜플) 첨자, 슬라이싱, 함수 호출, 속성 참조    |
| 3        | await x                                         | await 표현식                                         |
| 4        | **                                              | 거듭제곱                                             |
| 5        | +x, -x, ~x                                      | 단항 덧셈(양의 부호), 단항 뺄셈(음의 부호), 비트 NOT |
| 6        | *, @, /, //, %                                  | 곱셈, 행렬 곱셈, 나눗셈, 버림 나눗셈, 나머지         |
| 7        | +, -                                            | 덧셈, 뺄셈                                           |
| 8        | <<, >>                                          | 비트 시프트                                          |
| 9        | &                                               | 비트 AND                                             |
| 10       | ^                                               | 비트 XOR                                             |
| 11       | \|                                              | 비트 OR                                              |
| 12       | in, not in, is, is not, <, <=, >, >=, !=, ==    | 포함 연산자, 객체 비교 연산자, 비교 연산자           |
| 13       | not x                                           | 논리 NOT                                             |
| 14       | and                                             | 논리 AND                                             |
| 15       | or                                              | 논리 OR                                              |
| 16       | if else                                         | 조건부 표현식                                        |
| 17       | lambda                                          | 람다 표현식                                          |

햇갈리면 괄호로 감싸서 계산하자

> 비트 연산자는 비트(bit) 단위로 논리 연산을 할 때 사용하는 연산자입니다. 또한, 비트 단위로 전체 비트를 왼쪽이나 오른쪽으로 이동시킬 때도 사용합니다.
>
> ```python
> a = 1
> b = 3
> print(a^b)
> 
> >>>
> 2
> ```
>
> 이진법 0,1로 생각해보면 a는 0,1 b는 1,1이므로 xor결과 1,0나온다. 따라서 2가 출력됨.

__너무 느린 입출력 방식 선택__

대부분의 프로그래밍 언어에서는 텍스트를 입출력할 수 있는 다양한 방법을 제공한다. 예를 들어 C++에서는 gets()를 이용해 모든 입력을 문자열 하나로 파싱할 수도있고, cin등의 고수준 입력 방식을 사용할 수도있지만, 고수준은 속도 저하..

__위에 사례처럼 입력출력할 변수가 1만개 넘어가면, 긴장하고 python에서 어떤 입출력이 빠르게 되는지 점검하자__

__변수 초기화 문제__

프로그램을 한번만 실행하고, 한 번에 여러개의 입력에 대해 답을 처리하라고요구한다. 이때 이전 입력에서 사용한 전역 변수 값을 __초기화하지 않고 그대로 사용하면 절대 안된다__

이를 방지하기위해 동일 예제 두번반복시키면 혹여나 못찾아낸것도 찾을수있다.

### 디버깅과 테스팅

__디버깅에 관하여__

대부분 사람들은 예제 입력 실행후 결과가 다른 상황이면 보통 디버거를 켜고 프로그램이 실행되는 과정을 하나하나 따라가본다. 하지만 대회에서는 눈으로하는것이 빠를때도있으며, 재귀호출 중복 반복문을 많이 사용하는 복잡한 코드는 디버거 활용이 적당하지않고, 3명이 컴퓨터 1개이기때문에 나머지 2명 아무것도못함. 따라서 복잡한 코드를 짜지 말고, 잘 분리된 기능적인 코드를 짜야한다.

눈으로 디버깅 가능한 조건은 단순한 코드+ 분리된 기능적 코드 이다

__눈으로 디버깅할 때 순서__

- 작은 입력에 대해 제대로 실행되나 확인 > 예제 입력의 크기를 줄여 디버깅

- python의 `assert` 함수를 사용해 체크하자. 참이면 무시되며, 거짓일때 오류를 냄

  예를 들면 함수에서 넘겨받은 인자들이 범위안에 있는지, 값들은 제대로 입력받았는지 검사가능

- 프로그램의 계산 중간 결과를 출력한다> 어디까지 예상대로 진행됫는지 보기위해

__앞으로 디버깅시 눈으로 위 3과정을 거치고도 모르겠다면 디버거를 사용하자.__

__테스트에 관하여__

답안 제출 전에 예제 입력을 만들어 가능한 많이 프로그램을 테스트하는 것이 좋다. 예제를 변경하여 가장 작은 입력, 가장 큰 입력을 만들어서도 넣어보고, 시간안에 실행되는지, 답이 잘 나오는지 꼭 테스트해보자! 

프로그램을 테스트할 때 유용하게 사용할 수 있는 기법으로 스캐폴딩(공사판에 걸어다니기위한 임시 구조물..)이 있다. 이 말은 다른 코드를 개발할 때 뼈대를 잡기 위해 임시로 사용하는 코드라는 뜻으로 쓰입니다.

스캐폴딩은 코드의 정당성을 확인하거나 반례를 찾는데 특히 유용하게 쓰인다.

예를 들면 코드를 제출했는데 오답판정이 나는데, 예제는 다 통과하는 상황이라면 오류를 찾는게 쉽지않다. 이때 임의의 작은 입력을 자동으로 생성해 프로그램을 동려 보고, 그 답안을 검증하는 프로그램을 짜면된다. 직접 작성한 정렬 함수를 테스트 하고 싶다면 `while Ture`안에서 입력값을 매번생산해서 함수에 넣어주고 하나는 직접만든 함수에 하나는 표준 라이브러리sort를 이용해 결과값이 다르다면 오류를 내고 원인을 출력하게한다.

하지만 비교 대상이없다면, 아주 단순한 알고리즘으로짠(대신느린)것과 비교해볼수도있다. 

__꼭 필요한 경우에 쓰자. 시간을 그만큼 더 잡아 먹기 때문이다__

### 변수 범위의 이해

__산술 오버플로__

어떤 식의 계산 값이 반환되는 자료형의 표현 가능한 범위를 벗어나는 경우를 말한다

수학에 어떤 변수 n있다면 이 변수에 담을 수 있는 숫자제한없다. 하지만 컴퓨터의 모든 변수에는 담을 수 있 크기가 제한되어있다. 즉, 완전히 정당한 알고리즘도 구현했을때 흔히 문제를 일으키는 것이 산술 오버플로다.

__실수 2가지__

- 보통 언어에서는 오버플로 일어나도 경고안해줌. 비효율적이니까
- 프로그램의 정당성을 검증할 때 프로그램 논리의 정확성에만 집중하다보면 산술 오버플로가 등장할 것이라는것을 간과할때가 많다

__너무 큰 결과__

32비트, 64비트 고려하기

__너무 큰 중간 값__

출력 값은 작지만, 중간 과정에서 큰 값을 일시적으로 계산해야할때!(64비트, 32비트고려)

__너무 큰 무한대 값__

너무큰 무한대 값들이 서로 연산되면 산술 오버플로가 발생하므로 조심하자

__오버플로 피해가기__

더 큰 자료형을 쓰면 오버플로를 피할수있다. 64비트 사용!

또한 연산 순서를 바꾼다면 해결될수도있다

~~__자료형의 프로모션__~~

~~사칙연산이나 대소 비교등의 이항 연산자들은 두 개의 피연산자를 받는다. 피연산자의 자료형이 다르거나 자료형의 범위가 너무 작은 경우 컴파일러들이 대개 이들을 같은 자료현으로 변환하여 계산하는데 이를 프로모션이라고함(C++해당내용) 버그에 기여할때가있다.~~ 

### 실수 자료형의 이해

```python
def isX(range_number):
    count_result = 0
    for x in range(1,range_number+1):
        if (1/x)*x == 1:
            count_result += 1
    print(count_result)
isX(500)

>>>
469
```

왜? 모든 실수가 만족하는 것인데?

컴퓨터가 사용하는 실수 표현 방식에 대해 알아야한다

__실수와 근사 값__

일상적으로 정수들은 컴퓨터가 모두 정확하게 표현할수있다. 반면 실수에서는 이야기가 다르다. 1만원을 3명이 나누면 0.33333333... 되어버린다. 소수점 뒤로 무한하게 이어진다. 컴퓨터의 메모리는 유한하고, 이 모든 값들을 모두 정확하게 담을 수 없으니 적절히 비슷한 값을 사용하는 것으로 만족해야한다. 적절한 반올림같은것. 컴퓨터도 정확도가 제한된 근사 값을 저장한다.즉, 컴퓨터에서 실수를 다루는 것은 까다롭다. 

__IEE 754 표준__

가장 많은 컴퓨터/컴파일러들에서 사용되는 실수 표기 방식은 IEE754표준이다. 특징은 다음과 같다.

- 이진수를 실수로 표기
- 부동 소수점 표기법
- 무한대, 비정규 수, NaN(숫자아님) 등의 특수한 값이 존재

책에 주제에 대해서 직접적인 영향을 미치는 주제에 관해서만 다루자.

__실수의 이진법 표기__

12.34라는 실수의 십진법 표기를 보자. 마지막 자리의 4가 5로 변한다면 전체 수의 0.01만큼 커진다. 즉, 소수점 바로 아래 자리의 크기는 1/10, 그 다음자리의 크기는 1/100이 된다. 일반화하면 소수점 밑 i번째 자리의 크기는 1/10^i라고 할수있다.

실수의 이진수 표기도 기본적으로 똑같은 방식을 사용한다. 소수점 밑 i번째 자리의 크기는 1/2^i가 된다. 따라서 이진법으로 쓴 실수 1011.101인 경우는 정수는 2^3+2^1+2^0=11 이다. 소수부는 1/2 +1/8=0.625이다. 11.625

__부동 소수점 표기__(움직이는 소수점)

32비트 공간을 이용해 실수를 이진법으로 표기한다고하자. 정수부와 소수부에 비트를 어떻게 배분할 것인지 선택해야한다. _ _ . _ _ 처럼 소수점위 X자리, 소수점 밑 Y자리! 하지만 모두를 만족시킬수없는 이방법은 정확도를 떨어트린다.(어느숫자는 정수부가 많고, 어느숫자는 소수부가 많으므로)

따라서 1011.101이라는 이진법 수가 있다면 이것을 1.011101으로 저장한다. 소수점앞에있을수있는 유일한 숫자 1이므로 1비트를 절약한다. 즉, 5비트만을 저장할수있다면 최상위비트 1을 제외한 01110 5비트를 저장할수있다!

이때 실수 변수는 다음과 같은 3가지의 정보를 저장해야한다

- 부호 비트- 양수인지 음수인지
- 지수- 소수점 몇칸 옮겼나?
- 가수- 소수점을 옮긴 실수의 최상위 X비트(숫자를 표현하는 비트)

만약 63비트중 53비트를 지수표현에 쓰고 10비트만 가수 표현사용하는데 쓴다면, 1024를 이진법으로 표현하면 1 00000 00000 이고, 1024.25 는 1 00000 00000.01 이다. 따라서 최대 11비트를 사용할수있는 기수는 결국 1024와 1024.25의 차이를 모르고 같은 숫자로 저장한다. 정확도 하락

따라서 사람들은 지수보다 가수에 훨씬 많은 비트 수를 부여하기로했다.

따라서 실수 자료형들에는 32, 64,80비트등에서 지수 가수에 공간을 어떻게 분배하는지에 따라 표현할수있는 숫자 범위값이 정해짐.

![스크린샷 2020-11-08 오후 3.34.14](https://tva1.sinaimg.cn/large/0081Kckwgy1gkhr6jrpu3j30o407en6t.jpg)

64비트에서 52비트가 가수 비트이며 맨앞 1까지 포함하면 53비트까지 표현하고 54비트 이하의 숫자들은 반올림된후 버려진다. 이것을 십진수로 따지만 최대 7자리의 정확도밖에 제공하지 않는것이다.

64비트 쓰자.

__실수 비교하기__

컴퓨터가 실수를 근사적으로 표현한다는 사실을 알면, 위에 소스 코드에서 원하는 답이 안나온이유를 알수있다. 이진법으로 표현할 수 없는 형태의 실수는  근사 값으로 저장되는데, 이때 생기는 작은 오차가 계산 과정에서 다른 결과를 가져오기때문이다.

따라서 두 값의 차이가 매우 작은 경우 두 값이 같다고 판단할때는  |(a-b)|<1e-10으로 검증하면 된다. 오차보다 작으면 같은거지!

__비교할 실수의 크기들에 비례한 오차 한도를 정한다__

500월짜리가 3000천만원이 될수없는것처럼 실제 입력으로 들어올 최대 값과 최소값을 대략 예측할수있고, 이들이 크게 차이 나지 않는 경우ㅔ는 하나의 오차한도 값을 사용할수있다.  같게 판단할만큼 크고 다름을 알정도로 작아야한다.

동전 문제에서 동전의 반지름은 항상 1이상이고, 소수점 밑 둘째 자리까지 입력이 주어진다면, 사실상 1밀리미터 단위로 주어지는 것이다. 반지름 1인원과 1.01인 원의 넓비 차이를 보자

![스크린샷 2020-11-08 오후 3.59.30](https://tva1.sinaimg.cn/large/0081Kckwgy1gkhrwrjjnvj30d4046772.jpg)

따라서 오차 한도가 0.0001 이하라면 충분하다.

__상대 오차를 이용한다__

문제 입력으로 한자리 또는 서른 자리가 주어질지 알수없을때 오차 한도를 미리 정할수없다. 이런 경우에는 비교하는 숫자들의 크기에 비례하여 오차를 정하는 방식을 사용하자.

두 숫자의 크기에 비해 그 차이가 작다면 그 차이가 작다면 두 수가 같다고 판정하는 식이다.

__대소 비교__

만약 예상하는 결과가 다른경우 이 상황도 비교전 미리 오차범위내에있는지확인해야한다

__정확한 사칙연산__

IEEE표준에 의해 정확하게 표현할 수 있는 값은 항상 정확하게 저장하도록 구현되어있다. 64비트 실수형은 52비트이므로 +-2^52 보다 작은 정수들은 항상정확함.

__코드의 수치적 안정성 파악하기__

수치적으로 안정적이라는 말은 프로그램 실행 과정에서 발생하는 오차가 더 커지지 않는다는말이다.

모든 실수가 아닌 주어진 {1,4,6}에서 답찾는것은 실수로 1,4가 false가 나오는순간 6이 정답이므로 수치적 안전성이 낮은 프로그램이 나올수있다.

__실수 연산 아예하지 않기__

피해가는게 젤 중요!

- 곱셈과 나눗셈 순서바꾸기

  (결과가 항상정수라면 a/b\*c를 할게 아니라 a\*c/b)(대신 오버 플로 주의)

- 양변 제곱하기

  정수 좌표를 갖는 두 점 A(x1,y2),B(x2,y2) 사이의 거리가 r인지 확인하고싶은것은 원리 root((x1-x2)^2 -(y1-y2)^2) = r을 확인해야하는데 이때는 그냥 양변 제곱한것을 비교하는게 더 좋다.

- 실수 좌표를 써야 하는 기하 문제에서 좌표계를 가로 세로로 정수배 늘리면 정수만을 이용해 문제 풀기가능.

# 4장 알고리즘의 시간 복잡도 분석

어떤 작업이 주어졌을 떄 컴퓨터가 이 작업을 해결하는 방법을 가리켜 알고리즘이라고한다.

가능한 한 명료하고 모호하지 않은 표현을 위해 사람들은 알고리즘을 대개 의사 코드나 그것을 구현한 소스 코드의 형태로 설명합니다. 언어 상관없이 문제를 해결하는 방법 그 자체를 가르키는것이 알고리즘이다.

한 문제를 해결하는데 여러 개의 알고리즘이 있다면? 알고리즘을 평가하는 기준으로 판단하자

- 시간 - 알고리즘이 적은 시간을 사용한다는 것은 빠르게 동작한다는 이야기임
- 공간 - 더 적은 용량의 메모리를 사용하는 이야기

두 기준은 서로 상출하는 경구가 많다. 메모리가 박하지 않은 이상 보통은 __속도__ 가 빠른것을 선택하자 

## 4.1 도입

알고리즘 속도를 어떻게 측정할 것인가?

직관적 방법은 각각을 프로그램으로 구현한뒤 입력에 대해 프로그램의 수행 시간을 측정하는 것이다

하지만 프로그램의 실행 시간은 알고리즘 속도를 모두 대변하지 못한다. 언어, 하드웨어, 운영체제, 컴파일러까지 많은 요소에 의해 바뀔수있기 때문이다. 

알고리즘을 평가하는 방법

__반복문이 지배한다__

자동차, 자전거를 서울부산 움직이면, 자동차가 주유시간 등등 여가 요소를 빼고도 결국 속도가 전체의 대소를 좌지우지한다.(=__지배한다__)

알고리즘의 수행 시간을 지배하는 것은 반복문이다!! 입력이 커질수록 반복문이 알고리즘의 수행 시간을 지배한다

반복문의 수행 횟수는 입력의 크기에 대한 함수로 표현한다. 주어진 배열에서 가장 많이 등장하는 수를 찾는 코드를 보자. 이것은 수행 시간은 배열의 크기 N에 따라 변한다. N번 수행되는 반복문이 두개가 겹쳐있으므로 수행시간은 N^2이다

```python
# 배열에서 가장 많은 수 반환
input_number = [1,2,3,1,2,2,4,3,2,4,5,1,2,3,2,3,5,1,2]
majority_num = 0
for i in range(len(input_number)):
    count=0
    present_number = input_number[i]
    
    for j in range(len(input_number)):
        if present_number==input_number[j]:
            count+=1
    if count> majority_num:
        majority_num = present_number
print(majority_num)
```

입력으로 주어지는 숫자가 100점 만점이라면, 이처럼 숫자의 범위가 작다면, 배열을 이용해 각 숫자가 등장하는 횟수를 쉽게 셀수 있다. 마지막에 빈도수 배열을 순회하면서 최대치의 위치를 찾으면 된다. 다음코드를 보자. 하나는 N번 수행하고, 다른 나머지는 100번 수행되므로 전체 반복문의 수행 횟수는 N+100이다. N이 커질수록 후자의 반복문이 수행시간에서 차지하는 비중이 줄게된다.

궁극적으로 아래 코드의 수행 시간은 N이라고 쓴다.

```python
# 배열에서 가장 많은 수 반환2
input_number = [1,2,3,1,2,2,4,3,2,4,5,1,2,3,2,3,5,1,2]
count=0

#파이썬에서 백터 대체가능한 딕셔너리 활용(책에서는 백터활용함.)
number_dict = {}
for i in range(1,101):
    number_dict[i] = 0

#여기서 부터 책에 쓰여진 코드 알고리즘
for i in range(len(input_number)):
    number_dict[input_number[i]] += 1
    
# 빈도수에서 가장큰것을 반환
for i in range(1,101):
    if number_dict[i]>number_dict[majority]:
        majority = i
print(majority)
```

## 4.2 선형 시간 알고리즘

__다이어트 현황 파악: 이동 평균 계산하기__

이동 평균은 주식의 가격, 몸무게 등 시간에 따라 변화하는 값들을 관찰할 때 유용하게 사용할수있는 통계적 기준이다. M-이동평균은 마지막 M개의 관찰 값의 평균으로 정의된다. 따라서 새 관찰 값이 나오면 M-이동 평균은 새 관찰 값을 포함하도록 바뀐다.

만약 N개의 측정치가 주어질 때 매달 M달 간의 이동 평균을 계산하는 프로그램을 짜면 어떨까?

예시 코드 수행 시간은 두 개의 for문에 의해 지배된다. j를 사용하는 반복문은 항상 M번 실행되고, i를 사용하는 반복문은 N-M+1 번 실행되니 전체 반복문은 (M)\*(N-M+1) 만큼 반복된다. N=12, M=3이면 30번이다.

```python
N=[1,2,3,4,5]
M=4

for i in range(M-1,len(N)):
    sum_result=0
    for j in range(M):
        sum_result+=N[i-j]
    print(sum_result/M)

    

##내가 짠 코드
# N개의 특정치가 주어질 떄, 매달 M달 간의 이동평균 계산
N=[1,2,3,4,5]
M=4

for i in range(len(N)-M+1):
    sum_result=0
    for j in range(M):
        sum_result+= N[i+j]
    print(sum_result/M)

```

이는 할아버지의 매일 몸무게 입력이면 어떻게될까?

대중 10만 일간의 이동평균을 알고싶다면, 전체 반복 횟수는 253억이다. 좀더 빠른 프로그램이 필요하다.

__중요한 아이디어는 중복된 계산을 없애는 것이다__

측정치가 M개는 되어야 이동평균을 계산할수있다. 이때 M-1일의 이동평균과 M일의 이동 평균에 포함되는 숫자는 0일과 M일 빼고는 모두 겹치는 숫자임을 알수있다. 그러면 측정한 몸무게의 합을 일일이 구할 것없이 M-1일에 구햇던 몸무게의 합에서 0일째에 측정한 몸무게를 빼고 M일째에 측정한 몸무게를 더하면 된다는 아이디어를 생각해볼수있다.

이 프로그램 반복 수행 횟수는 M-1 + (N-M+1) = N이 됩니다.

```python
N=[1,2,3,4,5]
M=4

count = 0
for i in range(M-1):
    count+= N[i]
for i in range(M-1,len(N)):
    count+=N[i]
    print(count/M)
    count-= N[i-M+1]



### 내 풀이
count=0
for i in range(M-1,len(N)):
    if not count:
        for j in range(M):
            count+=N[i-j]
    else:
        count-=N[i-M]
        count+=N[i]
        
    print(count/M)
```

코드 수행시간은 N에 정비례합니다. 

입력의 크기에 대비해 걸리는 시간을 그래프로 그려보면 정확히 직선이 된다. 이런 알고리즘을 선형 시간 알고리즘이라고 부른다. 선형 시간 알고리즘은 가장 좋은 알고리즘인 경우가 많다

## 4.3 선형 이하 시간 알고리즘

### 성형 전 사진 찾기

__어떤 문제건 입력된 자료를 모두 한번 훑어보는 데에는 입력의 크기에 비례하는 시간, 즉 선형 시간이 걸린다__. 하지만 선형 시간보다 더 짧은 알고리즘도있다. 입력으로 주어진 자료에 대해 우리가 미리 알고 있는 지식을 활용한다면 가능하다.

A군이 성형을 했고 우린 사진과 날짜(날짜순 정렬)를 알고있다. 그럼 A군이 언제 성형했는지를 가능한 정확하게 알려면 대체 몇장의 사진을 확인해야할까?

가장 좋은 방법은 남은 사진들을 항상 절반으로 나눠서 가운데 있는 사진을 보는 것이다. 가운데보고 맞으면 그전사진들중 가운데, 틀리면 그전사진들은 날리면되고 후의 사진들중 가운데.. 이런식

이때 봐야되는 사진의 장수를 N에 대해 표현하면?

전체 N장 사진에서 계속 절반으로 나눠서 1이하가 될때까지 몇번을 나눠야 하는지로 알수있는데, 이것을 나타내는 함수가 로그이다. 매번 절반씩 나누니 밑이 2인 로그 log 밑 2 를 사용하면된다.(이후  lg로줄임). 따라서 확인해야 하는 사진의 장수는 대략 lgN이다.

선형 이하 시간알고리즘!(데이터 전체를 보지않음)

### 이진 탐색

방금전 예제에서 사용한 알고리즘을 이진 탐색(binary search)라고 부른다. 누구나 사전을 찾을때, 이용하는 아이디어이다. 모든 알고리즘 중 가장 유용하게 씀. 이진 탐색 알고리즘이 하는 일을 정의해보자.

![스크린샷 2020-11-09 오후 4.29.05](https://tva1.sinaimg.cn/large/0081Kckwgy1gkiydwib5sj30w007kqcb.jpg)

__쉽게 표현하자면 배열 A[ ]에서 x를 삽입할수있는 위치중 가장 앞에 있는 것을 반환한다고 생각하자__

대개의 배열이나 리스트 구현에서  i번째 위치에 새원소를 삽입한다는 것은 i번째와 그 이후의 원소들을 뒤로 한칸씩 밀어내고 들어간다는 것이다. 따라서 A[]에 x가 존재할경우, 이 함수는 첫 번째 x의 위치를 반환하고, 없는 경우 x보다 큰 첫번째 원소(위치아닌가???)를 반환한다.

위같은 일을 하는 이진 탐색 함수가 있다고할떄, 성형 문제는 다음과 같이 풀수있다. 길이  N인 정수 배열 A[]를 만들어 각 원소가 가장 일찍 찍힌 사진부터 차례대로 하나의 사진을 표현하도록한다. 이때 각 원소의 값은 해당 사진에서 A군이 성형했을때 1, 아닐때 0으로 한다. 그러면 A는 {0,0,0,0,0,0...........,1,1,1,1,1,1} 형태이다. 위에 이진 탐색 함수를 활용해서 A[i-1]<1=<A[i]인 i를 찾으면 1의 첫번째 위치를 찾을 수있다. 따라서 i-1~i사진사이에서 성형한것을 알수있다.

### 그래도 선형 시간 아닌가?

근데 위 설명대로면 함수를 쓰기위해 모든 사진을 보면서 0,1을 라벨링해야되니까..하지만 그렇지 않다

A[]를 실제로 계산해서 갖고 있을 필요가없다. 이진 탐색 알고리즘 내부에서 그중 몇개도 안보기때문이다. 그때마다 물어보면 된다. 

### 구현

간단한 아이디어와 달리 이진 탐색을 정확하게 구현하기는 까다롭다. 어렵다!

## 지수 시간 알고리즘

### 다항 시간 알고리즘

변수 N와 N^2, 그외 N의 거듭제곱들의 선형 결합으로 이뤄진 식을 다항식이라고 부른다. 반복문의 수행 횟수를 입력 크기의 다항식으로 표현할수있는 알고리즘들을 다항 시간 알고리즘으로 부른다.

뭐 4.1, 4.2에 코드들도 다항 시간 알고리즘이다 (각각 수행시간은 N^2, N)

하지만 다항 시간이라는 하나의 분류에 포함되는 알고리즘간에는 엄청난 시간차이가날수있다.

### 알러지가 심한 친구들

N명의 친구를 초대해서 M가지의 음식중 무엇을 대접해야, 알레르기를 비해서모두가 적어도 한가지 음식을 먹을수 있을까?

![스크린샷 2020-11-10 오후 4.43.55](https://tva1.sinaimg.cn/large/0081Kckwgy1gkk4fn23plj30qc0aek58.jpg)

### 모든 답 후보로 평가하기

물론 음식모두를 한다면 상관없지만, 우린 더 적은 종류의 음식만 준비하고싶다. __이렇게 여러 개의 답이 있고 그중 가장 좋은 답을 찾는 문제를 풀떄 가장 간단한 방법은 모든 답을 일일이 고려하는것이다__

만들수있는 음식의 모든 목록을 만드는 과정은 여러 개의 결정으로 나누면 자연스럽다. 첫번째 요리를 만들지 말지 결정하고, 두번쨰 요리를 만들지 말지 결정하는것을 계속반복하면된다. 끝까지 내려가보면 마지막 층에서는 존재 가능한 모든 목록을 만나게 된다. 이제 모든 친구들이 식사할 수 있는 목록들만을 골라낸뒤 가장 음식의 수가 적은 목록을 찾으면된다.

![스크린샷 2020-11-10 오후 5.16.07](https://tva1.sinaimg.cn/large/0081Kckwgy1gkk5d4xjkbj311u0rue81.jpg)

이런 알고리즘을 구현하는 가장 쉬운 방법은 재귀 호출이다. 이떄 재귀 함수는 그림에서의 한 상태를 입력받아 이 상태 밑에 달린 모든 후보들을 검사하고 이중 가장 좋은 답변을 반환하는 역할을 한다. 

코드에서 selectMenu()는 지금까지 만들기로 정한 메뉴와 몇 번 음식을 결정할 차례인지를 입력받아 가능한 모든 메뉴를 하나씩 시도해 봅니다.(???추후에 설명해주겟지..)

![스크린샷 2020-11-10 오후 5.29.24](https://tva1.sinaimg.cn/large/0081Kckwgy1gkk5qyhivnj30ua0u0x6p.jpg)

### 지수 시간 알고리즘

모든 답을 한번씩 다 확인하기 때문에, 전체 걸리는 시간은 만들수 있는 답의 수에 비례하게 된다. M가지의 음식을만든다, 안만든다 이므로 2^M가지의 답지가 있다. 답하나를 만들떄마다 canEverybodyEat()을 수행하니까 수행시간은 2^M 에 canEverybodyEat()의 수행시간을 곱한것이된다. canEverybodyEat()을 수행할떄 반복문이 N*M번 수행된다고 가정하면 전체 수행 시간은 N*M*2^M이다

즉, 2^M과 같은 지수 함수는 알고리즘의 전체 수행 시간에 엄청난 영향을 미친다. 

이와같이 N이 하나 증가 할때마다 시간이 배로 증가하는 알고리즘들은 지수 시간에 동작한다고 한다. 입력 크기에 따라 다항 시간과는 비교도 안되게 빠르게 증가한다.... 그렇다고 지수 시간보다 빠른알고리즘을 찾지 못해서 꽤 쓰고있다.

지수 시간을 다항 시간으로 바꾸는 방법은 없다. 단지 좀더 지수 시간을 단축시켜줄뿐

### 소인수 분해의 수행 시간

입력으로 주어지는 숫자의 개수가 아니라 그 크기에 따라 수행 시간이 달라지는 알고리즘들 또한 지수 수행 시간을 가질수있다. 자연수 N이 주어질떄 N의 소인수 결과를 반환하는 알고리즘, N까지의 숫자로 나눠본다. 즉, N크기에 따라 반복문의 수행 횟수가 달라진다.

```python
input_number = 10000000
num_list=[]
def search_int(number):
    for x in range(2,number+1):
        while(number%x ==0): #구지 책에서는 while을 써서 지수함수를 만듬
             num_list.append(x)
    print(num_list)

search_int(input_number)
```

이는 N의 크기에 좌우된다. 선형시간이 걸린다고 생각하는것과는 다르다. N의 갯수에 따른것이 아니니까. 실제 입력은 1개니까> 그럼 왜 이런 불일치가 발생한다는걸까?

이런 불일치를 직관적으로 이해하기 위해 알고리즘의 수행 시간과 입력이 메모리에서 차지하는 공간의 관계를 생각해보자. 이진 탐색, 이동 평균 계산 등 지금까지 다룬 알고리즘에서는 입력의 값들이 일정 범위 내에 있다고 어렵지 않게 생각할수있다. 이 경우 입력의 개수와 메모리에서 차지하는 공간이 직접적으로 비례한다. 반면 소인수 분해 문제에서는 입력으로 주어지는 숫자가 알고리즘의 동작에 직접적인 영향을 미치므로, 숫자가 특정범위안에 있다고 가정할수없다. 입력의 값이 커지면 커질수록 숫자를 저장하는데 필요한 메모리의 공간도 증가할 것이기때문이다. (???)

입력이 차지하는 비트의 수에 따라 수행 시간이 증가한다고 생각하면 아까의 불일치를 직관적으로 설명할수있다. 비트의 수가 하나 증가할 때마다 표현할수이쓴ㄴ 수의 범위와 알고리즘의 최대 수행시간은 두배로 증가한다. 이렇게 입력의 크기를 입력이 차지하는 비트 수로 정의하면 위에 코드는 지수 시간이 걸린다고 말할수있다.



## 4.5 시간 복잡도

__4장에서 설명하는 모든것을 이해하자__, 모든 알고리즘에 쓰이는것이기때문이다

시간 복잡도란 가장 널리 사용되는 알고리즘의 수행시간 기준으로, 알고리즘이 실행되는 동안 수행하는 __기본적인 연산의 수를 입력의 크기에 대한 함수로 표현__한 것이다. 기본적인 연산이란 더 작게 쪼갤수 없는 최소 크기의 연산이라고 생각하자. 

최소 크기의 연산예시

- 두 부호 있는 32비트 정수의 사칙연산
- 두 실수형 변수의 대소 비교
- 한 변수에 다른 변수 대입하기

반면 다음과 같은 연산은 반복문을 포함하기 때문에 기본적인 연산이 아니다

- 정수 배열 정렬하기
- 두 문자열이 서로 같은지 확인하기
- 입력된 수 소인수 분해하기

반복문의 내부에 있는 기본적 연산들은 더 쪼갤 수없기 때문에 이것은 시간 복잡도의 대략적인 기준이 됩니다.

__시간 복잡도가 높다는 말은 입력의 크기가 증가할 때 알고리즘의 수행 시간이 더 빠르게 증가한다는 의미다.__ 하나더 생각해야할 것은 시간 복잡도가 낮다고 해서 언제나 더 빠르게 동작하는 것은 아니라는 것이다. 입력의 크기가 충분히 작을 때는 시간 복잡도가 높은 알고리즘이 더 빠르게 동작할수도있다. 시간 복잡도가 낮은 알고리즘은 입력이 커지면 커질수록 더 효율적이다.

__따라서 시간복잡도는 알고리즘의 완전한 속도 기준이 아니다__. 만약 A와 B에 입력의 크기 N에 대해 10240+35logN, 2N^2의 시간이 걸린다고하자. A는 처음에 복잡한 작업을 하지만 N에대해서는 선형 이하 시간이다. 반면 B는 전형적인 다항 시간 알고리즘이다. N이 낮을때는 B가 우위를 가진다. 하지만 N이 높을때는 A가 더 빠르다. A는 입력의 크기가 더 크더라도 수행시간에 미치는 영향이 적기때문이다.

### 입력의 종류에 따른 수행 시간의 변화

배열에서 같은 입력값과 같은 수 찾아서 index반환하는 함수, 보통 최악 수행시간이 마지막 에있을경우이므로 최악의 수행 시간을 사용한다.

### 점근적 시간 표기: O 표기

시간 복잡도는 알고리즘의 수행 시간을 표가하는 방법이지만, 계산하기 너무 힘듬. 따라서 반복문의 반복 수만 고려하게된다.

더욱 간단하게 표현한 대문자 O표기법을 사용해 알고리즘의 수행 시간을 표기한다. O표기법은 간단하게 말해 주어진 함수에서 가장 빨리 증가하는 항만을 남긴 채 나머지를 다 버리는 표기법이다.(앞에상수도빼버림)

예를 들어 수행시간이 F(N)=root(5)/3*N^2-N*log(N/2)+16N-7이라고하자. 4개의 항이있다. N이 증가할때 가장 빨리 증가하는 항은 root(5)/3*N^2이고, 여기에서 상수를 떼어내면 N^2가 된다. 그럼 이 알고리즘의 수행시간은 O(N^2)이라고 표기한다. 위에 알고리즘에서 반복문의 수행 횟수가 N\*M\*2^M 인것이있었다. 이것은  O(N\*M\*2^M)

만약에 알고리즘의 입력의 크기가 두개 이상의 변수로 표현될때는 그중 가장 빨리 증가하는 항들만을 떼 놓고 나머지를 버린다. 

![스크린샷 2020-11-12 오후 5.48.27](https://tva1.sinaimg.cn/large/0081Kckwgy1gkmhjf0u81j30ky0bak04.jpg)

마지막 두가지는 흥미롭다. (N^2)\*M, N\*(M^2) 어느 한쪽이 빠르게 증가한다고 할수 없기때문에 둘다 O표기에 포함된다. 맨 마지막은 입력의 크기와 상관없이 항상 같은시간에 끝나기에, 이 알고리즘은 1만큼의 시간밖에 걸리지 않는다고 씬다. 이런 알고리즘은 __상수 시간 알고리즘__이라고 부른다

이 같이 최고차항을 제외한 모든 것을 들어내기 때문에, 수행 시간의  O표기가 훨씬 간편하다. __이 표기법을 쓸떄 알고리즘의 시간 복잡도는 반복문에 의해 결정되기 때문에, 반복문들이 몇번이나 실행되는지만 보면된다.__

### O표기법의 의미

O 표기법은 대략적으로 함수의 상한을 나타낸다는데 의미를 가진다. 여기서의 상한의 의미는 특이하다. N에 대한 함수  F(N)이 주어질때, F(N)=O(g(N)) 은 다음과 같은 의미이다

![스크린샷 2020-11-12 오후 5.59.53](https://tva1.sinaimg.cn/large/0081Kckwgy1gkmhvahxw4j30zo0aenau.jpg)

즉 F(N)=(N^2) + 100*N + 1 일때 O(N^2)이다. N^2는 F(N)보다는 항상 작다. 하지만 적당한 C를 곱해준다면 항상 F(N)보다 크거나 같아진다. 

N0와 C는 우리맘대로 정하면된다. 

O표기법이 수행 시간의 상한을 나타낸다는 것이 알고리즘의 최악의 수행 시간을 알아냇다고착각하는 일이 잦다. 하지만 O표기법은 각 경우의 수행 시간을 간단히 나타내는 표기법일뿐, 특별히 최악의 수행시간과 관련없다. 

예를 들면 퀵 정렬의 최악의 수행시간을 보면 최고차항이 N^2이고, 최악의 시간 복잡도는 O(N^2)이다. 하지만 평균 수행 시간을 계산해보면 최고차항이 NlogN이며, 평균 시간 복잡도는 O(NlogN)이다

### 시간 복잡도 분석 연습

아래 코드는 주어진 정수 배열을 정렬하는 유명한 두가지 알고리즘의 구현이다

selectionSort()는 선택 정렬알고리즘을 구현한다. 선택 정렬은 모든 i에 대해 A[i..N-1]에서 가장 작은 원소를 찾은 뒤, 이것을 A[i]에 넣는 것을 반복합니다. 

```python
# 선택정렬
A=[1,3,4,5,6]


def selectionSort(unsorted_list):
    
    for x in range(len(unsorted_list)):
        minIndex = x
        
        for y in range(x+1,len(unsorted_list)):
            
            if(unsorted_list[minIndex]>unsorted_list[y]):
                minIndex=y
        unsorted_list[x],unsorted_list[minIndex] = unsorted_list[minIndex],unsorted_list[x]
        
        
selectionSort(A)
print(A)
```

x=0일때 N-1번,x=1일때 N-2번, x=N-1일때는 0번이다. 즉 O(N^2), N은 당연히 A[ ]의 크기이다.

![스크린샷 2020-11-12 오후 7.05.05](https://tva1.sinaimg.cn/large/0081Kckwgy1gkmjr5392lj30so04gn1y.jpg)

```python
# 선택정렬
A=[3,1,6,5,7]


def insertionSort(unsorted_list):
    for x in range(len(unsorted_list)):
        y = x
        while(y>0 and unsorted_list[y-1]>unsorted_list[y]):
            unsorted_list[y-1],unsorted_list[y] =unsorted_list[y],unsorted_list[y-1]
            y-=1
            
insertionSort(A)
print(A)
```

insertionSort( )는 전체 배열중 정렬되어 있는 부분에 새 원소를 끼워넣는 일을 반복한다. 삽입 정렬은 A[i]에 있던 값을 하나씩 앞으로 옮기면서 조건 만족할때까지 while문으로 구현. 

입력 배열의 초기 순서에 따라 달라진다.

따라서 최선의 경우와 최악의 경우가 나눠질수있다.

최선의 경우는 이미 정렬된배열이 입력일때는, while문은 바로 종료기 때문에 O(1)으로 보고, 따라서 전체 시간 복잡도는 x에 대한 for문으로 자우된다. 따라서 O(N)이다.

반면 최악의 경우는 숫자들을 계속 앞으로 전달하는 경우 이므로 while문 시간복잡도는 O(N)이며 전체 시간 복잡도는 O(N^2)이다.

따라서 삽입정렬이 거의 선택정렬보다 빠르다는 것을 알수있다. 

### 시간 복잡도의 분할 상환 분석

알고리즘의 시간 복잡도를 항상 반복문의 개수를 세는 것만으로만 결정하지않는다. 더 정확한 시간 복잡도 계산에 대표적 예시가 시간 복잡도의 분할 상환 분석을 사용하지만, 이 책범위넘어감

## 4.6 수행 시간 어림짐작하기

### 주먹구구 법칙

다양한 요소가 프로그램의 수행시간에 관여한다. 많은 경우 __시간 복잡도__와 입력 크기만 알아도 대략 시간을 알수있다. 

입력의 크기를 시간 복잡도에 대입해서 얻는 반복문 수행 횟수에 대해, 1초당 반복문 수행 횟수가 1억(10^8)을 넘어가면 시간 제한 초과 생각하자

N=10000 일떄 O(N^3)는 통과못하고 O(NlogN)은 통과한다.

하지만 의외로 다른요소때문에 안될때가 있다

- 시간 복잡도가 프로그램의 실제 수행 속도 반영못하는 경우
- 반복문의 내부가 복잡한 경우
- 메모리 사용 패턴이 복잡한 경우
- 언어와 컴파일러 차이
- 구형 컴퓨터를 사용하는경우

실제 알고리즘과 프로그램 구현을 참조해 속도를 어림짐작할 때는 평소에 작성하는 프로그램들의 시간 복잡도와 수행 시간의 상관 관계에 대한 경험과 직관이있으면 도움이 많이된다.

### 실제 적용해 보기

1차원 배열에서 연속된 부분 구간 중 그 합이 최대인 구간을 찾는 문제를 풀어보자. 

예시 배열[-7,4,-3,6,3,-8,3,4]에서 최대 합을 갖는 부분 구간은 [4,-3,6,3]으로 합은 10이다. 여러 가지 알고리즘으로 해결가능하다. 시간 복잡도가 서로 다른 여러 알고리즘을 구현하고 각 알고리즘의 수행 시간이 어떻게 다른지 확인해보자

첫 첫 번째로 다룰 알고리즘은 주어진 배열의 모든 부분 구간을 순회하면서 그 합을 계산하는 알고리즘이다. O(N^2)개의 후보 구간을 검사하고, 각 구간의 합을 구하는데 O(N)이 걸리므로 전체 시간 복잡도는 O(N^3)이다. 

이를 개선하여 O(N^2)로 수행할수있다. betterMaxSum( )참조하자.

![스크린샷 2020-11-13 오후 3.56.47](https://tva1.sinaimg.cn/large/0081Kckwgy1gknjxjsl2rj30z00mk4qp.jpg)

```python
#최대 연속 부분 구간 합 문제를 푸는 무식한 알고리즘들
def betterMaxSum(A):
    result=0
    for i in range(len(A)):
        sum = 0
        for j in range(i,len(A)):
            sum += A[j]
            result = max(result, sum)
    return result

A = [-7,4,-3,6,3,-8,3,4]
betterMaxSum(A)
```

7장에서 다루는 분할 정복 기법을 이용하면 더 빠른 수행시간 가지는 알고리즘 설계가 가능하다. 입력받은 배열을 우선 절반으로 잘라 왼쪽 배열과 오른쪽 배열로 나눈다. 이때 우리가 원하는 최대 합 부분 구간은 두 배열 중 하나에 속해있을수도있고, 두 배열 사이에 걸쳐 있을수도있다. 이떄 각 경우의 답을 재귀 호출과 탐욕법을 이용해 계산하면 훌륭한 분할 정복 알고리즘이된다. 아래는 전체 수행 시간은 O(NlogN)

```python
#최대 연속 부분 구간 합 문제를 푸는 분할 정복 알고리즘
def fastMaxSum(A,lo,hi):
    MIN=0
    #기저 사례: 구간의 길이가 1일 경우
    if(lo==hi):
        return A[lo]
    # 배열을 A[lo..mid],A[mid+1...hi]의 두조각으로나눈다
    mid = (lo+hi)//2
    # 두 부분에 모두 걸쳐 있는 최대 합 구간을 찾는다. 이 구간은 A[lo..mid],A[mid+1...hi]형태를 갖는 구간의 합으로 이뤄진다
    # A[lo..mid]형태를 갖는 최대 구간을 찾는다
    left =MIN
    right=MIN
    sum=0
    for i in range(mid,lo,-1):
        sum += A[i]
        left =max(left,sum)
        
    # A[mid+1...hi]형태를 갖는 최대 구간을 찾는다.
    sum = 0
    for j in range(mid+1,hi,1):
        sum += A[j]
        right = max(right, sum)
        
    #최대 구간이 두 조각 중 하나에만 속해 있는 경우의 답을 재귀호출로 찾는다
    single = max(fastMaxSum(A,lo, mid), fastMaxSum(A, mid+1, hi))
    return max(left+right, single)

  
A = [-7,4,-3,6,3,-8,3,4]
lo=0
hi=7
fastMaxSum(A,lo,hi)
```

마지막으로 이 문제를 선형 시간에 푸는 방법(8장에 소개) 동적  계획법을 사용하는  것이다. A[i]를 오른쪽  끝으로 갖는 구간의 최대  합을 반환하는  함수  maxAt(i)를 정의한다. 그런데  A[i]에서 끝나는 최대 합 부분 구간은 항상 A[i] 하나만으로 구성되어있거나, A[i-1]를 오른쪽 끝으로 갖는 최대 합 부분 구간의 오른쪽에 A[i]를 붙인 형태로 구성되어 있음을 증명할 수 있습니다. 따라서 maxAt()을 다음과 같은 점화식으로 표현할수 있다.(???)

아래 코드는 O(N)의 시간 복잡도를 갖는다.

![스크린샷 2020-11-17 오후 1.03.22](https://tva1.sinaimg.cn/large/0081Kckwgy1gks1ebmh7wj30e60200uj.jpg)

```python
def fastestMaxSum(input_list):
    MIN = 0
    N=len(input_list)
    ret = MIN
    psum =  0
    
    for i in range(N):
        psum = max(psum, 0) + input_list[i]
        ret = max(psum, ret)
        
    return ret


A = [-7,4,-3,6,3,-8,3,4]
fastestMaxSum(A)
```

> A[i-1]까지의 합이 음수인경우 다음 psum은 0으로 초기화하며 +A[i]이 새로운 psum값이 된다.

즉, 1개의 문제를 풀이하는 4가지의 알고리즘을 제시했다.  각각 O(N^3),O(N^2),O(NlogN),O(N)이다.

![스크린샷 2020-11-17 오후 1.11.28](https://tva1.sinaimg.cn/large/0081Kckwgy1gks1mqp12vj30oy0biqjo.jpg)

다행히  주먹구구 법칙으로 예측한 것보다 느리게 동작하는 프로그램은 없었다.

## 4.7 계산 복잡도 클래스: P,NP,NP-완비

시간 복잡도는 알고리즘의 특성이고, 문제의 특성이 아니다. 

계산 복잡도는 각 문제에 대해 얼마나 빠른 알고리즘이 존재하는지를 탐구하는 학문

### 문제의 특성 공부하기

계산 복잡도 이론은 각 문제의 특성을 공부한다.

- 정렬 문제: 주어진 N개의 정수를 정렬한 결과는 무엇인가?
- 부분 집합 합 문제: N개의 수가 있을 떄 이중 몇개를 골라내서 그들의 합을 S가 되도록 할 수 있는가?

둘중 무엇이 문제푸는 것이 어려울까? 이때 어려움은 계산 복잡도 이론에서의 문제의 난이도이다. 빠른 알고리즘이있는 문제를 쉽다고 정의한다. 다항 시간 알고리즘이나 그보다 빠른 알고리즘들만의 "빠르다"라고 표현한다. (코드가 몇줄이든 상관없다)

계산 복잡도 이론에서는 이렇게 다항 시간 알고리즘이 존재하는 문제들의 집합을 P문제라고한다. 같은 성질을 같은 문제들을 모아놓은 집합을 계산 복잡도 클래스라고 한다. 우리는 P와 NP문제를 보겠다.

### 난이도의 함정

P가 다항 시간에 풀수있는 문제면, NP는 답이 주어졌을때 이것이 정답인지를 다항 시간 내에 확인할 수 있는 문제이다.

그럼 문제 A가 B문제이상으로 어렵다고 말하려면 어떻게 확인하나?, 문제의 난이도를 비교하기 위한 환산이라는 기법을 이용한다. 환산이란 한 문제를 단른 문제로 바꿔서 푸는 기법이다. B의 입력을 적절히 변형해 A의 입력으로 바꾸는 환산 알고리즘이 존재한다고하자. 그럼 B문제를 A를 푸는 가장 빠른 알고리즘 +환산 알고리즘 으로 풀수있다. 환산 알고리즘은 무시될 정도로 빠르다. B를 푸는 알고리즘이 A+환산보다 같거나 빠르다면 A가 B이상으로 어렵다라고 말할수있다.

예를 들어 주어진 배열을 비교하는 정렬하는 문제와 최소치를 찾는 문제 난이도비교해보자

주어진 배열을 다항 시간에 정렬하고 첫번째 값을 취하면 최소치를 얻을수있다. 따라서 정렬보다 최소치가 오래 걸릴수가없다. 따라서 정렬 문제는 최소치 문제 이상으로 어렵다고 말할수있다. 

### NP문제, NP난해 문제

SAT문제 이상이 문제 어려움의 기준이된다. 

NP는 답이 주어졌을때 이것이 정답인지를 다항 시간 내에 확인할 수 있는 문제이다. 따라서 부분 집합 합 문제는 NP이다. 답이 주어졌을때, 원래 집합의 부분 집합인지, 그리고 원소들의  합이 S인지 다항 시간에 쉽게 확인할수있기때문이다

또한 모든 P문제는 모두 NP문제에도 포함된다. 다항 시간 알고리즘이 존재한다면, 이를 사용해 문제를 처음부터 다시 푼뒤답을 비교하는 방식으로 답의 정당성을 다항 시간에 확인할수있기 때문이다.

# 6 무식하게 풀기

## 개관

알고리즘을 고안하는 것은 까다롭다. 요구사항에 대해 깊이 생각하지 않는 채 우선 타이핑하고, 꼬여버린 코드를 볼수도있다. ㅠㅠ

알고리즘 설계작업은 한순간의 영감보다 여러 전략적인 선택에 따라 좌우된다. 해결할 문제 특성을 이해하며, 동작 시간, 사용 공간 사이의 상충 관계를 이해하고, 적절한 자료 구조를 선택해야한다.

알고리즘 설계 패러다임이란 주어진 문제를 해결하기 위해 알고리즘이 채택한 전략이나 관점을 말한다. 어떤 알고리즘들은 문제를 해결하기 위한 가장 중요한 깨달음을 공유하고, 이는 일종의 패턴이 있다.

(컴퓨터 과학의 역사를 바꾼 주용한 알고리즘 설계 패러다임들에 대해 설명)

## 6.1 도입

__프로그래밍 대회에서 가장 많이하는 실수는 쉬운 문제를 어렵게 푸는 것이다__. 공부를 많이 했으니 우아한 답안을 만들고싶고, 따라서 쉽고 간단하며 틀릴 가능성이 낮은 답안을 간과할수있다.

__이런 실수를 피하기 위해 문제를 마주하고 나면 가장 먼저 스스로에게 물어보자. 무식하게 풀수있을까?__

무식하게푼다= 컴퓨터의 빠른 계산능력을 이용해서 가능한 경우의 수를 일일이 나열해서 답을 찾는방법이다. 

이렇게 가능한 방법을 전부 만들어 보는 알고리즘들을 __완전탐색__ 이라고 부른다

완전탐색은 더 빠른 알고리즘의 기반이 되기도 한다

### 6.2 재귀 호출과 완전 탐색

### 재귀 호출

모든 작업들에는 대개 작은 조각들로 나눌수있다.

범위가 작아지면 작아질수록 각 조각들의 형태가 유사해지는 작업들을 많이 볼수있다. `for` 문은 대표적인 완전히 같은 코드를 반복해 실행하는 예시다. 이런 작업을 구현할 때 유용하게 사용되는 개념이 __재귀 함수, 혹은 재귀 호출__이다.

__재귀 함수란 자신이 수행할 잡업을 유사한 형태의 여러 조각으로 쪼갠 뒤 그 중 한 조각을 수행하고, 나머지를 자기 자신을 호출해 실행하는 함수를 가르킨다.__

다양한 알고리즘을 구현하는데 매우 유용

예시는 반복문을 재귀 함수로 바꿔보자. 자연수 n이 주어졌을 때 1부터 n까지의 합을 반환하는 함수 sum()을 구현해보자. 재귀함수를 이용하여라

```python
def recursiveSum(n):
    if (n==1):
        return 1
    return n + recursiveSum(n-1)

recursiveSum(10)
```

n개의 숫자의 합을 구하는 작업을 n개의 조각으로 쪼개, 더학 각 숫자가 하나의 조각이 되도록하자. 재귀 호출을 이용하기 위해서는 이 조각 중 하나를 뗴내어 자신이 해결하고, 나머지 조각들은 자기 자신을 호출해 해결하자. 이 조각중에 n만 때어냈다. 그러면 1~n-1까지의 조각들이 남는다. 이들을 모두 처리한 결과는 1~n-1까지의 합이다. 따라서 자기 자신을 호출해 n-1까지의 합을 구하고, 여기에 n을 더하면, 답이다.

`if(n==1)` 이 굉장히 중요하다. 더이상 일 조각이 하나뿐이므로, 한개빼고는 더이상 처리할 작업이없다. __모든 재귀 함수는 이와 같이 더이상 쪼개지지 않는 최소한의 작업에 도달했을 때 곧장 반환하는 조건문을 포함해야한다.__ 이때 쪼개지지 않는 가장 작은 작업들을 가르켜 재귀 호출의 기저 사례(base case)라고한다.

기저 사례를 선택할 때는 존재하는 모든 입력이 항상 기저 사례의 답을 이용해 계산 될수 있도록 신경써야한다. 즉 예시에서 `if(n==2)`라고했을때  n=1로 주어지면 문제가 생김.

재귀 호출은 기존에 반복문을 사용해 작성하던 코드를 다르게 짤수있는 방법제공한다.

### 예제: 중첩 반복문 대체하기

0번부터 차례대로 번호 매겨진 n개의 원소 중 네 개를 고르는 모든 경우를 출력하는 코드를 작성해보자

예를 들어  n=7이라면 (0,1,2,3),(0,1,2,4),(0,1,2,5),...,(3,4,5,6)의 모든 경우를 출렸하는 것이다. 물론 4중 for문을 써서 간단해결도가능하다.

```python
def answer(n):
    answer_list2=[]

    for i in range(n):

        for j in range(i+1,n):

            for k in range(j+1,n):
            
                for l in range(k+1,n):
                    answer_list2.append([i,j,k,l])
    print(answer_list2)
    
answer(5)
```

10개를 골라야하면 `for` 문 10개를 하면되겠지...

위 코드 조각이 하는 작업은 네 개의 조각으로 나눌수있다. 각 조각에서 하나의 원소를 고르는것이다. 이럴게 원소를 고른뒤, 남은 원소들을 고르는 작업을 자기자신을 호출해 떠넘기는 재귀 함수를 작성하자. 이때 남은 원소들을 고르는 작업을 다음과 같은 입력들의 집합으로 정의할수있다.

- 원소들의 총 개수
- 더 골라야 할 원소들의 개수
- 지금까지 고른 원소들의 번호

```python
def pick(n, picked,toPick):
    ##기저 사례: 더 고를 원소가 없을때 고른 원소출력
    if(toPick==0):
        print(picked)
        return
    ## picked마지막숫자 참고하여 고를수있는 가장 작은 번호를 계산한다

    try:
        smallest = picked[-1] +1
    except:
        smallest = 1

    ##이 단계에서 원소 하나를 고른다
    for next in range(smallest,n):
        picked.append(next)
        pick(n,picked, toPick-1)
        del picked[-1]
    
pick(5,[],2)
```
