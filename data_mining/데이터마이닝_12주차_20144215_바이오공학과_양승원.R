#실습 예제2
library(dplyr)
library(car)
library(ROCR)
library(BaylorEdPsych)
#1) 데이터 불러오고 확인하기
data <- read.csv("/Users/lostcatbox/univ_lecture/data_mining/Lec12_실습자료/Lec12_Logistic2.csv", header=T)
str(data)
summary(data)
#2) 변수 별 NA 개수 확인하기
sapply(data, function(y) sum(is.na(y))) #함수기능 적용, 어떤 함수 알려줘야함


#3) NA가 가장 많은 변수를 선택하여 filter 함수를 이용하여 결측 값 제거하기. 
data <- select(data, -insulin) #변수, 열 제거
head(data)
data <- filter(data, !is.na(triceps)) 
head(data)
data <- filter(data, !is.na(glucose))
head(data)
data <- filter(data, !is.na(pressure))
data <- filter(data, !is.na(mass))
sapply(data, function(y) sum(is.na(y))) #NA없는것 확인

#4) Train set과 Test set을 8:2로 나누기
sep <-  sample(2, nrow(data), prob=c(0.8, 0.2), replace=T)
train <- data[sep==1,]
test <- data[sep==2,]

#5) Train set 이용하여 로지스틱 회귀분석 돌리기
logit <- glm(diabetes~., data=train , family = binomial)

#6) step 함수로 최종 로지스틱 회귀분석 결과 출력
logit1 <- step(logit, trace=F)
summary(logit1)
#7) 공선성 검사
vif(logit1)  #10넘지않는것 확인
#8) 예측력 확인
logit.full.auc #ROC 곡선 아래 면적, 0.8023정도로 좋은편
#- ROC 곡선 출력 - AUC 값 출력
logit.full.pred <- predict(logit1, newdata=test, type="response") 
logit.full.pr <- prediction(logit.full.pred, test$diabetes) #예측력 보는 함수, 역할은 위의 y_hat값(logit.full.pred)과 실제데이터의 y값을 비교
logit.full.prf <- performance(logit.full.pr, measure = "tpr", x.measure = "fpr")  #y축이 trp(맞는것 맞다고함) x축이 fpr(틀린것 맞다고함)임. 
plot(logit.full.prf) #ROC 곡선 그리기ROC커브 볼수있음, 
logit.full.auc <- performance(logit.full.pr, measure = "auc")  #performance함수의 auc계산함
logit.full.auc <- logit.full.auc@y.values[[1]] #AUC면적을 나타내는 것은 첫번째 리스트에 있는 값에 존재


exp(coef(logit1))
PseudoR2(logit1)
#odds_hat = 3.995688e-05 + 1.149361e+00*pregnant + 1.033275e+00*glucose + 1.099189e+00*mass + 3.249455e+00*pedigree + 1.031616e+00*age
#                                   (p<0.001)            (p<0.001)            (p<0.001)                   (p<0.001)

# AIC =378.06;McFadden.Pseudo R^2= 0.325; Adj.McFadden.Pseudo R^2=0.299












