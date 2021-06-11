# 데이터를 파일 또는 웹에서 가져오기
rd<-read.csv(“/User/”, header=T) #파일 (csv 형태): 
rd <- read.table("http://사이트주소", header = T, stringsAsFactors = FALSE) #웹 (txt 형태), stringsAsFactors는 데이터안에 문자열로되어있는것을 범주형factors로 인식해버림을 방지#
 # 산점도를 통한 두 변수간 관계 확인(관계성 유효한지 눈치보기)
plot(x=a, y=b, xlim=c(0,10), ylim=c(0,10), main=“points“) #xlim, ylim은 값범위를 나타냄
par(mfrom=c(2,1));plat(x1,y);plot(x2,y) #;는 다른선언문이라고 표현
#필요한 변수 생성 및 모으기(질적변수>>양적변수처럼 만드는 더미변수)
##일괄적 더미변수 생성:(cbind로 dummy데이터 합쳐야함, A변수는 다 썻으면 없애기)
  drd <- data.frame(fac=factor(rd$A));#rd$A변수를 범주형 변수로 바꾼다음, 데이터프레임으로 저장후,  
  dummy <- model.matrix(~fac-1, drd) #~fac을 더미변수로 변형됨,  -1은모든 0으로 되있는변수는 생성하지않고
##조건별 더미변수 생성:(특정조건에 해당하면 1, 아니면 0)(A변수는 끝났으면 삭제, 아래는 기존 데이터에 추가되므로 cbind필요없다)
    newdata <- transform(rd, dum1 = ifelse(A >= 1 & A < 2, 1, 0), dum2 = ifelse(A >= 3 & Month <4, 1, 0)) #더미변수 생성
# 회귀분석 돌리기
reg <- lm(y ~ x1+x2, data=rd)
# reg <- lm(y ~ ., data=rd) ; summary(reg) #이것ㄷ 사용가능, 하지만 .을 사용하므로 A변수를 제거했어야함
reg1<-step(reg, trace=F) #유효한 변수들만 걸러내기 step활용 

# 잔차의 등분산성 – 잔차와 독립변수의 산점도
plot(newdata$A, residuals(reg1), xlab="residuals", ylab="이름 넣기") #residuals는 잔차가져오는 함수
abline(h=0, col="red", lty=2) #선 긋기
# 잔차의 정규성 – 잔차의 정규확률그림(normal Q-Q plot)
qqnorm(residuals(reg1), main="그래프이름")
qqline(residuals(reg1), lty=2, col="red")
#qqnorm의심될때, 잔차분석 – Shapiro-Wilk의 정규성 검정 (귀무가설: 정규분포에서 추출된 표본이다.)
shapiro.test(residuals(reg1))
# 독립변수들 간의 독립성 – 분산확대인자
vif(reg1)   #vif의 10이하면 독립성이 성립!
# 최종모형 선택 & 작성
##회귀식 y_hat= beta0+beta1*x1+..........+beta(p+1)*d(p+1) +... #d는 더미변수들
##R2 & Adjusted R2


# 분산분석표 – SSE, SSR, MSE, MSR 등을 확인할 수 있음