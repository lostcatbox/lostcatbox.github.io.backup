---
title: django-basic (장고 개념 기초)
date: 2019-10-19 19:06:17
categories: [Django]
tags: [Basic, Django]
---

------
# 아주 중요 개념
------
 뷰, 모델, url, 템플렛
 view = 각종 로직 처리하는곳
 request = 사용자가 서버에 요청 보낼떄 
 model = 웹서비스에서 서비스에 필요한 부분 저장할 당위 정의
 url = 사용자가 url치면 그걸 view로 연결
 즉 개발자는 모델, 뷰, 템플릿을 제공 한 다음 url에 매핑하기만 하면 장고는 결과정으로 사용자에게 제공한다
 <pre> user-django-url-view-model, template 


__예를 들면__
 내가  192.0.1:8000/horo에 접속하면  urls.py에 url(r'^horo/$', views.video_list, name='list') 에 접속하고 실행하게되면서
 먼저 import views.py가 되어있었으므로 그 파일에 video_list함수가 실행된다
 (request가 매개변수지만 유저가 요청한것을 대변하므로 따로 ()지정필요없다)
 그 함수 마지막에는 
 return render(request, 'video/video_list.html', {'video_list': video_list}) 가 있다.
 의미는 렌더링을 하는것이고, video폴터안에 video_list.html이라는 템플릿이  사용된다. 
 이떄 이 템플릿으로 video_list이름의 video_list리스트정보를 보낸다.
 탬플랫은 html과 파이썬의 탬플랫태그를 통해 최종적으로 뷰에 들어가 
 최종결과물이 url을 통해 유저에게 보여진다.


 url(r'^video/', include('video.urls')), 이런 url이 잇다면 192.0.o01/video 하면 video폴더에 urls.py에 url까지쳐야 실행됨
 (만약 video까지만 치면 404뜸)
 </pre>



------
# 가상환경 설치방법 
------

 ```
 python3 -m venv myvenv  (가상환경 생성)
 source myvenv/bin/activate (가상환경 활성)
 deactivate (가상환경 비활성)
 ```
 가상환경 이름 myvenv로 만들기
 사용 활성화 source myvenv/bin/activate  #myvenv는 내가 이름 정한걸로 변경 가능
 활성화 성공시 맨앞에 myvenv보임

보통 manage.py옆에 myvenv 폴더 둡니다

------
# 프로젝트 시작
------

 장고 시작은 

 ```
 django-admin startproject djangotube . (.은 현재 디렉토리에 설치하라는 의미 (위치지정가능)) 
 ```

 <pre>
 .
 ├── djangotube
 │   ├── __init__.py
 │   ├── settings.py
 │   ├── urls.py
 │   └── wsgi.py
 └── manage.py
 이게 생김
 </pre>

------
# 데이터베이스 생성
------

 ```
 (myvenv) ~/djangogirls$ python manage.py migrate  #db.sqlite3생성됨
 ```
------
# 어플리케이션 추가
------
 ```
 (myvenv) ~/djangogirls$ python manage.py startapp video 
 #애플리케이션 비디오 추가됨 (장고튜브 프로젝트안에) #어플리케이선 video 추가
 ```
 어플리케이션을 만들면 이것을 서버한테도 알려줘야한다!
 __INSTALLED_APPS의 모든 요소 끝에 콤마(,)가 있는지 꼭 확인하세요!__
 #djangotube폴더안이 아니라 밖임 (manage.py 있는곳에서 작업한다라고 기억하자)

 <pre>
 ├── djangotube
 │   ├── __init__.py
 │   ├── settings.py
 │   ├── urls.py
 │   └── wsgi.py
 ├── manage.py
 └── video
    ├── __init__.py
    ├── admin.py
    ├── apps.py
    ├── migrations
    │   └── __init__.py
    ├── models.py
    ├── tests.py
    └── views.py
 </pre>



------
# Model은 데이터를 저장하는 역할 
------

 모델안에 클래스 하나당 DB table하나씩생성함
 모델이 video 리스트를 보여줄 것입니다 video key와 제목을 저장하기 위한 video Model 을 만들어야합니다
 model.py에 적기

------
# 데이터 베이스에 적용하는해야 실행되겠지? 
------

 이 변경사항들을 데이터베이스에게 알려주기 위해서는 Migration 이라는 작업
 makemigrations 명령어를 입력하게 되면 django 에서 자동으로 Migration 파일을 만들어주고,
 migrate 명령어로 만들어진 Migration 파일을 데이터베이스에 적용하는 작업을 하는 거에요.
 ```
 (myvenv) $ python manage.py makemigrations video
 (myvenv) $ python manage.py migrate video
 ```

------
# 비디오 데이터 보여주는 view뷰 추가하기
------
 ```
 video_list = Video.objects.all() (video 객체들을 전부 가져오겠다는다는것)
 ```
 가져오는 video 들은 파이썬의 dic 형태로 template쪽으로 넘겨주게 됩니다
 그러면 template 쪽에서 video_list라는 이름으로 해당 리스트를 사용할수있습니다.



------
# url추가하기
------

 template 와 view를 연경해주는 urls.py먼저 만듬
 즉 어떤 URL에 어떤 View를 연결시켜줄것인지 알려줌
 urlpatterns이라는 리스트안에 url 적어준것
 namespace는 이름공간 = 관련이름 url 이름들을 한곳에 묵ㄲ고 싶을떄 사용
 즉 url외우기 어려우니 name들을 부여후 이름으로소환



------
# template 추가하기
------

 템플릿 엔진이라는 것을 통해서 html에 특별한 구문 을 작성할 수 있습니다.


 탬플릿 태그라고 부른다 html에서 % url '~~' %라고 사용
 ```
 편리한 기능!{% for video in video_list %}
                 <a href="/video/{{ video.id }}">
                     <h4>{{ video.title }}</h4>
                 </a>
             {% endfor %} #탬플릿 태그 사용시 무조건 닫아줘야함
 ```

 탬플릿태그로 파이썬의 for in 구문사용했다. 마지막 
 html에서 {{video.title}} 이 표현식으로 제목 출력가능

------
# 크롤링중 보안 참고 
------


 ```
  {% csrf_token %}
 
 ```
 부분일 거에요.이 템플릿 태그는 특별한 템플릿 태그인데요, 
 웹사이트 공격기법으로 Cross-Site Request Forgery(CSRF)라는 것이 있는데 이 공격을 장고가 기본적으로  막아주는 것이랍니다.

