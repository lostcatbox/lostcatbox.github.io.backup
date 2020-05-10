---
title: 회귀선형모형
date: 2020-04-16 19:13:06
categories: [Dataminging]
tags: [Dataminging, Univ]
---

# 선형 회귀 분석?





## 기본 통계학적 개념

![스크린샷 2020-04-16 오후 7.11.41](https://tva1.sinaimg.cn/large/007S8ZIlgy1gdvrv47qvyj30vi0rijwl.jpg)

1. 평균(mean, average): 주어진 수의 합을 측정개수로 나눈 값으로, 대표값 중 하나이다
2. 분산(Variance): 편차의 제 곱의 평균값으로, 변량들이 퍼져있는 정도를 의미한다.
3. 표준편차(standard deviation): 분산의 양의 제곱근으로, 분산보다 많이 쓰인다.

## 확률변수

예를 들면 주사위는 1,2,3,4,5,6 이라는 확률 변수를 가질수있으므로 이산확률 변수, 또한 각각 확률 변수의 확률이 1/6이므로 이를 확률 분포로 그리면 딱딱끊김

## 더미변수

- __0 또는 1만으로 표현되는 값!__

- 카테고리 값을 그냥 정수로 쓰면 회귀 분석 모형은 이 값을 크기를 가진 숫자로 인식하므로 더미변수의 형태로 변환 필요

  예를 들면 1~12 월이 있는데 이것을 spring,summer,fall,winder로 0 or 1을 가진 변수로 바꿔주던가 아니면 mon1~mon12로 0 or 1을 가진 변수를 바꿔줘야만한다.

![CE8D740B-FCB7-461D-AADA-F031E370DF8D_1_105_c](https://tva1.sinaimg.cn/large/007S8ZIlgy1geasxe5si7j310r0gidhv.jpg)

![D4805572-E335-4F4F-8A9E-86DEA5742A6F_1_105_c](https://tva1.sinaimg.cn/large/007S8ZIlgy1geasxh635pj30yx0hdwgu.jpg)

# 선형 회귀 분석 해보기

## 데이터를 파일 또는 웹에서 가져오기

```R
rd<-read.csv(“/User/”, header=T) #파일 (csv 형태): 
rd <- read.table("http://사이트주소", header = T, stringsAsFactors = FALSE) #웹 (txt 형태), stringsAsFactors는 데이터안에 문자열로되어있는것을 범주형factors로 인식해버림을 방지
```

## 산점도를 통한 두 변수간 관계 확인(관계성 유효한지 눈치보기)

```R
plot(x=a, y=b, xlim=c(0,10), ylim=c(0,10), main=“points“) #xlim, ylim은 값범위를 나타냄
par(mfrom=c(2,1));plat(x1,y);plot(x2,y) #;는 다른선언문이라고 표현

```

## 필요한 변수 생성 및 모으기(질적변수>>양적변수처럼 만드는 더미변수)

### 일괄적 더미변수 생성

마지막에는 cbind로 dummy데이터 합쳐놔야함

A변수는 다 썻으면 없애기

```R
  drd <- data.frame(fac=factor(rd$A));#rd$A변수를 범주형 변수로 바꾼다음, 데이터프레임으로 저장후,  
  dummy <- model.matrix(~fac-1, drd) #~fac을 더미변수로 변형됨,  -1은모든 0으로 되있는변수는 생성하지않고
```

### 조건별 더미변수 생성

특정조건에 해당하면 1, 아니면 0

A변수는 끝났으면 삭제, 아래는 기존 데이터에 추가되므로 cbind필요없다

```R
    newdata <- transform(rd, dum1 = ifelse(A >= 1 & A < 2, 1, 0), dum2 = ifelse(A >= 3 & Month <4, 1, 0)) #더미변수 생성
```

## 회귀분석 돌리기

```R
reg <- lm(y ~ x1+x2, data=rd)
# reg <- lm(y ~ ., data=rd) ; summary(reg) #이것도 사용가능, 하지만 .을 사용하므로 A변수를 제거하고, 여분의 변수들 역시 제거 완료된 데이터여야함
reg1<-step(reg, trace=F) #유효한 변수들만 걸러내기 step활용 
```

## 등분산성, 정규성, 독립성 체크하기

### 잔차의 등분산성 – 잔차와 독립변수의 산점도

```R
plot(newdata$A, residuals(reg1), xlab="residuals", ylab="이름 넣기") #residuals는 잔차가져오는 함수
abline(h=0, col="red", lty=2) #선 긋기 
```

### 잔차의 정규성 – 잔차의 정규확률그림(normal Q-Q plot)

```R
qqnorm(residuals(reg1), main="그래프이름")
qqline(residuals(reg1), lty=2, col="red")
#qqnorm의심될때, 잔차분석 – Shapiro-Wilk의 정규성 검정 (귀무가설: 정규분포에서 추출된 표본이다.)
shapiro.test(residuals(reg1))
```

### 독립변수들 간의 독립성 – 분산확대인자

```R
vif(reg1)   #vif의 10이하면 독립성이 성립!
```

## 최종모형 선택 & 작성

### 최종모형의 타당성 검증 R^2, Adj.R^2 확인

```R
#회귀식 y_hat= beta0+beta1*x1+..........+beta(p+1)*d(p+1) +... #d는 더미변수들
#R2 & Adjusted R2
```

```R
# 분산분석표 – SSE, SSR, MSE, MSR 등을 확인할 수 있음
```

---------

## 실습해보기

#### 최종 모형에 만약 p값이 의미없는 변수가 있다면

- step 함수를 적용한 회귀분석 결과가 최종 모형이므로 유의하지 않은 계수들을 포함할 수 있습니다.  식에는 포함시키되, 식을 해석할 때와 예측할 때만 유의하지 않은 계수는 제외하고 계산하면 됩니다.

```R
install.packages("car")
library(car)

rd <- read.csv("/Users/lostcatbox/uinv_lecture/data_mining/Lec6_dummy.csv", header=T)
str(rd)
#month변수는 우리가 볼때는 범주형 변수지만 R에서는 일단 연속형으로보고있다
#즉, 더미 변수로 변환해줘야함
drd <- data.frame(mon=factor(rd$Month)) #일단 범주형인식후  mon변수로 가져옴
str(drd)
dummy_month <- model.matrix(~mon-1,drd) #더미를 생성함, mon변수에서 -1를 한이유는 0으로만 이루어진 interupt을 없애고 출력하겠음. 0만 나오는건 출력안함

#아래는 봄여름가을겨울 계절 변수 만들기
season <- transform(rd, spring = ifelse(Month>=3&Month<6,1,0), summer = ifelse(Month>=6&Month<9,1,0), 
                    fall = ifelse(Month>=9&Month<12,1,0), winter=ifelse(Month==12|Month<=2,1,0)) #일단 계절에 해당하는 변수 4개 생성

#1 dummy 없이 회귀분석 돌려보기
par(mfrow=c(2,2))
plot(x=rd$temp,y=rd$beer)
plot(x=rd$pay,y=rd$beer)
plot(x=rd$unemp,y=rd$beer)
plot(x=rd$index,y=rd$beer)

#더미없는것으로
reg_nodummy <- lm(beer~temp+pay+unemp+index, data=rd)

#스텝function을 이용해서 관련없는 변수들 제거
reg_nodummy1 <-  step(reg_nodummy, trace=F)
summary(reg_nodummy1)
#결과에서 index변수가 빠진것을 볼수있다., 이 회기모형에서 예측력이 도움이 되지 않음으로 판단됨

#beer_hat = 14.139 +0.137*temp + 1.249*pay -0.615*unemp
#                    (p>0.001)      (p=0.039)   (p<0.001) #모두 유의미하게 y에 영향줌
#R^2 = 0.692
#Adj. R^2 = 0.671 다중회기에서 꼭!!적기 #x변수들이 y변수들이 설명하는데 67%정도 설명가능함

#다음 잔차의 등분산성, 정규성, 독립성 봐야함
#잔차의 등분산성(x변수각각 잔차와 비교함)
#다들 퍼져있고 갈수록 증가 감소안보임
par(mfrow=c(3,1))

plot(rd$temp, residuals(reg_nodummy1))
abline(h=0,col='red',lty=2)
plot(rd$pay, residuals(reg_nodummy1))
abline(h=0,col='red',lty=2)
plot(rd$unemp, residuals(reg_nodummy1))
abline(h=0,col='red',lty=2)

#잔차의 정규성

par(mfrow=c(2,1))
qqnorm(residuals(reg_nodummy1))
qqline(residuals(reg_nodummy1), col="red", lty=2)#기준선
#끝쪽이 기준선에서 벋어나는것을 보임
shapiro.test(residuals(reg_nodummy1))
#w=.976, p=0.420 #잔차가 정규성을 뜰라면 기무가설이 증명되어야 좋은거임0.05에비해 엄청큼, 정규성 성립

# x변수들간의 독립성
#다중공선성이란, x변수(입력변수)들간에 상관관계가 존재해버리는것 (데이터 분석시 부정적인 영향을 미치는 현상, 분산이 엄청 커져버림, 회기계수를 믿을수없게됨)
vif(reg_nodummy1) #최종 회기모형넣어줘야함
vif(reg_nodummy1) >10 #True, False값만 보기

#2 mon dummy 추가하여 회귀분석 돌리기.
#산점도 그려서 보는것은 생략

#기존에 있던 rd에 month변수와 값들 추가하기
#cbind는 행을 기준으로 두 데이터를 합치는 함수(두 데이터의 열의 개수가 동일해야함)
#rbind는 열을 기준으로 두 데이터를 합치는 함수(두 데이터의 행의 개수가 동일해야함))
rd_month <- cbind(rd, dummy_month)
#더미변수는 범주의 갯수 -1 해야되므로 12달중에 1달 뺴야함.
#우리는 mon1을 빼겠음 + month는 이미 더미변수로 만들었기때문에 뺴도됨.
#첫번째 방법
rd_month1 <-rd_month[,c(-1, -7)] #행은 다 가져오고 1열, 7열 제외한 모든 열 가져옴

#두번째 방법(함수이용)
rd_month2 <- subset(rd_month,select = c(-Month,-mon1))  #subset은 부분집합 이라는 뜻

#따라서 데이터 프레임 만들었음 >회귀분석 돌리기

reg_month <- lm(beer~., data=rd_month1)#상관없는 인자빼서 ~.으로 가능(종속변수선택, 나머지 독립변수) #기준이 1월임>>beta_0가 1월
reg_month1 <- step(reg_month,trace=F)
summary(reg_month1)

#beer_hat = 18.356 + 0.120temp - 0.881unemp - 1.580mon4 -1.165mon10 - 2.274mon11
#                    (p<0.001)    (p<0.001)    (p=0.027)   (p=0.10142)  (p=0.003) #mon10은 R^2값을 설명하느데는 도움됨
#R^2 = 0.753
# Adj. R^2 = 0.7235 
#해석은 4, 11이 판매량 감소고 다른 달은 판매량이 동일함. 10월도 판매량 동일, 11월달이 가장적다. 
#72.4%정도 모든 x들이 종속변수를 설명함.

#잔차의 등분산성(유효한 연속형 변수에만 하면됨)
par(mflow=c(2,1))
plot(rd_month1$temp, residuals(reg_month1))
abline(h=0, col="red", lty=2)
plot(rd_month1$unemp, residuals(reg_month1))
abline(h=0, col="red", lty=2)

#잔차의 정규성
par(mflow=c(1,1))
qqnorm(residuals(reg_month1))
qqline(residuals(reg_month1), col="red", lty=2)
# 벗어난것 보이므로 shapiro
shapiro.test(residuals(reg_month1))
# W = 0.95681, p-value = 0.07503 5%유의수준에서는 귀무가설이 기각되지 못하므로 정규성이 성립하지만
#10%유의수준에서는 귀무가설이 기각된다, 정규성이 성립하지 못한다.

#독립변수들 간의 독립성
vif(reg_month1)
#모든 변수가 10 미만이므로 독립적임

#따라서 3가지 성질이 모두 확립되므로 회귀모형이 유효함


# season 데이터를 사용하여 회기분석하기 #month 변수 제거후 사용해야함
```



