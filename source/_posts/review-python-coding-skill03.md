---
title: 파이썬 코딩의 스킬 리뷰 3
date: 2020-04-22 14:41:32
categories: [Python]
tags: [Review, Tip, Skill]
---

# 클래스와 상속

파이썬은 상속, 다형성, 캡슐화 같은 객체 지향 언어의 모든 기능을 제공한다. 파이썬으로 작업을 처리하다 보면 새 클래스들을 작성하고 해당 클래스들이 인터페이스와 상속 관계를 통해 상호 작용하는 방법을 정의해야 하는 상활을 자주 접하게 된다.



파이썬의 클래스와 상속을 이용하면 프로그램에서 의도한 동작을 객체들로 손쉽게 표현할수있다. 또한 프로그램의 기능을 점차 개선하고 확장도 가능하다. 요구사항이 바뀌는 환경에서도 유연히 대처가능. 클래스와 상속을 사용하는 방법을 잘 알아두면 유지보수가 용이한 코드작성 가능.

## 딕셔너리와 튜플보다는 헬퍼 클래스로 관리하자 (B22)

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

하지만 계층이 한 단계가 넘는 중첩은 피해야 한다.(즉, 딕셔너리를 담은 딕셔너리는 피하자). 여러 계층으로 중첩하면 다른 프로그래머들이 코드를 이해하기 어려워지고 유지보수의 악몽으로 ㅈ됨

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
Grade = collections.namedtuple('Grade', ('score', 'weight'))  #Grade와 namedtuple의 Grade는 맞추는것을 권장 #score, weight가 튜플의 값에 이름이됨.
```

불변 데이터 클래스는 위치 인수나 키워드 인수로 생성할 수 있다. 필드는 이름이 붙은 속성으로 접근할 수 있다. 이름이 붙은 속성이 있으면 나중에 요구 사항이 또 변해서 단순 데이터 컨테이너에 동작을 추가해야 할 때 namedtuple에서 직접 작성한 클래스로 쉽게 바꿀 수 있다.

[자세히](https://thrillfighter.tistory.com/454)

>#namedtuple의 제약
>
>namedtuple이 여러 상황에서 유용하긴 하지만 장점보다 단점을 만들어낼 수 있는 상황도 알자
>
>- namedtuple로 만들 클래스에 기본 인수 값을 설정할 수 없다.
>
>  그래서 데이터에 선택적인 속성이 많으면 다루기 힘들어진다. 속성을 사용할 때는 클래스를 직접 정의하는 게 나을 수 있다.
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

다른 언어레서라면 후크를 추상 클래스로 정의할 것이라고 예상할 수있다. 하지만 파이썬의 후크 중 상당수는 인수와 반환 값을 잘 정의해놓은 단순히 상태가 없는 함수다. 함수는 클래스보다 설명하기 쉽고 정의하기도 간단해서 후크로 쓰기에 이상적이다. 함수가 후크로 동작하는 이유는 파이썬이 일급 함수(firse-class function)을 갖췄기 때문이다. 다시 말해, 언어에서 함수와 메서드를 다른 값처럼 전달하고 참조할 수 있기 때문이다.

예를 들어 defaultdict 클래스의 동작을 사용자화한다고 해보자(B46참조)

> defaultdict은 말그대로 키에 해당하는 값을 입력하지 않았을때 default값을 대신 넣어주는 dic

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

defaultdict는 missing 후크가 상태를 유지한다는 사실을 모르지만, increment_with_report 함수를 실행하면 튜플의 요소로 기대한 개수인 2를 얻는다. 이는 간단한 함수를 인터페이스용으ㅡ로 사용할 때 얻을 수 있는 또 다른 이점이다. 클로저 안에 상태를 숨기면 나중에 기능을 추가하기도 쉽다.

```python
result, count = increment_with_report(current, increments)
print(count)
assert count == 2
print(result)
>>>
2
defaultdict(<function increment_with_report.<locals>.missing at 0x1114f8cb0>, {'green': 12, 'blue': 20, 'red': 5, 'orange': 9})
```

상태 보존 후크용으로 클로저를 정의할 때 생기는 문제는 상태가 없는 함수의 예제보다 이해하기 어렵다는 점이다. 또 다른 방법은 보존할 상태를 캡슐화하는 작은 클래스를 정의하는 것이다.(???)

```python
class CountMissing(object):
    def __init__(self):
        self.added = 0

    def missing(self):
        self.added += 1
        return 0
```

다른 언어에서라면 이제 CountMissing의 인터페이스를 수용하도록 defaultdict를 수정해야 한다고 생각할 것이다.(???) 하지만 파이썬에서는 일급 함수 덕분에 객체로 CountMissing.missing 메서드를 직접 참조해서 defaultdict의 기본값 후크로 넘길 수 있다. 메서드가 함수 인터페이스를 충족하는 건 자명하다.

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
- 파이썬에서 함수와 메서드에 대한 참조는 일급이다. 즉, 다른 타입처럼 표현식에서 사용할 수 있다(???)
-  \_\_call \_\_ 이라는 특별한 메서드는 클래스의 인스턴스를 일반 파이썬 함수처럼 호출할 수 있게 해준다
- 상태를 보존하는 함수가 필요할 때 상태 보존 클로저를 정의하는 대신  \_\_call \_\_ 메서드를 제공하는 클래스를 정의하는 방안을 고려하자(B15참조)

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















(작성중)