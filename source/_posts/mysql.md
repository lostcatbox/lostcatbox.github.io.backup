---


title: Mysql 기본 공부
date: 2020-10-02 15:19:38
categories: [DB]
tags: [Mysql, DB, Basic]
---

[원본 강의 및 출처](https://stricky.tistory.com/202)

[다끝나면 읽어보기 mysql vs postgresql](https://valuefactory.tistory.com/497)

# 왜?

모든 데이터 처리(읽기, 쓰기 등)와 서버의 트래픽 관리에서는 반드시 DB의 설계가 안정성과 성능을 좌우할 수 있다.

DB에 쿼리를 최대한 적게 보내는 것이 목적이며, RDBMS와 NOSQL에 따라 잘하는 것이 다르다.

분명 RDB와 NOSQL 각자 하나씩은 다뤄보면서 앞으로 DB를 설계 할 상황이나 만날 오류와 한계를 미리 학습하면 추후에 다양한 백엔드 작업시 많은 도움이 될 것이라고 생각하며, 학습을 시작했다.

# SQL

**SQL이란 데이터베이스의 언어입니다. 관계형 데이터베이스에서 데이터를 조작하고 쿼리(요청)하는 표준 언어**.

각각의 RDBMS (oracle, mysql, mariadb, ms-sql, postgresql, greenplum 등등)가 있지만 그중에 하나의 데이터베이스를 골라 SQL을 공부하 면 된다.

ANSI SQL 문법을 토대로 강의를 진행하여 다른 데이터베이스를 사용하시더라도 진행에 무리가 없도록 한다.

> 1986년 SQL-86의 명칭으로 ANSI에 의해 최초로 표준화된 SQL문법을 말하며, ANSI 표준으로 작성된 SQL은 모든 데이터베이스에서 호환된다. 기본적인 데이터 조회 구문은 ANSI SQL을 이용해서 작성이 가능하나, 특정 DBMS에서만 제공하는 함수를 사용하는 경우에는 데이터 조회가 불가능하다.

> mysql 세팅은 docker로 진행하였고, 내가 할수있는 가장 간단한 방법으로 docker-compose이용하였다
>
> ```
> version: '3.1'
> 
> services:
>    practice-mysql:
>      container_name: practice-mysql
>      image: mysql:5.7
>      ports:
>              - 7676:3306
>      restart: always
>      environment:
>        MYSQL_ROOT_PASSWORD: root 비번
>        MYSQL_DATABASE: DB이름
>        MYSQL_USER: 아이디
>        MYSQL_PASSWORD: 비번
> ```
>
> 

## SQL 명령어 종류

- DDL - Data Definition Language (데이터 정의 언어)

  > **CREATE**
  >
  > 데이터베이스 내 개체 (테이블, 인덱스 제약조건, 프로시저, 펑션 등)을 생성 할 때
  >
  > **DROP**
  >
  > 데이터베이스내 개체를 삭제할 때
  >
  > **ALTER**
  >
  > 데이터베이스 내 개체의 속성 및 정의를 변경할 때
  >
  > **RENAME**
  >
  > 데이터베이스내 개체의 이름을 변경 할 때
  >
  > **TRUNCATE**
  >
  > 테이블 내 모든 데이터를 빠르게 삭제할 때

  

- DML - Data Manipulation Language (데이터 조작 언어)

  > **INSERT**
  >
  > 특정 테이블에 데이터를 신규로 삽입할 때
  >
  > **UPDATE**
  >
  > 특정 테이블 내 데이터의 전체, 또는 일부를 새로운 값으로 갱신 할 때
  >
  > **DELETE**
  >
  > 특정 테이블 내 데이터의 전체, 또는 일부를 삭제 할 때
  >
  > **SELECT**
  >
  > 특정 테이블내 데이터의 전체 또는 일부를 획득할 때

  

- DCL - Data Control Language (데이터 제어 언어)

  > **GRANT**
  >
  > 데이터베이스 사용자에게 특정 작업의 수행 권한을 부여할 때
  >
  > **REVOKE**
  >
  > 데이터베이스 사용자에게 부여권 수행 권한을 박탈할 때
  >
  > **SET TRANSACTION**
  >
  > 트랜잭션 모드로 설정 할 때
  >
  > **BEGIN**
  >
  > 트랜잭션의 시작을 의미
  >
  > **COMMIT**
  >
  > 트랜잭션을 실행 할 때
  >
  > **ROLLBACK**
  >
  > 트랜잭션을 취소 할 때
  >
  > **SAVEPOINT**
  >
  > 롤백 지점을 설정 할 때
  >
  > **LOCK**
  >
  > 테이블 자원을 점유 할 때

  

# select를 잘 이용하는 방법

다른 명령어들이 많이 있다. create, insert, update, alter, delete, rename, commit 등등... 수많은 데이터베이스 SQL 명령어들이 있지만 이 모든 건 select를 잘하기 위해서 있는 것이다.

##  SQL select 문장을 사용하기 위한 용어 정리

행과 열은 즉 , row와 column으로 1:1 대응이다.

데이터베이스의 테이블에서 데이터를 가지고 오는 방법은 크게 두 가지로 나뉩니다. 

__Projection__ = 원하는 column만 가지고 오는 방법

**Selection** = 다른 하나는 원하는 row만 가지고 오는 방법

![스크린샷 2020-10-02 오후 4.22.39](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjb0nj0ushj311i0gkguo.jpg)

##  DESC 사용하기(Describe)

DESC 명령은 특정 테이블에 어떤 칼럼이 있는지 조회하는 명령어입니다.

```sql
create database kmong; # kmong은 데이터베이스명 입니다. 자신이 원하시는걸로 만드시면 됩니다.

use kmong; # 사용선언

create table select_test ( name varchar(50), dept_cd varchar(1), phone varchar(15), address varchar(100) ) character set utf8;

desc select_test;  # 테이블 칼럼 목록 확인가능
```

## 원하는 데이터만 select 하기

원하는 행을 가져오는거니까

먼저 데이터 추가후 (DB이름.table이름에 추가되는 데이터...)

```sql
INSERT INTO kmong.select_test (name, dept_cd, phone, address) VALUES ('홍길동', 'A', '01023456789', '조선 한양읍 ');
INSERT INTO kmong.select_test (name, dept_cd, phone, address) VALUES ('손흥민', 'A', '0112345434', '영국 런던 ');
INSERT INTO kmong.select_test (name, dept_cd, phone, address) VALUES ('박찬호', 'C', '01023433456', '충남 공주 ');
INSERT INTO kmong.select_test (name, dept_cd, phone, address) VALUES ('김유신', 'D', '0187766645', '신라 경주 ');
INSERT INTO kmong.select_test (name, dept_cd, phone, address) VALUES ('박나래', 'D', '0192929384', '서울특별시 영등포구 ');
INSERT INTO kmong.select_test (name, dept_cd, phone, address) VALUES ('강감찬', 'E', '01023432123', '고려');
```

```sql
select * from kmong.select_test; #모든 필드가 출력됨

select name, phone from select_test; #projection하는법
```

__이번엔 where이라는 키워드에 대해서 알아보겠습니다.__

where는 조건절이라고 부르기도 합니다. 위에서 알아봤던 selection에 대한 내용인데, 어떤 테이블에 많은 row들 가운데 특정한 조건을 입력하여 조건에 해당하는 데이터만 가지고 오라는 명령어입니다. 아래와 같이 select 문을 작성해서 데이터베이스에서 실행해 보겠습니다.

```sql
select * from kmong.select_test 
where dept_cd = 'A';
```

where은 6개의 row만 출력됬으므로 특정 row가져옴(= selection)

즉, __select__ 명령어 바로 뒤에 출력을 원하는 칼럼명을 쓰면 그 칼럼만 출력을 하라는 의미, __from__ 뒤 자리는 테이블명이 오는데, 여기에 다른 테이블 명을 쓰면 그 테이블에 해당하는 데이터를 출력하라는 의미, __where__ 뒤에 오는 내용은 어떤 row를 걸러서 출력을 할지를 결정하게 되는것 입니다.

**select, from, where**를 키워드라고 부릅니다. 이는 mysql이나 oracle 등의 DBMS에서 미리 정해놓은 단어라는 걸 알고 있으면 됩니다. 위 그림과 같은 모습이 우리가 앞으로 공부할 select 명령어의 가장 기본적인 모습이라 생각하면 됩니다.

##  표현식 (Expression) 사용하기

표현식 (Expression) 이란 칼럼의 데이터 외에 다른 문자열이나 내용을 출력하고 싶을 때 사용할 수 있습니다.

```sql
select name, '님 안녕하세요!!' from kmong.select_test;
```

![스크린샷 2020-10-02 오후 5.08.48](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjb1zi6gbcj30em07wwgx.jpg)

## 컬럼명 대신 별칭(alias)을 사용하기

name, 님 안녕하세요!!라고 칼럼명이 표시되어 있습니다. 이것을 별칭(alias)으로 표현하는 방법을 알아보겠습니다. select 명령은 아래와 같이 실행하시면 됩니다.(두 가지 방법이 있습니다. 결과는 같습니다)

```sql
select name as 이름, '님 안녕하세요!!' as 인사문구 from kmong.select_test; #as를 사용하여 칼럼명을 지정함.
```

## DISTINCT로 중복된 값을 제외하고 출력하기

**distinct** 명령이 중복된 값을 제외하고 출력하라는 명령입니다. 결과를 확인해 보겠습니다. (dept_cd는 속한 그룹을 나타내는 필드인데, 종류를 알고싶다면?)

```sql
select distinct dept_cd from kmong.select_test;
```

## 연결 연산자 함수로 칼럼 값을 붙여서 출력하기

```sql
select concat(name,'의 부서코드는 ',dept_cd,' 입니다.') from kmong.select_test;
```

![스크린샷 2020-10-02 오후 5.18.41](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjb29rh5h4j308c06ggmx.jpg)

concat이라는 문자열 또는 칼럼의 값을 연결해주는 함수를 사용한 것입니다.

```sql
select concat(name, '의 부서코드는',dept_cd,'입니다') from kmong.select_test
where dept_cd="A"; #조건에 맞는 원하는 행을 추출하는 것이므로 selection
```

위에 sql은 among.select_test 테이블에서 dept_cd="A"조건을 만족하는 행에 대해 concat(name, '의 부서코드는',dept_cd,'입니다')  출력한다.



# sql 독학 강의 # select를 잘 이용하는 방법(2)

## 산술 연산자 사용해보기

다른 프로그래밍 언어와 마찬가지로 SQL 또한 +,-,*, / 를 가진다

먼저 더미를 추가해주자

```sql
create table kmong.exam_result
( 
    name varchar(50),
    math int(10),
    english int(10),
    korean int(10)
) character set utf8;
INSERT INTO kmong.exam_result (name, math, english, korean) VALUES ('호날두', 98, 65, 56); 
INSERT INTO kmong.exam_result (name, math, english, korean) VALUES ('메시', 87, 76, 87); 
INSERT INTO kmong.exam_result (name, math, english, korean) VALUES ('치차리토', 76, 87, 75); 
INSERT INTO kmong.exam_result (name, math, english, korean) VALUES ('살라', 78, 88, 55); 
INSERT INTO kmong.exam_result (name, math, english, korean) VALUES ('라모스', 56, 90, 89); 
INSERT INTO kmong.exam_result (name, math, english, korean) VALUES ('모드리치', 90, 95, 78); 
INSERT INTO kmong.exam_result (name, math, english, korean) VALUES ('케인', 99, 82, 83);
```

평균값을 구하기 위해서는

```sql
select name, math, english, korean, (math + english + korean)/3 as avg, 
from kmong.exam_result
```

즉, avg라는 alias(별명)을 가진 컬럼이 생기고 평균값이 출력된다.

## where절에 비교 연산자를 사용해 보기

앞선 시간에 where절에 문자열을 넣어서 데이터중 조건에 맞는 일부 row만 출력하는 것을 배워보았습니다. where 절에 비교 연산자를 넣어서 출력하는 방법을 알아보겠습니다. 비교 연산자는 **<, >, =** 이런 것들을 이야기합니다.

번외로 SQL의 where절에서 사용할 수 있는 다양한 연산자에 대해서 알아보겠습니다.

| **비교연산자 종류**       | **설명**                                   |
| ------------------------- | ------------------------------------------ |
| **=**                     | 같은 조건을 검색                           |
| **!=, <>**                | 같지 않은 조건을 검색                      |
| **>**                     | 큰 조건을 검색                             |
| **>=**                    | 크거나 같은 조건을 검색                    |
| **<**                     | 작은 조건을 검색                           |
| **<=**                    | 작거나 같은 조건을 검색                    |
| **BETWEEN a AND b**       | a 와 b 사이에 있는 값을 검색               |
| **IN(a,b,c)**             | a,b,c 중 어느 하나 인 것을 검색            |
| **like**                  | 특정 패턴을 가지고 있는 조건을 검색        |
| **is Null / is Not Null** | NULL 인 값이나 NULL이 아닌 값을 검색       |
| **a AND b**               | a, b 두 조건 모두를 만족하는 값을 검색     |
| **a OR b**                | a 나 b 중 하나의 조건을 만족하는 값을 검색 |
| **NOT a**                 | a 가 아닌 모든 값을 검색                   |

> **NOT** 연산자는 말그대로 바로 뒤에 오는 조건을 부정하는 역할을 한다. 때문에 혼자서는 되지 않는다.
>
> 예시)
>
> `WHERE NOT user_id IN ('user1','user3')`

##  order by 절을 사용 하여 정렬하여 출력 하기

데이터의 양이 많을 때는 데이터를 어떤 기준으로 정렬하여 보는 것이 편할 때가 있습니다. 이럴 때 SQL에서는 order by 절을 사용 하게 됩니다. order by 역시 select, from, where 등과 마찬가지로 키워드로 분류가 됩니다. 기본적으로 order by를 사용하게 되면 오름차순으로 정렬이 되며, 내림차순으로 정렬을 하고 싶을 때는 desc라는 옵션을 사용하게 됩니다.

```sql
select * from kmong.`exam_result`
order by math; #order by 기본은 오름차순

select * from kmong.`exam_result`
order by math desc; # order by에 desc 옵션주면 내림차순
```

order by 에도 역시 산술 연산자를 사용해서 정렬하여 출력하게 할 수 있습니다.

```sql
select * from kmong.`exam_result`
order by (math+english+korean)/3 # 기본 오름차순

select * from kmong.`exam_result`
order by (math+english+korean)/3 desc # 내림차순
```

` order by 3` 도 써보자 (컬럼에서 3번째를 기준으로하는것)(권장안함.)(컬럼순서바뀌면 기준, 결과값달라지니까.)

```sql
select * from kmong.`exam_result`
order by 3
```

## 집합 연산자 사용하기

집합 연산자 사용하기 실습에 앞서 테이블 하나를 더 만들고, 데이터를 입력하겠습니다.

```sql
create table kmong.exam_result_2 (
  name varchar(50), 
  math int(10), 
  english int(10), 
  korean int(10) 
) character set utf8;
INSERT INTO kmong.exam_result_2 (name, math, english, korean) VALUES ('차범근', 78, 90, 78); 
INSERT INTO kmong.exam_result_2 (name, math, english, korean) VALUES ('서정원', 68, 99, 68); 
INSERT INTO kmong.exam_result_2 (name, math, english, korean) VALUES ('고종수', 84, 96, 98); 
INSERT INTO kmong.exam_result_2 (name, math, english, korean) VALUES ('박지성', 67, 68, 75); 
INSERT INTO kmong.exam_result_2 (name, math, english, korean) VALUES ('최순호', 88, 93, 68);
```

우선 집합 연산자의 종류에 대한 내용을 확인하고 넘어가겠습니다.

그리고, 집합이라고 하면 데이터베이스에서는 기본적으로 한 테이블을 하나의 집합이라고 하고, SQL에서 하나의 select 문으로 나오는 데이터셋을 집합이라고도 표현합니다. 집합 연산자에 대한 내용 확인해보겠습니다.

| **집합연산자 종류** | **내용**                                                     |
| ------------------- | ------------------------------------------------------------ |
| **UNION**           | 두 집합을 더해서 결과를 출력한다. 중복 값 제거하고 정렬을 수행한다. |
| **UNION ALL**       | 두 집합을 더해서 결과를 출력한다. 중복 제거와 정렬을 하지 않는다. |
| **INTERSECT**       | 두 집합의 교집합 결과를 정렬하여 출력한다.                   |
| **MINUS**           | 두 집합의 차집합 결과를 정렬하고 출력한다. SQL의 순서가 중요하다. |

```sql
select * from kmong.exam_result 
union 
select * from kmong.exam_result_2
```

이렇게 UNION을 이용해서 두 select 결과 (집합)을 합칠 수 있습니다.

다음은 UNION과 UNION ALL의 차이점도 한번 확인해보겠습니다

```sql
select * from kmong.exam_result 
union all
select * from kmong.exam_result_2
```

 중복값 제거 유무를 확인가능하다.

이번엔 INTERSECT와 MINUS의 차이점을 비교해보겠습니다.

> mysql의 5.7.29-0 ubuntu0.18.04.1 버전에서는 INTERSECT와 MINUS 기능이 지원하지 않습니다.

아래 테이블 추가

```sql
create table math_student ( 
  name varchar(50), 
  student_no varchar(10) 
) character set utf8;
create table korean_student ( 
  name varchar(50), 
  student_no varchar(10)
) character set utf8; 
INSERT INTO math_student (name, student_no) VALUES ('조단', '111'); 
INSERT INTO math_student (name, student_no) VALUES ('호나우두', '112'); 
INSERT INTO math_student (name, student_no) VALUES ('나달', '113'); 
INSERT INTO math_student (name, student_no) VALUES ('조코비치', '114'); 
INSERT INTO korean_student (name, student_no) VALUES ('조단', '111'); 
INSERT INTO korean_student (name, student_no) VALUES ('호나우두', '112'); 
INSERT INTO korean_student (name, student_no) VALUES ('조현우', '201'); 
INSERT INTO korean_student (name, student_no) VALUES ('루이스', '202');
```



![스크린샷 2020-10-03 오후 2.09.00](/Users/lostcatbox/Library/Application Support/typora-user-images/스크린샷 2020-10-03 오후 2.09.00.png)

아래그림과 같이 집합연산자에 대한 결과값을 표현할 수 있다.

![스크린샷 2020-10-03 오후 2.08.48](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjc2elq8xzj311k0ca4bl.jpg)

# 단일행 함수 잘 사용 하기(문자 함수)

여기서 함수란 무엇을 말하는 것일까요? 함수란 어떤 값을 받아서 그 값을 어떠한 정해진 정의에 의해 변환시켜 변환된 값을 출력하는 것을 말합니다

DBMS에서 함수를 분류하는 기준이 몇 가지 있습니다.

우선은 내장 함수와 사용자 정의 함수로 나눌 수 있습니다. 내장 함수란 우리가 사용하는 각각의 RDBMS에 이미 내장된 함수를 뜻 합니다. 그리고 사용자 정의 함수란 내장 함수를 제외하고 __'create function'__ 문을 사용해서 자신이 필요한 변환 규칙을 적용해 개개인의 유저 혹은 DBA, 개발자들이 만든 함수를 뜻 합니다.

그리고 다른 분류로는 단일행 함수, 복수행 함수로 구분할 수 있습니다. 단일행 함수란 한 행(row)의 값을 받아서 특정 규칙과 정의를 통해 변환시키는 함수이고, 복수행 함수란 여러 행의 값을 한꺼번에 받아서 하나의 행(row)의 결과 값으로 되 돌려주는 함수를 뜻합니다. 이미 알고 계실지도 모르겠지만 가장 보편적인 복수행 함수로는 'count()'가 있습니다.

그리고 또 분류하자면 문자 함수와 숫자 함수, 날짜 함수, 형 변환 함수, 일반 함수 등으로도 분류할 수 있습니다. 여기에 대해서는 천천히 알아보도록 하겠습니다.

![스크린샷 2020-10-03 오후 2.24.44](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjc2v3co1kj30u20u01kx.jpg)

이번 포스팅에서 공부할 내용은 내장 함수이자 단일행 함수이며 문자 함수에 속하는 내용에 대해서 공부하도록 하겠습니다.

```sql
create table kmong.country (
  country_name varchar(100), 
  capital_city varchar(100), 
  continent varchar(100) 
) character set utf8; 
INSERT INTO kmong.country (country_name, capital_city, continent) VALUES ('USA', 'Washington', 'America'); 
INSERT INTO kmong.country (country_name, capital_city, continent) VALUES ('England', 'London', 'Europe'); 
INSERT INTO kmong.country (country_name, capital_city, continent) VALUES ('S.Korea', ' Seoul', 'Asia'); 
INSERT INTO kmong.country (country_name, capital_city, continent) VALUES ('Australia', ' Canberra', 'Oceania'); 
INSERT INTO kmong.country (country_name, capital_city, continent) VALUES ('Ghana', 'Accra', 'Africa'); 
INSERT INTO kmong.country (country_name, capital_city, continent) VALUES ('Argentina', 'Buenos aires', 'America');
```

위 데이터 추가후

`select from kmong.country`해서 아래 테이블 형태 잘 기억해두기

![스크린샷 2020-10-03 오후 2.29.30](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjc301xyx4j30fa084gnj.jpg)

## lower/upper 함수 사용 하기

lower(칼럼명), upper(칼럼명)

```sql
select country_name as 원본, lower(country_name) as 소문자, upper(country_name) as 대문자 from country;
```

내장함수 사용하여 원본, 소문자, 대문자로 출력된것 확인가능

한 테이블의 한 칼럼을 다양하게 가공하여 여러 가지 모습으로 보이게 하는 것이 가능합니다.

## length 함수 사용 하기

length(칼럼명) 

```sql
select country_name, length(country_name) as 길이 from kmong.country;
```

## concat 함수 사용 하기

간단한 사용법을 설명드리자면 concat(칼럼 값, 칼럼 값, '문자열', '문자열') 이런 식으로 칼럼 값 고 문자열을 원하는 데로 넣고 그 사이는 ', '로 구분하여 작성하면 됩니다.

```sql
select concat(country_name,' 의 수도는 ',capital_city,' 입니다!') as 수도소개 from kmong.country;
```

## substr/mid/substring 함수 사용 하기

substr과 mid, substring 함수는 똑같은 함수이다.

substr(칼럼명, 시작할 문자열의 위치 값, 리턴 시킬 값의 길이) 

(함수안에 들어가는 값을 파라미터라고함.)

```sql
select continent as 원본, substr(continent,2,3) as substr, mid(continent,2,2) as mid, substring(continent,2,2) as substring from kmong.country;
```

##  instr 함수 사용 하기

instr 함수는 특정 문자열의 위치를 숫자로 리턴해주는 함수입니다.

instr(칼럼 값, '찾는 문자')

```sql
select continent as 원본, instr(continent, 'A') as A위치 from country; #대소문자 구별 안함, 가장 처음등장하는 인덱스 반환.
```

## lpad/rpad 함수 사용 하기

lpad와 rpad는 간단하게 설명하자면 데이터가 있고, 해당 데이터가 어떤 기준보다 짧을 경우에 원하는 문자를 왼쪽이나 오른쪽으로 자릿수를 맞춰 채워 주는 함수입니다.

lpad(칼럼명, 기준 자릿수, 채워 넣을 숫자 or 문자)

![스크린샷 2020-10-03 오후 2.45.44](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjc3gwpi5rj30re0ewjv1.jpg)

## trim/ltrim/rtrim 함수 사용 하기

trim은 어떤 문자열의 양쪽, 즉 왼쪽, 오른쪽의 공백을 없애는 함수이고, ltrim과 rtrim은 각각 왼쪽관 오른쪽 공백만 없애는 함수들입니다.

trim(칼럼명)

```sql
select capital_city as 원본, trim(capital_city) as trim, ltrim(capital_city) as ltrim, rtrim(capital_city) as rtrim from kmong.country;
```

## replace 함수 사용 하기

replace 함수는 특정 문자열을 찾아서 다른 문자열로 치환하는 함수입니다

replace(칼럼명, '찾을 문자', '치환할 문자')

```
select continent as 원본, replace(continent,'A','고양이') as 'replace' from kmong.country;
```

![스크린샷 2020-10-03 오후 2.49.15](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjc3kko90hj30ba07w75n.jpg)

대소문자 구별함!

# 단일행 함수 잘 사용 하기(숫자 함수)

##  round 함수 사용 하기

round 함수는 입력된 숫자를 반올림한 후 출력하는 함수입니다

round(칼럼명(그냥숫자도 당연가능), 표시할 자리수)

```sql
select student_no, round(student_no) as 값 from korean_student; 

select student_no, round(student_no,1) as 값 from korean_student; (소숫점 첫번쨰 자리까지 표시, 두번째자리에서 반올림)

select student_no, round(student_no,-1) as 값 from korean_student; #십의 자리까지 표시, 일의자리 반올림.
```

##  truncate 함수 사용 하기

truncate 함수는 round 함수와 사용법과 옵션의 의미가 같습니다. truncate 함수의 기능은 입력된 값을 옵션에 따라 지정된 위치에서 버리고 결과를 출력하는 함수입니다.

## mod 함수 사용 하기

mod 함수는 처음 입력된 값을 두 번째 입력된 값으로 나눈 뒤 나눈 값을 제외하고 나머지를 결과로 출력하는 함수입니다.

```sql
select mod(26,3),mod(10,9),mod(4,2);
```

결과 2|1|0 나옴

## ceil 함수 사용 하기

ceil 함수는 입력된 숫자보다 __크면서도, 가장 가까운 정수가 출력됩니다.__

```sql
select ceil(12.6),ceil(11.5),ceil(16.3)
```

 결과 13|12|17 나옴

## floor 함수 사용 하기

floor 함수는 ceil 함수와 **반대 개념**입니다. 

입력된 값보다 작으면서 가장 가까운 정수가 출력되는 함수입니다.

```sql
select floor(12.6),floor(11.5),floor(16.3)
```

결과 12|11|16

## power 함수 사용 하기

power 함수는 첫 번째 입력된 값을 두번째 입력값 만큼 제곱 하여 출력을 하는 함수 입니다.

```sql
select power(1,2),power(2,3),power(3,5)
```

결과 1|8|243



# 단일행 함수 잘 사용 하기(날짜 함수)

날짜 데이터는 저장되어 있는 많은 데이터들의 이름표 같은게 될 수도 있고, 특정 데이터를 찾기 위한 키가 될 수도 있습니다.

여러 상황에서 날짜 데이터를 날짜 함수를 통해 잘 컨트롤 할 수 있다면 데이터를 다루고 관리하는 데 있어서 많은 도움이 될 것이라 생각합니다.

## 지금 현재 날짜, 시간 출력 하기

mysql에서 지금 현재 날짜, 시간을 확인하는 방법은 매우 다양합니다. 여러 가지가 있지만 가장 많이 쓰이는 것을 위주로 안내해드리겠습니다.

| **SQL 명령**                | **결과**            |
| --------------------------- | ------------------- |
| select now();               | 2020-03-31 16:06:41 |
| select sysdate();           | 2020-03-31 16:06:48 |
| select current_timestamp(); | 2020-03-31 16:07:06 |
| select curdate();           | 2020-03-31          |
| select current_date();      | 2020-03-31          |
| select current_date();      | 16:07:26            |
| select current_time();      | 16:07:33            |
| select now()+0;             | 20200331160754      |
| select current_time()+0;    | 160813              |

위와 같이 다양한 SQL 명령을 통해서 현재 날짜, 시간을 출력할 수 있습니다.

> 더불어 가장 아래 두줄을 주목해 보시면 '+0'이라는 연산을 추가하면 날짜나 시간을 다른 형식에 맞게 출력하지 않고 숫자를 나열한 형태로 출력할 수 있습니다. 이때 출력되는 문자열은 숫자 형태로 출력이 되게 됩니다.

## 날짜, 시간에 따른 특정 정보 출력 하기

날짜나 시간에 따른 특정 정보만 출력하는 함수들이 있습니다. 이것도 매우 다양하게 있으니 대표적인 것들 위주로 소개해 드리겠습니다.

| SQL 명령                                  | 결과    | 설명                          |
| ----------------------------------------- | ------- | ----------------------------- |
| select dayofweek('2020-10-04 14:20:23');  | 1       | 1:일요일, 2:월요일...7:토요일 |
| select weekday('2020-10-04 14:20:23');    | 6       | 0:월요일, 1:화요일...6:일요일 |
| select dayofmonth('2020-10-04 14:20:23'); | 4       | 일자를 출력                   |
| select dayofyear('2020-10-04 14:20:23');  | 278     | 한해의 몇번째 날인지 출력     |
| select month('2020-10-04 14:20:23');      | 10      | 월을 출력                     |
| select dayname('2020-10-04 14:20:23');    | Sunday  | 요일을 영문으로 출력          |
| select monthname('2020-10-04 14:20:23');  | October | 월을 영문으로 출력            |
| select quarter('2020-10-04 14:20:23');    | 4       | 분기를 출력 (1분기~4분기)     |
| select week('2020-10-04 14:20:23');       | 40      | 한해의 몇번째 주인지 출력     |
| select year('2020-10-04 14:20:23');       | 2020    | 년도를 출력                   |
| select hour('2020-10-04 14:20:23');       | 14      | 시간을 출력                   |
| select minute('2020-10-04 14:20:23');     | 20      | 분을 출력                     |

 

## 날짜, 시간을 연산하여 출력 하기

날짜 및 시간을 연산한다는 것은 특정 날짜에서 며칠 뒤, 혹은 전을 출력하길 원하거나 시간, 분, 초를 더하거나 빼서 출력하는 것을 말합니다.

날짜 및 시간을 연산하는 함수는 아래와 같습니다. 사용법은 같으니, date_add 함수를 사용해서 설명드리겠습니다.

**date_add(date, interval expr type)**

**date_sub(date, interval expr type)**

**adddate(date, interval expr type)**

**subdate(date, interval expr type)** 

| **type** **변수 값** | **의미**                       | **type에 따른 expr 입력 형태** |
| -------------------- | ------------------------------ | ------------------------------ |
| **second**           | **seconds**                    | 초                             |
| **minute**           | **minutes**                    | 분                             |
| **hour**             | **hours**                      | 시                             |
| **day**              | **days**                       | 일                             |
| **month**            | **months**                     | 월                             |
| **year**             | **years**                      | 년                             |
| **minute_second**    | **minutes:seconds**            | 분:초                          |
| **hour_minute**      | **hours:minutes**              | 시:분                          |
| **day_hour**         | **days hours**                 | 일 시                          |
| **year_month**       | **years months**               | 년 월                          |
| **hour_second**      | **hours:minutes:seconds**      | 시:분:초                       |
| **day_minute**       | **days hours:minutes**         | 일 시:분                       |
| **day_second**       | **days hours:minutes:seconds** | 일 시:분:초                    |

```sql
select date_add('2020-12-31 23:59:59',interval 1 second);
```

결과값 `2021-01-01 00:00:00` 출력됨

> 참고로 -1 입력시 `2020-12-31 23:59:58` 출력

## 시간과 초 데이터 변환하여 출력 하기

시간과 초 값을 서로 변환해 주는 함수를 소개해드립니다.

```
select sec_to_time(3000);
```

결과값 `00:50:00`

## period_add, period_diff를 이용하여 원하는 값 출력 하기

period_add는 입력된 년월 데이터에 원하는 만큼의 개월을 더한 값을 'YYYYMM' 형태로 출력하는 함수입니다.

```sql
select period_add(2001,15); #입력값을 YYMM 으로 준 경우 
select period_add(202001,15); #입력값을 YYYYMM 으로 준 경우 
```

## date_format 함수 사용하여 출력 하기

date_format 함수는 mysql 혹은 mariadb에서 매우 많이 사용되는 날짜 함수 중 하나입니다. 이미 위에서 소개해드린 날짜 관련 함수들과 겹치는 기능이 있지만, 간단한 파라미터 조정으로 원하는 데이터를 원하는 형태로 쉽게 변경하여 출력할 수 있다는 장점이 있어 널리 사용되는 날짜 함수입니다.

```
select date_format('date','format');
```

위와 같은 형태로 사용을 하실 수 있습니다.

format에 들어가는 변수 따라서 출력되는 데이터 값의 형태와 내용이 달라집니다.

아래 표와 예문을 참고하시기 바랍니다.

| **format 변수** | **설명**                                                     |
| --------------- | ------------------------------------------------------------ |
| %W              | 요일 (Monday....Sunday)                                      |
| %D              | 일자 (1st, 2nd.....)                                         |
| %Y              | 년도 (YYYY)                                                  |
| %y              | 년도 (YY)                                                    |
| %a              | 요일 영문 약어 (Sun, Mon..)                                  |
| %d              | 일자 (01..02..31)                                            |
| %e              | 일자 (1..2..31)                                              |
| %m              | 월 (01..02..12)                                              |
| %c              | 월 (1..2..12)                                                |
| %b              | 월 (Jan...Dec)                                               |
| %j              | 해당년에서 몇번째 날인지 (1...366)                           |
| %H              | 시 (00..01..02..23)                                          |
| %k              | 시 (0..1..2..23)                                             |
| %h              | 시 (01..02..12)                                              |
| %l              | 시 (1..2..12)                                                |
| %I              | 시 (01..02..12)                                              |
| %i              | 분 (01..02..59)                                              |
| %r              | 시각(12) (hh:mm:ss [A/P])                                    |
| %T              | 시각(24) (hh:mm:ss)                                          |
| %S,s            | 초 (00..01..59)                                              |
| %p              | 오전/오후 (A/P)                                              |
| %w              | 해당 요일중 몇번째 날인지 (0:일요일, 1:월요일.....6:토요일)  |
| %U,u            | 해당년에서 몇번째 주 인지 (U:일요일이 주의 시작, u:월요일이 주의 시작) |

```sql
select date_format('2020-02-02','%W');
```

결과값: `Sunday`

날짜데이터는 일반 데이터와는 조금 다르게 관리하고, 사용해야 하는것을 아셨겠죠? 

그래도, 위에서 알려드린 함수만 잘 사용을 하게 된다면 특별한 어려움을 겪지는 않으실것 입니다.

# 단일행 함수 잘 사용 하기(형 변환 함수)

데이터베이스에 데이터를 저장할때는 그냥 text 형태로 넣을 수도 있지만 여러 가지 데이터 형을 칼럼에 정의하고 형태에 맞는 데이터를 insert 하고 관리하게 됩니다.

그래야지 데이터의 정합성을 지키는데도 유리하며, 관리적인 측면에서도 수월해지기 때문 입니다.

데이터베이스는 데이터의 형태를 쉽게 변형할 수 있도록 함수를 제공하고 있습니다.

## mysql의 데이터 타입 알아보기

### 1) 문자형 데이터 타입

| **데이터 유형**                  | **정의**                                                     |
| -------------------------------- | ------------------------------------------------------------ |
| **CHAR[(M)]**                    | 고정 길이를 갖는 문자열을 저장.  M은 1 ~ 255(2^8 - 1).  CHAR(20)인 칼럼에10자만 저장을 하더라도, 20자만큼의 기억 장소를 차지. |
| **VARCHAR[(M)]**                 | 가변 길이를 갖는 문자열을 저장. M은 1 ~ 65535(2^16 - 1).  VARCHAR(20)인 칼럼에10자만 저장을 하면, 실제로도 10자만큼의 기억 장소를 차지. |
| **TINYTEXT[(M)]**                | 최대 255(2^8 - 1) bytebyte                                   |
| **TEXT[(M)]**                    | 최대 65535(2^16 - 1) bytebyte                                |
| **MEDIUMTEXT[(M)]**              | 최대 16777215(2^24 - 1) bytebyte                             |
| **LONGTEXT[(M)]**                | 최대 4294967295(2^32 - 1) bytebyte                           |
| **ENUM('value1', 'value2',...)** | 열거형. 정해진 몇 가지의 값들 중 하나만 저장.최대 65535개의 개별 값을 가질 수 있고, 내부적으로 정수 값으로 표현된다. |
| **SET('value1', 'value2',...)**  | 집합형. 정해진 몇 가지의 값들 중 여러 개를 저장.최대 64개의 요소로 구성될 수 있고, 내부적으로는 정수 값이다. |

 

### 2) 숫자형 데이터 타입

| **데이터 유형**                                              | **바이트** | **정의**                                                     |
| ------------------------------------------------------------ | ---------- | ------------------------------------------------------------ |
| **BIT[(M)]**                                                 | 1          | 비트 값 유형. M은 값 당 비트 수를 나타내며 1에서 64 사이의 값을 나타냄. |
| **BOOL, BOOLEAN**                                            |            | 이 유형은 TINYINT (1)의 동의어. 0은 false, 0이 아닌 값은 true로 간주 |
| **TINYINT[(M)]**                                             | 1          | (signed) -128 ~ 127 (unsigned) 0 ~ 255(2^8)                  |
| **SMALLINT[(M)]**                                            | 2          | (signed) -32768 ~ 32767 (unsigned) 0 ~ 65535(2^16)           |
| **MEDIUMINT[(M)]**                                           | 3          | (signed) -8388608 ~ 8388607 (unsigned) 0 ~ 16777215(2^24)    |
| **INT[(M)]**                                                 | 4          | (signed) -2147483648 ~ 2147483647 (unsigned) 0 ~ 4294967295(2^32) |
| **BIGINT[(M)]**                                              | 8          | (signed) -9223372036854775808 ~ 9223372036854775807 (unsigned) 0 ~ 18446744073709551615(2^64) |
| **FLOAT[(M, D)]**                                            | 4          | (signed) -3.402823466E+38 ~ 1.175494351 E-38 (unsigned) 1.175494351 E-38 ~ 3.402823466E+38 |
| **DOUBLE[(M, D)] ****DOUBLE PRECISION[(M, D)]  ****REAL[(M, D)]** | 8          | (signed) -1.7976931348623157E+908 ~ -2.2250738585072014 E-308 (unsigned) 2.2250738585072014 E-308 ~ 1.7976931348623157E+308 |
| **FLOAT(p)**                                                 |            | 부동 소수점 숫자. p는 비트 정밀도를 가리키지만, MySQL은 결과 데이터 타입으로 FLOAT 또는 DOUBLE을 사용할지를 결정할 때에만 이 값을 사용한다. |
| **DECIMAL[(M [,**                                            | 길이+1     | 묶음 고정 소수점 숫자  M은 전체 자릿수(Precision : 정밀도), D는 소수점 뒷자리수(Scale : 배율) - DECIMAL(5)의 경우 : -99999 ~ 99999 - DECIMAL(5, 1)의 경우 : -9999.9 ~ 9999.9 - DECIMAL(5, 2)의 경우 : -999.99 ~ 999.99 최대 65자리까지 지원 |
| **DEC[(M [, D])] ****NUMERIC[(M [, D])]  ****FIXED[(M [, D])]** |            | DECIMAL과 동의어다. FIXED 동의어는 다른 데이터베이스 시스템과의 호환을 위해서 사용하는 것이다. |

 

### 3) 날짜형 데이터 타입

| **데이터 유형**    | **바이트** | **정의**                                                     |
| ------------------ | ---------- | ------------------------------------------------------------ |
| **DATE**           | 3          | YYYY-MM-DD('1001-01-01' ~ '9999-12-31')                      |
| **TIME**           | 3          | HH:MM:SS('-838:59:59' ~ '838:59:59')                         |
| **DATETIME**       | 8          | YYYY-MM-DD HH:MM:SS('1001-01-01 00:00:00' ~ '9999-12-31 23:59:59') |
| **TIMESTAMP[(M)]** | 4          | 1970-01-01 ~ 2037년 임의 시간(1970-01-01 00:00:00을 0으로 해서 1초 단위로 표기) |
| **YEAR[(2\|4)]**   | 1          | 2와 4를 지정할 수 있으며, 2인 경우에 값의 범위는 70 ~ 69, 4인 경우에는 1970 ~ 2069이다. |

 

### 4) 이진형 데이터 타입

| **데이터 유형**     | **정의**                                                     |
| ------------------- | ------------------------------------------------------------ |
| **BINARY[(M)]**     | CHAR 유형과 유사하지만 이진 바이트 문자열을 이진이 아닌 문자열로 저장. M은 바이트 단위의 열 길이를 나타냄. |
| **VARBINARY[(M)]**  | VARCHAR 유형과 유사하지만 이진 바이트 문자열을 이진이 아닌 문자열로 저장. M은 바이트 단위의 열 길이를 나타냄. |
| **TINYBLOB[(M)]**   | 이진 데이터 타입. 최대 255(2^8 - 1) byte                     |
| **BLOB[(M)]**       | 이진 데이터 타입. 최대 65535(2^16 - 1) byte                  |
| **MEDIUMBLOB[(M)]** | 이진 데이터 타입. 최대 16777215(2^24 - 1) byte               |
| **LONGBLOB[(M)]**   | 이진 데이터 타입. 최대 4294967295(2^32 - 1) byte             |

## 묵시적 형 변환 이란? 

묵시적 형 변환 이란, 데이터의 형태를 사용자의 의도에 맞춰서 데이터 베이스가 알아서 형 변환하여 결과를 출력하는 행위를 말합니다.

아래의 쿼리를 보겠습니다.

```sql
select 100 + 200 from dual;
```

100과 200을 더하는 SQL 명령입니다. 100, 200 모두 숫자로 입력을 했습니다. 당연히 결괏값 300이 출력됩니다.

출력값: `300` 

이번에는 100, 200 모두 문자로 바꿔서 입력 후 연산을 해보겠습니다.

```sql
select '100' + '200' from dual;
```

100, 200에 모두 따옴표를 붙여서 문자로 인식하도록 하고 연산을 실행했습니다.

출력값: `300` 

이렇게 해도 계산이 잘 되는군요. 

그럼 이번에는 숫자 + 문자열을 합쳐서 하나의 문자열로 만드는 시도를 concat 함수를 통해서 해보겠습니다.

```sql
select concat(82,'는 대한민국 국가 식별 전화번호') from dual;
```

위 SQL을 보면 82는 숫자형으로 뒤에 있는 글씨는 문자열로 입력 후 concat을 통해 합치라고 했습니다. 그 결과는?

출력값: `82는 대한민국 국가 식별 전화번호`

잘 합쳐지고 출력된다.

이와 같이 문자에서 숫자로, 숫자에서 문자로 사용자의 의도에 맞게 데이터 형태가 자동으로 변환되는 것을 묵시적 형 변환이라고 표현합니다.

### CAST, CONVERT 함수 사용 하기

CAST 함수란 mysql에서 데이터 타입을 서로 변환시켜주는 형 변환 함수입니다. 사용법은 아주 간단합니다.

**CAST ( 표현할 값  AS 데이터 형식[(길이)] );**

**CONVERT ( 표현할 값 , 데이터 형식[(길이)] );**

위와 같이 사용을 하시면 됩니다. 매우 쉽죠? 그럼 예제를 통해서 한번 확인해보겠습니다. 아래 내용에 있는 설명은 **CAST** 함수를 기준으로 설명을 드리겠습니다. **CONVERT** 함수의 사용법도 거의 같기 때문에 직접 실습을 통해서 해보시길 바랍니다.

> 숫자 데이터의 경우 셀 안에서 우측에 붙어서 표현이 되고, 문자의 경우 좌측에 붙어서 출력이 되고 있습니다. 다시 말하면 결과 나오는 것을 보면 같은 숫자라도 우측에 붙어 있으면 숫자, 좌측에 붙어있으면 문자로 데이터베이스가 인식하고 있다는 말이 됩니다.

```sql
select cast(100 as char) as num_to_char, cast('100' as unsigned) as char_to_num;
```

![스크린샷 2020-10-06 오후 1.04.45](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjfheud1icj30ok0aygml.jpg)

결과값을 보면 문자열 타입의 100은 좌측, 숫자형 타입은 우측으로 표현되었고, 이는 데이터타입의 변형이 성공했음을 확인할수있다.

(참고로 int는 signed, unsigned로 나눠지므로 구별하자)

```sql
select '2016-08-25 03:30:00', cast('2016-08-25 03:30:00' as datetime) as char_to_datetime from dual;
```

위에 예시도 마찬가지로 앞에는 문자열로 인식되는 데이터,  다음 char\_to\_datetime에 나오는 값은 datetime형 데이터이 출력된다.

![스크린샷 2020-10-06 오후 1.09.15](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjfhjgbhzuj310k0d2gnv.jpg)



# 단일행 함수 잘 사용 하기(일반 함수)

일반 함수는 그동안 우리가 배웠던 숫자, 문자, 날짜 등과 관련 없이 쓰일 수 있는 함수를 뜻합니다. 일반 함수도 여러 가지 많이 있겠지만, 포스팅에서는 가장 많이 쓰이는 일반 함수를 위주로 공부해보도록 하겠습니다.

## ifnull 함수 사용하기

oracle에서 NVL이라는 함수를 들어보셨을 겁니다. mysql에서는 같은 기능을 하는 함수가 ifnull입니다. **null인 데이터 값이 있을 때 null이라고 출력하지 않고 지정하는 다른 특정 값으로 출력하게 하는 함수**입니다.

__ifnull(data, 'null 대신 들어갈 문자나 숫자, 또는 컬럼명')__

> null의미
>
> 텅텅빈것, 0은 0이라는 데이터라도있다는것.
>
> 즉, null은  데이터가 없으니 비교 연산자로도 비교를 할 수 없으며, inner join을 해도 join 되지 않습니다. null 끼리도 연결이 되지 않는다는 것입니다.

```sql
create table kmong.dummy2 ( number varchar(100), text varchar(100), date varchar(100)) character set utf8;
select * from kmong.dummy2;

insert into kmong.dummy2(number, text, date) Values ('1', 'korea', null);
insert into kmong.dummy2(number, text, date) Values ('2', 'USA', '2020-04-07 14:00:12');
insert into kmong.dummy2(number, text, date) Values ('3', 'PHP', '2020-04-07 14:00:12');
insert into kmong.dummy2(number, text, date) Values ('4', 'korea2', '');
```

이제 ifnull을 써보자

```sql
select number, text, date, ifnull(date, 0) from kmong.dummy2
```

![스크린샷 2020-10-06 오후 1.48.29](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjfiob1tjfj30na07ujt2.jpg)

null인 값이 0값으로 표기된것을 알수있다.

```sql
select number, text, date, ifnull(date, text) from kmong.dummy2
```

![스크린샷 2020-10-06 오후 1.51.03](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjfiqxujd8j30mu08awg4.jpg)

위와 같게 응용가능하므로 ifnull은 잘 알아두자

## if 함수 사용 하기

**if 함수는 ifnull을 대신할 수도 있습니다.**

__if(조건, 조건 성립시 출력, 조건 미성립시 출력)__

```sql
select number, text, date, if(date is null, '해당없음', text) from kmong.dummy2
```

이런식으로도 if 사용가능

```sql
select name, dept, salary, if(salary >= 300, '고액연봉자', '일반연봉자') from class.salary;
```

## case 함수 사용 하기

case 함수는 oracle과도 거의 같다고 보시면 됩니다. 어떤 칼럼 값이 **A 이면 '가', B 이면 '나', C 이면 '다'**.... 이런 식으로 여러 가지 경우를 고려해서 출력을 해야 할 때 사용할 수 있습니다.

```sql
select number
       , text
       , case when dept='A' then "경영지원부" 
              when dept='B' then '회계팀' 
              else '다른부서' end as dept
       , dept from kmong.dummy3
```

> ```sql
> create table kmong.dummy3 ( number varchar(100), text varchar(100), date varchar(100), dept varchar(100)) character set utf8;
> select * from kmong.dummy3;
> 
> insert into kmong.dummy3(number, text, date, dept) Values ('1', 'korea', null, 'A');
> insert into kmong.dummy3(number, text, date, dept) Values ('2', 'USA', '2020-04-07 14:00:12', 'B');
> insert into kmong.dummy3(number, text, date, dept) Values ('3', 'PHP', '2020-04-07 14:00:12', 'C');
> insert into kmong.dummy3(number, text, date, dept) Values ('4', 'korea2', '', 'A');
> 
> select number, text, date, if(date is null, '해당없음', text) from kmong.dummy3
> ```

![스크린샷 2020-10-06 오후 2.02.00](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjfj2buv47j30mw07gjss.jpg)

## ifnull, if, case를 복합적으로 사용하기

**ifnull, if, case** 함수들을 한 SQL에서 복합적으로 사용하는 예제를 보겠습니다.

```sql
select number
     , text
     , date
     , dept
     , ifnull(date, '해당사항없음') as 'ifnull사용'              
     , if(number>2, '고위등급', '낮은등급') as 'if 사용' 
     , case when dept='A' then 'A등급'
            when dept='B' then 'B등급'
            else '그외등급' end as 'when 사용'
from kmong.dummy3;
       
```

![스크린샷 2020-10-06 오후 2.13.02](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjfjdu6ce3j30ws07ataq.jpg)

# 복수 행(window) 함수 잘 사용 하기(기본 사용법)

SQL에서 사용되는 복수 행 함수는 단일 행 함수와는 다르게 한 번에 여러 데이터에 대한 결과를 출력하는 함수를 말합니다.

복수 행 함수를 흔히 window 함수라고도 하고 그룹 함수라고도 지칭합니다. 어떤 정해진 것이 있다가 보다는 **복수 행, window, 그룹 이렇게 세 가지 명칭**을 잘 숙지하고 계시면 될 것 같습니다. 모두 같은 뜻이다

복수 행 함수에 대한 강의를 시작하기 앞서서 null과 관련된 이야기를 하나 하고 넘어가도록 하겠습니다. 

__모든 복수 행 함수 안에 칼럼명을 넣었을 때 해당 칼럼 값에 null 값이 있다면 이것은 제외하고 결과가 나오니 이에 대해서 헷갈리지 않으셨으면 좋겠습니다. 또한 쿼리를 작성할 때도 주의를 하셔야 합니다.__

즉, `select avg(bonus) from class.salary;`를 실행시에 bonus 필드에 만약 400,100,400,<null>,<null> 값이 있다면 그 합에 평균이 300으로 결과가 출력된다. (즉, null은 제외한다!)

하지만, 의도대로 5명에 대한 평균값을 구하고 싶었다면, 결과가 잘못된것이다.

` select avg(infall(bonus, 0)) from class.salary;`를 해야한다. (null을 0으로 출력시키므로)

## count 함수 사용 하기

**count() 함수**는 입력되는 데이터의 총건수를 반환합니다.

```sql
select count(*) from kmong.dummy3;
```

출력은 `4`

즉, 전체 칼럼을 대상으로 총 건수를 계산해서 반환하는 것이다.

**count() 함수** 안에 특정 칼럼명을 넣는다면 앞서 말씀드린 바와 같이 해당 칼럼에서 null값을 제외한 데이터 총건수가 반환됩니다.

## sum 함수 사용 하기

**sum()** 함수는 입력된 데이터들의 합계 값을 구해서 반환하는 함수입니다.

```sql
select sum(number) from kmong.dummy3;
```

number  칼럼값의 총합이 반환되었다.

## avg 함수 사용 하기

**avg() 함수**는 입력된 데이터 값의 평균값을 반환하는 함수입니다.

```sql
select avg(number) from kmong.dummy3;
```

number  칼럼값의 평균이 반환되었다.

## max, min 함수 사용 하기

**max()와 min() 함수**는 예상하셨다시피 최댓값과 최솟값을 구하는 함수입니다.

```sql
select max(number), min(number) from kmong.dummy3;
```

출력 `4`|`1` 로 나옴

## stddev 함수 사용 하기

**stddev()** 함수는 표준편차를 구하는 함수입니다.

```sql
select stddev(number) from kmong.dummy3;
```

## variance 함수 사용 하기

**variance() 함수**는 분산을 구하는 함수입니다.

```sql
select variance(number) from kmong.dummy3;
```

# 복수 행(window) 함수 잘 사용 하기(group by) 10편

복수 행 함수를 group by 절을 이용해서 조금 더 세분화하는 내용을 다루어 보도록 하겠습니다.

이번 포스팅에서 사용되는 예제를 다루기 위해서 아래와 같이 테이블을 생성 하고 데이터를 입력하겠습니다.

```sql
create table kmong.budget
(
        do varchar(100) null, 
        city varchar(100) null, 
        budget_value int null, 
        population int null 
) character set utf8;
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('서울특별시', '서울특별시', 23324, 345); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('부산광역시', '부산광역시', 34323, 5345); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('경상남도', '창원시', 4331, 435); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('경상남도', '양산시', 25436, 2134); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('경상남도', '밀양시', 62341, 6523); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('경기도', '부천시', 3242, 345); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('경기도', '시흥시', 32454, 546); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('경기도', '수원시', 3234, 345); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('충청남도', '공주시', 2425, 436); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('충청남도', '논산시', 5534, 4567); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('강원도', '속초시', 6542, 3542); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('강원도', '강릉시', 23423, 4355); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('강원도', '태백시', 5465, 45); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('전라북도', '전주시', 456, 645); 
INSERT INTO kmong.budget (do, city, budget_value, population) VALUES ('전라북도', '군산시', 3243, 234);
```

그럼 이젠 위 데이터를 가지고 group by 절과 함께 어떻게 복수 행 함수를 사용하는지를 함께 공부해 보도록 하겠습니다.

## group by 절을 이용해 평균 및 합계 구하기

```sql
select do, avg(budget_value) as 예산평균, sum(budget_value) as 예산합계 from kmong.budget
group by do;
```

![스크린샷 2020-10-06 오후 8.42.57](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjfunndio6j30fk09gjs8.jpg)

초보자 분들을 위해서 위 내용에 설명을 조금 덧 붙이자면, 원 데이터를 먼저 살펴보시면 do라는 칼럼에 "경기도"로 데이터가 들어가 있는 city는 부천시, 시흥시, 수원시가 있습니다. 이 "경기도" 라는 데이터를 한 그룹으로 묶어서 3개의 시에 대한 **예산의 평균 값과, 예산의 합계를 출력한 SQL** 입니다. 이와 마찬가지로 do 라는 컬럼 안에 있는 같은 데이터끼리 묶에서 위와 같이 강원도, 경기도, 경상남도, 부산광역시, 서울특별시, 전라북도, 충청남도의 각각의 예산 평균, 합계 값이 구해져서 나오게 된 것입니다.



## group by 절 사용 시 주의할 점

group by 절을 사용 할 때 주의하실 점이 몇 개 있습니다. group by 절에는 단순히 칼럼 명을 그대로 써도 좋지만 함수를 이용해서 group by를 할 수도 있습니다. 이때 select 절에도 group by 절에서 쓴 함수 그대로를 써줘야 group by 가 정상적으로 작동한다는 점 이 있습니다.

예를 들어 보겠습니다. 위와 같이 예산 평균, 합계를 구하는데, 수도권과 광역시 두 개의 그룹으로 나누어 보려고 합니다. 편의상 do 칼럼 값 중 "서울특별시", "경기도"를 수도권으로 하고 기타 지역들은 지방으로 나누어 두 그룹의 결과를 아래 SQL을 이용해서 출력해보겠습니다.

```sql
select if(do in ('서울특별시','경기도'), '수도권', '비수도권') as 지역구분, sum(budget_value) as 예산합계, avg(budget_value) as 예산평균 from kmong.budget
group by if(do in ('서울특별시','경기도'), '수도권', '비수도권');
```

__이런 식으로 꼭!! group by 절과 select 절에 그룹핑하는 대상의 형태를 똑같이 작성을 해주셔야 정확한 결과를 가지고 올 수 있다는 것을 명심하여야 합니다.__

# mysql join (정의 및 종류)

## join 수업용 데이터 생성

__테이블 생성__

```sql
create table kmong.student (
        student_id int(10) comment '학생번호', 
        major_id int(10) comment '학과ID', 
        bl_prfs_id int(10) comment '담당교수ID', 
        name varchar(20) comment '학생이름', 
        tel varchar(15) comment '학생연락처' 
) character set utf8;
create table kmong.professor (
        prfs_id int(10) comment '교수ID', 
        bl_major_id int(10) comment '소속학과ID', 
        name varchar(20) comment '교수이름', 
        tel varchar(15) comment '교수연락처' 
) character set utf8; 
create table kmong.major (
        major_id int(10) comment '학과ID', 
        major_title varchar(30) comment '학과명', 
        major_prfs_cnt int(5) comment '학과소속교수수', 
        major_student_cnt int(5) comment '학과소속학생수', 
        tel varchar(15) comment '학과사무실연락처' 
) character set utf8;
```

__데이터 삽입__

```sql
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1001, 9901, 7029901, '한지호', '01098447362'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1002, 9902, 7029902, '김은숙', '01023456787'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1003, 9903, 7039903, '강경호', '01092938476'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1004, 9904, 7049904, '민현민', '01088786623'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1005, 9905, 7059905, '조승우', '01092877795'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1006, 9901, 7069901, '이남철', '01045671234'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1007, 9902, 7079902, '이강철', '01021213434'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1008, 9903, 7089903, '조민수', '01098937262'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1009, 9904, 7099904, '박찬경', '01029884432'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1010, 9905, 7109905, '이도경', '01029385647'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1011, 9901, 7019901, '이만호', '01099996453'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1012, 9902, 7029902, '김효민', '01092887666'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1013, 9903, 7039903, '최효성', '01098999933'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1014, 9904, 7049904, '우민국', '01087651112'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1015, 9905, 7059905, '지대한', '01093934848'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1016, 9901, 7069901, '한나름', '01023329882'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1017, 9902, 7079902, '유육경', '01099881111'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1018, 9903, 7089903, '조민경', '01023311120'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1019, 9904, 7099904, '경지수', '01029100293'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1020, 9905, 7109905, '오종환', '01098882226'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1021, 9901, 7019901, '조형민', '01098909876'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1022, 9902, 7029902, '이수강', '01099992222'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1023, 9903, 7039903, '서민호', '01092997654'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1024, 9904, 7049904, '박효숙', '01022293332'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1025, 9905, 7059905, '남궁옥경', '01099938475'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1026, 9901, 7069901, '피경남', '01029222233'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1027, 9902, 7079902, '고주경', '01099226655'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1028, 9903, 7089903, '하지만', '01022228965'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1029, 9904, 7099904, '기지효', '01012090912'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1030, 9905, 7109905, '박민호', '01074746363'); 
INSERT INTO kmong.professor (prfs_id, bl_major_id, name, tel) VALUES (7019901, 9901, '김보경', '023445678'); 
INSERT INTO kmong.professor (prfs_id, bl_major_id, name, tel) VALUES (7029902, 9902, '조숙', '023446789'); 
INSERT INTO kmong.professor (prfs_id, bl_major_id, name, tel) VALUES (7039903, 9903, '이호', '023449584'); 
INSERT INTO kmong.professor (prfs_id, bl_major_id, name, tel) VALUES (7049904, 9904, '박철남', '023449588'); 
INSERT INTO kmong.professor (prfs_id, bl_major_id, name, tel) VALUES (7059905, 9905, '이만기', '023443443'); 
INSERT INTO kmong.professor (prfs_id, bl_major_id, name, tel) VALUES (7069901, 9901, '강조교', '023449994'); 
INSERT INTO kmong.professor (prfs_id, bl_major_id, name, tel) VALUES (7079902, 9902, '이희숙', '023443321'); 
INSERT INTO kmong.professor (prfs_id, bl_major_id, name, tel) VALUES (7089903, 9903, '소머리', '023440123'); 
INSERT INTO kmong.professor (prfs_id, bl_major_id, name, tel) VALUES (7099904, 9904, '두수위', '023443327'); 
INSERT INTO kmong.professor (prfs_id, bl_major_id, name, tel) VALUES (7109905, 9905, '지만래', '023449995'); 
INSERT INTO kmong.major (major_id, major_title, major_prfs_cnt, major_student_cnt, tel) VALUES (9901, '컴퓨터공학과', 7, 123, '023454321'); 
INSERT INTO kmong.major (major_id, major_title, major_prfs_cnt, major_student_cnt, tel) VALUES (9902, '아동보육학과', 8, 345, '023456676'); 
INSERT INTO kmong.major (major_id, major_title, major_prfs_cnt, major_student_cnt, tel) VALUES (9903, '국문학과', 6, 213, '023456567'); 
INSERT INTO kmong.major (major_id, major_title, major_prfs_cnt, major_student_cnt, tel) VALUES (9904, '경제학과', 5, 432, '023456987'); 
INSERT INTO kmong.major (major_id, major_title, major_prfs_cnt, major_student_cnt, tel) VALUES (9905, '사회복지학과', 9, 312, '023454534');
```

## join 이란 무엇인가?

우리가 흔히 아는 oracle, mysql, mariadb, ms-sql, postgres 등등은 모두 RDBMS입니다. DBMS라는 말은 많이 들어보셨을 겁니다.

맞습니다! 바로 DataBase Management System의 약자로써 데이터베이스를 관리하는 시스템이라는 뜻입니다. 그렇다면 **RDBMS**는요? **Relational DataBase Management System**의 약어로써 관계형 데이터베이스를 관리하는 시스템이라는 말이 되겠죠.

여기서 관계형이란, 말 그대로 데이터베이스 내에 있는 테이블이나 스키마들이 서로 관계를 가지고 있다는 뜻입니다. 그렇다면 이러한 관계를 이용해서 우리는 SQL을 작성하기도 해야 할 텐데요, 이럴 때 사용하는 게 바로 join이 됩니다.

join을 사용해서 여러 테이블이나 스키마에 분산되어 있는 데이터를 하나의 view로 출력하게 하는 것입니다.

![스크린샷 2020-10-07 오전 11.01.06](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjgjgfnilhj31160f644d.jpg)

위 그림과 같이 student 테이블과 major 테이블에 각각 따로 들어가 있는 데이터를 오른쪽에 join 로직을 거치면 하나의 테이블처럼 데이터를 볼 수 있게 됩니다. 위 그림에서는 2개의 테이블만 join을 했지만 3,4개 그 이상 join이 가능합니다. 추후 포스팅에서 2개를 초과하는 테이블의 join을 쉽게 하는 방법도 알려 드리도록 하겠습니다.

##  join의 종류는 무엇이 있을까?

DBMS에서 join을 하는 데 있어서 몇 가지 방법이 존재합니다. 각 join들의 특징을 잘 알고 계셔야지 자신이 원하는 결과를 출력하는데 유리합니다. 아래, 각 join의 종류별로 간단한 설명을 드리겠습니다.

> - inner join = 서로 매칭되는 것만 엮어 조회한다.
>
>   (Equi join ,Non Equi join 가 속한다.)
>
> - outer join =  매칭 뿐만 아니라 미매칭 데이터도 함께 조회한다.
>
>   (Left Outer Join, Right Outer Join, Full Outer Join가 속한다)

### 카티션곱 join

카티션곱 join이란 테이블들을 join 할 때 join 조건을 기술하지 않고 하는 join을 말합니다. 카티션곱 join의 결과는 두 테이블의 row 건수를 서로 곱한 것만큼의 결과를 출력합니다. 흔히 업무에서는 잘 사용되지 않으나, 데이터를 많이 불려야 하거나, 특정한 조건 안에서 필요할 때가 있습니다.

![스크린샷 2020-10-07 오전 11.06.06](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjgjlnc1orj311g0rs7go.jpg)

### Equi join

두 테이블을 서로 join 한다고 하면, 양쪽 테이블의 어떤 칼럼에 같은 값이 존재할 때 이것을 **Equal 연산자(=)를 이용하여 양쪽에 다 존재하는 값만 결과로 출력하는 join**입니다. 가장 보편적인 join 방법입니다. 

__inner join(이너 조인) 이라고도 불립니다.__

![스크린샷 2020-10-07 오전 11.06.32](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjgjm4aoufj31120o2qcr.jpg)

### Non Equi join

Equi join과 반대 개념입니다. 두 테이블을 서로 join 할 때, __서로 다른 값을 가지거나, 한쪽 데이터가 다른 쪽 테이블의 데이터 범위 내에 있는 것만 출력__을 원할 때 쓰는 join 방법입니다. 

__Non Equi join 역시 inner join(이너 조인)에 속합니다.__

![스크린샷 2020-10-07 오전 11.06.58](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjgjmjcc14j31160mudva.jpg)

### Outer join

Outer join은 left outer join, right outer join, full outer join으로 구분됩니다. left outer join, right outer join의 경우 어느 한쪽의 데이터를 모두 출력 한 뒤에 조건에 맞는 데이터만 다른 쪽에 출력을 하는 것을 말합니다. 조건에 맞지 않은 데이터 옆에는 null이 표시됩니다.

![스크린샷 2020-10-07 오전 11.07.26](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjgjn0qda6j31180ng4dp.jpg)

### Self join

Self join은 한 테이블이 자기 자신과 join을 다시 하는 경우를 말합니다. 아주 일반적인 경우는 아니지만 꼭 필요한 경우가 있습니다. 일반적인 사용법은 다른 join과 같습니다.



# Cartesian Product 카티션 곱 ansi SQL 문법

**mysql SQL문법**과 함께 **Ansi SQL 문법**도 같이 소개해 드리도록 하겠습니다.

Ansi SQL이란 앞에서도 안내를 한번 드리긴 했는데, 간단하게 다시 한번 말씀드리자면, 각각의 RDBMS가 서로 조금씩 다른 SQL문법을 사용하는데, 모든 RDBMS에서 사용될 수 있는 공통 문법이라고 생각하시면 쉽게 이해하실 수 있습니다.

## Cartesian Product, 카티션곱 의 정의

카티션 곱은 RDBMS에서 사용되는 join의 한 기법 중 하나입니다. where 절이나 on 절에 join 조건을 주지 않고 join을 수행하게 되면 카티션 곱이 수행됩니다.

Ansi SQL에서는 cross join 이라고도 합니다. 카티션 곱 join이 일어나게 되면 from 절에서 참조한 테이블들의 행 개수를 각각 모두 곱한 값만큼의 결과가 출력됩니다.

![스크린샷 2020-10-07 오전 11.31.19](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjgkbwjabrj310y0eoqad.jpg)

## 카티션곱 활용방법

카티션곱은 사실 RDBMS의 개념과 상충하는 개념이 됩니다. RDBMS는 각각의 테이블이 키를 가지고 있고, 해당 키를 이용해서 다른 테이블과 관계를 형성하는 개념을 가지고 있는데, 이 카티션곱 join은 키를 이용하지 않고 그냥 모든 데이터를 1:1로 연결하는 join 방법이기 때문이죠.

저도 실무에서 일을 하면서 카티션곱 조인을 사용할 경우가 자주 없었습니다만, 간혹 꼭 필요할 때가 있습니다. 

1) 데이터를 대량으로 복제해야 할 때

2) 특정 데이터 튜플만 복제되어야 할 때

3) 연결고리가 없는 두 테이블의 데이터를 무작위로 합쳐야 할 때

##  카티션곱 SQL 작성방법

```sql
select * from kmong.student; #5건

select * from kmong.professor; #10건
```

카티션 곱으로 조인하면 50건이 출력되어야함

카티션 곱으로 조인해보자

__mysql문법__

```sql
select m.major_id,
       m.major_title,
       p.prfs_id,
       p.name
from kmong.major m, kmong.professor p;
```

__ansi SQL 문법__

```sql
select m.major_id,
       m.major_title,
       p.prfs_id,
       p.name
from kmong.major m cross join kmong.professor p;
```

mysql문법을 사용할 때는 major 테이블과 professor 테이블 사이에 ", "를 넣어서 구분했지만 ansi SQL에서는 "cross join"이라는 명령어를 사용했습니다.

__참고로 각 테이블 명 뒤에 붙어있는 m과 p는 테이블의 alias 명입니다.__ (as써도 가능하더라...)

select, where 절에서 칼럼명을 사용해야 하는 경우 어떤 테이블의 컬럼명인지를 알수 있도록 테이블 명을 컬럼명 앞에 붙여야 하는데, 그때마다 테이블 명을 다 쓰기엔 너무 길기 때문에 간단하게 alias 명을 대신 사용을 합니다. 

# inner join with ansi SQL

**inner join**, 가장 일반적인 조인에 대해서 이야기합니다.

특별한 이야기가 없이 join을 이야기한다면 이 **inner join**을 이야기하시는 게 맞을 겁니다.



## inner join의 정의

A, B 두 테이블이 있을 때 서로 연결되는 key가 있다고 가정하고, 해당 키의 값이 값은 데이터를 가지고 와서 출력하는 것을 의미합니다.

만약 교수 테이블, 학과 테이블이 있을 때 교수들의 소속 학과를 함께 출력하는 경우, 이 inner join을 이용해서 join을 해서 출력해야 합니다.

**inner join은 EQUI join 이라고도 하고, 그냥 join 이라고도 하며, 등가 조인 이라고도 표현**할 수 있습니다.

## inner join 사용 예제

우선, **교수 테이블과, 학과 테이블** 데이터를 한번 확인해보겠습니다.

```sql
select * from kmong.professor;
select * from kmong.major;
```

위 테이블을 보면 교수 테이블에 교수들의 이름이 있고, 학과 테이블에 학과 이름이 있습니다. 그리고 교수 테이블을 보면 bl_major_id라는 소속 학과 아이디가 있습니다. 이 소속 학과 아이디는 학과 테이블의 major_id와 매핑이 됩니다.

__이것을 FK, Foreign Key라고 합니다. 두 테이블의 연결하는 key가 되는 것입니다. 이 FK를 join 시에 조건으로 넣어주시면 됩니다.__

그럼 두 테이블을 inner join 하여 교수 이름과, 학과명이 출력되도록 하는 예제를 보겠습니다.

## inner join SQL 작성방법

__mysql__

```sql
select p.name as 교수이름,
       m.major_title as 학과명
from kmong.professor p, kmong.major m
where p.bl_major_id = m.major_id;
```

__ansi sql__

```sql
select p.name as 교수이름,
       m.major_title as 학과명
from class.professor p 
       join class.major m 
               on p.bl_major_id = m.major_id; 
               
select p.name as 교수이름, 
       m.major_title as 학과명
from class.professor p 
       cross join class.major m 
               on p.bl_major_id = m.major_id;
               
select p.name as 교수이름, 
       m.major_title as 학과명 
from class.professor p 
       inner join class.major m 
               on p.bl_major_id = m.major_id;
```

3가지 모두 같은 방법이며, inner join을 활용하는게 가독성 높아짐

## inner join으로 3개의 테이블을 join 하는 예제

이번에는 inner join으로 3개의 테이블을 join 하여 출력하는 예제를 함께 해보겠습니다.

학생, 교수, 학과 테이블을 두고, 어떤 학생이 어떤 담당교수와 소속 학과가 어디인지 출력하는 SQL을 작성해보겠습니다.

참고로, 하나와 하나의 테이블을 join 할 때 FK을 각각 테이블에 공통적으로 존재하는 키를 쓴다고 했는데, 그럼 3개를 join 할 때는 어떻게 Key를 연결해야 할지 헷갈리시는 분들이 많은데 아래 그림으로 설명하겠습니다.

![스크린샷 2020-10-07 오후 12.34.40](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjgm5s4t9yj311w0oaaco.jpg)

예를 들어 **테이블 1과 테이블2를 조인할때 공통으로 들어있는 Key를 찾아 연결** 하고, **그것을 테이블 3과 join 한다고 생각**하면 쉽습니다. 테이블1 과 테이블2의 join 한 데이터를 하나의 테이블로 생각하고, 테이블3과 비교했을 때 공통의 키를 찾아서 다시 1:1 join을 하다고 생각하면 되는 것 이죠.

그럼 다시 문제로 돌아가서, **학생, 교수, 학과 테이블을 한 번에 inner join을 하여 각 학생별 담당교수와 소속 학과까지 출력하는 SQL문 예제**를 보겠습니다.

__mysql__

```sql
select s.name as 학생이름, 
       p.name as 교수이름, 
       m.major_title as 학과명 
from kmong.student s, kmong.major m, kmong.professor p 
where s.bl_prfs_id = p.prfs_id and p.bl_major_id = m.major_id;
```

__ansi sql__

```sql
select s.name as 학생이름,
       p.name as 교수이름, 
       m.major_title as 학과명 
from kmong.student s 
       inner join kmong.major m 
       inner join kmong.professor p
               on p.bl_major_id = m.major_id
                   and s.bl_prfs_id = p.prfs_id ;
```

# 비등가 join with ansi SQL

## 비등가 join의 정의

비등가 join은 만약 **A, B 두 테이블을 join 할 때 값이 서로 같지는 않지만 join 조건에서 지정한 어느 범위에 일치할 때 서로 데이터를 join 해 주는 것을 이야기**합니다. 

예를 들어서 어떤 마트에서 사은행사를 하는데, 그동안 쌓였던 포인트를 선물로 바꿔 준다고 합시다. **선물에는 각 5, 10, 15... 포인트가 매겨져 있으며, 예를 들어 8포인트를 가지고 있는 고객이 있다면 10포인트의 선물은 가져갈 수 없으니 5포인트의 선물과 매칭이 되어야 하는 상황**이 생길 겁니다. 이렇게 해서 각 고객이 받을 수 있는 선물이 무엇인지를 비등가 join을 이용해서 출력해 낼 수 있습니다.

## 비등가 join 사용 예제

우선, 이 join을 실습하기 위해서 테이블을 만들고, 데이터를 입력하겠습니다.

```sql
create table kmong.customer (
        name varchar(10), 
        point int
)character set utf8; 
create table kmong.gift (
        name varchar(20) null, 
        point_s int null, 
        point_e int null 
)character set utf8; 

INSERT INTO kmong.customer (name, point) VALUES ('조성모', 5); 
INSERT INTO kmong.customer (name, point) VALUES ('이기찬', 12); 
INSERT INTO kmong.customer (name, point) VALUES ('이소라', 14); 
INSERT INTO kmong.customer (name, point) VALUES ('서태지', 18); 
INSERT INTO kmong.customer (name, point) VALUES ('박효신', 21); 
INSERT INTO kmong.customer (name, point) VALUES ('김정민', 16); 
INSERT INTO kmong.customer (name, point) VALUES ('양파', 9); 
INSERT INTO kmong.customer (name, point) VALUES ('강수지', 22); 
INSERT INTO kmong.customer (name, point) VALUES ('강타', 24); 
INSERT INTO kmong.gift (name, point_s, point_e) VALUES ('공기청정기', 11, 15); 
INSERT INTO kmong.gift (name, point_s, point_e) VALUES ('아이폰11', 21, 25); 
INSERT INTO kmong.gift (name, point_s, point_e) VALUES ('로봇청소기', 6, 10); 
INSERT INTO kmong.gift (name, point_s, point_e) VALUES ('상품권', 1, 5); 
INSERT INTO kmong.gift (name, point_s, point_e) VALUES ('스마트패드', 16, 20);
```

데이터를 보시면 만약 이기찬이라는 고객은 포인트를 12포인트 가지고 있으니, 선물 테이블에서 11포인트 ~ 15포인트 사이인 로봇청소기를 사은품으로 가져갈 수 있을 겁니다. 그리고 강타라는 고객은 24포인트로, 가장 고가의 선물인 아이폰 11을 가져갈 수 있겠네요.

이렇게 연결을 하여 출력을 하겠다는 의미입니다.

## 비등가 join SQL 작성방법

우선 위에서 설명한 SQL을 mysql SQL로 작성을 먼저 해보도록 하겠습니다.

__mysql__

```sql
select c.name as 고객명, c.point as 고객_point, g.name as 상품명 
from kmong.customer c , kmong.gift g 
where c.point between g.point_s and g.point_e;
```

select, from 절까지는 이전에 했던 일반적인 inner join과 같지만 where 절을 보면 between, and 가 보이실 겁니다.

gift 테이블의 point_s에서부터 point_e 사이에 customer 테이블의 값이 해당한다면 두 테이블을 join 하라는 의미입니다

__ansi sql__

```sql
select c.name as 고객명, c.point as 고객_point, g.name as 상품명 
from kmong.customer c 
         join kmong.gift g 
                 on c.point between g.point_s and g.point_e;
```

결과값은 다음과 같다

![스크린샷 2020-10-07 오후 1.12.27](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjgn94uzd4j30c40b0q4n.jpg)

# outer join SQL

## outer join의 정의

조건과 매치 안되도 출력됨.

outer join은 RDBMS에서 join을 할 때 inner join을 빼면 가장 많이 사용하는 join 기법입니다.

inner join의 경우 A 와 B 두 테이블을 join 할시에 양쪽에 key값을 기준으로 모두 존재하는 데이터만 출력이 되지만, outer join은 한쪽을 기준으로 하여 다른 쪽에 key값이 일치하는 게 없더라도 모두 출력을 하는 join 기법입니다.

outer join의 종류에는 left outer join, right outer join, full outer join이 있는데 mysql에서는 full outer join을 지원하지 않고 있습니다.

![스크린샷 2020-10-07 오후 1.29.00](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjgnqeh2z1j311m0k4qgt.jpg)

(참고로, inner join은 정확히 where 에 쓰는 조건에 해당하는 것만 출력, 즉 조건이 not B or 범위로 잡혀있어도 조건에도 출력됨.)(그림과 정확히 같지는 않다)

> mysql에서는 full outer join이 필요할 때는 union으로 우회적으로 사용할 수 있습니다.
>
> ```sql
> ## full outer join 을 union all로 구현하기## select * 
> from A full outer join B 
> on A.a = B.b; 
> 
> select * 
> from A left outer join B 
> on A.a = B.b union 
> 
> select * 
> from B left outer join A 
> on A.a = B.b;
> ```

필요시에 꼭 써야 하는 outer join이지만 필요 없을 땐 쓰지 않아야 합니다. __outer join은 모든 데이터를 다 가지고 올 때 full scan을 하기 때문에 DB에 무리를 가할 수 있기 때문입니다.__

outer join을 하기 테스트하기 위해서 기존 class.student 테이블에 일부 데이터를 좀 더 추가하겠습니다

```sql
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1031, 9901, null, '신채령', '01044755564'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1032, 9902, null, '이만도', '01022287777'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1033, 9903, null, '박만호', '01099972253'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1034, 9904, null, '최이강', '01029386577'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1035, 9905, null, '강이민', '01033334444'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1036, 9901, null, '민형도', '01099973331'); 
INSERT INTO kmong.student (student_id, major_id, bl_prfs_id, name, tel) VALUES (1037, 9902, null, '도지란', '01055567774');
```



##  outer join 사용 예제

먼저 inner join 써보자  null을 가진 데이터와 join되므로 row수가 줄어든다.

```sql
select s.name,
       p.name
from kmong.student s,kmong.professor p
where s.bl_prfs_id = p.prfs_id;
```

## outer join SQL 작성방법

mysql은 outer join의 경우 ANSI SQL 형태로 작성을 해야 합니다.

__ansi sql__

```sql
select s.name, s.bl_prfs_id, p.name, p.prfs_id 
from kmong.student s 
        left outer join kmong.professor p 
                on s.bl_prfs_id = p.prfs_id;
```

다음은 outer join 결과다. 

![스크린샷 2020-10-07 오후 1.52.01](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjgoearex5j30u011vh9s.jpg)

파란색 상자 안의 두 칼럼은 student 테이블에서, 노란 상자 안의 두 컬럼은 professor 테이블에서 가지고 온 데이터를 student 테이블의 bl_prfs_id와 professor 테이블의 prfs_id 두 칼럼을 키로 연결하여 left outer join을 한 건데, 결과를 보시면 아시겠지만, 아래 30번째 행부터는 오른쪽 professor 테이블에 데이터가 없습니다.

물론 좌측의 student 테이블에 더 bl_profs_id는 31번 하아부터 데이터가 null로 표시되어 있지만 students 테이블의 name 칼럼에는 데이터가 표시되고 있으니, 데이터가 있다고 봐야겠죠.

"한지호"라는 학생은 bl_prfs_id에 값이 있지만, 연결이 되지 않아 professor 테이블 데이터가 null로 표시되어 있습니다. "한지호" 학생은 bl_prfs_id에 저장된 id 값이 교수 테이블에 존재하지 않는 것을 의미하고, 나머지 "신 채령"부터 "도지란" 까지는 아예 bl_prfs_id 값이 없기 때문에 professor 테이블과 연결이 되지 않은 것입니다.

이렇게 연결되지 않은 데이터까지 left outer join을 이용해서 출력해낼 수 있습니다.

righ outer join을 한다면, 교수진은 ` null`값이 존재하지 않으므로 전부 결과로 출력된다.

# ub query 서브 쿼리

서브 쿼리 (sub query) 란 SQL내에서 또 다른 select 절을 사용 하는 문법을 이야기합니다.

![스크린샷 2020-10-07 오후 1.57.30](https://tva1.sinaimg.cn/large/007S8ZIlgy1gjgojzks7tj30ri07qabc.jpg)

서브 쿼리를 사용해서 SQL에서 데이터를 폭넓게 사용할 수 있는 이점이 있습니다. 또한 복잡한 쿼리를 조금더 단순화 하여 사용 할 수 있는 장점이 있습니다.

하지만, 조인을 이용해서 풀 수 있는 문제를 서브 쿼리를 이용해서 푼다면 SQL의 성능에 악영향을 미칠 수 있습니다. 그래서 서브 쿼리는 양날의 검처럼 조심히, 최대한 어쩔 수 없는 상황에서만 사용할 수 있도록 해야 합니다.



https://stricky.tistory.com/265



