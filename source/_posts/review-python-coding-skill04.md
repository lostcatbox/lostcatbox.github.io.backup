---
title: 파이썬 코딩의 스킬 리뷰 4
date: 2020-05-07 11:23:51
categories: [Python]
tags: [Review, Tip, Skill]
---

# 메타클래스와 속성

메타클래스는 파이썬의 기능 목록에서 자주 언급되지만, 실제로 메타클래스가 무엇을 하는지 이해하는 사람은 소수다. 메티클래스(metaclass)라는 이름은 클래스 위에 있고 클래스를 넘어선다는 개념을 암시한다. 즉, 메타클래스를 이용하     면 파이썬의 class 문을 가로채서 클래스가 정의될 때마다 특별한 동작을 제공할 수 있다.

메타클래스 못지 않게 설명하기 어렵지만 강력한 기능은 속성 접근을 동적으로 사용자화하는 파이썬의 내장 기능이다. 파이썬의 객체 지향 구조와 함께 이용하면 이 기능들은 간단한 클래스를 복잡한 클래스로 쉽게 바꿔주는 훌륭한 도구가 된다.

그러나 이런 강력한 기능에는 함정이 많다. 동적 속성은 객체들을 오버라이드하다가 예상치 못한 부작용을 일으키게 할 수 있다. 메타클래스는 처음 접하는 사람은 도저히 이해할 수 없는 극도로 이상한 동작을 만들어내기도 한다. 그러므로 놀랄 만한 것은 최소한 사용을 따르고 제대로 이해하고 있는 이디엄을 구현하는 데만 이런 메커니즘을 이용해야 한다.

## 게터와 세터 메서드 대신 일반 속성을 사용하자 (B29)

다른 언어에서 파이썬으로 넘어온 프로그래머들은 자연스레 클래스에 게터(getter)와 세터(setter) 메서드를 명시적으로 구현하려고 한다.

```python
class OldResistor(object):
    def __init__(self, ohms):
        self._ohms = ohms

    def get_ohms(self):
        return self._ohms

    def set_ohms(self, ohms):
        self._ohms = ohms
```

하지만 이런 게터와 세터를 사용하는 방법은 파이썬답지 않다.

```python
r0 = OldResistor(50e3)
print('Before: %5r' % r0.get_ohms())
r0.set_ohms(10e3)
print('After:  %5r' % r0.get_ohms())

>>>
Before: 50000.0
After:  10000.0
```

게터와 세터 메서드는 특히 즉성에서 증가시키기 같은 연산에는 사용하기 불편하다.

```python
r0.set_ohms(r0.get_ohms() + 5e3)
```

이런 유틸리티 메서드는 클래스의 인터페이스를 정의하는 데 도움이 되고, 기능을 캡슐화하고 사용법을 검증하고 경계를 정의하기 쉽게 해준다. 이런 요소는 클래스가 시간이 지나면서 발전하더라도 호출하는 쪽 코드를 절대 망가뜨리지 않도록 설계할 때 중요한 목표가 된다.

하지만 파이썬에서는 명시적인 게터와 세터를 구현할 일이 거의 없다. 대신 항상 간단한 공개 속성부터 구현하기 시작해야 한다.

```python
class Resistor(object):
    def __init__(self, ohms):
        self.ohms = ohms
        self.voltage = 0
        self.current = 0

r1 = Resistor(50e3)

print('%r ohms, %r volts, %r amps' %
      (r1.ohms, r1.voltage, r1.current))
```

이렇게 하면 즉성에서 증가시키는 연산은 자연스럽고 명확해지는 것이다.

```python
r1.ohms += 5e3
```

__나중에 속성을 설정할 때 특별한 동작이 일어나야 하면 @property 데코레이터(decorator)와 이에 대응하는 setter 속성을 사용하는 방법으로 바꿀 수 있다.__ 여기서는 Resistor의 새 서브클래스를 정의하여 voltage 프로퍼티(property)를 할당하면 current 값이 바뀌게 해본다. 제대로 동작하려면 세터와 게터 메서드의 이름이 의도한 프로퍼티 이름과 일치해야 한다.

```python
class VoltageResistance(Resistor):
    def __init__(self, ohms):
        super().__init__(ohms)
        self._voltage = 0

    @property    #getter 역할 (세터와 게터 메서드의 이름이 의도한 프로퍼티 이름과 일치해야 한다.)
    def voltage(self):
        return self._voltage

    @voltage.setter  #메서드이름.setter 역할(게터 메서드와 세터 메서드의 이름이 지금 의도한 프로퍼티 이름과 일치해야한다.)
    def voltage(self, voltage):
        self._voltage = voltage
        self.current = self._voltage / self.ohms
```

이제 voltage 프로퍼티에 할당하면 voltage 세터 메서드가 실행되어 voltage에 맞게 객체의 current 프로퍼티를 업데이트할 것이다.(아래는 입력해서 self.\_voltage가 바뀌고 /self.ohms로 나눴으므로 self.current값 바로 바뀜)

```python
r2 = VoltageResistance(1e3)
print('Before: %5r amps' % r2.current)
r2.voltage = 10  #값을 줘서 객체 값 변환하는법 확인
print('After:  %5r amps' % r2.current)

>>>
Before:     0 amps
After:   0.01 amps
```

프로퍼티에 setter를 설정하면 클래스에 전달된 값들의 타입을 체크하고 값을 검증할 수도 있다. 다음은 모든 저항값이 0옴보다 큼을 보장하는 클래스를 정의한 것이다.

```python
class BoundedResistance(Resistor):
    def __init__(self, ohms):
        super().__init__(ohms)

    @property 
    def ohms(self):    #property를 쓰면 self._ohms = ohms가 생성됨 (???), 이건 ohms가 생성되는 이유는 아마, ohms.setter가있기때문.
        return self._ohms

    @ohms.setter  #이 속성에 대해 검사한다고 생각?
    def ohms(self, ohms):
        if ohms <= 0:
            raise ValueError('%f ohms must be > 0' % ohms)
        self._ohms = ohms
```

속성에 올바르지 않은 저항값을 할당하면 예외가 일어난다. (저항값은 ohms..옴이니까)

```python
r3 = BoundedResistance(23323)
print(r3.ohms)
r3.ohms=0

>>>
ValueError: 0.000000 ohms must be > 0
```

생성자에 올바르지 않은 값을 넘겨도 예외가 일어난다.

```python
BoundedResistance(-5)

>>>
ValueError: -5.000000 ohms must be > 0
```

__이 예외는 BoundedResistance.\_\_init\_\_가 self.ohms = -5를 할당하는 Resistor.\_\_init\_\_를 호출하기 때문에 일어난다. 이 할당문으로 BoundedResistance의 @ohms.setter 메서드가 호출되어 객체 생성이 완료되기도 전에 곧장 검증 코드가 실행된다.__ (???)

부모 클래스의 속성을 불변(immutable)으로 만드는 데도 @property를 사용할 수 있다.

```python
class FixedResistance(Resistor):
    def __init__(self, ohms):
        super().__init__(ohms)

    @property  #property를 쓰면 self._ohms = ohms가 생성됨 (???), 이건 ohms가 생성되는 이유는 아마, ohms.setter가있기때문.
    def ohms(self):
        return self._ohms #이것과 상관없다.

    @ohms.setter
    def ohms(self, ohms):
        if hasattr(self, '_ohms'):
            raise AttributeError("Can't set attribute")
        self._ohms = ohms
```

이 객체를 생성하고 나서 프로퍼티에 할당하려고 하면 예외가 일어난다.

```python
r4 = FixedResistance(1e3)
r4.ohms = 2e3 

>>>
AttributeError: Can't set attribute
```

@property의 가장 큰 단점은 속성에 대응하는 메서드를 서브클래스에서만 공유할수 있다는 점이다. 서로 관련이 없는 클래스는 같은 구현을 공유하지 못한다. 하지만 파이썬은 재사용 가능한 프로퍼티 로직을 비롯해 다른 많은 쓰임새를 가능하게 하는 디스크립터(descriptor)도 지원한다.(B31 참조)

마지막으로 @property 메서드로 세터와 게터를 구현할 때 예상과 다르게 동작하지 않게 해야 한다. 예를 들면 게터 프로퍼티 메서드에서 다른 속성을 설정하지 말아야 한다.

```python
class MysteriousResistor(Resistor):
    @property
    def ohms(self):
        self.voltage = self._ohms * self.current
        return self._ohms

    @ohms.setter
    def ohms(self, ohms):
        self._ohms = ohms   #__init__ 실행될때도 실행됨.
```

이와 같은 코드는 아주 이상한 동작을 만든다.

```python
r7 = MysteriousResistor(10)
r7.current = 0.01
#여기에 r7.ohms를 호출하면 정상작동.. 왜? 
print('Before: %5r' % r7.voltage)
r7.ohms
print('After:  %5r' % r7.voltage)
```

__최선의 정책은 @property.setter 메서드에서만 관련 객체의 상태를 수정하는 것이다.__ 모듈을 동적으로 임포트하건, 느린 헬퍼 함수를 실행하거나, 비용이 많이 드는 데이터베이스 쿼리를 수행하는 일처럼 호출하는 쪽이 객체에서 일어날 것이라고 예측하지 못할 만한 다른 부작용은 모두 피해야 한다. 사용자는 다른 파이썬 객체가 그렇듯이 클래스의 속성이 빠르고 쉬울 거라고 기대할 것이다. 더 복잡하거나 느린 작업은 일반 메서드로 하자.

### 정리

- 간단한 공개 속성을 사용하여 새 클래스 인터페이스를 정의하고 세터와 게터 메서드는 사용하지 말자.
- 객체의 속성에 접근할 때 특별한 동작을 정의하려면 @property를 사용하자.
- @property 메서드에서 최소 놀람 규칙(rule of least surprise)을 따르고 이상한 부작용은 피하자
- @property 메서드가 빠르게 동작하도록 만들자. 느리거나 복잡한 작업은 일반 메서드로 하자.

## 속성을 리팩토링하는 대신 @property를 고려하자 (B30)

내장 @property 데코레이터(decorator)를 이용하면 더 간결한 방식으로 인스턴스의 속성에 접근하게 할 수 있다(B29 참조). 고급 기법이지만 흔히 사용하는 @property 사용법 중 하나는 단순 숫자 속성을 즉석에서 계산하는 방식으로 변경하는 것이다. 호출하는 쪽을 변경하지 않고도 기존에 클래스를 사용한 곳이 새로운 동작을 하게 해주므로 매우 유용한 기법이다. 또한 시간이 지나면서 인터페이스를 개선할 때 중요한 임시방편이 된다. 

예를 들어 구멍 난 양동이의 할당량을 일반 파이썬 객체를 구현하려한다고 해보자. 다음 Bucket 클래스는 남은 할당량과 이 할당량을 이용할 수 있는 기간을 표현한다.

```python
from datetime import datetime, timedelta

class Bucket(object):
    def __init__(self, period):
        self.period_delta = timedelta(seconds=period)
        self.reset_time = datetime.now()
        self.quota = 0

    def __repr__(self):
        return 'Bucket(quota=%d)' % self.quota

bucket = Bucket(60)
print(bucket)
```

구멍 난 양동이(leaky bucket) 알고리즘은 양동이를 채울 때마다 할당량이 다음 기간으로 넘어가지 않게 하는 식으로 동작한다.

```python
def fill(bucket, amount):
    now = datetime.now()
    if now - bucket.reset_time > bucket.period_delta:
        bucket.quota = 0
        bucket.reset_time = now
    bucket.quota += amount
```

할당량을 소비하는 쪽에서는 매번 사용할 양을 뺄 수 있는지부터 확인해야 한다.

```python
def deduct(bucket, amount):
    now = datetime.now()
    if now - bucket.reset_time > bucket.period_delta:
        return False
    if bucket.quota - amount < 0:
        return False
    bucket.quota -= amount
    return True
```

이 클래스를 사용하기 위해 먼저 양동이를 채워보자

```python
bucket = Bucket(60)
fill(bucket, 100)
print(bucket)
```

그러고 나서 필요한 만큼 양을 빼보자

```python
if deduct(bucket, 99):
    print('Had 99 quota')
else:
    print('Not enough for 99 quota')
print(bucket)
```

그 결과 이용할 수 있는 양보다 많이 빼려고 해서 진행이 중단되었다. 이 경우 양동이의 할당량은 그대로 남는다.

```python
if deduct(bucket, 3):
    print('Had 3 quota')
else:
    print('Not enough for 3 quota')
print(bucket)
```

이 구현에서 문제는 양동이의 할당량이 어떤 수준에서 시작하는지 모른다는 점이다. 양동이는 0이 될 때까지 진행 기간 동안 할당량이 줄어든다. 0이 되면 deduct가 항상 False를 반환한다. 이때 deduct를 호출하는 쪽이 중단된 이유가 Bucket의 할당량이 소진되어서인지 아니면 처음부터 Bucket에 할당량이 없어서인지 알 수 있다면 좋을 것이다.

문제를 해결하려면 클래스에서 기간 동안 발생한 max_quota와quota_consumed의 변경을 추적하도록 수정하면 된다.

```python
class Bucket(object):
    def __init__(self, period):
        self.period_delta = timedelta(seconds=period)
        self.reset_time = datetime.now()
        self.max_quota = 0
        self.quota_consumed = 0

    def __repr__(self):
        return ('Bucket(max_quota=%d, quota_consumed=%d)' %
                (self.max_quota, self.quota_consumed))
```

이 새 속성들을 이용해 실시간으로 현재 할당량의 수준을 계산하려고 @property 메서드를 사용한다.

```python
    @property
    def quota(self):
        return self.max_quota - self.quota_consumed
```

quota속성이 할당을 받는 순간에 fill과 deduct에서 사용하는 이 클래스의 현재 인터페이스와 일치하는 특별한 동작을 하게 만든다.

```python
    @quota.setter
    def quota(self, amount):
        delta = self.max_quota - amount
        if amount == 0:
            # Quota being reset for a new period
            self.quota_consumed = 0
            self.max_quota = 0
        elif delta < 0:
            # Quota being filled for the new period
            assert self.quota_consumed == 0
            self.max_quota = amount
        else:
            # Quota being consumed during the period
            assert self.max_quota >= self.quota_consumed
            self.quota_consumed += delta
```

앞에서 본 데모 코드를 다시 실행하면 같은 결과가 나온다.

```python
bucket = Bucket(60)
print('Initial', bucket)
fill(bucket, 100)
print('Filled', bucket)

if deduct(bucket, 99):
    print('Had 99 quota')
else:
    print('Not enough for 99 quota')

print('Now', bucket)

if deduct(bucket, 3):
    print('Had 3 quota')
else:
    print('Not enough for 3 quota')

print('Still', bucket)

>>>
Initial Bucket(max_quota=0, quota_consumed=0)
Filled Bucket(max_quota=100, quota_consumed=0)
Had 99 quota
Now Bucket(max_quota=100, quota_consumed=99)
Not enough for 3 quota
Still Bucket(max_quota=100, quota_consumed=99)
```

가장 좋은 점은 Bucket.quota를 사용하는 코드는 변경하거나 Bucket 클래스가 변경된 사실을 몰라도 된다는 점이다. Bucket의 사용법은 제대로 동작하며 max_quota 와 quota_consumed에 직접 접근할 수 있다.

필자가 특별이 @property를 좋아하는 이유는 시간이 지날수록 더 좋은 데이터 모델로 발전시킬 수 있기 때문이다. 위에 Bucket 예제를 보면서 속으로 'fill'과 'deduct'는 처음부터 인스턴스 메서드로 구현했어야 했다.라고 생각했을 것이다 여러분의 생각이 맞는다고 해도 (B22참조) 실제로 객체가 형편없이 정의한 인터페이스로 시작하거나 아무 기능이 없는 데이터 컨테이너로 동작하는 상황이 많다. 이런 상황은 시간이 지나면서 코드가 증가하고, 영역이 넓어지고, 여러 개발자가 기여하면서도 아무도 장기 예방책을 고려하지 않는 경우가 발생한다.

@property는 실전 코드에서 만날 수 있는 문제를 해결하는 데 보탬이 되는 도구다. 하지만 과용하지말자. @property 메서드를 계속 확장하고 있다면, 코드의 부족한 설계를 계속 수정할 게 아니라 클래스를 새롭게 리팩토링할 시점이 된 것이다.

### 정리

- 기존의 인스턴스 속성에 새 기능을 부여하려면 @property를 사용하자
- @property를 사용하면 점점 나은 데이터 모델로 발전시키자
- @property를 너무 많이 사용한다면 클래스와 이를 호출하는 모든 곳을 리팩토링하는 방안을 고려하자

## 재사용 가능한 @property 메서드에는 디스크랩터를 사용하자(B31)

파이썬에 내장된 @property의 큰 문제점은 재사용성이다.(B29 참조)

즉, @property로 데코레이트하는 메서드를 같은 클래스에 속한 여러 속성에 사용하지 못한다. 또한 관련 없는 클래스에서도 재사용할 수 없다.

```python
class Homework(object):
    def __init__(self):
        self._grade = 0

    @property
    def grade(self):
        return self._grade

    @grade.setter
    def grade(self, value):
        if not (0 <= value <= 100):
            raise ValueError('Grade must be between 0 and 100')
        self._grade = value
```

@property를 사용하면 이 클래스를 쉽게 사용할 수 있다.

```python
galileo = Homework()
galileo.grade = 95
print(galileo.grade)
```

학생들의 시험 성적을 매긴다고 해보자. 시험은 여러 과목으로 구성되어 있고 과목별로 점수가 있다.

```python
class Exam(object):
    def __init__(self):
        self._writing_grade = 0
        self._math_grade = 0

    @staticmethod  #중요.
    def _check_grade(value):
        if not (0 <= value <= 100):
            raise ValueError('Grade must be between 0 and 100')
```

이 코드는 금방 장황해진다. 시험 영역마다 새 @property와 관련 검증이 필요하다.

```python
    @property
    def writing_grade(self):
        return self._writing_grade

    @writing_grade.setter
    def writing_grade(self, value):
        self._check_grade(value)
        self._writing_grade = value

    @property
    def math_grade(self):
        return self._math_grade

    @math_grade.setter
    def math_grade(self, value):
        self._check_grade(value)
        self._math_grade = value
```

이런 방법은 범용으로 사용하기에도 좋지 않다. 과제와 시험 이외의 항목에도 이 백분율 검증을 재사용하고 싶다면 @property와 \_check\_grade를 반복적으로 작성해야 한다.(당연히 각각 속성값을 세팅하는데 그 속성을 검사하려면 위와같은 과정말곤없다)

> [@staticmethod와 @classmethod 차이 구별](https://hamait.tistory.com/635) 해야함
>
> @staticmethod를 하면 클래스에서 공통으로 쓰는것을 목표로 함수 파라미터에서 self를 쓰지 않아도됨

파이썬에서 이런 작업을 할 때 더 좋은 방법은 디스크립터를 사용하는 것이다. 디스크립터 프로토콜(descriptor protocol)은 속성에 대한 접근을 언어에서 해석할 방법을 정의한다. 디스크립터 클래스는 반복 코드 없이도 성적 검증 동작을 재사용할 수 있게 해주는 \_\_get\_\_ 과 \_\_set\_\_ 메서드를 제공할 수 있다. 이런 목적으로는 디스크립터가 믹스인(B26 참조)보다도 좋은 방법이다. 디스크립터를 이용하면 한 클래스의 서로 다른 많은 속성에 같은 로직을 재사용할 수 있기 때문이다.

이번에는 Grade 인스턴스를 클래스 속성으로 포함하는 새로운 Exam 클래스를 정의한다. Grade 클래스는 디스크립터 프로토콜을 구현한다. Grade 클래스의 동작원리를 설명하기 전에 코드에서 Exam 인스턴스에 있는 이런 디스크립터 속성에 접근할 때 파이썬이 무슨 일이 하는지 이해해야 한다.

```python
class Grade(object):
    def __get__(*args, **kwargs):
        pass

    def __set__(*args, **kwargs):
        pass

class Exam(object):
    # Class attributes
    math_grade = Grade()
    writing_grade = Grade()
    science_grade = Grade()
```

다음과 같이 프로퍼티를 할당한다고 하자

```python
exam = Exam()
exam.writing_grade = 40
```

위의 코드는 다음과 같이 해석된다

```python
#위의 코드는 다음과 같이 해석된다
Exam.__dict__['writing_grade'].__set__(exam, 40)

#이번에는 다음과 같이 프로퍼티를 얻어온다고 하자
print(exam.writing_grade)

#위의 코드는 다음과 같이 해석된다.
print(Exam.__dict__['writing_grade'].__get__(exam, Exam))
```

이렇게 동작하게 만드는 건 object의 \_\_getattribute\_\_ 메서드다(B32 참조).  간단히 말하면 Exam인스턴스에 writing_grade 속성이 없으면(당연히 self.인것만 인스턴스 속성들이므로) 파이썬은 대신 Exam 클래스의 속성을 이용한다. 이 클래스의 속성이 \_\_get\_\_ 과 \_\_set\_\_ 메서드를 갖춘 __객체__라면 파이썬은 디스크립터 프로토콜을 따른다고 가정한다.

다음은 이런 동작과 Homework 클래스에서 @property를 성적 검증에 사용한 방법을 이해하고 Grade 디스크립터를 그럴듯하게 구현해본 첫 번째 시도다

```python
class Grade(object):
    def __init__(self):
        self._value = 0

    def __get__(self, instance, instance_type):
        return self._value

    def __set__(self, instance, value):
        if not (0 <= value <= 100):
            raise ValueError('Grade must be between 0 and 100')
        self._value = value
```

불행히도 위의 코드는 잘못 구현되어 있어서 제대로 동작하지 않을 것이다. 한 Exam 인스턴스에 있는 여러 속성에 접근하는 것은 기대한 대로 동작한다.

```python
class Exam(object):
    math_grade = Grade()
    writing_grade = Grade()
    science_grade = Grade()
    
first_exam = Exam()
first_exam.writing_grade = 82
first_exam.science_grade = 99
print('Writing', first_exam.writing_grade)
print('Science', first_exam.science_grade)
    
>>>
Writing 82
Science 99
```

하지만 여러 Exam 인스턴스의 이런 속성에 접근하면 기대하지 않은 동작을 하게 된다

(당연하다. 각 속성의 각각 Grade의 객체지만 그 각각의 객체를 Exam의 인스턴스에 따라 분리안했으므로 결국 self_values의 값은 한개밖에없다.)(즉, math\_grade.\_value로 있으므로 second 클래스 인스턴스에서도 math\_grade.\_value로 은 값을 가르킴. !)

```python
second_exam = Exam()
second_exam.writing_grade = 75
print('Second', second_exam.writing_grade, 'is right')
print('First ', first_exam.writing_grade, 'is wrong')

>>>
Second 75 is right
First 75 is wrong
```

문제는 한 Grade 인스턴스가 모든 Exam 인스턴스의 writing_grade 클래스 속성으로 공유된다는 점이다. 이 속성에 대응하는 Grade인스턴스는 프로그램에서 Exam 인스턴스를 생성할 때마다 생성되는 게 아니라 Exam 클래스를 처음 정의할 떄 한 번 생성되기때문이다.

이 문제를 해결하려면 __각 Exam 인스턴스별로 값을 추적하는 Grade 클래스가 필요하다.__ 여기서는 딕셔너리에 각 인스턴스의 상태를 저장하는 방법으로 값을 추적한다.

```python
class Grade(object):
    def __init__(self):
        self._values = {}

    def __get__(self, instance, instance_type):
        if instance is None: return self
        return self._values.get(instance, 0)

    def __set__(self, instance, value):
        if not (0 <= value <= 100):
            raise ValueError('Grade must be between 0 and 100')
        self._values[instance] = value
```

이 구현은 간단하면서도 잘 동작하지만 여전히 문제점이 하나 남아있다. 바로 메모리 누수다. \_values 딕셔너리는 프로그램의 수명 동안 \_\_set\_\_ 에 전달된 모든 Exam 인스턴스의 참조를 저장한다. 결국 인스턴스의 참조 개수가 절대로 0이 되지 않아 가비지 컬렉터가 정리하지 못하게 한다

파이썬의 내장 모듈 weakref를 사용하면 이 문제를 해결할 수 있다. 이 모듈은 \_values에 사용한 간단한 딕셔너리를 대체할 수 있는 WeakKeyDictionary라는 특별한 클래스를 제공한다. WeakKeyDictionary 클래스 고유의 동작은 런타임에 마지막으로 남은 Exam인스턴스의 참조를 갖고 있다는 사실을 알면 키 집합에서 Exam 인스턴스를 제거하는 것이다. 파이썬이 대신 참조를 관리해주고 모든 Exam 인스턴스가 더는 사용되지 않으면 \_values 딕셔너리가 비어있게 한다 (???)

```python
from weakref import WeakKeyDictionary

class Grade(object):
    def __init__(self):
        self._values = WeakKeyDictionary()
    def __get__(self, instance, instance_type):
        if instance is None: return self
        return self._values.get(instance, 0)

    def __set__(self, instance, value):
        if not (0 <= value <= 100):
            raise ValueError('Grade must be between 0 and 100')
        self._values[instance] = value
```

다음과 같은 Grade 디스크립터 구현을 사용하면 모두 기대한 대로 동작한다.

```python
class Exam(object):
    math_grade = Grade()
    writing_grade = Grade()
    science_grade = Grade()

first_exam = Exam()
first_exam.writing_grade = 82
second_exam = Exam()
second_exam.writing_grade = 75
print('First ', first_exam.writing_grade, 'is right')
print('Second', second_exam.writing_grade, 'is right')

>>>
First 82 is right
Second 75 is right
```

### 정리

- 직접 디스크립터 클래스를 정의하여 @property 메서드의 동작과 검증을 재사용하자
- WeakKeyDictionary를 사용하여 디스크립터 클래스가 메모리 누수를 일으키지 않게 하자
- \_\_getattribute\_\_ 가 디스크립터 프로토콜을 사용하여 속성을 얻어오고 설정하는 원리를 정확히 이해하려는 함정에 빠지지 말자.

## 지연 속성에는 \_\_getattr\_\_, \_\_getattribute\_\_, \_\_setattr\_\_을 사용하자 (B 32)

파이썬의 언어 후크(language hook)를 이용하면 시스템들을 연계하는 범용 코드를 쉽게 만들수 있다.

예를 들어 데이터베이스의 로우(row)를 파이썬 객체로 표현한다고 하자. 데이터베이스에는 스키마 세트가 있다. 그러므로 로우에 대응하는 객체를 사용하는 코드는 데이터베이스 형태도 알아야 한다. 하지만 파이썬에서는 객체와 데이터베이스를 연결하는 코드에서 로우의 스키마를 몰라도된다. 코드를 범용으로 만들면 된다.

어떻게 가능할까? 사용하기전에 앞에서 배운 정의부터 해야하는 일반 인스턴스 속성, @property 메서드, 디스크립터로는 이렇게 할 수 없다. 파이썬은 \_\_getattr\_\_ 라는 특별한 메서드로 이런 동적 동작을 가능하게 한다. 클래스에 \_\_getattr\_\_ 메서드를 정의하면 __객체의 인스턴스 딕셔너리에서 속성을 찾을 수없을 때마다 이 메서드가 호출된다.__

```python
class LazyDB(object):
    def __init__(self):
        self.exists = 5

    def __getattr__(self, name):
        value = 'Value for %s' % name
        setattr(self, name, value)
        return value
```

이제 존재하지 않는 속성인 foo에 접근해보자. 그러면 파이썬이 \_\_getattr\_\_ 메서드를 호출하게 되고 이어서 인스턴스 딕셔너리 \_\_dict\_\_를 변경하게된다.

```python
data = LazyDB()

data.__dict__
print('Before:', data.__dict__)
print('foo:   ', data.foo)
print('After: ', data.__dict__)
```

다음 코드에서는 \_\_getattr\_\_이 실제로 호출되는 시점을 보여주려고 LazyDB로깅을 추가한다. 무한 반복을 피하려고 super().\_\_getattr\_\_()로 실제 프로퍼티 값을 얻어오는 부분을 눈여겨보자

```python
class LoggingLazyDB(LazyDB):
    def __getattr__(self, name):
        print('Called __getattr__(%s)' % name)
        return super().__getattr__(name)

data = LoggingLazyDB()
print('exists:', data.exists)
print('foo:   ', data.foo)
print('foo:   ', data.foo)
```

exists 속성은 인스턴스 딕셔너리에 있으므로 \_\_getattr\_\_이 절대 호출되지 않는다. foo 속성은 원래는 인스턴스 딕셔너리에 없으므로 처음에는 \_\_getattr\_\_ 이 호출된다. 하지만 foo에 대응하는 \_\_getattr\_\_호출은 setattr을 호출하며, setattr은 인스턴스 딕셔너리에 foo를 저장한다. 따라서 foo에 두번째 접근할 떄는 \_\_getattr\_\_ 호출이 되지 않는다

이런 동작은 스키마리스 데이터(schemaless data)(구조가 정해지지 않은 데이터)에 지연 접근하는 경우에 특히 도움이 된다. \_\_getattr\_\_이 프로퍼티 로딩이라는 어려운 작업을 한 번만 실행하면 다음 접근부터는 기존 결과를 가져온다

데이터베이스 시스템에서 트랜잭션도 원한다고 하자. 사용자가 다음 번에 속성에 접근할 때는 대응하는 데이터베이스의 로우가 여전히 유효한지, 트랜잭션이 여전히 열려 있는지 알고 싶다고 해보자. \_\_getattr\_\_ 후크는 기존 속서에 빠르게 접근하려고 객체의 인스턴스 딕셔너리를 사용할 것이므로 이 작업에는 믿고 쓸 수가 없다.

__파이썬에는 이런 쓰임새를 고려한 \_\_getattribute\_\_라는 또 다른 후크가 있다. 이 특별한 메서드는 객체의 속성에 접근할 때마다 호출되며, 심지어 해당 속성이 속성 딕셔너리에 있을 때도 호출된다.__ 이런 동작 덕분에 속성에 접근할 때마다 전역 트랜잭션 상태를 확인하는 작업 등에 쓸 수 있다. 여기서 \_\_getattribute\_\_가 호출될 때마다 로그를 남기려고 ValidationDB를 정의한다.

```python
class ValidatingDB(object):
    def __init__(self):
        self.exists = 5

    def __getattribute__(self, name):
        print('Called __getattribute__(%s)' % name)
        try:
            return super().__getattribute__(name)
        except AttributeError:
            value = 'Value for %s' % name
            setattr(self, name, value)
            return value

data = ValidatingDB()
print('exists:', data.exists)
print('foo:   ', data.foo)
print('foo:   ', data.foo)

>>>
Called __getattribute__(exists)
exists: 5
Called __getattribute__(foo)
foo:    Value for foo
Called __getattribute__(foo)
foo:    Value for foo
```

> 트랜잭션은 작업의 완전성을 보장해주는것이다. 즉, 논리적인 작업 셋을 모두 완벽하게 처리하거나 또는 처리하지 못할 경우에는 원 상태로 복구해서 작업의 일부만 적용된는 현상이 발생하지 않게 만들어주는 기능이다. 단위임!

동적으로 접근한 프로퍼티가 존재하지 않아야 하는 경우에는 AttributeError를 일으켜서  \_\_getattr\_\_ ,  \_\_getattribute\_\_ 에 속성이 없는 경우의 파이썬 표준 동작이 일어나게 한다.

```python
try:
    class MissingPropertyDB(object):
        def __getattr__(self, name):
            if name == 'bad_name':
                raise AttributeError('%s is missing' % name)
            value = 'Value for %s' % name
            setattr(self, name, value)
            return value

    data = MissingPropertyDB()
    data.foo  # Test this works
    data.bad_name
except:
    logging.exception('Expected')
else:
    assert False
```

파이썬 코드로 범용적인 기능을 구현할 때 종종 내장 함수 hasattr로 프로퍼티가 있는지 확인하고 내장 함수 getattr로 프로퍼티 값을 가져온다. 이 함수들도 \_\_getattr\_\_ 을 호출하기 전에 인스턴스 딕셔너리에서 속성 이름을 찾는다.

```python
data = LoggingLazyDB()
print('Before:     ', data.__dict__)
print('foo exists: ', hasattr(data, 'foo'))
print('After:      ', data.__dict__)
print('foo exists: ', hasattr(data, 'foo'))

data = ValidatingDB()
print('foo exists: ', hasattr(data, 'foo'))
print('foo exists: ', hasattr(data, 'foo'))
```

이제 파이썬 객체에 값을 할당할 때 지연 방식으로 데이터를 데이터베이스에 집어넣고 싶다고 해보자. 이 작업은 임의의 속성 할당을 가로채는 \_\_setattr\_\_ 언어 후크로 할 수 있다. \_\_getattr\_\_ 과 \_\_getattribute\_\_ 로 속성을 추출하는 것과는 다르게 별도의 메서드 두 개가 필요하지 않다. \_\_setattr\_\_ 메서드는 인스턴스의 속성이 할당을 받을 때마다 직접 혹은 내장 함수 setattr을 통해 호출된다.

```python
class SavingDB(object):
    def __setattr__(self, name, value):
        # Save some data to the DB log
        super().__setattr__(name, value)
```

다음 코드에서는 SavingDB의 로깅용 서브클래스를 정의한다. \_\_setattr\_\_ 메서드는 속성에 값을 할당할 때마다 호출된다.

```python
class LoggingSavingDB(SavingDB):
    def __setattr__(self, name, value):
        print('Called __setattr__(%s, %r)' % (name, value))
        super().__setattr__(name, value)

data = LoggingSavingDB()
print('Before: ', data.__dict__)
data.foo = 5
print('After:  ', data.__dict__)
data.foo = 7
print('Finally:', data.__dict__)
```

 \_\_getattribute\_\_ 와  \_\_setattr\_\_ 을 사용할 때 부딪히는 문제는 객체의 속성에 접근할 때마다 (심지어 원하지 않을 때도) 호출된다는 점이다. 

예를 들어 객체의 속성에 접근하면 실제로 연관 딕셔너리에서 키를 찾게 하고 싶다고 해보자

```python
class BrokenDictionaryDB(object):
    def __init__(self, data):
        self._data = data

    def __getattribute__(self, name):
        print('Called __getattribute__(%s)' % name)
        return self._data[name]
```

그러려면 위와 같이 \_\_getattribute\_\_ 메서드에서 self._data에 접근해야한다. 하지만 실제로 시도해보면 파이썬이 스택의 한계에 도달할 때까지 재귀 호출을 하게 되어 결국 프로그램이 중단된다.

```
try:
    data = BrokenDictionaryDB({'foo': 3})
    data.foo
except:
    logging.exception('Expected')
else:
    assert False
```

문제는  \_\_getattribute\_\_ 가 self._data에 접근하면  \_\_getattribute\_\_가 다시 실행되고, 다시 self.\_data에 접근한다는 점이다. 해결책은 인스턴스에서 super().\_\_getattribute\_\_메서드로 인스턴스 속성 딕셔너리에서 값을 얻어오는 것이다. 이렇게 하면 재귀 호출을 피할 수 있다.

```python
class DictionaryDB(object):
    def __init__(self, data):
        self._data = data

    def __getattribute__(self, name):
        data_dict = super().__getattribute__('_data')
        return data_dict[name]

data = DictionaryDB({'foo': 3})
print(data.foo)
```

마찬가지 이유로 객체의 속성을 수정하는 \_\_setattr\_\_ 메서드에서도 super().\_\_setattr\_\_ 을 사용해야 한다.

### 정리

- 객체의 속성을 지연 방식으로 로드하고 저장하려면  \_\_getattr\_\_ 와  \_\_setattr\_\_을 사용하자.
-  \_\_getattr\_\_ 은 존재하지 않는 속성에 접근할 떄 한번만 호출되는 반면에  \_\_getattribute\_\_ 는 속성에 접근할 때마다 항상 호출된다
-  \_\_getattribute\_\_ 와  \_\_setattr\_\_ 에서 인스턴스 속성에 직접 접근할 때 super()(즉, object 클래스의 메서드)를 사용하여 무한 재귀가 일어나지 않게 하자.

## 메타클래스로 서브클래스를 검증하자 (B 33)

메타클래스를 응용하는 가장 간단한 사례는 클래스를 올바르게 정의했는지 검증하는 것이다. 복잡한 클래스 계층을 만들 떄 스타일을 강제하거나 메서드를 오버라이드하도록 요구하거나 클래스 속성 사이에 철저한 관계를 두고 싶을 수도 있다. 메타클래스는 서브클래스가 정의될 때마다 검증 코드를 실행하는 신뢰할 만한 방법을 제공하므로 이럴 때 사용할 수 있다.

보통 클래스 검증 코드는 클래스의 객체가 생성될 때 \_\_init\_\_ 메서드에서 실행된다.(B28 참조). 메타클래스를 검증용으로 사용하면 오류를 더 빨리 일으킬 수 있다.

서브클래스 검증용으로 메타클래스를 정의하는 방법을 알아보기 전에 메타클래스가 표준 객체에는 어떻게 동작하는 지 알아야한다. 메타클래스는 type을 상속하여 정의한다. 메타클래스는 기본으로 자체의 \_\_new\_\_ 메서드에서 연관된 class 문의 콘텐츠를 받는다. 여기서 타입이 실제로 생성되기 전에 클래스 정보를 수정할 수 있다.

```python
class Meta(type):
    def __new__(meta, name, bases, class_dict):
        orig_print = __builtins__.print
        print = pprint
        print((meta, name, bases, class_dict))
        print = orig_print
        return type.__new__(meta, name, bases, class_dict)
      
class MyClass(object, metaclass=Meta):
    stuff = 123

    def foo(self):
        pass
```

메타클래스는 클래스의 이름, 클래스가 상속하는 부모 클래스, class 본문에서 정의한 모든 클래스 속성에 접근할 수 있다.

```python
>>>
(<class '__main__.Meta'>,
 'MyClass',
 (<class 'object'>,),
 {'__module__': '__main__',
  '__qualname__': 'MyClass',
  'foo': <function MyClass.foo at 0x109aaa320>,
  'stuff': 123})
```

__클래스가 정의되기 전__에 클래스의 모든 파라미터를 검증하려면 Meta.\_\_new\_\_ 메서드에 기능을 추가하면 된다.

예를 들어 여러 면으로 이루어진 다각형을 어떤 타입이든 표현하고 싶다고 하자. 이렇게 하려면 특별한 검증용 메타클래스를 정의한 후 다각형 클래스 계층의 기반 클래스에 사용하면 된다. 이때 기반 클래스에는 같은 검증을 적용하지 말아야 한다는 점을 유의하기 바란다.

```python
class ValidatePolygon(type):
    def __new__(meta, name, bases, class_dict):
        # 추상 Polygon class는 검증하지 않음
        print
        if bases != (object,):  #???
            if class_dict['sides'] < 3:
                raise ValueError('Polygons need 3+ sides')
        return type.__new__(meta, name, bases, class_dict)  #type. 대신 super().해도상관없지!

class Polygon(object, metaclass=ValidatePolygon):
    sides = None  # 서브클래스에서 설정함

    @classmethod
    def interior_angles(cls):
        return (cls.sides - 2) * 180

class Triangle(Polygon):
    sides = 3  #클래스메서드로 정의했었으니까 cls.sides값은 3이됨

print(Polygon.interior_angles())  #이때는 bases == (object,)임 (부모클래스가 object임)
print(Triangle.interior_angles()) #이때는 bases != (object,)임 (부모클래스가 Polygon임)(__main__.Polygon)
```

면이 세개 미만인 다각형을 정의하려고 하면 검증 코드가 class 문의 본문이 끝나자마자 class 문을 실패하게 만든다. 즉, 이런 클래스를 정의하면 프로그램이 실행을 시작하지도 못한다.

```python
try:
    print('Before class')
    class Line(Polygon):
        print('Before sides')
        sides = 1
        print('After sides')
    print('After class')
except:
    logging.exception('Expected')
else:
    assert False
```

### 정리

- 서브클래스 타입의 객체를 생성하기에 앞서 서브클래스가 정의 시점부터 제대로 구성되었음을 보장하려면 메타클래스를 사용하자
- 파이썬2와 3는 메타클래스 문법이 다르다
- 메타클래스의 \_\_new\_\_ 메서드는 class 문의 본문 전체가 처리된 후에 실행된다.

## 메타클래스로 클래스의 존재를 등록하자 (B34)

메타클래스를 사용하는 또 다른 일반적인 사례는 프로그램에 있는 타입을 자동으로 등록하는 것이다. 등록(registration)은 간단한 식별자(identifier)를 대응하는 클래스에 매핑하는 역방향 조회(reverse lookup)를 수행할 때 유용하다.

예를 들어 파이썬 객체를 직렬화한 표현을 JSON으로 구현한다고 해보자. 객체를 얻어와서 JSON 문자열로 변환할 방법이 필요하다. 다음은 생성자 파라미터를 저장하고 JSON 딕셔너리로 변환하는 기반 클래스를 범용적으로 정의한 것이다.

```python
import json

class Serializable(object):
    def __init__(self, *args):
        self.args = args #아래 코드에서 super().__init__(x,y)했으므로 튜플값으로 args = (5, 3) 가 되었고 따라서 self.args = (5, 3)이다.

    def serialize(self):
        return json.dumps({'args': self.args})
```

이 클래스를 이용하면 Point2D처럼 간단한 불변 자료 구조를 문자열로 쉽게 직렬화할 수 있다.

```python
class Point2D(Serializable):
    def __init__(self, x, y):
        super().__init__(x, y)
        self.x = x
        self.y = y

    def __repr__(self):
        return 'Point2D(%d, %d)' % (self.x, self.y)

point = Point2D(5, 3)
print('Object:    ', point)
print('Serialized:', point.serialize())
```

이제 이 JSON 문자열을 역직렬화해서  JSON이 표현하는 Point2D 객체를 생성해야 한다. 이번에는 Serializable 부모 클래스에 있는 데이터를 역직렬화하는 또 다른 클래스를 정의한다.

```python
class Deserializable(Serializable):
    @classmethod
    def deserialize(cls, json_data):
        params = json.loads(json_data)
        return cls(*params['args'])
```

Deserializable을 이용하면 간단한 불변 객체들을 범용적인 방식으로 쉽게 직렬화하고 역질렬화할수있다.

```python
class BetterPoint2D(Deserializable):
    def __init__(self, x, y):
        super().__init__(x, y)
        self.x = x
        self.y = y

    def __repr__(self):
        return 'BetterPoint2D(%d, %d)' % (self.x, self.y)

point = BetterPoint2D(5, 3)
print('Before:    ', point)
data = point.serialize()
print('Serialized:', data)
after = BetterPoint2D.deserialize(data)
print('After:     ', after)
print(type(after))

Before:     BetterPoint2D(5, 3)
Serialized: {"args": [5, 3]}
After:      BetterPoint2D(5, 3)
<class '__main__.BetterPoint2D'>
```

이 방법의 문제는 직렬화된 데이터에 대응하는 타입(Point2D, BetterPoint2D)을 미리 알고 있을 때만 동작한다는 점이다. 이상적으로는 JSON으로 직렬화되는 클래스를 많이 갖추고 그중 어떤 클래스든 대응하는 파이썬 객체로 역직렬화하는 공통 함수를 하나만 두려고 할 것이다

이렇게 만들려면 직렬화할 객체의 클래스 이름을 JSON데이터에 포함하면 된다.

```python
class BetterSerializable(object):
    def __init__(self, *args):
        self.args = args

    def serialize(self):
        return json.dumps({
            'class': self.__class__.__name__,
            'args': self.args,
        })

    def __repr__(self):
        return '%s(%s)' % (
            self.__class__.__name__,
            ', '.join(str(x) for x in self.args))
```

다음으로 클래스 이름을 해당 클래스의 객체 생성자에 매핑하고 이 매핑을 관리한다. 범용 deserialize 함수는 register\_class 에 넘긴 클래스가 어떤 것이든 제대로 동작한다.

```python
registry = {}

def register_class(target_class):
    registry[target_class.__name__] = target_class

def deserialize(data):
    params = json.loads(data)
    name = params['class']
    target_class = registry[name]
    return target_class(*params['args'])
```

deserialize가 항상 제대로 동작함을 보장하려면 추후에 역직렬화할 법한 모든 클래스에 register\_class 를 호출 해야 한다.

```python
class EvenBetterPoint2D(BetterSerializable):
    def __init__(self, x, y):
        super().__init__(x, y)
        self.x = x
        self.y = y

register_class(EvenBetterPoint2D)
```

이제 어떤 클래스를 담고 있는지 몰라도 임의의  JSON문자열을 역직렬화할 수 있다.

```python
point = EvenBetterPoint2D(5, 3)
print('Before:    ', point)
data = point.serialize()
print('Serialized:', data)
after = deserialize(data)
print('After:     ', after)

>>>
```

이 방법의 문제는 register\_class 를 호출하는 일을 깜빡 잊을 수 있다는 점이다

```python
class Point3D(BetterSerializable):
    def __init__(self, x, y, z):
        super().__init__(x, y, z)
        self.x = x
        self.y = y
        self.z = z

# Forgot to call register_class! Whoops!
```

이는 등록을 잊은 클래스의 객체를 런타임에 역직렬화하려 할 때 코드가 중단되는 원인이 된다.

```python
try:
    point = Point3D(5, 9, -4)
    data = point.serialize()
    deserialize(data)
except:
    logging.exception('Expected')
else:
    assert False
```

BetterSerializable를 상속해서 서브클래스를 만들더라도 class 문의 본문 이후에 register\_class 를 호출하지 않으면 실제로 모든 기능을 사용하진 못한다. 이 방법은 오류가 일어날 가능성이 높으며, 특히 초보 프로그래머에게는 어렵다. 파이썬 3의 클래스 데코레이터를 이용할 때도 이런 누락이 있을 수 있다.

프로그래머가 의도한 대로 BetterSerializable을 사용하고 모든 경우에 register\_class가 호출된다고 확신할 수 있다면 어떨까? 메타클래스를 이용하면 서브클래스가 정의될 때 (B33 참조)class 문을 가로채는 방법으로 이렇게 만들 수 있다. 메타클래스로 클래스 본문이 끝나자마자 새 타입을 등록하면 된다.

```python
class Meta(type):
    def __new__(meta, name, bases, class_dict):
        cls = type.__new__(meta, name, bases, class_dict)
        register_class(cls)
        return cls

class RegisteredSerializable(BetterSerializable, metaclass=Meta):
    pass
```

RegisteredSerializable의 서브클래스를 정의할 때  register\_class 가 호출되어 deserialize가 항상 기대한 대로 동작할 것이라고 확신할 수 있다.

```python
class Vector3D(RegisteredSerializable):
    def __init__(self, x, y, z):
        super().__init__(x, y, z)
        self.x, self.y, self.z = x, y, z

v3 = Vector3D(10, -7, 3)
print('Before:    ', v3)
data = v3.serialize()
print('Serialized:', data)
print('After:     ', deserialize(data))
```

메타클래스를 이용해 클래스를 등록하면 상속 트리가 올바르게 구축되어 있는 한 클래스 등록을 놓치지 않는다. 앞에서 본 것처럼 직렬화에 잘 동작하며 데이터베이스 객체 관계 매핑(ORM), 플러그인 시스템, 시스템 후크에도 적용할 수 있다.

### 정리

- 클래스 등록은 모듈 방식의 파이썬 프로그램을 만들 떄 유용한 패턴이다
- 메타클래스를 이용하면 프로그램에서 기반 클래스로 서브클래스를 만들 때마다 자동으로 등록 코드를 실행할 수 있다
- 메타클래스를 이용해 클래스를 등록하면 등록 호출을 절대 빠뜨리지 않으므로 오류를 방지할 수 있다.

## 메타클래스로 클래스 속성에 주석을 달자 (B 35)











# 



















