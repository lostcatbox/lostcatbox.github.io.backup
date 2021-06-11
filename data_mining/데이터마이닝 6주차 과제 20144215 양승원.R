install.packages("car")
library(car)

rd <- read.csv("/Users/lostcatbox/uinv_lecture/data_mining/Lec6_dummy.csv", header=T)
str(rd)
#month변수는 우리가 볼때는 범주형 변수지만 R에서는 일단 연속형으로보고있다
#즉, 더미 변수로 변환해줘야함
drd <- data.frame(mon=factor(rd$Month)) #일단 범주형인식후  mon변수로 가져옴
str(drd)
dummy_month <- model.matrix(~mon-1,drd) #더미를 생성함, mon변수에서 -1를 한이유는 1으로만 이루어진 interupt을 없애고 출력하겠음. 0만 나오는건 출력안함

#아래는 봄여름가을겨울 계절 변수 만들기
season <- transform(rd, spring = ifelse(Month>=3&Month<6,1,0), summer = ifelse(Month>=6&Month<9,1,0), 
                    fall = ifelse(Month>=9&Month<12,1,0), winter=ifelse(Month==12|Month<=2,1,0)) #일단 계절에 해당하는 변수 4개 생성

#1 dummy 없이 회귀분석 돌려보기
par(mfrow=c(2,2))
plot(x=rd$temp,y=rd$beer)
plot(x=rd$pay,y=rd$beer)
plot(x=rd$unemp,y=rd$beer)
plot(x=rd$index,y=rd$beer)

# 범위 범주에서 기준뺴기
rd_season <- subset(season,select = c(-Month,-spring))  #subset은 부분집합 이라는 뜻
reg_season <- lm(beer~., data=rd_season)
reg_season1 <- step(reg_season)
summary(reg_season1)
#결과에서 temp, pay,unemp, winter만 분석됨. 
# beer_hat = 13.959 + 0.206*temp + 0.821*pay - 0.714*umenp + 2.13*winter
#                      (p<0.001)  (p<0.001)     (p<0.001)      (p=0.006)  #따라서 모두 종속변수에 영향주는 변수임
#R^2 = 0.743
#Adj. R^2 = 0.719 다중회기에서 꼭!!적기 #x변수들이 y변수들이 설명하는데 71%정도 설명가능함

#다음 잔차의 등분산성, 정규성, 독립성 봐야함
#잔차의 등분산성(x변수각각 잔차와 비교함)
#다들 퍼져있고 갈수록 증가 감소안보임
par(mfrow=c(3,1))

plot(rd$temp, residuals(reg_season1))
abline(h=0,col='red',lty=2)
plot(rd$pay, residuals(reg_season1))
abline(h=0,col='red',lty=2)
plot(rd$unemp, residuals(reg_season1))
abline(h=0,col='red',lty=2)

#잔차의 정규성
par(mfrow=c(2,1))
qqnorm(residuals(reg_season1))
qqline(residuals(reg_season1), col="red", lty=2)#기준선
#양끝쪽이 기준선에서 벋어나는것을 보임
shapiro.test(residuals(reg_season1))
#w=0.94946, p=0.03805 #잔차가 정규성을 뜰라면 기무가설이 증명되어야 좋은거임
#p<0.05 이므로, 정규성 성립안됨. 즉 , 유효하지 않은 회귀분석모형

# x변수들간의 독립성
#다중공선성이란, x변수(입력변수)들간에 상관관계가 존재해버리는것 (데이터 분석시 부정적인 영향을 미치는 현상, 분산이 엄청 커져버림, 회기계수를 믿을수없게됨)
vif(reg_season1) #최종 회기모형넣어줘야함
vif(reg_season1) >10 #True, False값만 보기
#모든 변수가 10을 넘지 않으므로 독립성 증명됨.

