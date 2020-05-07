---
title: 파이썬 코딩의 스킬 리뷰 4
date: 2020-05-07 11:23:51
categories: [Python]
tags: [Review, Tip, Skill]
---

# 메타클래스와 속성

메타클래스는 파이썬의 기능 목록에서 자주 언급되지만, 실제로 메타클래스가 무엇을 하는지 이해하는 사람은 소수다. 메티클래스(metaclass)라는 이름은 클래스 위에 있고 클래스를 넘어선다는 개념을 암시한다. 즉, 메타클래스를 이용하면 파이썬의 class 문을 가로채서 클래스가 정의될 때마다 특별한 동작을 제공할 수 있다.

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

나중에 속성을 설정할 때 특별한 동작이 일어나야 하면 @property 데코레이터(decorator)와 이에 대응하는 setter 속성을 사용하는 방법으로 바꿀 수 있다. 여기서는 Resistor의 새 서브클래스를 정의하여 voltage 프로퍼티(property)를 할당하면 current 값이 바뀌게 해본다. 제대로 동작하려면 세터와 게터 메서드의 이름이 의도한 프로퍼티 이름과 일치해야 한다.

```python
class VoltageResistance(Resistor):
    def __init__(self, ohms):
        super().__init__(ohms)
        self._voltage = 0

    @property    #getter 역할 (세터와 게터 메서드의 이름이 의도한 프로퍼티 이름과 일치해야 한다.)
    def voltage(self):
        return self._voltage

    @voltage.setter  #setter 역할(세터와 게터 메서드의 이름이 의도한 프로퍼티 이름과 일치해야 한다.)
    def voltage(self, voltage):
        self._voltage = voltage
        self.current = self._voltage / self.ohms
```

이제 voltage 프로퍼티에 할당하면 voltage 세터 메서드가 실행되어 voltage에 맞게 객체의 current 프로퍼티를 업데이트할 것이다.(아래는 입력해서 self.\_voltage가 바뀌고 /self.ohms로 나눴으므로 self.current값 바로 바뀜)

```python
r2 = VoltageResistance(1e3)
print('Before: %5r amps' % r2.current)
r2.voltage = 10
print('After:  %5r amps' % r2.current)
```

