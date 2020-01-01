---
title: '클래스뷰 정확히 쓰기 1'
date: 2019-12-03 16:20:28
categories: Django
tags: [Django, ClassView]
---

# overview

## View?

- 뷰의 정체는 호출가능한 객체 (Callable Object) 

  첫번째 인자로 HttpRequest 인스턴스를 받고, 

  리턴값으로 HttpResponse 인스턴스를 리턴해야하는 의무

```
# myapp/views.py
def about(request):  #여기 request가 HttpRequest인스턴스
     return HttpResponse('안녕하세요. AskDjango입니다.') #여기가 httpResponse인스턴스
# myapp/urls.py
from . import views
urlpatterns = [
     url(r'^about/$', views.about, name='about'),
]
```

### 함수기반뷰 or 클래스 기반뷰

- 함수 기빈뷰 - 함수로 구현한 뷰
- 클래슥 기반 뷰-클래스로 함수를 구현한 뷰

```
# 함수 기반 뷰
def about(request):
     return HttpResponse('안녕하세요. AskDjango입니다.')
     
# 클래스 기반 뷰
class AboutView(object):
   @classmethod
   def as_view(cls, message):
       def view_fn(request):
           return HttpResponse(message)
       return view_fn
       
# 클래스 기반 뷰를 통해 만들어낸 함수
# about객체는 현재 view_fn함수가 만들어짐.
about = AboutView.as_view('안녕하세요. AskDjango입니다.') 


지금 쓴 클래스뷰는 위에 함수기반뷰와 동일한 실행
```



### 참고) 클래스의 3가지 함수 형식

- instance method : instance를 통한 호출. 첫번째 인자로 instance가 자동 지정 (self에 대입) 

- class method : class를 통한 호출. 첫번째 인자로 Class가 자동 지정 (cls에 대입)

- static method : class를 통한 호출. 자동으로 지정되는 인자가 없음. 활용은 class method와 동일

  

```
class Person(object):
 		def __init__(self, name, country):
			  self.name = name
			  self.country = country
 
 		def say_hello(self):
 				return '안녕. 나는 {}이야. {}에서 왔어'.format(self.name, self.country)
 
    @staticmethod
    def new_korean1(name):
        return Person(name, 'Korea')
 
    @classmethod
    def new_korean2(cls, name):
        return cls(name, 'Korea')
```

출력

```
>>> tom = Person('Tom', 'SF')
>>> tom.say_hello()
'안녕. 나는 Tom이야. SF에서 왔어'
>>> steve = Person.new_korean1('Steve')
>>> steve.say_hello()
'안녕. 나는 Steve이야. Korea에서 왔어'
>>> lee = Person.new_korean2('Lee')
>>> lee.say_hello()
'안녕. 나는 Lee이야. Korea에서 왔어'
```



## ClassBasedView(CBV)

- CBV의 정체는 FBV를 만들어주는 클래스
  - as_view 클래스함수를 통해 뷰 함수를 생성
- 장고 기본 CBV 팩키지 위치 : django.views.generic
  - CBV는 범용적 (generic) 으로 쓸 뷰



### 1) FBV코드

```
포맷이 같은 유형

# myapp/views_fbv.py
from django.shortcuts import get_object_or_404, render

# 특정 id의 post detail 뷰 함수
def post_detail(request, id):
     post = get_object_or_404(Post, id=id)
     return render(request, 'blog/post_detail.html', {
         'post': post,
     })
     
# 특정 id의 article detail 뷰 함수
def article_detail(request, id):
     article = get_object_or_404(Article, id=id)
     return render(request, 'blog/article_detail.html', {
         'article': article,
     })
```

### 2) 동일한 동작을 하는 CBV를 직접 컨셉만 구현

```
# myapp/views_cbv.py
class DetailView(object):
     '이전 FBV를 CBV버전으로 컨셉만 간단히 구현. 같은 동작을 수행'
     @classmethod
     def as_view(cls, model):
         def view_fn(request, id):
             instance = get_object_or_404(model, id=id)
             instance_name = model._meta.model_name
             template_name = '{}/{}_detail.html'.format(model._meta.app_label, instance_name)
             return render(request, template_name, {
                 instance_name: instance,
             })
         return view_fn
         
post_detail = DetailView.as_view(Post)
article_detail = DetailView.as_view(Article)
```



### 3) 장고 기본제공 CBV 쓰기

```
# myapp/views_cbv2.py
from django.views.generic import DetailView
post_detail = DetailView.as_view(Post)
article_detail = DetailView.as_view(Article)
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
     url(r'^posts/cbv/(?P<id>\d+)/$', views_cbv.post_detail),
     url(r'^posts/cbv/(?P<id>\d+)/$', views_cbv.DetailView.as_view(Post)),
     url(r'^articles/cbv/(?P<id>\d+)/$', views_cbv.article_detail),
     url(r'^articles/cbv/(?P<id>\d+)/$', views_cbv.DetailView.as_view(Article)),

     # views_cbv2
     url(r'^posts/cbv2/(?P<id>\d+)/$', views_cbv2.post_detail),
     url(r'^posts/cbv2/(?P<id>\d+)/$', DetailView.as_view(Post)), # views_cbv2 뷰 참조없음
     url(r'^articles/cbv2/(?P<id>\d+)/$', views_cbv2.article_detail),
     url(r'^articles/cbv2/(?P<id>\d+)/$', DetailView.as_view(Article)), # views_cbv2 뷰 참조없음
]
```



### CBV는 구현은 복잡해도, 가져다 쓸 때는 SO SIMPLE !!!

- 그렇다고해서 CBV를 통한 뷰코드가 모두 심플해지는 것은 아님. 

- 이미 CBV에서 정해둔 시나리오를 따를 때에만 SIMPLE 

  - 재사용성은 높아지지만, 

  - 정해진 시나리오를 벗어날 때에는 복잡해질 여지가 많습니다.

-  CBV 만능주의 금물. FBV와 적절히 섞어쓰세요. CBV틀을 벗어나는 구현은 FBV가 훨씬 간단 

  - 함수로 구현하는 것이 재사용성은 낮지만, 로직 구현 복잡도가 낮아집니다.

- FBV먼저하고 나중에 cbv로 바꾸자



## CBV는 코드 재사용성을 높이기 위한 목적

중복을 제거하고, 코드 재사용성을 높이기 위함

- 하나의 뷰를 구현할 때,
  - 함수 : 하나의 로직 만을 담을 수 있다. 특정 로직 만을 변경할 수 없 다. 상속 개념이 없으므로, 유사한 뷰가 있을 경우 함수 전체를 그대 로 복사하여 활용해야함. 
  - 클래스 : 뷰를 다수의 함수로 구성할 경우, 특정 함수만 재정의하여 로직을 변경하기 용이하다.

> 관련 공식문서
>
> • Class-based views 
>
> • Form handling with class-based views 
>
> • Using mixins with class-based views 
>
> • Built-in class-based views API 
>
> • Class-based generic views - flattened index





#  상속을 통해 특정 루틴 재정의 (Overriding)

## 파이썬에서의 Overriding

- 상위 클래스가 가지고 있는 함수를 하위 클래스가 재정의
- 파이썬은 Overloading(함수명은 같으나, 인자의 자료형이나 수가 다른 함수의 선언을 허용하는 것)은 미지원

```
class Circle(object):
     def __init__(self, radius):
         self.radius = radius
     def get_area(self):
         return self.radius ** 2
     def __str__(self):
         return 'radius = {}, area = {}'.format(self.radius, self.get_area())
         
class Sphere(Circle):
		 def get_area(self): # get_area() 함수만 재정의
				 return self.radius ** 3
				 
print(Circle(3)) # radius = 3, area = 9
print(Sphere(3)) # radius = 3, area = 27
```



## CBV에 Overriding 활용

Overriding 대상 : 클래스 변수, 클래스 함수, 인스턴스 함수



```
from django.http import HttpResponse
from django.views import View

class GreetingView(View):
     message = 'Good Day' # Class Variable(클래스 변수)
     
     def get(self, *args, **kwargs):  #맴버함수
         return HttpResponse(self.message)  #self.message를 하면 인스턴스에 message있나 찾고 없으면 클래스 변수에서 찾음
         
greeting = GreetingView.as_view()  #이게 views.greeting을 호출시 실행됨

class MorningGreetingView(GreetingView):
			 message = 'Morning to ya' # Class Variable 재정의
			 
morning_greeting = MorningGreetingView.as_view()

evening_greeting = GreetingView.as_view(message='Evening to ya') #as_view 인스턴스 변수가 클래스 변수보다 우선순위 높으므로 evening to ya 로 출력됨
```

### view_fn = CBV.as_view(**init_kwargs) 의 동작방식

아래 코드는 주요루틴만 간략히 기술했습니다.(즉 view_fn함수= view(request, *args, **kwargs)



```
# 1)2)3) 순서로 잘보기

class View(object):
   def __init__(self, **kwargs):
     for key, value in kwargs.items(): # 3) 인스턴스 변수 세팅
       setattr(self, key, value) # => 이는 클래스 변수값 변경이 아닙니다.
       
 @classmethod
 def as_view(cls, **initkwargs): # 1) as_view 클래스함수의 인자로 주어진 keyword arguments는
     def view(request, *args, **kwargs):
         self = cls(**initkwargs) # 2) 내부적으로 CBV클래스 생성자의 인자로 넘겨지다!
         return self.dispatch(request, *args, **kwargs) #dispatch함수아직세팅안함
     return view

```

#### 함수로 재구현(스타일1)

```
def greeting(request, message='Good Day'):
	 return HttpResponse(message)
	 
def morning_greeting(request):
	 return greeting(request, 'Morning to ya')
	 
def evening_greeting(request):
	 return greeting(request, 'Evening to ya')
```

#### 함수로 재구현 (스타일2)

```
def greeting_view(message):
    def view_fn(request):
        return HttpResponse(message)
    return view_fn

greeting = greeting_view('Good Day')
morning_greeting = greeting_view('Morning to ya')
evening_greeting = greeting_view('Evenign to ya')
```



## 복잡한 뷰를 여러 함수에 나눠 구현하고, 재사용할 때 필요한 루틴만 재정의하기

```
def post_edit(request, id):
   instance =  get_object_or_404(Post, id=id) # Case 1) 인스턴스 획득 조건을 커스텀
   
   if request.method == 'POST':
  		 form = PostForm(request.POST, request.FILES, instance=instance)
  		 if form.is_valid():
  				 post = form.save()
  				 return redirect('/success_url/') # Case 2) 이동할 URL 변경
	 else:
		 form = PostForm()
	 return render(request, 'myapp/post_form.html', {'form': form}) # Case 3) 추가 파라미터 지정
 
def article_edit(request, id):
   # 위 post_edit 뷰와 비슷한 루틴인데, 중복을 최소화하고 재사용성을 어떻게 높일 수 있을까요?
     raise NotImplementedError
```



### 재사용이 가능토록, CBV패턴으로 재구현

```
 
from django.views import View

class EditFormView(View):
   model = None
   form_class = None
   success_url = None
   template_name = None
   
   def get_object(self):
       pk = self.kwargs['pk']
       return get_object_or_404(self.model, id=pk)

   def get_success_url(self):
   		return self.success_url #없다면 클래스 변수를 가져옴
   		
   def get_template_name(self):
   		return self.template_name  #없다면 클래스 변수를 가져옴
   		
 	 def get_form(self):
       form_kwargs = {
       'instance': self.get_object(),
       }
       if self.request.method == 'POST':
           form_kwargs.update({
               'data': self.request.POST,
               'files': self.request.FILES,
       })
 	    	return self.form_class(**form_kwargs) #form_class까지!!
 		
    def get_context_data(self, **kwargs):  #폼에넘길 인자들 사전현태로 만들기
        if 'form' not in kwargs:
            kwargs['form'] = self.get_form()
        return kwargs
 
    def get(self, *args, **kwargs):  #get요청일때 실행되는 함수
			   return render(self.request, self.get_template_name(), self.get_context_data())
 
    def post(self, *args, **kwargs): #post요청일떄 실행되는 함수
        form = self.get_form()
         if form.is_valid():
             form.save()
             return redirect(self.get_success_url())
         return render(self.request, self.get_template_name(), self.get_context_data(form=form))
```



### 활용 1) 클래스 변수값만 재정의

```
post_edit = EditFormView.as_view(
     model=Post,
     form_class=PostForm,
     success_url='/weblog/',
     template_name='blog/post_form.html')  #인자로 들어갈때는 self.이 앞에 붙나보네
```

혹은

```
class PostEditFormView(EditFormView):
       model = Post
       success_url = '/weblog/'
       template_name = 'blog/post_form.html'
post_edit = PostEditFormView.as_view()
```



### 각 인스턴스 함수들을 재정의

```
from django.shortcuts import resolve_url

class PostEditFormView(EditFormView):
     model = Post
     template_name='blog/post_form.html'
     
     def get_object(self):
         pk = self.kwargs['pk']
         return get_object_or_404(self.model, id=pk, created_at__year=2017) # 2017년 포스팅 중에서  #field에 publish이나 유저가 슈펴만도가능
     def get_context_data(self, **kwargs):
         context = super().get_context_data(**kwargs)
         context['dummy_params'] = '더미 인자'   #추가로하여 템플릿에서 값가져오기가능
         return context
         
     def get_success_url(self):
         return resolve_url('blog:post_detail', self.kwargs['pk']) #함수구현을 통해서 매 다른 경로로 이동가능
         
post_edit = PostEditFormView.as_view()
```



## 정리

- 각 CBV 동작은 소스코드를 직접 살펴보고 이해해야 합니다. 

  문서로는 설명하는 데에 한계가 있어요. 

- 파이썬에서 멤버함수 호출순서는 MRO 순서를 따릅니다. 

  파이썬 차근차근 시작하기 <클래스 상속과 MRO> 에피소드 참고

# HTTP 메소드별 처리

## 다양한 HTTP 메소드

- GET #spec : 요청 URI의 정보 
- POST #spec : 요청 URI에 새로운 정보 보냄
- PUT #spec : 요청 URI에 갱신할 정보 보냄 (전체를 교체) 
- PATCH #spec : 요청 URI에 갱신할 정보 보냄 (일부를 교체) 
- DELETE #spec : 요청 URI의 리소스를 삭제 
- HEAD #spec : GET요청에서 body는 제외하고 헤더만 응답  >get요청 할지말지 판단빠르게가능
- OPTIONS #spec : 요청 URI에서 사용할 수 있는 Method를 응답 
- TRACE #spec : 보낸 메시지를 다시 돌려보낸다.



## HTTP 메소드별 인스턴스함수 지원

하나의 뷰 (즉 하나의 URL) 에서 다양한 HTTP 메소드를 지원해야할 때

```
class View(object):
     http_method_names = ['get', 'post', 'put', 'patch', 'delete', 'head', 'options', 'trace']
     
     # 중략
     
     def dispatch(self, request, *args, **kwargs): #모든 http메소드에 다쓰임 
         '''
         본 함수를 통해 각 인스턴스 함수로의 분기를 처리
         CBV에서는 모든 HTTP 요청은 dispatch 인스턴스 함수를 통해 처리됩니다.
         '''
         if request.method.lower() in self.http_method_names:
        		 handler = getattr(self, request.method.lower(), self.http_method_not_allowed) #self이므로 현재요청에대해, get, post에 맞는 인스턴스함수들(요소들 attribute)을 획득시도, 없다면 3번째 인자 return 해라
         else:
        		 handler = self.http_method_not_allowed
         return handler(requset, *args, **kwargs)
```

### Example) ListView에서 head1 요청을 처리할 경우

```
ipython에서 head만 받고싶은 경우 requests.head('http://~~').headers



from django.http import Http404, HttpResponse

class PostListView(ListView):
   model = Post
   queryset = Post.objects.all().ordered_by('-id') #쿼리 추가 옵션
   
   def head(self, *args, **kwargs):
       try:
      		 post = self.get_queryset().latest('created_at') #추가 옵션적용된 쿼리셋가져오는 함수가 .get_queryset()임
       except Post.DoesNotExist:
      		 raise Http404
      		 
       response = HttpResponse()
       # RFC 1123 date format
       response['Last-Modified'] = post.created_at.strftime('%a, %d %b %Y %H:%M:%S GMT') #이 형식으로 head응답에 추가해줌
       return response
       
   def delete(self, *args, **kwargs):
   		raise NotImplementedError
   
post_list = PostListView.as_view()


즉 http 메서드에 따라서 이렇게 추가가능
```

### FBV 스타일로 구현

```
def post_list(request):
     if request.method == 'HEAD':
         try:
         		post = Post.objects.all().latest('created_at')
         except Post.DoesNotExist:
         		raise Http404
         		
         response = HttpResponse()
         # RFC 1123 date format
         response['Last-Modified'] = post.created_at.strftime('%a, %d %b %Y %H:%M:%S GMT')
         return response
         
      elif request.method == 'DELETE':
     		 raise NotImplementedError
     		
     return render(request, 'myapp/post_list.html', {
     		'post_list': Post.objects.all(),
     })
```

# CBV에 장식자 입히기

## 장식자(Decorators)

- 어떤 함수를 감싸는 (Wrapping) 목적의 함수

```
def base_10(fn):  #장식자 정의
     def wrap(x, y):
         return x + y + 10
     return wrap
     
@base_10
def mysum2(x, y):
 return x + y
 
# 이는 아래 코드와 동일 #함수 감싸주는 형태!

def mysum1(x, y):
 return x + y
mysum1 = base_10(mysum1)
```

### FBV) 뷰 함수에 장식자 적용

````
from django.contrib.auth.decorators import login_required
from django.shortcuts import render

@login_required  #역할은 아래 함수실행전에 로그인되어있는지 안되어있을시 로그인페이지로보냄
def protected_view(request):   #get, post요청 구별못해
 		return render(request, 'myapp/secret.html')
````

### CBV) FBV 스타일로 장식자 적

```
from django.contrib.auth.decorators import login_required
from django.views.generic import TempalteView

class SecretView(TemplateView):
		 template_name = 'myapp/secret.html'
 
view_fn = SecretView.as_view()

secret = login_required(view_fn) # 생성된 함수에 장식자 입히기
```

### CBV) 클래스에 직접 장식자 입히기 #1

- CBV에서 모든 요청은 dispatch 함수를 통해 처리되므로, dispatch 멤버함수를 꾸며야 합니다.

```
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator
from django.views.generic import TempalteView

#아래코드와 FBV뷰 함수에 장식자 적용은 같은 동작을함

class ProtectedView(TemplateView):
		 template_name = 'myapp/secret.html'
 
		 @method_decorator(login_required) # 인스턴스 함수를 꾸밀 때 #이렇게 장식해줘야함
     def dispatch(self, *args, **kwargs):
    		 return super().dispatch(*args, **kwargs)
protected = ProtectedView.as_view()
```

### CBV) 클래스에 직접 장식자 입히기 #2 (추천)

```
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator
from django.views.generic import TempalteView


# 클래스도 장식자 지원함. 클래스를 꾸밀 때, 인스턴스 함수명을 지칭
@method_decorator(login_required, name='dispatch') #클래스에서 원하는 함수 클래스이름만 적으면됨 

class AnotherProtectedView(TemplateView):
 		template_name = 'myapp/secret.html'
 		
another_protected = AnotherProtectedView.as_view()
```

#  Mixin과 django-braces

## Mixins을 통해 여러 CBV를 한번에 조합

- Mixins은 그냥 상속이라고 생각하자
-  CBV는 재사용성에 초점을 둔 뷰 
  - 기존 패턴을 사용할 경우에는 CBV가 단순하지만, 
  - 새로운 루틴의 뷰를 구현하실 때에는 FBV를 사용하시는 것이 구현이 더 단순해지실 경우 가 많습니다.
- 파이썬은 다중상속을 지원합니다.
- 동일 멤버함수가 여러 CBV에 걸쳐서 구현되었을 경우, MRO (Method Resolution Order) 1 순서대로 호출됩니다. (파이썬 차근차근 시작하기 "클래스 상속과 MRO"참조)

### 예시(FBV)

```
def home_page(request): # 요청이 들어왔을 때
     # 템플릿에서 사용할 인자를 준비하고
     context = {}
     # 템플릿 파일을 선택한 다음
     template_name = 'home.html'
     # HttpResponse응답을 생성
     return render(request, template_name, context)
```

### 예시(CBV) (클래스가 다들 상속되어있다)

```
class TemplateResponseMixin:
     def render_to_response(self, context, **response_kwargs):
     		'HttpResponse 응답 생성'
     
     def get_template_names(self):
    		 '사용할 템플릿 파일 이름 정하기'
     
class ContextMixin:
		 def get_context_data(self, **kwargs):
				 '템플릿에서 사용할 변수목록 만들기'
class View:
    @classmethod
    def as_view(cls, **initkwargs):
			 '뷰 함수를 생성'
 
    def dispatch(self, request, *args, **kwargs):
 				'Http 요청이 들어오면 호출되어, 요청을 처리'
 				
class TemplateView(TemplateResponseMixin, ContextMixin, View):
		 def get(self, request, *args, **kwargs):
 						context = self.get_context_data(**kwargs) # 부모 CBV의 Context 데이터를 받아와서
			 		  return self.render_to_response(context) # HttpResponse 응답 생성
 
 
#FBV예시와 동일, 여기서부터 위로 분석해보기
class HomePageView(TemplateView):
 		template_name = 'home.html' # get_template_names 함수에서 참조하는 값
 		
 		def get_context_data(self, **kwargs):
 		    context = super().get_context_data(**kwargs)
 		    context['name'} = 'AskDjango' #이런식으로 템플릿에 전달하는 정보추가 가능
 		    return context
 		
# as_view 호출을 통해 뷰 함수 생성
home_page = HomePageView.as_view()
```

## django.views.generic (일반적인 활용에좋음)

__사용법들은 개발 문서보기__

더 필요한 옵션을 추가하고싶다면 코드를 뜯고 부모, 부모의부모를 super()로 부르고 거기에 추가만 해주면됨

### django.views.generic.base

- ContextMixin
- TemplateResponseMixin
- __TemplateView__(TemplateResonseMixin, ContextMixin, View) 

```
from django.views.generic.base import TemplateView

class HomePageView(TemplateView):

     template_name = 'home.html'
     def get_context_data(self, **kwargs):
         context = super().get_context_data(**kwargs)
         context['latest_articles'] = Article.objects.all()[:5]
         return context
```

### django.views.generic.dates

- YearMixin, MonthMixin, DayMixin, WeekMixin -
- BaseDateListView(MultipleObjectMixin, DateMixin, View) 
- __ArchiveIndexView__(MultipleObjectTemplateResponseMixin, BaseArchiveIndexView) 
- BaseYearArchiveView(YearMixin, BaseDateListView) 
- __YearArchiveView__(MultipleObjectTemplateResponseMixin, BaseYearArchiveView)
- BaseMonthArchiveView(YearMixin, MonthMixin, BaseDateListView) 
- __MonthArchiveView__(MultipleObjectTemplateResponseMixin, BaseMonthArchiveView) 
-  BaseWeekArchiveView(YearMixin, WeekMixin, BaseDateListView) 
- __WeekArchiveView__(MultipleObjectTemplateResponseMixin, BaseWeekArchiveView) 
- BaseDayArchiveView(YearMixin, MonthMixin, DayMixin, BaseDateListView) 
- __DayArchiveView__(MultipleObjectTemplateResponseMixin, BaseDayArchiveView)
-  __TodayArchiveView__(MultipleObjectTemplateResponseMixin, BaseTodayArchiveView) 
- BaseDateDetailView(YearMixin, MonthMixin, DayMixin, DateMixin, BaseDetailView) 
- __DateDetailView__(SingleObjectTemplateResponseMixin, BaseDateDetailView)



```
from django.views.generic.dates import ArchiveIndexView, YearArchiveView, MonthArchiveView

class PostArchiveIndexView(ArchiveIndexView): #모델과 저거 기준으로 정렬됨 
     model = Article
     date_field = 'pub_date'
     
class ArticleYearArchiveView(YearArchiveView): #년단위
     queryset = Article.objects.all()
     date_field = 'pub_date'
     make_object_list = True
     allow_future = True
     
class ArticleMonthArchiveView(MonthArchiveView): #월단위
     queryset = Article.objects.all()
     date_field = "pub_date"
     allow_future = True
```



### django.views.generic.detail

- SingleObjectMixin(ContextMixin)
- BaseDetailView(SingleObjectMixin, View) 
- SingleObjectTemplateResponseMixin(TemplateResponseMixin) 
- __DetailView__(SingleObjectTemplateResponseMixin, BaseDetailView)



### django.views.generic.edit

- FormMixin(ContextMixin) 
- ModelFormMixin(FormMixin, SingleObjectMixin) 
- BaseFormView(FormMixin, ProcessFormView) 
- __FormView__(TemplateResponseMixin, BaseFormView)
- BaseCreateView(ModelFormMixin, ProcessFormView)
- __CreateView__(SingleObjectTemplateResponseMixin, BaseCreateView)
- BaseUpdateView(ModelFormMixin, ProcessFormView) 
- __UpdateView__(SingleObjectTemplateResponseMixin, BaseUpdateView) 
- DeletionMixin
- BaseDeleteView(DeletionMixin, BaseDetailView) 
- __DeleteView__(SingleObjectTemplateResponseMixin, BaseDeleteView)



### django.views.generic.list

- MultipleObjectMixin(ContextMixin)
- BaseListView(MultipleObjectMixin, View) 
- MultipleObjectTemplateResponseMixin(TemplateResponseMixin)
- __ListView__(MultipleObjectTemplateResponseMixin, BaseListView)

```
from django.views.generic.list import ListView

class ArticleListView(ListView):
		 model = Article
```

## django-braces (써드파티 Class Based View)

- LoginRequiredMixin : 로그아웃 시에 로그인URL로 이동 
  - 장고 1.9부터 django.contrib.auth.mixins.LoginRequiredMixin에 서 동일 기능을 제공 
- PermissionRequiredMixin(AccessMixin)
- MultiplePermissionsRequiredMixin(PermissionRequiredMixin)
- GroupRequiredMixin(AccessMixin)
- UserPassesTestMixin(AccessMixin) 

- SuperuserRequiredMixin(AccessMixin)
- AnonymousRequiredMixin(object) 
- StaffuserRequiredMixin(AccessMixin) 
  - staff 제한 
- __SSLRequiredMixin(object)__
  - 현재 페이지의 https URL로 이동 응답 (301). raise_exception=True 설정으로 404 응답도 가능
- __RecentLoginRequiredMixin__(LoginRequiredMixin
  - 지정 시간 (디폴트 30분) 내 로그인 여부 체크
  - 시간을 넘겼다면, 로그아웃/로그인 요청



### Form Mixins

- CsrfExemptMixin 
- UserFormKwargsMixin 
- UserKwargModelFormMixin 
- SuccessURLRedirectListMixin
- FormValidMessageMixin
- FormInvalidMessageMixin
- FormMessagesMixin

Other Mixins

> • SetHeadlineMixin • StaticContextMixin • SelectRelatedMixin • PrefetchRelatedMixin • JSONResponseMixin • JsonRequestResponseMixin • AjaxResponseMixin • OrderableListMixin • CanonicalSlugDetailMixin • MessageMixin • AllVerbsMixin • HeaderMixin



2019.12.10

