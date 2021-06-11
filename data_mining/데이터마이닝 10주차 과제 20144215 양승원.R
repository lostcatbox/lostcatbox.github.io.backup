setwd("/Users/lostcatbox/univ_lecture/data_mining/Lec10_실습자료/")
data = read.csv("Lec10_regression3.csv", header = T)
str(data)
plot(data$crim, data$medv) #2차함수
plot(data$nox, data$medv)
plot(data$rm, data$medv)
plot(data$age, data$medv) #2차 함수
plot(data$dis, data$medv) #2차 함수 #애매함

#질적 변수없이 양적 변수로만 이루어진 데이터이므로 2차함수를 이용하여 회귀분석
##dis변수 2차 변수로 사용
reg1 <- lm(data$medv~.+I(data$crim^2)+I(data$age^2)+I(data$dis^2), data = data)
reg2 <- step(reg1, trace=F)
summary(reg2)
#medv_hat = 5.651 -0.435crim -23.07nox  +7.617rm   +0.08age  -4.332dis  +0.003crim^2  +0.267dis^2
#                    (p<0.001)   (p<0.001)  (p<0.001)   (p<0.001)  (p<0.001)      (p=0.005)
# R^2=0.6115
# Adj.R^2 = 0.606 


#dis변수 2차 변수로 x
reg3 <- lm(data$medv~.+I(data$crim^2)+I(data$age^2), data = data)
reg4 <- step(reg3, trace=F)
summary(reg4)
#Adj.R^2 0.5911이므로 위에 모형보다 낮으므로 위에 dis변수는 2차 변수로 적용해야더 유효한 모델
