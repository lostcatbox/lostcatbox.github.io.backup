#룆스틱 회귀분석 과정
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

data <- read.csv("/Users/lostcatbox/univ_lecture/data_mining/Lec11_logistic1.csv")
str(data)
#모두 질적 변수임, Factor로 모두 변환.
for (i in c("r", "aged", "stage", "grade", "xray", "acid")) {
  data[,i]<- as.factor(data[,i])
}
sum(is.na(data)) #합계가 0이므로 NA없음
logit <- glm(r~.,family=binomial, data=data)
logit
logit1 <- step(logit, trace=F)
logit1 #aged, grade변수가 step함수로 제거됨
summary(logit1)
PseudoR2(logit1)   #설명력.. Adj.R과 의미하는바같음
#ln(odds)_hat = -3.0518 +1.645stage1 +1.911xray1 +1.638acid1
#                          (p=0.024)    (p=0.0139)  (p<0.0298)  
#AIC 57.18
#McFadden PseudoR2 = 0.3
#Adj.McFadden PseudoR2=0.158

#다중공선성 확인
vif(logit1) #문제없다

#p값들로 계수 유의한지 보기 
#임계치와 잔차이탈도 구하기 모형 적합성 따지기
qchisq(0.95, df=49) #df는 잔차의 자유도
#임계치 = 66.33865
#잔차이탈도 = 49.180
## 따라서 임계치가 더 높으므로 합당한 모형 

#결과 해석
#계수 해석시 로그 기준이므로, 로그제거하자
#회귀계수들은 log odds의 증가량이므로 exponential을 취하면 odds의 증분이 됨 exp(coef(mylogit))
exp(coef(logit1))
#r_hat = 0.0473 +5.183stage1 +6.764xray1 + 5.144acid1


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

wald.test(b=coef(logit1), Sigma=vcov(logit1), Terms=2:4)
# X2 = 12.9, df = 3, P(> X2) = 0.0048 이므로 귀무가설 증명됨. 각자 독립적