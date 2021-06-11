setwd("/Users/lostcatbox/uinv_lecture/data_mining/Lec10_실습자료/")
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



