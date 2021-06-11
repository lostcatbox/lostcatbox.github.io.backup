family <- read.table("http://www.randomservices.org/random/data/Galton.txt", header=T)
str(family)  #지금 데이터 테이블에 있는 각 변수들의 데이터 타입을 알려줌
#Factor타입은 명목형 변수 (각각의 순서없는 그룹형으로 나누는 데이터 타입)
#만약 Gender같은 것이 chr로 데이터타입이되어있었다면 이것을 factor로 변환해줘야함
newfamily<- subset(family, Gender=='M') #subset(데이터프레인, 조건): 데이터프레임에서 조건에 맞는 부분집합을 추출하는 함수  
new_family <- newfamily[c("Father","Height")]

#삼전도 그리기
plot(new_family$Father,new_family$Height, xlab="아버지의키", ylab="아들의키", main="아버지와 아들의 키")
reg = lm(Height~Father, data=new_family)
summary(reg)

# Height_hat = 38.25891 + 0.44775*Father
# (p<0.001!! p값이 너무작다)
anova(reg)
#multiple r-squared확인하기 15.3%를 설명할수있으므로 좋은 회기모형은 아님.
abline(reg$coefficients,col='red')

#잔차의 등분산성을 따지기위해 독립변수와 잔차 그래프 그리기
plot(new_family$Father, reg$residuals, xlab="아버지키", ylab='잔차(residuals')
abline(h=0, col='red', lty=2) #수평선 0값에 그리기, lty를 사용하여 직선의 선모양바꿈

qqnorm(reg$residuals)
qqline(reg$residuals, col='red', lty=2)

shapiro.test(residuals(reg))


#다중선형회귀분석 실습.
data = read.csv("/Users/lostcatbox/uinv_lecture/data_mining/Lec5_실습자료/Lec5_regression.csv", header = T)
str(data)
#산점도 그리기. (난방비를 설명해야하므로y가 cost임)
par(mfrow=c(2,2)) #파라미터 바꾸는데 화면 행열로 지정
plot(data$temp, data$cost)
plot(data$thickness, data$cost)
plot(data$window, data$cost)
plot(data$apt, data$cost)

reg <- lm(cost~temp+thickness+window+apt, data=data)
reg <- lm(cost~., data=data) #.을 하면 y변수를 제외한 모든 변수를 활요함!
summary(reg)
#window는 p값이 너무너무 큼., 관계가 없다고 생각됨, 회기모형을 깍을가능성이있음
#변수 소거법을 사용하자
reg1 <- step(reg, trace=F) #backward가 디폴트, trace는 콘솔창에 log찍을꺼냐? 
summary(reg1)
#adjusted R올라감
#cost_hat = 284.374 -8.348*temp - 15.264*thickness +6.383*apt
#                      (p<0.0001)     (p<0.007)       (p=0.144) 특히 apt의 p값은0.05보다크므로 cost에 영향을 주지못함,기무가설을 깨지못함
#R^2 = 0.797 R^2 = 0.759


#이제 잔차를 확인해야함 (독립성, 등분산성, 정규성)
#유의미한 변수만 선택해서 삼전도 그리기
par(mfrow=c(1,2))
plot(data$temp, residuals(reg1), xlab="temp", ylab='residuals')
abline(h=0, col='red')
plot(data$thickness, residuals(reg1), xlab="thickness", ylab='residuals')
abline(h=0, col='red')
#분산되어있고, 증가, 감소 패턴이없다. (독립성, 등분산성 증명완료)

par(mfrow=c(1,1))
qqnorm(residuals(reg1))
qqline(residuals(reg1), col='red')
#부분적으로 벗어나는 모습이 보이므로 또 shapiro하기

shapiro.test(residuals(reg1))
#귀무가설을 따라야하므로 p값이 0.05보다 높은게좋음
#따라서 잔차의 정규분포는 정규성이 있다

