install.packages("caret")
library(caret)
library(ModelMetrics)
getwd()
setwd("/Users/lostcatbox/univ_lecture/data_mining/")

#데이터 불러오기
data <- read.csv("Lec14_neuralnetwork.csv", header = T)
str(data)
summary(data) #결측값 확인

# Train set(6)과 Test set(4)으로 나누기 
sep <- sample(2, nrow(data), prob = c(0.6,0.4), replace=T)
train <- data[sep==1,]
test <- data[sep==2,]

# 다음 조합 데이터 프레임 생성 가중치 감소가 0.3, 5e-4 -> decay 은닉노드 수가 1, 2, 3 -> size 
exp <- expand.grid(decay=c(0.3,5e-4), size=c(1,2,3))
exp

#  Train set으로 모형 만들기 -> maxit = 200  , train 함수는 패키지caret필요
fit <-  train(share~., data=train, method="nnet", maxit=200, tuneGrid=exp, trace=F, lnear.output=T)


# 최적 가중치 감소 값과 은닉노드의 수 구하고 그래프 확인 
fit$bestTune #제일 좋은 조합출력
plot(fit) #제이 좋은 조합을 그래프확인 볼수있음

# Train set으로 모형 예측 및 mse 확인(이는 필수과정아님,회귀분석과 비교할려고)
pred <- predict(fit, newdata=train)
mse(train$share, pred)#ModelMetrics패키지 사용, 0.00017


# Test set으로 모형 예측 및 mse 확인 
pred1 <- predict(fit, newdata=test)
mse(test$share, pred1) # 0.00021

# 실제 값과 예측 값 묶어서 첫 6줄 확인 
head(cbind(test@share, pred1))

# Train set으로 회귀분석 돌려보기 
fit_1 <- lm(share~., data=train)
fit_2 <- step(fit_1, trace=F)
pred2 <- predict(fit_2, newdata=train)
mse(train$share, pred2) #0.0018

pred3 <- predict(fit_2, newdata=test)
mse(test$share, pred3) #0.0019
# 회귀분석 모형의 mse와 신경망 모형의 mse 비교 
## 따라서 신경망 학습이 오차 더 작음

# 신경망 모형 시각화 하기
source_url("https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r") 
nn<-summary(fit)
plot(nn)







install.packages("neuralnet")
library(neuralnet)
# 균등분포로부터 난수 50개 생성(runif(n, min, max) 함수)하여 x에 저장
x <- runif(50, 0, 100)

#생성한 난수의 제곱근(sqrt()함수)을 y로 저장 
y <- sqrt(x)

#x와 y를 열결합하여 train에 저장 
train <- cbind(x,y)

#neuralnet 함수를 이용하여 신경망 모형 만들기
##- 은닉노드 수는 10 
##- 노드 전달 임곗값은 0.01 
fit <- neuralnet(y~x, data=train, hidden=10, threshold = 0.01)
print(fit) #결과 출력하기 
plot(fit)#결과 시각화하기

#1~10 정수 생성하여 y_test에 저장 
y_test <- 1:10

#y_test를 제곱하여 data frame 형태로 x_test에 저장 (as.data.frame() 함수 사용) 
x_test <- as.data.frame(y_test^2)

#x_test 이용하여 예측 
predict <- compute(fit, x_test)
print(predict$net.result) #예측 값 출력 

#예측 결과 테이블 형태로 변형하여 출력
output <- cbind(x_test, y_test, as.data.frame(predict$net.result))
colnames(output) <- c("Input","Actual Output","Neural Net Output")
print(output)


mse(y_test, predict$net.result) #0.0008





#Train set(5)과 Test set(5)으로 나눈 후, neuralnet 함수를 이용하여 신경망 모형을 만드시오.
data <- iris
sep <- sample(2, nrow(data), prob=c(0.5,0.5), replace=T)
train <- data[sep==1,]
test <- data[sep==2,]

nn <- neuralnet(Species~., data=train, hidden=5, threshold = 0.01, linear.output = F) #분류니까 F
plot(nn) #생성된 신경망 모형을 시각화


#생성된 신경망 모형을 test set을 이용하여 검정하고 결과 정확도 테이블을 만드시오.
head(test) #검증시 5번째는 y변수가 있으므로 삭제 필요
p <- compute(nn, test[,1:4])
p1 <- print(p$net.result) 
p2 <- ifelse(p1>=0.05,1,0)
p2
p3 <- max.col(p2) #해당 행에서 최대값을 가지는 열 반환
p3

k <- table(test$Species, p3)
k

error <- sum(k[1,-1], k[2,-2], k[3,-3])/sum(k) #오차는 table에서 대각선을 제외한것이므로(해당-부호의뜻)
error #오차

#오분류를 최소화하는 은닉노드 수를 그래프를 통하여 구하시오.
test.error <- function(hiddensize){           #함수
  nn <- neuralnet(Species~., data=train, hidden=hiddensize, threshold=0.01, linear.output=F) 
  p<- compute(nn, test[,1:4])    #꼭 종속변수는 제외시켜줘
  p1<-print(p$net.result) 
  p2<-ifelse(p1>=0.5,1,0) 
  p3<-max.col(p2) 
  k<-table(test$Species,p3) 
  error <- sum(k[1,-1],k[2,-2],k[3,-3])/sum(k)         #오분류 수 / 전체 수 
  c(hiddensize,error) 
} 
out<-t(sapply(2:10,FUN=test.error)) #test.error라는 함수를 이용하여 은닉 노드수(2~10개)에 따른 오분류율 계산 
plot(out, type="b", xlab="the number of hidden units", ylab="test error") #오분류율 그래프 출력
out
# 3 0.03703704, 4 0.03703704, 9 0.03703704 따라서 노드 작은 3개선택
#노드 많을수록 과대적합될 가능성 높음

  
  