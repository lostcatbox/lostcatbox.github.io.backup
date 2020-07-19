---
title: docker
date: 2020-05-21 14:21:23
categories: [Docker]
tags: [Docker, Basic]
---

# 출처

[자세히](https://subicura.com/2017/01/19/docker-guide-for-beginners-1.html)

### MySQL 5.7 container까지함(https://subicura.com/2017/01/19/docker-guide-for-beginners-2.html)

[자세히2](https://subicura.com/2017/01/19/docker-guide-for-beginners-2.html)

# 도커 명령어

```
docker exec -it ec1 /bin/bash #container에 접속해 bash열기
```



| Command                                                      | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [docker attach](https://docs.docker.com/engine/reference/commandline/attach/) | Attach local standard input, output, and error streams to a running container |
| [docker build](https://docs.docker.com/engine/reference/commandline/build/) | Build an image from a Dockerfile                             |
| [docker builder](https://docs.docker.com/engine/reference/commandline/builder/) | Manage builds                                                |
| [docker checkpoint](https://docs.docker.com/engine/reference/commandline/checkpoint/) | Manage checkpoints                                           |
| [docker commit](https://docs.docker.com/engine/reference/commandline/commit/) | Create a new image from a container’s changes                |
| [docker config](https://docs.docker.com/engine/reference/commandline/config/) | Manage Docker configs                                        |
| [docker container](https://docs.docker.com/engine/reference/commandline/container/) | Manage containers                                            |
| [docker context](https://docs.docker.com/engine/reference/commandline/context/) | Manage contexts                                              |
| [docker cp](https://docs.docker.com/engine/reference/commandline/cp/) | Copy files/folders between a container and the local filesystem |
| [docker create](https://docs.docker.com/engine/reference/commandline/create/) | Create a new container                                       |
| [docker diff](https://docs.docker.com/engine/reference/commandline/diff/) | Inspect changes to files or directories on a container’s filesystem |
| [docker events](https://docs.docker.com/engine/reference/commandline/events/) | Get real time events from the server                         |
| [docker exec](https://docs.docker.com/engine/reference/commandline/exec/) | Run a command in a running container                         |
| [docker export](https://docs.docker.com/engine/reference/commandline/export/) | Export a container’s filesystem as a tar archive             |
| [docker history](https://docs.docker.com/engine/reference/commandline/history/) | Show the history of an image                                 |
| [docker image](https://docs.docker.com/engine/reference/commandline/image/) | Manage images                                                |
| [docker images](https://docs.docker.com/engine/reference/commandline/images/) | List images                                                  |
| [docker import](https://docs.docker.com/engine/reference/commandline/import/) | Import the contents from a tarball to create a filesystem image |
| [docker info](https://docs.docker.com/engine/reference/commandline/info/) | Display system-wide information                              |
| [docker inspect](https://docs.docker.com/engine/reference/commandline/inspect/) | Return low-level information on Docker objects               |
| [docker kill](https://docs.docker.com/engine/reference/commandline/kill/) | Kill one or more running containers                          |
| [docker load](https://docs.docker.com/engine/reference/commandline/load/) | Load an image from a tar archive or STDIN                    |
| [docker login](https://docs.docker.com/engine/reference/commandline/login/) | Log in to a Docker registry                                  |
| [docker logout](https://docs.docker.com/engine/reference/commandline/logout/) | Log out from a Docker registry                               |
| [docker logs](https://docs.docker.com/engine/reference/commandline/logs/) | Fetch the logs of a container                                |
| [docker manifest](https://docs.docker.com/engine/reference/commandline/manifest/) | Manage Docker image manifests and manifest lists             |
| [docker network](https://docs.docker.com/engine/reference/commandline/network/) | Manage networks                                              |
| [docker node](https://docs.docker.com/engine/reference/commandline/node/) | Manage Swarm nodes                                           |
| [docker pause](https://docs.docker.com/engine/reference/commandline/pause/) | Pause all processes within one or more containers            |
| [docker plugin](https://docs.docker.com/engine/reference/commandline/plugin/) | Manage plugins                                               |
| [docker port](https://docs.docker.com/engine/reference/commandline/port/) | List port mappings or a specific mapping for the container   |
| [docker ps](https://docs.docker.com/engine/reference/commandline/ps/) | List containers                                              |
| [docker pull](https://docs.docker.com/engine/reference/commandline/pull/) | Pull an image or a repository from a registry                |
| [docker push](https://docs.docker.com/engine/reference/commandline/push/) | Push an image or a repository to a registry                  |
| [docker rename](https://docs.docker.com/engine/reference/commandline/rename/) | Rename a container                                           |
| [docker restart](https://docs.docker.com/engine/reference/commandline/restart/) | Restart one or more containers                               |
| [docker rm](https://docs.docker.com/engine/reference/commandline/rm/) | Remove one or more containers                                |
| [docker rmi](https://docs.docker.com/engine/reference/commandline/rmi/) | Remove one or more images                                    |
| [docker run](https://docs.docker.com/engine/reference/commandline/run/) | Run a command in a new container                             |
| [docker save](https://docs.docker.com/engine/reference/commandline/save/) | Save one or more images to a tar archive (streamed to STDOUT by default) |
| [docker search](https://docs.docker.com/engine/reference/commandline/search/) | Search the Docker Hub for images                             |
| [docker secret](https://docs.docker.com/engine/reference/commandline/secret/) | Manage Docker secrets                                        |
| [docker service](https://docs.docker.com/engine/reference/commandline/service/) | Manage services                                              |
| [docker stack](https://docs.docker.com/engine/reference/commandline/stack/) | Manage Docker stacks                                         |
| [docker start](https://docs.docker.com/engine/reference/commandline/start/) | Start one or more stopped containers                         |
| [docker stats](https://docs.docker.com/engine/reference/commandline/stats/) | Display a live stream of container(s) resource usage statistics |
| [docker stop](https://docs.docker.com/engine/reference/commandline/stop/) | Stop one or more running containers                          |
| [docker swarm](https://docs.docker.com/engine/reference/commandline/swarm/) | Manage Swarm                                                 |
| [docker system](https://docs.docker.com/engine/reference/commandline/system/) | Manage Docker                                                |
| [docker tag](https://docs.docker.com/engine/reference/commandline/tag/) | Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE        |
| [docker top](https://docs.docker.com/engine/reference/commandline/top/) | Display the running processes of a container                 |
| [docker trust](https://docs.docker.com/engine/reference/commandline/trust/) | Manage trust on Docker images                                |
| [docker unpause](https://docs.docker.com/engine/reference/commandline/unpause/) | Unpause all processes within one or more containers          |
| [docker update](https://docs.docker.com/engine/reference/commandline/update/) | Update configuration of one or more containers               |
| [docker version](https://docs.docker.com/engine/reference/commandline/version/) | Show the Docker version information                          |
| [docker volume](https://docs.docker.com/engine/reference/commandline/volume/) | Manage volumes                                               |
| [docker wait](https://docs.docker.com/engine/reference/commandline/wait/) | Block until one or more containers stop, then print their exit codes |

 ## 도커 Run options

도커를 실행하는 명령어는 다음과 같습니다.

```
docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]
```

다음은 자주 사용하는 옵션들입니다.

| 옵션  | 설명                                                   |
| :---- | :----------------------------------------------------- |
| -d    | detached mode 흔히 말하는 백그라운드 모드              |
| -p    | 호스트와 컨테이너의 포트를 연결 (포워딩)               |
| -v    | 호스트와 컨테이너의 디렉토리를 연결 (마운트)           |
| -e    | 컨테이너 내에서 사용할 환경변수 설정                   |
| –name | 컨테이너 이름 설정                                     |
| –rm   | 프로세스 종료시 컨테이너 자동 제거                     |
| -it   | -i와 -t를 동시에 사용한 것으로 터미널 입력을 위한 옵션 |
| –link | 컨테이너 연결 [컨테이너명:별칭]                        |

# 도커란?

> 간단히 말해서 이미지는 프로그램  묶음
>
> 컨테이너는 프로그램을 실행, 실행대기 상태로 해놓은것

도커는 **컨테이너 기반의 오픈소스 가상화 플랫폼**입니다.

컨테이너는 격리된 공간에서 프로세스가 동작하는 기술입니다. 가상화 기술의 하나지만 기존방식과는 차이가 있습니다.

기존의 가상화 방식은 주로 **OS를 가상화**하였습니다.(비주얼박스같이 OS위에 OS)

Server>Host OS> Guest OS>Bins/Libs>App 방식에서

Server>Host OS> Docker Engine>Bins/Libs>App

 **프로세스를 격리** 하는 방식이 등장합니다.

리눅스에서는 이 방식을 리눅스 컨테이너라고 하고 단순히 프로세스를 격리시키기 때문에 가볍고 빠르게 동작합니다. CPU나 메모리는 딱 프로세스가 필요한 만큼만 추가로 사용하고 성능적으로도 거어어어어의 손실이 없습니다.

> 도커의 기본 네트워크 모드는 `Bridge`모드로 약간의 성능 손실이 있습니다. 네트워크 성능이 중요한 프로그램의 경우 `--net=host` 옵션을 고려해야 합니다.

하나의 서버에 여러개의 컨테이너를 실행하면 서로 영향을 미치지 않고 독립적으로 실행되어 마치 가벼운 VMVirtual Machine을 사용하는 느낌을 줍니다. 실행중인 컨테이너에 접속하여 명령어를 입력할 수 있고 `apt-get`이나 `yum`으로 패키지를 설치할 수 있으며 사용자도 추가하고 여러개의 프로세스를 백그라운드로 실행할 수도 있습니다. CPU나 메모리 사용량을 제한할 수 있고 호스트의 특정 포트와 연결하거나 호스트의 특정 디렉토리를 내부 디렉토리인 것처럼 사용할 수도 있습니다.

도커에서 가장 중요한 개념은 컨테이너와 함께 이미지라는 개념입니다.

<그림 전부가 도커 이미지>

![docker-image](https://subicura.com/assets/article_images/2017-01-19-docker-guide-for-beginners-1/docker-image.png)

이미지는 **컨테이너 실행에 필요한 파일과 설정값등을 포함하고 있는 것**으로 상태값을 가지지 않고 변하지 않습니다(Immutable). 컨테이너는 이미지를 실행한 상태라고 볼 수 있고 추가되거나 변하는 값은 컨테이너에 저장됩니다. 같은 이미지에서 여러개의 컨테이너를 생성할 수 있고 컨테이너의 상태가 바뀌거나 컨테이너가 삭제되더라도 이미지는 변하지 않고 그대로 남아있습니다.

ubuntu이미지는 ubuntu를 실행하기 위한 모든 파일을 가지고 있고 MySQL이미지는 debian을 기반으로 MySQL을 실행하는데 필요한 파일과 실행 명령어, 포트 정보등을 가지고 있습니다.

말그대로 이미지는 컨테이너를 실행하기 위한 모든 정보를 가지고 있기 때문에 더 이상 의존성 파일을 컴파일하고 이것저것 설치할 필요가 없습니다. 이제 새로운 서버가 추가되면 미리 만들어 놓은 이미지를 다운받고 컨테이너를 생성만 하면 됩니다. 한 서버에 여러개의 컨테이너를 실행할 수 있고, 수십, 수백, 수천대의 서버도 문제없습니다.

도커 이미지는 [Docker hub](https://hub.docker.com/)에 등록하거나 [Docker Registry](https://docs.docker.com/registry/) 저장소를 직접 만들어 관리할 수 있습니다. 현재 공개된 도커 이미지는 50만개가 넘고 Docker hub의 이미지 다운로드 수는 80억회에 이릅니다. 누구나 쉽게 이미지를 만들고 배포할 수 있습니다.

# 레이어(layer)

유니온 파일 시스템을 이용하여 여러개의 레이어를 하나의 파일시스템으로 사용할 수 있게 해줍니다. 이미지는 여러개의 읽기 전용read only 레이어로 구성되고 파일이 추가되거나 수정되면 새로운 레이어가 생성됩니다.

ubuntu 이미지가 `A` + `B` + `C`의 집합이라면, ubuntu 이미지를 베이스로 만든 nginx 이미지는 `A` + `B` + `C` + `nginx`가 됩니다. webapp 이미지를 nginx 이미지 기반으로 만들었다면 예상대로 `A` + `B` + `C` + `nginx` + `source` 레이어로 구성됩니다. webapp 소스를 수정하면 `A`, `B`, `C`, `nginx` 레이어를 제외한 새로운 `source(v2)` 레이어만 다운받으면 되기 때문에 굉장히 효율적으로 이미지를 관리할 수 있습니다. ~~(개이득)~~

컨테이너를 생성할 때도 레이어 방식을 사용하는데 기존의 이미지 레이어 위에 읽기/쓰기read-write 레이어를 추가합니다. 이미지 레이어를 그대로 사용하면서 컨테이너가 실행중에 생성하는 파일이나 변경된 내용은 읽기/쓰기 레이어에 저장되므로 여러개의 컨테이너를 생성해도 최소한의 용량만 사용합니다.

가상화의 특성상 이미지 용량이 크고 여러대의 서버에 배포하는걸 감안하면 단순하지만 엄청나게 영리한 설계입니다.

# 이미지 경로

![image-url](https://subicura.com/assets/article_images/2017-01-19-docker-guide-for-beginners-1/image-url.png)

이미지는 url 방식으로 관리하며 태그를 붙일 수 있습니다. ubuntu 14.04 이미지는 `docker.io/library/ubuntu:14.04` 또는 `docker.io/library/ubuntu:trusty` 이고 `docker.io/library`는 생략가능하여 `ubuntu:14.04` 로 사용할 수 있습니다. 이러한 방식은 이해하기 쉽고 편리하게 사용할 수 있으며 태그 기능을 잘 이용하면 테스트나 롤백도 쉽게 할 수 있습니다.

# Dockerfile

```dockerfile
# vertx/vertx3 debian version
FROM subicura/vertx3:3.3.1
MAINTAINER chungsub.kim@purpleworks.co.kr


ADD build/distributions/app-3.3.1.tar /
ADD config.template.json /app-3.3.1/bin/config.json
ADD docker/script/start.sh /usr/local/bin/
RUN ln -s /usr/local/bin/start.sh /start.sh


EXPOSE 8080
EXPOSE 7000


CMD ["start.sh"]
```

도커는 이미지를 만들기 위해 `Dockerfile`이라는 파일에 자체 DSLDomain-specific language언어를 이용하여 이미지 생성 과정을 적습니다. 추후에 문법에 대해 자세히 다루겠지만 위 샘플을 보면 그렇게 복잡하지 않다는 걸 알 수 있습니다.

이것은 굉장히 간단하지만 유용한 아이디어인데, 서버에 어떤 프로그램을 설치하려고 이것저것 의존성 패키지를 설치하고 설정파일을 만들었던 경험이 있다면 더 이상 그 과정을 블로깅 하거나 메모장에 적지 말고 `Dockerfile`로 관리하면 됩니다. 이 파일은 소스와 함께 버전 관리 되고 원한다면 누구나 이미지 생성과정을 보고 수정할 수 있습니다.

# 설치 및 세팅

맥환경: [Docker for mac](https://docs.docker.com/docker-for-mac/)

[리눅스](https://subicura.com/2017/01/19/docker-guide-for-beginners-2.html)

## Linux

자동 설치 스크립트를 이용

```
curl -fsSL https://get.docker.com/ | sudo sh
```

**sudo 없이 사용하기**

docker는 기본적으로 root권한이 필요합니다. root가 아닌 사용자가 sudo없이 사용하려면 해당 사용자를 `docker`그룹에 추가합니다.

```
sudo usermod -aG docker $USER # 현재 접속중인 사용자에게 권한주기
sudo usermod -aG docker your-user # your-user 사용자에게 권한주기
```

사용자가 로그인 중이라면 다시 로그인 후 권한이 적용됩니다.

```
docker version #도커 버전 확인
```

> 버전정보가 클라이언트와 서버로 나뉘어져 있습니다. 도커는 하나의 실행파일이지만 실제로 클라이언트와 서버역할을 각각 할 수 있습니다. 도커 커맨드를 입력하면($docker run xxx) 도커 클라이언트가 도커 서버로 명령을 전송하고 결과를 받아 터미널에 출력해 줍니다.
>
> 기본값이 도커 서버의 소켓을 바라보고 있기 때문에 사용자는 의식하지 않고 마치 바로 명령을 내리는 것 같은 느낌을 받습니다. 이러한 설계가 mac이나 windows의 터미널에서 명령어를 입력했을때 가상 서버에 설치된 도커가 동작하는 이유입니다.

[리리](https://subicura.com/2017/01/19/docker-guide-for-beginners-2.html)