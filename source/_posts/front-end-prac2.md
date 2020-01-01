---
title: front-end-prac2
date: 2019-12-15 15:35:09
categories: Frontend
tags: [Frontend, Django, Ajax]
---

# 장고에서의 STATIC 파일 관리

## 참고 VOD 요약

[장고 기본편] "Static Files - CSS/JavaScript 파일을 어떻게 관리해야 할까요?" VOD 링크

- 장고는 One Project, Multi App 구조 
- 한 App을 위한 static 파일을 app/static/app경로에 두세요.
- 프로젝트 전반적으로 사용되는 static 파일을 settings.STATICFILES_DIRS에서 참조 하는 경로에 두세요.

```
# myproj/settings.py
STATIC_URL = '/static/' # Static 파일 요청에 대한 URL Prefix
STATICFILES_DIRS = [
 		os.path.join(BASE_DIR, 'myproj', 'static'),
]
```

## 장고에서의 STATIC 파일 서빙

장고의 개발서버에서

```
myproj/static/main.css => http://localhost:8000/static/main.css 경로로 접근 가능
myproj/static/jquery/jquery-2.2.4.min.js => http://localhost:8000/static/jquery/
jquery-2.2.4.min.js
myproj/static/bootstrap/3.3.7/css/bootstrap.min.css => http://localhost:8000/static/
bootstrap/3.3.7/css/bootstrap.min.css
blog/static/blog/style.css => http://localhost:8000/static/blog/style.css 경로로 접근 가능
blog/static/blog/blog.js => http://localhost:8000/static/blog/blog.js 경로로 접근 가능
shop/static/shop/shop.js => http://localhost:8000/static/shop/shop.js 경로로 접근 가능


URL을 통해 STATIC 파일이 저장된 파일시스템에 직접 접근하는 것이 아니라, 지정 이름의 STATIC 파일
을 장고의 StaticFiles Finder에서 대신 찾아 그 내용을 읽어서 응답하는 것

```

## 브라우저 캐시

브라우저 캐시 기간을 설정해 주면(header에서설정) 그 기간 동안은 웹브라우저가 해당 파일을 다시 다운받지 않고 캐싱된 내용을 사용하기 때문에 트래픽이 줄어들고, 속도도 빨라집니다.

- Expires 헤더 MDN #doc : 만료일시를 지정

  - Expires: Wed, 21 Oct 2015 07:28:00 GMT

  - 응답 내에 "max-age" 혹은 "s-max-age" directive를 지닌 CacheControl 헤더가 존재할 경우, Expires 헤더는 무시 

- Cache-Control 

### 이후에 해당 파일이 변경되었습니다. 그런데, 새로운 내용이 반영되지 않습니다. ???

1. 유저는 /blog/ 페이지에 방문하면서 브라우저에 /static/blog/style.css 파일이 다운로드되었습니다. 이때 이 파 일이 24시간 동안 브라우저 캐싱이 되어있다고 생각해봅시다.

2. 그런데, 개발하면서 CSS파일이 변경되었습니다. 파일경로는 바뀌지 않았습니다. 변경된 CSS파일이 유저페이지에 적용되길 원하지만 적용되지 않습니다. 캐싱된 이전 파일에 계속 접근하게 됩니다.

3. 해결하기

   ​	방법1) 해당 파일의 캐싱이 만료될 때까지 기다립니다.

   ​	방법2) 브라우저 설정에서 캐싱된 내용을 삭제합니다. 크롬 브라우저에서는 "강력 새로고침" 3을 통해 수행 가능.

   ​	방법3) 해당 STATIC 리소스의 URL을 변경합니다.

Tip: 방법2)개발 시에 유용합니다. 윈도우 단축키 Ctrl+Shift+R, 맥 단축키 Command+Shift+R (개발자도구띄어놓은상황에서)



### 클라이언트측 캐싱과 빠른 업데이트를 할려면

리소스의 URL을 변경하고 콘텐츠가 변경될 때마다 사용자가 새 응답을 다운로드하도록 하면 됩니다.



1. GET인자 붙이기 : 실제 파일명은 변경하지 않으면서, 브라우저가 인지하는 URL만 변경

   개발 시에 유용

   버전을 숫자로 붙이거나 (아래 예시는 get인자로 버전숫자붙임)(새로운 url로 인식되므로 모든 리소스 새롭게 다운받게됨)

   http://localhost:8000/static/main.css?v=1

   버전을 날짜로 붙이거나

   http://localhost:8000/static/main.css?v=20180618

   더미로 현재시각의 timestamp을 붙입니다.

   http://localhost:8000/static/main.css?_=1503808011

2. 파일명 변경하기

   서비스 배포 시에 유용



### 커스텀 템플릿태그를 통해 STATIC URL에 더미 GET인자 붙이기

필요 위치 경로) myapp/templatetags/static_tags.py



```
import time
from django import template
from django.conf import settings
from django.templatetags.static import StaticNode

register = template.Library()

class VersioningStaticNode(StaticNode):  #장고에서 기본 지원해주는 템플릿 태그
     def url(self, context):
         url = super().url(context)  #기존 스테틱노드에서 url얻고 
         if settings.DEBUG:  #개발모드 일때만 
             t = str(int(time.time())) #소수점까지 붙는 시간을 int로 정수형반환>문자열로 반환
             if '?' not in url:     #(url안에 ? 없다면)
             		url += '?_=' + t
             else:
             		url += '&_=' + t   #?가 이미있다면 get인자가 이미존재하는것이므로 &_뒤에씀
         return url

@register.tag('static_t')
def static_t(parser, token):
		 return VersioningStaticNode.handle_token(parser, token)
```





```
{% raw %}


blog/templates/layout

{% extends "layout.html" %}
{% load static %}

{%  block extra_head %}
    <link rel="stylesheet" href="{%  static "blog/style.css" %}   #경로 반환해줌
{%  endblock %}


{% endraw %}
```



### static_t 태그 활용

```
{% raw %}

{% load static_tags %}
{% static_t "blog/style.css" %}  #사용법

{% endraw %}
```



위 내용은 아래와 같이 렌더링되며, 새로고침할 때마다 더미 GET인자값이 변경됩니다. 같은 파일이지만 브라우저에서는 매번 새로운 URL로 인지하게 됩니다.

/static/blog/style.css?_=1503810446 

아래와 같이 JavaScript/CSS 경로에 사용할 수 있습니다.

```
<link href="{% static_t "blog/style.css" %}" />
<script src="{% static_t "blog/editor.js" %}"></script>
```

### 다양한 STATIC 리소스

- 직접 생성/등록한 CSS/JavaScript/Image 파일들
- 외부 CSS/JavaScript 라이브러리
  - CDN (Contents Delivery Network) 배포판 활용
  - 직접 다운로드&서빙
  - 자바스크립트 팩키지 관리자를 활용하여 다운로드&서빙

### CDN 배포판 활용

- 유명 라이브러리일 경우, 대게 CDN 배포판을 제공
- 개발 시에 빠른 적용을 위해서는 편리

```
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
<script src='https://code.jquery.com/jquery-2.2.4.min.js"></script> <!-- bootstrap은 jquery에 의존성이 있습니다. -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
```

- __안정적인 실서비스 제공을 위해서는 다운로드&서빙을 추천__
  - 정적 파일 서빙을 "관리할 수 없는 외부 서비스"에 의존할 경우, 특정 유 저의 해외망 접속이 원활하지 않거나, 해당 서비스 장애일 경우, 의도치 않게 서비스 이용에 차질이 발생하게 됩니다.

### 직접 다운로드&서빙

- 프로젝트 전반적으로 사용될 파일들이므로, filesystem static finder 에서 접근하는 경로에 넣어두고, 버전관리 대상에도 추가

```
# settings.py
STATIC_URL = '/static/'
STATICFILES_DIR = [
    os.path.join(BASE_DIR, 'askdjango', 'static'),
]   # 여기에 추가해주면 알아서 관리해줌
```

- "프로젝트/static/" 경로

### 자바스크립트 팩키지 관리자를 활용(좋아)

- bower (deprecated) 
  - 트위터에서 만든 프론트엔드 전용 팩키지 관리자
  - bower_components 디렉토리에 다운로드/저장을(만) 해줍니다.
- yarn(추천 기능많음) 
  - JavaScript/CSS 팩키지 관리자
  - node_moduels 디렉토리에 저장
- webpack(여러파일 합쳐줌,,. 따라서 yarn과  같이 잘씀)
  - JavaScript/CSS Bundler
  - https://hyunseob.github.io/2017/03/21/webpack2-beginners-guide/



## Bower (deprecated)

### 먼저 nodejs 설치

- https://nodejs.org/ko/download/

- 설치 확인 

```
쉘> node --version # nodejs 인터프리터 v8.3.0 

쉘> npm --version # nodejs 팩키지 매니저 5.3.0
```









### bower 설치

Deprecated된 라이브러리이지만, yarn보다는 심플한 컨셉입니다. 한 번 경험해봅시다

```
 npm을 통한 설치 : 쉘> npm install -g bowe
 
  homebrew를 통한 설치 : 쉘> brew install bower
```



### CSS/JavaScript 라이브러리 설치



```
 bower install jquery
 bower install "jquery#3.2.1" 
```

bower_components 디렉토리에 다운로드됩니다.

```
bower uninstall jquery # 혹은 해당 디렉토리를 직접 제거하셔도 됩니다.
쉘> bower list
```

### bower.json

```
쉘> bower init 명령을 통해 bower.json 파일 생성 혹은 직접 생성
본 JavaScript/CSS 팩키지를 배포하는 것은 아니기에, 다른 항목은 불필요
{
 "name": "example",
 "dependencies": {
 "jquery": "~3.2.1",
 "bootstrap": "~3.3.7"
 }
}
```

Tip: 버전지정 Rule : "~3.2.1"은 "3.2.1" 이상 "3.3.0" 미만을 뜻합니다



### bower install 명령을 통한 일괄 다운로드(현재창에서 명령시)

bower_components 디렉토리가 생성되며, 그 하위에 다운로드



생성되는 경로 

- bower.json
- bower_components/ 
  - bootstrap/ 
  - jquery/ 

ex) 다운로드 예시 

- bower_components/bootstrap/dist/js/bootstrap.min.js 경로
- bower_components/bootstrap/dist/css/bootstrap.min.css 경로 
- bower_components/jquery/dist/jquery.min.js 경로



### 장고와 연계

- 따로 생성한 bower_components 경로를 settings.STATICFILES_DIRS 경로에 추가

```
# myproj/settings.py
STATICFILES_DIRS = [
     os.path.join(BASE_DIR, 'myproj', 'static'),
     os.path.join(BASE_DIR, 'bower_components'), # 추가
]
```

- bower_components 하위 경로를 참조하여, 템플릿에서 직접 참조

````
{% raw %}


실전예시
#프로젝트/templates/layout.html
{% load static %}

<script src="//code.jquery.com/jquery-2.2.4.min.js"></script>
이것을 변경
<script src="{% static "jquery/dist/jquery.min.js" %}"></script>
<script src="{% static "bootstrap/dist/js/bootstrap.min.js" %}"></script>

결과값 (페이지 소스 보기)

    <script src="/static/jquery/dist/jquery.min.js"></script>
    <script src="/static/bootstrap/dist/js/bootstrap.min.js"></script>




{% endraw %}
````

### .gitignore

bower.json 파일만 버전관리대상에 넣어두고, bower_components는 배포 시에 매번 새롭게 다운받습니다.



```
>>> vi ./.gitignore

안에 
bower_components 추가
```



### 차후 에피소드에서 yarn과 webpack에 대해서 살펴보겠습니다.

## 배포는 지금까지 배운것이 거의 기본 전부

# Ajax with Django 1

## 코드 구현

- List Pagination 

  - HTML만을 통한 페이징 처리

  - Ajax를 통한 페이징 처리
- 뷰에서의 응답 포맷: HTML or JSON
- 무한 스크롤 (Infinite Scroll)





### List Pagination

- List 뷰에서의 페이징 처리 : ListView CBV에서 paginate_by 인자를 지정하면, 페이징 처리를 해줍니다.
  - 관련 context data : paginator, page_obj, is_paginated

```
{% raw %}


from django.views.generic import ListView

class PostListView(ListView):
     model = Post
     paginate_by = 10 # 페이징 처리가 필요할 때, 지정

페이지 이전 다음 만들기
{% if is_paginated %}
     {% if page_obj.has_previous %}
     			<a href="?page={{ page_obj.previous_page_number }}">이전</a>
     {% endif %}
     {{ page_obj.number }} 페이지
     {% if page_obj.has_next %}
     			<a href="?page={{ page_obj.next_page_number }}">다음</a>
     {% endif %}
{% endif %}


{% endraw %}
```

```
{% raw %}


#blog/templates/index.html

{% extends "blog/layout.html" %}

{%  block extra_body %}
<script>

$(function () {
    $('#page-2-btn').click(function () {
        $.get('?page=2')
            .done(function(html) {
                console.log(html);
                $('#post-list-wrapper').html(html); #id가 이것인 html을 다 바꿥
            })
            .fail(function() {
                console.log('fail');
            })
            .always(function () {
                console.log('always');
            });
        return false;

    });
});
</script>

#blog/views.py

class PostListView(ListView):
    model = Post
    template_name = 'blog/index.html'
    paginate_by = 2

    def get_template_names(self):
        if self.request.is_ajax():
            return ['blog/_post_list.html']
        return ['blog/index.html']

이렇게 투가를 해줘야지 ajax일때는 따로 빼놓은 _post_list.html이 html로 전달되어서
layout은 안바뀌고 필요한 내용만 바뀌는 것을 알수있다.


{% endraw %}
```





참고 강의 :

> "클래스 기반 뷰, 잘 알고 쓰기" 코스의 "Generic CBV View - Display/Date" 에피소드 참고
>
> django-bootstrap3 라이브러리 내 bootstrap_pagination 템플릿 태그 #src 참고



### 브라우저 히스토리 조작하기

페이지 전환없이 URL만 조작하기 (예를 들면,즉 url에 지금 ?page=2를 로딩없이 붙일수있다.)

HTML5, history객체의 pushState를 활용

따라서 ajax로 이동후 url도 수정해주고싶은경우 사용

```
var state_obj = {}; // pushState 후에 history.state로 접근 가능
var title = '';
var url = "?page=2"; // 이동할 URL
history.pushState(state_obj, title, url);
```

### 응답포맷

브라우저에서는 HTML 포맷의 데이터가 필요합니다.

1) HTML 포맷을 서버에서 만들어서 응답으로 주거나

```
def my_view_fn_1(request):

     response = render(request, 'myapp/my_view_fn_1.html', {
     'post_list': Post.objects.all(),
     })
     return response
```

2) __서버에서 Raw 데이터 응답을 하면 (주로 JSON포맷), 웹프론트엔드 JavaScript 단에서 이를 HTML포맷으로 변환__

```
from django.http import JsonResponse

def my_view_fn_2(request):
     qs = Post.objects.all()
     
     # list comprehension 문법을 통해, 수동 직렬화
     post_list = [
         {'id': post.id, 'title': post.title }
         for post in qs]
     
     return JsonResponse(post_list, safe=False) # safe=True일 때에는 dict타입만 받고, 아닐 경우 TypeError 예외 발생
     
     #jsonresponse는 직렬화에서 qs를 문자열로 변환해야되는 룰을 알지못해
```

### JSON응답을 하기 위해서는, JSON 직렬화가 필요

ex) QuerySet/Model 객체를 list/tuple/dict으로 변환

- 직접 직렬화 코딩을 하거나
- django-rest-framework 활용
- 아래 예시 사용하기전에 serializers설치후 settings.py에 추가
- pip3 install djangorestframework

```
# myapp/serializers.py
from rest_framework.serializers import ModelSerializer

class PostSerializer(ModelSerializer): # Django Form/ModelForm과 유사
     class Meta:
         model = Post
         fields = '__all__'
         
# myapp/views.py
from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
from .serializers import PostSerializer

def post_list(request):
     qs = Post.objects.all()
     serializer = PostSerializer(qs, many=True)
     json_utf8_string = JSONRenderer().render(serializer.data)
     # return HttpResponse(json_utf8_string) # Content-Type헤더가 text/html; charset=utf-8 로 디폴트 지정
     return HttpResponse(json_utf8_string, content_type='application/json; charset=utf8') # 커스텀 지정
```

Tip >>>curl -i  http://localhost:8000/post.json/ 

해보면 헤드정보 볼수있음



### Ajax HTTP 요청 여부 판단

- Ajax 요청에는 X-Requested-With헤더에 "XMLHttpRequest"값이 전달
- django 뷰에서는 request.is_ajax()로 판단

```
class PostListView(ListView):
     def render_to_response(self, context):
         # Ajax요청이 아니면, 템플릿 응답을 하고
         if not self.request.is_ajax():
         			return super().render_to_response(context)
         
         # Ajax요청일 경우에는 JSON응답을 하겠습니다.
         qs = context['post_list']
         serializer = PostSerializer(qs, many=True)
         json_utf8_string = JSONRenderer().render(serializer.data)
         return HttpResponse(json_utf8_string, content_type='application/json; charset=utf8') # 커스텀 지정
```

[tip](https://github.com/django/django/blob/1.11.5/django/http/request.py#L214)

### django-rest-framework 간단 활용

```
{% raw %}


# myapp/api.py
from rest_framework import generics
from rest_framework.pagination import PageNumberPagination

class PostPagination(PageNumberPagination):
		 page_size = 10
		 
class PostListAPIView(generics.ListAPIView): # CBV
     queryset = Post.objects.all()
     serializer_class = PostSerializer
     pagination_class = PostPagination
     
     
urlpatterns = [
		 url(r'^posts/$', PostListApiView.as_view(), name='post_list'),
]

# myapp/urls.py
from . import api

urlpatterns = [
     # 추가
     url(r'^api/', include('myapp.api', namespace='api')),
]
# include라고 했으면 당연히 그 파일안에 urlpatterns가 선언이 되어있어야함.
# 위설정끝나면 http://localhost:8000/api/v1/posts.json/?format=json로 받아볼수있다.


{% endraw %}
```

### Infinite Scroll

스크롤을 내리면, 다음 페이지를 로딩해서, 페이지 하단에 추가

```
{% raw %}


#blog/templates/index.html
{% extends "blog/layout.html" %}

{%  block extra_body %}
<script>
$(function() {   //road가 끝나면 아래와 같은 함수가 실행되도록함.
     var $win = $(window)  //jquery로 객체를 만들었고 아래를 보면 $(window).height(), $(window). scrollTop()등을 수행할수있는것.
    //$(여기)에있는 것은 html에 dom이라는 html 문서에서 각 객체들을 불러올수있음.
     var is_loading = false;  //???


     // 매 화면 스크롤마다 호출
     $win.scroll(function() {
         // 문서의 끝에 도달했는가?
         var diff = $(document).height() - $win.height();  //현재 전체 문서의 세로길이 - 윈도우의 세로길지==
         if ( (!is_loading) && diff == $win.scrollTop() ) {  //is_loading이 false이므로 이것은 True, 값이 같아질때는 아래일어나야함
             var search_params = new URLSearchParams(window.location.search); // location.search는 "?page=2"를 가져오고 이것을 URLSearchRarams를 사용해 현재 페이지의 GET인자를 가공
             var current_page = parseInt(search_params.get('page')) || 1; // GET인자 page를 획득하고 없으면 1을 반환
             var next_page_url = '?page=' + (current_page + 1); // 다음 페이지를 요청하기 위한 URL생성 JS는 문자열과 숫자를 더하면 문자열로 반환함,
             is_loading = true;

             $.get(next_page_url). //안에 주소로 ajax요청을 한
                 done(function(html) {
                     $('#post-list tbody').append(html);  //현재는 id에 tbody밑에있으므로!
                     history.pushState({}, '', next_page_url);  //주소는 원래 url그대로 인데 이것도 url이 변경되도록 url을 변경해주는 역할을함.
                 }).
                 fail(function(xhr, textStatus, error) {
		                 console.log(textStatus);
                 })
                 .always(function() {
                     console.log("always");
                     is_loading = false;
                 });
         }
     });
 });
</script>




{%  endblock %}

{% block content %}
<div class="container">
    <div class="row">
        <div class="col-sm-12">
            <table class= "table table-bordered table-hover" id="post-list">
                <tbody>
                    {% include "blog/_post_list.html" %}

                </tbody>

            </table>





                <hr/>
                <a href="{% url "blog:post_new" %}" class="btn btn-primary">새글쓰기
                </a>


        </div>
    </div>
</div>


{% endblock %}


{% endraw %}
```



## 다음 시간에는 ..

- Post Detail을 Bootstrap Model UI로 보기
- Ajax를 활용한 댓글 추가/수정/삭제





# Ajax with Django 2



## 코드 구현

- More 버튼 추가
- Modal을 활용한 Detail 
  - bootstrap4 modal 
- 댓글 Ajax 삭제

## More 버튼 구현

- 현재까지의 문제점은 화면에 그냥 전부 표시되면 스크롤 이벤트 자체가 발생을 안함.
- 위에서 했던것들은 url에서 get인자중 page를 가져온는것인데 그걸로 구현안할꺼임.
- 스크롤 뿐만 아니라, More 버튼을 통한 "Load More" 구현!!
- load_more 자바스크립트 함수를 별도로 구현

```
{% extends "blog/layout.html" %}

{%  block extra_body %}
<script>
$(function() {   //road가 끝나면 아래와 같은 함수가 실행되도록함.
     var $win = $(window)  //jquery로 객체를 만들었고 아래를 보면 $(window).height(), $(window). scrollTop()등을 수행할수있는것.
    //$(여기)에있는 것은 html에 dom이라는 html 문서에서 각 객체들을 불러올수있음.
     var is_loading = false;  //???
     var current_page = null;

     var load_more = function()  {   //함수로 따로 뺌!!
         if (! is_loading ) {
                     // var search_params = new URLSearchParams(window.location.search); // location.search는 "?page=2"를 가져오고 이것을 URLSearchRarams를 사용해 현재 페이지의 GET인자를 가공
                     // var current_page = parseInt(search_params.get('page')) || 1; // GET인자 page를 획득하고 없으면 1을 반환, 현재코드는 get인자 이용하지않으므로삭제
                     var next_page = (current_page || 1) +1 //current_page를 받아오는데 null이면 1로 대체한다.
                     var next_page_url = '?page=' + next_page; // 다음 페이지를 요청하기 위한 URL생성 JS는 문자열과 숫자를 더하면 문자열로 반환함,
                     is_loading = true;

                     $.get(next_page_url)  //안에 주소로 ajax요청을 함, get인자만 주면 다시 해당데이터 응답.
                         .done(function(html) {  //응답을 받은후
                             $('#post-list tbody').append(html);
                             current_page = next_page;
                             //history.pushState({}, '', next_page_url);
                         }) //현재 get인자 url추가필요없으므로 삭제
                         .fail(function(xhr, textStatus, error) {
                                 console.log(textStatus);
                         })
                         .always(function() {
                             console.log("always");
                             is_loading = false;
                         }); // 항상작동
                 }

     };

     // 매 화면 스크롤마다 호출
     $win.scroll(function() {
         // 문서의 끝에 도달했는가?
         var diff = $(document).height() - $win.height();  //현재 전체 문서의 세로길이 - 윈도우의 세로길지==
         if ( diff == $win.scrollTop() ) {  //is_loading이 false이므로 이것은 True, 값이 같아질때는 아래일어나야함
             console.log("바닥왔음");

             load_more(); //위에 함수 구현해놓음
             $("#load-more-btn").click(load_more); //버튼누르면 함수호출

         }
```

## Modal을 활용한 Detail

### 포스팅 리스트에서 링크에 click 리스너 걸기

중요한것은 원래 클릭하면 다음링크로 넘어가야하는데 그 사이에 modal을 띄우려하므로 clikck 리스너 필요

```
$(function() { //단지 새 포스트들이 로딩되면 안걸려있음. 왜냐하면 로딩후의 function들이므로
     $('#post-list tbody a').click(function(e) {
         e.preventDefault();
         var detail_url = $(this).attr('href');
         alert(detail_url);
     });
});
```

그런데, 새로이 추가된 다음 페이지 포스팅에 대해서는 이벤트가 먹지 않습니다. click 리스너를 등록하고 나서, 추가된 항목에 대해서는 click 리스너가 등록이 되어 있지 않는 거죠



### 다음 코드를 통해 해결.

__$(document).on활용잘하기__



```
$(function() {  //document자체로 해서 리스너 걸어버리면 추가되어도 걸린상태로나옴
     $(document).on('click', '#post-list tbody a', function(e) {
         e.preventDefault();
         var detail_url = $(this).attr('href');
         alert(detail_url);
     });
});
```

### 포스팅 제목 클릭 시에, Modal창 띄우기

```
<script>
$(function() {
     $(document).on('click', '#post-list tbody a', function(e) {
         e.preventDefault();
         var detail_url = $(this).attr('href');
         // alert(detail_url);
         $('#post-modal').modal(); // modal 창 띄우기
     });
});
</script>
```

### Modal HTML 코드

```
<div class="modal fade" id="post-modal" tabindex="-1">
     <div class="modal-dialog">
         <div class="modal-content">
             <div class="modal-header">
                 <h5 class="modal-title">포스팅 제목</h5>
                 <button type="button" class="close" data-dismiss="modal">
                		 <span>&times;</span>
                 </button>
             </div>
             <div class="modal-body">
                 ...<br/>
                 ...<br/>
                 ...<br/>
                 ...<br/>
             </div>
             <div class="modal-footer">
                 <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                 <a class="btn btn-primary btn-detail">자세히</a>
             </div>
         </div>
     </div>
</div>
```



### post detail 뷰에서의 Ajax 요청 추가 처리

장고 빌트인 태크이용

(요약해서 모달에 보여줄것이므로 글자수제한)

```
from django.http import JsonResponse
from django.template.defaultfilters import truncatewords

class PostDetailView(DetailView):
     model = Post
     
     def render_to_response(self, context):
         if self.request.is_ajax():
             return JsonResponse({
                 'title': self.object.title,
                 'content': truncatewords(self.object.content, 100),
         })
     
     # 템플릿 렌더링
     return super().render_to_response(context)
     
post_detail = PostDetailView.as_view()
```



### 포스팅 링크 클릭 시, Ajax 요청, 모달에 반영 및 띄우기



```
$(function() {
     $(document).on('click', '#post-list tbody a', function(e) {
         e.preventDefault();
         var detail_url = $(this).attr('href');
         $.get(detail_url)
             .done(function(obj) {
             // console.log(obj.title);
             // console.log(obj.summary);
             
             var $modal = $('#post-modal');
             $modal.find('.modal-title').html(json_obj.title); //id같은것에 modal-title class에 그 html 내용 에다가 '얻어온 제목'이라 변경
             $modal.find('.modal-body').html(json_obj.content); //이렇게 구현한이유는 내용은 DB 응답받아야 가져올수있으므
             $modal.find('.btn-detail').attr('href', detail_url); //그 태그안에 속성에 href추가함,
             $modal.modal();
         })
         .fail(function() {
         		alert('request failed');
         });
     });
});
```

## 댓글 Ajax 삭제

### STEP #1) Ajax요청 전송이 용이하도록, 템플릿 변경

```
{% raw %}

<!-- blog/templates/blog/post_detail.html -->
<ul>
     {% for comment in post.comment_set.all %}
         <li id="comment-{{ comment.pk }}">
             {{ comment.message }}
             &dash;
             <a href="{% url "blog:comment_edit" post.pk comment.pk %}">
                <small>{{ comment.updated_at }}</small>
             </a>

             <a href="{% url "blog:comment_delete" post.pk comment.pk %}"
                 class="ajax-post-confirm"
                 data-target-id="comment-{{ comment.pk }}" //이렇게 data속성으로 id를 지어놓으면 호출하기 더 편하다 구지 위에태그부터 내려올필요없어짐
                 data-message="삭제하시겠습니까?">
                 <small>삭제</small>
             </a>
     </li>
     {% endfor %}
</ul>

{% endraw %}
```

TIP: HTML5에서는 커스텀 data 속성을 지원합니다.



### STEP #2) 삭제 링크 클릭 시에 Ajax POST 요청

```
$(function() {
     $(document).on('click', '.ajax-post-confirm', function(e) {
         e.preventDefault();
         
         var url = $(this).attr('href');
         var message = $(this).data('message');//현재 링크에 data속성을 가져올떄
         var target_id = $(this).data('target-id');//현재 링크에 data속성을 가져올떄
         
         if ( confirm(message) ) {
             $.post(url)
                 .done(function() {
                		 $('#' + target_id).remove(); // 삭제된 엘리먼트를 UI에서 제거
                 })
                 .fail(function(xhr, textStatus, error) {
                 		alert('failed : ' + error);
                 });
         }
     });
});
```



### 그런데, Forbidden가 발생해요.

__runserver 로그에는 :( "POST /11/comments/15/delete/ HTTP/1.1" 403 2502__

__장고에서는 모든 POST요청에 대해 CSRF Token 체크를 하도록 되어있기 때문입니다. jQuery POST 요청에서는 CSRF Token 처리를 하지 않았어요__

### jQuery Ajax에서의 CSRF Token 대처

- 매 Ajax요청마다 직접 CSRF Token값을 지정해줄 수도 있겠지만, 
  - 이건 우리 스타일이 아니예요. :D
  - 구글에서 django csrf jquery 로 검색해보세요. 
- 장고 공식문서 CSRF Protection에 관련 코드가 상세히 기술되어있어요.

```
#project/project/static/jquery.csrf.js


$.ajaxSetup({
     // 모든 Ajax 요청 전에 호출되는 함수를 지정
     beforeSend: function(xhr, settings) {
         // CSRF Token 설정이 필요한 요청이면
         if (! csrfSafeMethod(settings.type) && !this.crossDomain ) {
             // Token 값을 가져와서, 요청 헤더에 심어줍니다.
             xhr.setRequestHeader("X-CSRFToken", csrftoken);
         }
     }
});


function getCookie(name) {
     var cookieValue = null;
     if (document.cookie && document.cookie !== '') {
         var cookies = document.cookie.split(';');
         for (var i = 0; i < cookies.length; i++) {
             var cookie = jQuery.trim(cookies[i]);
             // Does this cookie string begin with the name we want?
             if (cookie.substring(0, name.length + 1) === (name + '=')) {
                 cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                 break;
             }
         }
     }
     return cookieValue;
}
var csrftoken = getCookie('csrftoken');

function csrfSafeMethod(method) {
     // these HTTP methods do not require CSRF protection
     return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
}
```

이 파일을 jquery.csrf.js 파일로 static경로에 저장하고, 템플릿에 추가해주세요. 그럼 삭제가 됩니다

```
{% raw %}

#project/templates/layout.html

    <script src="{% static 'jquery/dist/jquery.min.js' %}"></script>
    <script src="{% static "bootstrap/dist/js/bootstrap.min.js" %}"></script>
    <script src="{% static "jquery.csrf.js" %}"></script>
    #추가해줌
    
{% endraw %}
```



지금까지blog/layout

```
{% raw %}



{% extends "blog/layout.html" %}

{% block extra_body %}
<script>
$(function() {
    $(document).on('click', '.ajax-post-confirm', function(e) {
        e.preventDefault();

        var url = $(this).attr("href");
        var target_id = $(this).data('target-id'); //현재 링크에 data속성을 가져올떄
        var message = $(this).data('message');

        if ( confirm(message) ) { //confirm자체가 확인 취소를 물어보고 이는 true false로 입력된다.
            $.post(url)
                .done(function () {
                    $('#' + target_id).remove();
                })
                .fail(function (xhr, textStatus, error) {
                    alert("failed")
                });


        }

        alert('clicked:' + message);
    });
});

</script>

{% endblock %}
{% block content %}
<div class="container">
    <div class="row">
        <div class="col-sm-12">

            <h1>{{ post.title }}</h1>

            {{ post.content|linebreaks }}

            <a href="{%  url "blog:comment_new" post.pk %}" class="btn btn-primary btn-block"> 댓글쓰기</a>
                </hr>
                {% for comment in post.comment_set.all %}
                    <li id="comment-{{ comment.pk }}">
                        {{ comment.message }}
                        &dash;
                        <a href="{% url "blog:comment_edit" post.pk comment.pk %}">
                            <small>{{ comment.updated_at }}</small>
                        </a>
                        <a href="{% url "blog:comment_delete" post.pk comment.pk %}"
                            class="ajax-post-confirm"
                            data-target-id="comment-{{ comment.pk }}"
                            data-message="정말 삭제하시겟습니까?"
                            >

                               <small>삭제</small>
                        </a>
                    </li>

                 {% endfor %}


</hr>

        </div>
    </div>
</div>
<a href="{% url 'blog:index' %}" class="btn btn-primary">목록</a>
<a href="{% url 'blog:post_edit' post.id %}" class="btn btn-primary">
    수정
</a>
<a href="{% url 'blog:post_delete' post.id %}" class="btn btn-danger">
    삭제
</a>

{% endblock %}




{% endraw %}
```



## 다음 이시간에는

- 댓글 Ajax 쓰기/수정
- 댓글 파일업로드 Ajax 처리
- 댓글 Ajax 처리할 때, 유효성 검사에 실패한다면?
- ETC.