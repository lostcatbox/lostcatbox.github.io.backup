
#다중선형회귀분석 실습.

data = read.csv("/Users/lostcatbox/uinv_lecture/data_mining/Lec5_실습자료/Lec5_regression2.csv", header = T)
str(data)
data <- na.omit(data)
#산점도 그리기. (판매실적를 설명해야하므로y가 sales)
par(mfrow=c(2,2)) #파라미터 바꾸는데 화면 행열로 지정
plot(data$men, data$sales)
plot(data$size, data$sales)
plot(data$promo, data$sales)
plot(data$pop, data$sales)

reg <- lm(sales~., data=data)
summary(reg)
#men, size는 p값이 너무너무 큼., 관계가 없다고 생각됨, 회기모형을 깍을가능성이있음
#변수 소거법을 사용하자
reg1 <- step(reg, trace=F) #backward가 디폴트, trace는 콘솔창에 log찍을꺼냐? 
summary(reg1)
#adjusted R올라감
#sales_hat = 4.641e+02 +1.364e+00 *promo  + 7.826e-02*pop
#                      (p<0.0003)     (p<0.001)     
#R^2 = 0.9507 R^2 = 0.9469


#이제 잔차를 확인해야함 (독립성, 등분산성, 정규성)
#유의미한 변수만 선택해서 삼전도 그리기
par(mfrow=c(1,2))
plot(data$promo, residuals(reg1), xlab="promo", ylab='residuals')
abline(h=0, col='red')
plot(data$pop, residuals(reg1), xlab="pop", ylab='residuals')
abline(h=0, col='red')
#분산되어있고, 증가, 감소 패턴이없다. (독립성, 등분산성 증명완료)

par(mfrow=c(1,1))
qqnorm(residuals(reg1))
qqline(residuals(reg1), col='red')
#부분적으로 벗어나는 모습이 보이므로 또 shapiro하기

shapiro.test(residuals(reg1))
#귀무가설을 따라야하므로 p값이 0.05보다 높은게좋음
#따라서 잔차의 정규분포는 정규성이 있다

