install.packages("clusterGeneration")
install.packages("reshare")
install.packages("reshape")
install.packages("devtools")
install.packages("scales")

library(nnet)
library(clusterGeneration)
library(reshape)
library(scales)
library(devtools)

data <- iris
str(data)

sep <- sample(2, nrow(data), prob=c(0.5,0.5), replace=T)
train <- data[sep==1,]
test <- data[sep==2,]
nn <- nnet(Species~., data =data, size=2, maxit=200, decay=5e-04, trace=F)
summary(nn) #각각이 가중치들임

#모형 시각화
source_url("https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r") 
plot(nn)

#test데이터이용해서 만든 모형을 test
p <- predict(nn, newdata = test, type="class")
table(test$Species,p) #완벽하게 맞았다!!
#은닉노드 수가 2~10개인 경우

test.error <- function(hiddensize){ #함수선언문, input데이터를 hiddensize명으로가져옴
  nnn <- nnet(Species~., data=train, size=hiddensize, decay=5e-04, maxit=200, trace=F) 
  p<- predict(nnn, newdata=test, type = "class")
  error<-mean(test$Species != p) #실제값과 추정값이 다른 것에 대한 비율'
  c(hiddensize,error)
}
out<-t(sapply(2:10,FUN=test.error)) #test.error라는 함수를 이용하여 은닉 노드수(2~5개)에 따른 오분류율 계산 #sapply는 2:5의 숫자를 각각 함수를 돌림 #t()는 가로데이터를 세로데이터로바꿈
plot(out, type="b", xlab="the number of hidden units", ylab="test error") #오분류율 그래프 출력 #세로데이터가 필요함

