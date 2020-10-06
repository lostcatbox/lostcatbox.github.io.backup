---

title: Mysql 기본 공부
date: 2020-10-02 15:19:38
categories: [DB]
tags: [Mysql, DB, Basic]
---

[원본 강의 및 출처](https://stricky.tistory.com/202)

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
