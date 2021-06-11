# Train, Test set 만들기(왜? 현재 있는 데이터로 모델만들 데이터와, 만든 모형 테스트 해야하므로)
# Train set: 모형을 만들 데이터
# Test set: 만든 모형을 검증,검사할 데이터
#보통 8:2 또는 7:3으로 설정
#설정 방법:
#(그림1)
#  sep <- sample(2, nrow(x), prob = c(0.8, 0.2), replace = T)  #sample함수는 1,2중 2를 뽑고 replace=T이므로 공을 뽑고 다시 그 데이터 집어넣음.
# nrow(x)는 행의 갯수 만큼 뽑을꺼임, prob = c(0.8,0.2) 은 1,2를 각각 뽑을 확률임,즉 정확게 8:2는 아님.
# 즉 변수1, 변수2 가있는 데이터 프레임이 있다면 sep변수 만들어서 1 or 2 를 값으로 추가하여 test set과 train set을 만듬
#  train.x <- x[sep == 1, ]  #sep==1인 열 모두  
#  test.x <- x[sep == 2, ]   #sep==2인 열 모두
#  공선성 검사 (vif 가 5이하면 공선성 없는 것)
#  "car" package install 후 library(car) 실행
#실행 방법: vif(logit.fit)



#Train set을 이용하여 만든 모형의 예측력
#" ROCR " package install 후 suppressMessages(library(ROCR)) 실행
# ROC 커브 아래의 영역 AUC가 1에 가까울 수록 모델의 예측 정확도 높음 
# 실행 방법:
#  logit.full.pred <- predict(logit.fit, newdata=testset, type="response") #logit.fit = train 데이터로 만든 모형, newdata=testset를 가지고 예측하는 함수 # y_hat값 가지고있음
# logit.full.pr <- prediction(logit.full.pred, testset$Y) #예측력 보는 함수, 역할은 위의 y_hat값(logit.full.pred)과 실제데이터의 y값을 비교
#  logit.full.prf <- performance(logit.full.pr, measure = "tpr", x.measure = "fpr")  #y축이 trp(맞는것 맞다고함) x축이 fpr(틀린것 맞다고함)임. 
# plot(logit.full.prf) #ROC 곡선 그리기
#  logit.full.auc <- performance(logit.full.pr, measure = "auc")  #performance함수의 auc계산함
# logit.full.auc <- logit.full.auc@y.values[[1]] #AUC면적을 나타내는 것은 첫번째 리스트에 있는 값에 존재
# logit.full.auc #ROC 곡선 아래 면적


#AUC 판단기준
#• excellent = 0.9~1
#• good = 0.8~0.9
#• fair = 0.7~0.8
#• poor = 0.6~0.7
#• fail = 0.5~0.6

#데이터 정리에 유용한 함수
#sapply(x, function(y) expression)  #각각의 변수에 함수 적용 하고싶을때!
#예) x 데이터 안에 있는 각 변수 별 평균 구하기:
#  sapply(x, function(y) mean(y)) 
# 예)x데이터안에 각변수별NA의개수구하기:
#  sapply(x, function(y) sum(is.na(y)))
#예) x 데이터 안에 각 변수 별 원소 값의 종류 개수 구하기:
#  sapply(x, function(y) length(unique(y))) 

#suppressMessages(library(dplyr)) 패키지 또는 install.packages("dplyr"); library(dplyr) #dplyr가 데이터 편집, 정제 좋은 함수많음
#select(x, y1, y2) :select는 특정 열만 추출가능, x 데이터 안에 있는 y1, y2 변수만 선택
#mutate(x, y=ifelse(A, B, y)) : mutate함수는 데이터 수정에 쓰임. x 데이터 안에 있는 y변수가 A면 B로 치환하고 아니면 그대로 y 출력 
# filter(x, A) : filter는 특정 행만 추출가능, x 데이터에 A인 경우만 거르기


# 로지스틱 회귀분석 실습
#해야하는 것
#Lec12_Logistic1.csv 파일에 있는 데이터를 이용하여 Titanic 생존 여부를 설명하는 모형을 만드시오. 
#1) 데이터 불러오고 확인하기
#2) 변수 별 NA 개수 확인하기
#3) Name, Ticket, 그리고 NA가 500개 이상인 변수들 외에 나머지 변수들만 선택하여 저장하기
#4) Age 변수 결측 값은 평균 값으로 대체
#5) 남은 결측 값 행 제거 (filter 사용)
#6) Train set과 Test set을 8:2로 나누기
#7) Train set 이용하여 로지스틱 회귀분석 돌리기 
#8) 회귀분석 결과 summary 출력
#9) step 함수로 최적화 결과 출력 
#10) 공선성 검사
#11) 예측력 확인
#- ROC 곡선 출력 - AUC 값 출력


#survived가 생존 여부이며 1이 생존 , 0은 사망
install.packages("dplyr")
install.packages("ROCR")
library(dplyr)
library(car)
library(ROCR)
library(BaylorEdPsych)


data <- read.csv("/Users/lostcatbox/univ_lecture/data_mining/Lec12_실습자료/Lec12_Logistic1.csv", header=T)
str(data)
head(data)
summary(data) #NA많음..

sapply(data, function(y) sum(is.na(y))) #함수기능 적용, 어떤 함수 알려줘야함

data <- select(data, -Name, -Ticket, -Cabin, -PassengerId) #변수, 열 제거#PassengerId는 필요하지않은값이므로.
head(data)
data <- mutate(data, Age=ifelse(is.na(Age), mean(Age, na.rm=T), Age)) #값 변경#평균은NA가 있다면 NA없애야햄, 맨  마지막은 false면 기존 Age값 가져닿씀
head(data)
data <-  filter(data, !is.na(Survived)) #행 제거, #NA값은 Survived, Fare, Embarked존재함, !=not, filter는 뒤에 조건이 참일때 그 행 삭제
sapply(data, function(y) sum(is.na(y))) #아직 Embarked 남아있음
data <-  filter(data, !is.na(Embarked)) #행 제거, #NA값은
sapply(data, function(y) sum(is.na(y)))

#전처리 완료,Train set, Test set 나누기
sep <-  sample(2, nrow(data), prob=c(0.8, 0.2), replace=T)
train <- data[sep==1,]
test <- data[sep==2,]

#  train set을 이용해  로지스틱 회귀분석
logit <- glm(Survived~., data=train , family = binomial)
logit1 <- step(logit, trace=F)
summary(logit1)

vif(logit1)
logit.full.pred <- predict(logit1, newdata=test, type="response") 
logit.full.pr <- prediction(logit.full.pred, test$Survived) #예측력 보는 함수, 역할은 위의 y_hat값(logit.full.pred)과 실제데이터의 y값을 비교
logit.full.prf <- performance(logit.full.pr, measure = "tpr", x.measure = "fpr")  #y축이 trp(맞는것 맞다고함) x축이 fpr(틀린것 맞다고함)임. 
plot(logit.full.prf) #ROC 곡선 그리기ROC커브 볼수있음, 
logit.full.auc <- performance(logit.full.pr, measure = "auc")  #performance함수의 auc계산함
logit.full.auc <- logit.full.auc@y.values[[1]] #AUC면적을 나타내는 것은 첫번째 리스트에 있는 값에 존재
logit.full.auc #ROC 곡선 아래 면적, 0.8485정도로 좋은편

exp(coef(logit1))
PseudoR2(logit1)
#odds_hat = 188.971 + 0.314*Pclass + 0.059*Sexmale + 0.9618*Age + 0.677*SibSp
#                          (p<0.001)  (p<0.001)          (p<0.001)       (p<0.001)
#해석하면 Pcalss가 한단위 증가할때마다 생존확률*0.314배 되므로 죽을 확률이 높아짐
#AIC = 628.81
#McFadden.Pseudo R^2= 0.339
#Adj.McFadden.Pseudo R^2=0.326

#실습 예제2
#1) 데이터 불러오고 확인하기
#2) 변수 별 NA 개수 확인하기
#3) NA가 가장 많은 변수를 선택하여 filter 함수를 이용하여 결측 값 제거하기. 
#4) Train set과 Test set을 8:2로 나누기
#5) Train set 이용하여 로지스틱 회귀분석 돌리기
#6) step 함수로 최종 로지스틱 회귀분석 결과 출력
#7) 공선성 검사
#8) 예측력 확인
#- ROC 곡선 출력 - AUC 값 출력











# 인공지능 개요
# 입력 값으로부터 결과 값을 내는 함수를 만들어 내는 것
#input x >> function f>> output y  (이떄 function에 선형, 비선형결합한 함수로 만들어냄)
#하지만 고도화 하기 힘듬
# 따라서 신경망을 찾음
#  (그림2)
#weight
#네모: 1
#세뫼 -1

# input data
# (3,2)
# (1,4)
# (5,5)
# (8,3)

#label
#1,-3, 0,5

#weight값을 찾아내는것 >> 기게학습이 하는일

#기계학습의 종류
#지도학습(Supervised learning)
#- input과 labels를 이용한 학습
#- 분류(classification), 회귀(regression)
#비지도학습(Unsupervised learning)
#- input만을 이용한 학습
#- 군집화(clustering), 압축(compression)
#강화학습(Reinforcement learning)
#- label 대신 reward가 주어짐
#- action selection, policy learning
#- https://www.youtube.com/watch?v=Q70ulPJW3Gk&feature=youtu.be

#신경망
#기본단위: 신경세포(Neuron)
#- 개별적으로는 단순한 작동원리
# cell-body 일정수준 이상일 때 반응>>축삭돌기, 가지돌기 는 연접>>다른신경세포가 알게함. 전기 화학적 신호)
# 신경망, 기본단위 신경세포>> 어느정도 역치가 지나야 전달 , 차단.
# 개별적으로는 단순한 형태, 전체적으로는 정교한 판단 - 반응
#Neuron 수 , 층(Layer) , 적절한 연결(connections) >>>모이면 창발(Emergence)
#왼쪽, 오른쪽 신경이 있다면 왼쪽에 햇빛이면 왼쪽에 있는 신경 더 쌔게 반응, 근육방향조절가능(신경망이 근육과 크로스면, 오른쪽근육움직임, 직선연결이면 왼쪽근육움직임)
# 신경망에서는 신경 갯수도 중요하지만 연결이 매우중요함> 반응이 다르게 나옴


#정교한 판단 - 반응: XOR 문제
# 신경세포로 표현하자면 사냥 성공확률P(S)와 보상의 크기 (Reward)가 축삭말단이 Hunt(사냥 실행여부)로 이어진 (그림3)
# 사냥 성공확률이 크면 1과 가까워짐, 보상의 크기 크면1과 가까워짐 , 사냥 실행여부 1과 가까워짐.
# (그림4) 성공가능성이 낮은데 성공시 보상 높으면 함(실행여부 1), 완전 반대 경우도 (실행여부 1), 성공확률높고 보상확률도 높으면 (실행여부 0)>> 너무 이상적인 경우면 이건 fake로 알아차림, 조개가 페이크칠 확률이있으므
# (그림5) 즉 둘중 하나만 1일때 사냥 실행해야되므로 Exclusive OR 문제라고 부름
# (그림 6) 2개의 신경망 세포에 사이에 하나더 추가하면 가능
#(그림 7) 적절한 연결이 매우 중요함
# (그림 8) 신경 숫자 layer까지 많아지면 정교한 판단가능, 새로운 경험을 하면서 신경망은서로의 연결을 추가, 제거, 강화, 약화 시킴

#학습이란?
# - 심리학에서 학습이란 과거 경험 때문에 일어나는 __행동__ 상의 비교적 영속적인 변화
# - 학습은 비교적 오래 __지속__되는 변화가 있음을 의미
# - 학습은 __경험__에 의해 생겨나는 변화이며 따라서 육체적 성숙, 약물, 질병 등으로 인한 행동 변화와는 구분되어야 함

#사람은 어떻게 학습할까?
#- 연합(association): 주위 환경에서 일어나는 사건들 간의 연관성을 배우는 것
#- 고전적 조건형성(classical conditioning): 두 자극이나 사건 사이의 관련성을 배우는 것 #번개치면 소리나중엠
#- 도구적 조건형성(instrumental or operant conditioning): 반응과 그 결과 사이의 인과관계 학습 # 성적이 향상될려면 공부 열심히

#(그림9) layer!!, learning 
#기계학습(Machine learning)의 한 방법론
#- 기계학습은 인공지능의 한 분야
#- 컴퓨터를 인간처럼 학습시켜 스스로 규칙을 형성할 수 있도록 하는 알고리즘과 기술을 개발하는 분야 - 예) 분류문제: 수신한 e-메일의 스팸 여부, 입력된 고양이와 개의 사진 구분
#회귀분석문제: 주식 가격 예측, 기온 예측, 강수량 예측
#- 기계학습의 대표적인 방법론: 신경망, 의사결정나무, 베이지안 망, 서포트 벡터 기계, 강화학습
# 세계는 지금 딥러닝 전쟁중!
#- 네이버의 음성 검색
#- 구글의 딥러닝 전문가 기업 '딥마인드' 인수
#- 트위터의 딥러닝 기반 이미지 검색 스타트업 기업 인수 - 중국 바이두의 기계학습 유명학자 초빙
#- 페이스북의 인공지능 연구책임자 초빙

#신경망 학습
#1. 데이터의 특성 
# 랜덤, 조직화(어떤 패턴을 가짐)
#  신경망에서 테이터 특성을 추출하는 방법은 "함께 반응하는 신경세포들을 함께 연결시킨다"
# 개구리는 밝은 빛 배경에서 한부분만 어두우면 반응하는 Off-cell이 혀 근육에 반응을 줌.
# off-cell이 여러 개에 알파벳을 노출시키면 (그림 10) E를 노출하면 맨위에 3개 세포는 반응함, F도 반응함, T에도 반응함, 따라서 함께 반응하는애들을 상위에 한 뉴런에 연결됨.
# 따라서 하위(점)가 모여서 상위인 선을 뜩하는 한차원 높은 상위 신경세포가 만들어짐
# 학습을 통해서만 하위 묶어서 상위를 만들어낼수있음
# E가 중간에 구멍이 뚫여있어도 상위 신경세포가 조금 약한 반응을 함!,데이터가 완벽하지 않아도, 가능
#-Fuzzy logic: 데이터가 완벽하지 않아도 비슷한 판단 가능
#- Fault Tolerant: 데이터에 약간의 하자가 있어도 큰 지장 없이 움직임
#- Generalization: 데이터의 모양이 완전하지 않더라도 판단을 내리는데 큰 지장 없음
# 점에서 한차원 높은 층 (layer)가 높아질수록 점점더 복잡한 패턴을 인식할수있음, 선>눈,귀>사람얼굴
# 사전적 지시 없었음.
#함께 반응하는 신경세포들을함께 연결하므로 가능함.









