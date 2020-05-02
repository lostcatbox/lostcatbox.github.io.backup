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

데이터 프레임은 리스트+배열 같이 합친 데이터

- 리스트가 여러개 모여있거나
- 리스트 + 배열 





## 백터의 이해

### 백터의 개념

- 1차원 배열 데이터 (1행에 데이터가![스크린샷 2020-04-19 오후 1.19.47](https://tva1.sinaimg.cn/large/007S8ZIlgy1gdyyi46fffj316n0u0al4.jpg)있다)(1학년 학생들의 몸무게 자료) 

  ex) 몸무게 > 56|67|85|65|56|49

- 2차원 배열 데이터 (행과열이 존재)(국가별 GDP)

  ex) 우리가 익히 아는 엑셀 데이터, DB

### 리스트

![스크린샷 2020-04-19 오후 1.10.55](https://tva1.sinaimg.cn/large/007S8ZIlgy1gdyylu3oevj317u0t8198.jpg)



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
for(i in 1:20) {
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