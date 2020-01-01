---
title: 프론트엔드 기본편 1
date: 2019-12-08 15:17:51
categories: Frontend
tags: [Frontend, Django, Ajax]
---

# 강의 시작 전

## 필요한 기능

- blog앱
  - Post모델의  list/detail/edit/delete
  - Comment 모델의 list/edit/delete
  - 코멘트에 post_id를 선택하는것이 아니라 그것은 자동지정해주고 댓글만 폼에서 받아내는것이므로 아래 코드 참고하자 

```
# views.py


def index(request):
    return render(request, 'blog/index.html')

index = ListView.as_view(model=Post, template_name='blog/index.html')
post_new = CreateView.as_view(model=Post, fields="__all__")
post_detail = DetailView.as_view(model=Post)
post_edit = UpdateView.as_view(model=Post, fields='__all__')

class PostDeleteView(DeleteView):
    model = Post
    success_url = reverse_lazy('blog:index')

class CommentCreatView(CreateView):
    model = Comment
    fields = ['message']

    def form_valid(self, form):
        comment = form.save(commit=False)
        comment.post = get_object_or_404(Post, pk=self.kwargs['post_pk']) #kwargs는 url인자
        return super().form_valid(form)

    def get_success_url(self):
        #현재 저장한 object가 self.object에 존재함!!!
        return resolve_url(self.object.post)

comment_new = CommentCreatView.as_view()

class CommentUpdateView(UpdateView):
    model = Comment
    fields = ['message']

    def get_success_url(self):
        # 현재 저장한 object가 self.object에 존재함!!!(self.commnet인득?)
        return resolve_url(self.object.post)

comment_edit = CommentUpdateView.as_view(model=Comment, fields=['message'])

class CommentDeleteView(DeleteView):
    model = Comment

    def get_success_url(self):
        # 현재 저장한 object가 self.object에 존재함!!!(self.commnet인득?)
        return resolve_url(self.object.post)

comment_delete = CommentDeleteView.as_view(model=Comment)
```





# 시작하기

- HTML 
- CSS
- JavaScript 

위 세 언어는 웹브라우저에서 구동되는 언어입니다. 그래서 웹프론트엔드 언어라고 부릅니다.

웹브라우저는 서버로부터 HTML/CSS/JavaScript 코드를 받아서, 이를 그래픽적으로 해석해서 유저에게 보여줍니다. 

- HTML (Hyper Text Markup Language) : 문서를 구조적으로 표현
- CSS (Cascasding Style Sheet) : 웹페이지의 각 스타일을 정의
- JavaScript : 웹페이지내 로직을 구현

## 1) 한 HTML파일에 CSS/JavaScript를 모두 넣을 수도 있구요

css는 내용보다 앞에 둠(스타일이 먼저 로딩되어야하므로)

js를 맨뒤에 두는게 좋음 (로직쪽이며 로딩이 느릴가능성높음)

```
<!doctype html>
<html>
<head>
   <meta charset="utf-8" />
   <title>AskDjango Blog</title>
   <style> #CSS를 inline으로 넣을수있다.
       body { background-color: lightyellow; }
       #post_list .post { margin-bottom: 3px; }
   </style>
</head>
<body>
   <ul id="post_list">
       <li class="post">파이썬 차근차근 시작하기</li>
       <li class="post">크롤링 차근차근 시작하기</li>
       <li class="post">파이썬으로 업무 자동화하기</li>
       <li class="post">장고 기본편</li>
       <li class="post">서비스 배포하기</li>
   </ul>
   <script> #js도 inline으로 넣음
       /* CSS만으로 충분하지만, Javascript도 같이 넣어봤습니다. */
       var posts = document.getElementsByClassName('post');
       for(var i=0; i<posts.length; i++) {
           var post = posts[i];
           post.style.backgroundColor = 'pink';
       }
   </script>
</body>
</html>
```

## 2) CSS/JavaScript 파일을 별도 파일로 관리하실 수도 있습니다.

```
#blog.html

<!doctype html>
<html>
<head>
     <meta charset="utf-8" />
     <title>AskDjango Blog</title>
     <link rel="stylesheet" href="blog.css" />  #rel속성을 꼭 넣어줘야함
</head>
<body>
     <ul id="post_list">
         <li class="post">파이썬 차근차근 시작하기</li>
         <li class="post">크롤링 차근차근 시작하기</li>
         <li class="post">파이썬으로 업무 자동화하기</li>
         <li class="post">장고 기본편</li>
         <li class="post">서비스 배포하기</li>
     </ul>
     <script type="text/javascript"src="blog.js"></script> #type구지사용안해도 지금js로 통일되어있으므로 안써도 작동함, 꼭 />하면안됨
</body>
</html>
```

별도 파일 css 예시

```
body {
 background-color: lightyellow;
}
#post_list .post {
 margin-bottom: 3px;
}
```

별도 파일 js 예시

```
var posts = document.getElementsByClassName('post');  #포스팅들을 얻어와서
for(var i=0; i<posts.length; i++)  #posts.length: 포스트 총 갯수반환, 순회를 돌면서 i를 1씩 증가시킴, post[i]각각에 접근해서 post돔에 . style . backgroundColor로 핑크!
{
 var post = posts[i];
 post.style.backgroundColor = 'pink';
}
```

### 대개의 경우 CSS/JavaScript와 같은 정적인 파일은 별도 파일로 관리

- HTML 응답크기를 줄일 수 있습니다. 
- 여러 번 새로고침하더라도, 브라우저 캐싱기능을 통해 같은 파일을 서버 로부터 다시 읽어들이지 않습니다. 
- 웹페이지 응답성을 높여줄 수 있습니다.

### CSS 파일

- 처음에는 직접 CSS 날코딩을 하시고,
- 추후에는 성향에 따라 __Sass__, Less를 검토해보세요.
- sass, less 문법으로 작성된 코드를 빌드하여, css파일을 만들어냅니다.(Sass추천?)

### JavaScript

- 처음에는 직접 JavaScript 날코딩을 하시고,
- 추후에는 성향에 따라 TypeScript를 검토해보세요.(언어임)
  - TypeScript 문법으로 작성되는 코드를 빌드하여, javascript파일을 만들어냅니다.

## 웹 프론트엔드와 백엔드

- 웹개발은 크게 백엔드와 프론트엔드 개발로 나눠집니다. 장고는 백엔드에 초점이 맞춰 진 웹프레임워크입니다.
- 장고를 공부하실 때에는 백엔드에 포커스를 맞춰서 공부하시고, 웹프론트엔드는 최소화 하세요.
  - 2가지를 모두 한번에 잘할 수는 없습니다. 우선순위를 백엔드에 먼저 두세요. Android/iOS 앱도 일단 미뤄두세요.
  - 단 1번에 완전한(?) 웹서비스를 만들 순 없습니다. 점진적으로 개선해가세요.

## 백엔드 개발언어와 프론트엔드 개발언어

- 프론트엔드 개발언어 (클라이언트단 중 하나1 ) 
  - 브라우저 단에서 실행이 됩니다. 
  - HTML/CSS/JavaScript의 조합 • 백엔드 개발언어 (서버 단) 
- 클라이언트 단의 요청을 처리/응답만 할 수 있으면 됩니다.
  - 다양한 언어가 가능하며, 여러 언어/프레임워크를 섞어쓰실 수도 있습니다. (Python, NodeJS, Ruby, Java 등)

## 웹 요청/응답

- 웹은 HTTP(S) 프로토콜로 동작합니다.
- 하나의 요청은 클라이언트가 웹서버로 요청하며, 웹서버는 요청에 맞게 응답을 해야합니다. 
  - 응답은 HTML 코드 문자열, CSS 코드 문자열, JavaScript 코드 문자열, Zip, MP4 등 어떠한 포맷이라도 가능합니다. 
- 웹서버에서 응답을 만들 때, 요청의 종류를 구분하는 기준 
  - URL (일반적), 요청헤더, 세션, 쿠키 등 
- 웹서버 구성에 따라 
  - /static/flower.jpg : JPG파일 내용을 응답으로 내어주도록 설정했습니다. 
  - /blog/images/flower.jpg : 장고 View를 통해, JPG파일 내용을 응답으로 내어주도록 설정했습니다.
  - /blog/images/flower/ : 장고 View를 통해, JPG파일 내용을 응답으로 내어주도록 설정했습니다.
- 웹서버 구성에 따라, 특정 요청에 대한 응답을 Apache/Nginx 웹서버에도 할 수도 있고 Django 뷰에서 응답을 할 수도 있다

### 일반적인 장고 페이지의 예

```
포스팅 목록 페이지 : /blog/
# blog/urls.py
from django.conf.urls import url
from . import views

urlpatterns = [
	 url(r'^blog/$', views.post_list, name='post_list'),
]
# bl
og/views.py
from django.shortcuts import render
from .models import Post

def post_list(request):
     return render(request, 'blog/post_list.html', {
           'post_list': Post.objects.all(),
     })
```

### HTML 템플릿

```
blog/post_list.html
<!doctype html> <html> <head>

    <meta charset="utf-8" />

    <title>AskDjango Blog</title>
</head>
<body>

    <h1>AskDjango Blog</h1>

    <ul>
         {% for post in post_list %}

        <li>
         {{ post.title }}
         </li>
         {% endfor %}
     </ul>

<hr/>
 &copy; 2017, AskDjango.
</body>
</html>
```

### 이 화면이 그려지기까지, 처리순서

단지, 하나의 HTTP 요청에 대해, 하나의 HTTP 응답을 받습니다.

1. 브라우저에서 서버로 HTTP 요청

2. 서버에서는 해당 HTTP요청에 대한 처리 실행 : 장고에서는 관련 뷰 함수가 호출

3. 뷰 함수에서 리턴해야만 비로소 HTTP응답이 시작되며, 그 HTTP 응답을 받기 전까지는 하얀 화면만 보여집니다. __따라서 뷰 처리시간이 길어질수록 긴 화면이 보여지는 시간이 길어집니다.__

4. 브라우저는 서버로부터 HTTP 문자열 응답을 1줄씩 해석하여, 그래픽적으로 표현합니다. 

   

   아직, HTML 문자열 응답에 추가 리소스 (CSS, JavaScript, Image 등) 가 없습니다.

### 만약 HTML 문자열 응답에 추가 리소스가 지정되어있다면?

HTML 문자열은 1줄씩 처리되며, 외부 리소스는 해당 리소스가 로딩완료/실행될 때까지 대기합니다.

아래 예시에는 link, script 가 외부이므로.

```
<!doctype html>
<html>
<head>
     <meta charset="utf-8" />
     <title>AskDjango Blog</title>
     <link rel="stylesheet" href="/static/style.css" />
     <script src="/static/jquery-3.2.1.min.js"></script>
</head>
<body>
     <h1>AskDjango Blog</h1>
     <ul>
         {% for post in post_list %}
         <li>
         {{ post.title }}
         </li>
         {% endfor %}
     </ul>
     <hr/>
     &copy; 2017, AskDjango.
</body>
</html>
```

### HTML UI 응답성이 낮아지는 경우

- 과도한 JavaScript 로딩 및 계산
- 과도한 CSS 레이아웃 로딩 및 계산
- 잦은 시각적 개체 업데이트

### HTML UI 응답성을 높이기 위해

- 실서비스시에 CSS/JavaScript파일은 __Minify__시켜서 다운로드 용량을 줄입니다.
- 대개 CSS를 HTML컨텐츠보다 앞에 위치시키고 
  - CSS가 컨텐츠보다 뒤에 위치한다면, 유저에게는 스타일이 적용되지 않은 HTML컨텐츠가 먼저 노출될 수 있습니다. 
- JS를 HTML컨텐츠보다 뒤에 위치시킵니다.
  - JS는 스타일에 직접적인 영향을 끼치지 않기 때문에, HTML컨텐츠보다 나중 에 로딩되어도 대개 괜찮습니다. 꼭 필요한 몇몇 JS는 HTML컨텐츠보다 앞에 위치시키기도 합니다

## 초기 웹과는 달라진 JavaScript의 위상

js는 그냥 effect였지만

구글맵이 나면서 웹 애플리케이션의 세계 오픈, 그냥 링크가아니라 웹 애플리케이션! 구글 지도참조

#  CSS Layout

- 각 HTML 엘리먼트에 대한 스타일을 기술
- MDN web docs css에서 참고서 지도서 데모 하면 기초다질수있다

## Table 기반의 레이아웃이 흥하던 시절이 있었습니다

- HTML로 문서의 구조를, CSS로 스타일링을 한다는 개념이 보급되기 전에는 태그로 레이아웃을 잡았었죠.

NARADESIGN, 웹 표준 코딩의 장점, Table for Layout과 CSS Layout의 비교실험 

- Table for Layout은 개발하기에 직관적인 레이아웃이지만, 웹표준 방식에 맞지 않습니다.

CSS Layout 방식은? 

> 코드 용량 절감
>
> 사람이나 컴퓨터가 이해하기 쉬운 구조
>
> 쉬운 유지보수

## 그런데, CSS로 스타일 잡기 너무 어렵습니다

- 지금도 브라우저 간의 파편화는 존재합니다.
- 바닥부터 한땀한땀 CSS 스타일링을 하는 것은 너무나도 고통스럽습니 다. 더군다나 우리는 백엔드 개발자 !!! :( 
- 게다가 반응형 웹페이지까지 할려면, @_@;;;

#### 반응형 웹

- 브라우저의 가로크기에 따라 각기 다른 CSS 스타일을 적용 (다른 레이아웃 을 적용) 되는 웹페이지 
- CSS Media Queries를 통해 구현

```
/* 브라우저의 가로크기가 600px 이하일 경우, 아래 스타일이 적용 */
@media (max-width: 600px) {
     body {
     background-color: green;
     }
}
```

#### 반응형 웹의 단점

- 예전에는 모바일/데스크탑 페이지를 따로 만드는 경우도 많았으나, 반응형 웹으로 구현 하면 한 페이지에서 모바일/데스크탑 페이지를 한 페이지에서 대응 가능 
- 모든 해상도 대응을 위한 CSS/이미지를 모두 불러와야 하므로, 로딩 시간이 길어집니다. 
- 복잡한 컨텐츠에는 맞지 않습니다. 레이아웃과 컨텐츠가 복잡하지 않아야, 일관된 UX을 제공할 수 있습니다.
-  따로 분리하는 것이 더 나은 선택일 수도 있습니다. 네이버는 모바일페이지 https:// m.naver.com 와 데스크탑페이지 https://naver.com 가 서로 분리되어있습니다. 



## CSS Frameworks

- 초기 구성의 용이함
- 기본적인 CSS스타일을 이미 구성
- 이미 일정 수준의 작업이 되어있기에, 원하는 레이아웃으로 작업해서 초기 웹페이지를 구성하기에 편리
- 하지만, 같은 CSS Frameworks를 쓴 사이트는 같은 서비스인 것처럼 보여집니다... :( 
- 구성하기 나름이죠. CSS Frameworks 만으로 끝나지 않습니다. 시작은 쉽게 하되, 좋 은 디자인을 뽑아내기 위해서는 커스텀이 필요한 시점이 옵니다. 2

### Best Css Frameworks of 2019

- __Bootstrap__
- Bulma
- Pure.css : 사이즈가 작고 Flat한 디자인
- Kube • Materialize • Vuetify

__Bootstrap4 사용!__

기본 스타일도 좋고 • 반응형도 잘 지원하고 • Bootstrap4는 아직 시작단계이며, 아직 Bootstrap3에서 보다 다양한 무료/유료 테 마들이 있습니다



### Bootstrap34 , CDN 배포판 활용

```
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
```

bootstrap은 jquery에 의존성이 있습니다. 필히 bootstrap javascript보다 jquery가 먼저 선언되어야 합니다.

### CDN

최적화된 전세계적으로 촘촘히 분산된 서버로 이루어진 플랫폼 전 세계의 유저에게 빠르고 안전한 정적파일 전송

- 우리는 하나의 원본(Origin)서버를 가지고, 
- CDN 서비스 업체에서는 전 세계에 걸쳐 컨텐츠 서버를 가지고 있고, 원본 서버로부터 각 컨텐츠 서버로 데이터를 복제합니다.
- 전 세계의 유저들이 동일한 주소로 컨텐츠를 요청을 하면, CDN 서비스에서 는 이 요청을 해당 유저와 물리적으로 가까운 CDN 콘텐츠 서버에서 응답토 록 구성합니다.



### 다양한 Bootstrap3 테마 사이트

- Bootswatch
- Start Boostrap
- Wrap Bootstrap
- themeforest 

이쁘다고 아무 테마나 사지마세요. 어떤 프론트엔드 기술이 적용되어있는 지 꼼꼼하게 체크하셔야 합니다

장고 프로젝트에 Bootstrap3 및 커스텀 테마를 적용해보세요.

```
프로젝트에 template/layout.html
특히 css는 head에 js는 body맨끝에 놓기
그리고 프로젝트에 template폴더이므로 settings.py에 templates에 dirs에 경로 추가해주기

'DIRS': [
            os.path.join(BASE_DIR, 'front_end_prac', 'templates'),
        ],
        
        
        
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>AskDjango Blog</title>

        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />

    </head>
    <body>
         <h1>AskDjango Blog</h1>

         {% block content %}
         {% endblock %}
    <hr/>

    2017 &copy; <a href="https://nomade.kr"
                   target=_blank">nomade.kr"</a>

    <script src="//code.jquery.com/jquery-2.2.4.min.js"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </body>
</html>


#blog/templates/layout.html

{% extends "layout.html" %}

#blog/templates/index.html 등다른것들은
{% extends "blog/layout.html" %}

```



### 꿀팁

```
pip install django-bootstrap3
한다음에
settings.py에서 installed_apps에서 'bootstrap3' 추가후

해당 원하는 곳에가서
{% load bootstrap3 %}

{% bootstrap_form form %}같이 쓸수있음
위 명령어 안에               {{ form.as_table }}까지 포함되어있으므로 삭제하자

```

# JavaScript와 jQuery

## JavaScript

- 웹브라우저 내에서 주로 구동되던 프로그래밍 언어
- 구글이 크롬 브라우저에서 사용되는 V8엔진을 오픈소스로 풀어버림.
  - 자바스크립트를 실행하기 전에 컴파일한 후에 실행
  - 이 V8엔진을 통해 nodejs1 플랫폼이 개발됨
- 주로 웹서비스 개발에 많이 사용, Electron을 통해 Desktop 애플리케이션도 만듬



## jQuery

- 2006년, jQuery 출시
  - 그 전에는 브라우저 별로 파편화가 무척 심했습니다. 프론트엔드 개발 HELL ~
  - jQuery는 단일 API로 Ajax요청과 DOM조작을 편리하게 해줍니다.
- 하지만, 최근에는 jQuery를 안 쓰는 경우가 많음. 
  - 무거워진 jQuery, 하지만 방대한 기존 jQuery 플러그인
  - 보다 근대화된 브라우저
  - 보다 발전된 Web API

### jQuery CDN 버전

```
<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<script>
// 이후에 필요한 자바스크립트 코드 구현
$(function() {
 		console.log("웹페이지 로딩 완료");
});
</script>
```

### 각 코드 비교

모두 동일한 동작을 하는 코드

```
// 예전 JavaScript 스타일
var div = document.getElementsByTagName('div')[0];
div.className += ' foo';

// jQuery
jQuery('div:first').addClass('foo');

// 최신 브라우저에서 지원하는 자바스크립트 API
document.querySelector('div').classList.add('foo');
```

### 이제 더 이상 jQuery를 잘 사용하지 않게 되었습니다..

- 구글검색: jQuery를 쓰면 안 되는 이유
- 대부분의 jQuery 메소드의 대안을 최근 브라우저에서는 네이티브 구현으로 제공
  - 출처: You Don't Need jQuery
- 그렇지만, 자바스크립트를 처음 시작할 때에는 jQuery를 쓰시면, 보다 쉽게 코드를 만들어보실 수 있습니다.
  - 추후에 프론트엔드 프레임워크인 Vue.js와 React-JS를 적용해보겠습니다.
- 우리는 jQuery를 통해, 장고 프로젝트를 좀 더 개선해보도록 하겠습니다



## jQuery사용

### 일단, 브라우저의 개발자 도구 열기

- 프론트엔드 개발에서는 필히 브라우저의 "개발자 도구"를 열어주세요.
  - 웹 개발 시의 브라우저는 Chrome이나 Firefox가 좋습니다. 
- 브라우저 자바스크립트 수행 중에 발생한 오류는 __"console 탭"__에서 확 인하실 수 있어요.



### 구현해볼 기능

1. Event Listener 등록
   - __수많은 이벤트(상황)__가 있지만, 이 중에 대표적으로 onload(현재 문서 로딩완료), click(특정 엘리먼트가 클릭됨), submit(form태그에서 submit이 발생했을때) 이벤트에 대해서만 살펴보겠습니다.
2. DOM 엘리먼트 추가/제거
3. Ajax GET/POST 요청

무조건 jQuery먼저 CDN으로 불러오고 그다음 쓰자





#### 기능1) 이벤트 리스너 등록

onload 이벤트 리스너

이벤트 리스너 등록은 웹페이지 로딩 후에 하는 것이 안전합니다.



```
<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<script>
#(document)대상이 레디가 되었을때 대한 콜백을 등록함 ready(콜백!!)
$(document).ready(function() {
 console.log("웹페이지 로딩 완료");
});
</script>
```

위를 축약표현으로는

```
<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<script>
  $(function() {
   console.log("웹페이지 로딩완료");
  });
</script>
```

#### click 이벤트 리스너

어떤 DOM 3 엘리먼트에도 click 이벤트 리스너를 등록하실 수 있습니다.

(ul에는 여러가지항목에 대해 리스너 등록 예시)

```
<a id="btn-naver-1" href="http://m.naver.com" target="_blank">Naver Button 1</a>
<a id="btn-naver-2" href="http://m.naver.com" target="_blank">Naver Button 2</a>
<ul id="my-list">
   <li>list1</li>
   <li>list2</li>
   <li>list3</li>
</ul>
```

```
<script>
$(function() {
     // 리스너에 리턴값이 없기 때문에
     // 아래 리스너가 호출될 뿐만 아니라, href 링크가 동작
     // #은 id를 가르킴!!
     $('#btn-naver-1').click(function() {
     console.log('clicked btn-naver-1');
     });
     
     // 아래 리스너가 호출되지만, href 링크는 동작하지 않습니다.
     // function(이벤트)에서 이벤트 지정가능
     $('#btn-naver-2').click(function(e) {
     e.preventDefault(); // 디폴트 동작 수행 방지. 혹은 이부분지우고 return false; 도 동일한 효과!!
     console.log('clicked btn-naver-2');
     // return false; // true를 리턴하면, 위 태그 클릭 시의 디폴트 동작 수행
     });
     
     //id=my-list밑에 li에검
     $('#my-list li').click(function() {  
     var content = $(this).html();
     console.log('clicked : ' + content);
     });
});
</script>
```

#### submit 이벤트 리스너

Form 엘리먼트에 대한 submit 이벤트 리스너를 등록하실 수 있습니다.

```
<form id="query-form">
     <input type="text" name="query" />
     <input type="submit" value="조회" />
</form>

<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<script>
//id가 quert-form인 태그에서 submit을 막는것
$(function() {
     $('#query-form').submit(function(e) {
         e.preventDefault();
         console.log("form submit");
     });
});
</script>
```

#### 기능2) DOM 엘리먼트 추가/제거

- 버튼 태그는 form태그안에서는 submit효과를 가지지만 밖이면 이렇게 쓰면 아무런 효과없다

```
<button id="lotto-btn">로또 번호를 점지해주세요.</button>
<button id="remove-at-first">처음을 삭제</button>
<button id="remove-at-last">마지막을 삭제</button>

<div id="lotto-list"></div>
```

```
<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<script>
$(function() {
     $('#lotto-btn').click(function() {
         var rendered = '<div class="post">로또 번호를 뽑아봅시다 : ' + (new Date()) + '</div>';
         
         // var container = $('#lotto-list').append(rendered); // append 활용
         var $added = $(rendered).appendTo('#lotto-list'); // appendTo 활용. 추가된 jQuery객체를 리턴.
         $added.click(function() {
       		  $(this).remove(); // 각 항목
         });
     });
     
     $('#remove-at-first').click(function() {
         $('#lotto-list div:first').remove(); //id=lotto-list에서 div태그에 첫번째꺼!
     });
     
     $('#remove-at-last').click(function() {
    		 $('#lotto-list div:last').remove();
     });
});
</script>
```

참고) jQuery에서 지원하는 Selector : https://api.jquery.com/category/selectors/



#### 별도 템플릿을 통한 추가

underscore.js  의 템플릿 시스템 활용(django템플릿처럼)

https://underscorejs.org/#template

```

<button id="lotto-btn">로또번호 생성하기</button>

<div id="lotto-list"></div>

<!-- 복잡한 문자열을 custom script 태그를 통해 정의하기 -->
<!-- javascript로서 처리되지 않도록, 임의 type 지정!!!!!!!! -->
<!-- 아래<%= numbers %>는 underscorejs의 변수 출력 문법임 -->
<script id="post-template" type="text/x-template">
     <div class="post">
     		당첨번호는 <%= numbers %>이며, 보너스 번호는 <%= bonus %>입니다.
     </div>
</script>

<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
<script>
$(function() {
     var raw_template = $('#post-template').html(); //해당아래것들을 문자열로만가져옴
     var tpl = _.template(raw_template); //이렇게 문자열을 넣어주면 템플릿반환
     
     $('#lotto-btn').click(function() {
         var sample = _.sample(_.range(1, 46), 6);
         //이렇게 아래처럼 쓰면 알아서 받아서 집어넣고 문자열로 만들어줌
         var rendered = tpl({
         numbers: sample.slice(0, 5).sort(function(x, y) { return x - y; }), 
         bonus: sample[5]
         }); 
         console.log(rendered);
         $(rendered).appendTo('#lotto-list');
     });
});
</script>

```

프론트단에서 모두 계산완료

#### 기능3) Ajax GET/POST 요청

자바스크립트를 통한 비동기 HTTP 요청 - Asynchronous JavaScript and XML

- HTTP 요청 Method

  - GET 요청 : 주로 검색/조회/페이징처리 시에 사용

  - POST 요청 : 주로 수정/삭제 처리 시에 사용 

- 브라우저의 동일 도메인 참조 정책 (Same-Origin Policy) 

  - 같은 프로토콜/호스트명/포트 내에서만 Ajax 요청이 가능 

  - 초기에는 웹사이트의 보안을 위한 좋은 방법으로 생각되었으나, 최근 여러 도메인에 걸쳐서 구성되는 웹서비스가 늘어나는 시점에서는 거추장스 러운(?) 기술??? 그래서, Cross Domain Request를 허용하기 위해 __CORS(Cross Origin Resource Sharing) 지원__ (서버측 셋업이 필요) 

    CORS 설정: 모든 도메인에 대해서 허용한다면, 서버 측 응답헤더에 Access-Control-Allow-Origin: *를 추가

  - 혹은 서버에 요청을 위임하여, 요청을 Proxy처리하기도 합니다.
  - JSONP방식은 Proxy처리에 사용되는 방식이아니라, Same-Origin Policy를 우회하는 방식입니다.

- Django 뷰에서는 POST를 받을 때 CSRF Token값을 체크합니다. CSRF Token값이 없거나 값이 맞지 않으면 400 Bad Request 응답을 합니다. Django에서의 대응은 Django 공식문서를 참고하세요.

#### 다른 도메인에 요청으로 하므로, 실패하는 Ajax GET 요청

같은 도메인이라면 요청이 성공할 것입니다

```
$.ajax({
     method: "GET",
     url: 'http://www.melon.com/search/keyword/index.json?jscallback=?', // 다른 도메인입니다 !!!
     data: {query: '윤종신'},
     cache: false // true 지정 : GET인자로 "_={timestamp}" 를 붙여줍니다. 매번 URL이 달라지므로 브라우저 캐싱되지 않습니다.
})
.done(function(response, textStatus, xhr) {
     console.log("---- done ----");
     console.log(response);
     console.log(textStatus);
     console.log(xhr);
})
.fail(function(xhr, textStatus, error) {
     console.log("---- fail ----");
     console.log(xhr);
     console.log(textStatus);
     console.log(error);
})
.always(function(response_or_xhr, textStatus, xhr_or_error) {
 // 인자가 done/fail 인자 매핑과 동일
});
```

#### 개발자도구, 오류 메세지

> XMLHttpRequest cannot load http://www.melon.com/search/ keyword/index.json?jscallback=? &query=%EC%9C%A4%EC%A2%85%EC%8B%A0&_=150451 5550905. No 'Access-Control-Allow-Origin' header is present on the requested resource. Origin 'null' is therefore not allowed access.

교차 원본 요청 차단: 동일 출처 정책으로 인해 [요청한 도메인]에 있는 원 격 자원을 읽을 수 없습니다. 자원을 같은 도메인으로 이동시키거나 CORS 를 활성화하여 해결할 수 있습니다.

#### JSONP 5 의 예

 JSONP:  태그는 SOP정책에 속하지 않음을 이용하여, 서로 다른 도메인/포트 간에 JSON GET통신을 할 수 있는 방법

```
$.ajax({
     method: "GET",
     url: 'http://www.melon.com/search/keyword/index.json?jscallback=?', // jsonp 핵심포인트 1) : jscallback=? 인자
     data: {query: '윤종신'},
     dataType: 'json', // jsonp 핵심포인트 2)
     cache: false // true 지정 : GET인자로 "_={timestamp}" 를 붙여줍니다. 매번 URL이 달라지므로 브라우저 캐싱되지 않습니다.
	 })
   .done(function(response, textStatus, xhr) {
     console.log("---- done ----");
     console.log(response);
     console.log(textStatus);
     console.log(xhr);
	 })
   .fail(function(xhr, textStatus, error) {
     console.log("---- fail ----");
     console.log(xhr);
     console.log(textStatus);
     console.log(error);
	 })
     .always(function(response_or_xhr, textStatus, xhr_or_error) {
     // 인자가 done/fail 인자 매핑과 동일
 	});
```

#### Shortcut: jQuery.get (https://api.jquery.com/jquery.get/)

dataType='json'지정이 필요한데, dataType 속성을 지정할 수 없으므로, 아래 요청은 실패합니다.

3가지

```
var params = {query: '윤종신'};

$.get("http://www.melon.com/search/keyword/index.json?jscallback=?", params)
     .done(function(response, textStatus, xhr) {
         console.log("---- done ----");
     })
     .fail(function(xhr, textStatus, error) {
         console.log("---- fail ----");
         console.log(xhr);
         console.log(textStatus);
         console.log(error);
     })
     .always(function(response_or_xhr, textStatus, xhr_or_error) {
         // 인자가 done/fail 인자 매핑과 동일
     });
```

#### Shortcut: jQuery.getJSON

__dataType 속성이 'json'으로 자동지정__되므로, 아래 요청은 성공합니다.

```
var params = {query: '윤종신'};

$.getJSON("http://www.melon.com/search/keyword/index.json?jscallback=?", params)
     .done(function(response, textStatus, xhr) {
         console.log("---- done ----");
         console.log(response);
         console.log(textStatus);
         console.log(xhr);
     })
     .fail(function(xhr, textStatus, error) {
         console.log("---- fail ----");
         console.log(xhr);
         console.log(textStatus);
         console.log(error);
     })
     .always(function(response_or_xhr, textStatus, xhr_or_error) {
         // 인자가 done/fail 인자 매핑과 동일
     });
```

#### Shortcut: jQuery.post

추후 장고 연동 시에 샘플을 살펴보겠습니다



```
var params = {};
$.post("/posts/100/delete/", params)
       .done(function
      (response, textStatus, xhr){
           console.log("---- done ----");
           console.log(response);
           console.log(textStatus);
           console.log(xhr);
       })
       .fail(function
      (xhr, textStatus, error){
           console.log("---- fail ----");
           console.log(xhr);
           console.log(textStatus);
           console.log(error);
       })
       .always(function
      (response_or_xhr, textStatus, xhr_or_error){
           // 인자가 done/fail 인자 매핑과 동일
       });
```

### 실습(멜론 검색결과 구현하기)

```
<!doctype html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Melon 검색</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
</head>
<body>

    <div class="container">
        <div class="row">
            <div class="col-sm-12">
                <form id="melon-query-form" class="input-group" style="margin: 20px 0;">
                    <input type="text" name="q" class="form-control" autocomplete="off" />
                    <span class="input-group-btn">
                        <input type="submit" class="btn btn-default" />
                    </span>
                </form>

                <ul id="media-list">
                </ul>
            </div>
        </div>
    </div>

<script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script id="song-template" type="text/x-template">
    <div class="media">
        <div class="media-left">
            <a href="http://www.melon.com/song/detail.htm?songId=<%= SONGID %>" target="_blank">
                <img src="<%= ALBUMIMG %>" class="media-object" style="widwth: 64px; height: 64px;" />
            </a>
        </div>
        <div class="media-body">
            <h4>
                <a href="http://www.melon.com/song/detail.htm?songId=<%= SONGID %>" target="_blank">
                    <%= SONGNAME %>
                </a>
            </h4>
            <%= ALBUMNAME %> by
            <%= ARTISTNAME %>
        </div>
    </div>
</script>

<script>
function melon_search(query) {
    var params = {
        'query': query,
    };
    $.getJSON('http://www.melon.com/search/keyword/index.json?jscallback=?', params)
        .done(function(resp) {
            console.log(resp);
            $('#media-list').html('');
            var tpl = _.template($('#song-template').html());
            $(resp.SONGCONTENTS).each(function() {
                console.log(this);
                // var html = tpl(this);
                // $(html).appendTo('#media-list');
                $('<div class="media">' +
                    '<div class="media-left">' +
                    '<a href="http://www.melon.com/song/detail.htm?songId=' + this.SONGID + '" target="_blank">' +
                    '<img src="' + this.ALBUMIMG + '" class="media-object" style="widwth: 64px; height: 64px;" />' +
                    '</a>' +
                    '</div>' +
                    '<div class="media-body">' +
                    '<h4>' +
                    '<a href="http://www.melon.com/song/detail.htm?songId=' + this.SONGID + '" target="_blank">' +
                    this.SONGNAME +
                    '</a>' +
                    '</h4>' +
                    this.ALBUMNAME + ' by ' + this.ARTISTNAME +
                    '</div>' +
                    '</div>').appendTo('#media-list');
            });
        });
};
$(function() {
    $('#melon-query-form').submit(function(e) {
        e.preventDefault()
        var q = $(this).find('input[name=q]').val();
        melon_search(q);
    });
});
</script>

</body>
</html>

```



