---
title: 배열(array)와 리스트(list) 차이
date: 2020-10-19 13:59:14
categories: [Basic]
tags: [Basic. Python]
---

[자세히](https://m.blog.naver.com/PostView.nhn?blogId=sw4r&logNo=221122409797&proxyReferer=https:%2F%2Fwww.google.com%2F)

[자세히2](https://velog.io/@choonghee-lee/%EB%B2%88%EC%97%AD-Array-vs.-List-vs.-Python-List)

# 왜?

데이터를 만지다보면 또는 알고리즘 문제를  풀다보면 배열과 리스트를 인덱스로 불러오는 방법이 다르다는 것을 알수있다.

왜 차이가 날까?

# 자세히

파이썬에서는 array를 지원하지 않기 때문에 numpy를 사용하자

![스크린샷 2020-10-19 오후 2.15.45](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjukisdpa6j30sq0tajvz.jpg)

a는 array, b는 list 객체이다.

array는 인덱스로 값을 불러올수있다. (파이썬에서는 0부터 인덱스가 시작이라는 것을 알자)

파이썬의 리스트는 인덱스를 할수없다는 컴퓨터 공학에서의 리스트와 같게 생각하면 안된다.

파이썬에서 리스트가 어떻게 작동하는지 내부를 보면 파이썬의 리스트는 배열처럼 구현되어있다는것이다(Dynamic Array)

즉, 파이썬 리스트의 아이템들은 메모리 상의 연속적인 위치에 배치되며, 인덱스를 사용하여 접근이 가능하다. 또한 `append`, `pop`처럼 하이레벨의 기능들도 지원한다. 따라서 특정 언어와 관계없이 __자료구조를 익히기 위해, 파이썬에서는 리스트를 단순 배열로만 생각하는 것이 좋다.__

# 결론

__(컴퓨터 공학에서의 배열과 리스트)__

## 공통점 

- 아이템들의 컬렉션이다.

- 아이템들의 순서가 있다.

## 차이점

**배열은 인덱스를 가지고 이 값은 유일무이한 식별자이다.**

__배열은 반드시 할당된 메모리 공간은 연속적이라는 것이다.__(연속이라는것이 매우중요, 조회가 빠르다,  cache hit가능성크다.)

**반면, 리스트는 인덱스를 갖지만 이는 몇 번째 데이터인가 정도를 의미한다**

__리스트는아이템들의 메모리 주소가 연속적일 수도 있고, 아닐 수도 있다.__

__배열의 모든 아이템들이 똑같은 사이즈를 가진다__
