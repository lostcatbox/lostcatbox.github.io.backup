---
title: Django 기본 네번째이야기
date: 2019-11-21 15:01:59
tags: [Basic, Django]
categories: Django
---




# Messages Framework

- 1회성 메세지를 담는 용도(한명의 유저에게만)

  HttpRequest 인스턴스를 통해 메세지를 남길 수 있음

  메세지는 __1회 노출이 되고, 사라집니다.__ 새로고침하면 보여지지 않음.

  Ex) "저장되었습니다", "로그인되었습니다"

- Messages Framework는 세션에 저장되는데 이것은 DB에 저장이됨. 이때 세션을 관리하기위해서는 HttpRequest 인스턴스가 필요함(???)



##Message levels를 통한 메세지 분류

- 메세지를 남길때 내용+레벨을 지정해야함
- 파이썬 로깅 모듈과 유사. 레벨 별로 필터링이 가능하며, 템플릿에서 다른 스타일로 노출이 가능

- Level 종류(장고!!)
  - DEBUG: 디폴트 설정 상으로 메세지를 남겨도 무시
  - INFO
  - SUCCESS
  - WARNING
  - ERROR



## 메세지 등록 코드(뷰안에)

해당 뷰 요청을 한 유저에게만 노출할 메세지를 다수 등록, 유저 별로 메세지가 따로 등록

```
# blog/views.py
  from django.contrib import messages
  
def post_new(request):
 # 중략
 if form.is_valid():
     post = form.save() #실제 데이터 베이스의 form에있는 Clean_data에  저장성공
     #첫번쨰 방법!!! (둘중하나만쓰기)
     messages.add_message(request, messages.INFO, '새 글이 등록되었습니다.') 
     #두번째 방법!!!(둘중하나만쓰기)(많이쓰는것)
     messages.info(request, '새 글이 등록되었습니다.') # 혹은 shortcut 형태,  #messages.레벨이름임
     return redirect(post)
 # 생략
```





## 메세지 소비 코드(모든템플릿에)(상속이용하자)

- 메세지가 등록되고 난 후, 템플릿 렌더링을 통해 메세지 노출

   messages context_processors 를 통해 message list에 접근 

  - message.tags속성을 통해 레벨을 제공 

  - message.message속성을 통해 내용을 제공 (= str(message))

     \# 코드 뜯어보면 템플릿으로 뷰에서 인자 패스안해도 기본적인것가져오는 프로세스 코드있음





```
<!-- askdjango/templates/layout.html --> #최상위 템플릿 #따라서 모든 템플릿 적용됨
{% if messages %} #전달받은 메세지 확인
   <ul class="messages">
     {% for message in messages %}
         <li {% if message.tags %} class="{{ message.tags }}"{% endif %}>
             {{ message.tags}}     # 메세지 Level
             {{ message.message }}  #실제 메세지 내용
     </li>
     {% endfor %}
   </ul>
{% endif %}
```

아래것을 응용한것이 위에있음

```
   <div class="container"> #박스형식으로 보여주는것

<div class="alert alert-info">
     alert-info 스타일 메세지
    </div>

<div class="alert alert-success">
     alert-success 스타일 메세지
    </div>

<div class="alert alert-warning">
     alert-warning 스타일 메세지
    </div>

<div class="alert alert-danger">
     alert-danger 스타일 메세지
    </div>

```



## 참고, Django Context Processor

템플릿에서 쓸 변수목록을 템플릿 렌더링 요청 시에 넘기지 않아도, 독립적 으로 Context Processors 함수가 호출되어, 그 리턴값 (사전타입) 을 모 아서 템플릿에서 참조 디폴트 context_processors : debug, request, auth, messages

```
# askdjango/settings.py
TEMPLATES = [{
     'OPTIONS': {
       'context_processors': [
           'django.template.context_processors.debug',
           'django.template.context_processors.request',
           'django.contrib.auth.context_processors.auth',
           'django.contrib.messages.context_processors.messages', # HERE !!!
     ],
     },
}]
```





## Bootstrap Alert 스타일로 메세지 노출하기

-  bootstrap alert class-name #ref : alert-info, alert-success, alertwarning, alert-danger  
- message tags : debug, info, success, warning, error \# 둘이 태그이름다르므로 겹치는걸 써야함.(아니면 아래에 서로 이름 이어주는걸 해주던가)

```
<!-- askdjango/templates/layout.html -->
{% if messages %}
     <div class="messages">
         {% for message in messages %}
             <div {% if message.tags %} class="alert alert-{{ message.tags }}"{% endif %}> # 지금 bs스타일 쓰는법
                 {{ message.tags }}
                 {{ message.message }} #내용출력
             </div>
         {% endfor %}
     </div>
{% endif %}
```

### bootstrap 측에 alert-debug 스타일이 없음

없으면 만들면 되지

```
.alert-debug {
     background-color: #eee;
     border-color: #eee;
     color: #333;
}
```

- Tip: 장고 기본설정으로 debug 메세지는 무시되고 있음. debug level을 쓸려면 아래와 같이 settings.MESSAGE_LEVEL을 변경해줘야함

```
# askdjango/settings.py
from django.contrib.messages import constants as messages_constants
MESSAGE_LEVEL = messages_constants.INFO # 디폴트 설정
MESSAGE_LEVEL = messages_constants.DEBUG # 이렇게 설정해줘야 debug메세지가 노출됨
```



### bootstrap 측은 error가 아닌 danger

error로 지정하지만 message.tags는 danger로 출력토록 설정

```
# askdjango/settings.py
from django.contrib.messages import constants as messages_constants
MESSAGE_TAGS = {message_constatns.ERROR: 'danger'} #변환!
```



##  django-bootstrap3의 bootstrap_messages Tag 

```
{% raw %}

{% load bootstrap3 %}

 {% bootstrap_css %}

 {% bootstrap_javascript %} 

{% bootstrap_messages %} 



{% endraw %}
```





편하게쓸수있지만 커스텀힘듬



# StaticFiles

## Static and Media Files

- Static Files : 개발 리소스로서의 정적인 파일 (js, css, image, etc) 
  - 앱 단위로 저장/서빙 
  - 프로젝트 단위로 저장/서빙 (특정앱에 속하지않고 전반적으로 쓰임, 별도tree에넣기)

- Media Files : 유저가 업로드한 모든 정적인 파일 (image, etc) 
  - 프로젝트 단위로 저장/서빙 (settings.MEDIA_ROOT 미디어 모든파일저장됨)

## Static Files(3가지꼭알기)

관련 settings 예시

```
# askdjango/settings.py 


# 각 static 파일에 대한 URL Prefix #유저가 뷰함수요청말고 파일요청일때 구분
    STATIC_URL = '/static/' # 항상 /로 끝이 나도록 설정 #맨처음 시작이/static/이면 스테틱파일에 대한 요청으로 알아들음
    #예시: http://localhost:8000/static/blog/style.css
# STATIC_URL = 'http://static.myservice.com/v1/static/' # 다른 서버에 static파일들을 복사했을 시


# FileSystemFinder 를 위한 static 디렉토리 목록!!(장고에게알려줌)
STATICFILES_DIRS = [
 os.path.join(BASE_DIR, 'askdjango', 'static'),
]


# 각 디렉토리 별로 나눠져있는 static파일들을 manage.py collectstatic명령을 통해, 아래 디렉토리 경로로 복사
# 개발 당시에는 의미가 없는 설정. 실서비스 배포 전에 static 파일들을 모아서 배포 서버에 복사
STATIC_ROOT = os.path.join(BASE_DIR, '..', 'staticfiles')
```



## Static Files Finders

Template Loader와 유사 

다수 디렉토리 목록에서 지정 상대경로를 가지는 Static파일을 찾음 

- AppDirectoriesFinder : "앱/static" 경로를 추가 
- FileSystemFinder : settings.STATICFILES_DIRS=[] 의 경로를 추 가

위 Finder를 통해, Static 파일이 있을 후보 디렉토리 리스트를 작성합니 다. 이는 장고 서버 초기 시작시에만 1회 작성됩니다



후보 디렉토리 예시

1) blog/static

2) askdjango/static

네임 스페이스 개념으로 써줘야 같은 이름파일도 구별가능



> Template Loader 와 비교
>
>  • app_directories.Loader : "앱/templates" 경로
>
>  • filesystem.Loader : settings.TEMPLATES 애 DIRS=[] 의 경로



## 템플릿 내에서 각 static 파일 URL처리

방법1) 수동으로 settings.STATIC_URL Prefix 붙이기 (BAD)

\<img src="/static/blog/title.png?" />

 경고 : settings.STATIC_URL 설정은 언제라도 변경될 수 있음 />

방법2) __Template Tag를 통해 Prefix 붙이기 (GOOD) __ (장고태그기능)

{% raw %}

{% load static %} 

\<img src="{% static "blog/title.png" %}" />

{% endraw %}



__tip__ 프로젝트는 경로 추가해주고, 앱은 static디렉만들고 blog디렉안에 만들고 그안에 파일넣기



예시) 스타일을 템플릿에서 빼고 

```
<link rel="stylesheet" href="/static/style.css">

<link rel='stylesheet' href="'{%  static "style.css" %}" #₩이걸더 추천
경로이름 바뀌어도 사용가능 (템플릿 최상단에 {%  load static  %}추가@)
```

해서 불러옴





## 개발환경에서의 static 파일 서빙

- 개발서버(python3 manage.py runserver가 개발서버임) 를 통해 settings.DEBUG = True 설정에 한해 서빙 지원 
- 원래는 urls.py에 없어도 가능
- 프로젝트/urls.py 에 Rule이 명시되어 있지 않아도 자동 Rule 추가 
- 장고를 통해 직접 static파일 서빙하는 것은 개발목적으로만 제공
- 즉 실제 서비스는  따로 둬야함, 정적파일은 따로관리 



## 자동 static serve가 수행되지 않을 때에도 장고를 통해 static serve를 수행할려면? (비추)

settings.DEBUG=False 이거나 개발서버를 쓰지않는 경우 django.views.static.serve 뷰에 대한 URL Rule을 명시



``` 
# askdjango/urls.py
   from django.contrib.staticfiles.views import serve
# 중략
  urlpatterns += [
   url(r'^static/(?P<path>.+)$', serve, {'insecure': True}),
  ]
```





## 실 서비스 배포 전에 collectstatic

실서비스 정적파일 서빙은 외부 웹서버 권장 (nginx/apache/S3/CDN) 

여러 디렉토리에 나눠 저장된 static 파일들의 위치는 "현재 장고 프로젝 트" 만이 알고 있음. 외부 웹서버는 전혀 알지 못함. 

외부 웹서버에서 Finder의 도움없이도 static파일 서빙을 하기위해, Finder를 활용하여 한 디렉토리 (settings.STATIC_ROOT) 로 파일들을 복사 => 복사된 파일을 서빙하면 Finder가 필요없다



```
외부에서는 /static/style.css , /static/blog/style.css는 같은 디렉토리로 판단됨.
사실은 blog/static/blog/style.css =>settings.STATIC_ROOT /blog/style.css
askdjango/static/style.css => settings.STATIC_ROOT/style.css

원본파일을 파일들복사해서 settings.STATIC_ROOT로 파일복사하면 결국 
http://localhost:8000/static/blog/style.css
http://localhost:8000/static/style.css  경로가 같아짐

Finder도움 필요없음
이 복사작업때문에 python manage.py collectstatic 필요함


예시
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')를 settings.py에 추가후 명령 실행
```





## 외부 웹서버에 의한 static/ media 컨텐츠 서비스

- 정적인 컨텐츠는, 외부 웹서버에서 직접 응 답을 하면, 더 빠른 응답 

  WAS (Django, RoR, Node) 보다 빠 르고 효율적으로 동작 

- 정적 컨텐츠와 동적 컨텐츠 분리를 통해, 그 에 맞는 최적화 방법을 사용 memcache/redis 캐시 등
- 장고로 안거치고 바로 서버가 파일줌, 아니면 장고로 넘김
- ![스크린샷 2019-11-14 오후 6.10.37](/Users/spicyhoro/Desktop/스크린샷 2019-11-14 오후 6.10.37.png)

## static 파일 모으는 순서, 적용순서

1. 먼저 python manage.py collectstatic 명령을 통해, settings.STATIC_ROOT 경로 아래로 Static 파일들을 모두 복사
2. settings.STATIC_ROOT 경로에 모아진 파일을 배포서버로 복사 
3. settings.STATIC_URL 설정이 __배포서버를 가르키도록 수정__
4. 실서비스 static 서빙 웹서버 설정 (nginx/apache/S3/CDN 등)



## nginx 웹서버에서의 static 서빙 설정 SIMPLE 예시(원리)

```
server {
   # 중략
   location /static {
       autoindex off;
       alias /var/www/staticfiles; # settings.STATIC_ROOT
       }
   location /media {
         autoindex off;
         alias /var/www/media; # settings.MEDIA_ROOT
   }
  }
```





# Media Files

뷰에는 HttpRequest.FILES를 통해 파일이 전달되고, 

뷰에서는 이를 적절 히 검증한 후, settings.MEDIA_ROOT 디렉토리 하단에 저장



```
# askdjango/settings.py

# 각 media 파일에 대한 URL Prefix
MEDIA_URL = '/media/' # 항상 /로 끝이 나도록 설정
# MEDIA_URL = 'http://static.myservice.com/media/' # 다른 서버로 media파일을 복사할 시

# 업로드된 파일을 저장할 디렉토리 경로
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
```

## FileField/ImageField 파일저장을 지원하는 모델필드

__파일은 settings.MEDIA_ROOT경로에 실제파일 저장하며__, 

__DB필드에는 settings.MEDIA_ROOT내 저장된 하위 경로(문자열)를 저장__



```
# blog/models.py

from django.db import models

class Post(models.Model):
   title = models.CharField(max_length=100)
   content = models.TextField()
   photo = models.ImageField()
```



__Tip. __

File Storage API (디폴트: FileSystemStorage)를 통해 파일을 저장 해당 필드를 옵션필드로 두고자 할 경우, blank=True옵션 적용

__Tip2.__

 ImageField (FileField 상속)

필요!! Pillow 이미지 처리 라이브러리 를 통해 이미지 width/height 획득



## 개발환경에서의 media 파일 서빙

- static files와 다르게 개발서버에서 서빙 미지원
- 개발 편의성 목적으로 직접 서빙 Rule 추가 가

```
# askdjango/urls.py

from django.conf import settings
from django.conf.urls.static import static

# 중략

# settings.DEBUG=False에서는 static함수에서 빈 리스트를 리턴(즉 무조건 켜줘야함)
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)   #뜻은 url경로에 media_url로 들어오면 media_root경로가서 파일찾아라
```





## 참고) 파일 업로드 시의 form enctype

- form method는 필히 POST : GET method는 enctype이 "application/x-www-form-urlencoded"로 강제됨
-  __form enctype은 필히 "multipart/form-data"__ : "application/xwww-form-urlencoded"로 지정될 경우, 파일명만 전송(>디폴트값임)

```
<form action="" method="post" enctype="multipart/form-data">
   {% csrf_token %}
   <table>
       {{ form.as_table }}
   </table>
   <input type="submit" />
</form>
```

Tip: 만약 업로드가 안된다면 둘중하나 multipart/form-data로 지정하고 뷰에 request.FILES로 해당 폼이 request.POST와 request.FILES를 받는지 확인

## 파일 저장경로

디폴트 설정으로 업로드된 파일은 "settings.MEDIA_ROOT/파일명"경 로에 저장되며, DB에는 "파일명"만 저장

​     ex)  travel-20170131.jpg 파일을 업로드할 경우

- MEDIA_ROOT/travel-20170131.jpg 경로에 저장되며 
- DB필드에는 "travel-20170131.jpg" 문자열 저장



## 파일 저장경로 커스텀 by upload_to

각 필드 별로 다른 디렉토리 저장경로를 가지게 하기

한 디렉토리에 파일들을 너무 많이 몰아둘 경우, OS 파일찾기 성능 저하 디렉토리 Depth가 깊어지는 것은 성능에 큰 영향이 없음

업로드가될때 upload_to경로가 참고되므로 바꾼다고 원래 경로 디렉토리이름은 안바뀜

- 대책1) 필드 별로 다른 디렉토리에 저장(부실함)(upload_to)

- 대책2) 업로드 시간대별로 다른 디렉토리에 저장 (upload_to)

  

예시) Post에

```
# upload_to 경로입력에 맨앞뒤의 '/'는 뺀다
photo = models.ImageField(blank=True, upload_to='blog/post')


# upload_to='blog/post/%y/%m/%d' #년월일 지원

```

### travel-20170131.jpg 파일을 업로드할 경우

photo = models.ImageField(upload_to="blog") 

- MEDIA_ROOT/blog/travel-20170131.jpg 경로에 저장 
- DB필드에는 "blog/travel-20170131.jpg" 문자열 저장

 photo = models.ImageField(upload_to="blog/photo") 

-  MEDIA_ROOT/blog/photo/travel-20170131.jpg 경로에 저장

- DB필드에는 "blog/photo/travel-20170131.jpg" 문자열 저장

 ### strftime 포맷팅 지원

업로드 당시의 시각을 디렉토리 경로에 쓸 수 있음.

 photo = models.ImageField(upload_to="blog/%Y/%m/%d") 

업로드 시각이 2017년 2월 1일이라면

- MEDIA_ROOT/blog/2017/02/01/travel-20170131.jpg 경로
- DB필드에는 "blog/2017/02/01/travel-20170131.jpg"



## 템플릿 내에서 각 media 파일 URL처리

방법1) 수동으로 settings.MEDIA_URL Prefix 붙이기 (BAD) 

```
<img src="/media/blog/2017/02/01/travel-20170131.jpg" />
<img src="/media/{{ post.photo}}/"
```

경고 : settings.MEDIA_URL 설정은 언제라도 변경될 수 있음 (post.photo로경로확인가능)

방법2) FileField/ImageField의 .url 속성 (BAD) 

```
<img src="{{ post.photo.url }}" %}" />
예시에서처럼 앞에 /media/를 붙여주는 역할을 .url이함
없는 파일에서는 url못찾았다고 오류뜨므로
앞뒤로 {% if post.photo %}
      {% endif %} 해주면 존재할때만 안에 코드실행 
```

Tip) .path속성은 파일시스템 상의 절대경로

 - settings.MEDIA_ROOT가 Prefix로 붙음



### 기타 참고

```
import re
from django.conf import settings
from django.views.static import serve
if '://' not in settings.MEDIA_URL: # 외부서버를 지정하지 않았다면
   prefix = re.escape(settings.MEDIA_URL.lstrip('/'))
   pattern = r'^%s(?P<path>.*)$' % prefix
   urlpatterns += [
   url(pattern, serve, {'document_root': settings.MEDIA_ROOT}),
   ]
```





## 참고) File Upload Handler (뷰에전달시)

- 메모리에 담겨 전달 (by MemoryFileUploadHandler) 
  -  파일크기가 2.5MB (settings.FILE_UPLOAD_MAX_MEMORY_SIZE) 이하일 경우
-  디스크에 담겨 전달 (by TemporaryFileUploadHandler)
  -  파일크기가 2.5MB 초과할 경우





# 이미지 썸네일 만들기

JPEG : 손실압축 포맷. 파일 크기가 작아 웹에서 널리 사용 

- 압축률을 높이면 파일크기는 더 작아지나 이미지 품질은 떨어짐 (1~100%, 대개 60~80%가 적정선) 
- 투명채널은 지원되지 않으며, 사진 이미지에 유용 

PNG : 투명채널 지원하며, 24비트 색상 (2^24) 지원 

- 투명이 필요하거나, 문자가 있는 이미지는 PNG포맷이 유리 

GIF: 256색까지 지원. 애니메이션 지원 (움짤)





### 이미지 용량 줄이기

- 네트워크 트래픽은 돈
- 이미지 용량이 크면, 유저 다운로드에도 더 긴 시간이 소요 
- 가급적 JPG 포맷 사용 
  - 투명채널이 필요하지 않고, 문자가 없는 이미지 (인물/풍경 사진 등) 
  - 글자가 많은 이미지는 JPG포맷을 쓰면, 글자가 뭉개집니다. 

- 메타데이터(사진정보들)는 이미지 노출과 직접적인 관련성이 없으므로, __제거__ 
- 서비스에 필요한 이미지 크기로 리사이징



## 파이썬 이미지 처리 라이브러리

- PIL (Python Image Library) : 마지막 업데이트 2009 
- Pillow : PIL fork (많이사용)
  - 기존 PIL 활용코드를 그대로 쓸 수 있습니다.

- PILKit : PIL 유틸리티 라이브러리(많이사용)(pip3 install pilkit)
- Wand : ImageMagick 파이썬 바인딩

### 다양한 processors 지원

- ProcessorPipeline, Adjust, Reflection, Transpose, Anchor, MakeOpaque
- TrimBorderColor, Crop, SmartCrop
- ColorOverlay 
- Resize, ResizeToCover, ResizeToFill, SmartResize, ResizeCanvas, AddBorder, ResizeToFit, Thumbnail

## requests를 이용하여, 이미지 다운받기

- 설치 : pip install requests

  ```
  import requests 
  
  img_binary = requests.get("이미지URL").content
  with open("저장할파일경로" , "wb") as f:
  		f.write(img_binary)
  ```

  

Tip: pip3 install "ipython[notebook]"하면 쥬피터랑같이설치됨



## [PILKit] Thumbnail (썸내일 사진 만들기)

```
from PIL import Image
from pilkit.processors import Thumbnail

processor = Thumbnail(width=300, height=300)

img = Image.open("읽어올이미지경로")
thumb_img = processor.process(img) #원본은 수정안되고 변환된 사진을 인스턴스로 반환

thumb_img.save("sample-300x300.png")
for quality in [100, 80, 60, 40, 20]:
   thumb_img.save("sample-300x300-{}.jpg".format(quality), quality=quality)v
```

즉, 링크만가지고 받아서 썸네일로 변경후 저장가능



# ImageField 썸네일

##이미지 썸네일 Helper 장고 앱. 몇가지

- Django-imagekit
- Sorl-thumbnail
- Easy-thumbnails

### Django-imagekit 설치

```
pip3 install pillow
pip3 install django-imagekit #PILKit 추가설치해야함 
django-imagekit>PILKit>pillow 의존성
```

- settings.INSTALLED_APPS에 "imagekit" 추가
- 실제 이미지 처리 시에는 PILKit가 사용됩니다.

## 활용1. 원본 ImageField로부터 썸네일 Field생성

ImageSpecField 

- url, path, width, height 속성 지원
- Form에서는 렌더링되지 않음



```
from django.db import models
from imagekit.models import ImageSpecField
from imagekit.processors import Thumbnail

#모델클래스 안에다가 이미지필드만들고 이미지스팩으로!! 옵션들지정가능
class Post(models.Model):
   photo = models.ImageField() #업로드 동시에 ImageSpecField실행되게됨,
   photo_thumbnail = ImageSpecField( # settings.MEDIA_ROOT 내 CACHES/ 하위 경로에 생성
   
         source='photo', # 원본을 구할 ImageField필드명!
         processors=[Thumbnail(100, 50)], # 처리할 작업목록
         format='JPEG', # 최종 저장포맷
         options={'quality': 60}) # 저장 옵션
```

## 활용2 : 원본 이미지를 유지 X, 썸네일 Field만 저장

```
from django.db import models
from imagekit.models import ProcessedImageField
from imagekit.processors import Thumbnail

class Post(models.Model):
   photo_thumbnail = ProcessedImageField(
         upload_to='blog/post',
         processors=[Thumbnail(100, 50)], # 처리할 작업목록
         format='JPEG', # 최종 저장포맷
         options={'quality': 60}) # 저장 옵션
```



##  템플릿에서 직접 이미지 썸네일 처리하기



기본 지원 Generator : "imagekit:thumbnail"

(장고 이미지 킷에서만 쓰는 용어)

__여러가지 크기의 썸네일필요하면 이 방법이 최적임__

__따로 모델건드릴필요없음__



- width (int) : thumbnail 가로크기 지정 
- height (int) : thumbnail 세로 크기 지정
- crop (bool, 디폴트 True) : 이미지가 클 경우, Crop 여부
- upscale (bool, 디폴트 True) : 이미지가 작을 경우, 이미지 확대 여부



```
  blog/models.py
  
# 첫번째 방법
  
  class Post
  photo = models.ImageField(blank=True, upload_to='blog/post/%y/%m/%d')
    
    photo_thumbnail = ImageSpecField(source='photo', 
             processors=[Thumbnail(300,300)],
             format='JPEG',
             options={'quality': 60})
             
    #이렇게 구성시 템플릿에서 {{post.photo_thumbnail.url}}로 바꿔줘야함
    
    
#두번째 방법
    photo = ProcessedImageField(blank=True, upload_to='blog/post/%y/%m/%d',
                                processors=[Thumbnail(300, 300)],
                                format='JPEG',
                                options={'quality': 60})
                                
     #이렇게 구성시 템플릿은 원래 {{post.photo.url}}임
     
#템플릿에서 직접 이미지 썸네일 처리하기

    
```

### thumbnail Template Tag 활용

템플릿 최상단에 꼭 {% raw %} __{% load imagekit %}__{% endraw %}



```
{% raw %}
{% thumbnail "300x300" post.photo %} <!-- 이미지 태그 생성 -->

{% thumbnail "300x300" post.photo as thumb %} <!-- 썸네일 file object 획득 --> #as를 쓰면 이미지태그 자동으로생성안됨.

<img src="{{ thumb.url }}" width="{{ thumb.width }}" height="{{ thumb.height }}/>  #직접 그림의 속성값들 지정하고 이미지태그만들어줌

{% thumbnail "300x300" post.photo -- id="myimg" classs="mycls" %} <!-- 추가 속성 정의 --> # -- 찍고 추가 속성 정의해주면 더들어감

{% endraw %}
```

### generateimage Template Tag 활용

```
{% raw %}

{% generateimage "imagekit:thumbnail" source=post.photo width=300 height=300 %}

{% generateimage "imagekit:thumbnail" source=post.photo width=300 height=300 as thumb %}

<img src="{{ thumb.url }}" width="{{ thumb.width }}" height="{{ thumb.height }}/>

{% generateimage "imagekit:thumbnail" source=post.photo width=300 height=300 -- id="myimg" class="mycls" %}
{% endraw %}
```



# FormField Widget

## Widget

- UI 입력 요소

- class Widget(attrs=None)
  - Attires : 해당 tag의 property 지정
  - Self.attrs를 통해 접근가능

```
>>> from django import forms
>>> name = forms.TextInput(attrs={'size': 10, 'title': 'Your name',}) #속성이름과 값을 추가함
>>> name.render('name', 'value', attrs=None)
'<input title="Your name" type="text" name="name" value="A name" size="10" required />' #.render를 통해서html형식으로 바꿀수있음
```

## built-in widgets(다레이어존재)

텍스트 입력 : TextInput, NumberInput, EmailInput, URLInput, PasswordInput, HiddenInput, DateInput, DateTimeInput, TimeInput, Textarea (다들각자맞는제약존재)

select/콤보박스 : CheckboxInput, Select, NullBooleanSelect, SelectMultiple, RadioSelect, CheckboxSelectMultiple 

File upload : FileInput, ClearableFileInput 

Composite : MultipleHiddenInput, SplitDateTimeWidget, SplitHiddenDateTimeWidget, SelectDateWidget



## 위젯 지정

- Widget클래스 혹은 Widget인스턴스로 지정

```
# 방법1) Form Field 정의 시에 widget 을 통해 지정
class PostForm(forms.Form):
   lnglat = forms.CharField(max_length=50, widget=NaverMapPointWidget()) #커스텀오더 위젯지정가능
   
# 방법2) ModelForm Class 의 Meta 내 widgets를 통해 widget만 변경
class PostForm(forms.ModelForm):
   class Meta:
          model=Post
          fields='__all__'
          widgets = {
       'lnglat': NaverMapPointWidget(),
       } #이런식으로  각 필드별 커스텀오더. 위젯지정가능
```

##  커스텀 위젯

위젯을 변경한다고 해서, 서버로 전달되는 값이 변경되는 것은 아님. 단지 유저에게 UI편의성을 제공

만드는 법 

- django.forms.Widget.render 멤버함수 재정의를 통해, 추가 

  HTML/CSS/JavaScript를 정의 (render의 역할은 html형식으로 바꿔줌,유저보여줌)

   ex) forms.TextInput 이나 forms.HiddenInput 기반에서 네이버 맵 위젯, 다음 맵 위젯, 구글 맵 위젯



## 네이버맵 경도/위도 입력위젯 - NaverMapPointWidget

(커스텀위젯 직접만들기)(이 단원은 api적용하므로 어렵더라,,넘어가자일단.)

```
import re
from django import forms
from django.conf import settings  #장고 글로벌setting + askdjango/setting.py 둘다 포함됨
from django.template.loader import render_to_string

class NaverMapPointWidget(forms.TextInput):
     BASE_LAT, BASE_LNG = '37.497921', '127.027636' # 강남역

             def render(self, name, value, attrs): #render함수 오버라이딩!!!!
                     width = str(self.attrs.get('width', 800))
                     height = str(self.attrs.get('height', 600))
                     
                     if width.isdigit(): width += 'px'
                     if height.isdigit(): height += 'px'
                     context = { 'naver_client_id': settings.NAVER_CLIENT_ID,
                     'id': attrs['id'], # 현재 formfield
                         의 html id
                     'width': width, 'height': height,
                    'base_lat': self.BASE_LAT, 'base_lng': self.BASE_LNG}


                     if value:
                         try:
                             lng, lat = re.findall(r'[+-]?[\d\.]+', value)
                             context.update({'base_lat': lat, 'base_lng': lng})
                         except (IndexError, ValueError):
                             pass
                     attrs['readonly'] = 'readonly'
                   
                     #부모의 함수이용할때(여기서는forms.TextInput의 함수!!)
                     parent_html = super().render(name, value, attrs) 
                     html = render_to_string('widgets/naver_map_point_widget.html', context)
                     return parent_html + html
```

Tip: 프로젝트의 모든 디렉토리(.py파일있는)는 무조건 \_\_init\_\_.py가 있어야함.

이과정에서 forms.ModelForm으로 폼을 만들었으니까 class Meta: 아래에 widget에 추가



> 원래 form에다가 필드 생성하면 해당 위젯의 기본값도 들어가있는데 이 기본값을 오버라이딩해서 지도 등을 추가하는 과정
>
> Widget.py에다가 html까지쓰는건 비효율적이므로 분리추천.
>
> 알아둬야할것은 html은 문자열 render()는 HttpResponse인스턴스반환
>
> html 에서는 id값은 유니크해야한다 두개면 하나만 출력된다



### 넘어가자!



# Class Based View (CBV)

- 뷰의 정체는 호출가능한 객체 (Callable Object)

- CBV의 정체는 __FBV를 만들어주는 클래스 __

  as_view 클래스함수를 통해 함수뷰를 생성 !!!!

- 장고 기본 CBV 팩키지 위치 : django.views.generic

  CBV는 범용적 (generic) 으로 쓸 뷰 모아놓음

- step4를 이해하기위해 1~4까지 진행하자

  Tip: get_object_or_404는 

  ```
    #try:
       #   post = Post.objects.get(id=id)
    #except Post.DoesNotExist:
      #    raise Http404   이코드와같다
  ```

  

## 샘플 STEP1 - FBV버전

```
# myapp/views_fbv.py
from django.shortcuts import get_object_or_404, render

def post_detail(request, id):
   post = get_object_or_404(Post, id=id)
   return render(request, 'blog/post_detail.html', {
       'post': post,
   })
 
def article_detail(request, id):
   article = get_object_or_404(Article, id=id)
   return render(request, 'blog/article_detail.html', {
       'article': article,
   })
```



## 샘플 STEP2 - 함수를 통해, 뷰 생성 버전

\# 중요한점은 generate_view_fn()이 호출될때마다 아래 view_fn이 새롭게 정의된다.

따라서 아래처럼 코딩하면 post_detail= view_fn(새로작성된) post_detail가 이제는 post_detail(request, id)를 받으면똑같이 행동

```
def generate_view_fn(model): #모델클래스를 받는다
   def view_fn(request, id):
       instance = get_object_or_404(model, id=id)
       instance_name = model._meta.model_name
       template_name = '{}/{}_detail.html'.format(model._meta.app_label, instance_name)
       
       return render(request, template_name, {
           instance_name: instance,
       })
   return view_fn
   
post_detail = generate_view_fn(Post)
article_detail = generate_view_fn(Article)
```





## 샘플 STEP3 - CBV형태로 컨셉만 구현한 버전



```
# myapp/views_cbv.py
class DetailView(object):
     '이전 FBV를 CBV버전으로 컨셉만 간단히 구현. 같은 동작을 수행'
     
     def __init__(self, model):
     			self.model = model
     
     def get_object(self, *args, **kwargs):
    		 return get_object_or_404(self.model, id=kwargs['id'])
    		 
     def get_template_name(self):
     		return '{}/{}_detail.html'.format(self.model._meta.app_label, self.model._meta.model_name)
     		
     def dispatch(self, request, *args, **kwargs):
    			 return render(request, self.get_template_name(), {
     self.model._meta.model_name: self.get_object(*args, **kwargs),
     })
     
     @classmethod
     def as_view(cls, model): #cls는 클래스로 이클래스를 호출
    		 def view(request, *args, **kwargs):
     						self = cls(model) #해당 위에 클래스의 인스턴스생성.
    					 return self.dispatch(request, *args, **kwargs) #추가인자받은것을 그대로 다시 넘겨줌
    		 return view
 
 
post_detail = DetailView.as_view(Post)
article_detail = DetailView.as_view(Article)
```

Tip: *arg는 불특정 다수의 positional argu     *하나는 튜플형태로받음 **는 사전형태

**kwargs는 불특정 다수의 keyword argu 받을수있다



## 샘플 STEP4 - 장고 기본 제공 DetailView CBV 쓰기

```
# myapp/views_cbv2.py
from django.views.generic import DetailView

post_detail = DetailView.as_view(model=Post, pk_url_kwarg='id')
article_detail = DetailView.as_view(model=Article, pk_url_kwarg='id')

혹은 urls.py 내 이름을 id -> pk 로 변경하면 path('<int: pk>')

post_detail = DetailView.as_view(model=Post)
article_detail = DetailView.as_view(model=Article)
```



## 샘플 urls.py

```
# myapp/urls.py
from django.views.generic import DetailView
from .models import Post, Article
from . import views_fbv
from . import views_cbv
from . import views_cbv2

urlpatterns = [
     # views_fbv
     url(r'^posts/fbv/(?P<id>\d+)/$', views_fbv.post_detail),
     url(r'^articles/fbv/(?P<id>\d+)/$', views_fbv.article_detail),
     
     # views_cbv
     url(r'^posts/cbv/(?P<id>\d+)/$', views_cbv.post_detail), #이렇게 함수처럼 구현도가능
     url(r'^posts/cbv/(?P<id>\d+)/$', views_cbv.DetailView.as_view(Post)), #그냥 바로 호출가능
     url(r'^articles/cbv/(?P<id>\d+)/$', views_cbv.article_detail),
     url(r'^articles/cbv/(?P<id>\d+)/$', views_cbv.DetailView.as_view(Article)),

     # views_cbv2
     url(r'^posts/cbv2/(?P<id>\d+)/$', views_cbv2.post_detail),
     url(r'^posts/cbv2/(?P<id>\d+)/$', DetailView.as_view(Post)), # views_cbv2 뷰 참조없음
     url(r'^articles/cbv2/(?P<id>\d+)/$', views_cbv2.article_detail),
     url(r'^articles/cbv2/(?P<id>\d+)/$', DetailView.as_view(Article)), # views_cbv2 뷰 참조없음
]
```





## CBV는 구현은 복잡해도, 가져다 쓸 때는 SO SIMPLE !!!

- 그렇다고해서 CBV를 통한 뷰코드가 모두 심플해지는 것은 아님.

- 이미 CBV에서 정해둔 시나리오를 따를 때에만 SIMPLE 

  그 길을 벗어날 때에는 복잡해질 여지가 많습니다.

- CBV 만능주의 금물. FBV와 적절히 섞어쓰세요. CBV틀을 벗어나는 구 현은 FBV가 훨씬 간단

  함수로 구현하는 것이 재사용성은 낮지만, 로직 구현 복잡도도 낮음.



## 기본 제공 CBV

- Generic Display Views 
  - ListView, DetailView 
- Generic Editing Views
  - FormView, CreateView, UpdateView, DeleteView 

- Generic Date Views 
  - ArchiveIndexView, YearArchiveView, MonthArchiveView, WeekArchiveView, DayArchiveView, TodayArchiveView, DateDetailView



### ListView

(get요청)지정 모델에 대한 전체 목록을 조회

- paginate_by 옵션 : 페이지당 갯수 지정

- 디폴트 템플릿 경로 : “앱이름/모델명소문자\_list.html”

- 디폴트 context object name : "모델명소문자\_list"

  • ex) post_list, comment\_list, tag\_list



```
# myapp/views.py
from django.views.generic import ListView

post_list = ListView.as_view(model=Post) # 1안) 페이징 없이, 전체
post_list = ListView.as_view(model=Post, paginate_by=10) # 2안) 페이징당 10개씩 노출

# myapp/urls.py
urlpatterns = [
 url(r'^posts/$', views.post_list),
]

<!-- myapp/templates/myapp/post_list.html -->
<ul>
   {% for post in post_list %}
       <li>{{ post.title }}</li>
   {% endfor %}
</ul>
```



### DetailView

(get요청)지정 pk 혹은 slug의 모델 인스턴스에 대한 Detail

- 디폴트 템플릿 경로 : “앱이름/모델명소문자_detail.html” 

- 디폴트 context object name : "모델명소문자"

   ex) post, comment, tag

```
# myapp/views.py
from django.views.generic import DetailView

post_detail = DetailView.as_view(model=Post)

# myapp/urls.py
urlpatterns = [
 url(r'^posts/(?P<pk>\d+)/$', views.post_detail),
]  #pk이므로 위에 pk_url_kwarg='id'없어도됨


<!-- myapp/templates/myapp/post_detail.html -->
<h1>{{ post.title }}</h1>
{{ post.content|linebreaks }}
```





### CreateView / UpdateView

[GET/POST 요청] ModelForm  을 통해 Model Instance를 생성/수정



- model 옵션 (필수) 
- form_class 옵션 : 미제공시, ModelForm 생성/적용 
- fields 옵션 : form_class 미제공 시, 지정 field에 대해서만 Form 처리 
- __success_url 옵션 : 제공하지 않을 경우, model_instance.get_absolute_url() 획득을 시도 __
- 디폴트 템플릿 경로 : "앱이름/모델명소문자_form.html" 
- GET 요청 : 입력 Form을 보여주고, 입력이 완료되면 같은 URL (즉 같은 뷰) 로 POST요청 
- POST 요청 : 입력받은 POST데이터에 대해 유효성 검사를 수행하고 
- invalid 판정 시 : Error가 있으면 다시 입력Form을 보여줍니다.
-  valid 판정 시 : 데이터를 저장하고, success_url 로 이동



### 베이스 코드

```
# myapp/models.py
from django.db import models

class Post(models.Model):
     title = models.CharField(max_length=100)
     
 		 def get_absolute_url(self):
				 return reverse('myapp:post_detail', args=[self.id]) #reverse는 해당 주소를 반환함 /blog/10 이렇게 즉 성공시 해당 디테일뷰로 이동가능하게함
				 
# myapp/views.py
post_detail = DetailView.as_view(model=Post)

# myapp/urls.py
urlpatterns = [
 	url(r'^(?P<id>\d+)/$', views.post_detail, name='post_detail'),
]



```

valid 판정을 받으면, 저장하고 post.get_absolute_url() 주소로 이동 

```

# myapp/views.py
from django.views.generic import CreateView, UpdateView
from .models import Post

post_new = CreateView.as_view(Post)
post_edit = UpdateView.as_view(Post) #두 코드 모두 success_url제공안했으므로  성공하면 모델에 get_absolute_url를 찾아서 자동이동 따라서 detail모델클래스에서는 반드시 get_absolute_url 꼭 구현해놓자

# myapp/urls.py
urlpatterns = [
   url(r'^new/$', views.post_new, name='post_new'),
   url(r'^(?P<id>\d+)/edit/$', views.post_edit, name='post_edit'),
]

```



HTML 템플릿은 FBV에서와 동일합니다

```
<!-- myapp/templates/myapp/post_form.html -->
<form action="" method="post">
     {% csrf_token %}
     <table>
     {{ form.as_table }}
     </table>
     <input type="submit" />
</form>
```





### DeleteView

- [GET/POST 요청] 지정 Model Instance 삭제확인 밎 삭제
- Model 옵션(필수)
- success_url 옵션 (필수)
- 디폴트 템플릿 경로 : "앱이름/모델명소문자_confirm_delete.html"
- GET 요청 : 삭제의사를 물어봅니다.
- POST 요청 : 삭제를 수행하고, 지정된 success_url 로 이동합니다.



#### 샘플 코드

```
# myapp/views.py
from django.views.generic import DeleteView
from .models import Post

# valid판정받고 저장되면, post.get_absolute_url() 주소로 이동
post_delete = DeleteView.as_view(Post,
     success_url=reverse_lazy('myapp:post_list'))
 
# myapp/urls.py
urlpatterns = [
   url(r'^(?P<id>\d+)/delete/$', views.post_delete, name='post_delete'),
]
```

```
# templates/blog/post_confirm_delete.html
#단순히 html의 form을 씀. 이유는 유저에게 받을 값이 없기때문에 이걸로도충분함.
 단, 유저로 부터 암호등의 값을 받아야한다면 장고 폼 써야함

<body>
<h1> {{ post }} 삭제 확인</h1>

정말삭제하시겠습니까?

<form action="" method="post">
    {% csrf_token %}
    <a href="{{ post.get_absolute_url }}">아니요. 취소</a>
    <input type="submit" value="예. 삭제하겠습니다" />

</form>

</body>
</html>

```



## reverse_lazy

- 모듈 import 시점에 url reverse가 필요할 때 사용

  - 전역변수/클래스변수

  ```reverse(blog:post_list)를 실행하면 주소를 반환하여 success_url에 사용가능할것같지만 오류가뜸```  __이유는 reverse는 모든 프로젝트가 초기화를 한후에 실행해야하는데 이것은 ```post_delete = DeleteView.as_view(model=Post, success_url=reverse('blog:post_list'))``` 초기화중에 실행되므로 오류가 뜸

- 따라서 reverse_lazy를 사용하자 (필요 사용할때까지 지연시키므로가능)

- ex) Class 선언 시에

```
# myapp/views.py
from django.views.generic import CreateView
from django.urls import reverse_lazy
from .models import Post


class PostCreateView(CreateView): #커스텀 CBV만드는중
     model = Post
     success_url = reverse_lazy('blog:post_list') # !!!

 def form_valid(self, form):
     post = form.save(commit=False)
     post.ip = self.request.META['REMOTE_ADDR']
     post.user_agent = self.request.META['HTTP_USER_AGENT']
     return super().form_valid(form)
```

- ex) django settings module 에서

```
# myproj/settings.py
from django.urls import reverse_lazy

# LOGIN_URL = '/accounts/login/' # DO NOT
LOGIN_URL = reverse_lazy('login') # DO !!!

# LOGIN_REDIRECT_URL = '/accounts/profile/' # DO NOT
LOGIN_REDIRECT_URL = reverse_lazy('profile') # DO !!!

#즉 url필요한 부분 직접쓰지말고 reverse로 쓰면 더 간편함
```

