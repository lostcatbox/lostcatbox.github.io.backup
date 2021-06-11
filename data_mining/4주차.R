# 4주차 데이터 마이닝

a <- 5:1
b <- a^2
plot(x=a,y=b,xlim=c(0,5),ylim=c(0,30),main="Example")

#실습
area <- c(1812, 1914,1842,1812, 1838, 2028, 1732)
price <- c(90000,104400, 93300, 91000, 101900, 108500, 97900)
plot(area, price, ylim=c(60000,110000), main="Home market value")

#실습 2
rd <- read.csv("/Users/lostcatbox/uinv_lecture/data_mining/Lec4_실습자료/Lec4_regression.csv", header=T)
reg <- lm(y ~ x, data=rd)  #선형회귀분석식 linear model y는 종속변수이름, x는 돌립변수이름
summary(reg)
anova(reg)
#그래프부터 실습하기
plot(rd$x, rd$y)
abline(reg$coefficients)    # a b 절편을 가진 그래프를 그리는 함수 #베타0, 1 값은 계수이므로 coefficients
abline(reg$coefficients, col="red")    # abline에서 col인수로 그래프 색입히기
#회귀분석 실습
home <- read.csv("/Users/lostcatbox/uinv_lecture/data_mining/Lec4_실습자료/Lec4_regression2.csv", header=T)
reg <- lm(Price~Area, data=home)
summary(reg)
# 즉 price_hat= -47159.99 + 77.59*Area
reg$coefficients  #1번쨰가 베타0, 2번쨰가 베타1 값
b0 <- reg$coefficients[1]
b1 <- reg$coefficients[2]
b0+b1*2500
#2500 Area에  가ㅏ격을 예측.






