setwd("/Users/lostcatbox/univ_lecture/data_mining/Lec10_실습자료/")
data = read.csv("Lec10_regression.csv", header = T)
#항상 데이터 확인하기
update_data = data[,-1]
#1열 빼기
str(update_data) #Factor로 인지되었으므로 더미변수처리가능

plot(data$dose, data$len)

#첫번째 방법으로 그냥 회귀분석 (교후작용 x)
reg <- lm(len~., data=update_data)
reg1 <- step(reg, trace=F)
summary(reg1)

#len_hat = 9.272 -3.700*suppVC +9.7636*dose
#(p=0.001)      (p<0.001)
#R^2 = 0.7038 Adj.R^2 = 0.6934


#교효작용 적용
reg2 <- lm(len~.^2, data=update_data)
reg3 <- step(reg2, trace=F)
summary(reg3)
#len_hat = 11.550  -8.255*suppVC + 7.811 *dose + 3.904*(suppVC*dose)
#                      (p=0.001)      (p=0.001)       (p=0.025)
#R^2 = 0.730 Adj.R^2 = 0.715  
#설명력 이 올라감 R값을 보면, 따라서 더미변수에 따라 나누는것이 맞음

## 예제 2번째 
#size, income둘다 양적 변수이므로 교효작용 사용 불가.
# size-score or size-income의 산점도를 그려서 비선형 선택후 2차함수로,,
data2 <-  read.csv("Lec10_regression2.csv", header=T)
str(data2)

#산점도 그리기.
plot(data2$size,data2$score)
plot(data2$income,data2$score)  #낫 모양임.비선형

#그냥 선형회귀분석으로 돌려보기
reg4 <- lm(score~., data=data2)
reg5 <- step(reg4, trace=F)
summary(reg5)

# score_hat = 638.729 -0.648*size + 1.839*income
#                         (p=0.0679)    (p<0.01)  
# R^2=0.511 
# Adj.R^2 = 0.5091 

#2차함수 넣어서 돌려복 양적변수 2개면>?? 이렇게? size는 왜안함.???
reg6 <- lm(score~size+income+I(income^2), data=data2)
reg7 <- step(reg6, trace=F)
summary(reg7)

# score_hat = 625.230 -0.910*size +  3.882*income -0.0442*income^2
#                         (p=0.00727)    (p<0.01)     (p<0.01)
# R^2=0.564
# Adj.R^2 = 0.561

##2차함수는 종속변수가 최대를 가지는 시점이있음.구하기

reg8 <- lm(score~income + I(income^2), data=data2)
summary(reg8)

# score_hat = 607.302 + 3.851*income - 0.042income^2
#income으로미분하여 기울기 =0되는 곳찾기
# 3.851 - 0.084*income = 0 >>>>> income값이 3.851/0.084= (45.845)일때score 최대값가짐


##예제3  다 양적변수이므로 교효변수 적용 못함 

####################여기까지가  y변수 x변수 둘다 양적변수 하나이상있어야했음

#로지스틱 회귀분석: y변수가 질적변수로 나타남 (암환자 아니다 맞다 구별에사용)
# 로지스틱 회귀변수는 더미변수임 0~1사이의 값을 가짐.
# 선형 회귀 분석에서는 x가 -무한대 ~+무한대 인데 y는 0~1범위라면 설명 불가능
#로지스틱 회귀분석 필요
# 로지스틱  회귀 분석에서는 x가 -무한대 ~+무한대 인데 y는 0~1범위라면(로지스틱함수사용)-무한대 ~+무한대로바꿔줌 
# odds 라는 가정 필요
## 실패확률에 대한 성공에 비율
## p=성공확률; 1-p=실패할 확률; odds=p/1-p; p는 0~1사이의 값을 가짐; odds는 0에서 무한대값을 가질수있음
## ln(odds)= ln(p)-ln(1-p)
## 즉 이 값은 ln(odds)는 -무한대 ~+무한대사이의 값을 가짐

##ln(odds) = 베타*X
## 원하는 값은 즉 결과적으로 0 or 1만 가져야함,(더미변수로)
## 애를 연속변수로 생각한다면 0~1사이 값을 가짐 즉 0.5라는기준은 세워서 이하면 0 05보다 높으면 1(이게 확률값)
## 즉 확률 값이 0~1밖에 못구하므로 ln취함, -무한대 ~+무한대사이의 값을 가짐
## ln(odds)=베타*X로 로지스틱 함수가 완성됨.

#로지스틱 회귀분석 과정
##- 1단계: 각 집단에 속하는 확률의 추정치를 예측. 이진분류의 경우 집단 1에 속하는 확률 P(Y=1)의 추정치로 얻음. - 2단계: 추정확률 → 분류기준값(cut-off) 적용 → 특정 범주로 분류
## 예) P(Y=1) ≥ 0.5 → 집단 1로 분류
##P(Y=1) < 0.5 → 집단 0으로 분류


##odds는 확률 이 아님. p/1-p
## odds = 1/6 =0.16666 ; odds=6/1=6 대칭안됨
## odds = ln(odds)= ln(1/6)= -1.7917;odds = ln(odds)= ln(6/1)= 1.7917 대칭
## p=0.5 >> odds=1 >>logit(p)=ln(odds)=0

# odds ratio
## - 설명변수 x=1에서의 odds와 x=0에서의 odds의 비
#- x가 한 단위 증가할 때 y=1일 위험과 y=0일 위험의 비의 증가율
#- 설명변수 x=1에서의 odds와 x=0에서의 odds의 비
#- x가 한 단위 증가할 때 y=1일 위험과 y=0일 위험의 비의 증가율
#- 특정 위험에 노출될 경우, 그렇지 않은 경우에 대한 상대적 위험도- 특정 위험에 노출될 경우, 그렇지 않은 경우에 대한 상대적 위험도


