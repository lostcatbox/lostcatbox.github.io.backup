---
title: 프론트엔드 기본편 4
date: 2020-01-02 16:52:59
categories: Frontend
tags: [Frontend, Django, Ajax]
---

#  Ajax with Django #4

## 이미지 썸네일 처리

큰 이미지를 CSS로 이미지 크기만 줄이는 것은 도움이 되지 않습니다.__실제 서버에서 다운받을 때부터 적절히 조절하는 것이 좋습니다.__

- 이미지 업로드 받을 때 미리 조절해서 한 버전 혹은 여러 버전으로 저장 해두거나
- 이미지를 서빙받을 때 동적으로 조절해서 내려주거나

### Image Libraries

- sorl-thumbnail
- easy-thumbnails

```
pip3 install easy-thumbnails

settings.py 에 easy_thumbnails 추가
python3 manage.py migrate 필수
```

사용법은 예시를 통해!

예시

```
{% load thumbnail %}


<li id="comment-{{ comment.pk }}">
    {%  if comment.photo %}
        <img src="{{ thumbnail comment.photo.url }}" style="width: 100px;"/>
    {% endif %}

```

위에 코드를 아래처럼 바꿀수있다

```
{% load thumbnail %}


<li id="comment-{{ comment.pk }}">
    {%  if comment.photo %}
        <img src="{% thumbnail comment.photo 100x100 crop %}"/> //인자 3개넘김
    {% endif %}

```

```
#post_detail.html 에서

    $.get('{% url "blog:comment_list" post.pk %}')
        .done(function (html) {
            $('#comment-list').html(html);
        })
        .fail(function (xhr, textStatus, error) {
            alert('failed:' + error);
        })
        
추가해준다면 현재 html에서 id= 'comment-list'를 찾아서 거기안에 html을 get요청으로 받아온 html을 넣어줌 즉, ajax로 댓글 리스트를 구현함.
```



## 댓글 레이아웃 개선

bootstrap에서 양식따와서 수정함 

왼쪽 사진 오른쪽 댓글로 구성됨.



## 댓글 페이징처리

blog템플릿에 post_detail에 있던내용중 comment-list를 따로 blog템플릿Comment_list.html 뺌

```
<div id="'comment-list">
        {% for comment in comment_list %}
            {% include "blog/_comment.html" %}
        {% endfor %}
</div>
```

따로 만들어줌







## 댓글 Ajax 새로고침

Comment-id를 추출해서 이 id값이 더 높은 값이 있다면 새로고침을 하는 방식으로 구현

```
#blog/templates/_comment.html
<div id="comment-{{ comment.pk }}" class="media comment" data-comment-id="{{ comment.id }}">

data-comment-id속성을 추가하므로서 댓글 구별, 삭제, 새로고침들에 이용가능
```

```
# post_detail.html 글쓰기 아래 부분에 추가 


<a id="check-comment" class="btn btn-primary btn-block">
                새 댓글 체크
</a>






    $('#check-comment').click(function(e) {
        e.preventDefault();

        var comment_id = $('#comment-list .comment:first').data('comment-id');
        console.log(comment_id);

         $.get('{% url "blog:comment_list" post.pk %}', {last_comment_id: comment_id}) //get요청의 인자로 보냄
             .done(function(html) {
                 console.log(html);
                     $('#comment-list').prepend(html); //최상단에 html넣기

             })
             .fail(function(xhr, textStatus, error) {
               alert('failed:' + error);
             });

    });
```



```
view.py 

class CommentListView(ListView):
    model = Comment

    def get_queryset(self):
        #self.kwargs를 가져오면 url에서 post_ argu를 다 가져옴!!!
        qs = super().get_queryset()
        qs = qs.filter(post__id = self.kwargs['post_pk'])

        latest_comment_id = self.request.GET.get('latest_comment_id', None)
        if latest_comment_id:
            # lt : less than <
            # gt : greater than >
            qs = qs.filter(id__gt=latest_comment_id)
        return qs

comment_list = CommentListView.as_view()


```





## 사용자 인증 연동

### 로그인 로그아웃. next인자를 넣어준다면 그전 url로 자동으로 돌아감

```
<div id="navbar" class="collapse navbar-collapse">
    <ul class="nav navbar-nav">
  		  <li class="active"><a href="{% url "blog:index" %}">Home</a></li>
    </ul>
    <ul class="nav navbar-nav navbar-right">
    
        {% if not user.is_authenticated %}
        <li><a href="{% url "login" %}"?next={{ request.path }}>로그인</a></li>
        <li><a href="{% url "signup" %}">회원가입</a></li>
        {% else %}

        <li><a href="{% url "profile" %}">프로필</a></li>
        <li><a href="{% url "logout" %}?next={{ request.path }}" class="disabled">로그아웃</a></li>
        {% endif %}

        <li><a href="#about">About</a></li>
        <li><a href="#contact">Contact</a></li>
    </ul>
</div>

```

### loginview, logoutview에 인자 넘기는 법

```
urls.py 에서

from django.contrib.auth import views as auth_views
from django.conf import settings
from django.urls import path, include
from . import views

urlpatterns = [
    path('signup/', views.SignupFormView.as_view(), name="signup"),
    path('login/', auth_views.LoginView.as_view(template_name='accounts/login.html'), name="login"),
    path('logout/', auth_views.LogoutView.as_view(next_page=settings.LOGIN_URL), name="logout"),
    path('profile/', views.profile, name='profile'),

]
```

### 로그인 창 또한 ajax로 처리하는 방법

-  modal을 이용해야하는데 이미 앞에서 class=comment-form-btn을 click이벤트가 발생하면 ajax로 처리하는 일반화된 것을 만들어놓음 따라서 로그인 버튼에 class=comment-form-btn이라고 지정만 해주면 처리가 될것이다 (앞에서는 detail안에만 있지만 이것을 일반화시키면 모두 modal로 띄워줄수있다)

```
comment-form에 관한 모든것을 다 modal-form으로 바꾸고 일반화
# 프젝/layout.html에 아래내용 추가 (기존 detail내용들은 삭재)


    <script>
            $(document).on('click', '.modal-form-btn', function(e) {
        e.preventDefault();

        var action_url = $(this).attr('href');
        var target_id = $(this).data('target-id');

        $.get(action_url)
            .done(function (form_html) {
                var $modal = $('#modal-form-modal');

                $modal.find('.modal-body').html(form_html);

                $form = $modal.find('.modal-body form');
                $form.attr('action', action_url);

                if ( target_id ) {  //target_id값 존재시
                 // modal form에 data-target-id속성을 기록
                 // - $form.data('target-id', target_id); 를 써봤으나,
                 // 지정이 되지않아서 attr로 변경
                     $form.attr('data-target-id', target_id);
                }
                else {
		             $form.removeData('target-id'); //target-id정보 제거
                }

                $modal.modal();
            })
            .fail(function (xhr, textStatus, error) {
                alert('failed:' + error);

            });

        // $('#comment-form-modal').modal();

    })


    $(document).on('submit', '#modal-form-modal form', function(e) {
        e.preventDefault();
        console.log("Submit");

        // jQuery Form Plugin의 ajaxSubmit을 활용 : ajax로 파일까지 모두 전달
        $(this).ajaxSubmit({
                success: function(response, statusText, xhr, $form) {
                        console.log("---- done ----");
                        var html = response;
                        console.log(html);

                        var $resp = $(html);
                        var target_id = $form.data('target-id');

                        if ( $resp.find('.has-error').length > 0 ) {
                                var fields_html = $resp.html();
                                $('#modal-form-modal .modal-body form').html(fields_html);
                        }
                        else {
                            if (target_id) {
                                $('#' + target_id).html($resp.html());
                            }
                            else {
                                $resp.prependTo('#comment-list');
                            }

                            $('#modal-form-modal').modal('hide');
                            $form[0].reset();
                        }
                },
                error: function(xhr, textStatus, error) {
                    alert('failed : ' + error);
                },
                complete: function(xhr, textStatus) {
                }
        });

        $(document).on('click', '.ajax-post-confirm', function (e) {
            e.preventDefault();

            var url = $(this).attr("href");
            var target_id = $(this).data('target-id'); //현재 링크에 data속성을 가져올떄
            var message = $(this).data('message');

            if (confirm(message)) { //confirm자체가 확인 취소를 물어보고 이는 true false로 입력된다.
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

    })




    </script>

```

위에 처럼 바꾸면 로그인을 하는순간 ajax post로 보냈으므로 html로 응답되기를 기대되는데 로그인 성공하면 post_detail로 redirect가 일어나 일어난것에 대해 ajax요청이니까 post에 대한 json응답을 받아버림

-  ajax로 처리하는과정

````
class LoginView(AuthLoginView):

    def form_valid(self, form):
        response = super().form_valid(form)
        if self.request.is_ajax():
            return JsonResponse({'next_url': self.get_success_url()})
        return response

    def get_template_names(self):
        if self.request.is_ajax():
            return ['accounts/_login.html']
        return ['accounts/login.html']
````

```
프젝/layout.html  내용 추가

$(document).on('submit', '#modal-form-modal form', function(e) {
        e.preventDefault();
        console.log("Submit");


        // jQuery Form Plugin의 ajaxSubmit을 활용 : ajax로 파일까지 모두 전달
        $(this).ajaxSubmit({
                success: function(response, statusText, xhr, $form) {
                        if ( response.next_url ) { //response안에 nex_url인자 존재시
                            window.location = response.next_url //window.location에 주소로이동임
                            return; // 함수종료
                        }

```

지금까지 modal 사용, ajax연결 등을 자세히 배웠음



# JavaScript Chart 데이터 연동

## 다양한 JavaScript 차트

- Chart.js #home
- D3.js
- Highcharts.js
- Chartist.js 
- Google Chart
- 이 외에도 수많은 라이브러리가 있습니다.

## 장고와의 연동에서 주안점

1. Chart 라이브러리 static 연결 
   - CDN 버전 연결 
   - static 직접 호스팅 1
2. 데이터 연동 : 데이터가 고정된 차트를 보고 싶지 않습니다.
   - Inline JavaScript를 통한 데이터 공급
   - Ajax를 통한 데이터 공급



Tip: 참고: [장고 기본편] StaticFiles - CSS/JavaScript 파일을 어떻게 관리해야할까요?

### django chart 앱

- django-chartjs: Django Class Based Views to generate Ajax charts js parameters. This is compatible with Chart.js and Highcharts JS libraries.
- django-jchart: This Django app enables you to configure and render Chart.JS charts directly from your Django codebase.
- django-chart-tools: django-chart-tools is a simple app for creating charts in django templates using Google Chart API.
- django-rest-pandas: Serves up Pandas dataframes via the Django REST Framework for use in client-side (i.e. d3.js) visualizations and offline analysis (e.g. Excel)

## javascript chart 활용법을 먼저 익히세요.

- django chart 앱을 통해, 장고에서 손쉽게 차트를 사용하실 수는 있습니다.
- 하지만 django chart 앱과 연동된 차트 외에 더 많은 JavaScript 차트가 있습니다.
- 게다가 django chart 앱에서는 본연의 JavaScript의 모든 기능을 활용하 지 못하고 있을 가능성도 있습니다. 
- JavaScript 차트를 직접 활용하실 줄 아셔야 합니다.

## 백엔드 도움없이 프론트엔드 단에서만 차트 그리기

### Chart.js 간단 샘플

```
<!doctype html>
<html>
<head>
     <meta charset="utf-8" />
     <script src="http://www.chartjs.org/dist/2.7.0/Chart.bundle.js"></script>
</head>
<body>

<canvas id="canvas"></canvas>  //웹에서의 그림판임!! 여기에다가 chart.js가 그림

<script>
var chartData = {  // 현재 chartData 객체에 들어있는 지금값들은 chart.js가 요구하는 스펙으로 구성함 (label과 data만 넣어도 작동은함)
     labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
     datasets: [{
         label: 'Dataset 1',
         backgroundColor: "rgba(255, 99, 132, 0.5)",
         borderColor: "rgba(255, 99, 132, 1)",
         pointBackgroundColor: "rgba(255, 99, 132, 1)",
         pointBorderColor: "#fff",
         data: [
             parseInt(Math.random() * 100), parseInt(Math.random() * 100), parseInt(Math.random() * 100), parseInt(Math.random() * 100),
             parseInt(Math.random() * 100), parseInt(Math.random() * 100), parseInt(Math.random() * 100)
         ]
     }]
};

window.onload = function() { //현재 jquery를 안썻으므로 이방식으로 함수지정해서쓰면 페이지로딩다되면 함수호출됨

     var ctx = document.getElementById('canvas').getContext('2d'); //2d context가져옴
     
     // chart.js에서 지원해주는 Chart로 ctx넘겨주고, 필수 객체넘겨주면 인자만들어줌
     window.chart = new Chart(ctx, {
     
         type: 'line',
         data: chartData
     });
};
</script>
</body>
</html>
```

## 백엔드에서 데이터 넘겨주기 (1) 템플릿 렌더링 시에 데이터 넘겨주기

### 유틸리티 코드) 웹툰 평점 크롤링

```
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin


def get_comic_info(comic_id, comic_title):
    ep_list = []


    for page in range(1, 3):  # 최대 5페이지
        params = {
            'titleId': comic_id,
            'page': page,
        }
        resp = requests.get('http://comic.naver.com/webtoon/list.nhn', params=params)
        html = resp.text
        soup = BeautifulSoup(html, 'html.parser')



        for tr in soup.select('#content table tr'):  # 아래 크롤링 하는목록 죄회하
            try:
                link = tr.select('.title a[href*=detail]')[0]  #.title이 class 이름이고 a에 href가 포함된것을 긁어옴
                rating = tr.select('.rating_type strong')[0].text
                date = tr.select('.num')[0].text
            except IndexError:
                continue

            title = link.text
            url = urljoin(resp.request.url, link['href'])
            ep = {
                'title': title,
                'url': url,
                'rating': rating,
                'date': date,
            }
            if ep in ep_list: #같은게 나와버리면 지금 함수 끝냄
                return ep_list

            ep_list.append(ep)

    return {
            'title': comic_title,
            'ep_list': ep_list,
            'soup': soup,
     }
```

### 뷰 코드

차트 데이터들을 server side에서 javascript 형식으로 렌더링하기

```
from django.shortcuts import render
from .utils import get_comic_info

def index(request):
     comic = get_comic_info(20853,
    '마음의 소리')
     return render(request, 'mychart/index.html', {
     		'comic': comic,
     })
```

## 뷰 render에서 넘겨진 comic 사전 활용 템플릿

```
{{ comic }}
```

위에 호출은 django단에서 처리되고 script태그 안에있는것은 django한테는 그냥 문자열이지

django문법 

```
{% %}
```

를 써서 javascript문자열들을 만들어줌

```
<!doctype html>
<html>
<head>
     <meta charset="utf-8" />
     <script src="http://www.chartjs.org/dist/2.7.0/Chart.bundle.js"></script>
</head>
<body>

<canvas id="canvas"></canvas>

<script>
var chartData = {
     labels: [
         {% for ep in comic.ep_list %}
             '{{ ep.title }}'
             {% if not forloop.last %},{% endif %}  //마지막 loop의 마지막이 아닐경우 ,를 붙인다
         {% endfor %}
     ],
     datasets: [{
         label: '평점',
         backgroundColor: "rgba(255, 99, 132, 0.5)",
         borderColor: "rgba(255, 99, 132, 1)",
         pointBackgroundColor: "rgba(255, 99, 132, 1)",
         pointBorderColor: "#fff",
         data: [
             {% for ep in comic.ep_list %}
                 {{ ep.rating }}
                 {% if not forloop.last %},{% endif %}  //마지막 loop의 마지막이 아닐경우 ,를 붙인다
             {% endfor %}
         ]
     }]
};
</script>

```

```
<script>
window.onload = function() {
     var ctx = document.getElementById('canvas').getContext('2d');
     var chart = new Chart(ctx, {
     type: 'line',
     data: chartData
		 });
};
</script>
</body>
</html>
EP 9. JavaScript Chart 
```

## 백엔드에서 데이터 넘겨주기 (2) Ajax 활용

### urls.py

```
urlpatterns = [
		 # 중략
 		url(r'^data.json$', views.data_json, name='data_json'),
]
```

### 뷰 코드

```
from django.shortcuts import render
from .utils import get_comic_info
from django.http import JsonResponse

def index(request):

    comic = get_comic_info(20853, '마음의 소리')

    return render(request, 'mychart/index.html', {'soup': comic})


def data_json(request):
    comic = get_comic_info(20853, '마음의 소리')

    return JsonResponse({
        'labels': [ep['title'] for ep in comic['ep_list']],
        'datasets': [{
            'label': '평점',
            'backgroundColor': "rgba(255, 99, 132, 0.5)",
            'borderColor': "rgba(255, 99, 132, 1)",
            'pointBackgroundColor': "rgba(255, 99, 132, 1)",
            'pointBorderColor': "#fff",
            'data': [ep['rating'] for ep in comic['ep_list']]
        }],

    })

```

### 템플릿 코드

```
{% load static %}
<!doctype html>

<html>
<head>
     <meta charset="utf-8" />
     <script src="http://www.chartjs.org/dist/2.7.0/Chart.bundle.js"></script>
     <script src="{% static 'jquery/dist/jquery.min.js' %}"></script>

</head>
<body>

        <canvas id="canvas"></canvas>

<ul>
{#    {{ soup }}#}  //로우데이터보고싶을때 활용
</ul>


        <script>
            $(function() {

                $.get('{% url "mychart:data_json" %}')
                    .done(function(chartData) {
                        console.log(chartData)
                         var ctx = document.getElementById('canvas').getContext('2d');
                         window.chart = new Chart(ctx, {
                             type: 'line',
                             data: chartData
                         });
                    })
                    .fail(function (xhr, textStatus, error) {
                        alert('failed:'+ error);

                    });
            });
        </script>
</body>
</html>
```

## ~~백엔드에서 데이터 넘겨주기 (3) django-chartjs 활용(추천안함)~~

### django-chartjs 활용 뷰코드 

data_json 뷰를 django-chartjs를 통해 만들기

```
from chartjs.views.lines import BaseLineChartView

class WebtoonChartJSONView(BaseLineChartView):
     def __init__(self):
         super().__init__()
         self.comic = get_comic_info(20853, '마음의 소리')
         
     def get_labels(self):
     		 return [ep['title'] for ep in self.comic['ep_list']]
     		 
     def get_providers(self):
     		 return ['평점']
     		 
     def get_data(self):
     		 return [
     				 [ep['rating'] for ep in self.comic['ep_list']],
         ]
         
     def get_colors(self):
         yield (255, 99, 132)
         
data_json = WebtoonChartJSONView.as_view()
```

## Tip

javascript chart를 장고와 연동하기 전에, html/css/javascript만으로 javascript chart를 우선 익혀보세요. 

그래야만 자유자재로 chart를 활용하실 수 있습니다. 

그 후에, django chart 앱을 활용하시며, 소스코드도 까보세요.



### 크롤링 로우 데이터

```
{'title': '마음의 소리', 'ep_list': [{'title': '1203. 그 동상', 'url': 'https://comic.naver.com/webtoon/detail.nhn?titleId=20853&no=1207&weekday=tue', 'rating': '9.73', 'date': '2019.12.30'}, {'title': '1202. 당숙 어르신', 'url': 'https://comic.naver.com/webtoon/detail.nhn?titleId=20853&no=1206&weekday=tue', 'rating': '9.77', 'date': '2019.12.23'}, {'title': '1201. 겨울 옷차림', 'url': 'https://comic.naver.com/webtoon/detail.nhn?titleId=20853&no=1205&weekday=tue', 'rating': '9.85', 'date': '2019.12.16'}, {'title': '1200. 양심의소리', 'url': 'https://comic.naver.com/webtoon/detail.nhn?titleId=20853&no=1204&weekday=tue', 'rating': '9.95', 'date': '2019.12.09'}, {'title': '1199. 백야', 'url': 'https://comic.naver.com/webtoon/detail.nhn?titleId=20853&no=1203&weekday=tue', 'rating': '9.81', 'date': '2019.12.02'}, {'title': '1198. 성함이…?', 'url': 'https://comic.naver.com/webtoon/detail.nhn?titleId=20853&no=1202&weekday=tue', 'rating': '9.93', 'date': '2019.11.25'}, {'title': '1197. 학예회', 'url': 'https://comic.naver.com/webtoon/detail.nhn?titleId=20853&no=1201&weekday=tue', 'rating': '9.85', 'date': '2019.11.18'}, {'title': '1196. 키아누 X브스', 'url': 'https://comic.naver.com/webtoon/detail.nhn?titleId=20853&no=1200&weekday=tue', 'rating': '9.80', 'date': '2019.11.11'}, {'title': '1195. 상의', 'url': 'https://comic.naver.com/webtoon/detail.nhn?titleId=20853&no=1199&weekday=tue', 'rating': '9.73', 'date': '2019.11.04'}, {'title': '1194. 불법스캔', 'url': 'https://comic.naver.com/webtoon/detail.nhn?titleId=20853&no=1198&weekday=tue', 'rating': '9.54', 'date': '2019.10.28'}]
```

