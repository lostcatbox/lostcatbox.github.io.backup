---
title: '클래스뷰 정확히 쓰기 2'
date: 2019-12-06 13:27:30
categories: Django
tags: [Django, ClassView]
---



# Generic Display CBV 뷰

## Built-in CBV API

- Generic Display Views
  - ListView, DetailView 

- Generic Date Views
  - ArchiveIndexView, YearArchiveView, MonthArchiveView, WeekArchiveView, DayArchiveView, TodayArchiveView, DateDetailView 
- Generic Editing Views
  - FormView, CreateView, UpdateView, DeleteView



## Generic Display Views

### CBV에서 공통적으로 지원하는 옵션

- 템플릿을 사용하는 CBV 
  - template_name : 디폴트 템플릿경로가 제공되지만 이를 변경코자 할 때
- 리스트 형
  - allow_empty (디폴트 False) : 조회할 데이터가 없을 경우, 404 예외
  - paginate_by (디폴트 None) : 페이지당 갯수 지정
    - 지정시 페이징 처리 (페이지 인자 예: ?page=1)
- 페이징 관련 클래스 : Page1 , Paginator2

### ListView

- 지정 모델에 대한 전체 목록을 조회
- 디폴트 템플릿 경로 : “앱이름/모델명소문자_list.html” _
- 디폴트 context_object_name     #context는 즉 템플릿에서 넘겨받아쓸수있는 인스턴스명들
  - "모델명소문자\_list" : ex) post_list, comment_list, tag_list 
  - 혹은 "object_list"



#### 뷰 구현

```
from django.http import Http404
from django.views.generic import ListView
from .models import Post

# 구현 1-1) FBV
로 직접 간단 구현
def post_list(request):
     qs = Post.objects.all()
     allow_empty = False
     if not allow_empty and not qs.exists():
     				raise Http404
     return render(request, 'blog/post_list.html', {
     			'post_list': Post.objects.all(),
     })
     
# 구현 1-2) CBV로 페이징없이 구현. QuerySet은 Model.objects.all()로 지정됨.
post_list = ListView.as_view(model=Post)

# 구현 2) QuerySet을 직접 지정
post_list = ListView.as_view(model=Post, queryset=Post.objects.all().order_by('-id'))

# 구현 3-1) CBV로 페이징 처리
post_list = ListView.as_view(model=Post, paginate_by=10)

# 구현 3-2) 상속을 통한 CBV 구현 (모든 CBV에서 가능)
class PostListView(ListView):
     model = Post
     paginate_by = 10
     queryset = Post.objects.all().ordered_by('id')    #쿼리셋 커스텀
     또는
     def get_queryset(self):  #쿼리셋 커스텀 (특정 맴버 함수 재정의
         qs = super().get_queryset()
         return qs.filter(id__lte=2)
     
post_list = PostListView.as_view()
```

#### 템플릿 구현 (이전, 다음 페이지 구현)

```
# blog/templates/blog/post_list.html

<ul>
     {% for post in post_list %}
         <li>{{ post.title }}</li>
     {% endfor %}
</ul>

{% if is_paginated %}  #paginated_by 설정하면 이부분이 True됨

     {% if page_obj.has_previous %}
     		<a href="?page={{ page_obj.previous_page_number }}">이전</a>
     {% endif %}
     
     {{ page_obj.number }}페이지
     
     {% if page_obj.has_next %}
    		 <a href="?page={{ page_obj.next_page_number }}">다음</a>
     {% endif %}
{% endif %}
```

### DetailView

- 지정 pk 혹은 slug의 모델 인스턴스에 대한 Detail
- 디폴트 템플릿 경로 : “앱이름/모델명소문자_detail.html”
- 디폴트 context_object_name 
  - "모델명소문자" : ex) post, comment, tag
  - 혹은 "object"

####  뷰 구현

```
#blog/views.py

from django.views.generic import DetailView
from django.shortcuts import get_object_or_404
from .models import Post

# 구현 1) FBV로 구현
def post_detail(request, pk):
     post = get_object_or_404(Post, pk=pk)
     return render(request, 'blog/post_list.html', {
		     'post': post,
     })
     
# 구현 2) CBV로 구현
post_detail = DetailView.as_view(model=Post)
```

#### 템플릿 구현

```
#blog/templates/blog/post_detail.html
<h1>{{ post.title }}</h1>
{{ post.content|linebreaks }}
```



## Generic Date Views

- 공통 옵션 
  - allow_future (디폴트: False) 
    - False : 현재시간 이후의 Record는 제외

### ArchiveIndexView

- 지정 날짜필드 역순으로 정렬된 목록

- 필수 옵션

  - date_field : 지정 날짜필드

- 디폴트 템플릿 경로 

  - “앱이름/모델명소문자_archive.html” 

    ex) "blog/post_archive.html" 

- context 

  - latest (디폴트 context_object_name) : 지정날짜 필드 역순으로 정렬된 QuerySet 

  - date_list : 년도별 포스팅의 지정 날짜필드 

    ex) [2016-01-01 00:00:00, 2017-01-01 00:00:00, ...]

#### URLConf 구현

``` 
urlpatterns = [
 url(r'^archive/$', views.post_archive),
]
```

#### 뷰 구현

```
from django.views.generic import ArchiveIndexView
from .models import Post

post_archive = ArchiveIndexView.as_view(model=Post, date_field='updated_at')
```

#### 템플릿 구현

```
# blog/templates/blog/post_archive.html 

<h3>등록된 포스팅의 년도 (모두 1월 1일)</h3>
{% for date in date_list %}
 {{ date|date:"Y" }} <!-- ex) 2017 -->  #date인자에는 다양한값존재,연도값만 뽑아냄
{% endfor %}

<h3>updated_at 역순으로 정렬된 전체 포스팅</h3>
<ul>
     {% for post in latest %}

    <li>
     {{ post }}
     </li>
     {% endfor %}
</ul>
```



### YearArchiveView

- URL Rule의 지정 year년도의 목록 

- 디폴트 옵션 

  - date_list_period (디폴트 'month') : 지정 년도에서 월 단위로 레코드가 있는 날짜를 뽑음. 
  - make_object_list (디폴트 False) : 거짓일 경우, object_list를 비움. (본 CBV에만 있는 옵 션) (년도에 해당된 post가 너무 많음을 방지)

- 디폴트 템플릿 경로 : “앱이름/모델명소문자_archive_year.html”

- context 

  - date_list : 해당 년도의 월별 포스팅의 지정 날짜필드 

    ex) [2016-01-01 00:00:00, 2017-02-01 00:00:00, ...]

#### URLConf 구현

```
from . import views
# year이라는 인자를 받는다!!
urlpatterns = [
     url(r'^archive/(?P<year>\d{4})/$', views.PostYearArchiveView.as_view(), name='post_archive_year'),
]
```

#### 뷰 구현

```
from django.views.generic.dates import YearArchiveView
from .models import Post

class PostArchiveYearView(YearArchiveView):
     model = Post
     date_field = 'created_at'
     # make_object_list = False
```

#### 템플릿 구현

```
# blog/templates/blog/post_archive_year.html

<h3>{{ year|date:"Y" }}</h3>

{% for post in object_list %}
 		{{ post }}
{% endfor %}

<h4>레코드가 있는 월</h4>

{% for date in date_list %}
 		<a href="{% url "blog:post_archive_month" date|date:"Y" date|date:"m" %}">  #이렇게 인자를 각자 해줘야 url작성됨!!
        {{ date|date:"Y-m" }} <!-- ex) 2017-01 -->
        </a>

{% endfor %}

<hr/>

{% if previous_year %}  #cbv에서 자동으로 만들어줌.
		 <a href="{% url "blog:post_archive_year" previous_year|date:"Y" %}">
				 {{ previous_year|date:"Y년" }}
		 </a>
{% endif %}

{% if next_year %}   #cbv에서 자동으로 만들어줌.
		 <a href="{% url "blog:post_archive_year" next_year|date:"Y" %}">
 				{{ next_year|date:"Y년" }}
		 </a>
{% endif %}
```



### MonthArchiveView

- URL Rule의 지정 year/month 년/월의 목록 
- 디폴트 템플릿 경로 : “앱이름/모델명소문자_archive_month.html” 
- 인자 
  - month_format (디폴트 %b]) 3 : 숫자포맷은 %m

#### URLConf 구현

```
from . import views
urlpatterns = [
 re_path(r'^archive/(?P<year>\d{4})/(?P<month>\d{1,2})/$', views.PostMonthArchiveView.as_view(), name='post_archive_month'),
]
```

#### 뷰  구현

```
#blog/views.py

from django.views.generic.dates import MonthArchiveView
from .models import Post

class PostMonthArchiveView(MonthArchiveView):
       model = Post
       date_field = 'updated_at'
       month_format = '%m'  #이걸해야 jan이렇게안나오고 숫자로 나옴
```

#### 템플릿 구현

```
# blog/templates/blog/post_archive_month.html

<h3>{{ month|date:"Y년 m월" }}</h3>

{% for date in date_list %}
		 {{ date|date:"Y-m-d" }} <!-- ex) 2017-01-01 -->
{% endfor %}

<hr/>

{% for post in object_list %}
 {{ post.title }}
{% endfor %}

<hr/>

{% if previous_month %}
     <a href="{% url "blog:post_archive_month" previous_month|date:"Y" previous_month|date:"m" %}">   
         {{ previous_month|date:"Y년 m월" }}
 </a>
{% endif %}

{% if next_month %}
     <a href="{% url "blog:post_archive_month" next_month|date:"Y" next_month|date:"m" %}">
  		   {{ next_month|date:"Y년 m월" }}
 </a>
{% endif %}
```

### WeekArchiveView

- URL Rule의 지정 year/week 년/주의 목록 
- 디폴트 템플릿 경로 : 앱이름/모델명소문자_archive_week.html” 
- 인자 week_format 
  - %U (디폴트) : 한 주의 시작을 일요일로 지정
  - %W : 한 주의 시작을 월요일로 지정



#### URLConf 구현

```
from . import views

urlpatterns = [
     url(r'^archive/(?P<year>\d{4})/week/(?P<week>\d{1,2})/$', views.PostWeeArchivekView.as_view(), name='post_archive_week'),
]
```

#### 뷰 구현

````
# blog/views.py

from django.views.generic.dates import WeekArchiveView
from .models import Post

class PostWeekArchiveView(WeekArchiveView):
     model = Post
     date_field = 'created_at'
````

#### 템플릿 구현

```
# blog/tempaltes/blog/post_archive_week.html

{% for post in object_list %}
 		{{ post }}
{% endfor %}

<hr/>
<% if previous_week%>
<a href="{% url "blog:post_archive_week" previous_week|date:"Y" previous_week|date:"W" %}">
		 {{ previous_week|date:"Y년 W주" }}
</a>
{% endif %}

{{ week|date:"Y년 W주" }}

<% if next_week%>
<a href="{% url "blog:post_archive_week" next_week|date:"Y" next_week|date:"W" %}">
 {{ next_week|date:"Y년 W주" }}
</a>
{% endif %}
```

### DayArchiveView (??? 에러뜸)

- URL Rule의 지정 year/month/day 년/월/일의 목록 
- 디폴트 템플릿 경로 : “앱이름/모델명소문자_archive_day.html”

#### URLConf구현

```
from . import views
urlpatterns = [
 url(r'^archive/(?P<year>\d{4})/(?P<week>\d{1,2})/(?P<day>\d{1,2})/$', views.PostDayArchiveView.as_view(), name='post_archive_day'),
]
```

#### 뷰 구현

```
from django.views.generic.dates import DayArchiveView
from .models import Post

class PostDayArchiveView(DayArchiveView):
     model = Post
     date_field = 'updated_at'
     month_format = '%m'
```



#### 템플릿 구현

```
# blog/templates/blog/post_archive_day.html

<h3>{{ day|date:"Y년 m월 d일" }}</h3>

  {% for post in object_list %}
   {{ post }}
  {% endfor %}

<hr/>
<% if previous_day %>
<a href="{% url "blog:post_archive_day" previous_day|date:"Y" previous_day|date:"m" previous_day|date:"d" %}">
 {{ previous_day|date:"Y년 m월 d일" }}
</a>
{% endif %}

<% if next_day %>
<a href="{% url "blog:post_archive_day" next_day|date:"Y" next_day|date:"m" next_day|date:"d" %}">
 {{ next_day|date:"Y년 m월 d일" }}
</a>
{% endif %}
```





### TodayArchiveView

- 오늘 날짜에 해당되는 목록
- 디폴트 템플릿 경로 : “앱이름/모델명소문자_archive_day.html” 
  - DayArchiveView 뷰와 동일한 템플릿 경로 
- DayArchiveView와 다르게 이전/다음 날 datetime 인스턴스가 제공 되지 않습니다

#### URLConf 구현

```
from . import views
urlpatterns = [
 url(r'^archive/today/$', views.PostTodayArchiveView.as_view(), name='post_archive_today'),
]
```

#### 뷰 구현

````
from django.views.generic.dates import TodayArchiveView
from .models import Post

class PostTodayArchiveView(TodayArchiveView):
     model = Post
     date_field = 'created_at'
````

#### 템플릿 구현

```
# blog/templates/blog/post_archive_day.html

<h3>{{ day|date:"Y년 m월 d일" }}</h3>
    {% for post in object_list %}
     {{ post }}
    {% endfor %}
```

### DateDetailView (???)

- URL Rule의 year/month/day 목록 중에서 특정 pk의 detail
  - URL에 year/month/day 를 쓰고 싶을 경우
- 디폴트 템플릿 경로 : “앱이름/모델명소문자_detail.html”

#### URLConf 구현

```
from . import views
urlpatterns = [
 url(r'^archive/(?P<year>\d{4})/(?P<month>\d{1,2})/(?P<day>\d{1,2})/(?P<pk>\d+)/$', views.PostDateDetailView.as_view(), name='post_archive_today'),
]
```



#### 뷰 구현

```
from django.views.generic.dates import DateDetailView
from .models import Post
class PostDateDetailView(DateDetailView):
     model = Post
     date_field = 'created_at'
     month_format = '%m'
```

#### 템플릿 구현

```
#blog/templates/blog/post_detail.html

<h3>{{ post.title }}</h3>
{{ post.content|linebreaks }}
```

#  Generic Editing CBV Views

## FormView

form을 처리하는 CBV

- 유효성 검사에 실패하면 오류정보를 노출하고

- 성공하면 form_valid()를 처리하고 Success URL로 이동 

- 옵션 

  - form_class 옵션 (필수) : Form 클래스 지정 

  - success_url 옵션 (필수) : 유효성 검사 성공 시 이동할 URL 지정 

    - url reverse를 수행해주지 않습니다. 

  - template_name 옵션 (필수) 

  - form_valid, form_invalid 멤버함수를 통해 form valid/invalid 시의 처리 구현

    즉 각 valid invalid 상황 나눠서 구현가능

## 뷰 구현

아래에 form.save()가 된거보면 분명cbv안에 form = PostForm(request.POST, request.FILES)가 있을것이다. 이것을 self.post인자에 담는 이유는 다른qs를 더할수있으므로 그런듯,

```
#blog/views.py

from django.urls import reverse
from django.shortcuts import resolve_url
from django.views.generic import FormView
from .forms import PostForm

class PostCreateView(FormView):
     form_class = PostForm
     template_name = 'blog/post_form.html'
     
     def form_valid(self, form):
         'form.is_valid() 시에 호출'
         self.post = form.save()
         return super().form_valid(form) #오버라이딩 했으므로 이부분 꼭 필요
         
     def get_success_url(self):
         'form_valid(form) 처리 후에, 이동할 URL을 획득'
         return resolve_url(self.post) # resolve_url사용하려면, Post모델에 get_absolute_url() 멤버함수 구현 필요
         # return self.post.get_absolute_url() # 대안 1
         # return reverse('blog:post_detail', args=[self.post.id]) # 대안 2
```

### URLConf 구현

```
from django.conf.urls import url
from . import views
urlpatterns = [
 url(r'^new/$', views.PostCreateView.as_view(), name='post_new'),
]
```

### 템플릿 구현

```
# blog/templates/blog/post_form.html

<form action="" method="post">
     {% csrf_token %}
     <table>
     {{ form }}
     </table>
     <input type="submit" />
</form>
```

## CreateView

Model Instance를 생성

- 옵션 
  - model 옵션 (필수)
  - form_class 옵션 : 제공하지 않을 경우, Model로부터 ModelForm을 생성/적용
  - fields 옵션 : 지정 field에 대해서만 Form 처리
  - success_url 옵션 : 제공하지 않을 경우, model_instance.get_absolute_url() 획득을 시도 
  - 디폴트 템플릿 경로 : "앱이름/모델명소문자_form.html"

###  뷰 구현

```
from django.views.generic import CreateView
from .models import Post
from .forms import PostForm

#아래처럼 짜면 newpost하면 각자 해당하는 detail로 감!
#하지만 이것보다 더 좋은건 해당 모델에 get_absolute_url구현해놓는것!
class PostCreateView(CreateView):
     model = Post
     
     fields = '__all__'
     # success_url = reverse_lazy('blog:post_index') 경로 변경 불가 detail로 이동하고싶다

     #def get_success_url(self):
     #    return resolve_url('blog:post_detail', self.object.id)
     
urls/template은 위 FormView 구성을 이용 가능
```

```
#models.py
#get_absolute_url 구성!

from django.db import models
from django.urls import reverse

class Post(models.Model):
    title = models.CharField(max_length=100)
    content = models.TextField()
    updated_at = models.DateTimeField(auto_now=True)

    def get_absolute_url(self):
        return reverse('blog:post_detail', args=[self.id])

# Create your models here.

```





## UpdateView

Model Instance를 수정

옵션은 위 CreateView와 동일



### URLConf 구현

```
from django.conf.urls import url
from . import views
urlpatterns = [
 url(r'^(?P<pk>\d+)/edit/$', views.PostUpdateView.as_view(), name='post_edit'),
]
```

### 뷰 구현

```
from django.views.generic import UpdateView
from .models import Post
from .forms import PostForm

class PostUpdateView(UpdateView):
     model = Post
     form_class = PostForm
템플릿은 범용 템플릿을 그대로 활용
```



## DeleteView

지정 Model Instance 삭제확인 및 삭제 

- 옵션 • model 옵션 (필수) 
  - success_url 옵션 (필수) 
  - 디폴트 템플릿 경로 : "앱이름/모델명소문자 _confirm_delete.html"

### URLConf 구현

```
from django.conf.urls import url
from . import views
urlpatterns = [
 path('<int:pk>/delete/$', views.PostDeleteView.as_view(), name='post_delete'),
]
```



### 뷰 구현

   Tip: 전역변수/클래스 변수에서 url reverse가 필요할 때 reverse_lazy를 사용

```
from django.views.generic import DeleteView
from .models import Post
class PostDeleteView(DeleteView):
     model = Post
     success_url = reverse_lazy('blog:post_list') #이것도 가능
```



### 템플릿 구현

```
# blog/templates/blog/post_confirm_delete.html

<form action="" method="post">
     {% csrf_token %}
     정말 삭제하시겠습니까?
     <input type="submit" value="삭제하겠습니다." />
</form>
```

