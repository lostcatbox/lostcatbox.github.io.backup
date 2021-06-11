library(car)

rd <- read.csv("/Users/lostcatbox/uinv_lecture/data_mining/Lec7_regression.csv", header=T)
str(rd)
#R에서는 일단 int로 모두 보고있고, gender만 factor로 입력되어있으므로, 범주형 자료들은 범주형으로 인식하게해줘야함.
#race, drace, gender 는 factor로 입력해야함
#그리고 추후 더미변수(연속형자료인것처럼)로 만들어줘야한다.
#drd <- data.frame(fac_race=factor(rd$race),fac_drace=factor(rd$drace),fac_gender=factor(rd$gender)) #일단 범주형인식후  mon변수로 가져옴
#str(drd)
#dummy_all <- model.matrix(~.-1,drd) #더미를 생성함, mon변수에서 -1를 한이유는 0으로만 이루어진 interupt을 없애고 출력하겠음. 0만 나오는건 출력안함

#아래는 엄마,아빠,성별 더미변수 만들기
##참고사항은 race, drace에 더미변수는 10이 보기에없는데 들어이쓰음로 그냥 10을 기준으로 두면 더미변수에서 제외할것은 없다.즉 5개씩모두들어가면됨.
dummy_add_data <- transform(rd, mom_white = ifelse(race<=5,1,0),mom_mexican = ifelse(race==6,1,0), mom_black = ifelse(race==7,1,0), 
                   mom_asian = ifelse(race==8,1,0), mom_mixed=ifelse(race==9,1,0),
                   fa_white = ifelse(drace<=5,1,0),fa_mexican = ifelse(drace==6,1,0),fa_black = ifelse(drace==7,1,0), 
                   fa_asian = ifelse(drace==8,1,0), fa_mixed=ifelse(drace==9,1,0)) #일단 더미변수에 해당하는 변수들 생성

#1 dummy 없이 회귀분석 돌려보기
par(mfrow=c(1,1))
plot(x=rd$gestation,y=rd$baby)
plot(x=rd$parity,y=rd$baby)
plot(x=rd$age,y=rd$baby)
plot(x=rd$ht,y=rd$baby)
plot(x=rd$wt,y=rd$baby)
plot(x=rd$dage,y=rd$baby)
plot(x=rd$dht,y=rd$baby)
plot(x=rd$dwt,y=rd$baby)
plot(x=rd$inc,y=rd$baby)
plot(x=rd$time,y=rd$baby)
plot(x=rd$number,y=rd$baby)

#2 mon dummy 추가하여 회귀분석 돌리기.


#기존에 있던 rd에 더미변수들 추가하기
#각 더미변수는 범주의 갯수 -1 해야되므로 10을 이미 기준으로 잡음,빼는것이 필요
#+ mom, fa는 이미 더미변수로 만들었기때문에 뺴도됨, 원본들은 데이터테이블에서 삭제 필요.

#두번째 방법(함수이용)
rd_dummy_fixed <- dummy_add_data[,-c(4,8)]  #subset은 부분집합 이라는 뜻

#따라서 데이터 프레임 만들었음 >회귀분석 돌리기
reg_rd <- lm(baby~., data=rd_dummy_fixed)#상관없는 인자빼서 ~.으로 가능(종속변수선택, 나머지 독립변수)
reg_rd1 <- step(reg_rd,trace=F)
summary(reg_rd1)

#baby_hat = -111.72381 + 0.465*gestation  + .883*parity + 1.319*ht + 0.073*dwt + 1.032*time -2.016*number + 3.936*genderM -5.498*mom_white + 11.514*fa_white + 13.257*fa_mexican + 10.987*fa_mixed
#                    (p<0.001)         (p=0.009)        (p<0.001)    (p=0.011)  (p=0.016)    (p<0.001)      (p=0.048)           (p<0.10)         (p=0.009)            (p=0.009)    (p=0.008)
#0.1을 기준으로 본다면 유의미함. 0.05를 기준으로는 fa_asian, baby_man이 종속변수에 주는 영향 미미함
#R^2 = 0.295
# Adj. R^2 = 0.2821 
#해석은 더미변수에서 어머니가 멕시칸인종일시 종속변수증가, 아버지가 흑인일시 종속변수 감소, 아버지가 아시안일시 종속변수 감소, 아기가 남자일경우 종속변수 증가
#28%정도 모든 x들이 종속변수를 설명함.

#잔차의 등분산성(유효한 연속형 변수에만 하면됨) 
par(mflow=c(2,1))
plot(rd_dummy_fixed$gestation, residuals(reg_rd1))
abline(h=0, col="red", lty=2)
plot(rd_dummy_fixed$parity, residuals(reg_rd1))
abline(h=0, col="red", lty=2)
plot(rd_dummy_fixed$ht, residuals(reg_rd1))
abline(h=0, col="red", lty=2)
plot(rd_dummy_fixed$time, residuals(reg_rd1))
abline(h=0, col="red", lty=2)
plot(rd_dummy_fixed$number, residuals(reg_rd1))
abline(h=0, col="red", lty=2)
plot(rd_dummy_fixed$mom_mexican, residuals(reg_rd1))
abline(h=0, col="red", lty=2)
plot(rd_dummy_fixed$fa_black, residuals(reg_rd1))
abline(h=0, col="red", lty=2)
##따로 증가 감소경향 보이지 않는다.

#잔차의 정규성
par(mfrow=c(1,1))
qqnorm(residuals(reg_rd1))
qqline(residuals(reg_rd1), col="red", lty=2)
# 벗어난것 보이므로 shapiro
shapiro.test(residuals(reg_rd1))
# W = 0.99582, p-value = 0.0992 5%유의수준에서는 귀무가설이 기각되지 못하므로 정규성이 성립하지만
#10%유의수준에서는 귀무가설이 기각된다, 정규성이 성립하지 못한다.

#독립변수들 간의 독립성
vif(reg_rd1)
#모든 변수가 10 미만이므로 독립적임

#따라서 3가지 성질이 모두 확립되므로 회귀모형이 유효함

#Q1
#1) 
baby_hat = -106.466 + 0.463*gestation  + 0.899*parity + 1.334*ht + 0.074*dwt + 1.067*time -2.038*number + 8.208*mom_mexican -6.451*fa_black + 3.760*baby_man # (fa_asian은 p값이 5퍼센트 유의성 초과됨으로 제외)
#2) 
#잔차의 정규성
par(mfrow=c(1,1))
qqnorm(residuals(reg_rd1))
qqline(residuals(reg_rd1), col="red", lty=2)
# 벗어난것 보이므로 shapiro
shapiro.test(residuals(reg_rd1))
# W = 0.99582, p-value = 0.0992 5%유의수준에서는 귀무가설이 기각되지 못하므로 정규성이 성립하지만
#10%유의수준에서는 귀무가설이 기각된다, 정규성이 성립하지 못한다.

#3) 
#독립변수들 간의 독립성
vif(reg_rd1)
#모든 변수가 10 미만이므로 독립적임
#4)
#기준을 아버지가 백인종으로 잡아놔서 현재 모든 나머지 더미변수의 계수가 -임을 봐서
# 백인종 아버지가 가장 신생아의 무게가 크고, 그 무게는 흑인 아버지보다 단위당 6.451 더 높다.
#5 SSR구하기
anova(reg_rd1)
ano<- anova(reg_rd1)
sum(ano$'Sum Sq'[1:11])

#답  61245.28
#6) MSE 구하기 (잔차의 분산 추정량)
#답 242


#Q2
baby_hat = -106.466 + 0.463*280  + 0.899*2 + 1.334*65 + 0.074*170 + 1.067*4 -2.038*0 + 8.208*0 -6.451*0 + 3.760*0#(fa_asian은 p값이 5퍼센트 유의성 초과됨으로 제외)
print(baby_hat)
#답:128.53


