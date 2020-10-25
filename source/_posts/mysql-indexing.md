---
title: mysql indexing 자세히
date: 2020-10-22 19:22:14
categories: [DB]
tags: [Mysql, DB, Basic]
---

[자세히](https://jojoldu.tistory.com/243)

[자세히](https://asfirstalways.tistory.com/333)

[아주 고급 자세히](http://junil-hwang.com/blog/db-indexing/)

# 왜?

DB에서 조회능력을 최대한으로 이끌어낼 수 있는 방법중 하나가 인덱싱이다.

조회할때 인덱싱을 어떤방식으로 해놔야 좀더 빠르게 조회할수있을까? 생각해보자

DB 캐시 서버는 DB로 요청하는 쿼리 수를 줄일수있고, 인덱스는 쿼리 성능 자체를 높일수있다(물론 조회성능)

# 인덱스란?

인덱스는 __지정한 칼럼들을 기준으로 메모리 영역에 일종의 목차를 생성하는 것__이다. insert, update, delete의 성능이 희생된다. (일어나면 인덱스까지 모두 반영하므로) 

장점은 select(Query)의 성능이 대폭 상승한다. 여기서 주의하실 것은 update, delete 행위가 느린것이지, **update, delete를 하기 위해 해당 데이터를 조회하는것은 인덱스가 있으면 빠르게 조회**가 된다.

 많은 양의 데이터를 삭제 해야하는 상황에선 인덱스로 지정된 컬럼을 기준으로 진행하는것을 추천한다.

mysql의 인덱스 구조는 오직 __B-Tree 인덱스 구조__ 이다__디스크 접근(I/O)이 줄어든다 = Root~leaf 까지의 왕복 횟수가 적다 = 검색 속도가 빠르다__

인덱스는 메모리에 있는 파일로써, 페이지 단위(Page =16KB)로 관리된다.  

> 페이지(Page) : 메모리에 데이터를 저장하는 가장 __기본 단위__

# 실전

![스크린샷 2020-10-22 오후 7.38.05](https://tva1.sinaimg.cn/large/0081Kckwgy1gjyap2v6f9j316q0n2dls.jpg)



인덱스 탐색은 Root>Branch>Leaf순으로 이뤄지며 Leaf는 RowID값을 가지므로 디스크 조회가 일어난다.

인덱스의 두번쨰 칼럼(emp_no)은 첫번째 칼럼(dept_no)에 의존한다. 첫번째 칼럼이 d001로 모두 같은 열에서만 두번쨰 칼럼의 정렬이 의미를 가진다. (3,4가 있다면 2에 3 칼럼이 의존, 4가 3칼럼에 의존...)

인덱스는 갯수 3~4가 적당하다. (옵티마이저가 잘못된 인덱스를 선택할수있고, 공간차지, create, update, delete성능고려)

> 만약 본인이 설정한 인덱스 키의 크기가 16 Byte 라고 하고, 자식노드(Branch, Leaf)의 주소(위 인덱스 구조 그림 참고)가 담긴 크기가 12 Byte 정도로 잡으면, `16*1024 / (16+12) = 585`로 인해 하나의 페이지에는 585개가 저장될 수 있다.
>
> 여기서 인덱스 키가 32 Byte로 커지면 어떻게 될까요?
> `16*1024 / (32+12) = 372`로 되어 372개만 한 페이지에 저장할 수 있게 된다.
>
> 따라서, 조회 결과로 500개의 row를 읽을때 16byte일때는 1개의 페이지에서 다 조회가 되지만, 32byte일때는 2개의 페이지를 읽어야 하므로 이는 성능 저하가 발행하게 됩니다.
>
> __인덱스의 키는 길면 길수록 성능상 이슈가 있습니다.__

__카디널리티가 높은걸 첫번째 인덱스 잡자__

복수 칼럼 인덱스 사용시 둘다 걸리는 and조건 조회는 훨씬빠르다.

하지만 `where 두번째칼럼="테스트"` 실행되면 효과을 볼수없다.(즉, 비즈니스 로직을 잘 생각해야한다.)



# 명령

__Index 생성하기__

```sql
ALTER TABLE  테이블명 ADD INDEX(필드명(크기)); #기존의 테이블에 인덱스를 추가

CREATE TABLE 테이블 명 ( 
    필드명 데이터타입(데이터크기), 
    INDEX(필드명(크기)
); # 테이블 생성시 index생성하기
```

__성능차이__

```sql
SELECT * FROM test WHERE keyword LIKE '가%' ; 

SELECT * FROM test_index WHERE keyword LIKE '가%' ; 
```

# 실습

[실습데이터 적용법](https://futurists.tistory.com/19)

필자는 도커로 올렸기 때문에 volume필수였고 exec -it으로 접근해서 직접  실습 sql파일을 import했다

__전체 table name과 rows 갯수를 보는 방법__

```sql
select table_name, table_rows from information_schema.tables where table_schema = "employees";
```

__데이터 구조 그림__

![스크린샷 2020-10-23 오후 4.12.52](https://tva1.sinaimg.cn/large/0081Kckwgy1gjzadr596dj30vg0u0k0z.jpg)

(위 그림은 PK, FK고려해야한다. 1:N이 표현되어있다.)

employees에 last_name 필드를 지정한 index를 생성후 속도와 index 제거후 last_name과의 select 속도를 비교하였다

```sql
alter table employees add index employees_insert_test(last_name(10));

select * from employees where last_name = 'Facello';

show index from employees;
alter table employees drop index employees_insert_test;

select * from employees where last_name = 'Facello';
```

전자가 59.8ms 후자가 280ms였다. 여러번 실행을 해도  index가 있는 쪽이 휠씬 빨랐다.



