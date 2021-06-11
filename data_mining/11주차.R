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
