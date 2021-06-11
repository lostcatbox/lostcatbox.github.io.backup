#1-1 
#F


#1-2 
#T


#1-3
# T


#1-4
#F

#1-5
#T


##2-1
#2.110874
0.04950/0.02345



##2-2
#-2.99091
-1.973*1.51592

##2-3
#0.6056
1-(1-0.6199)*(110)/(106)

##2-4
#43.192
x <- (14780+39969+19050+1701)/4 #MSR
x/437 #MSE로 나눔

##2-5
#46322
437*106



##3
library(car)

rd <- read.csv("/Users/lostcatbox/uinv_lecture/data_mining/babies2.csv", header=T)
str(rd)
print(rd$mrace) 
print(rd$drace) #둘다 10이 있는것을 볼수있음 따라서 더미변수 기준값을 10으로 잡으면 편함

dummy_add_data <- transform(rd, mom_white = ifelse(mrace<=5,1,0),mom_mexican = ifelse(mrace==6,1,0), mom_black = ifelse(mrace==7,1,0), 
                            mom_asian = ifelse(mrace==8,1,0), mom_mixed=ifelse(mrace==9,1,0),
                            fa_white = ifelse(drace<=5,1,0),fa_mexican = ifelse(drace==6,1,0),fa_black = ifelse(drace==7,1,0), 
                            fa_asian = ifelse(drace==8,1,0), fa_mixed=ifelse(drace==9,1,0)) #일단 더미변수에 해당하는 변수들 생성

par(mfrow=c(1,1))
plot(x=rd$day,y=rd$baby)
plot(x=rd$past,y=rd$baby)
plot(x=rd$mrace,y=rd$baby)
plot(x=rd$mage,y=rd$baby)
plot(x=rd$mht,y=rd$baby)
plot(x=rd$mwt,y=rd$baby)
plot(x=rd$dage,y=rd$baby)
plot(x=rd$drace,y=rd$baby)
plot(x=rd$dht,y=rd$baby)
plot(x=rd$dwt,y=rd$baby)
plot(x=rd$income,y=rd$baby)
plot(x=rd$stop,y=rd$baby)
plot(x=rd$number,y=rd$baby)
plot(x=rd$gender,y=rd$baby)


#-------------------------------------
#분석에 필요한 값 추출
rd_dummy_fixed <- dummy_add_data[,-c(4,8)]  #subset은 부분집합 이라는 뜻
#따라서 데이터 프레임 만들었음 >회귀분석 돌리기
reg_rd <- lm(bwt~., data=rd_dummy_fixed)#상관없는 인자빼서 ~.으로 가능(종속변수선택, 나머지 독립변수)
reg_rd1 <- step(reg_rd,trace=F)
summary(reg_rd1)

#----------------------------------------





##3-1
#bwt_hat = -6.372 + 0.028*day  + 0.058*past + 0.087*mht + 0.004*dwt + 0.062*stop -0.125*number +  0.194*genderM -0.632*mom_white -0.888*mom_black -0.712*mom_mixed  + 0.934*fa_white + 0.897*fa_mexican + 0.848*fa_black + 1.135*fa_mixed
#           (p<0.001) (p<0.001)   (p=0.009)   (p<0.001)    (p=0.026)   (p=0.026)    (p<0.001)      (p=0.13)        (p=0.027)           (p=0.049)        (p=0.082)          (p=0.002)         (p=0.004)          (p=0.070)      (p=0.008)  
#R^2 = 0.2766
# Adj. R^2 = 0.2598
#0.1을 기준으로 본다면 genderM빼고는 모두 유의미함. 0.05를 기준으로는 genderM, fa_black, mom_mixed이 종속변수에 주는 영향 미미함


##3-2
#잔차의 정규성
par(mfrow=c(1,1))
qqnorm(residuals(reg_rd1))
qqline(residuals(reg_rd1), col="red", lty=2)
# 벗어난것 보이므로 shapiro
shapiro.test(residuals(reg_rd1))
# W = 0.9981, p-value = 0.7351 5%유의수준에서는 귀무가설이 기각되지 못하므로 정규성이 성립



##3-3
#어머니가 흑인 일때 -0.888만큼 덜 나가게 된다.



##3-4
#7.194
bwt_hat = -6.372 + 0.028*270  + 0.058*1 + 0.087*60 + 0.004*180 + 0.062*2 -0.125*1 -0.888*1 + 0.897*1
print(bwt_hat)


##3-5
#835.718
x <- anova(reg_rd1)
sum(x$'Sum Sq')


##3-6
#MSE = 1.004
x

