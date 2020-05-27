---
title: ubuntu
date: 2020-05-27 01:21:55
categories:
tags:
---

```
ssh agd@192.168.1.211
ssh: connect to host 192.168.1.211 port 22: Connection refused
```

PC2에 고정 IP가 구성되어 있습니다. 그리고 WiFi를 통해 PC2에 SSH를 시도하면 작동합니다.

다른 스레드에 대한 몇 가지 가이드를 참조하여 시도했습니다.

```
sudo service ssh status
```

모든 것이 포트 22를 듣고 있습니다.

그런 다음 시도했습니다

```
sudo apt-get purge openssh-server 
sudo apt-get install openssh-server
```

그것도 잘 갔다. 상태를 확인할 때 포트 22 청취

그런 다음 시도했습니다

```
sudo service ssh restart
```

문제 없다

그런 다음 두 PC에서 모두 시도했습니다.

```
ufw allow 22
```

하지만 같은 네트워크 망에있으면 ssh 로 접근 불가능하였다.





[해결](https://cpuu.postype.com/post/30065)