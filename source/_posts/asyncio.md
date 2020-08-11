---
title: 비동기 asyncio 활용
date: 2020-08-11 15:04:42
categories: [Library]
tags: [Library, Python]

---

# 왜?

채팅 앱을 만들다보면 실시간으로 처리해야하는 부분들이많다. 이를동기적으로 처리할 경우 A것을모두처리한후에B를 처리하므로 A가나중에 보낸것들이  B의 메세지보다 먼저 처리가 될수도있다. (실시간 채팅을 구현하기 힘들다)

이를 멀티스레드로 해결할 수 도 있지만.. 이는 나중에 알아보자

[GIL때문에 python은 멀티스레드를 할수록 같거나 느려질수도있다](https://velog.io/@doondoony/Python-GIL)

# 동기와 비동기의 차이점

[자세히](https://sjquant.tistory.com/13)

## 동기

요청이 들어온 순서에 맞게 하나씩 처리하는 방식이다. 순서에 맞춰 진행되는 장점이 있지만, 여러 가지 요청을 동시에 처리할 수 없다.

요청후 응답을 줄때까지 기다림

> 토스트 요청이 들어오면 계란을 굽고 다 구웠다면 토스트굽기를 하고 그것이 끝나면 토스트요리가 나가는 방식

## 비동기

하나의 요청에 따른 응답을 즉시 처리하지 않아도, 그 대기 시간동안 또 다른 요청에 대해 처리 가능한 방식이다. 여러 개의 요청을 동시에 처리할 수 있는 장점이 있지만 동기 방식보다 속도가 떨어질 수도 있다.

요청후 응답을 기다리는동안 다른일도 처리함.

> 토스트 요청이 들어오면 계란을 구우며 타이머 맞춰놓고 바로 토스트 굽기시작후 타이머 맞춰놓고 다음 일 청소를 하는중.,.. 타이머가 울리면 모두 합쳐 토스트 요리가 나가는 방식

전체 데이터를 불러온다면 동기 방식이 적합하고, 일부 데이터만 불러온다면 비동기 방식이 적합하다

# asyncio

[자세히](https://sjquant.tistory.com/14)

[자세히](https://dojang.io/mod/page/view.php?id=2469)

[자세히](https://docs.python.org/ko/3/library/asyncio-eventloop.html)

파이썬에서 비동기를 사용하기 위해서 필요한 라이브러리

프로그래밍에서는 특히 데이터를 요청하고 응답을 기다리는 네트워크 IO에 큰 성능 상향을 기대할수있다.

## 들어가기전

이벤트 루프, 코루틴을 이해해야 완벽히 활용가능하다

- 이벤트루프(Event Loop)

  __이벤트 루프__는 작업들을 루프(반복문)를 돌면서 **하나씩** 실행시키는 역할을 합니다. 이때, 만약 실행된 작업이 특정한 데이터를 요청하고 응답을 기다려야 한다면, 이 작업은 다시 이벤트 루프에 통제권을 넘겨줍니다. 통제권을 받은 이벤트 루프는 다음 작업을 실행하게 됩니다. 그리고 응답을 받은 순서대로 **멈췄던 부분부터** 다시 통제권을 가지고 작업을 마무리합니다.

- 코루틴(Coroutine)

  이때, 이러한 작업은 파이썬에서 __코루틴(Coroutine)__으로 이루어져 있습니다. **코루틴은 응답이 지연되는 부분에서 이벤트 루프에 통제권을 줄 수 있으며, 응답이 완료되었을 때 멈추었던 부분부터 기존의 상태를 유지한 채 남은 작업을 완료할 수 있는 함수**를 의미합니다. 파이썬에서 코루틴이 아닌 일반적인 함수는 `서브루틴(Subroutine)`이라고 합니다.

  ![0_s1GH0YO9ZNdEEDxo](https://tva1.sinaimg.cn/large/007S8ZIlgy1ghmvhn66fxj30m80vqmyo.jpg)

## 연습

함수앞에 `async`를 붙이면 코루틴을 만들수있다

병목이 발생해서 다른 작업으로 통제권을 넘겨줄 필요가 있는 부분에서 `await` 쓴다

이때 `await`뒤에 오는 함수도 코루틴으로 작성되어 있어야 합니다.

`asyncio.sleep` 함수는 코루틴으로 구현되어있기 때문에 비동기로 동작합니다.

(time.sleep은 코루틴이아니므로 사용불가.)(코루틴이 아닌 함수도 비동기에서 사용하는 방법은 뒤에서)

코루틴으로 테스크를 만들었다면, `asyncio.get_event_loop`함수를 사용하여 이벤트 루프를 정의하고 `run_until_complete`으로 실행할수있다.

__비동기로 두 개 이상의 작업(코루틴)을 돌릴 때에는 `asyncio.gather`함수를 이용합니다. 이때, 각 태스크들은 `unpacked 형태`로 넣어주어야 합니다. 즉, `asyncio.gather(coroutine_1(), coroutine_2())`처럼 넣어주거나
`asyncio.gather(*[coroutine_1(), coroutine_2()])`처럼 넣어주어야 합니다.__

```python
import asyncio
import time

async def coroutine_1():  # 코루틴 정의 (async를 앞에 붙여준다.)
    print('코루틴 1 시작')
    print('코루틴 1 중단... 5초간 대기')
    # await으로 중단점 설정 (블락킹되는 부분에서 사용)
    await asyncio.sleep(5)
    print('코루틴 1 재개')


async def coroutine_2():
    print('코루틴 2 시작')
    print('코루틴 2중단... 4초간 대기')
    await asyncio.sleep(4)
    print('코루틴 2 재개')

if __name__ == "__main__":
    # 이벤트 루프 정의
    # 두 개의 코루틴을 이벤트 루프에서 돌린다.
    # 코루틴이 여러개일 경우, asyncio.gather을 먼저 이용 (순서대로 스케쥴링 된다.)
    loop = asyncio.get_event_loop()
    loop.run_until_complete(asyncio.gather(*[coroutine_1(), coroutine_2()]))
```

> 중요한 부분은 먼저 응답이 된 곳부터 시작된다는 것이다.
>
> 따라서  '코루틴 2 재개'가 '코루틴 1재개'보다 먼저 출력된다.

## 코루틴으로 짜여있지 않은 함수 비동기적으로 이용하기

위에서 `await` 뒤에 오는 함수  역시 코루틴으로 작성되어있어야 비동기적인 작업을 할 수 있다고 했습니다. 파이썬의 대부분은 라이브러리들은 비동기를 고려하지 않고 만들어졌기때문에 비동기로 이용할 수없습니다. 하지만 이벤트 루프의 `run_in_executor` 함수를 이용하면 가능합니다.

`asyncio.get_event_loop()`를 활용해서 __현재 이벤트 루프를 `loop`라는 이름으로 받아오고,__ `loop.run_in_executor`를 사용하면 됩니다. 이 함수의 **첫 번째 인자**로는 `concurrent.futures.Executor`의 객체가 들어가고(None을 써주시면 asyncio의 내장 executor가 들어갑니다), **두 번째 인자**로는 사용하고자 하는 함수, **그 이후의 인자(\*args)** 에는 사용하고자 하는 함수의 인자들을 써주면 됩니다.

```python
import asyncio
import time


async def coroutine_1():
    print('코루틴 1 시작')
    print('코루틴 1 중단... 5초간 기다립니다.')
    loop = asyncio.get_event_loop()
    # run_in_executor: 코루틴으로 짜여져 있지 않은 함수(서브루틴)을
    # 코루틴처럼 실행시켜주는 메소드

    # Params of run_in_executor:
    # executor(None: default loop executor), func, *args
    # 또는 concurrent.futures.Executor의 인스턴스 사용가능
    await loop.run_in_executor(None, time.sleep, 5)

    print('코루틴 1 재개')


async def coroutine_2():
    print('코루틴 2 시작')
    print('코루틴 2중단... 5초간 기다립니다.')
    loop = asyncio.get_event_loop()
    await loop.run_in_executor(None, time.sleep, 4)
    print('코루틴 2 재개')

if __name__ == "__main__":
    # 이벤트 루프 정의
    loop = asyncio.get_event_loop()

    # 두 개의 코루틴이 이벤트 루프에서 돌 수 있게 스케쥴링

    start = time.time()
    loop.run_until_complete(asyncio.gather(coroutine_1(), coroutine_2()))
    end = time.time()

    print(f'time taken: {end-start}')
```

`asyncio.sleep`을 사용한 것과 거의 유사한 결과를 볼 수 있습니다. 원리는 무엇일까요? 사실 이것은 비동기적 처리처럼 보이지만 실제로는 **쓰레딩**을 이용한 것이라고 할 수 있습니다. 첫번째 글에서 언급했던 **멀티쓰레드**기억나시나요? 비동기적 처리보다는 비효율적이었지만 작업이 완료되길 기다리고 다른 작업을 시작하는 것보다는 빠르게 작업을 처리할 수 있었습니다.

하지만, 쓰레딩을 이용했을 때는 비용도 만만치 않다. 파이썬에서는  GIL 때문에 쓰레드들이  동시에 작업이 불가능하기 때문에, 다른  쓰레드를 호출하는데 걸리는 시간을  낭비합니다.(컨텍스트 스위칭의 비용)

__비교해보기__

```python
import asyncio
import time
from concurrent.futures import ProcessPoolExecutor, ThreadPoolExecutor


async def sleep(executor=None):
    loop = asyncio.get_event_loop()
    await loop.run_in_executor(executor, time.sleep, 1)


async def main():

    # max_workers에 따라서 실행시간이 달라지는 것을 확인할 수 있다.
    # (하지만 workers가 많아질수록 컨텍스트 스위칭 비용도 커진다.)
    # None으로 하는 경우는 디폴트로 설정한 workers수가 작아서 인지 훨씬 더 오래걸린다.

    executor = ThreadPoolExecutor(max_workers=1000)

    # asyncio.ensure_future함수는 태스크를 현재 실행하지 않고,
    # 이벤트 루프가 실행될 때 실행할 것을 보증해주는 함수
    futures = [
        asyncio.ensure_future(sleep(executor)) for i in range(1000)
    ]
    await asyncio.gather(*futures)


if __name__ == "__main__":
    start = time.time()
    # python 3.7부터는 이벤트 루프를 따로 명시적으로 지정하지 않고,
    # asyncio.run으로 돌릴 수 있다.
    asyncio.run(main())
    end = time.time()
    print(f'time taken: {end-start}')
```

__모두 비동기 구성이 된 함수들로 구성됨__(asyncio.sleep은 코루틴이므로 컨텍스트스위치 비용안듬)

```python
import asyncio
import sqlite3
import time


async def sleep():
    await asyncio.sleep(1)


async def main():
    # asyncio.sleep은 아무리 많아져도 비동기적으로 잘 돌아간다.
    futures = [
        asyncio.ensure_future(sleep()) for i in range(10000)
    ]
    await asyncio.gather(*futures)


if __name__ == "__main__":
    start = time.time()
    asyncio.run(main())
    end = time.time()
    print(f'{end-start}')
```

## 실습

[자세히](https://sjquant.tistory.com/15?category=797018)

