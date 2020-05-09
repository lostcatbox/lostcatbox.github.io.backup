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

## 재사용 가능한 @property 메서드에는 디스크랩터를 사용하자









