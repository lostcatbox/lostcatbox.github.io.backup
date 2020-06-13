---

title: 회귀선형모형
date: 2020-04-16 19:13:06
categories: [Dataminging]
tags: [Dataminging, Univ]
---

# 선형 회귀 분석

t, p/f [자세히]([http://blog.daum.net/dataminer9/category/t%EA%B2%80%EC%A6%9D%2C%EB%B6%84%EC%82%B0%EB%B6%84%EC%84%9D%2CF%EA%B2%80%EC%A6%9D%2CANOVA](http://blog.daum.net/dataminer9/category/t검증%2C분산분석%2CF검증%2CANOVA))



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

  예를 들면 1\~12 월이 있는데 이것을 spring,summer,fall,winder로 0 or 1을 가진 변수로 바꿔주던가 아니면 mon1\~mon12로 0 or 1을 가진 변수를 바꿔줘야만한다.
  
- 한 종류 더미변수들 중에 기준이 되는 더미변수(mon1~mon12에서 mon1)하나는 반드시 제거후에 돌려줘야함(그래야 beta0값을 기준으로 beta들 차례대로 정해지니까)

![CE8D740B-FCB7-461D-AADA-F031E370DF8D_1_105_c](https://tva1.sinaimg.cn/large/007S8ZIlgy1geasxe5si7j310r0gidhv.jpg)

![D4805572-E335-4F4F-8A9E-86DEA5742A6F_1_105_c](https://tva1.sinaimg.cn/large/007S8ZIlgy1geasxh635pj30yx0hdwgu.jpg)

## 선형 회귀 분석 해보기

### 데이터를 파일 또는 웹에서 가져오기

```R
rd<-read.csv(“/User/”, header=T) #파일 (csv 형태): 
rd <- read.table("http://사이트주소", header = T, stringsAsFactors = FALSE) #웹 (txt 형태), stringsAsFactors는 데이터안에 문자열로되어있는것을 범주형factors로 인식해버림을 방지
```

### 산점도를 통한 두 변수간 관계 확인(관계성 유효한지 눈치보기)

```R
plot(x=a, y=b, xlim=c(0,10), ylim=c(0,10), main=“points“) #xlim, ylim은 값범위를 나타냄
par(mfrom=c(2,1));plat(x1,y);plot(x2,y) #;는 다른선언문이라고 표현

```

### 필요한 변수 생성 및 모으기(질적변수>>양적변수처럼 만드는 더미변수)

#### 일괄적 더미변수 생성

마지막에는 cbind로 dummy데이터 합쳐놔야함

A변수는 다 썻으면 없애기

```R
  drd <- data.frame(fac=factor(rd$A));#rd$A변수를 범주형 변수로 바꾼다음, 데이터프레임으로 저장후,  
  dummy <- model.matrix(~fac-1, drd) #~fac을 더미변수로 변형됨,  -1은모든 0으로 되있는변수는 생성하지않고, #모든 값종류기준으로 전부 더미변수로
```

#### 조건별 더미변수 생성

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

step 함수를 적용한 회귀분석 결과가 최종 모형이므로 유의하지 않은 계수(p값이 의미없는것)들을 포함할 수 있습니다.  식에는 포함시키되, 식을 해석할 때와 예측할 때만 유의하지 않은 계수는 제외하고 계산하면 됩니다.

```R
install.packages("car")
library(car)

rd <- read.csv("/Users/lostcatbox/univ_lecture/data_mining/Lec6_dummy.csv", header=T)
str(rd)
#month변수는 우리가 볼때는 범주형 변수지만 R에서는 일단 연속형으로보고있다
#더미 변수로 변환해줘야함, 아래 과정은 전체를 더미변수화하는것이므로 4계절로나누는것불가!
drd <- data.frame(mon=factor(rd$Month)) #일단 범주형인식후  mon변수로 가져옴
str(drd)
dummy_month <- model.matrix(~mon-1,drd) #더미를 생성함, mon변수에서 -1를 한이유는 0으로만 이루어진 interupt을 없애고 출력하겠음. 0만 나오는건 출력안함

#4계절 더미변수만들기
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
#해석은 4, 11이 판매량 감소고 다른 달은 판매량이 동일함. 
#10월도 판매량 동일(해당계수가 유의미하지않으므로 0으로취급), 11월달이 가장적다. 
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

# 비선형데이터 다루기

- [변수](https://m.blog.naver.com/libido1014/120113775017), [변수2](http://triki.net/study/3108#dry_toc_2)

- 데이터가 낫처럼 휘어져 있음

- 좋은 회귀식의 조건은 데이터의 중앙을 지나야 하지만 직선으로 굽어진 데이터의 중앙을 모두 지날 수 없음

- x 값의 변화에 따른 y 값의 변화가 일정하지 않음

- 변하는 기울기를 설명하지 못하는 상황 발생

- 변수 간의 독립성이 무너짐

- 비선형 데이터를 다루는 방법:

  - 1차가 아닌 r차의 변수 사용(2차 함수 예시)(독립변수가 연속형일때 사용가능)

  - 교호작용(interaction) 변수 사용(기울기까지 바꿀수있음)

    더미변수(질적변수)와 독립변수의 연속형(양적변수)데이터면 교호작용 변수 사용하면됨(구지  r차 변수 사용안해도됨)

## 교호작용

질적변수와 양적변수의 교호작용:

예시

𝑋: 연령, 𝑆: 성별(1 여성, 0 남성)일 때, 초봉(Y)를 설명하려고 한다. (당연히 성별이 질적변수)

더미 변수만 활용시 

```R
𝑌 = 𝛽􏰀 + 𝛽􏰁𝑋 + 𝛽􏰂𝑆 + 𝜖
```

 남성일 때의 연령과 여성일 때의 연령을 고려하기 위해서 교호작용 변수(𝑋 􏰃 𝑆)를 적용

```R
𝑌= 𝛽􏰀+𝛽􏰁𝑋+𝛽􏰂𝑆+𝛽􏰄(𝑋􏰃𝑆)+𝜖
```

연령에 따른 회귀직선의 절편과 기울기가 바뀌어서 성별을 고려한 비교가 가능해짐

```R
𝑌_hat= 8+1.1􏰁𝑋+1.2􏰂𝑆-0.4􏰄(𝑋􏰃𝑆)+𝜖 라고한다면 XS에 따라 기울기 변함
남성은 8+1.1X
여성은 8 +1.1X + 1.2 - 0.4X = 9.2+0.7X
```

유용한 인수들

```R
lm(y~x*z, data = data) #x*z를 이렇게 쓰면 x, z각각은 기본적으로 들어가게됨
```



### 실습해보기

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
```

## 2차함수

선형회귀 말고
그래프에 커브가 보이면 r차 함수로 추정하자

독립변수의 이차함수 사용하기: 

```R
lm(y~x+I(x^2), data = data) #알파벳 I()함수쓰는것
```

### 실습해보기

```R
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


```

# 로지스틱 회귀분석

```R

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



11주차(로지스틱함수 자세히)

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



12주차(train, test set)

```R
# Train, Test set 만들기(왜? 현재 있는 데이터로 모델만들 데이터와, 만든 모형 테스트 해야하므로)
# Train set: 모형을 만들 데이터
# Test set: 만든 모형을 검증,검사할 데이터
#보통 8:2 또는 7:3으로 설정
#설정 방법:
#(그림1)
#  sep <- sample(2, nrow(x), prob = c(0.8, 0.2), replace = T)  #sample함수는 1,2중 2를 뽑고 replace=T이므로 공을 뽑고 다시 그 데이터 집어넣음.
# nrow(x)는 행의 갯수 만큼 뽑을꺼임, prob = c(0.8,0.2) 은 1,2를 각각 뽑을 확률임,즉 정확게 8:2는 아님.
# 즉 변수1, 변수2 가있는 데이터 프레임이 있다면 sep변수 만들어서 1 or 2 를 값으로 추가하여 test set과 train set을 만듬
#  train.x <- x[sep == 1, ]  #sep==1인 열 모두  
#  test.x <- x[sep == 2, ]   #sep==2인 열 모두
#  공선성 검사 (vif 가 5이하면 공선성 없는 것)
#  "car" package install 후 library(car) 실행
#실행 방법: vif(logit.fit)



#Train set을 이용하여 만든 모형의 예측력
#" ROCR " package install 후 suppressMessages(library(ROCR)) 실행
# ROC 커브 아래의 영역 AUC가 1에 가까울 수록 모델의 예측 정확도 높음 
# 실행 방법:
#  logit.full.pred <- predict(logit.fit, newdata=testset, type="response") #logit.fit = train 데이터로 만든 모형, newdata=testset를 가지고 예측하는 함수 # y_hat값 가지고있음
# logit.full.pr <- prediction(logit.full.pred, testset$Y) #예측력 보는 함수, 역할은 위의 y_hat값(logit.full.pred)과 실제데이터의 y값을 비교
#  logit.full.prf <- performance(logit.full.pr, measure = "tpr", x.measure = "fpr")  #y축이 trp(맞는것 맞다고함) x축이 fpr(틀린것 맞다고함)임. 
# plot(logit.full.prf) #ROC 곡선 그리기
#  logit.full.auc <- performance(logit.full.pr, measure = "auc")  #performance함수의 auc계산함
# logit.full.auc <- logit.full.auc@y.values[[1]] #AUC면적을 나타내는 것은 첫번째 리스트에 있는 값에 존재
# logit.full.auc #ROC 곡선 아래 면적


#AUC 판단기준
#• excellent = 0.9~1
#• good = 0.8~0.9
#• fair = 0.7~0.8
#• poor = 0.6~0.7
#• fail = 0.5~0.6

#데이터 정리에 유용한 함수
#sapply(x, function(y) expression)  #각각의 변수에 함수 적용 하고싶을때!
#예) x 데이터 안에 있는 각 변수 별 평균 구하기:
#  sapply(x, function(y) mean(y)) 
# 예)x데이터안에 각변수별NA의개수구하기:
#  sapply(x, function(y) sum(is.na(y)))
#예) x 데이터 안에 각 변수 별 원소 값의 종류 개수 구하기:
#  sapply(x, function(y) length(unique(y))) 

#suppressMessages(library(dplyr)) 패키지 또는 install.packages("dplyr"); library(dplyr) #dplyr가 데이터 편집, 정제 좋은 함수많음
#select(x, y1, y2) :select는 특정 열만 추출가능, x 데이터 안에 있는 y1, y2 변수만 선택
#mutate(x, y=ifelse(A, B, y)) : mutate함수는 데이터 수정에 쓰임. x 데이터 안에 있는 y변수가 A면 B로 치환하고 아니면 그대로 y 출력 
# filter(x, A) : filter는 특정 행만 추출가능, x 데이터에 A인 경우만 거르기


# 로지스틱 회귀분석 실습
#해야하는 것
#Lec12_Logistic1.csv 파일에 있는 데이터를 이용하여 Titanic 생존 여부를 설명하는 모형을 만드시오. 
#1) 데이터 불러오고 확인하기
#2) 변수 별 NA 개수 확인하기
#3) Name, Ticket, 그리고 NA가 500개 이상인 변수들 외에 나머지 변수들만 선택하여 저장하기
#4) Age 변수 결측 값은 평균 값으로 대체
#5) 남은 결측 값 행 제거 (filter 사용)
#6) Train set과 Test set을 8:2로 나누기
#7) Train set 이용하여 로지스틱 회귀분석 돌리기 
#8) 회귀분석 결과 summary 출력
#9) step 함수로 최적화 결과 출력 
#10) 공선성 검사
#11) 예측력 확인
#- ROC 곡선 출력 - AUC 값 출력


#survived가 생존 여부이며 1이 생존 , 0은 사망
install.packages("dplyr")
install.packages("ROCR")
library(dplyr)
library(car)
library(ROCR)
library(BaylorEdPsych)


data <- read.csv("/Users/lostcatbox/univ_lecture/data_mining/Lec12_실습자료/Lec12_Logistic1.csv", header=T)
str(data)
head(data)
summary(data) #NA많음..

sapply(data, function(y) sum(is.na(y))) #함수기능 적용, 어떤 함수 알려줘야함

data <- select(data, -Name, -Ticket, -Cabin, -PassengerId) #변수, 열 제거#PassengerId는 필요하지않은값이므로.
head(data)
data <- mutate(data, Age=ifelse(is.na(Age), mean(Age, na.rm=T), Age)) #값 변경#평균은NA가 있다면 NA없애야햄, 맨  마지막은 false면 기존 Age값 가져닿씀
head(data)
data <-  filter(data, !is.na(Survived)) #행 제거, #NA값은 Survived, Fare, Embarked존재함, !=not, filter는 뒤에 조건이 참일때 그 행 삭제
sapply(data, function(y) sum(is.na(y))) #아직 Embarked 남아있음
data <-  filter(data, !is.na(Embarked)) #행 제거, #NA값은
sapply(data, function(y) sum(is.na(y)))

#전처리 완료,Train set, Test set 나누기
sep <-  sample(2, nrow(data), prob=c(0.8, 0.2), replace=T)
train <- data[sep==1,]
test <- data[sep==2,]

#  train set을 이용해  로지스틱 회귀분석
logit <- glm(Survived~., data=train , family = binomial)
logit1 <- step(logit, trace=F)
summary(logit1)
# log(ods) =  -3.052 + 1.645*stage1 + 1.912*xray1 + 1.638*acid1

vif(logit1)
logit.full.pred <- predict(logit1, newdata=test, type="response") 
logit.full.pr <- prediction(logit.full.pred, test$Survived) #예측력 보는 함수, 역할은 위의 y_hat값(logit.full.pred)과 실제데이터의 y값을 비교
logit.full.prf <- performance(logit.full.pr, measure = "tpr", x.measure = "fpr")  #y축이 trp(맞는것 맞다고함) x축이 fpr(틀린것 맞다고함)임. 
plot(logit.full.prf) #ROC 곡선 그리기ROC커브 볼수있음, 
logit.full.auc <- performance(logit.full.pr, measure = "auc")  #performance함수의 auc계산함
logit.full.auc <- logit.full.auc@y.values[[1]] #AUC면적을 나타내는 것은 첫번째 리스트에 있는 값에 존재
logit.full.auc #ROC 곡선 아래 면적, 0.8485정도로 좋은편

exp(coef(logit1))
PseudoR2(logit1)
#odds_hat = 188.971 + 0.314*Pclass + 0.059*Sexmale + 0.9618*Age + 0.677*SibSp
#                          (p<0.001)  (p<0.001)          (p<0.001)       (p<0.001)
#해석하면 Pcalss가 한단위 증가할때마다 생존확률*0.314배 되므로 죽을 확률이 높아짐
#AIC = 628.81
#McFadden.Pseudo R^2= 0.339
#Adj.McFadden.Pseudo R^2=0.326

#실습 예제2
#1) 데이터 불러오고 확인하기
#2) 변수 별 NA 개수 확인하기
#3) NA가 가장 많은 변수를 선택하여 filter 함수를 이용하여 결측 값 제거하기. 
#4) Train set과 Test set을 8:2로 나누기
#5) Train set 이용하여 로지스틱 회귀분석 돌리기
#6) step 함수로 최종 로지스틱 회귀분석 결과 출력
#7) 공선성 검사
#8) 예측력 확인
#- ROC 곡선 출력 - AUC 값 출력
```

# 신경망

```R


# 인공지능 개요
# 입력 값으로부터 결과 값을 내는 함수를 만들어 내는 것
#input x >> function f>> output y  (이떄 function에 선형, 비선형결합한 함수로 만들어냄)
#하지만 고도화 하기 힘듬
# 따라서 신경망을 찾음
#  (그림2)
#weight
#네모: 1
#세뫼 -1

# input data
# (3,2)
# (1,4)
# (5,5)
# (8,3)

#label
#1,-3, 0,5

#weight값을 찾아내는것 >> 기게학습이 하는일

#기계학습의 종류
#지도학습(Supervised learning)
#- input과 labels를 이용한 학습
#- 분류(classification), 회귀(regression)
#비지도학습(Unsupervised learning)
#- input만을 이용한 학습
#- 군집화(clustering), 압축(compression)
#강화학습(Reinforcement learning)
#- label 대신 reward가 주어짐
#- action selection, policy learning
#- https://www.youtube.com/watch?v=Q70ulPJW3Gk&feature=youtu.be

#신경망
#기본단위: 신경세포(Neuron)
#- 개별적으로는 단순한 작동원리
# cell-body 일정수준 이상일 때 반응>>축삭돌기, 가지돌기 는 연접>>다른신경세포가 알게함. 전기 화학적 신호)
# 신경망, 기본단위 신경세포>> 어느정도 역치가 지나야 전달 , 차단.
# 개별적으로는 단순한 형태, 전체적으로는 정교한 판단 - 반응
#Neuron 수 , 층(Layer) , 적절한 연결(connections) >>>모이면 창발(Emergence)
#왼쪽, 오른쪽 신경이 있다면 왼쪽에 햇빛이면 왼쪽에 있는 신경 더 쌔게 반응, 근육방향조절가능(신경망이 근육과 크로스면, 오른쪽근육움직임, 직선연결이면 왼쪽근육움직임)
# 신경망에서는 신경 갯수도 중요하지만 연결이 매우중요함> 반응이 다르게 나옴



```





![s](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfh3oufpxgj30h00d0jvm.jpg)



![스크린샷 2020-06-05 오전 12.39.52](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfh3ozjkx2j30ke0byq3d.jpg)



![스크린샷 2020-06-05 오전 1.04.35](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfh3p72yn0j31cw0mgwfu.jpg)



![스크린샷 2020-06-05 오전 1.08.34](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfh3pbho9jj31tg0q2qgb.jpg)



![스크린샷 2020-06-05 오전 1.11.30](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfh3pembrfj31mk0ta13f.jpg)



![스크린샷 2020-06-05 오전 1.13.08](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfh3phf12fj31s60qmwr9.jpg)



![스크린샷 2020-06-05 오전 1.14.11](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfh3pk7jgxj31o40lygx6.jpg)



![스크린샷 2020-06-05 오전 1.14.56](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfh3ppdzc4j31s40ry7ex.jpg)



![스크린샷 2020-06-05 오전 1.15.47](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfh3pu47s5j316l0u0wp6.jpg)



![스크린샷 2020-06-05 오전 1.20.47](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfh3q23ew3j31480m8tdd.jpg)





![스크린샷 2020-06-05 오전 1.28.20](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfh3q5a8r7j30r40aiwfm.jpg)





## 13주차

## 신경망의 특성

- 단순 기본단위들이 자발적으로 복잡한 전체를 형성: “창발”
- 유연한 반응 시스템
- “최적해” 보다는 “적정해”를 추구하는 시스템(최적x 적정한 해답내놓음!)

인공 신경망(Artificial neural network)은 생물학적 신경망의 중추신경계인 인간의 뇌가 문제를 처리하는 방식을 모방한 모형으로 기계학습과 인지과학에서 많이 활용

- 신경망의 특성
   \- 신경망의 각 노드에 미분 가능한 비선형 활성함수를 적용
   \- 신경망은 하나 이상의 은닉층(Hidden layer)을 포함.
   \- 신경망은 높은 수준의 연결성을 나타내며 이때 연결강도는 신경망의 가중치에 의해 결정

심층 신경망(Deep neural network)의 종류

- 심층 신경망은 입력층(Input layer)과 출력층(Output layer) 사이에 여러 개의 은닉층(Hidden layer)으로 이루어진 신경망
- 심층 신경망은 1개의 은닉층을 가진 천층 신경망(Shallow neural network)과 마찬가지로, 복잡한 비선형 관계를 모형화할 수 있음

![스크린샷 2020-06-12 오후 3.13.06](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfph8orqaoj31fu0i6wzf.jpg)

> 입력노드는 입력 변수의 수와 같고 출력층의 출력노드의 수는 분류모형에서는 양성, 음성 구분시 출력노드수 2개, 등 출력갯수에와같음

### 신경망과 역전파(backpropagation) >>분류와예측에 사용

신경망 훈련은 역전파 알고리즘을 가장 많이 사용, 훈련은 다음과 같이 두 단계로 진행. 전방향 단계에서는 신경망의 가중치가 고정, 입력신호는 출력에 도달할 때까지 층별로 전파. 역방향 단계에서는 신경망 출력을 목표출력과 비교하여 오차신호를 생성.
 오차신호는 역방향으로 층별로 전파. 이 단계에서는 신경망의 가중치가 연속적으로 조정.

- 입력 * 계수 = 출력 (추정값)
- 정답 - 추정값 = 오차
- 오차 * 계수 별 오차 기여도 = 보정값 >>>(계수변경후 업데이트)

> 신경망의 여러계수들 합쳐서 >> 모델이라 부름

### 신경망 작동 원리

- 은닉층 2개와 출력층 1개를 가진 신경망의 구조. 일반적으로 신경망은 완전히 연결.
- 모든 층의 노드가 이전 층의 모든 노드에 연결되어 있음을 의미함.
- 신호의 흐름은 신경망을 통해 왼쪽에서 오른쪽으로 그리고 층별로 모든 방향으로 진행.
- 신경망은 다중입력 및 다중출력문제를 비교적 쉽게 해결할 수 있는 장점이 있음.

![스크린샷 2020-06-12 오후 3.29.31](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfphpqjmj1j30ui0jkn69.jpg)

- 신경망의 두 가지 기본신호인 함수신호와 오차신호의 흐름을 보여줌.

- 함수신호: 신경망의 입력노드로 들어와 신경망을 통해 노드별로 전방향으로 전파되어 신경망의 출력노드에서 출력신호로

  나오는 신호

- 오차신호: 신경망의 출력노드에서 시작하여 신경망을 통해 층별로 역방향으로 전파되어 신경망의 모든 노드에 의한

  - 오차신호 계산에서 오차함수가 포함되는 신호

- 출력노드는 신경망의 출력층을 구성하며, 은닉노드는 신경망의 은닉층을 구성.

![스크린샷 2020-06-12 오후 3.35.21](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfphvsjb7mj30l40deq6i.jpg)

### 인공 신경망 구성 요소

weights = 가중치

각 층의 출력이 다음 층에 입력이됨

모든 계수는 학습과정에서 조금씩 변하고,

각 노드가 어떤 입력을 중요하게 여기는 지 반영하고

신경망의 학습은 이 계수를 업데이트하는 과정임





![스크린샷 2020-06-12 오후 3.36.06](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfphwkjf9rj31lm0qo14m.jpg)



activation function(활성함수)의 종류는 

- 계단함수, 
- 시그모이드 함수,
-  쌍곡탄젠트 함수, 
- ReLU 함수(x가 0보다작으면 0출력, 나머지는 x출력)

![스크린샷 2020-06-12 오후 3.42.34](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfpi3bvjpnj31j60o648v.jpg)

weight노드지나서 각각의 weight*input를 모두 합해서 b(편향벡터)와 더하고, 함수의 결과값이 특정값이상이면 1를 출력, 아니면 0을 출력



### XOR 문제



![스크린샷 2020-06-12 오후 9.52.06](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfpsrt6wogj31m20u00w4.jpg)

그래프에 한 직선을 그어서 +,-의 영역을 나눌수없다.

__신경망으로 해결__

![995B3296-EA95-4E02-9E78-00D25260C27D_1_105_c](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfpt462h7sj30xu0hxtcc.jpg)

위 그림의 계산이 원리(행열계산은 ㄱ자 순서로 계산하기)

![08BF26B5-BDEA-4C72-96BD-3A63AA50260F_1_105_c](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfptboe4cej310g0gnjuo.jpg)

역전파 알고리즘

![A3D06EE9-C292-4EFC-A75C-34C0C0E815B9_1_105_c](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfpurvozgxj30w60iv78e.jpg)

시그모이드 함수

![083EFDB4-4591-449E-920A-EAB07B4C89E5_1_105_c](https://tva1.sinaimg.cn/large/007S8ZIlgy1gfpus4tu5dj30xh0i40up.jpg)

### 과대적합

- 과대적합 문제: 모형이 훈련 데이터에 너무 잘 맞지만 일반성이 떨어짐, 신경망에서 빈번히 발생하는 문제
  - train 데이터에 너무 맞추어져 있어서 test 데이터나 다른 데이터에는 높은 성능을 보여주지 못함
- 해결 방법:
  - 훈련데이터를 더 많이 모음
  - 모형을 적합하는 과정에서 검증오차가 증가하기 시작하면 반복 중지
  - 가중치 감소 또는 제거(자잘한 계수들 제거)



## 신경망 실행

```R
# nnet 패키지 설치 
install.packages(“nnet”) 
library(nnet)


nnet(Y~., data = data, size = 2, decay = 0.02, maxit = 100, trace = F)
# Y: 종속변수
# data: 사용할 데이터
# size: 은닉노드 갯수(nnet 은 천층신명망이므로 은닉층 하나있다고 이미 가정함)
# decay: 가중치 감소 (기본값: 0) #가중치가 0.02보다 작으면 그 노드제거 #보통 5e-04로함
# maxit: 역전파 알고리즘의 반복 횟수 (기본값: 100)


```

- summary(nn): 신경망 모형 결과
   \- 연결선의 방향과 가중치를 알려줌
   \- 초기값을 지정하지 않으면 nnet() 함수가 실행될 때마다 결과가 달라짐
- 적합결과 시각화 방법

```R
install.packages("clusterGeneration"); 
library(clusterGeneration)
library(scales)
install.packages("reshape"); library(reshape)
library(devtools) 
source_url("https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c
 34f1a4684a5/nnet_plot_update.r") 
plot(nn)
```

- 적합/예측

```R
 p<- predict(nn, newdata=test, type = “class”)
```

- 정오분류표: 

```R
table(test$Y, p)
```

- 은닉 노드 수에 따른 오분류율

  은닉노드수를 정해놨지만, 늘리거나 줄이면 정확도 올라갈수있음. 확인방법

  만약 모두 오류율이 비슷하면, 노드수 줄이는것이 과대적합피할수있다.

```R
test.error <- function(hiddensize){ #함수선언문, input데이터를 hiddensize명으로가져옴
  nnn <- nnet(Y~., data=train, size=hiddensize, decay=0.02, maxit=100, trace=F) 
  p<- predict(nnn, newdata=test, type = "class") #test데이터로 검증도필요
  error<-mean(test$Y != p) #실제값과 추정값이 다른 것에 대한 비율 #!=이므로 같으면 false반환됨,R에서는 False=0 ,True=1임, 모든값을 다 더하고 전체n개로 나누는 평균 구하는 mean을썻다.(오차율나옴)
  c(hiddensize,error) 
}
out<-t(sapply(2:5,FUN=test.error)) #test.error라는 함수를 이용하여 은닉 노드수(2~5개)에 따른 오분류율 계산 #sapply는 2:5의 숫자를 각각 함수를 돌림 #t()는 가로데이터를 세로데이터로바꿈
plot(out, type="b", xlab="the number of hidden units", ylab="test error") #오분류율 그래프 출력 #세로데이터가 필요함
```



### 신경망 실습

- iris 데이터에는 아이리스 꽃에 대한 자료이며 다음과 같은 변수를 포함한다. 

  - Sepal.Length: 꽃받침 너비

  - Petal.Length: 꽃잎 길이
  - Petal.Width: 꽃잎 너비
  - Species: 아이리스 꽃 종류

- 아이리스 꽃 종류를 분류하는 신경망 모형을 train 데이터로 구축하고 결과를 출력하시오.

  - 자료를 5:5로 train과 test 데이터로 나누기 - 은닉노드가 2개
  - 역전파 알고리즘의 반복 횟수는 200
  - 가중치 감소는 5e-04

```R
install.packages("clusterGeneration")
install.packages("reshare")
install.packages("reshape")
install.packages("devtools")
install.packages("scales")

library(nnet)
library(clusterGeneration)
library(reshape)
library(scales)
library(devtools)

data <- iris
str(data)

sep <- sample(2, nrow(data), prob=c(0.5,0.5), replace=T)
train <- data[sep==1,]
test <- data[sep==2,]
nn <- nnet(Species~., data =data, size=2, maxit=200, decay=5e-04, trace=F)
summary(nn) #각각이 가중치들임

source_url("https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r") 
plot(nn)
```

- train 데이터를 이용하여 만든 모형을 시각화 하시오.
- train 데이터를 이용하여 만든 모형을 test 데이터에 적합하고 정오분류표를 출력하시오.
- 은닉노드 수가 2~10개인 경우에 대하여 오분류율을 비교할 수 있도록 그래프를 출력하시오.
  - X축: 은닉노드 수
  - Y축: 오분류율
  - 그래프 type: b (점선 그래프)
- 참고: plot()함수에서 type 인수는 그래프 형태를 바꿀 수 있는 인수이다. 
  - p: 점(points) – 기본 값
  - l: 선(lines)
  - b: 점과 선(both points and lines)

```R
#모형 시각화
source_url("https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r") 
plot(nn)

#test데이터이용해서 만든 모형을 test
p <- predict(nn, newdata = test, type="class")
table(test$Species,p) #완벽하게 맞았다!!
#은닉노드 수가 2~10개인 경우

test.error <- function(hiddensize){ #함수선언문, input데이터를 hiddensize명으로가져옴
  nnn <- nnet(Species~., data=train, size=hiddensize, decay=5e-04, maxit=200, trace=F) 
  p<- predict(nnn, newdata=test, type = "class")
  error<-mean(test$Species != p) #실제값과 추정값이 다른 것에 대한 비율'
  c(hiddensize,error)
}
out<-t(sapply(2:10,FUN=test.error)) #test.error라는 함수를 이용하여 은닉 노드수(2~5개)에 따른 오분류율 계산 #sapply는 2:5의 숫자를 각각 함수를 돌림 #t()는 가로데이터를 세로데이터로바꿈
plot(out, type="b", xlab="the number of hidden units", ylab="test error") #오분류율 그래프 출력 #세로데이터가 필요함

```





```R

#정교한 판단 - 반응: XOR 문제
# 신경세포로 표현하자면 사냥 성공확률P(S)와 보상의 크기 (Reward)가 축삭말단이 Hunt(사냥 실행여부)로 이어진 (그림3)
# 사냥 성공확률이 크면 1과 가까워짐, 보상의 크기 크면1과 가까워짐 , 사냥 실행여부 1과 가까워짐.
# (그림4) 성공가능성이 낮은데 성공시 보상 높으면 함(실행여부 1), 완전 반대 경우도 (실행여부 1), 성공확률높고 보상확률도 높으면 (실행여부 0)>> 너무 이상적인 경우면 이건 fake로 알아차림, 조개가 페이크칠 확률이있으므
# (그림5) 즉 둘중 하나만 1일때 사냥 실행해야되므로 Exclusive OR 문제라고 부름
# (그림 6) 2개의 신경망 세포에 사이에 하나더 추가하면 가능
#(그림 7) 적절한 연결이 매우 중요함
# (그림 8) 신경 숫자 layer까지 많아지면 정교한 판단가능, 새로운 경험을 하면서 신경망은서로의 연결을 추가, 제거, 강화, 약화 시킴

#학습이란?
# - 심리학에서 학습이란 과거 경험 때문에 일어나는 __행동__ 상의 비교적 영속적인 변화
# - 학습은 비교적 오래 __지속__되는 변화가 있음을 의미
# - 학습은 __경험__에 의해 생겨나는 변화이며 따라서 육체적 성숙, 약물, 질병 등으로 인한 행동 변화와는 구분되어야 함

#사람은 어떻게 학습할까?
#- 연합(association): 주위 환경에서 일어나는 사건들 간의 연관성을 배우는 것
#- 고전적 조건형성(classical conditioning): 두 자극이나 사건 사이의 관련성을 배우는 것 #번개치면 소리나중엠
#- 도구적 조건형성(instrumental or operant conditioning): 반응과 그 결과 사이의 인과관계 학습 # 성적이 향상될려면 공부 열심히

#(그림9) layer!!, learning 
#기계학습(Machine learning)의 한 방법론
#- 기계학습은 인공지능의 한 분야
#- 컴퓨터를 인간처럼 학습시켜 스스로 규칙을 형성할 수 있도록 하는 알고리즘과 기술을 개발하는 분야 - 예) 분류문제: 수신한 e-메일의 스팸 여부, 입력된 고양이와 개의 사진 구분
#회귀분석문제: 주식 가격 예측, 기온 예측, 강수량 예측
#- 기계학습의 대표적인 방법론: 신경망, 의사결정나무, 베이지안 망, 서포트 벡터 기계, 강화학습
# 세계는 지금 딥러닝 전쟁중!
#- 네이버의 음성 검색
#- 구글의 딥러닝 전문가 기업 '딥마인드' 인수
#- 트위터의 딥러닝 기반 이미지 검색 스타트업 기업 인수 - 중국 바이두의 기계학습 유명학자 초빙
#- 페이스북의 인공지능 연구책임자 초빙

#신경망 학습
#1. 데이터의 특성 
# 랜덤, 조직화(어떤 패턴을 가짐)
#  신경망에서 테이터 특성을 추출하는 방법은 "함께 반응하는 신경세포들을 함께 연결시킨다"
# 개구리는 밝은 빛 배경에서 한부분만 어두우면 반응하는 Off-cell이 혀 근육에 반응을 줌.
# off-cell이 여러 개에 알파벳을 노출시키면 (그림 10) E를 노출하면 맨위에 3개 세포는 반응함, F도 반응함, T에도 반응함, 따라서 함께 반응하는애들을 상위에 한 뉴런에 연결됨.
# 따라서 하위(점)가 모여서 상위인 선을 뜩하는 한차원 높은 상위 신경세포가 만들어짐
# 학습을 통해서만 하위 묶어서 상위를 만들어낼수있음
# E가 중간에 구멍이 뚫여있어도 상위 신경세포가 조금 약한 반응을 함!,데이터가 완벽하지 않아도, 가능
#-Fuzzy logic: 데이터가 완벽하지 않아도 비슷한 판단 가능
#- Fault Tolerant: 데이터에 약간의 하자가 있어도 큰 지장 없이 움직임
#- Generalization: 데이터의 모양이 완전하지 않더라도 판단을 내리는데 큰 지장 없음
# 점에서 한차원 높은 층 (layer)가 높아질수록 점점더 복잡한 패턴을 인식할수있음, 선>눈,귀>사람얼굴
# 사전적 지시 없었음.
#함께 반응하는 신경세포들을함께 연결하므로 가능함.
```

