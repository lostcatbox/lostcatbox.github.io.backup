---
title: 파이썬 코딩의 스킬 리뷰 3
date: 2020-04-22 14:41:32
categories: [Python]
tags: [Review, Tip, Skill]
---

# 클래스와 상속

파이썬은 상속, 다형성, 캡슐화 같은 객체 지향 언어의 모든 기능을 제공한다. 파이썬으로 작업을 처리하다 보면 새 클래스들을 작성하고 해당 클래스들이 인터페이스와 상속 관계를 통해 상호 작용하는 방법을 정의해야 하는 상활을 자주 접하게 된다.

파이썬의 클래스와 상속을 이용하면 프로그램에서 의도한 동작을 객체들로 손쉽게 표현할수있다. 또한 프로그램의 기능을 점차 개선하고 확장도 가능하다. 요구사항이 바뀌는 환경에서도 유연히 대처가능. 클래스와 상속을 사용하는 방법을 잘 알아두면 유지보수가 용이한 코드작성 가능.

## 딕셔너리와 튜플보다는 헬퍼 클래스로 관리하자 (B22)(!!!)

파이썬에 내장되어 있는 딕셔너리 타입은 객체의 수명이 지속되는 동안 동적인 내부 상태를 관리하는 용도로 아주 좋다. 여기서 '동적'이란 예상하지 못한 식별자들을 관리해야 하는 상황을 뜻한다. 

예를 들면 이름을 모르는 학생 집단의 성적을 기록하고 싶다고 해보자. 학생별로 미리 정의된 속성을 사용하지 않고 딕셔너리에 이름을 저장하는 클래스를 정의할 수 있다. 

```python
class SimpleGradebook(object):
    def __init__(self):
        self._grades = {}

    def add_student(self, name):
        self._grades[name] = []

    def report_grade(self, name, score):
        self._grades[name].append(score)

    def average_grade(self, name):
        grades = self._grades[name]
        return sum(grades) / len(grades)
```

클래스를 사용하는 방법은 간단하다.

```python
book = SimpleGradebook()
book.add_student('Isaac Newton')
book.report_grade('Isaac Newton', 90)
book.report_grade('Isaac Newton', 95)
book.report_grade('Isaac Newton', 85)
print(book.average_grade('Isaac Newton'))

>>>
90.0
```

딕셔너리는 정말 사용하기 쉬워서 과도하게 쓰다가 코드를 취약하게 작성할 위험이 있다. 

예를 들어 SimpleGradebook 클래스를 확장해서 모든 성적을 한 곳에 저장하지 않고 과목별로 저장한다고 하자. 이런 경우 \_grades 딕셔너리를 변경해서 학생 이름(키)을 또 다른 딕셔너리(값)에 매핑하면 된다. 가장 안쪽에 있는 딕셔너리는 과목(키)을 성적(값)에 매핑한다.

```python
class BySubjectGradebook(object):
    def __init__(self):
        self._grades = {}

    def add_student(self, name):
        self._grades[name] = {} #리스트에서 딕셔너리로 바뀜
```

위의 코드는 충분히 직관적이다. report_grade와 average_grade메서드는 여러 단계의 딕셔너리를 처리하느라 약간 복잡해지지만 아직은 다룰만 하다

```python
#위의 클래스와 이어짐
    def report_grade(self, name, subject, grade):
        by_subject = self._grades[name]
        grade_list = by_subject.setdefault(subject, [])
        grade_list.append(grade)

    def average_grade(self, name):
        by_subject = self._grades[name]
        total, count = 0, 0
        for grades in by_subject.values():
            total += sum(grades)
            count += len(grades)
        return total / count
```

> setdefault()
>
> 첫번째 인자는 key값으로 기존 dict에 지금받는 key가 없으면 생성
>
> 두번째 인자는 default값으로 첫번쨰 인자가 생성된다면 이 값이 value로 들어감
>
> 만약 첫번째 인자의 key값을 갖는것이 dict에 존재한다면 그 해당 value값을 반환함

```python
book = BySubjectGradebook()
book.add_student('Albert Einstein')
book.report_grade('Albert Einstein', 'Math', 75)
book.report_grade('Albert Einstein', 'Math', 65)
book.report_grade('Albert Einstein', 'Gym', 90)
book.report_grade('Albert Einstein', 'Gym', 95)
print(book._grades["Albert Einstein"]) #타고 value값보기
print(book._grades["Albert Einstein"]['Math'])
print(book.average_grade('Albert Einstein'))
```

이제 요구 사항이 다시 바뀐다고 해보자. 수업의 최종 성적에서 각 점수가 차지하는 비중을 매겨서 중간고사와 기말고사를 쪽지시험보다 중요하게 만들려고 한다. 이 기능을 구현하는 방법 중 하나는 가장 안쪽 딕셔너리를 변경해서 과목(키)을 성적(값)에 매핑하지 않고, 성적과 비중을 담은 튜플(score, weight)에 매핑하는 것이다.

```python
class WeightedGradebook(object):
    def __init__(self):
        self._grades = {}

    def add_student(self, name):
        self._grades[name] = {}

    def report_grade(self, name, subject, score, weight):
        by_subject = self._grades[name]
        grade_list = by_subject.setdefault(subject, [])
        grade_list.append((score, weight))
```

값을 튜플로 만든 것뿐이라서 report_grade를 수정한 내역은 간단해보이지만, average_grade 메서드는 루프 안에 루프가 생겨서 이해하기 어려워졋다.

```python
# 위 클래스와 이어짐
    def average_grade(self, name):
        by_subject = self._grades[name]
        score_sum, score_count = 0, 0
        for subject, scores in by_subject.items():
            subject_avg, total_weight = 0, 0
            for score, weight in scores:
                subject_avg += score * weight
                total_weight += weight
            score_sum += subject_avg / total_weight
            score_count += 1
        return score_sum / score_count
```

클래스를 사용하는 방법도 더 어려워졌다. 위치 인수에 있는 수자들이 무엇을 의미하는 지도 명확하지 않다

```python
book.report_grade('Albert Einstein', 'Math', 80, 0.10)
```

이렇게 복잡해지면 딕셔너리와 튜플 대신 클래스의 계층 구조를 사용할 때가 된것이다

처음엔 성적에 비중을 적용하게 될지 몰랐으니 복잡하게 헬퍼 클래스를 추가할 필요는 없었다. 파이썬의 내장 딕셔너리와 튜플 타입을 쓰면 내부 관리용으로 층층이 타입을 추가하는 게 쉽다. 

__하지만 계층이 한 단계가 넘는 중첩은 피해야 한다.__(즉, 딕셔너리를 담은 딕셔너리는 피하자). 여러 계층으로 중첩하면 다른 프로그래머들이 코드를 이해하기 어려워지고 유지보수의 악몽

관리하기 복잡하다고 느끼는 즉시 클래스로 옮겨가야한다. 그러면 데이터를 더 잘 캡슐화한 잘 정의도니 인터페이스르 제공할 수 있다. 또한 인터페이스와 실제 구현 사이에 추상화 계층을 만들 수 있다

### 클래스 리팩토링

의존 관계에서 가장 아래에 있는 성적부터 클래스로 옮겨보자. 이렇게 간단한 정보를 담기에 클래스는 너무 무거워 보인다. 성적은 변하지 않으니 튜플을 사용하는 게 더 적절해 보인다.다음 코드에서는 리스트 안에 성적을 기록하려고(score, weight)튜플을 사용한다.

```python
grades = []
grades.append((95, 0.45))
grades.append((85, 0.55))
total = sum(score * weight for score, weight in grades)
total_weight = sum(weight for _, weight in grades)
average_grade = total / total_weight
print(average_grade)
```

문제는 일반 튜플은 위치에 의존한다는 점이다. 성적에 선생님의 의견 같은 더 많은 정보를 연관지으려면 이제 튜플을 사용하는 곳을 모두 찾아서 아이템을 계속 추가해서 수정해줘야한다. 다음 코드에서는 튜플에 있는 세 번째 값을 \_ 로 받아서 그냥 무시하도록 했다.(파이썬에서는 관례적으로 사용하지 않을 변수에 밑줄 변수 이름을 쓴다.)

```python
grades = []
grades.append((95, 0.45, 'Great job'))
grades.append((85, 0.55, 'Better next time'))
total = sum(score * weight for score, weight, _ in grades)
total_weight = sum(weight for _, weight, _ in grades)
average_grade = total / total_weight
print(average_grade)
```

튜플을 점점 더 길게 확장하는 패턴은 딕셔너리의 계층을 깊게 두는 방식과 비슷하다. 튜플의 아이템이 두 개를 넘어가면 다른 방법을 고려해야한다

__`collections` 모듈의 namedtuple 타입이 정확히 이런 요구에 부합한다__

namedtuple을 이용하면 작은 불변 데이터 클래스(immutable data class)를 쉽게 정의 할수있다.(불변의 데이터는 튜플의특징이고 클래스처럼 사용가능하게 만들어줌)

```python
import collections
Grade = collections.namedtuple('Grade', ('score', 'weight'))  #Grade와 namedtuple의 Grade는 맞추는것을 권장 #score, weight가 튜플의 값에 이름이됨., type은 클래스
```

불변 데이터 클래스는 위치 인수나 키워드 인수로 생성할 수 있다. 필드는 이름이 붙은 속성으로 접근할 수 있다. 이름이 붙은 속성이 있으면 나중에 요구 사항이 또 변해서 단순 데이터 컨테이너에 동작을 추가해야 할 때 namedtuple에서 직접 작성한 클래스로 쉽게 바꿀 수 있다.

[자세히](https://thrillfighter.tistory.com/454)

>#namedtuple의 제약
>
>namedtuple이 여러 상황에서 유용하긴 하지만 장점보다 단점을 만들어낼 수 있는 상황도 알자
>
>- namedtuple로 만들 클래스에 기본 인수 값을 설정할 수 없다.
>
>   그래서 데이터에 선택적인 속성이 많으면 다루기 힘들어진다. 속성을 사용할 때는 클래스를 직접 정의하는 게 나을 수 있다.
>
>- namedtuple인스턴스의 속성 값을 여전히 숫자로 된 인덱스와 순회 방법으로 접근할 수 있다. 특히 외부 API로 노출한 경우에는 의도와 다르게 사용되어 나중에 실제 클래스로 바꾸기 더 어려울 수도 있다. namedtuple 인스턴스를 사용하는 방식을 모두 제어할 수 없다면 클래스를 직접 정의하는 게 낫다.

다음으로 성적들을 담은 단일 과목을 표현하는 클래스를 만들어보자

```python
import collections
Grade = collections.namedtuple('Grade', ('score', 'weight'))  #Grade와 namedtuple의 Grade는 맞추는것을 권장 #score, weight가 튜플의 값에 이름이됨.

class Subject(object):
    def __init__(self):
        self._grades = []

    def report_grade(self, score, weight):
        self._grades.append(Grade(score, weight))

    def average_grade(self):
        total, total_weight = 0, 0
        for grade in self._grades:
            total += grade.score * grade.weight #이렇게 클래스처럼 그 값에 접근가능함
            total_weight += grade.weight
        return total / total_weight
```

이제 한 학생이 공부한 과목들을 표현하는 클래스를 작성해보자

```python
class Student(object):
    def __init__(self):
        self._subjects = {}

    def subject(self, name):
        if name not in self._subjects:
            self._subjects[name] = Subject()
        return self._subjects[name]

    def average_grade(self):
        total, count = 0, 0
        for subject in self._subjects.values():
            total += subject.average_grade()
            count += 1
        return total / count
```

마지막으로 학생의 이름을 키로 사용해 동적으로 모든 학생을 담을 컨테이너를 작성한다.

```python
class Gradebook(object):
    def __init__(self):
        self._students = {}

    def student(self, name):
        if name not in self._students:
            self._students[name] = Student()
        return self._students[name]
```

이 세 클래스의 코드 줄 수는 이전에 구현한 코드의 두 배에 가깝다. 하지만 이 코드가 휠씬 이해하기 쉽다. 이 클래스들을 사용하는 예제도 더 명확하고 확장하기 쉽다.

```python
book = Gradebook()
albert = book.student('Albert Einstein')
math = albert.subject('Math')
math.report_grade(80, 0.10)
math.report_grade(80, 0.10)
math.report_grade(70, 0.80)
gym = albert.subject('Gym')
gym.report_grade(100, 0.40)
gym.report_grade(85, 0.60)
print(albert.average_grade())

>>>
81.5
```

필요하면 이전 형태의 API 스타일로 작성한 코드를 새로 만든 객체 계층 스타일로 바꿔주는 하위 호환용 메서드를 작성해도 된다

### 정리

- 다른 딕셔너리나 긴 튜플을 값으로 담은 딕셔너리를 생성하지 말자
- 정식 클래스의 유연성이 필요 없다면 가벼운 불변 데이터 컨테이너에는 namedtuple을 사용하자
- 내부 상태를 관리하는 딕셔너리가 복잡해지면 여러 헬퍼 클래스를 사용하는 방식으로 관리 코드를 바꾸자

## 인터페이스가 간단하면 클래스 대신 함수를 받자 (B23)

파이썬 내장 API의 상당수에는 함수를 넘겨서 동작을 사용자화하는 기능이 있다. API는 이런 후크(hook)를 이용해서 여러분의 작성한 코드를 실행 중에 호출한다. 

예를 들어 list타입의 sort메서드는 정렬에 필요한 각 인덱스의 값을 결정하는 선택적인 key인수를 받는다. 다음코드에서는 lambda 표현식을 key후크로 넘겨서 이름 리스트를 길이로 정렬한다.

```python
names = ['Socrates', 'Archimedes', 'Plato', 'Aristotle']
names.sort(key=lambda x: len(x))
print(names)
```

다른 언어에서라면 후크를 추상 클래스로 정의할 것이라고 예상할 수있다. 하지만 파이썬의 후크 중 상당수는 인수와 반환 값을 잘 정의해놓은 단순히 상태가 없는 함수다. 함수는 클래스보다 설명하기 쉽고 정의하기도 간단해서 후크로 쓰기에 이상적이다. 함수가 후크로 동작하는 이유는 파이썬이 일급 함수(firse-class function)을 갖췄기 때문이다. 다시 말해, 언어에서 __함수와 메서드를 다른 값처럼 전달하고 참조할 수 있기 때문이다.__

예를 들어 defaultdict 클래스의 동작을 사용자화한다고 해보자(B46참조)

> defaultdict은 말그대로 키에 해당하는 값을 입력하지 않았을때 default값을 대신 넣어주는 dict

이 자료 구조는 찾을 수 없는 키에 접근할 때마다 호출될 함수를 받는다. defaultdict에 넘길 함수는 딕셔너리에서 찾을 수 없는 키에 대응할 기본값을 반환해야 한다. 다음은 키를 찾을 수 없을 때마다 로그를 남기고 기본값으로 0을 반환하는 후크를 정의한 코드다.

```python
from collections import defaultdict

def log_missing():
    print('Key added')
    return 0
```

초깃값을 담은 딕셔너리와 원하는 증가 값 리스트로 log_missing 함수를 두번(각각 'red'와 'orange'일때)실행하여 로그를 출력하게 해보자

```python
current = {'green': 12, 'blue': 3}
increments = [
    ('red', 5),
    ('blue', 17),
    ('orange', 9),
]
result = defaultdict(log_missing, current)  #첫번째 인자는 default값, 두번째는 사전줌
print('Before:', dict(result))
for key, amount in increments:
    result[key] += amount
print('After: ', dict(result))



>>>
Before: {'green': 12, 'blue': 3}
Key added
Key added
After:  {'green': 12, 'blue': 20, 'red': 5, 'orange': 9}
```

log_missing같은 함수를 넘기면 결정 동작과 부작용(작용하지않음)을 분리하므로 API를 쉽게 구축하고 테스트할 수 있다.

예를 들어 기본값 후크를 defaultdict에 넘겨서 찾을 수 없는 키의 총 개수를 센다고 해보자. 이렇게 만드는 한 가지 방법은 상태 보존 클로저(B15)를 사용하는 것이다. 다음은 상태 보존 클러저를 기본값 후크로 사용하는 헬퍼 함수다.

```python
def increment_with_report(current, increments):
    added_count = 0

    def missing():
        nonlocal added_count  # 상태 보존 클로저
        added_count += 1
        return 0

    result = defaultdict(missing, current)
    for key, amount in increments:
        result[key] += amount

    return result, added_count
```

> nonlocal + 변수 를 설정하면 지금 함수 밖에서 정의된 변수를 변경할수있다.(현재 위치에서 가장 가까운 지역변수불러옴)

defaultdict는 missing 후크가 상태를 유지한다는 사실을 모르지만, increment_with_report 함수를 실행하면 튜플의 요소로 기대한 개수인 2를 얻는다. 이는 간단한 함수를 인터페이스용으로 사용할 때 얻을 수 있는 또 다른 이점이다. 클로저 안에 상태를 숨기면 나중에 기능을 추가하기도 쉽다.

```python
result, count = increment_with_report(current, increments)
print(count)
assert count == 2
print(result)
>>>
2
defaultdict(<function increment_with_report.<locals>.missing at 0x1114f8cb0>, {'green': 12, 'blue': 20, 'red': 5, 'orange': 9})
```

상태 보존 후크용으로 클로저를 정의할 때 생기는 문제는 상태가 없는 함수의 예제보다 이해하기 어렵다는 점이다. 

또 다른 방법은 보존할 상태를 캡슐화하는 작은 클래스를 정의하는 것이다.

```python
class CountMissing(object):
    def __init__(self):
        self.added = 0

    def missing(self):
        self.added += 1
        return 0
```

다른 언어에서라면 이제 CountMissing의 인터페이스를 수용하도록 defaultdict를 수정해야 한다고 생각할 것이다. 하지만 파이썬에서는 일급 함수 덕분에 객체로 CountMissing.missing 메서드를 직접 참조해서 defaultdict의 기본값 후크로 넘길 수 있다. 메서드가 함수 인터페이스를 충족하는 건 자명하다.

```python
counter = CountMissing()
result = defaultdict(counter.missing, current)  # Method reference
for key, amount in increments:
    result[key] += amount
assert counter.added == 2
print(result)
```

헬퍼(같은 로직반복시 따로때어내는것)  클래스로 상태 보존 클로저의 동작을 제공하는 방법이 앞에서 increment_with_report 함수를 사용한 방법보다 명확하다. 그러나 CountMissing 클래스 자체만으로는 용도가 무엇인지 바로 이해하기 어렵다. 누가 CountMissing 객체를 생성? 누가 missing메서드를 호출? 나중에 다른 공개 메서드를 클래스에 추가할 일이 있을까? defaultdict와 연계해서 사용한 예를 보기 전까지는 이 클래스가 수수께끼로 남는다.

파이썬에서는 클래스에 \_\_call \_\_ 이라는 특별한 메서드를 정의해서 이런 상황을 명확하게 할 수 있다.  \_\_call \_\_ 메서드는 객체를 함수처럼 호출할 수 있게 해준다. 또한 내장 함수 callable이 이런 인스턴스에 대해서는 True를 반환하게 만든다. 

```python
class BetterCountMissing(object):
    def __init__(self):
        self.added = 0

    def __call__(self):
        self.added += 1
        return 0

counter = BetterCountMissing()
counter()
print(counter.added)
counter()
print(counter.added)
callable(counter)

>>>
1
2
```

다음은 BetterCountMissing 인스턴스를 defaultdict의 기본값 후크로 사용하여 딕셔너리에 없어서 새로 추가된 키의 개수를 알아내는 코드다.(추가로 계속 불러내면 어떻게 되는지 예제코드 넣었다.)

```python
counter = BetterCountMissing()
result = defaultdict(counter, current)  # __call__이 필요함,  객체를 함수처럼 호출됨
for key, amount in increments:
    result[key] += amount
assert counter.added == 2
print(result)
```

이 예제가 CountMissing.missing 예제보다 명확하다.  \_\_call \_\_ 메서드는 (API 후크처럼) 함수 인수를 사용하기 적합한 위치에 클래스의 인스턴스를 사용할 수 있다는 사실을 드러낸다. 이 코드를 처음 보는 사람을 클래스의 주요 동작을 책임지는 진입점(entry point)으로 안내하는 역할도 한다. 클래스의 목적이 상태 보존 클로저로 동작하는 것이라는 강력한 힌트가 된다!

무엇보다도  \_\_call \_\_ 을 사용할 때 defaultdict은 여전히 무슨일이 일어나는지도 모른다. defaultdict에 필요한건 기본값 후크용 함수뿐이다. 파이썬은 하고자 하는 작업에 따라 간단한 함수 인터페이스를 충족하는 다양한 방법을 제공한다.

### 정리

- 파이썬에서 컴포넌트 사이의 간단한 인터페이스용으로 클래스를 정의하고 인스턴스를 생성하는 대신에 함수만 써도 종종 충분하다.
- 파이썬에서 함수와 메서드에 대한 참조는 일급이다. 즉, 다른 타입처럼 표현식에서 사용할 수 있다
-  __\_\_call \_\_ 이라는 특별한 메서드는 클래스의 인스턴스를 일반 파이썬 함수처럼 호출할 수 있게 해준다__
- __상태를 보존하는 함수가 필요할 때 상태 보존 클로저를 정의하는 대신  \_\_call \_\_ 메서드를 제공하는 클래스를 정의하는 방안을 고려하자(B15참조)__

## 객체를 범용으로 생성하려면 @classmethod 다형성을 이용하자(B24) (???)

파이썬에서는 객체가 다형성을 지원할 뿐만 아니라 클래스도 다형성을 잘 지원한다.

이게 무슨 의미? 장점은?

다형성은 계층 구조에 속한 여러 클래스가 자체의 메서드를 독립적인 버전으로 구현하는 방식이다. 다형성을 이용하면 여러 클래스가 같은 인터페이스나 추상 기반 클래스를 충족하면서도 다른 기능을 제공할 수 있다. (B28 참조)

예를 들어 맵리듀스(MapReduce)구현을 작성할 때 입력 데이터를 표현할 공통 클래스가 필요하다고 하자. 다음은 서브클래스에서 정의해야 하는 read 메서드가 있는 입력 데이터 클래스다.

```python
class InputData(object):
    def read(self):
        raise NotImplementedError
```

다음은 디스크에 있는 파일에서 데이터를 읽어오도록 구현한 InputData의 서브 클래스다.

```python
class PathInputData(InputData):
    def __init__(self, path):
        super().__init__()
        self.path = path

    def read(self):
        return open(self.path).read()
```

PathInputData 같은 InputData 서브클래스(종속받음)가 몇 개든 있을 수 있고, 각 서브클래스에서는 처리할 바이트 데이터를 반환하는 표준 인터페이스인 read를 구현할 것이다. 다른 InputData 서브클래스는 네트워크에서 데이터를 읽어오거나 데이터의 압축을 해제하는 기능 등을 할수있다.

표준 방식으로 입력 데이터를 처리하는 맵리듀스 작업 클래스에도 비슷한 추상 인터페이스가 필요하다.

```python
class Worker(object):
    def __init__(self, input_data):
        self.input_data = input_data
        self.result = None

    def map(self):
        raise NotImplementedError

    def reduce(self, other):
        raise NotImplementedError
```

다음은 적용하려는 특정 맵리듀스 함수를 구현한 Worker의 구체 서브클래스다(간단한 줄바꿈 카운터)

```python
class LineCountWorker(Worker):
    def map(self):
        data = self.input_data.read()
        self.result = data.count('\n')

    def reduce(self, other):
        self.result += other.result
```

이렇게 구현하면 잘 동작할 것처럼 보이지만 결국 큰 문제에 직면한다. 이 모든 코드 조각을 무엇으로 연결할 것인가? 적절히 인터페이스를 설계하고 추상화한 클래스들이지만 일단 객체를 생성한 후에나 유용하다. 무엇으로 객체를 만들고 맵리듀스를 조율할까?

가장 간단한 방법은 헬퍼 함수로 직접 객체를 만들고 연결하는 것이다. 다음은 디렉터리의 내용을 나열하고 그 안에 있는 각 파일로 PathInputData인스턴스를 생성하는 코드다.

```python
import os

def generate_inputs(data_dir):
    for name in os.listdir(data_dir):
        yield PathInputData(os.path.join(data_dir, name))

```

다음으로 generate_inputs 함수에서 반환한 InputData 인스턴스를 사용하는 LineCountWorker인스턴스를 생성한다.

```python
def create_workers(input_list):
    workers = []
    for input_data in input_list:
        workers.append(LineCountWorker(input_data))
    return workers
```

map 단계를 여러 스레드로 나눠서 이 Worker인스턴스들을 실행한다(B37참조). 그런 다음 reduce를 반복적으로 호출해서 결과를 최종값 하나로 합친다.

```python
from threading import Thread

def execute(workers):
    threads = [Thread(target=w.map) for w in workers]
    for thread in threads: thread.start()
    for thread in threads: thread.join()

    first, rest = workers[0], workers[1:]
    for worker in rest:
        first.reduce(worker)
    return first.result
```

마지막으로 단계별로 실행하려고 mapreduce 함수에서 모든 조각을 연결한다.

```python
def mapreduce(data_dir):
    inputs = generate_inputs(data_dir)
    workers = create_workers(inputs)
    return execute(workers)
```

테스트용 입력 파일로 이 함수를 실행해보면 잘 동작한다.

```python
from tempfile import TemporaryDirectory
import random

def write_test_files(tmpdir):
    for i in range(100):
        with open(os.path.join(tmpdir, str(i)), 'w') as f:
            f.write('\n' * random.randint(0, 100))

with TemporaryDirectory() as tmpdir:
    write_test_files(tmpdir)
    result = mapreduce(tmpdir)

print('There are', result, 'lines')
```

무엇이 문제일까? 큰 문제는 mapreduce 함수가 전혀 범용적이지 않다는 점이다. 다른 InputData나 Worker 서브클래스를 작성한다면 generate_inputs, create_workers, mapreduce 함수를 알맞게 다시 작성해야한다.

이 문제는 결국 __객체를 생성하는 범용적인 방법의 필요성__으로 귀결된다. 다른 언어에서는 이 문제를 생성자 다형성으로 해결한다. 이 방식을 따르면 각 InputData 서브클래스에서 맵리듀스를 조율하는 헬퍼 메서드가 범용적으로 사용할 수 있는 특별한 생성자를 제공해야 한다. __문제는 파이썬이 단일 생성자 메서드 \_\_init\_\_ 만을 허용한다는 점이다. 결국 모든 InputData 서브클래스가 호환되는 생성자를 갖춰야 한다는 것 터무니없는 요구 사항이다.__

__이 문제를 해결하는 가장 좋은 방법은 @classmethod 다형성을 이용하는 것이다.__ @classmethod 다형성은 생성된 객체가 아니라 전체 클래스에 적용된다는 점만 빼면 InputData.read에 사용한 인스턴스 메서드 다형성과 똑같다.

이 발상을 맵리듀스 관련 클래스에 적용하자. 여기서는 공통 인터페이스를 사용해 새 InputData 인스턴스를 생성하는 범용 클래스 메서드로 InputData 클래스를 확장한다.

```python
class GenericInputData(object):
    def read(self):
        raise NotImplementedError

    @classmethod
    def generate_inputs(cls, config):
        raise NotImplementedError
```

generate_inputs 메서드는 GenericInputData를  구현하는 서브클래스가 해석할 설정 파라미터들을 담은 딕셔너를 받는다. 다음 코드에서는 입력 파일들을 얻어올 디렉터리를 config로 알아낸다.

```python
class PathInputData(GenericInputData):
    def __init__(self, path):
        super().__init__()
        self.path = path

    def read(self):
        return open(self.path).read()

    @classmethod
    def generate_inputs(cls, config):
        data_dir = config['data_dir']
        for name in os.listdir(data_dir):
            yield cls(os.path.join(data_dir, name)) #cls()를 호출해서 클래스 인스턴스로 만듬
```

비슷하게 GenericWorker 클래스에 create_workers 헬퍼를 작성한다. 여기서는 input\_class 파라미터(GenericInputData의 서브클래스여야함)로 필요한 입력을 만들어낸다. cls()를 범용 생성자로 사용해서 GenericWorker를 구현한 서브클래스의 인스턴스를 생성한다.

```python
class GenericWorker(object):
    def __init__(self, input_data):
        self.input_data = input_data
        self.result = None

    def map(self):
        raise NotImplementedError

    def reduce(self, other):
        raise NotImplementedError

    @classmethod
    def create_workers(cls, input_class, config):
        workers = []
        for input_data in input_class.generate_inputs(config):
            workers.append(cls(input_data))  #cls()를 호출해서 클래스 인스턴스로 만듬
        return workers
```

위의 input_class.generate_inputs호출이 바로 여기서 보여주려는 클래스 다형성다. 또한 create_workers가  \_\_init\_\_ 메서드를 직접 사용하지 않고 GenericWorker를 생성하는 또 다른 방법으로 cls를 호출함을 알 수 있다.

GenericWorker를 구현할 서브클래스는 부모 클래스만 변경하면 된다.

```python
class LineCountWorker(GenericWorker):
    def map(self):
        data = self.input_data.read()
        self.result = data.count('\n')

    def reduce(self, other):
        self.result += other.result
```

드디어 mapreduce함수를 완전히 범용적으로 재작성할 차례다

```python
def mapreduce(worker_class, input_class, config):
    workers = worker_class.create_workers(input_class, config)
    return execute(workers)
```

​	테스트용 파일로 새로운 작업 클래스 객체를 실행하면 이전에 구현한 것과 같은 결과가 나온다. 차이는 mapreduce함수가 범용적으로 동작하려고 더 많은 파라미터를 요구한다는 점이다

```python
with TemporaryDirectory() as tmpdir:
    write_test_files(tmpdir)
    config = {'data_dir': tmpdir}
    result = mapreduce(LineCountWorker, PathInputData, config)
print('There are', result, 'lines')
```

이제 GenericInputData와 GenericWorker의 다른 서브클래스를 원하는 대로 만들어도 글루 코드(glue code)를 작성할 필요가 없다.

### 정리

- 파이썬에서는 클래스별로 생성자를 한개 (\_\_init\_\_ 메서드)로만 만들 수 있다
- 클래스에 필요한 다른 생성자를 정의하려면 @classmethod 를 이용하자
- 구체 서브클래스들을 만들고 연결하는 범용적인 방법을 제공하려면 클래스 메서드 다형성을 이용하자.
- ~~솔직히 하나도 모르겠다..그냥 느낌만 알고 실제 사용하려면 오래걸리겠지만 반드시 이해해야하는내용~~

## super로 부모 클래스를 초기화하자(B25)

기존에는 자식 클래스에서 부모 클래스의 \_\_init\_\_ 메서드를 직접 호출하는 방법으로 부모 클래스를 초기화했다.

```python
class MyBaseClass(object):
    def __init__(self, value):
        self.value = value

class MyChildClass(MyBaseClass):
    def __init__(self):
        MyBaseClass.__init__(self, 5)

    def times_two(self):
        return self.value * 2

foo = MyChildClass()
print(foo.times_two())
```

이 방법은 간단한 계층 구조에는 잘  동작하지만, 많은 경우 제대로 동작못한다.

클래스가 다중 상속(보통은 피해야 할 방법이다.)(B26)의 영향을 받는다면 위의 방법인 슈퍼클래스의  \_\_init\_\_ 메서드를 직접 호출하는 행위는 예기치 못한 동작을 일으킬 수 있다.

한 가지 문제는  \_\_init\_\_ 의 호출 순서가 모든 서브클래스에 걸쳐 명시되어 있지 않다는 점이다.

예를 들어 인스턴스의 value 필드로 연산을 수행하는 부모 클래스 두 개를 정의해보자

```python
class TimesTwo(object):
    def __init__(self):
        self.value *= 2

class PlusFive(object):
    def __init__(self):
        self.value += 5
```

다음 클래스는 한 가지 순서로 부모 클래스들을 정의한다.

```python
class OneWay(MyBaseClass, TimesTwo, PlusFive):
    def __init__(self, value):
        MyBaseClass.__init__(self, value)
        TimesTwo.__init__(self)
        PlusFive.__init__(self)
```

이 클래스의 인스턴스를 생성하면 부모 클래스의 순서와 일치하는 결과가 만들어진다.

```python
foo = OneWay(5)
foo.value
print('First ordering is (5 * 2) + 5 =', foo.value)

>>>
First ordering is (5 * 2) + 5 = 15

```

다음은 같은 부모 클래스들을 다른 순서로 정의한 클래스다.

```python
class AnotherWay(MyBaseClass, PlusFive, TimesTwo):
    def __init__(self, value):
        MyBaseClass.__init__(self, value)
        TimesTwo.__init__(self)
        PlusFive.__init__(self)
```

하지만 부모 클래스 생성자   TimesTwo.\_\_init\_\_ ,  PlusFive. \_\_init\_\_ 를 이전과 같은 순서로 호출한다. 이 클래스의 동작은 부모 클래스를 정의한 순서와 일치하지 않는다.(당연한거 아닌가,,)

```python
bar = AnotherWay(5)
print('Second ordering still is', bar.value)

>>>
Second ordering still is 15
```

다른 문제는 다이아몬드 상속(diamond inheritance)이다. 다이아몬드 상속은 서브클래스가 계층 구조에서 같은 슈퍼클래스를 둔 서로 다른 두 클래스에서 상속받을 때 방생한다. 다이아몬드 상속은 공통 슈퍼클래스의 \_\_init\_\_ 메서드를 여러 번 실생하게 해서 예상치 못한 동작을 일으킨다. 예를 들어 MyBaseClass에서 상속받는 자식 클래스 두개를 정의해보자

```python
class TimesFive(MyBaseClass):
    def __init__(self, value):
        MyBaseClass.__init__(self, value)
        self.value *= 5

class PlusTwo(MyBaseClass):
    def __init__(self, value):
        MyBaseClass.__init__(self, value)
        self.value += 2
```

다음으로 이 두 클래스 모두에서 상속받은 자식 클래스를 정의하여 MyBaseClass를 다이아몬드의 꼭대기로 만든다.

```python
class ThisWay(TimesFive, PlusTwo):
    def __init__(self, value):
        TimesFive.__init__(self, value)
        PlusTwo.__init__(self, value)

foo = ThisWay(5)
print('Should be (5 * 5) + 2 = 27 but is', foo.value)
```

(5*5)+2=27이라고 생각하여 결과는 27예상된다. 하지만 두 번째 부모 클래스의 생성자 PlusTwo.\_\_init\_\_ 를 호출하는 코드가 있어서 MyBaseClass.\_\_init\_\_ 가 두 번째 호출될 때 self.value를 다시 5로 리셋된다.!(그래서 7이나왔잖어)

파이썬 2.2에서는 이 문제를 해결하려고 super라는 내장 함수를 추가하고 메서드 해석 순서(MRO, Method Resolution Order)를 정의했다. MRO는 어떤 슈퍼클래스부터 초기화하는지를 정한다.(예를 들면 깊이 우선, 왼쪽에서 오른쪽으로). 또한 다이아몬드 계층 구조에 있는 공통 슈퍼클래스를 단 한 번만 실행하게 된다.

다음 코드는 다이아몬드 클래스 구조지만 super(파이썬 2 스타일)로  부모 클래스를 초기화한다.

```python
class MyBaseClass(object):
    def __init__(self, value):
        self.value = value

class TimesFiveCorrect(MyBaseClass):
    def __init__(self, value):
        super(TimesFiveCorrect, self).__init__(value)
        self.value *= 5

class PlusTwoCorrect(MyBaseClass):
    def __init__(self, value):
        super(PlusTwoCorrect, self).__init__(value)
        self.value += 2
```

이제 다이아몬드의 꼭대기인MyBaseClass.\_\_init\_\_가 한 번만 실행된다. 다른 부모 클래스는 class 문으로 지정한 순서대로 실행된다.

```python
class GoodWay(TimesFiveCorrect, PlusTwoCorrect): #이 순서가 MRO 중요함!!!
    def __init__(self, value):
        super(GoodWay, self).__init__(value)
        
foo = GoodWay(5)
print('Should be 5*(5+2)=35 and is', foo.value)

before_pprint = pprint
pprint(GoodWay.mro())
```

이 순서는 뒤에서부터 시작하는 것 같다. TimesFiveCorrect.\_\_init\_\_를 먼저 실행할 수 없을까? 그래서 결과가 (5*5)+2 = 27이 되도록!!

정답은 '불가능하다', 이 순서는 이 클래스에 대해 MRO가 정의하는 순서와 일치한다. MRO순서는 mro라는 클래스 메서드로 알수 있다.(만약 GooWay에서 (PlusTwoCorrect,TimesFiveCorrect)이렇게 하면 mro순서가 바뀌므로 27만들기가능)

```python
from pprint import pprint
pprint(GoodWay.mro())
pprint = pprint

>>>
[<class '__main__.GoodWay'>,
 <class '__main__.TimesFiveCorrect'>,
 <class '__main__.PlusTwoCorrect'>,
 <class '__main__.MyBaseClass'>,
 <class 'object'>]
```

GoodWay(5)를 호출하면 이 생성자는 TimesFiveCorrect.\_\_init\_\_를 호출하고, 이는 PlusTwoCorrect.\_\_init\_\_ 를 호출하며, 이는 다시 MyBaseClass.\_\_init\_\_를 호출한다. 이런 호출이 다이아몬드의 꼭대기에 도달하면, 모든 초기화 메서드는 실체 \_\_init\_\_함수가 호출된 순서의 역순으로 실행된다. MyBaseClass.\_\_init\_\_는 5라는 값을 value에 할당하고, PlusTwoCorrect.\_\_init\_\_는 2를 더해서 value가 7이 된다. TimesFiveCorrect.\_\_init\_\_는 그 값을 5와 곱해서 value는 35가 된다.

내장 함수 super는 제대로 동작하지만, 파이썬2 에서 여전히 주목할 만한 두 가지 문제가 있다.

- 문법이 좀 장황하다. 현재 정의하는 클래스, self 객체, 메서드 이름(보통 \_\_init\_\_)과 모든 인수를 설정해야 한다. 이런 생성 방법은 파이썬을 처음 접하는 프로그래머에서 혼란을 준다
- super를 호출하면서 현재 클래스의 이름을 지정해야 한다. 클래스의 이름을 변경(클래스 계층 구조를 개선할 때 아주 흔히 하는 조치다)하면 super를 호출하는 모든 코드를 수정해야한다.

다행히 파이썬 3에서는 super를 인수 없이 호출하면 \_\_class\_\_와 self를 인수로 넘겨서 호출한 것으로 처리해서 이 문제를 해결한다. 파이썬 3에서는 항상 super를 사용해야한다. super는 명확하고 간결하며 항상 제대로 동작하기 때문이다.

```python
class Explicit(MyBaseClass):
    def __init__(self, value):
        super(__class__, self).__init__(value * 2) #__class__는 현재 Explicit #__class__는 파이썬3에만 정의되어있다. #이 코드에서는 self.value = value*2를 아래 적지않고 식까지 넘겨버렸네

class Implicit(MyBaseClass):
    def __init__(self, value):
        super().__init__(value * 2)

assert Explicit(10).value == Implicit(10).value
```

파이썬 3에서는 \_\_class\_\_ 변수를 사용한 메서드에서 현재 클래스를 올바르게 참조하도록 해주므로 위의 코드가 잘 동작한다. 하지만 파이썬 2에서는 \_\_class\_\_가 정의되어 있지 않아 제대로 동작하지 않는다. super의 인수로 self.\_\_class\_\_ 를 사용하면 될거라고 생각할 수있지만, 파이썬2의 super구현방식 때문에 제대로 동작하지 않는다.

### 정리

- 파이썬의 표준 메서드 해석 순서(MRO)는 슈퍼클래스의 초기화 순서와 다이아몬드 상속 문제를 해결한다.
- 항상 내장 함수 super로 부모 클래스를 초기화하자.

## 믹스인 유틸리티 클래스에만 다중 상속을 사용하자 (B26)(???)

파이썬은 다중 상속을 다루기 쉽게 하는 기능을 내장한 객체 지향 언어다(B25). 하지만 다중 상속은 아예 안 하는  게 좋다.

다중 상속으로 얻는 편리함과 캡슐화가 필요하다면 대신 믹스인(mix-in)을 작성하는 방안을 고려하자. 믹스인이란 클래스에서 제공해야 하는 추가적인 메서드만 정의하는 작은 클래스를 말한다. 믹스인 클래스는 자체의 인스턴스 속성(attribute)을 정의하지 않으며  \_\_init\_\_ 생성자를 호출하도록 요구하지도 않는다.

__파이썬에서는 타입과 상관없이 객체의 현재 상태를 간단하게 조사할 수 있어서 믹스인을 쉽게 작성할 수있다. 동적 조사(dynamic inspection)를 이용하면 많은 클래스에 적용할 수 있는 범용 기능을 믹스인에 한 번만 작성하면 된다.__ 믹스인들을 조합하고 계층으로 구성하면 반복 코드를 최소화하고 재사용성을 극대화할 수 있다.

예를 들어 파이썬 객체를 메모리 내부 표현에서 직렬화(serialization)용 딕셔너리로 변환하는 기능이 필요하다고 해보자. 이 기능을 모든 클래스에서 사용할 수 있게 범용으로 작성하는 건 어떨까?

다음은 상속받는 모든 클래스에 추가될 새 공개 메서드로 이 기능을 구현하는 믹스인이다.

```python
from pprint import pprint

class ToDictMixin(object):
    def to_dict(self):
        return self._traverse_dict(self.__dict__) #클래스의 네임스페이스를 반환함(클래스.__dict__)
```

세부 구현은 직관적이며 hasattr을 사용한 동적 속성 접근, isinstance를 사용한 동적 타입 검사, 인스턴스 딕셔너리 \_\_dict\_\_를 이용한다.

__클래스 네임스페이스 개념도 알아야함([자세히](https://wikidocs.net/1743))__

> - hasattr(object, name)
>
>   object안에 name에 해당하는 attribute가 있으면 True
>
> - isinstance(mylist, list)
>
>   mylist가 list임을 알아봅니다 이렇게 class, str, int, float가능
>
> ```python
> class foobar():
>     data = [1,2,3,4]
>     def __init__(self, val):
>         self.val = val
>         
> x = foobar
> y = foobar(['a','b'])
> z = foobar([1,2])
> 
> hasattr(x, 'data')
> >>>
> True
> 
> hasattr(x, 'val')
> >>>
> false
> 
> delattr(x, 'data') #attr삭제가능
> hasattr(x, 'data')
> >>>
> false
> 
> 
> #isinstance 사용예시
> simclass = CSimple()
> isinstance(simclass, CSimple)
> 
> ```

```python
#위에 클래스 안에 이어서   
   def _traverse_dict(self, instance_dict):
        output = {}
        for key, value in instance_dict.items():
            output[key] = self._traverse(key, value)
        return output

    def _traverse(self, key, value):
        if isinstance(value, ToDictMixin):
            return value.to_dict()
        elif isinstance(value, dict):
            return self._traverse_dict(value)
        elif isinstance(value, list):
            return [self._traverse(key, i) for i in value]
        elif hasattr(value, '__dict__'):
            return self._traverse_dict(value.__dict__)
        else:
            return value
```

다음은 바이너리 트리(binary tree)를 딕셔너리로 표현하려고 믹스인을 사용하는 예제 클래스다.

```python
class BinaryTree(ToDictMixin):
    def __init__(self, value, left=None, right=None):
        self.value = value
        self.left = left
        self.right = right
```

이제 수많은 관련 파이썬 객체를 딕셔너리로 손쉽게 변환할 수 있다.

```python
tree = BinaryTree(10,
    left=BinaryTree(7, right=BinaryTree(9)),
    right=BinaryTree(13, left=BinaryTree(11)))
print(tree.to_dict())
```

믹스인의 가장 큰 장점은 범용 기능을 교체할 수 있게 만들어서 요할 때 동작을 오버라이드할 수 있다는 점이다.

예를 들어 다음은 부모 노드에 대한 참조를 저장하는 BinaryTree의 서브클래스다. 이 순환 참조(circular reference)는 ToDictMixin.to_dict의 기본 구현이 무한 루프에 빠지게 만든다.(???)

```python
class BinaryTreeWithParent(BinaryTree):
    def __init__(self, value, left=None,
                 right=None, parent=None):
        super().__init__(value, left=left, right=right)
        self.parent = parent
```

해결책은 BinaryTreeWithParent 클래스에서 ToDictMixin._traverse 메서드를 오버라이드해서 믹스인이 순환에 빠지지 않도록 필요한 값만 처리하게 하는 것이다. 다음은 _traverse 메서드를 오버라이드해서 부모를 탐색하지 않고 부모의 숫자 값만 꺼내오게 만든 예제다.

```python
#위에 클래스와 잇기. 오버라이드    
    def _traverse(self, key, value):
        if (isinstance(value, BinaryTreeWithParent) and
                key == 'parent'):
            return value.value  # 순환 방지
        else:
            return super()._traverse(key, value)
```

순환 참조 속성을 따라가지 않으므로 BinaryTreeWithParent.to_dict를 호출하는 코드는 문제 없이 동작한다.

```python
root = BinaryTreeWithParent(10)
root.left = BinaryTreeWithParent(7, parent=root)
root.left.right = BinaryTreeWithParent(9, parent=root.left)
orig_print = print
print = pprint
print(root.to_dict())
print = orig_print
```

BinaryTreeWithParent._traverse를 정의한 덕분에BinaryTreeWithParent타입의 속성이 있는 클래스라면 무엇이든 자동으로  ToDictMixin으로 동작할수 있게 됫다.

```python
class NamedSubTree(ToDictMixin):
    def __init__(self, name, tree_with_parent):
        self.name = name
        self.tree_with_parent = tree_with_parent

my_tree = NamedSubTree('foobar', root.left.right)
orig_print = print
print = pprint
print(my_tree.to_dict())  # No infinite loop
print = orig_print
```

믹스인을 조합할 수 있다.

예를 들어 어떤 클래스에도 동작하는 범용 JSON 직렬화를 제공하는 믹스인이 필요하다고 해보자. 이 믹스인은 클래스에 to_dict메서드(ToDictMixin 클래스에서 제공할 수도 있고 그렇지 않을 수도 있다.)가 있다고 가정하고 만들면 된다. 

```python
import json

class JsonMixin(object):
    @classmethod
    def from_json(cls, data):
        kwargs = json.loads(data)
        return cls(**kwargs)

    def to_json(self):
        return json.dumps(self.to_dict())
```

JsonMixin 클래스가 어떻게 인스턴스 메서드와 클래스 메서드를 둘다 정의하는 지 주목하자. 믹스인을 이용하면 이 두 종류의 동작을 추가 할 수 있다. 이 예제에서 JsonMixin의 요구 사항은 클래스에 to_dict 메서드가 있고 해당 클래스의 \_\_init\_\_메서드에서 키워드 인수를 받는다는 것뿐이다(B19참조)

이 믹스인을 이용하면 짧은 반복 코드로 JSON으로 직렬화하고  JSON에서 역직렬화하는 유틸리티 클래스의 계층 구조를 간단하게 생성할 수 있다.

예를 들어 다음은 데이터센터 토폴로지를 구성하 부분들을 표현하는 데이터 클래스의 계층이다

```python
class DatacenterRack(ToDictMixin, JsonMixin):
    def __init__(self, switch=None, machines=None):
        self.switch = Switch(**switch)
        self.machines = [
            Machine(**kwargs) for kwargs in machines]

class Switch(ToDictMixin, JsonMixin):
    def __init__(self, ports=None, speed=None):
        self.ports = ports
        self.speed = speed

class Machine(ToDictMixin, JsonMixin):
    def __init__(self, cores=None, ram=None, disk=None):
        self.cores = cores
        self.ram = ram
        self.disk = disk
```

이 클래스들을 JSON으로 직렬화하고  JSON에서 역직렬화하는 방법은 간단하다. 여기서는 데이터가 직렬화와 역질렬화를 통해 원래 상태가 되는지 검증한다.

```python
serialized = """{
    "switch": {"ports": 5, "speed": 1e9},
    "machines": [
        {"cores": 8, "ram": 32e9, "disk": 5e12},
        {"cores": 4, "ram": 16e9, "disk": 1e12},
        {"cores": 2, "ram": 4e9, "disk": 500e9}
    ]
}"""

deserialized = DatacenterRack.from_json(serialized)
roundtrip = deserialized.to_json()
assert json.loads(serialized) == json.loads(roundtrip)
```

이런 믹스인을 사용할 때는 클래스가 객체 상속 계층의 상위에서 이미 JsonMinxin을 상속받고 있어도 괜찮다. 결과로 만들어지는 클래스는 같은 방식으로 동작할 것이다.

### 정리

- 믹스인 클래스로 같은 결과를 얻을 수 있다면 다중 상속을 사용하지 말자
- 인스턴스 수준에서 동작을 교체할 수 있게 만들어서 믹스인 클래스가 요구할 때 클래스별로 원하는 동작을 하게 하자
- 간단한 동작들로 복잡한 기능을 생성하려면 믹스인을 조합하자.

## 공개 속성보다는 비공개 속성을 사용하자 (B27)

파이썬에는 클래스 속성의 가시성(visibility)이 공개(public)와 비공개(private) 두 유형밖에 없다.

```python
class MyObject(object):
    def __init__(self):
        self.public_field = 5
        self.__private_field = 10

    def get_private_field(self):
        return self.__private_field
```

공개 속성은 어디서든 객체에 점 연산자(.)를 사용하여 접근할 수 있다.

```python
foo = MyObject()
assert foo.public_field == 5
```

비공개 필드는 속성 이름 앞에 밑줄 두개를 붙여 지정한다. 같은 클래스에 속한 메서드에서만 비공개 필드에 직접 접근할 수 있다

```python
assert foo.get_private_field() == 10 #접근확인
```

하지만 클래스 외부에서 직접 비공개 필드에 접근하면 예외가 일어난다.

```python
try:
    foo.__private_field
except:
    logging.exception('Expected')
else:
    assert False
```

클래스 메서드도 같은 class 블록에 선언되어 있으므로 비공개 속성에 접근할 수 있다.

```python
class MyOtherObject(object):
    def __init__(self):
        self.__private_field = 71

    @classmethod
    def get_private_field_of_instance(cls, instance):
        return instance.__private_field

bar = MyOtherObject()
assert MyOtherObject.get_private_field_of_instance(bar) == 71
```

__비공개 필드라는 용어에서 예상할 수 있듯이 서브클래스에서는 부모 클래스의 비공개 필드에 접근할 수 없다.__

```python
try:
    class MyParentObject(object):
        def __init__(self):
            self.public_field = 5
            self.__private_field = 71
    
    class MyChildObject(MyParentObject):
        def get_private_field(self):
            return self.__private_field
    
    baz = MyChildObject()
    baz.get_private_field()
except:
    logging.exception('Expected')
else:
    assert False
```

비공개 속성의 동작은 간단하게 속성 이름을 변환하는 방식으로 구현된다. 파이썬 컴파일러는 MyChildObject.get\_private\_field 같은 메서드에서 비공개 속성에 접근하는 코드를 발견하면 \_\_private\_field를 \_MyChildObject\_\_private_field에 접근하는 코드로 변환한다.(모든 비공개 속성)

이 예제에서보면 \_\_private\_field가 MyParentObject.\_\_init\_\_ 에만 정의되어있으므로 비공개 속성의 실제 이름은 \_MyParentObject\_\_private\_field가 된다. 자식 클래스에서 부모의 비공개 속성에 접근하는 동작은 단순히 변환된 속성 이름이 일치하지 않아서 실패하는 것이다.

이 체계를 이해하면 접근 권한을 확인하지 않고서도 서브클래스나 외부 클래스에서 어떤 클래스의 비공개 속성이든 쉽게 접근할 수 있다.

```python
assert baz._MyParentObject__private_field == 71
```

객체의 속성 딕셔너리를 들여다보면 실제로 비공개 속성이 변환 후의 이름으로 저장되어있음을 알 수 있다.

```python
print(baz.__dict__) #반드시 해보기
>>>
{'_MyParentObject__private_field': 71, 'public_field': 5}
```

비공개 속성용 문법이 가시성을 엄격하게 강제하지 않는 이유는 뭘까? 가장 간단한 답은 파이썬에서 자주 인용되는 '우리 모두 성인이라는 사실에 동의합니다'라는 좌우명에 있다. 파이썬 프로그래머들은 개방으로 얻는 장점이 폐쇄로 얻는 단점보다 크다고 믿는다.

이외에도 속성에 접근하는 것처럼 언어 기능을 가로채는 기능(B32 참조)이 있으면 마음만 먹으면 언제든지 객체의 내부를 조작할 수 있다. 이렇게 할 수 있다면 파이썬이 비공개 속성에 접하는 것을 막는 게 무슨 가치가 있을까?

파이썬 프로그래머들은 무분별하게 객체의 내부에 접근하는 위험을 최소화하려고 스타일 가이드(B2 참조)에 정의된 명명 관례를 따른다. \_protected\_field처럼 앞에 밑줄 한 개를 붙인 필드를 보호(protected) 필드로 취급해서 클래스의 외부 사용자들이 신중하게 다뤄야 함을 의미한다.

하지만 파이썬을 처음 접하는 많은 프로그래머가 서브클래스나 외부에서 접근하면 안되는 내부 API를 피공개 필드로 나타낸다.

```python
class MyClass(object):
    def __init__(self, value):
        self.__value = value

    def get_value(self):
        return str(self.__value)

foo = MyClass(5)
assert foo.get_value() == '5'
```

이 접근 방식은 잘못되었다. 누군가는 클래스에 새 동작을 추가하거나 기존 메서드의 결함을 해결(위의 코드에서는 MyClass.get_value가 항상 문자열을 반환하는 방법을 사용한다.)하려고 서브클래스를 만들기 마련이다. 비공개 속성을 선택하면 서브클래스의 오버라이드(override)와 확장(extension)을 다루기 어렵고 불안정하게 만들 뿐이다. 나중에 만들 서브클래스에서 꼭 필요하면 여전히 비공개 필드에 접근할 수 있다.

```python
class MyIntegerSubclass(MyClass):
    def get_value(self):
        return int(self._MyClass__value) #이런식으로 접근하면 가능하긴하지....

foo = MyIntegerSubclass(5)
assert foo.get_value() == 5
```

하지만 나중에 클래스의 계층이 변경되면 MyIntegerSubClass 같은 클래스는 비공개 참조가 더는 유효하지 않게 되어 제대로 동작하지 않는다

MyIntegerSubClass 클래스의 직계 부모인 MyClass에 MyBaseClass라는 또 다른 부모 클래스를 추가했다고 하자.

```python
class MyBaseClass(object):
    def __init__(self, value):
        self.__value = value

    def get_value(self):
        return self.__value

class MyClass(MyBaseClass):
    def get_value(self):
        return str(super().get_value())

class MyIntegerSubclass(MyClass):
    def get_value(self):
        return int(self._MyClass__value) #동작안됨. 계층구조바꿈... 동작하려면 return int(self._MyBaseClass__value)이여야함
```

이제 \_\_value 속성을 MyClass 클래스가 아닌 MyBaseClass에서 할당한다. 그러면 MyIntegerSubclass에 있는 비공개 변수 참조인 self.\_MyClass\_\_value가 동작하지 않는다.

```python
try:
    foo = MyIntegerSubclass(5)
    foo.get_value()
except:
    logging.exception('Expected')
else:
    assert False
```

일반적으로 보호 속성을 사용해서 서브클래스가 더 많은 일을 할 수 있게 하는 편이 낫다. 각각의 보호 필드를 문서화해서 서브클래스에서 내부 API 중 어느 것을 쓸 수 있고 어느 것을 그대로 둬야 하는지 설명하자. 이렇게 하면 자신이 작성한 코드를 미래에 안전하게 확장하는 지침이 되는 것처럼 다른 프로그래머에게도 조언이 된다.

```python
class MyClass(object):
    def __init__(self, value):
        # 사용자가 객체에 전달한 값을 저장한다. (This stores the user-supplied value for the object.)
        # 문자열로 강제할 수 있는 값이여야 하며, (It should be coercible to a string. Once assigned for)
        # 객체에 할당하고 나면 불변으로 취급해야 한다.(the object it should be treated as immutable.)
        self._value = value

    def get_value(self):
        return str(self._value)
```

비공개 속성을 사용할지 진지하게 고민할 시점은 서브클래스와 이름이 충돌할 염려가 있을 때뿐이다. 이 문제는 자식 클래스가 서로 모르는 사이에 부모 클래스에서 이미 정의한 속성을 정의할 때 일어난다.

```python
class ApiClass(object):
    def __init__(self):
        self._value = 5

    def get(self):
        return self._value

class Child(ApiClass):
    def __init__(self):
        super().__init__()
        self._value = 'hello'  # 충돌하는 변수

a = Child()
print(a.get(), 'and', a._value, 'should be different')

>>>
hello and hello should be different
```

주로 클래스가 공개 API의 일부일 때 문제가 된다. 서브클래스는 직접 제어할 수 없으니 문제를 고치려고 리팩토링할 수 없다. 이런 충돌은 속성 이름이 value처럼 아주 일반적일 때 일어날 확률이 특히 높다. 이런 상황이 일어날 위험을 줄이려면 부모 클래스에서 비공개 속성을 사용해서 자식 클래스와 속성 이름이 겹치지 않게 하면 된다.

```python
class ApiClass(object):
    def __init__(self):
        self.__value = 5

    def get(self):
        return self.__value

class Child(ApiClass):
    def __init__(self):
        super().__init__()
        self._value = 'hello'  # OK!

a = Child()
print(a.get(), 'and', a._value, 'are different')
```

### 정리

- 파이썬 컴파일러는 비공개 속성을 엄격하게 강요하지 않는다
- 서브클래스가 내부 API와 속성에 접근하지 못하게 막기보다는 처음부터 내부 API와 속성으로 더 많은 일을 할 수 있게 설계하자
- __비공개 속성에 대한 접근을 강제로 제어하지 말고 보호 필드를 문서화해서 서브클래스에 필요한 지침을 제공하자__
- 직접 제어할 수 없는 서브클래스와 이름이 충돌하지 않게 할 때만 비공개 속성을 사용하는 방안을 고려하자.

## 커스텀 컨테이너 타입은 collections.abc의 클래스를 상속받게 만들자 (B28)

파이썬 프로그래밍의 대부분은 데이터를 담은 클래스들을 정의하고 이 객체들이 연계되는 방법을 명시하는 일이다. 모든 파이썬 클래스는 일종의 컨테이너로, 속성과 기능을 함께 캡슐화한다. 파이썬은 데이터 관리용 내장 컨테이너 타입(리스트, 튜플, 세트, 딕셔너리)도 제공한다. 

> 컨테이너란?
>
> 컨테이너라는 개념은 1개 이상의 데이터를 하나의 변수에 할당하는 것입니다. ['a', 1, 'b'] #a,b,1 데이터들이  담김

시퀀스(sequence)처럼 쓰임새가 간단한 클래스를 설계할 때는 파이썬의 내장 list 타입에서 상속받으려고 하는 게 당연하다.

예를 들어 멤버의 빈도를 세는 메서드를 추가로 갖춘 커스텀 리스트 타입을 생성한다고 해보자.

```python
class FrequencyList(list):
    def __init__(self, members):
        super().__init__(members)

    def frequency(self):
        counts = {}
        for item in self:
            counts.setdefault(item, 0)
            print(counts)
            counts[item] += 1
        return counts
```

list에서 상속받아 서브클래스를 만들었으므로 list의 표준 기능을 모두 갖춰서 파이썬 프로그래머에게 익숙한 시맨틱(semantic)을 유지한다. 그리고 추가한 메서드로 필요한 커스텀 동작을 더할 수 있다.

```python
foo = FrequencyList(['a', 'b', 'a', 'c', 'b', 'a', 'd'])
foo.frequency() #테스트 가능
print('Length is', len(foo))
foo.pop()
print('After pop:', repr(foo)) #str대신 객체에 공식적인 문자열 출력
print('Frequency:', foo.frequency())
```

> 요약해보면, repr() 은 __repr__ 메소드를 호출하고, str() 이나 print 는 __str__ 메소드를 호출하도록 되어있는데, __str__ 은 객체의 비공식적인(informal)( 사용자가 보기 쉬운 형태로 보여줄 때) 문자열을 출력할 때 사용하고, __repr__ 은 공식적인(official)(해당 객체를 인식할 수 있는 공식적인 문자열로 나타내 줄 때 ) 문자열을 출력할 때 사용한다.

이제 list의 서브클래스는 아니지만 인덱스로 접근할 수 있게 히서 list처럼 보이는 객체를 제공하고 싶다고 해보자. 예를 들어 바이너리트리 클래스에 (list나 tuple 같은) 시퀀스 시맨틱을 제공한다고 하자

```python
class BinaryNode(object):
    def __init__(self, value, left=None, right=None):
        self.value = value
        self.left = left
        self.right = right
```

이 클래스가 시퀀스 타입처럼 동작하게 하려면 어떻게 해야 할까? 파이썬은 특별한 이름을 붙인 인스턴스 메서드로 컨테이너 동작을 구현한다.

```python
bar = [1, 2, 3]
bar[0]
```

위와 같이 시퀀스의 아이템을 인덱스로 접근하면 다음과 같이 해석된다.

```python
bar.__getitem__(0)
```

BinaryNode 클래스가 시퀀스처럼 동작하게 하려면 객체의 트리를 깊이 우선으로 탐색하는 \_\_getitem\_\_ 을 구현하면 된다.(그냥 리스트를 구현한다 생각하자)

```python
class IndexableNode(BinaryNode):
    def _search(self, count, index):
        found = None
        if self.left:
            found, count = self.left._search(count, index) #found가 None값이 반환되버리면 이제 아래걸로 넘어가겠지!
        if not found and count == index:
            found = self
        else:
            count += 1
        if not found and self.right:
            found, count = self.right._search(count, index)
        return found, count
        # Returns (found, count)

    def __getitem__(self, index):
        found, _ = self._search(0, index)
        if not found:
            raise IndexError('Index out of range')
        return found.value

```

이 바이너리 트리는 평소처럼 생성하면 된다.

```python
tree = IndexableNode(
    10,
    left=IndexableNode(
        5,
        left=IndexableNode(2),
        right=IndexableNode(
            6, right=IndexableNode(7))),
    right=IndexableNode(
        15, left=IndexableNode(11)))
```

트리 탐색은 물론이고 list처럼 접근할 수도 있다.

```python
print('LRR =', tree.left.right.right.value)
print('Index 0 =', tree[0])
print('Index 1 =', tree[1])
print('11 in the tree?', 11 in tree)
print('17 in the tree?', 17 in tree)
print('Tree is', list(tree))

>>>
LRR = 7
Index 0 = 2
Index 1 = 5
11 in the tree? True
17 in the tree? False
Tree is [2, 5, 6, 7, 10, 11, 15]
```

문제는 \_\_getitem\_\_ 을 구현하는 것만으로는 기대하는 시퀀스 시맨틱을 모두 제공하지 못한다는 점이다

```python
len(tree)

>>>
TypeError: object of type 'IndexableNode' has no len()
```

내장 함수 len을 쓰려면 커스텀 시퀀스 타입에 맞게 구현한 \_\_len\_\_ 이라는 또 다른 특별한 메서드가 필요하다.

```python
class SequenceNode(IndexableNode):
    def __len__(self):
        _, count = self._search(0, None)
        return count
      
      
tree = SequenceNode(
    10,
    left=SequenceNode(
        5,
        left=SequenceNode(2),
        right=SequenceNode(
            6, right=SequenceNode(7))),
    right=SequenceNode(
        15, left=SequenceNode(11))
)

print('Tree has %d nodes' % len(tree))

>>>
Tree has 7 nodes
```

불행히도 아직은 부족하다. 파이썬 프로그래머들이 list나 tuple 같은 시퀀스 타입에서 기대할 count와 index 메서드가 빠졌다. 커스텀 컨테이너 타입을 정의하는 일은 보기보다 어렵다.

파이썬 세계의 이런 어려움을 피하려고 내장 collections.abc 모듈은 각 컨테이너 타입에 필요한 일반적인 메서드를 모두 제공하는 추상 기반 클래스들을 정의한다. 이 추상 기반 클래스들에서 상속받아 서브클래스를 만들다가 깜빡 잊고 필수 메서드를 구현하지 않으면, 모듈이 뭔가 잘못되었다고 알려준다.

```python
try:
    from collections.abc import Sequence
    
    class BadType(Sequence):
        pass
    
    foo = BadType()
except:
    logging.exception('Expected')
else:
    assert False
```

앞에서 다룬 SequenceNode처럼 추상 기반 클래스가 요구하는 메서드를 모두 구현하면 별도로 작업하지 않아도 클래스가 index와 count 같은 부가적인 메서드를 모두 제공한다.

```python
class BetterNode(SequenceNode, Sequence):
    pass

tree = BetterNode(
    10,
    left=BetterNode(
        5,
        left=BetterNode(2),
        right=BetterNode(
            6, right=BetterNode(7))),
    right=BetterNode(
        15, left=BetterNode(11))
)

print('Index of 7 is', tree.index(7))
print('Count of 10 is', tree.count(10))
```

Set와 MutableMapping처럼 파이썬의 관례에 맞춰 구현해야 하는 특별한 메서드가 많은 더 복잡한 타입을 정의할 때 이런 추상 기반 클래스를 사용하는 이점은 더욱 커진다.

### 정리

- 쓰임새가 간단할 때는 list나 dict 같은 파이썬의 컨테이너 타입에서 직접 상속받게 하자
- 커스텀 컨테이너 타입을 올바르게 구현하는 데 필요한 많은 메서드에 주의해야 한다.
- 커스텀 컨테이너 타입이 collections.abc에 정의된 인터페이스에서 상속받게 만들어서 클래스가 필요한 인터페이스, 동작과 일치하게 하자