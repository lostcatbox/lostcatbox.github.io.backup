---
title: R_language
date: 2020-03-27 15:32:53
categories:
tags:
---



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

숫자형, 문자형, 논리형, 특수값으로 변수의 자료형타입임, 

Null  정의되어있지 않음을 의미

NA 결측값(missing value) (데이터가 찾을려고해도 없어!)

NaN 수학적으로 정의가 불가능한 값(ex sqrt(-3))

Inf 양의 무한대, -Inf 음의 무한대

## 백터의 이해

### 백터의 개념

- 1차원 배열 데이터 (1행에 데이터가있다)(1학년 학생들의 몸무게 자료) 

  ex) 몸무게 > 56|67|85|65|56|49

- 2차원 배열 데이터 (행과열이 존재)(국가별 GDP)

  ex) 우리가 익히 아는 엑셀 데이터, DB

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
sort(d, decreasing = TRUE)   #  내림차순 정렬
```

