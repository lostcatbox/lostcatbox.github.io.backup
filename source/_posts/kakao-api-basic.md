---
title: 카카오채널 구현해보기
date: 2020-01-22 19:04:47
categories: Kakao
tags: [Kakao, basic]
---

# Kakao api 시작하기 전에

이 내용은 모두 [KakaoDevelopers 개발가이드]([https://developers.kakao.com/docs/ios/kakao-talk-channel#%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1-%EC%B1%84%EB%84%90-%EC%B6%94%EA%B0%80%ED%95%98%EA%B8%B0](https://developers.kakao.com/docs/ios/kakao-talk-channel#카카오톡-채널-추가하기))에 있는 내용임을 알립니다!

[개발자로 회원가입](https://developers.kakao.com/)

# 시작하기

## 카카오 채널관리자 만들기

카카오톡채널 관리자센터 [여기](https://accounts.kakao.com/login/kakaoforbusiness?continue=https://center-pf.kakao.com/)

카카오 developer관련 질문 [여기](https://i.kakao.com/forum/)

카카오 api 소개 및 다루는 법 소개 [여기](https://developers.kakao.com/features/kakao#%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1-%EC%B1%84%EB%84%90-API](https://developers.kakao.com/features/kakao#카카오톡-채널-API))

위 사이트안에서 카카오채널에 관한 소개 [여기]([https://developers.kakao.com/features/kakao#%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1-%EC%B1%84%EB%84%90-API](https://developers.kakao.com/features/kakao#카카오톡-채널-API))

카카오채널에서 플러스 친구과 연결된 다양한 오픈 빌더 플랫폼 [여기](https://i.kakao.com/login)

[나중에 삭제 예정된 참고자료](https://github.com/Beomi/where-is-my-customs)

## OBT신청하기 [여기](https://i.kakao.com/login)

__주의사항__

챗봇의 사용목적을 정확히 서술하지 않고 챗봇 OBT를 신청할 경우 잘못하면 6일이라는 시간을 날릴 수도 있으니 신청할때 아래 중요시 생각되는 것들과  예시를 통해 꼼꼼히 작성하길 바란다

~~(나도그냥했다가바로짤림)~~

```
“챗봇의 사용 목적이 불분명하여 OBT 승인 신청이 반려되었습니다.
카카오 i 디벨로퍼스 OBT 참여를 희망하시는 경우, 플러스친구 홈과 신청사유에 챗봇의 성격을 뚜렷하게 명시해주시길 바랍니다.
예시로 주변 맛집을 찾아주는 ‘맛집봇’, 특정 인물의 Q&A를 알려주는 ‘인물봇’ 등 챗봇의 사용 목적이 드러나면 좋습니다.
플러스친구 이름, 프로필 이미지, 카테고리 등 플러스친구 정보를 정확히 입력 후, 공개로 설정된 플러스친구 계정 URL을 정확하게 입력하여 다시 신청해주시기 바랍니다.
OBT에 신청해주셔서 감사합니다.”
```

## 주요개념

### 엔티티

- **엔티티(Entity)**란 봇이 이해할 수 있는 용어를 체계적으로 정리한 데이터 사전입니다. 엔티티가 정의되어 있다면, 봇은 __사용자 발화로부터 사용자의 의도에 맞는 동작 수행을 위한 주요 데이터를 추출할 수 있게 됩니다.__
- 엔티티명>대표엔트리(1,2,3,)>동의어(A,B,C...)로 구성되어있다.
- 엔티티는 __나의엔티티__(내가직접입력) , __시스템엔티티__(카카오측에서 만들어놓음)(날짜, 시간, 숫자 등등)로 구별된다.
- 엔티티가 있다면 사용자가 비슷한 말을 발화한 것에서 원하는 값을 객체로 가져올수있다.

### 시나리오

























