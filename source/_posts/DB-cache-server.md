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
| **저장소**        | In Memory Storage                                      |                                                              |
| **저장 방식**     | Key-Value                                              |                                                              |
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



![스크린샷 2020-10-23 오후 2.36.14](https://tva1.sinaimg.cn/large/0081Kckwgy1gjz7l9xxjbj30wd0u0naa.jpg)

- Create : Database에 데이터를 생성한다.
- Update : Datebase에 데이터를 수정하고 캐시서버에도 데이터가 있다면 마찬가지로 수정한다.
- Delete : Database에 데이터를 삭제하고 캐시서버에도 데이터가 있다면 마찬가지로 삭제한다.

물론 캐싱이 만능은 아닐 것이다. __비용도 비용이지만, 제대로 사용하지 못하면, 최신으로 업데이트되지 않은 “틀린” 데이터를 클라이언트에게 제공할 수도 있고 비용이 최적화되지 않을 수도 있다.__
가장 중요한 건 기존의 시스템에 정확히 어떤 부분에서 성능이 저하되는지를 주안점으로 두고 그에 대한 대처를 가장 효율적으로 하는 것이 좋지 않을까 싶다.

# Memcached plugin

MySQL 5.6부터 들어왔던 것 같은데.. **InnoDB의 데이터를 memcached 프로토콜을 통해서 접근할 수 있다는 것**을 의미합니다. 플러그인을 통하여 구동되기 때문에.. 캐시와 디비의 몸통은 하나이며, InnoDB 데이터에 직접 접근할 수 있기도 하지만, 캐시 공간을 별도로 두어.. 캐시처럼 사용할 수도 있어요. (옵션을 주면, set 오퍼레이션이 binlog에 남는다고 하던데.. 해보지는 않음 ㅋㅋ)

![스크린샷 2020-10-25 오후 6.34.27](https://tva1.sinaimg.cn/large/0081Kckwgy1gk1pps8bgbj313t0u016e.jpg)

 데이터베이스의 테이블 데이터를.. memcached 프로토콜로 직접적으로 access할 수 있다면 어떨까요? 메모리 위주로 데이터 처리가 이루어질 때.. 가장 많은 리소스를 차지하는 부분은 바로 **쿼리 파싱과 옵티마이징 단계**입니다. 만약 **PK 조회 위주의 서비스이며.. 이것들이 자주 변하지 않는 데이터**.. 이를테면 “서비스토큰”이라든지, “사용자정보” 같은 타입이라면..?

심지어 이 데이터는 이미 InnoDB 라는 안정적인 데이터베이스 파일로 존재하기 때문에.. 예기치 않은 정전이 발생했을지라도, 사라지지 않습니다. 물론, 파일의 데이터를 메모리로 올리는 웜업 시간이 어느정도 소요될테지만.. 최근의 DB의 스토리지들이 SSD 기반으로 많이들 구성되어가는 추세에서, 웜업 시간이 큰 문제는 될 것 같지는 않네요.

MySQL InnoDB memcached plugin을 여러 방식으로 설정하여 사용할 수 있겠지만, 오늘 이야기할 내용은, memcache 프로토콜만 사용할 뿐, 실제 액세스하는 영역은 DB 데이터 그 자체임을 우선 밝히고 다음으로 넘어가도록 하겠습니다.

 # 구성해보기

오라클 문서([innodb-memcached-setup](https://dev.mysql.com/doc/refman/8.0/en/innodb-memcached-setup.html))를 참고할 수도 있겠습니다만, 오늘 이 자리에서는 memcached 플러그인을 단순히 memcache 프로토콜을 쓰기 위한 용도 기준으로만 구성해보도록 하겠습니다.

우선, InnoDB 플러그인 구성을 위해 아래와 같이 memcached 관련된 스키마를 구성합니다. 🙂 여기서 $MYSQL_HOME는 MySQL이 설치된 홈디렉토리를 의미하며, 각자 시스템 구성 환경에 따라 다르겠죠.

```sql
create database innodb_memcached_config character set utf8;
show databases;
use innodb_memcached_config;

CREATE DATABASE memcache_test character set utf8;
CREATE TABLE `memcache_test`.`token` (
    `id` varchar(32) NOT NULL,
    `token` varchar(128) NOT NULL,
     PRIMARY KEY (`id`)
);


use memcache_test;
select count(*) from token;
select * from token;
insert ignore into token 
select md5(rand()), concat(uuid(), md5(rand())) from dual;
insert ignore into token 

select md5(rand()), concat(uuid(), md5(rand())) from token;
```

```
use innodb_memcache;
update cache_policies set 
get_policy = 'innodb_only', 
set_policy = 'disabled', 
delete_policy='disabled', 
flush_policy = 'disabled';
```

https://gywn.net/2019/09/mysql-innodb-as-cache-server-config/