
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







