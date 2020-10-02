---
title: mysql
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
where dept_cd="A";
```

위에 sql은 among.select_test 테이블에서 dept_cd="A"조건을 만족하는 행에 대해 concat(name, '의 부서코드는',dept_cd,'입니다')  출력한다.

https://stricky.tistory.com/205 (여기부터 시작)

