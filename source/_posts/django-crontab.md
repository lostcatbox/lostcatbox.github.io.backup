---
title: django-crontab 사용하기
date: 2021-01-15 12:22:58
categories: [Skill]
tags: [Python, Djagno]
---

# 왜?

세번째 외주를 진행하는데 서버에서 몇시간, 몇분마다 작업해야하는 요청 및 관련 처리가 생겼다. 그래서 간단하게 쓸수있는 것을 찾아보니  django-crontab  이 있어서 기록해놓는다

> 장고 서버 데몬 실행
>
> ```bash
> nohup manage.py runserver 0.0.0.0:80 &
> ```
>
>   중단 방법
>
> ``` bash
> ps -ef | grep python
> 
> kill -9 <process_id_no>
> ```

# Django-crontab

[자세히](https://wave1994.tistory.com/112)

## 설치

```bash
pip3 install django-crontab
```

##  setting.py

```python
DJANGO_APPS = [
    'django_crontab',  #추가해주기
]

CRONJOBS = [
    ('*/5 * * * *', 'homepage.cron.crontab_getndelete'),
] # 시간, 원하는 함수위치
```

> 분,시,일,월,요일 순이며, 매분 매시간이면, \*\/\<number\>처럼 적으면 된다. 위에 예시는 5분마다 함수를 실행한다.

## 사용법

 ```python
python3 manage.py crontab add # 프로세스 생성
python3 manage.py crontab show #프로세스 보기
python3 manage.py crontab remove #프로세스 제거
sudo corntab -l #프로세스 보기

python3 manage.py crontab run <hash_id> #id 값은 show했을때 나오는 id값이다, 디버깅하자.
 ```

# 실수

run으로 검토후 실행되는지 확인했지만, 실제로는 원하는 결과가 나오지 않았다.

같은 인증, 토큰을 사용하는 함수를 동시에 실행해버리면  TOO MANY REQUEST 오류가 뜰수있다.

같은 인증, 토큰을 사용하는 작업끼리 모아놓고 하나의 함수를 cron.py 에 모아놓고 crontab add 하자



