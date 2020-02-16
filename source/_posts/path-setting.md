---
title: 환경변수 활용법
date: 2020-02-13 18:02:48
categories: [Linux]
tags: [Basic, Linux]
---

# 환경 변수

환경변수에 등록된 경로는, 컴퓨터의 어떤 경로에서라도 접근(=실행) 할 수 있다.

```
환경변수 확인
$ echo $PATH   ($변수명 하면 호출됨)

$ echo AAA #AAA에 대한 환경변수값 확인

$ ls -la
.bash_profile 이라는 숨김 파일이 있는지 확인한다.

없을경우 생성
$ touch .bash_profile

있을 경우 파일 오픈
$ vi .bash_profile  -> vi를 통해 오픈
$ open .bash_profile  -> 에디터를 통해 오픈
```

## 환경 변수 경로 의미

```
export PATH=${PATH}  #$앞의 {PATH}의 경우 상위 Path

# 그리고 그 뒤에 다른 Path가 필요할 경우 {PATH}뒤에 : 적어서 경로를 이어줍니다.
export PATH="/Users/wefw/wgwe/erge/:$PATH" #기존의 PATH변수에있던 값들앞에 앞에 쓴 새로운 경로추가함

```

리눅스 환경은 `.bash_profile`,`.bashrc`에 설정해놓으면 되는데 

zsh를 쓰는 나의 환경에서는 iterms를 껏다 키면 $PATH 가 초기화되어 계속

```
source ~/.bash_profile
source ~/.bashrc
```

를 해서 zsh환경에서 실행할때마다 설정해줘야하는 문제가 발생했다

> 이유:
>
> YADR 즉 dotfiles는 zsh기반으로 동작하며
> zsh은 기존 linux, mac 시스템이 사용하는 ~/.bash_profile 파일의 설정을 따르지 않고
> ~/.zshrc 파일의 설정을 따릅니다.
> 따라서 기존 linux, mac 시스템에서 .bash_profile 파일에 등록한것과 같이 아래 형태로 환경변수를 정의하면 됩니다.



## oh-my-zsh

아래 파일들이 zsh가 참고하는 환경변수 파일이다.

여기에 원하는 환경변수들을 저장하면 항상 사용가능하다.

```
~/.zshrc
~/.zshenv
~/.zprofile
```

### zsh에 bash파일들에 있는 환경변수 자동추가하기

이미 .bash_profile 과 .bashrc 에 설정해놓은 path를 사용하기위해
source ~/.bash_profile
source ~/.bashrc
를 실행시키도록 설정했다

```
vi ~/.zprofile  #vi에디터로 .zprofile 을 열어 아래 명령을 추가 작성 및 저장
```

```
source ~/.bash_profile
source ~/.bashrc 
```

# 환경변수의 활용

SECRET_KEY 분리하기

settings.py 파일에서 비밀 값을 분리하는 방법은 여러가지가 있는데 책에서 소개하는 방법은 2가지이다.

- 환경변수패턴 : SECRET_KEY의 값을 환경변수에 저장하여 참고한다.
- 비밀파일패턴 : SECRET_KEY의 값을 별도 파일에 저장하여 참고한다.

## 환경변수패턴

환경변수란 프로세스가 컴퓨터에서 동작하는 방식에 영향을 미치는, 동적인 값들의 모임이다.([위키](https://ko.wikipedia.org/wiki/환경_변수)) 시스템의 실행파일이 놓여 있는 디렉토리의 지정 등 OS 상에서 동작하는 응용소프트웨어가 참조하기 위한 설정이 기록된다. 환경변수를 사용하여 비밀 키를 보관함으로써 걱정 없이 세팅파일을 github 공개 저장소에 추가할 수 있다.

로컬 개발 환경에서 환경 변수를 세팅하려면 다음 코드를 .bashrc 혹은 .bash_profile, .profile, .zshrc 파일에 추가하면 된다. 어느 종류의 shell을 사용하는지에 따라서 편집하는 파일이 달라진다.(mac 사용자 기준) 나의 경우 [zsh](http://ohmyz.sh/)을 사용하고 있어서 .zshrc에 아래와 같이 환경변수 추가 작업을 진행했다.

```
$ vim ~/.zshrc # vim을 사용하여 .zshrc 파일을 편집하겠다.

# .zshrc 파일에 아래 코드를 추가해준다.
export INSTA_SECRET_KEY='b_4(!id8ro!1645n@ub55555hbu93gaia0 본인의 고유 비밀 키 추가'

# 환경변수 확인 명령
$ echo $INSTA_SECRET_KEY
```

추가 완료 후, settings.py 파일을 열어서 SECRET_KEY 의 값을 삭제하고 환경변수로 대체한다.

```
# settings.py
import os


# 환경변수 INSTA_SECRET_KEY 의 값을 참조한다.
SECRET_KEY = os.environ["INSTA_SECRET_KEY"]
```

혹은 아래와 같은 예외 처리를 통해서 환경변수가 존재하지 않을 때 원인을 파악하기 쉽도록 할 수 있다.

```
# settings.py
import os
from django.core.exceptions import ImproperlyConfigured


def get_env_variable(var_name):
  """환경 변수를 가져오거나 예외를 반환한다."""
  try:
    return os.environ[var_name]
  except KeyError:
    error_msg = "Set the {} environment variable".format(var_name)
    raise ImproperlyConfigured(error_msg)


SECRET_KEY = get_env_variable("INSTA_SECRET_KEY")
```

쉘에서 python3 manage.py runserver 명령을 입력하니 정상적으로 개발 서버가 구동되는 것을 확인 할 수 있었다. 참고로 실제 운영환경에서 환경변수를 세팅하려면, 각자 사용하는 배포도구에 따라서 변수 지정방법이 달라진다.

------

## 비밀파일패턴

환경변수는 경우에 따라 적용되지 않을 수 있다. (아파치를 웹 서버로 이용하는 등) 이럴 경우에는 JSON 파일에 비밀 키 정보를 입력하고, settings.py에서 참고하도록 설정할 수 있다. 우선 아래와 같이 **secrets.json** 파일을 작성한다. (주의 - 이어지는 항목이 없는 경우, 쌍따옴표 뒤에 콤마(,)를 입력해서는 안된다. python git 갱신이력을 깔끔하게 관리하려고 dictionary 마지막 항목에도 콤마를 추가하는 습관이 있어서 그대로 적용했더니 json에서는 오류가 발생했다.)

```
{
  "SECRET_KEY": "b_4(!id8ro!1645n@ub55555hbu93gaia0 본인의 고유 비밀 키 추가"
}
```

작성한 secrets.json 파일은 버전관리 시스템에 저장되지 않도록 **.gitignore** 문서에 추가한다. 그리고 해당 파일을 SECRET_KEY 값으로 참고하기 위해서 다음 코드를 settings.py에 추가한다.

```
# settings.py

import os, json
from django.core.exceptions import ImproperlyConfigured


secret_file = os.path.join(BASE_DIR, 'secrets.json') # secrets.json 파일 위치를 명시

with open(secret_file) as f:
    secrets = json.loads(f.read())

def get_secret(setting, secrets=secrets):
    """비밀 변수를 가져오거나 명시적 예외를 반환한다."""
    try:
        return secrets[setting]
    except KeyError:
        error_msg = "Set the {} environment variable".format(setting)
        raise ImproperlyConfigured(error_msg)

SECRET_KEY = get_secret("SECRET_KEY")
```

쉘에서 python3 manage.py runserver 명령을 입력하니 이 방법을 사용해도 정상적으로 개발 서버가 구동되는 것을 확인 할 수 있었다.

------

# 결론

AWS 루트키가 github 공개 저장소에 추가되면 악용되어서 요금폭탄을 맞을 수도 있다는 이야기는 많이 들어보았다. 하지만 settings에 대해서는 비교적 신경을 쓰지 못했다. Django 초보라면 대부분 SECRET_KEY를 본인의 공개 저장소에 올려본 경험은 있지 않을까? 물론 배포 전에 변경하고 분리하는 것이 가능 하지만, 그에 따른 부작용이 발생 할 수 있으니 처음부터 관리하는게 좋겠다. 앞으로 first commit 이전에 SECRET_KEY를 환경변수 혹은 json 파일로 분리하거나, 초반에는 .gitignore 파일에 settings.py 파일을 추가해 놓는 것도 괜찮겠다는 생각을 했다.

# 출처

[oh-my-zsh 사용시 환경변수 (path) 설정하기](http://blog.naver.com/loverman85/221265795874)

