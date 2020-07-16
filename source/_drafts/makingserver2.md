---
title: makingserver2
date: 2020-06-25 19:47:31
categories:
tags:
---

# 장고 배포하기 실습

![스크린샷 2020-06-25 오후 7.49.15](https://tva1.sinaimg.cn/large/007S8ZIlgy1gg4qa419uxj317u0ek44t.jpg)



서버 동작 과정

## Refer

1. [윈도우에서 SSH 접속하기](https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/putty.html)
2. [장고 배포 체크리스트](https://docs.djangoproject.com/en/2.2/howto/deployment/checklist/)
3. [Ubuntu16.04, Nginx, Uwsgi환경에서 Django 프로젝트 배포하기](https://www.digitalocean.com/community/tutorials/how-to-serve-django-applications-with-uwsgi-and-nginx-on-ubuntu-16-04)
4. [Ubuntu16.04에서 장고 배포 후  Postgresql 사용하기](https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-django-application-on-ubuntu-16-04)
5. [자세히](https://twpower.github.io/41-connect-nginx-uwsgi-django)

## **시스템 환경**

- **Ubuntu 18.04**
- **Django 2.2**
- **nginx**
- **uwsgi**

## **Step**

1. **AWS EC2 인스턴스 생성**

   1. Elastic IP 연결
   2. Privatekey 생성 (윈도우는 `puttyGen`이용, 맥은 `chmod` 400)

2. **장고 배포 준비**

   1. 개발하는 환경에 따라 

      ```
      settings
      ```

      파일과 패키지 

      ```
      requirements
      ```

      파일을 분리하여 사용한다

      1. ```
         requirements
         ```

          파일 분기

         1. `common.txt` ← 로컬, 개발, 상용 서버에 모두 사용되는 패키지들 모음
         2. `prod.txt` ← 상용 서버에서만 사용되는 패키지들 모음
         3. `dev.txt` ← 개발환경에서 사용되는 패키지들 모음

      2. ```
         settings
         ```

          파일 분리

         1. `common.txt` ← 로컬, 개발, 상용 서버에 모두 사용되는 설정 모음
         2. `prod.txt` ← 상용 서버에서만 사용되는 설정 모음
         3. `dev.txt` ← 개발환경에서 사용되는 설정 모음

      3. `BASE_DIR` 경로수정

   2. `manage.py` , `uwsgi.py` 의 셋팅 모듈 값 변경

   3. `Static`, `Media` 파일 경로 설정

3. **SSH 접속**

   ```bash
   $ ssh ubuntu@ip -i ~/.ssh/[private_key] 
   ```

4. **기본 스크립트 설정 및 가상환경 준비**

   ```bash
   # 기본적인 명령어 alias 등록
   $ echo "alias python='python3'" >> ~/.bashrc
   $ echo "alias pip='pip3'" >> ~/.bashrc
   $ source ~/.bashrc # 쉘 스크립트 적용
   
   # 우분투 패키지 설치
   $ sudo apt-get -y update
   $ sudo apt-get install -y python3-pip python3-dev libpq-dev
   $ sudo apt-get install -y python3-venv
   $ sudo pip3 install --upgrade pip
   
   # 장고 코드 받기
   $ git clone <https://github.com/jucie15/deploy-for-p.rogramming.git>
   $ cd deploy-for-p.rogramming
   
   # 가상환경 생성 및 실행
   # 저는 manage.py가 있는 곳에 생성해요.
   $ python -m venv [venv_name]
   $ source [venv_name]/bin/activate
   
   # 파이썬 패키지 설치
   $ pip install -r reqs/prod.txt # UWSGI 포함!!!!
   
   # static 파일 서빙을 위해
   $ python manage.py collectstatic
   
   # 패키지 설치 후uWSGI 서버 테스트
   $ uwsgi --http :8080 --home    /home/ubuntu/deploy-for-p.rogramming/venv --chdir /home/ubuntu/deploy-for-p.rogramming/mysite -w mysite.wsgi
   ```

5. **uWSGI 설정**

   1. **uWSGI 옵션 파일(.ini) 추가**

      - [uWSGI options](https://uwsgi-docs.readthedocs.io/en/latest/Options.html)

      ```bash
      $ sudo mkdir -p /etc/uwsgi/sites # -p 옵션은 중간에 없는 디렉토리까지 같이 생성해준다.
      $ sudo vi /etc/uwsgi/sites/[project].ini
      
      # dir: /etc/uwsgi/sites/[project].ini
      # dir: /home/[user]/run/uwsgi/[project].ini -> 하나만 있을 경우 run 폴더에 바로 설정해도 무관 
      
      [uwsgi]
      uid = ubuntu
      # 여기서  base와 project는 재사용되는 경로를 변수로 설정해둔 것
      base = /home/%(uid)/deploy-for-p.rogramming 
      project = mysite
      
      # venv의 경로 설정
      home = %(base)/venv 
      # 프로젝트가 시작되기 전에 해당경로로 이동한다.
      chdir = %(base)/%(project) 
      # 해당 경로에서 wsgi 모듈의 경로 설정
      module = %(project).wsgi:application
      
      master = true
      processes = 5
      
      socket = /run/uwsgi/%(project).sock
      chown-socket = %(uid):www-data
      chmod-socket = 660
      vacuum = true
      ```

   2. **uWSGI에 대한 서비스 스크립트 생성**

      - [Systemd](https://uwsgi-docs.readthedocs.io/en/latest/Systemd.html)
      - [Systemd options](https://www.freedesktop.org/software/systemd/man/systemd.service.html)

      ```bash
      $ sudo vi /etc/systemd/system/uwsgi.service
      
      [Unit]
      Description=uWSGI Emperor service
      
      [Service]
      
      ExecStartPre=/bin/bash -c 'mkdir -p /run/uwsgi; chown ubuntu:www-data /run/uwsgi'
      ExecStart=/home/ubuntu/deploy-for-p.rogramming/venv/bin/uwsgi --emperor /etc/uwsgi/sites
      Restart=always
      KillSignal=SIGQUIT
      Type=notify
      NotifyAccess=all
      
      [Install]
      WantedBy=multi-user.target
      ```

   3. **uWSGI 서비스 등록 및 구동 확인**

      ```bash
      $ sudo systemctl enable uwsgi
      $ sudo systemctl start uwsgi
      $ sudo systemctl status uwsgi
      ```

6. **nginx 설정**

   1. **server-block 설정 파일 추가**

      ```bash
      $ sudo apt-get install -y nginx
      $ sudo vi /etc/nginx/sites-available/[project_name]
      
      server {
          listen 80;
          server_name [IP OR DOMAIN]; # 서버 도메인 or ip 추가
      
          location = /favicon.ico { access_log off; log_not_found off; }
          location /static/ {
              root /home/ubuntu/deploy-for-p.rogramming/mysite;
          }
      
          location / {
              include         uwsgi_params;
              uwsgi_pass      unix:/run/uwsgi/mysite.sock;
          }
      }
      ```

   2. 설정 파일 심볼릭 링크 연결

      ```bash
      $ sudo ln -s /etc/nginx/sites-available/[project] /etc/nginx/sites-enabled
      ```

   3. 구문 오류 체크 후 nginx 재시작

      ```bash
      $ sudo nginx -t
      $ sudo systemctl restart nginx
      $ sudo systemctl enable nginx
      ```

   4. 방화벽 액세스 허용

      ```bash
      $ sudo ufw allow 'Nginx Full'
      ```

7. uwsgi 에러 확인

   ```bash
   $ sudo journalctl -u uwsgi
   ```

8. **한글설정**

   1. Ubuntu에 한글 설정(에러가 날 경우)

      ```bash
      # 한국의 Locale은 "ko_KR.UTF-8"
      
      # 우분투의 Locale 확인 법
      $ locale
      
      # Locale 변경1 - 한글 패키지 설치
      $ sudo apt-get install -y language-pack-ko
      
      # Locale 설치
      $ sudo locale-gen ko_KR.UTF-8
      
      # dpkg-reconfigure을 이용하는 방법
      # ko_KR.UTF-8 선택
      $ sudo dpkg-reconfigure locales
      
      # 마지막으로 시스템 LANG설정 업데이트
      $ sudo update-locale LANG=ko_KR.UTF-8 LC_MESSAGES=POSIX
      ```

   2. uwsgi 한글 설정 (필수)

      ```bash
      $ sudo vi /etc/systemd/system/uwsgi.service
      # 해당 파일 수정
      
      ''' 중략 ''' 
      [Service]
      ''' 중략 '''
      Environment = LANG=ko_KR.utf8
      Environment = LC_ALL=ko_KR.utf8
      Environment = LC_LANG=ko_KR.utf8
      ''' 중략 '''
      ```

9. **RDS 생성 및 DB 연결**

10. **SSL/ TLS를 사용 트래픽 보호하기.**