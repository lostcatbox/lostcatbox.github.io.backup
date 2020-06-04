---
title: R_언어 공부
date: 2020-03-27 15:32:53
categories: [R]
tags: [R, Univ, Basic]
---

# R

mac 에서 utf8관련오류

```
#teminal
defaults write org.R-project.R force.LANG en_US.UTF-8
```



## 각 R 언어 해석

[자세히](https://m.blog.naver.com/PostView.nhn?blogId=dic1224&logNo=80206009323&proxyReferer=https%3A%2F%2Fwww.google.com%2F)

```
#temminal
brew install r     #R 설치

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null ; brew install caskroom/cask/brew-cask 2> /dev/null

brew cask install rstudio   # rstudio설치
```

## R데이터 속성 

![스크린샷 2020-04-19 오후 1.10.55](https://tva1.sinaimg.cn/large/007S8ZIlgy1gdyy9nf81cj31450u046h.jpg)

숫자형, 문자형, 논리형, 특수값으로 변수의 자료형타입임, 

Null  정의되어있지 않음을 의미

NA 결측값(missing value) (데이터가 찾을려고해도 없어!)

NaN 수학적으로 정의가 불가능한 값(ex sqrt(-3))

Inf 양의 무한대, -Inf 음의 무한대

![스크린샷 2020-04-19 오후 1.12.28](https://tva1.sinaimg.cn/large/007S8ZIlgy1gdyyaho3g7j31800u0k4x.jpg)

80,70만있거나 홍길동, 손오공만 있으면 무슨 타이틀을 알수없다.

이 타이틀을 부여해준것이 리스트임

배열에 가로로읽는건지 세로로읽는 데이터인지 알수없음.

데이터 프레임은 리스트+배열 같이 합친 데이터(단, 각 열별로는 데이터타입이 같아야함.)

(만약 숫자만 있는 열에 문자를 집어넣는다면 전부 문자형으로 변환됨)

- 리스트가 여러개 모여있거나
- 리스트 + 배열 

![스크린샷 2020-05-13 오후 5.29.53](https://tva1.sinaimg.cn/large/007S8ZIlgy1geqwm2a8kaj30zg0u0n2u.jpg)

### 리스트와 데이터 프레임의 차이

- 데이터 프레임은 행과 열이 동일하게 구성되어있으며 그 이상의 자유도를 갖지 못합니다

  예를 들면 첫번쨰 열은 3개의 요소, 두번째 열은 5개 요소로를 가질수없으며, 한개의 열이 3개의 요소만 갖는다면 나머지 열 또한 3개의 요소만 가질수있다

  반면 리스트는 첫번쨰 자리는 1개의 값, 두번쨰 자리는 3개의 값.. 각 자리마다 가질수있는 요소가 다양함



## 백터의 이해

### 백터의 개념

- 1차원 배열 데이터 (1행에 데이터가![스크린샷 2020-04-19 오후 1.19.47](https://tva1.sinaimg.cn/large/007S8ZIlgy1gdyyi46fffj316n0u0al4.jpg)있다)(1학년 학생들의 몸무게 자료) 

  ex) 몸무게 > 56|67|85|65|56|49

- 2차원 배열 데이터 (행과열이 존재)(국가별 GDP)

  ex) 우리가 익히 아는 엑셀 데이터, DB

### 리스트

![스크린샷 2020-04-19 오후 1.10.55](https://tva1.sinaimg.cn/large/007S8ZIlgy1gdyylu3oevj317u0t8198.jpg)

```R
# 리스트에 각 요소에 이름 지정해주기
names(x) <- c("첫번째 이름", "두번재이름", "세번쨰이름", "네번쨰 이름")
```

리스트는 각 리스트에 요소가 한개 또는 여러개도 저장이 가능하다 (벡터와 다른점)

__리스트를 생성하면 안의 요소들은 자동으로 또 하나의 리스트로 처리된다고 생각하자__

```R
x<-list("kk","dam", 1:5)
x
#하면 3번째의 리스트에는 5개의 요소가들어감
x[1] # 1번쨰 리스트를 출력
x[[3]] #3번쨰 리스트의 값에 접근해서 출력

class(x[1]) #class는 속성을 알수있게해줌
class(x[[3]])

>>>
[1] "list"
[1] "integer"

#즉 3번째 리스트의 값중에 2~4인덱스에 해당하는 값을 원한다면
x[[3]][2:4]

x<-list(1:3,3:6, 1:5, c("kk","dam"))
x
x[2][[1]][4]   # 두번째리스트에 첫번째리스트의 값에 4번째 요소
x[4][[1]][2]   # 네번째리스트에 첫번째리스트의 값에 2번째 요소
```



### 백터 변수 만들기

c()를 사용하여 벡터 변수를 만들수있다

```
x <- c(1,2,3) # 숫자형 벡터
y <- c("a","b","c") # 문자형 벡터
z <- c(TRUE,TRUE, FALSE, TRUE) # 논리형 벡터
x # x에 저장된 값을 출력


# 문자와 숫자는 같은 벡터 변수로 지정될떄, 문자열로 저장을 자동으로함
w <- c(1,2,3, "a","b","c")
w

#연속 숫자 필요하면 c(int:int)쓰기
v1 <- 50:90
v1
v2 <- c(1,2,5, 50:90)
v2

#연속 숫자인데 간격지정
v3 <- seq(1,101,3)
v3
v4 <- seq(0.1,1.0,0.1)
v4

#반복 생성
v5 <- rep(1,times=5) # 1을 5번 반복
```

벡터의 원소값에 이름 지정

```
score = c(123,243,423,5234)
names(score) = c('3', '4qjsWO', 'rrr', 'rew')
score #실행시 이제 header가 names가 들어가고 2행 3열
```

백터에서 원소 추출

```
d <- c(1,2,3,4,5,6,6,7)
d[1]
d[1:8]
d[seq(1,5,2)]


d[-2] #주의하자python은 뒤에서부터 새지만, R은 d[2]를 뺴고 출력하라라는 뜻
[1] 1 3 4 5 6 6 7 
> d[-c(3:5)]
[1] 1 2 6 6 7
> 


GNP <- c(2090, 2450, 960)
names(GNP) <- c("Korea", "Japan", "Nepal")
GNP[1]
GNP["Japan"]
GNP[c("Korea", "Nepal")]

v1 <- c(1,5,7,8,9) v1
v1[2] <- 3 # v1의 2번째 값을 3으로 변경
v1[c(1,5)] <- c(10,20) # v1의 1, 5번째 값을 각각 10, 20으로 변경
```

### 벡터의 연산

기본적으로 벡터값을 연산은 벡터들의 길이가 같아야함

하지만 두 객체의 길이가 서로 배수관계가 있으면 짧은 벡터를 반복하여 자동으로 연산 실행됨

![image-20200412165213190](https://tva1.sinaimg.cn/large/007S8ZIlgy1gdr1axl1x2j30x00mo7cv.jpg)

```
sort(d, decreasing = FALSE)  # 오름차순 정렬 default값임
sort(d, decreasing = TRUE)   # 내림차순 정렬
```

## 매트릭스(5주차)

### 매트릭스의 개념

- 1차원 데이터 : ‘몸무게’ 데이터와 같은 단일 주제의 데이터 → 벡터
- 2차원 데이터 : ‘키’, ‘몸무게’, ‘나이’ 와 같은 여러 주제의 데이터→ 매트릭스, 데이터 프레임
- 매트릭스(matrix): 데이터 테이블의 모든 셀의 값들이 동일핚 자료형

>매트릭스와 데이터 프레임(data frame)차이
>
>자료형이 다른 컬럼들로 구성(데이터프레임에 이름, 학번은 문자형, 나이는 숫자형 으로 가능했음)
>
>하지만 매트릭스는 모든 데이터형이 같아야함



![스크린샷 2020-04-19 오후 3.05.37](https://tva1.sinaimg.cn/large/007S8ZIlgy1gdz1k6v6v9j31480nmgqz.jpg)

### 행열 만들기 (matrix함수사용하고 기본적으로 array의 2차원이 행열임)

```R
x <- matrix(1:6, nrow=2) #행 2개
x
x <-  matrix(1:6, nrow=2, byrow=TRUE) #행이 우선으로 채워짐, 즉 가로로 읽음!!!!!!!! TRUE or T

names <- list(c("1행", "2행"), c("1열", "2열", "3열"))
matrix(1:6, nrow=2, byrow=TRUE, dimnames=names)
```

### 매트릭스에서 값 추출하기

```
x[2,3]  #x에서 2행 3열의 값을 가져옴
x[,3] #x에서 3열의 값을 가져옴

z <- matrix(1:20, nrow=4, ncol=5)

z[2,1:3]
z[1, c(1,2,4)] #1행, 1,2,4열에 있는값가져옴
z[1:2,]
z[,c(1,4)]

```

### 행열에 이름붙이기

```
rownames(x) <- c("1행", "2행", "3행", "4행") #row name붙이는 함수
x

colnames(x) <- c("1열", "2열", "3열") # column name붙이는 함수
x

x["1행",c("2열","3열")] #해당 값 나옴
x[,"3열"] #3열값들나옴 즉, 객체이름으로 불어올수있음
rownames(x) #행의 모든 이름
colnames(x) #열의 모든 이름
colnames(x)[2] #열의 2번째 이름


```

## 데이터 프레임와 매트릭스

### 데이터 프레임

- 숫자형 벡터, 문자형 벡터 등 서로 다른 형태의 데이터를 2차원 데이터테이블 형태로 묶을 수있는 자료구조
- 외관상으로 매트릭스와 차이가 없지만 매트릭스는 동일한 자료형인 것만 가능, 데이터 프레임은 서로 다른 형태 가능

![스크린샷 2020-05-02 오후 6.44.15](https://tva1.sinaimg.cn/large/007S8ZIlgy1gee8xrdm5oj30ow0f2gr4.jpg)

![스크린샷 2020-04-19 오후 2.56.19](https://tva1.sinaimg.cn/large/007S8ZIlgy1gdz1axf3cqj317u0tgk4j.jpg)

![스크린샷 2020-04-19 오후 2.55.44](https://tva1.sinaimg.cn/large/007S8ZIlgy1gdz1b510ecj317q0u0n92.jpg)

### 데이터세트

R에서 제공하는 실습용 데이터셋

```R
library(help=datasets)  # 데이터 세트의 목록 보기
data()  #위와 동일 역할

data(iris) #quakes 데이터 호출
iris  # 150 그루의 붓꽃에 대해 4개 분야의 측정 데이터와 품종 정보를 결합하여 만든
데이터셋

head(iris, n=10) #위로부터 10개
tail(iris, n=8)  #아래로부터 8개

#데이터 세트 구조 보기
names(iris) #변수이름 출력
dim(iris) # raw갯수 column갯수 출력
nrow(iris) # 행의 개수 출력
ncol(iris) # 열의 개수 출력
colnames(iris) # 열 이름 출력, names( )와 결과 동일
head(iris) # 데이터셋의 앞부분 일부 출력
tail(iris) # 데이터셋의 뒷부분 일부 출력

str(iris) # 데이터프레임 상세정보(구조)
iris[,5] # 5열 데이터 보기
unique(iris[,5]) # 품종의 종류 보기(중복 제거)
table(iris[,"Species"]) # 품종의 종류별 행의 개수 세기
unique(iris[,5]) #위와 동일 값

#매트릭스와 데이터프레임에서 사용하는 함수
colSums(iris[,-5]) # 열별 합계 #5열은 숫자형 데이터가 아니므로 제외시킴
colMeans(iris[,-5]) # 열별 평균 #5열은 숫자형 데이터가 아니므로 제외시킴
rowSums(iris[,-5]) # 행별 합계 #5열은 숫자형 데이터가 아니므로 제외시킴
rowMeans(iris[,-5]) # 행별 평균 #5열은 숫자형 데이터가 아니므로 제외시킴

#데이터 세트 요약 보기
summary(iris)
summary(iris$Petal.Width) #특정 변수 출력

#데이터 세트 저장하고 일기
write.table(iris, "../iris.txt", sep=",")  #변수와 변수사이의 값에대해 ,찍음

x <- read.csv("../iris.txt", header=T)

x<- read.csv(file.choose(), header=T)
```

### 이외의 필요한 정보

```R
# 행과 열 방향 전환
z <- matrix(1:20, nrow=4, ncol=5)
z
t(z)  #이때 바뀜 t함수

#조건에 맞는 행과 열의 값 추출 (subset은 데이터프레임에서 잘먹힘)
IR.1 <- subset(iris, Species=="setosa")  #subset은 부분집합!
IR.1
IR.2 <- subset(iris, Sepal.Length>5.0 &
Sepal.Width>4.0)
IR.2
IR.2[, c(2,4)]

#매트릭스와 데이터프레임에 산술연산(행 열 갯수 같아야함)
a <- matrix(1:20,4,5)
b <- matrix(21:40,4,5)
a
b
2*a # 매트릭스 a에 저장된 값들에 2를 곱하기
b-5
2*a + 3*b
a+b
b-a
b/a
a*b
a <- a*3
b <- b-5
a+b # a+b 값 당연히 출력물 다름

#매트릭스와 데이터프레임의 자료구조 변환
## 매트릭스를 데이터프레임으로 변환
st <- data.frame(state.x77)
head(st)
class(st)
## 데이터프레임을 매트릭스로 변환
iris.m <- as.matrix(iris[,1:4])  #1열에서 4열까지만 숫자이므로 #만약 그대로하면 factor로 들어감
head(iris.m)
class(iris.m)
```

### 자료 구조 확인

```R
class(iris) # iris 데이터셋의 자료구조 확인
class(state.x77) # state.x77 데이터셋의 자료구조 확인 #미국 50개주 통계자료
is.matrix(iris) # 데이터셋이 매트릭스인지를 확인하는 함수
is.data.frame(iris) # 데이터셋이 데이터프레임인지를 확인하는 함수
is.matrix(state.x77)
is.data.frame(state.x77)

#매트릭스와 데이터프레임 차이
iris[,"Species"] # 결과=벡터. 매트릭스와 데이터프레임 모두 가능
iris[,5] # 결과=벡터. 매트릭스와 데이터프레임 모두 가능
iris["Species"] # 결과=데이터프레임. 데이터프레임만 가능
iris[5] # 결과=데이터프레임. 데이터프레임만 가능 #,가 없으므로 열 로 인식
iris$Species # 결과=벡터. 데이터프레임만 가능
```

## 파일 데이터 읽기/쓰기

```R
setwd("../Users/user_name/uinv_lecture/R language/") # 기본 작업 폴더 지정
air <- read.csv("airquality.csv", header=T) # .csv 파일 읽기
head(air)

my.iris <- subset(iris, Species="Setosa")# Setosa 품종 데이터만 추출
my.iris
write.csv(my.iris, "my_iris.csv", row.names=F) # .csv 파일에 저장하기
```

# 조건문, 반복문, 함수

## 조건문

### if else

```R
job.type <- "A"
if(job.type == "B") {
  bonus <- 200 # 직무 유형이 B일 때 실행
} else {
  bonus <- 100} # 직무 유형이 B가 아닌 나머지 경우 실행 }
print(bonus)

job.type <- "B"
bonus <- 100
if(job.type == 'A') {
bonus <- 200 # 직무 유형이 B일 때 실행
}
print(bonus)

score <- 85
if (score > 90)  #if에 else를 쓰기전에  elseif 를 사용하면 조건문 추가
{ grade <- "A"
} else if (score > 80) {
grade <- "B"
} else if (score > 70) {
  grade <- "C"
} else if (score > 60) {
grade <- "D"
} else {
  grade <- "F"
}
print(grade)
```

> 1. if와 else 다음에 있는 중괄호 { }는 프로그래밍에서 코드블록이라고 부름 
> 2. 여러 명령문을 하나로 묶어주는 역할
>
> ```R
> old <- 20
> if (old>25) {print("통과")}
> else {print("비통광")}
> #위에 코드처럼 짜면 불가능함.. else가 바로 나오면안되므로
> 
> old <- 20
> if (old>25) {print("통과")
>   } else {print("비통광")}
> #위에처럼... else가 맨 앞안됨
> ```

```R
a <- 10
b <- 20
if(a>5 & b>5) { # and 사용
print (a+b)
}
if(a>5 | b>30) { # or 사용
print (a*b)
}
```

- 논리합(OR): “+” 나 “또는”, R에서는 “|”  >>>>or
- 논리곱(AND): “·” 나 “그리고”, R에서는 “&” >>>>>and

###  ifelse문

```R
a <- 10
b <- 20
if (a>b) {
c <- a
} else {
c <- b
}
print(c)
a <- 10
b <- 20
c <- ifelse(a>b, a, b)  #R에서의 조건문 표현법 (알아만두기..라고하심..하지만 훨편해보임)
print(c)
```

## 반복문

### for문

```R
for(i in 1:5) {
print(i)  #print는 줄당하나
}
for(i in 1:5) {
  cat(i)  #cat은 여러 결과값을 한줄에 출력
}

for(i in 1:9) {
print('2 *', i,'=', 2*i,'\n')   #cat은 print와 유사하지만 다름, \n반드시기억
}
```

### for 문 안에 if문 사용

```R
for(i in 1:20) {w
if(i%%2==0) { # 짝수인지 확인
print(i)
}
}

sum <- 0
for(i in 1:100) {
sum <- sum + i # sum에 i 값을 누적
}
print(sum)
>>>
5050
```

>```R
>/ 나눗셈
>%% 나머지
>%/% 몫
>```

### iris에서 꽃잎의 길이에 따른 분류 작업

```R
data(iris)
norow <- nrow(iris) # iris의 행의 수 
mylabel <- c( ) # 비어있는 벡터 선언 
for(i in 1:norow) { 
  if (iris$Petal.Length[i] <= 1.6) { # 꽃잎의 길이에 따라 레이블 결정 
    mylabel[i] <- "L"
    } else if (iris$Petal.Length[i] >= 5.1) {
             mylabel[i] <- "H" } else {
             mylabel[i] <- "M"
    } 
}

print(mylabel)                #레이블출력
newds <- data.frame(iris$Petal.Length, mylabel) # 꽃잎의 길이와 레이블 결합 head(newds) # 새로운 데이터셋 내용 출력
```

### while문

- while문은 어떤 조건이 만족하는 동안 코드블록을 수행하고, 해당 조건이 거짓일 경 우 반복을 종료하는 명령문

```R
sum <- 0
i <- 1
while(i <=100) {
    sum <- sum + i 
    i <- i + 1
} 
print(sum)
# sum에 i 값을 누적 # i 값을 1 증가시킴
```

### break

```R
sum <- 0 
for(i in 1:10) {
    sum <- sum + i
    if (i>=5) break 
  }
sum
```

### next

```R
sum <- 0 
for(i in 1:10) {
  if (i%%2==0) next
  sum <- sum + i 
}
sum
```

### apply() 함수 (꼭 알아두기)

- 반복 작업이 필요한 경우에는 반복문을 적용

- 반복 작업의 대상이 매트릭스나 데이터프레임의 행(row) 또는 열(column)인 경우는 for문이나 while문 대신에 apply() 함수를 이용할 수 있음

- apply() 함수의 문법

  ```
  apply(데이터셋, 행/열방향 지정, 적용 함수)
  ```

예시 

(mean()함수는 평균구하는 함수)

```R
apply(iris[,1:4], 1, mean) # row 방향으로 함수 적용 #1이 행방향
apply(iris[,1:4], 2, mean) # col 방향으로 함수 적용  #2는 열방향
```

## 함수

### 나머지 내장함수

```R
##내장함수
print(seq(11,20))
print(seq(11,20, by=2)) #간격 2로 줌

print(rep(1, times=5))
print(rep(11:20, times=5))

print(mean(25:83))
print(sum(1:100))
```

### 사용자 정의 함수

사용자 정의 함수 문법

```R
함수명 <- function(매개변수 목록) {
실행할 명령문(들)
return(함수의 실행 결과)
}
```

예시

```R
mymax <- function(x,y) {
  num.max <- x
  if (y > x) {
    num.max <- y
  }
  return(num.max)
}
mymax(2,1)
```

예시2

```R
mydiv <- function(x,y=2) {  #y 디폴트 2로 설정
  result <- x/y
  return(result)
}

mydiv(x=10,y=3) # 매개변수 이름과 매개변수값을 쌍으로 입력
mydiv(10,3) # 매개변수값만 입력
mydiv(10) # x에 대한 값만 입력(y 값이 생략됨)
```

#### 함수가 반환하는 결과값이 여러 개일 때의 처리

```R
myfunc <- function(x,y) {
val.sum <- x+y
val.mul <- x*y
return(list(sum=val.sum, mul=val.mul))
}


result <- myfunc(5,8)
s <- result$sum # 5, 8의 합
m <- result$mul # 5, 8의 곱
cat('5+8=', s, '\n')  #\n은 띄어쓰기
cat('5*8=', m, '\n') 
```

####  사용자 정의 함수의 저장 및 호출

```R
setwd("d:/source") # myfunc.R이 저장된 폴더 (우리는 c:/temp 로 변경)
source("myfunc.R") # myfunc.R 안에 있는 함수 실행
# 함수 사용
a <- mydiv(20,4) # 함수 호출
b <- mydiv(30,4) # 함수 호출
a+b
mydiv(mydiv(20,2),5) # 함수 호출
```

#### 조건에 맞는 데이터의 위치 찾기

- 데이터 분석을 하다 보면 자신이 원하는 데이터가 벡터나 매트릭스, 데이터 프레임 안에서 어디에 위치하고 있는지를 알기 원하는 때가 있음
- 예를 들어, 50명의 학생 성적이 저장된 벡터가 있는데 가장 성적이 좋은 학생은 몇 번째에 있는지를 알고 싶은 경우
- 이런 경우 편리하게 사용할 수 있는 함수가 which(), which.max(), which.min() 함수

```R
score <- c(76, 84, 69, 50, 95, 60, 82, 71, 88, 84)
which(score==69) # 성적이 69인 학생은 몇 번째에 있나
which(score>=85) # 성적이 85 이상인 학생은 몇 번째에 있나
max(score) # 최고 점수는 몇 점인가
which.max(score) # 최고 점수는 몇 번째에 있나
min(score) # 최저 점수는 몇 점인가
which.max(score) # 최저 점수는 몇 번째에 있나

score <- c(76, 84, 69, 50, 95, 60, 82, 71, 88, 84)
idx <- which(score<=60) # 성적이 60 이하인 값들의 인덱스
score[idx] <- 61 # 성적이 60 이하인 값들은 61점으로 성적 상향 조정
score # 상향 조정된 성적 확인
idx <- which(score>=80) # 성적이 80 이상인 값들의 인덱스
score.high <- score[idx] # 성적이 80 이상인 값들만 추출하여 저장
score.high # score.high의 내용 확인
```

```R
idx <- which(iris$Petal.Length>5.0) # 꽃잎의 길이가 5.0 이상인 값들의 인덱스
idx
iris.big <- iris[idx,] # 인덱스에 해당하는 값만 추출하여 저장
iris.big

# 1~4열의 값 중 5보다 큰 값의 행과 열의 위치를 idx (row, col로나옴)
idx <- which(iris[,1:4]>5.0, arr.ind =TRUE) #row, col 열로 나옴! 보기편함
idx
```

# 자료

## 자료 구조

### 자료 특성에 따른 분류

- 범주형 자료(질적 자료) 
  - 크기 비교못함
  - 성별, 혈액형
- 연속형 자료(양적 자료)
  - 크기 비교 가능

### 변수의 개수에 따른 분류

- 단일변수 자료(열이 하나, 벡터하나로 표현가능)
- 다중변수 자료(많은 변수들로 구성, 열이 여러개, 메트릭스or데이터프레임사용)

## 단일변수 범주형 자료의 탐색

### 도수 분포표 작성

도수 분포표는 정한 구간에 해당하는 파라미터가 얼마나 있는지 파악할수있다.

> 도수 분포표 만드는 원리
>
> \1. 자료의 개수를 센다. (55개) 2. 자료 내에서 최대/최소값을 찾는다. (최대 180, 최소 162) 3. 몇 개 구간으로 나눌지 결정한다. (5개 구간으로 설정) 4. 구간의 폭을 구한다. (구간폭=(최대값–최소값)/구간수, (180-162)/5=3.6, 따라서 4로 결정) 5. 구간의 경계값(급의 경계값)을 구한다. 6. 구간별 자료의 개수(도수)를 적는다.

```R
favorite <- c('WINTER', 'SUMMER', 'SPRING', 'SUMMER', 'SUMMER’,
'FALL', 'FALL', 'SUMMER', 'SPRING', 'SPRING')
favorite # favorite의 내용 출력
table(favorite) # 도수분포표 계산
table(favorite)/length(favorite) # 비율 출력
```

### 막대그래프

```R
ds <- table(favorite)
ds
barplot(ds, main='favorite season') #main은 차트 이름

ds.new <- ds[c(2,3,1,4)]
ds.new
barplot(ds.new, main='favorite season') #계절순서바꿈
```

### 원그래프

```R
ds <- table(favorite)
ds
pie(ds.new,clockwise=TRUE, main='favorite season') #시계방향
```

### 숫자로 표현된 범주형 자료

```R
#1=초록, 2=빨강, 3=파랑
favorite.color <- c(2, 3, 2, 1, 1, 2, 2, 1, 3, 2, 1, 3, 2, 1, 2)
ds <- table(favorite.color)
ds
barplot(ds, main='favorite color')
colors <- c('green', 'red', 'blue')
names(ds) <- colors #자료값 1,2,3을 green, red, blue로 변경
ds
barplot(ds, main='favorite color', col=colors) # 색 지정 막대그래프
pie(ds, main='favorite color', col=colors) # 색 지정 원그래프
```

## 단일변수 연속형 자료의 탐색

### 평균과 중앙값

- 평균은 그냥 평균, 중앙값은 자료의 값들을 크기순으로 일렬로 줄세웠을떄 중앙에 위치하는 값
- 절사 평균: 자료의 관측값들 중에서 작은 값들의 하위 n%와 큰 값들 의 상위 n%를 제외하고 중간에 있는 나머지 값들만 가지고 평균을 계산

```R
weight <- c(60, 62, 64, 65, 68, 69)
weight.heavy <- c(weight, 120)
weight
weight.heavy
mean(weight) # 평균
mean(weight.heavy) # 평균
median(weight) # 중앙값, 6개이므로 중앙값은 가운데 2개값/2임
median(weight.heavy) # 중앙값
mean(weight, trim=0.2) # 절사평균(상하위 20% 제외)
mean(weight.heavy,trim=0.2) # 절사평균(상하위 20% 제외)
```



### 사분위수

- 사분위수(quatile)란 주어진 자료에 있는 값들을 크기순으로 나열했을 때 이것을 4등 분하는 지점에 있는 값들을 의미
- 자료에 있는 값들을 4등분하면 등분점이 3개 생기는데, 앞에서부터 ‘제1사분위수 (Q1)’, ‘제2사분위수(Q2)’, ‘제3사분위수(Q3)’라고 부르며, 제2사분위수(Q2)는 중앙값 과 동일
- 전체 자료를 4개로 나누었기 때문에 4개의 구간에는 각각 25%의 자료가 존재

```R
mydata <- c(60, 62, 64, 65, 68, 69, 120)
quantile(mydata)
quantile(mydata, (0:10)/10) # 10% 단위로 구간을 나누어 계산
summary(mydata)
```



### 산포

- 주어진 자료에 있는 값들이 퍼져 있는 정도(흩어져 있는 정도)
- 분산(variance)과 표준편차(standard deviation)를 가지고 파악
- 분산: 평균에서 얼마나 떨어져있나?
- 자료의 분산과 표준편차가 작다는 의미는 자료의 관측값들이 평균값 부근에 모여있다는 뜻 

``` R
mydata <- c(60, 62, 64, 65, 68, 69, 120)
var(mydata) # 분산(variance)
sd(mydata) # 표준편차 (standard deviation)
range(mydata) # 값의 범위
diff(range(mydata)) # 최댓값, 최솟값의 차이
```



### 히스토그램(연속형 변수에게만 적용하는 막대그래프)

- 히스토그램(histogram)은 외관상 막대그래프와 비슷한 그래프로, 연속형 자료의 분 포를 시각화할 때 사용
- 막대그래프를 그리려면 값의 종류별로 개수를 셀 수 이어야 하는데, 키와 몸무게 등 의 자료는 값의 종류라는 개념이 없어서 종류별로 개수를 셀 수 없음
- 대신에 연속형 자료에서는 구간을 나누고 구간에 속하는 값들의 개수를 세는 방법을 사용
- 히스토그램에서는 막대의 면적도 의미가 존재함

```R
cars
str(cars) #데이터프레임 구조 보기
dist <- cars[,2] # 자동차 제동거리, 데이터프레임..
hist(dist, # 자료(data)
    main="Histogram for 제동거리", # 제목
    xlab ="제동거리", # x축 레이블
    ylab="빈도수", # y축 레이블
    border="blue", # 막대 테두리색
    col="green", # 막대 색
    las=2, # x축 글씨 방향(0~3)
    breaks=5) # 막대 개수 조절
```



### 상자그림

- 상자그림(box plot)은 상자 수염 그림(box and whisker plot)으로도 부르며, __사분위 수를 시각화__하여 그래프 형태로 나타낸 것
- 하나의 그래프로 데이터의 분포 형태를 포함한 다양한 정보를 전달하기 때문에 단일 변수 수치형 자료를 파악하는 데 자주 사용

```R
dist <- cars[,2] # 자동차 제동거리(단위: 피트)
boxplot(dist, main="자동차 제동거리")

boxplot.stats(dist)

boxplot(Petal.Length~Species, data=iris, main="품종별 꽃잎의 길이")
```

## 다중변수 자료의 탐색

### 산점도

- 다중변수 자료(또는 다변량 자료): 변수가 2개 이상인 자료
- 다중변수 자료는 2차원 형태를 나타내며, 이는 매트릭스나 테이터 프레임에 저장하여 분석
- 산점도란 2개의 변수로 구성된 자료의 분포를 알아보는 그래프

```R
#산점도
data() #R의 기본데이터 셋!!
str(mtcars)
wt <- mtcars$wt
mpg <- mtcars$mpg
plot(wt, mpg, main="중량 - 연비 그래프", xlab="중량", ylab="연비", col="red", pch=18) #pch는 plot에 18은 점 모양이 다이야몬드


# 변수 여러개
vars <- c("mpg","disp", "drat", "wt")
target <- mtcars[,vars]  #모든 행뽑고, 변수에 해당하는 열들 모두 추출됨
head(target)
pairs(target, main="multi plots") #x, y값으로 모두 그래프 그려줌\

# 변수관의 관계, 그룹관의 관계 한번에 관측비교가능(다른점모양, 다른 색 )
iris.2 <- iris[,3:4]
iris.2
point <- as.numeric(iris$Species) #종의 이름이 들어가잇으므로 숫자로 바꿔줌
iris$Species
point
color <- c("red", "green", "blue")
plot(iris.2, main="Iris plot", pch=c(point), col=color[point]) #pch은 점 모양 , col은 색깔지정 point번호로 color red, green, blue순으로 출력

```

### 상관분석과 상관계수

- 자동차의 중량이 커지면 연비는 감소하는 추세
- 추세의 모양이 선 모양이어서 중량과 연비는 '선형적 관계'에 있다고 표현
- 선형적 관계라고 해도 강한 선형적 관계가 있고 약한 선형적 관계도 있음
- 상관분석: 얼마나 선형성을 보이는지 수치상으로 나타낼 수 있다.

- 피어슨 상관계수(통계학에서 배운것)
  - -1<r<1
  - r이 1, -1에 가까울수록 x,y상관관계가 높음

```R

#상관분석과 상관계수
#R을 이용한 상관ㄱㅖ수의 계산
beers =c(5,2,9,8,3,7,3,5,3,5)
bal <- c(0.1,0.03,0.19,0.12,0.04,0.0095,0.07,0.06,0.02,0.05)

tbl <- data.frame(beers,bal) #데이터 프레임 생성
tbl
plot(bal~beers, data=tbl)  #산점도
res <- lm(bal~beers, data=tbl) #회귀식 도출, y=ax+b를 a,b구하는것, 
abline(res) #회귀선 그리기 
cor(beers, bal) #상관계수 계산, 0.6797025만큼  상관관계를 가짐(0.5보다 높으면 굿굿)

# 예시
cor(iris[,1:4]) #4개 변수 간 상관성 분석  #0.5이상이면 상관관계 높음
tbl <- data.frame(iris[,1:4])
tbl
plot(tbl)
```

