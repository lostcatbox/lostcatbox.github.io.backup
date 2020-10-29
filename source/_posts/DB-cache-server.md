---
title: DB-cache-server에 대해서
date: 2020-10-23 10:50:04
categories: [DB]
tags: [Mysql, DB]
---

[필요이유 자세히](https://tmdahr1245.tistory.com/120)

[자세히 포스팅되어있는곳](https://nangkyeong.tistory.com/entry/%EC%9D%B4%EA%B2%83%EC%9D%B4-MySQL%EC%9D%B4%EB%8B%A4%EB%A1%9C-%EC%A0%95%EB%A6%AC%ED%95%B4%EB%B3%B4%EB%8A%94-%EC%9D%B8%EB%8D%B1%EC%8A%A4-%EA%B0%9C%EB%85%90)

[mysql lnnoDB의 메모리 캐시 서버로 변신(이걸로 꼭 실습해보기)](https://gywn.net/2019/09/mysql-innodb-as-cache-server-config/)

[redis와 mem 비교글 자세히](https://deveric.tistory.com/65)

[spring이용하여 redis 캐시 서버 만들기](https://anomie7.tistory.com/43)

[django cache,..ㅎㄷㄷ](https://dingrr.com/blog/post/django-seo-%EB%8D%94-%EB%B9%A0%EB%A5%B4%EA%B2%8C-cache%EC%99%80-%EC%95%95%EC%B6%95)

[도커에 redis설치](https://emflant.tistory.com/235)

[redis 캐시 설명](https://brunch.co.kr/@jehovah/20)

[redis 캐시 설명 2](https://webisfree.com/2017-10-26/redis-%EB%A0%88%EB%94%94%EC%8A%A4%EB%A5%BC-%EC%82%AC%EC%9A%A9%ED%95%9C-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4-%EC%BA%90%EC%8B%B1%EC%84%9C%EB%B2%84-%EC%9A%B4%EC%98%81%ED%95%98%EA%B8%B0)

# 왜?

솔직히 말하자면, 실제로 큰 데이터를 다뤄본적이 없기에 지금 필요이유를 체감한 적은 없다.

하지만 구성해보고싶었다. DB를 캐싱한다는 것은 속도를 높일 수 있는 수단이 될수있기 때문이다. 그냥 해보고싶어서 하는거다! 

(추후에 체감하면 수정예정)

# 캐시

- CPU 성능을 높이기 위한 L1, L2, L3 캐시를 사용하는 CPU 캐시, 
- 디스크의 내용을 RAM에 저장하는 DISK 캐시
- web 브라우저의 캐시나 iOS, Android와 같은 미들웨어, 애플리케이션에서 사용하는 단말 애플리케이션 단위의 캐시
- DB나 웹 서버, 대용량 서버에서 사용하는 분산 캐시 등으로 크게 나눌 수 있을 것이다. 분산 환경 또는 서버 환경에서 개발하면서 만들고 경험했던 캐시 시스템을 소개하고, 분산 캐시의 대표 주자인 Redis와 Memcached 등이 만들어지게 되는 배경을 살펴보고자 한다.

# Redis와 Memcached 스펙 비교

|                   | **Redis**                                              | **Memcached**                                                |
| ----------------- | ------------------------------------------------------ | ------------------------------------------------------------ |
| **저장소**        | In Memory Storage                                      | ''                                                           |
| **저장 방식**     | Key-Value                                              | ''                                                           |
| **데이터 타입**   | String, Set, Sorted Set, Hash, List                    | String                                                       |
| **데이터 저장**   | Memory, Disk                                           | Only Memory                                                  |
| **메모리 재사용** | 메모리 재사용 하지 않음(명시적으로만 데이터 삭제 가능) | 메모리 부족시 LRU 알고리즘을 이용하여 데이터 삭제 후 메모리 재사용 |
| **스레드**        | Single Thread                                          | Multi Thread                                                 |
| **캐싱 용량**     | Key, Value 모두 512MB                                  | Key name 250 byte, Value 1MB                                 |

 

# RDBMS의 문제점

서버를 구성할 때 DB는 주로 관계형 DB를 사용한다.

구글이나 네이버에 이용자들이 쿼리 요청을 필요하는 일들을 많이한다면, 그만큼 데이터가 쌓이고, 쿼리를 하나 실행하는것도 오래걸린다. 공공데이터 포탈에서 2000만 cardinality규모의 데이터를 받아 샘플 DB를 생성하고 조회하면 index를 걸어놓았음에도 불구하고 20초 넘게 걸린다. 간단한 조회 쿼리가 아니라 다양한 조건이 걸리고 몇 개의 테이블이 조인되면 더 오래 걸릴것이다

# 데이터 베이스 데이터 캐싱

DB를 튜닝하고 다원화하고 좀 더 효율적으로 인덱스를 걸수도 있겠지만, 근본적인 문제인 RDBMS로의 쿼리 전송을 줄이는 방법도 있다. 데이터 캐싱을 하면 쿼리 요청을 줄일수있다!

데이터베이스에서의 데이터 캐싱이란 처음 쿼리를 전송할 때는 데이터베이스에서 직접 가져오지만 두번째 쿼리부터는 캐시에 저장된 데이터를 가져와 데이터베이스까지 직접 쿼리를 전송하지 않아도 되는것이다 (OS hit, miss개념인듯)

__주로 데이터베이스에서 캐시용으로 NoSQL 류의 Redis나 Memcached를 사용한다.__ 두 DB 모두 디스크 기반이었던 기존의 RDBMS 들과 달리 메모리 기반이며 성능을 목적으로 개발되었기 때문에 캐시 서버로 주로 사용된다. 메모리 기반만 공통점이며 상당 부분 이 둘은 상당부분 다르다.

가장 기본적이고 단순한 Key-Value 형태로 메모리에 저장하고
또한 내부적으로도 성능에 목적을 둔 기능들이 많기 때문에 데이터 캐시 서버로 사용하기 매우 좋다.

읽기는 많지만 쓰기는 적은 데이터 그리고 데이터의 양이 많지 않은 데이터를 캐싱 하는 것이 적합하다고 한다.
또한 캐시에도 데이터가 쌓이면 언젠가는 RDBMS와 다를 게 없어지므로 적절한 __데이터 캐시 만료 기간을 설정__해야 한다.

# 데이터 캐싱이 적용된 시스템에서 CRUD

website가 가장 먼저 바라보는것은 캐시 서버이다. 따라서 캐시 서버의 해당값이 있냐, 없냐로 조건이 나뉜다. 그 이후 로직을 생각해보자.

![스크린샷 2020-10-23 오후 2.36.14](https://tva1.sinaimg.cn/large/0081Kckwgy1gjz7l9xxjbj30wd0u0naa.jpg)

- Create : Database에 데이터를 생성한다.
- Update : Datebase에 데이터를 수정하고 캐시서버에도 데이터가 있다면 마찬가지로 수정한다.
- Delete : Database에 데이터를 삭제하고 캐시서버에도 데이터가 있다면 마찬가지로 삭제한다.

물론 캐싱이 만능은 아닐 것이다. __비용도 비용이지만, 제대로 사용하지 못하면, 최신으로 업데이트되지 않은 “틀린” 데이터를 클라이언트에게 제공할 수도 있고 비용이 최적화되지 않을 수도 있다.__
가장 중요한 건 기존의 시스템에 정확히 어떤 부분에서 성능이 저하되는지를 주안점으로 두고 그에 대한 대처를 가장 효율적으로 하는 것이 좋지 않을까 싶다.

> Read 요청시- 방문자, 사용자의 새로운 데이터 서버에 요청- Redis 서버에서 요청 데이터가 있는지 확인
> \- 데이터가 존재하는 경우 만료여부 확인 후 이 정보를 반환
> \- 정보를 반환한 경우 시간을 현재로 업데이트 후 종료
> \- 데이터가 만료되었거나 없는 경우 삭제 후 주 서버에 요청
> \- 주 서버에서 받은 데이터를 캐싱, 데이터베이스에 저장
> \- 이 값을 방문자에게 반환 후 종료
>
>
> CUD Create, Update, Delete 요청시이 경우 앞의 과정과는 조금 다르다. 그 이유는 **데이터에 변화가 생겼으므로 해당하는 값의 데이터는 캐싱 값이 아닌 현재 실시간 정보를 보내주는 것이 효과적이기 때문**이다. 캐싱 만료시간이 아무리 짧게 설정되어도 없는 데이터를 사용자가 보게되는 일으도록 해야할 것이다. 그러기 위해 필요한 조치는 비교적 간단하다. CUD 요청시 아래와 같이 처리한다.
>
> \- 방문자가 CUD를 서버에 요청
> \- CUD 요청을 주서버에 반영하여 업데이트
> \- 변경된 데이터 값을 캐싱데이터인 Redis에서 찾아 삭제 후 종료
>
> 여기서 가장 중요한 점은 캐싱을 제공하는 경우 단순하게 정보를 제공하는 주분만 고려하는 것이 아니라 다양한 상황에 대처해야한다는 점이다. 이 중 한 가지가 위와같이 CUD처럼 데이터에 중요한 변경사항이 있는 경우 기존의 캐싱 데이터를 삭제처리하는 과정이다.

# Memcached plugin

MySQL 5.6부터 들어왔던 것 같은데.. **InnoDB의 데이터를 memcached 프로토콜을 통해서 접근할 수 있다는 것**을 의미합니다. 플러그인을 통하여 구동되기 때문에.. 캐시와 디비의 몸통은 하나이며, InnoDB 데이터에 직접 접근할 수 있기도 하지만, 캐시 공간을 별도로 두어.. 캐시처럼 사용할 수도 있어요. (옵션을 주면, set 오퍼레이션이 binlog에 남는다고 하던데.. 해보지는 않음 ㅋㅋ)

![스크린샷 2020-10-25 오후 6.34.27](https://tva1.sinaimg.cn/large/0081Kckwgy1gk1pps8bgbj313t0u016e.jpg)

 데이터베이스의 테이블 데이터를.. memcached 프로토콜로 직접적으로 access할 수 있다면 어떨까요? 메모리 위주로 데이터 처리가 이루어질 때.. 가장 많은 리소스를 차지하는 부분은 바로 **쿼리 파싱과 옵티마이징 단계**입니다. 만약 **PK 조회 위주의 서비스이며.. 이것들이 자주 변하지 않는 데이터**.. 이를테면 “서비스토큰”이라든지, “사용자정보” 같은 타입이라면..?

심지어 이 데이터는 이미 InnoDB 라는 안정적인 데이터베이스 파일로 존재하기 때문에.. 예기치 않은 정전이 발생했을지라도, 사라지지 않습니다.

# Redis

[꼭읽기](https://brunch.co.kr/@jehovah/20)

 # 구성해보기(redis)

 간단하게만 해볼 것이다.

__docker를 이용한다. (network구성,  volume 등을 신경써야한다.)__

## redis 설치

docker-compose를 이용할 것이며 cache로 이용할거면 docker에 network를 하나 생성해놓는게 유리할것이다

```
# docker network 생성
docker network create redis-cache-server
```

다음은 docker-compose.yml 구성이다.

```
# docker-compose.yml

version: "3.0"

services:
        redis1:
                container_name: redis-cache
                image: redis:alpine
                command: redis-server --requirepass yourpassword --port 6379
                restart: always
                ports:
                        - 6379:6379
                volumes:
                        - ./data:/data

networks:
        default:
                external:
                        name: redis-cache-server
```

6379외부 포트로 설정해주었고 `yourpassword` 를 수정해서 쓰면된다.

또한 external로 docker-compose network망이 아닌 먼저 만들어져있는 망을 쓴 것에 주의하자. (추후에 mysql 컨테이너도 같은 network에 넣어줄것이다.)

`docker-compose up -d` 실행해서 컨테이너를 올리자

## redis 테스트

`pip install redis` 한 후

python으로 접속 확인해보자

```python
import redis

# 레디스 클라이언트를 만든다
# Redis<ConnectionPool<Connection>>
r = redis.Redis(host="192.168.88.244", port=6379, password="yourpassword", 
                decode_responses=True)

print(r.ping())                     #// True
print(r.set(name="야", value="호")) #// True
print(r.get(name="야"))             #// 호
```

(개인 서버 내부망를 쓰고 VPN접속할것이므로 192.168.88.244 우분투 IP로 접속했다.)

결과를 확인하자

## mysql을 Python으로 조회하기

[자세히](https://yurimkoo.github.io/python/2019/09/14/connect-db-with-python.html)

일단 캐시 서버로 쓰기전에 간단하게  python으로 mysql과 연결해보겠다.

```python
import pymysql
mysql_db = pymysql.connect(
    user="root",
    passwd="lostcatboxmysql",
    host="192.168.88.244",
    port=7676,
    db="employees",
    charset = "utf8"
)

cursor = mysql_db.cursor()
sql = "select * from employees;"
cursor.execute(sql)
result = cursor.fetchall()
```

만약 where문을 쓰고 싶다면

```sql
cursor = mysql_db.cursor()
sql = '''select * from employees where last_name=%s;'''
cursor.execute(sql, ("Facello"))
result = cursor.fetchall()
```

결과는 판다스로 출력한다.

```Python
import pandas as pd

result = pd.DataFrame(result)
result
```

## Redis cache로 사용해보기

정말 간단하게 구현하였다

request.py는 먼저 캐시로 요청하고 null이면 DB를 조회 요청 후 결과를 캐시에 업데이트하며, 다시 캐시로 조회를 한다. 그러면 무조건 hit가 되고 원하는 값을 받을 수 있다.

```python
#request.py
import redis
import pymysql
import time

# 레디스 클라이언트를 만든다
# Redis<ConnectionPool<Connection>>
r = redis.Redis(host="192.168.88.244", port=6379, password="password", 
                decode_responses=True)
                
#pymysql로 mysql 연결
mysql_db = pymysql.connect(
    user="root",
    passwd="password",
    host="192.168.88.244",
    port=7676,
    db="employees",
    charset = "utf8"
)

#여기부터 실제 로직
result_list = []
#id=int(input("emp_no 입력 (6자리)")) #직접입력귀찮아서;
for emp_no in range(10200,10300):
    id= int(emp_no)
    first_time = time.time()
    result = r.get(name=id)
    print(id)

    if not result:
        print("캐시에서 가져오지 못함")
        cursor = mysql_db.cursor()
        sql = '''select emp_no,first_name from employees where emp_no=%s'''
        cursor.execute(sql, (int(id)))
        result = cursor.fetchone()
        r.set(name=result[0], value=result[1])


    else:
        print("캐시에서 가져옴!")

    result = r.get(name=id) #if문에 넣을수있지만 동일한 조건을 주기위함
    last_time = time.time()
    timetotime = last_time-first_time
    print(timetotime, "초 걸림")
    print(result)
    result_list.append(timetotime)
    
print("완료")
print(sum(result_list)/len(result_list))
```

![스크린샷 2020-10-27 오후 8.17.35](https://tva1.sinaimg.cn/large/0081Kckwgy1gk44394qbxj30my06kdgc.jpg)

![스크린샷 2020-10-27 오후 8.17.15](https://tva1.sinaimg.cn/large/0081Kckwgy1gk44376vvqj30kl06174s.jpg)

2배 더 빨랐다!

