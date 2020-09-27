---
title: 우분투 apt-get
date: 2020-09-27 15:40:41
categories: [Ubuntu]
tags: [Ubuntu, Basic]
---

[자세히](https://www.lesstif.com/lpt/apt-apt-get-24445574.html)

[자세히2](http://taewan.kim/tip/apt-apt-get/)

`apt`와 `apt-get`, `apt-cache`, `apt-config` 들의 차이가 있다. 

`apt-get`, `apt-cache`, `apt-config` 는 too low level로 패키지들을 조정할수있다. 덕분에 매우 많은 기능들을 갖고있다.

`apt` 는 `apt-get`, `apt-cache`, `apt-config` 등으로 구성되어있으며, 각각의 핵심 기능들을 활용할 수 있다.

`apt`명령어는 ubuntu 14이상에서는 다른 것들보다 권장되고있다,

| apt 명령         | 기존 명령            | 설명                                     |
| :--------------- | :------------------- | :--------------------------------------- |
| apt install      | apt-get install      | 패키지 목록                              |
| apt remove       | apt-get remove       | 패키지 삭제                              |
| apt purge        | apt-get purge        | 패키지와 관련 설정 제거                  |
| apt update       | apt-get update       | 레파지토리 인덱스 갱신                   |
| apt upgrade      | apt-get upgrade      | 업그레이드 가능한 모든 패키지 업그레이드 |
| apt autoremove   | apt-get autoremove   | 불필요한 패키지 제거                     |
| apt full-upgrade | apt-get dist-upgrade | 의존성 고려한 패키지 업그레이드          |
| apt search       | apt-cache search     | 프로그램 검색                            |
| apt show         | apt-cache show       | 패키지 상세 정보 출력                    |

__+ 새로운 명령어__

| apt 명령         | 설명             |
| ---------------- | ---------------- |
| apt list         | apt-get install  |
| apt edit-sources | 소스 리스트 편집 |

