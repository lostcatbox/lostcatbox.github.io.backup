---
title: Elastic Beanstalk
date: 2020-02-06 15:41:25
categories: [Elastic Beanstalk]
tags: [Basic, Elastic Beanstalk, AWS]
---

# Elastic Beanstalk

## EB CLI 명령어 정리

```
eb init #  EB CLI를 사용하여 만든 애플리케이션의 기본값을 설정(init의 설정한 값은 현재 디렉터리와 리포지토리에만 적용됩니다)

eb init -i #  EB CLI를 사용하여 만든 애플리케이션의 기본값을 수정

eb create # 환경을 생성.

eb status # 환경의 현재 상태를 확인, red가 뜬다면 로드벨런스 체크해야한다

eb health # 환경 전반의 상태와 환경의 인스턴스에 대한 상태 정보 확인, 

eb events # 이벤트 목록 출력

eb logs # 환경의 인스턴스에서 로그를 가져옵니다. red에서 로드벨런스ip주소 allowedhost추가하기

eb open # 브라우저로 웹 사이트 열림

eb deploy # 서버에 올림. 프로젝트 폴더의 git 리포지토리를 초기화한 경우, 대기 중인 변경 사항이 있더라도 EB CLI가 항상 최신 커밋을 배포합니다. eb deploy를 실행하기 전에 변경 사항을 커밋하여 이를 환경에 배포합니다.

eb config # 실행 중인 환경에 사용 가능한 구성 옵션을 봅니다.

eb terminate # 환경을 종료합니다. 프로젝트 작동 종료.



```

>Tip: .gitignore에서 숨기고싶은 파일을 등록하면 eb deploy하는중에서도 .gitignore를 참고하여버려서 원하는 값이 적절한 코드에 들어가지않을수있다. 
>
>이때는 .ebignore 파일을 만들어주면 .ebignore파일이 있을시 EB CLI는 .gitignore파일을 참조하지 않으므로 적절한 해결이 될수있다. 
>
>

다른 오류시 참조: https://coding-dahee.tistory.com/75

애플리케이션을 빠르고 쉽게 **배포**하고, **모니터링**하고, **확장**할 수 있습니다. [참고](https://aws.amazon.com/ko/elasticbeanstalk/)

![clearbox-flow-00](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/images/clearbox-flow-00.png)

- 장점

  - 빠르고 간편한 배포

    (Beanstalk가 용량 프로비저닝, 로드 밸런싱, Auto Scaling, 애플리케이션 상태 모니터링에 대한 배포 정보를 자동으로 처리합니다.)

  - 개발자 생산성올라감

    (사용자 대신 인프라를 __provisioning__하고 운영할 뿐만 아니라 애플리케이션 스택(플랫폼)을 관리해줌)

    (따라서 서버, 데이터베이스, 로드 밸런서, 방화벽, 네트워크 등을 관리하고 구성하는 시간이 없음)

  - 완벽한 리소스 제어

## 시작하기전

### Elastic Beanstalk 개념

- 애플리케이션

  Elastic Beanstalk *애플리케이션*은 *환경*, *버전* 및 *환경 구성*을 포함한 Elastic Beanstalk 구성 요소의 논리적 컬렉션입니다. Elastic Beanstalk에서 애플리케이션은 개념적으로 폴더와 유사합니다.

- 애플리케이션 버전

  Elastic Beanstalk에서 *애플리케이션 버전*은 웹 애플리케이션의 배포 가능한 코드의 레이블 지정된 특정 반복을 나타냅니다. 애플리케이션 버전은 Java WAR 파일 등의 배포 가능한 코드가 포함된 Amazon Simple Storage Service(Amazon S3) 객체를 가리킵니다.

  따라서 구버전과 신버전 둘다 돌리면서 테스트 해볼수도있다.

- 환경

  *환경*은 애플리케이션 버전을 실행 중인 AWS 리소스 모음입니다.

  각 환경은 한 번에 하나의 애플리케이션 버전만 실행하지만 여러 환경에서 동일한 애플리케이션 버전 또는 서로 다른 애플리케이션 버전을 동시에 실행할 수 있습니다. 환경을 생성하면 Elastic Beanstalk에서 사용자가 지정한 애플리케이션 버전을 실행하는 데 필요한 리소스를 프로비저닝합니다.

- 환경 티어

  Elastic Beanstalk 환경을 시작할 때 먼저 환경 티어를 선택합니다. 환경 티어는 환경에서 실행하는 애플리케이션 유형을 지정하고 Elastic Beanstalk에서 이러한 애플리케이션을 지원하기 위해 프로비저닝하는 리소스를 결정합니다.

  HTTP 요청을 처리하는 애플리케이션은 [웹 서버 환경 티어](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/concepts-webserver.html)에서 실행됩니다. Amazon Simple Queue Service(Amazon SQS) 대기열에서 작업을 가져오는 환경은 [작업자 환경 티어](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/concepts-worker.html)에서 실행됩니다.

- 환경 구성

  *환경 구성*은 환경 및 연관된 리소스의 작동 방법을 정의하는 파라미터 및 설정의 모음을 식별합니다. 환경의 구성 설정을 업데이트하면 Elastic Beanstalk가 자동으로 기존 리소스에 변경 사항을 적용하거나, 삭제하고 새 리소스를 배포합니다(변경 유형에 따라 다름).

- 저장된 구성

  *저장된 구성*은 고유한 환경 구성을 생성하기 위한 시작점으로 사용할 수 있는 템플릿입니다. Elastic Beanstalk 콘솔, EB CLI, AWS CLI 또는 API를 사용하여 저장된 구성을 생성 및 수정하고 환경에 적용할 수 있습니다. API 및 AWS CLI는 저장된 구성을 *구성 템플릿*으로 참조합니다.

- 플랫폼

  플랫폼은 운영 체제(OS), 프로그래밍 언어 실행 시간, 웹 서버, 애플리케이션 서버 및 Elastic Beanstalk 구성 요소의 조합입니다. 플랫폼을 대상으로 하는 웹 애플리케이션을 설계합니다. Elastic Beanstalk는 애플리케이션을 구축할 수 있는 다양한 플랫폼을 제공합니다

## 시작하기 

### [Elastic Beanstalk에 접속 및 만들기](https://us-east-2.console.aws.amazon.com/elasticbeanstalk/home?region=us-east-2#/applications)

- 필요 요소나 리소스 업로드하고 시작(예제는 **GettingStartedApp**이름으로 시작)

### 환경 살펴보기

- 콘솔에서 환경 대시보드 볼려면 __<myprojectname>__-env를 선택
- URL, 현재 상태, 현재 배포된 애플리케이션 버전의 이름, 최근 이벤트 다섯 개, 애플리케이션이 실행 중인 플랫폼 버전이 포함됩니다.
- Elastic Beanstalk에서 AWS 리소스를 만들고 애플리케이션을 시작하는 동안 환경은 `Pending` 상태에 있습니다. 시작 이벤트에 대한 상태 메시지가 대시보드에 지속적으로 추가됩니다.
- 환경의 **URL**은 대시보드의 오른쪽 상단에 있는 **작업** 메뉴 옆에 있습니다. 이것은 환경이 실행 중인 웹 애플리케이션의 URL입니다. 이 URL을 선택해 예제 애플리케이션의 *구성* 페이지로 이동합니다.
- 콘솔의 왼쪽에 있는 탐색 페이지는 환경에 대한 더 자세한 정보가 포함되어 있으며 추가 기능에 액세스할 수 있는 다른 페이지로 연결합니다
  - **구성** – 애플리케이션을 호스팅하는 Amazon Elastic Compute Cloud(Amazon EC2) 인스턴스 등 이 환경에 대해 프로비저닝된 리소스가 표시됩니다. 이 페이지에서 일부 프로비저닝된 리소스를 구성할 수 있습니다.
  - **상태** – 애플리케이션을 실행하는 Amazon EC2 인스턴스에 대한 상태와 세부 상태 정보가 표시됩니다.
  - **모니터링** – 평균 지연 시간 및 CPU 사용률 등 환경에 대한 통계가 표시됩니다. 이 페이지를 사용하여 모니터링 중인 측정치에 대한 경보를 만들 수 있습니다.
  - **이벤트** – 이 환경에서 사용하는 Elastic Beanstalk 서비스 및 리소스가 있는 다른 서비스의 정보 또는 오류 메시지를 표시합니다.
  - **태그** – 환경 태그를 표시하고 관리할 수 있습니다. 태그는 환경에 적용되는 키-값 쌍입니다.

### 새 버전의 애플리케이션 배포

주기적으로 새 버전의 애플리케이션을 배포해야 할 수도 있습니다. 환경에서 다른 업데이트 작업이 진행 중이지 않은 한 언제든지 새 버전을 배포할 수 있습니다.

이 자습서로 시작한 애플리케이션 버전을 **Sample Application**이라고 합니다.

### 환경 구성

애플리케이션에 더 적합하도록 환경을 구성할 수 있습니다. 예를 들어 컴퓨팅 집약적인 애플리케이션이 있는 경우 애플리케이션을 실행 중인 Amazon Elastic Compute Cloud(Amazon EC2) 인스턴스의 유형을 변경할 수 있습니다. 구성 변경을 적용하기 위해 Elastic Beanstalk는 환경 업데이트를 수행합니다.

일부 구성은 변경이 간단하고 빠르게 처리되지만 일부 변경의 경우 AWS 리소스를 삭제한 후 다시 만들어야 하며, 여기에는 몇 분 정도 걸릴 수 있습니다. 구성 설정을 변경하면 Elastic Beanstalk는 잠재적 인 애플리케이션 중단 시간에 대해 경고합니다.

#### 구성 변경

이 구성 변경 예에서는 환경의 용량 설정을 편집합니다. Auto Scaling 그룹에 2 ~ 4개의 Amazon EC2 인스턴스가 있고 로드 밸런싱 수행 및 자동 조정 환경을 구성한 다음 변경이 발생했는지 확인합니다. Elastic Beanstalk는 추가 Amazon EC2 인스턴스를 생성하여 처음 생성한 단일 인스턴스에 추가합니다. 그런 다음 Elastic Beanstalk는 두 인스턴스를 환경의 로드 밸런서와 연결합니다. 결과적으로 애플리케이션의 응답성이 향상되고 가용성이 향상됩니다.

# Elastic Beanstalk에서의 사용을 위한 개발 머신 구성

[참고](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/chapter-devenv.html#devenv-project-folder)

AWS Elastic Beanstalk 애플리케이션 개발을 위해 로컬 시스템을 설정하는 방법을 보여 줍니다. 또한 폴더 구조, 소스 제어 및 CLI 도구를 살펴봅니다.

## 프로젝트 폴더 만들기

여러 애플리케이션에서 작업하려는 경우 workspace나 projects 프로젝트별로 폴더만들고 프로젝트 폴더의 내용은 애플리케이션들로 구성되어있어야함. ('', ""는 사용하지말것)

## 소스 컨트롤 설정

실수로 프로젝트 폴더 내의 파일 또는 코드를 삭제하기 않도록 하고 프로젝트를 중단시키는 변경 사항을 되돌리기 위한 방법으로 소스 컨트롤을 설정합니다. git 사용

## 원격 리포지토리 구성

하드 드라이브가 충돌하거나 다른 컴퓨터에 있는 프로젝트에 대해 작업하려는 경우 어떻게 하시겠습니까? 소스 코드를 온라인으로 백업하고 임의의 컴퓨터에서 이 코드에 액세스하려면 커밋을 푸시할 수 있는 원격 리포지토리를 구성합니다.

AWS CodeCommit을 사용하면 AWS 클라우드에서 프라이빗 리포지토리를 생성할 수 있습니다. CodeCommit는 [AWS 프리 티어](https://aws.amazon.com/free/)에서 계정 내 최대 5명의 AWS Identity and Access Management(IAM) 사용자에 대해 무료로 사용할 수 있습니다.

GitHub는 프로젝트 코드를 온라인으로 저장할 수 있는 널리 사용되는 또 다른 옵션입니다. GitHub를 사용하면 퍼블릭 온라인 리포지토리를 무료로 생성하고 GitHub는 월별 요금으로 프라이빗 리포지토리를 지원합니다

프로젝트를 위한 원격 리포지토리를 생성한 후에는 `git remote add`를 사용하여 로컬 리포지토리에 연결합니다.

## EB CLI 설치

[EB CLI](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/eb-cli3.html)를 사용하여 명령줄에서 Elastic Beanstalk 환경을 관리하고 상태를 모니터링합니다. 설치 지침은 [EB CLI 설치](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/eb-cli3-install.html)를 참조하십시오.

기본적으로 EB CLI는 프로젝트 파일의 내용을 모두 패키지로 묶어 Elastic Beanstalk에 소스 번들로 업로드합니다. Git과 EB CLI를 함께 사용하는 경우 `.gitignore`를 사용하여 내장 클래스 파일이 소스로 커밋되지 않도록 방지하고 `.ebignore`를 사용하여 소스 파일이 배포되지 않도록 방지할 수 있습니다.

또한 프로젝트 폴더의 콘텐츠 대신 [빌드 아티팩트(WAR 또는 ZIP 파일)를 배포하도록 EB CLI를 구성](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/eb-cli3-configuration.html#eb-cli3-artifact)할 수도 있습니다

### Clone this repository

Use the following:

```
brew install awscli #brew추천함 환경변수따로 추가안해도됨
```

Tip: 만약 pip 로 깔았다면 아래 답변을 참고하자

> 환경 변수조회
>
> ```
> #조회 
> echo $PATH
> #적용
> source ~/.bash_profile
> 
> ```
>
> 
>
> 명령을 실행할 때 : `pip3 install awscli --upgrade --user`
>
> AWS CLI 도구가 설치되는 위치를 자세히 살펴보면 터미널 로그의 경로를 볼 수 있습니다. 제 경우에는 다음과 같은 것이 있습니다.
>
> ```
> awscli in ./Library/Python/3.6/lib/python/site-packages
> ```
>
> 이제 다음과 같이 .bash_profile에 bin 폴더 (lib 경로에서 제거하고 대신 bin 경로를 넣음)에 동일한 경로를 추가해야합니다.
>
> ```
> export PATH=/Users/xuser/Library/Python/3.6/bin/:$PATH
> ```

Tip: 과정중 brew권한 이슈, zlip, awsebcli istall등 해줘야하는게많다. 오류를 따라가서 필요한 프로그램 설치해주자. brew로 수동설치해주는것도 방법임.

```
You can install Python packages with
  /usr/local/opt/python@3.8/bin/pip3 install <package>
They will install into the site-package directory
  /usr/local/opt/python@3.8/Frameworks/Python.framework/Versions/3.8/lib/python3.8/site-packages

See: https://docs.brew.sh/Homebrew-and-Python

python@3.8 is keg-only, which means it was not symlinked into /usr/local,
because this is an alternate version of another formula.

If you need to have python@3.8 first in your PATH run:
  echo 'export PATH="/usr/local/opt/python@3.8/bin:$PATH"' >> ~/.zshrc

For compilers to find python@3.8 you may need to set:
  export LDFLAGS="-L/usr/local/opt/python@3.8/lib"

For pkg-config to find python@3.8 you may need to set:
  export PKG_CONFIG_PATH="/usr/local/opt/python@3.8/lib/pkgconfig"

```



## AWS CLI 설치

AWS 명령줄 인터페이스(AWS CLI)는 모든 퍼블릭 API 작업을 위한 명령을 제공하는 AWS 서비스용 통합 클라이언트입니다. 이러한 명령은 EB CLI에서 제공하는 명령보다 수준이 낮기 때문에 AWS CLI에서 작업을 수행하려면 일반적으로 명령을 더 사용합니다. 다시 말해, AWS CLI에서는 로컬 머신에서 리포지토리를 설정하지 않고 계정에서 실행 중인 애플리케이션 또는 환경으로 작업할 수 있습니다. AWS CLI를 사용하여 작업을 간소화 또는 자동화하는 스크립트를 생성합니다.

AWS CLI는 Amazon S3에서 효율적으로 파일을 보내고 받을 수 있는 간단한 새 [파일 명령](https://aws.amazon.com/ko/cli/#file_commands_anchor) 세트를 제공합니다.

```
brew install awscli
```

## .ebignore를 사용하여 파일 무시

`.ebignore` 파일을 프로젝트 디렉터리에 추가하여 EB CLI가 디렉터리의 특정 파일을 무시하도록 명령할 수 있습니다. 이 파일은 `.gitignore` 파일처럼 작동합니다. 프로젝트 디렉터리를 Elastic Beanstalk에 배포하고 새 애플리케이션 버전을 생성하는 경우 EB CLI에는 이렇게 생성되는 소스 번들의 `.ebignore`에서 지정된 파일이 포함되지 않습니다.

`.ebignore`가 없고 `.gitignore`가 있는 경우 EB CLI는 `.gitignore`에 지정된 파일을 무시합니다. `.ebignore`가 있으면 EB CLI는 `.gitignore`를 읽지 않습니다.

`.ebignore`가 있으면 EB CLI는 git 명령을 사용하여 소스 번들을 생성하지 않습니다. 즉 EB CLI는 `.ebignore`에 지정된 파일을 무시하고 다른 모든 파일을 포함시킵니다. 특히 커밋되지 않은 소스 파일을 포함시킵니다.

[나머지 eb cli사용법](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/eb-cli3-getting-started.html)

# Python 개발환경 설정

[참고](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/python-development-environment.html)

AWS Elastic Beanstalk로 배포하기 전에 로컬에서 애플리케이션을 테스트하도록 Python 개발 환경을 설정합니다. 

`python3 -m venv myvenv`  (가상환경 생성)

## Elastic Beanstalk에 대해 Python 프로젝트 구성

Elastic Beanstalk CLI를 사용하여 Elastic Beanstalk에 배포하도록 Python 애플리케이션을 준비할 수 있습니다.

**Elastic Beanstalk에 배포하도록 Python 애플리케이션을 구성하려면**

1. [가상 환경](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/python-development-environment.html#python-common-setup-venv)에서 프로젝트 디렉터리 트리(`python_eb_app`)의 상단으로 돌아가 다음을 입력합니다.

   ```
   pip freeze >requirements.txt #필수파일
   ```

   이 명령은 가상 환경에 설치된 패키지의 이름과 버전을 requirements.txt로 복사합니다. 예를 들어 *PyYAML*의 경우 *3.11*은 가상 환경에 설치되며 파일에는 다음 행이 포함됩니다.

   ```
   PyYAML==3.11
   ```

   애플리케이션을 개발하고 테스트하는 데 사용하는 동일한 패키지와 버전을 통해 Elastic Beanstalk는 애플리케이션의 Python 환경을 복제할 수 있습니다.

2. **eb init** 명령으로 EB CLI 리포지토리를 구성합니다. 프롬프트 메시지에 따라 리전, 플랫폼 및 기타 옵션을 선택합니다. 자세한 지침은 [EB CLI를 사용하여 Elastic Beanstalk 환경 관리](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/eb-cli3-getting-started.html) 단원을 참조하십시오.

기본적으로 Elastic Beanstalk는 `application.py`라는 파일을 찾아 애플리케이션을 시작합니다. 이 파일이 생성한 Python 프로젝트에 존재하지 않는 경우, 애플리케이션 환경을 일부 조정해야 합니다. 또한 애플리케이션의 모듈을 로드할 수 있도록 환경 변수를 설정해야 합니다. 자세한 내용은 [Elastic Beanstalk Python 플랫폼 사용](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/create-deploy-python-container.html) 섹션을 참조하십시오.



## Django 

__가상환경 만들어 시작__

## Elastic Beanstalk에 맞게 Django 애플리케이션 구성

이제 로컬 시스템에 Django 기반 사이트가 있으므로 Elastic Beanstalk에 배포하도록 이를 구성할 수 있습니다.

기본적으로 Elastic Beanstalk는 `application.py`라는 파일을 찾아 애플리케이션을 시작합니다. 이 파일은 생성한 Django 프로젝트에는 존재하지 않기 때문에 애플리케이션 환경을 약간 조정해야 합니다. 또한 애플리케이션의 모듈을 로드할 수 있도록 환경 변수를 설정해야 합니다.

**Elastic Beanstalk에 맞게 사이트를 구성하려면**

1. 가상 환경을 활성화합니다.

2. `pip freeze`를 실행한 다음 이름이 `requirements.txt`인 파일에 출력을 저장합니다.

3. `pip freeze`를 실행한 다음 이름이 `requirements.txt`인 파일에 출력을 저장합니다.

4. `.ebextensions`이라는 디렉터리를 생성합니다.

5. `.ebextensions` 디렉터리 내에서 다음 텍스트가 있는 `django.config`라는 [구성 파일](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/ebextensions.html)을 추가합니다.

   예) __~/ebdjango/.ebextensions/django.config__ 

6. 이 설정 `WSGIPath`는 Elastic Beanstalk가 애플리케이션을 시작하는 데 사용하는 WSGI 스크립트의 위치를 지정합니다.

7. 가상환경 비활성화

### EB CLI를 사용하여 사이트 배포

Elastic Beanstalk에 애플리케이션을 배포하기 위해 필요한 모든 항목을 추가했습니다. 프로젝트 디렉터리가 이제 다음과 같을 것입니다.

```
~/ebdjango/
|-- .ebextensions
|   `-- django.config
|-- ebdjango
|   |-- __init__.py
|   |-- settings.py
|   |-- urls.py
|   `-- wsgi.py
|-- db.sqlite3
|-- manage.py
`-- requirements.txt
```

다음으로 애플리케이션 환경을 생성하고 Elastic Beanstalk에 구성된 애플리케이션을 배포합니다.

배포 즉시 Django의 구성을 편집해 Elastic Beanstalk가 Django `ALLOWED_HOSTS`의 사용자 애플리케이션에 할당한 도메인 이름을 추가합니다. 그리고 애플리케이션을 다시 배포합니다. 이는 HTTP `Host` 헤더 공격을 방지할 수 있도록 설계된 Django의 보안 요구 사항입니다. 자세한 내용은 [호스트 헤더 검증](https://docs.djangoproject.com/en/2.1/topics/security/#host-headers-virtual-hosting)을 참조하십시오.





**환경을 생성하고 Django 애플리케이션을 배포하려면**

**참고**

이 자습서에서는 EB CLI를 배포 메커니즘으로 사용하지만, Elastic Beanstalk 콘솔을 사용하여 프로젝트의 콘텐츠를 포함하는 .zip 파일을 배포할 수도 있습니다.

1. **eb init** 명령으로 EB CLI 리포지토리를 초기화합니다.

   ```
   ~/ebdjango$ eb init -p python-3.6 django-tutorial
   Application django-tutorial has been created.
   ```

   이 명령은 `django-tutorial`이라는 애플리케이션을 생성합니다. 이 명령은 또한 최신 Python 3.6 플랫폼 버전을 통해 환경을 생성하도록 로컬 리포지토리를 구성합니다.

2. (선택 사항) SSH를 통해 애플리케이션을 실행하는 EC2 인스턴스에 연결할 수 있도록 **eb init**를 다시 실행하여 기본 키 페어를 구성합니다.

   ```
   ~/ebdjango$ eb init
   Do you want to set up SSH for your instances?
   (y/n): y
   Select a keypair.
   1) my-keypair
   2) [ Create new KeyPair ]
   ```

   키 페어가 이미 있는 경우 이를 선택하거나, 프롬프트에 따라 키 페어를 생성합니다. 프롬프트가 보이지 않거나 나중에 설정을 변경해야 하는 경우 **eb init -i**를 실행합니다.

3. 환경을 만들고 **eb create**로 해당 환경에 애플리케이션을 배포합니다.

   ```
   ~/ebdjango$ eb create django-env
   ```

   **참고**

   "service role required" 오류 메시지가 표시되면 `eb create`를 대화식으로 실행하고(환경 이름을 지정하지 않고) EB CLI가 사용자 대신 역할을 생성하도록 합니다.

   이 명령은 이름이 `django-env`인 로드 밸런싱된 Elastic Beanstalk 환경을 생성합니다. 환경을 생성하는 데 약 5분이 걸립니다. Elastic Beanstalk는 애플리케이션을 실행하는 데 필요한 리소스를 생성하면서 EB CLI가 터미널에 전달하는 정보 메시지를 출력합니다.

4. 환경 생성 프로세스가 완료되면, **eb status**를 실행해 새 환경의 도메인 이름을 찾습니다.

   ```
   ~/ebdjango$ eb status
   Environment details for: django-env
     Application name: django-tutorial
     ...
     CNAME: eb-django-app-dev.elasticbeanstalk.com
     ...
   ```

   사용자 환경의 도메인 이름은 `CNAME` 속성의 값입니다.

5. `settings.py` 디렉터리에 있는 `ebdjango` 파일을 엽니다. `ALLOWED_HOSTS` 설정을 찾은 다음 이전 단계에 찾은 애플리케이션 도메인 이름을 설정 값에 추가합니다. 파일에서 이 설정을 찾을 수 없는 경우 새로운 줄로 추가합니다.

   ```
   ...
   ALLOWED_HOSTS = ['eb-django-app-dev.elasticbeanstalk.com']
   ```

6. 파일을 저장한 후 **eb deploy**를 실행해 애플리케이션을 배포합니다. **eb deploy**를 실행하면 EB CLI가 프로젝트 디렉터리의 콘텐츠를 번들링한 후 이를 환경에 배포합니다.

   ```
   ~/ebdjango$ eb deploy
   ```

   **참고**

   프로젝트에 Git을 사용할 경우 [EB CLI와 Git 사용](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/eb3-cli-git.html) 단원을 참조하십시오.

7. 환경 업데이트 프로세스가 완료되면 **eb open**으로 웹 사이트를 엽니다.

   ```
   ~/ebdjango$ eb open
   ```

   그러면 애플리케이션에 대해 생성된 도메인 이름을 사용하여 브라우저 창이 열립니다. 로컬에서 만들고 테스트한 것과 동일한 Django 웹 사이트가 보일 것입니다.

   ![             Elastic Beanstalk에 배포된 Django 웹사이트 시작 페이지           ](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/images/eb_django_deployed.png)

실행 중인 애플리케이션이 보이지 않거나 오류 메시지를 받은 경우, [배포 문제 해결](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/troubleshooting-deployments.html)에서 오류의 원인을 확인하는 방법에 대한 도움말을 보십시오.

실행 중인 애플리케이션이 *보이면* 성공한 것입니다. Elastic Beanstalk에 첫 Django 애플리케이션을 배포했습니다.

## 애플리케이션 업데이트

이제 Elastic Beanstalk에서 실행 중인 애플리케이션이 있으므로 애플리케이션 또는 그 구성을 업데이트하고 다시 배포할 수 있습니다. Elastic Beanstalk에서 인스턴스를 업데이트하고 새 애플리케이션 버전을 시작하는 작업을 처리합니다.

이 예제에서는 Django의 관리자 콘솔을 활성화하고 몇 가지 설정을 구성합니다.

### 사이트 설정 수정

기본적으로 Django 웹 사이트에서는 UTC 시간대를 사용하여 시간을 표시합니다. `settings.py`에서 시간대를 지정하여 이를 변경할 수 있습니다.

**사이트의 시간대를 변경하려면**

1. `settings.py`에서 `TIME_ZONE` 설정을 수정합니다.

   **예 ~/ebdjango/ebdjango/settings.py**

   ```
   ...
   # Internationalization
   LANGUAGE_CODE = 'en-us'
   TIME_ZONE = 'US/Pacific'
   USE_I18N = True
   USE_L10N = True
   USE_TZ = True
   ```

   시간대 목록은 [이 페이지](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)를 참조하십시오.

2. 애플리케이션을 Elastic Beanstalk 환경에 배포합니다.

   ```
   ~/ebdjango/$ eb deploy
   ```

### 사이트 관리자 생성

Django 애플리케이션의 사이트 관리자를 생성하여 웹 사이트에서 직접 관리 콘솔에 액세스할 수 있습니다. 관리자 로그인 세부 정보는 Django가 생성하는 기본 프로젝트에 포함된 로컬 데이터베이스 이미지에 안전하게 저장됩니다.

**사이트 관리자를 생성하려면**

1. Django 애플리케이션의 로컬 데이터베이스를 초기화합니다.

   ```
   (eb-virt) ~/ebdjango$ python manage.py migrate
   Operations to perform:
     Apply all migrations: admin, auth, contenttypes, sessions
   Running migrations:
     Applying contenttypes.0001_initial... OK
     Applying auth.0001_initial... OK
     Applying admin.0001_initial... OK
     Applying admin.0002_logentry_remove_auto_add... OK
     Applying admin.0003_logentry_add_action_flag_choices... OK
     Applying contenttypes.0002_remove_content_type_name... OK
     Applying auth.0002_alter_permission_name_max_length... OK
     Applying auth.0003_alter_user_email_max_length... OK
     Applying auth.0004_alter_user_username_opts... OK
     Applying auth.0005_alter_user_last_login_null... OK
     Applying auth.0006_require_contenttypes_0002... OK
     Applying auth.0007_alter_validators_add_error_messages... OK
     Applying auth.0008_alter_user_username_max_length... OK
     Applying auth.0009_alter_user_last_name_max_length... OK
     Applying sessions.0001_initial... OK
   ```

2. `manage.py createsuperuser`를 실행하여 관리자를 생성합니다.

   ```
   (eb-virt) ~/ebdjango$ python manage.py createsuperuser
   Username: admin
   Email address: me@mydomain.com
   Password: ********
   Password (again): ********
   Superuser created successfully.
   ```

3. 정적 파일을 저장할 위치를 Django에 알리려면 `settings.py`에서 `STATIC_ROOT`를 정의합니다.

   **예 ~/ebdjango/ebdjango/settings.py**

   ```
   # Static files (CSS, JavaScript, Images)
   # https://docs.djangoproject.com/en/2.1/howto/static-files/
   STATIC_URL = '/static/'
   STATIC_ROOT = 'static'
   ```

4. `manage.py collectstatic`을 실행하여 `static` 디렉터리를 관리자 사이트의 정적 자산(javascript, CSS, 이미지)으로 채웁니다.

   ```
   (eb-virt) ~/ebdjango$ python manage.py collectstatic
   119 static files copied to ~/ebdjango/static
             
   ```

5. 애플리케이션 배포

   ```
   ~/ebdjango$ eb deploy
   ```

   

6. 다음과 같이 사이트 URL에 `/admin/`을 추가하여 브라우저에서 사이트를 열어 관리 콘솔을 봅니다.

   ```
   http://djang-env.p33kq46sfh.us-west-2.elasticbeanstalk.com/admin/
   ```

   ![               2단계에서 생성한 사용자 이름과 암호를 입력하여 관리 콘솔에 로그인합니다.             ](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/images/eb_django_admin_login.png)

7. 2단계에서 구성한 사용자 이름과 암호로 로그인합니다.

   ![               Elastic Beanstalk에 배포된 Django 웹사이트의 Django 관리 콘솔             ](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/images/eb_django_admin_console.png)

로컬 업데이트/테스트와 비슷한 절차를 사용할 수 있으며, 그 다음 **eb deploy**를 수행합니다. Elastic Beanstalk에서 라이브 서버를 업데이트하는 작업을 처리하므로 서버 관리 대신에 애플리케이션 개발에 집중할 수 있습니다.

### 데이터베이스 마이그레이션 구성 파일 추가

사이트가 업데이트될 때 실행할 `.ebextensions` 스크립트에 명령을 추가할 수 있습니다. 이를 통해 데이터베이스 마이그레이션을 자동으로 생성할 수 있습니다.

**애플리케이션을 배포할 때 마이그레이션 단계를 추가하려면**

1. 다음 콘텐츠가 포함된 `db-migrate.config`라는 이름의 [구성 파일](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/ebextensions.html)을 추가합니다.

   **예 ~/ebdjango/.ebextensions/db-migrate.config**

   ```
   container_commands:
     01_migrate:
       command: "django-admin.py migrate"
       leader_only: true
   option_settings:
     aws:elasticbeanstalk:application:environment:
       DJANGO_SETTINGS_MODULE: ebdjango.settings
   ```

   이 구성 파일은 애플리케이션을 시작하기 전에 배포 프로세스 중에 `django-admin.py migrate` 명령을 실행합니다. 이는 애플리케이션 시작 전에 실행되므로 `DJANGO_SETTINGS_MODULE` 환경 변수를 명시적으로 구성해야 합니다(일반적으로 `wsgi.py`는 시작 중에 이를 처리). 명령에서 `leader_only: true`를 지정하면 여러 인스턴스에 배포할 때 한 번만 실행됩니다.

2. 애플리케이션 배포

   ```
   ~/ebdjango$ eb deploy
   ```

## 정리

개발 세션 사이에 인스턴스 시간과 여러 AWS 리소스를 저장하려면 **eb terminate**를 사용하여 Elastic Beanstalk 환경을 종료합니다.

```
~/ebdjango$ eb terminate django-env
```

이 명령은 환경과 그 안에서 실행되는 모든 AWS 리소스를 종료합니다. 그러나 애플리케이션은 삭제되지 않으므로 **eb create**를 다시 실행하여 동일한 구성의 더 많은 환경을 언제든 생성할 수 있습니다. EB CLI 명령에 대한 자세한 내용은 [EB CLI를 사용하여 Elastic Beanstalk 환경 관리](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/eb-cli3-getting-started.html) 단원을 참조하십시오.

샘플 애플리케이션 사용을 마치면 프로젝트 폴더와 가상 환경을 제거할 수 있습니다.

```
~$ rm -rf ~/eb-virt
~$ rm -rf ~/ebdjango
```

## 다음 단계

심화 자습서를 포함해 Django에 대한 자세한 내용은 [공식 설명서](https://docs.djangoproject.com/en/2.1/)를 참조하십시오.

다른 Python 웹 프레임워크를 사용해 보고 싶은 경우 [Elastic Beanstalk에 Flask 애플리케이션 배포](https://docs.aws.amazon.com/ko_kr/elasticbeanstalk/latest/dg/create-deploy-python-flask.html) 단원을 참조하십시오.





## 기타 구축 방법 사이트

[웹 사이트 및 웹 앱](https://aws.amazon.com/ko/getting-started/use-cases/websites/?csl_l2b_ws)

[스토리지](https://aws.amazon.com/ko/getting-started/use-cases/databases/?csl_l2b_db)

[DevOps](https://aws.amazon.com/ko/getting-started/use-cases/devops/?csl_l2b_do)

[Big Data](https://aws.amazon.com/ko/getting-started/use-cases/big-data/?csl_l2b_bd)

[기타 전체 설명서](https://docs.aws.amazon.com/index.html?nc2=h_ql_doc_do_v)

# 오류 모음

## sudo

- 내 계정이 `brew install` 에서 권한이 없게 나옴

- 해결 

  내 계정 권한

  ```
  sudo chown -R lostcatbox /usr/local/lib/pkgconfig
  ```

## 로드 밸런서, S3와 IP가 바뀜

### 해결1.

지금 만든 서비스가 단일 인스턴스로 해결된다면 구성>용량>로드 밸런스를 단일 인스턴스로 바꾸면 바로 해결됨 

근본적으로 로드 밸런스가 내부 IP를 이용하여 서버의 상태를 확인하게 되므로 일어나는 문제이므로,,



### 해결2.



[참고](https://lhy.kr/elb-healthcheck-for-django?fbclid=IwAR0hJuPy_zomKc18rJWTOyC4Poe3KWXEOIyagPV4L7om9JEwGSNDH4aVC40)

[참고2](https://sanyambansal.wordpress.com/2017/06/26/how-to-make-djangos-allowed_hosts-work-with-aws-elb-health-checks/?fbclid=IwAR2QZg9eXmQZc574ozolOEVBIQ404JdEDWIArlExwkjdDXU1MPttCWij5Kc)

EB에서 오토스케일링 하면서 연결된EC2의 IP가 계속 바뀌더라고요 ㅡ 도메인이나 특정 아이피를 EB에 연결하셔야 해요 ㅡ 아니면 Allowed HOST에 *로 해서 테스트 하실수 있지 않나요?

settings.ALLOWED_HOSTS 부분은 Health Check와는 무관하게,
서비스되고 있는 장고의 아이피 혹은 도메인이름을 뜻합니다.
현재 서비스가 52.78.86.29 아이피에서 되고 있기에 위 오류가 발생하는 듯 하구요. 서비스하시는 아이피 혹은 도메인을 ALLOWED_HOSTS에 추가하시고 서비스하실 수 있습니다.

- [김승민](https://www.facebook.com/profile.php?id=100004859527644) [이진석](https://www.facebook.com/allieuslee?hc_location=ufi) 답변감사합니다! 늦게 확인했네요..
  그런데 말씀하신대로 아이피를 ALLOWED_HOSTS에 추가햇더니 하루정도 문제가 없다가 하루뒤에 새로운 아이피를 또 추가하라고 합니다ㅜ
  이 아이피가 elastic ip도 아니고, 무엇인지 aws 콘솔에서 인스턴스 관련해서 찾아보려고 해도 안보이네요…[더 보기](https://www.facebook.com/groups/askdjango/permalink/2370270649655131/#)

  숨기기 또는 신고

  

  빈소톡도 EC2를 씁니다.
  EC2 내역에서 아이피를 확인해보세요.

  그리고 서비스 시에는 아이피로 서비스하시기보다, 도메인을 쓰시는 것이 관리상 유리하실 듯 하네요.