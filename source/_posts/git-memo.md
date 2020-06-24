---
title: git memo
date: 2019-10-19 19:10:31
categories: Git
tags: [Git, Basic]
---

# Git Hub

-----

## git의 관리받는 저장소만들기

```
git init  #저장소 만들기

rm -rf .git #저장소 삭제하기
```
## 저장소 받아오기

```
git clone /로컬/저장소/경로
```
## 원격 서버의 저장소를 복제 
```
git clone 사용자명@호스트:/원격/저장소/경로
```
## 원격 저장소 주소 추가 삭제



```
git remote add origin <주소>   #주소적기
git remote    
git remote -v   #지금 현재 주소 
git remote show <리모트 저장소 이름>  #리모트 저장소의 구체적인 정보를 알수있다.
git remote rename <원래 이름> <바꿀이름>   #리모트 저장소 이름 바꾸기
git remote remove <리모트 저장소 이름> #리모트 삭제
```

## 리모트 저장소를 Pull 하거나 Fetch 하기

앞서 설명했듯이 리모트 저장소에서 데이터를 가져오려면 간단히 아래와 같이 실행한다.

```console
$ git fetch <remote>
```

이 명령은 로컬에는 없지만, 리모트 저장소에는 있는 데이터를 모두 가져온다. 그러면 리모트 저장소의 모든 브랜치를 로컬에서 접근할 수 있어서 언제든지 Merge를 하거나 내용을 살펴볼 수 있다.

저장소를 Clone 하면 명령은 자동으로 리모트 저장소를 “origin” 이라는 이름으로 추가한다. 그래서 나중에 `git fetch origin` 명령을 실행하면 Clone 한 이후에(혹은 마지막으로 가져온 이후에) 수정된 것을 모두 가져온다. `git fetch` 명령은 리모트 저장소의 데이터를 모두 로컬로 가져오지만, 자동으로 Merge 하지 않는다. 그래서 당신이 로컬에서 하던 작업을 정리하고 나서 수동으로 Merge 해야 한다.

그냥 쉽게 `git pull` 명령으로 리모트 저장소 브랜치에서 데이터를 가져올 뿐만 아니라 자동으로 로컬 브랜치와 Merge 시킬 수 있다(다음 섹션과 [Git 브랜치](https://git-scm.com/book/ko/v2/ch00/ch03-git-branching) 에서 좀더 자세히 살펴본다). 먼저 `git clone` 명령은 자동으로 로컬의 master 브랜치가 리모트 저장소의 master 브랜치를 추적하도록 한다(물론 리모트 저장소에 master 브랜치가 있다는 가정에서). 그리고 `git pull` 명령은 Clone 한 서버에서 데이터를 가져오고 그 데이터를 자동으로 현재 작업하는 코드와 Merge 시킨다.

## 저장소 commit 되돌리기 (rollback)

```
git reset <옵션> <돌아가고싶은 커밋>

git reset --hard xxxxxxx # 돌아가려는 이력이후의 모든 내용을 지워 버립니다.

git reset --soft  xxxxxx # 돌아가려 했던 이력으로 되돌아 갔지만, 이후의 내용이 지워지지 않고, 해당 내용의 인덱스(또는 스테이지)도 그대로 있습니다. 

git reset HEAD~6 # 위와 같이 현재부터 6개 이전 이력으로 돌아가라라고 상대적으로 지정

git psuh --force #분명 위에과정을 거치면 로컬과  git다를텐데 강제로 push

```

[자세히]([https://www.devpools.kr/2017/02/05/%EC%B4%88%EB%B3%B4%EC%9A%A9-git-%EB%90%98%EB%8F%8C%EB%A6%AC%EA%B8%B0-reset-revert/](https://www.devpools.kr/2017/02/05/초보용-git-되돌리기-reset-revert/))





## Git 의 구성

------

-작업디렉토리
-인덱스(stage)
-HEAD

## 관련 설명

------
작업디렉토리는 실제 파일들로 이루어져있으며
안에 변경사항이 일어날경우 git이 인지
내가 변경사항이 있는 것들을 add를 통해 추가
또는 기존에서 추가하는파일들이있어도 역시 add로 추가한다
그리고 stage에 있는 애들은 commit명령어로 HEAD로 최종확정본을 나타낸다
다음은 서버로 올려야한다

## 현재상태확인

```
git status
```
## 파일추가 및 확정.

```
git add<파일 이름>
git add *
git commit -m "이번 확정본에 대한 설명"
```
## 변경 내용 발행하기

현재의 변경 내용은 아직 로컬 저장소의 HEAD안에 머물고 있다
원격 서버로 올려보자

```
git push origin master (다른 가지를 발행하려면 master 대신 가지이름을 적는다)
```

## 서버주소 입력해주자

만약 기존에 있던 원격 저장소를 복제한것이 아니라면
원격 서버의 주소를 git에게 알려줘야 해요
```
git remote add origin <원격 서버 주소>
```
이제 변경 내용을 원격 서버로 발행가능

## 가지 (branch)

가지는 안전하게 격리된 상태에서 무언가를 만들떄 사용합니다
branch로 가지로 나와서 나중에 완성되면 merge로 master(혹은 현재잡혀있는 위치)와 병합합니다

```
git checkout -b feature_x (feature_x라는 가지생성)

git checkout master(마스터 가지로 돌아옴)

git branch -d feature_x (가지삭제)

git push origin <가지이름> (서버로 보낼떄까지는 다른사람 접근 불가)
```
## 갱신과 병합

나의 로컬 저장소를 원격 저장소에 맞춰 갱신하려면 (원격 저장소의 변경 내용이 로컬 작업 디렉토리에 받아지고 병합됨)
```
git pull
```
다른 가지에 있는 변경 내용을 현재 가지에 병합하려면 현재 위치에서
```
git merge <가지 이름>
```
### 만약 충돌일어나면? 
위에 둘다  병합시도를 하는데 충돌이 일어나면 git에서 알려주는 파일을 직접 수정후 파일을 병합하라고 알려주셈 
```
git  add<파일 이름>
```
변경내용을 병합하기전에, 어떻게 내용차이가 나는지알수있음
```
git diff <원래 가지> <비교대상가지>
```

## 로컬 변경 내용 되돌리기

위 명령은 로컬의 변경 내용을 변경 전  상태(HEAD)로 되돌려줘요
```
git checkout -- <파일 이름>
```
다만 이미 인덱스에 추가된 변경 내용과 새로 생성한 파일은 그대로 남는다

## 로컬 포기

만약, 로컬에 있는 모든 변경 내용과 확정본을 포기하려면,
아래 명령으로 원격 저장소의 최신 이력을 가져오고,
로컬 master 가지가 저 이력을 가리키도록 할수 있어요/

```
git fetch origin
git reset --hard origin/master
```

## git add한 걸 취소하고싶을떄
```
git reset HEAD[file]   #파일명이없다면 add한 파일 전체 취소한다
```
[자세히](https://gmlwjd9405.github.io/2018/05/25/git-add-cancle.html)

[자세히 2](https://mrgamza.tistory.com/593)



## 그외 기능들

### git graph 보기

```
git log --graph --oneline --all
```





### git에 올릴필요없는파일들

./gitignore에 경로 표시하면 해당 파일 무시됨

예시)

```
# ./gitignore

secrets.json 

```

그리고 만약 현재 추적당하는 파일을 넣어 추척을 피하고싶다면

`git rm --cached` 명령을 이용하여 캐시를 다 지우고 

다시 `git add .` 명령을 해주자

[자세히](https://git-scm.com/docs/gitignore)



### git의 내장 GUI


### 콘솔에서 git output을 컬러로 출력하기

git config color.ui true
### 이력(log)에서 확정본 1개를 딱 한 줄로만 표시하기

git config format.pretty oneline
### 파일을 추가할 때 대화식으로 추가하기

git add -i

### 어떤상황에서 나가는 방법

:q!





# 심화

## Conflict 대부분 해결방법

[자세히](https://velog.io/@devmin/git-conflict-solution-basic)





## Clone 으로 받은 저장소에 브랜치로 이동하기

Git에서 Clone으로 저장소를 내려받으면 저장소에 저장된 브랜치들을 사용할 수 있습니다. 그러나 처음에 `git branch`로 확인하였을 때 브랜치들이 보이지 않습니다.

```
$ git branch
 * master
```

`-a` 옵션을 사용하면 브랜치들을 볼 수 있습니다.

```
$ git branch -a 
remotes/origin/HEAD -> origin/master
remotes/origin/draft
remotes/origin/master
```

만약 원하는 upstream 브랜치로 이동하고자 한다면 직접 Checkout 할 수 있습니다.

```
$ git checkout origin/draft

Note: checking out 'origin/draft'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b new_branch_name

HEAD is now at cff5802... 임시 저장
```

그러나 이 경우에서는 임시로 해당 브랜치로 이동하는 것이기 때문에 로컬 브랜치가 만들어지지 않습니다. 다음과 같이 사용하면 로컬 브랜치를 만들 수 있습니다.

```
$ git checkout -b draft origin/draft 
Branch draft set up to track remote branch draft from origin.
Switched to a new branch 'draft'

$ git branch
 * draft
   maste
```

브랜치 이름을 짓지 않고 remote 저장소에 브랜치 이름을 그대로 로컬 브랜치로 생성하고자 한다면 `git checkout` 명령어에 `-t` 또는 `--track` 옵션을 사용합니다.

```
$ git checkout --track origin/draft
Branch draft set up to track remote branch draft from origin.
Switched to a new branch 'draft'

$ git branch
 * draft
   master
```

# 오류

머지중에 conflict 

https://stackoverflow.com/questions/42174485/git-how-dangerous-is-deleted-by-us-conflict

