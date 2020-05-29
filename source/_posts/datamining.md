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

10주차

```R
setwd("/Users/lostcatbox/univ_lecture/data_mining/Lec10_실습자료/")
data = read.csv("Lec10_regression.csv", header = T)
#항상 데이터 확인하기
update_data = data[,-1]
#1열 빼기
str(update_data) #Factor로 인지되었으므로 더미변수처리가능

plot(data$dose, data$len)

#첫번째 방법으로 그냥 회귀분석 (교후작용 x)
reg <- lm(len~., data=update_data)
reg1 <- step(reg, trace=F)
summary(reg1)

#len_hat = 9.272 -3.700*suppVC +9.7636*dose
#(p=0.001)      (p<0.001)
#R^2 = 0.7038 Adj.R^2 = 0.6934


#교효작용 적용
reg2 <- lm(len~.^2, data=update_data)
reg3 <- step(reg2, trace=F)
summary(reg3)
#len_hat = 11.550  -8.255*suppVC + 7.811 *dose + 3.904*(suppVC*dose)
#                      (p=0.001)      (p=0.001)       (p=0.025)
#R^2 = 0.730 Adj.R^2 = 0.715  
#설명력 이 올라감 R값을 보면, 따라서 더미변수에 따라 나누는것이 맞음

## 예제 2번째 
#size, income둘다 양적 변수이므로 교효작용 사용 불가.
# size-score or size-income의 산점도를 그려서 비선형 선택후 2차함수로,,
data2 <-  read.csv("Lec10_regression2.csv", header=T)
str(data2)

#산점도 그리기.
plot(data2$size,data2$score)
plot(data2$income,data2$score)  #낫 모양임.비선형

#그냥 선형회귀분석으로 돌려보기
reg4 <- lm(score~., data=data2)
reg5 <- step(reg4, trace=F)
summary(reg5)

# score_hat = 638.729 -0.648*size + 1.839*income
#                         (p=0.0679)    (p<0.01)  
# R^2=0.511 
# Adj.R^2 = 0.5091 

#2차함수 넣어서 돌려복 양적변수 2개면>?? 이렇게? size는 왜안함.???
reg6 <- lm(score~size+income+I(income^2), data=data2)
reg7 <- step(reg6, trace=F)
summary(reg7)

# score_hat = 625.230 -0.910*size +  3.882*income -0.0442*income^2
#                         (p=0.00727)    (p<0.01)     (p<0.01)
# R^2=0.564
# Adj.R^2 = 0.561

##2차함수는 종속변수가 최대를 가지는 시점이있음.구하기

reg8 <- lm(score~income + I(income^2), data=data2)
summary(reg8)

# score_hat = 607.302 + 3.851*income - 0.042income^2
#income으로미분하여 기울기 =0되는 곳찾기
# 3.851 - 0.084*income = 0 >>>>> income값이 3.851/0.084= (45.845)일때score 최대값가짐


##예제3  다 양적변수이므로 교효변수 적용 못함 

####################여기까지가  y변수 x변수 둘다 양적변수 하나이상있어야했음

#로지스틱 회귀분석: y변수가 질적변수로 나타남 (암환자 아니다 맞다 구별에사용)
# 로지스틱 회귀변수는 더미변수임 0~1사이의 값을 가짐.
# 선형 회귀 분석에서는 x가 -무한대 ~+무한대 인데 y는 0~1범위라면 설명 불가능
#로지스틱 회귀분석 필요
# 로지스틱  회귀 분석에서는 x가 -무한대 ~+무한대 인데 y는 0~1범위라면(로지스틱함수사용)-무한대 ~+무한대로바꿔줌 
# odds 라는 가정 필요
## 실패확률에 대한 성공에 비율
## p=성공확률; 1-p=실패할 확률; odds=p/1-p; p는 0~1사이의 값을 가짐; odds는 0에서 무한대값을 가질수있음
## ln(odds)= ln(p)-ln(1-p)
## 즉 이 값은 ln(odds)는 -무한대 ~+무한대사이의 값을 가짐

##ln(odds) = 베타*X
## 원하는 값은 즉 결과적으로 0 or 1만 가져야함,(더미변수로)
## 애를 연속변수로 생각한다면 0~1사이 값을 가짐 즉 0.5라는기준은 세워서 이하면 0 05보다 높으면 1(이게 확률값)
## 즉 확률 값이 0~1밖에 못구하므로 ln취함, -무한대 ~+무한대사이의 값을 가짐
## ln(odds)=베타*X로 로지스틱 함수가 완성됨.

#로지스틱 회귀분석 과정
##- 1단계: 각 집단에 속하는 확률의 추정치를 예측. 이진분류의 경우 집단 1에 속하는 확률 P(Y=1)의 추정치로 얻음. - 2단계: 추정확률 → 분류기준값(cut-off) 적용 → 특정 범주로 분류
## 예) P(Y=1) ≥ 0.5 → 집단 1로 분류
##P(Y=1) < 0.5 → 집단 0으로 분류


##odds는 확률 이 아님. p/1-p
## odds = 1/6 =0.16666 ; odds=6/1=6 대칭안됨
## odds = ln(odds)= ln(1/6)= -1.7917;odds = ln(odds)= ln(6/1)= 1.7917 대칭
## p=0.5 >> odds=1 >>logit(p)=ln(odds)=0

# odds ratio
## - 설명변수 x=1에서의 odds와 x=0에서의 odds의 비
#- x가 한 단위 증가할 때 y=1일 위험과 y=0일 위험의 비의 증가율
#- 설명변수 x=1에서의 odds와 x=0에서의 odds의 비
#- x가 한 단위 증가할 때 y=1일 위험과 y=0일 위험의 비의 증가율
#- 특정 위험에 노출될 경우, 그렇지 않은 경우에 대한 상대적 위험도- 특정 위험에 노출될 경우, 그렇지 않은 경우에 대한 상대적 위험도



```

11주차

```R
#범주형 타입으로 바꾸기
x1 <- c(200, 100, 120, 130)
x2 <- c(1,0,1,1)
y <- c(1,0,0,1)

data <- data.frame(cbind(y,x1,x2))
str(data)

data$y <- as.factor((data$y))
str(data)
#또는 반복문으로 좀더 간편하게 변형가능
for (i in c("y","x2")) {
  data[,i] <- as.factor(data[,i])
}
str(data)

#로지스틱 회귀분석 과정
#1) "https://stats.idre.ucla.edu/stat/data/binary.csv" 링크에서 csv 파일 불러서 저장하기 2) head() 함수를 이용하여 데이터 확인
#3) Missing 데이터 유무 확인 및 제거
#4) str() 함수를 이용하여 변수 class 확인하기
#5) 범주형 변수 범주화하기
#6) 로지스틱 회귀분석 돌리기 – 유의한 변수로 구성된 모형 구하기: step(reg, trace=F) 7) 다중공선성 확인
#8) 회귀계수 유의미 및 모형 적합성 확인하기
#9) 결과 해석하기

# 로지스틱 회귀분석 실습
install.packages("BaylorEdPsych")
library(BaylorEdPsych)
library(car)
install.packages("aod")
library(aod)

data <- read.csv("https://stats.idre.ucla.edu/stat/data/binary.csv")
str(data)
data[,"admit"] <- as.factor(data[,"admit"])
data[,"rank"] <- as.factor(data[,"rank"])
str(data)
head(data, 3) #data의 처음 3개를 출력
tail(data)   #data의 마지막 6개 출력
sum(is.na(data))  #0이 나오므로 NA(결측치)없음

#왜 rank는 더미변수로 변화하고 작업하지 않는가, R이 factor이므로 알아서 rank1을 상수항으로하고 rank2~4는 더미변수로 자동으로 처리함


logit <- glm(admit ~., family=binomial, data=data)
logit1 <- step(logit, trace = F)
summary(logit1)
PseudoR2(logit1)   #설명력.. Adj.R과 의미하는바같음


#In(odds)_hat = -3.990 + 0.002gre +0.804gpa -0.675rank2 - 1.340rank3 - 1.551rank4
#                          (p=0.038)  (p=0.015)   (p=0.033)  (p<0.001)   (p<0.001)
#AIC = 470.52
#McFadden Pseudo R^2 = 0.083
#Adj.McFadden R^2 =0.055

#다중공선성 확인
vif(logit1)

#p값들로 계수 유의한지 보기 
#임계치와 잔차이탈도 구하기 모형 적합성 따지기
qchisq(0.95, df=394) #임계치 구함 #Residual deviance: 458.52  on 394  degrees of freedom여기에 자유도 나옴
#임계치=441.282  잔차 이탈도 = 458.52
#임계치보다 작야야하는데 크므로 모형이 적합하지 않음을 알수있다.

#결과 해석
#계수 해석시 로그 기준이므로, 로그제거하자
#회귀계수들은 log odds의 증가량이므로 exponential을 취하면 odds의 증분이 됨 exp(coef(mylogit))
exp(coef(logit1))
#odds_hat = 0.019 +1.002gre +2.234pga+0.509rank2 +0.262rank3 +0.212rank4
# gre 1단위증가할때마다 합격할확률이 불합격할확률보다 1.002배 커짐.. 나머지도 같은 해석.
# p/(1-p) = 0.019 +1.002gre +2.234pga+0.509rank2 +0.262rank3 +0.212rank4

#해석:
#- gre가 한 단위 증가함에 따라 admission이 1일 odds가 1.002배 (0.2%) 증가 (합격할 확률 = 불합격할 확률 이면 1배이므로 1.002배는 즉 0.2%증가한거임)
#- gpa가 한 단위 증가함에 따라 admission이 1일 odds가 2.23배 (123%) 증가함 - rank2면 admission이 1일 odds가 0.509배(49.1%) 감소함
#- rank3이면 admission이 1일 odds가 0.262배(73.8%) 감소함
#- rank4면 admission이 1일 odds가 0.212배(78.8%) 감소함

#현재 구한것들은 rank1이 기준으로 각각 비교 가능하지만 rank2~4간의 비교는 불가 

##rank 변수의 전반적 효과 (234간의 다른것없다면 차이가 없으므로 rank2,3,4에있으면 차이없다고 결론)
##- 귀무가설: rank 변수의 효과가 없다. (p-value가 작으면 계수의 효과가 다름)
##install.packages(“aod”) 
##Package 설치 후 Packages에서 선택 
##wald.test(b = coef(mylogit), Sigma = vcov(mylogit), Terms = 4:6) #b에는 계수들 넣어줘야함 #분산알려줌

wald.test(b=coef(logit1), Sigma=vcov(logit1), Terms=4:6)
#chisq(3) = 20.9, p<0.001
#기무가설이 rank변수의 효과가 다르지 않다.이므로 기각됨. 즉, rank2~4간의 효과가 다르다.#다음 아래과정 필요

##rank2, 3, 4 변수간의 회귀계수가 같은지 검정하기
##- 귀무가설: rank2의 회귀계수와 rank3의 회귀계수가 같다. (p-value가 작으면 두 회귀계수의 효과가 다름)
##l <- cbind(0, 0, 0, 1, -1, 0)
##wald.test(b = coef(mylogit), Sigma = vcov(mylogit), L = l

l <- cbind(0, 0, 0, 1, -1, 0) #현재 rank2, rank3만 살려놓음
wald.test(b = coef(logit1), Sigma = vcov(logit1), L = l)
# chisq(1) = 5.5, p =0.019
# rank2와 rank3의 효과가 다르다

l <- cbind(0, 0, 0, 1, 0, -1) #현재 rank2, rank3만 살려놓음
wald.test(b = coef(logit1), Sigma = vcov(logit1), L = l)
# chisq(1) = 5.7, p =0.017
#rank2와 rank4의 효과가 다르다

l <- cbind(0, 0, 0, 0, -1, 1) #현재 rank2, rank3만 살려놓음
wald.test(b = coef(logit1), Sigma = vcov(logit1), L = l)
# chisq(1) = 0.29, p =0.590
#rank3와 rank4의 효과가 다르지 않다
## 즉, 새로운 데이터가 들어올떄 학생이 rank3과 rank4일때 서로 차이없이 합격 불합격 정해짐



#실습  심화
##gre, gpa 고정하고 Rank가 변할 때 p (admit 확률) 변화 보기
newdata1 <- with(data, data.frame(gre = mean(gre), gpa = mean(gpa), rank = factor(1:4)))  #with 이므로 gre, gpa값은 모두 같고 rank만 1,2,3,4가짐
newdata1$rankP <- predict(logit1, newdata = newdata1, type ="response") #logit1모형으로 예측하기 #type에는 response(성공할 확률 p값출력)와 link(ln(odds)값 출력됨)를 줄수있음.
newdata1
#따라서 1만합격 , 나머지는 불합격

##rank, gpa 고정하고 gre의 효과보기
##newdata2 <- with(mydata, data.frame(gre = rep(seq(from = 200, to = 800, length.out = 100), 4), gpa =mean(gpa), rank = factor(rep(1:4, each = 100)))) #rep()함수는 안에있는 요소 반복해줌

##newdata2$rankP <- predict(mylogit, newdata = newdata2, type = "response")
newdata2 <- with(data, data.frame(gre = rep(seq(from = 200, to = 800, length.out = 100), 4), gpa =mean(gpa), rank = factor(rep(1:4, each = 100))))

newdata2$rankP <- predict(logit1, newdata = newdata2, type = "response")
```



