---
title: 우분투에서 IP고정
date: 2020-09-25 11:46:45
categories: [Ubuntu]
tags:  [Ubuntu, Network]
---

[자세히](https://blog.dalso.org/linux/ubuntu-20-04-lts/9069)

# 왜?

버전 20.04 LTS이다

가장 먼저 해야할 것은 고정 IP 할당입니다.
고정 IP를 할당하지않으면 DHCP를 통해 IP가 자꾸 바뀌는 불상사가있을수도 있기 때문이다.

실제로 나는 우분투를 재부팅후, IP주소를 제대로 못잡아서, apt-get의 오류를 읽고 차근차근 추론하여, 위와 같은 문제인것을 알았다. (+친구의 도움)

# netplan 이용

기본적으로 파일 경로는 /etc/netplan/50-cloud-init.yaml에있다. (파일명 다를수있음)

__기본 파일 내용(DHCP일경우)__

![스크린샷 2020-09-25 오후 12.09.03](https://tva1.sinaimg.cn/large/007S8ZIlgy1gj2qdggdn8j30rr0eat9n.jpg)

__변경 내용__

![스크린샷 2020-09-25 오후 12.22.53](https://tva1.sinaimg.cn/large/007S8ZIlgy1gj2qelmcedj30rc0jmjt4.jpg)

~~(gateway4: 192.168.88.1 이였다..)~~

- dhcp4 : IPv4 dhcp 설정
- dhcp6 : IPv6 dhcp 설정
- addresses : `,`로 구분한 IP 멀티로 가능
- gateway4 : IPv4 gateway 설정
- nameservers : dns 설정 `,`로 구분 멀티로 설정 가능 [생략 가능]



마지막으로 변경사항 적용후

`sudo netplan apply`

확인해보자

`ifconfig -a`



> netplan이 없을경우 
>
> `sudo apt-get update -y`
>
> `sudo apt-get install -y netplan.io`

