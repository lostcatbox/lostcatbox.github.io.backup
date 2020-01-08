---
title: 기타 꿀팁과 햇갈리는 것 정리
date: 2019-10-19 19:10:12
categories: Terminal
tags: [Terminal, Basic]
---



# 정리가 필요한 것

------

Rest api (???)





# 터미널에서

------

```
pip freeze #현재 설치된 버전들 모두 볼수있다
pip freeze>requirements.txt #현재 설치된 버전들을 txt파일로 저장함
pip install -r requirements.txt #패키지 이름하고 해당 버전 읽어서 다 다운로드함

Cat requirements.txt #파일 내용 출력

cv requirements.txt ../cbv #복붙 기능 상위폴더에 cbv폴더안에

mv requirements.txt ../cbv #이동 기능 상위폴더에 cbv폴더안에


```

## 파일 내용을 보고싶을때

------

```
vi <파일이름>
```

i를 누르면 edit mode 
다 수정후 :wq  로 나간다 (저장후 끄기)



# Git

[자세히](https://lostcatbox.github.io/2019/10/19/git-memo/)



# 파이참에서

```
shift+shift는 프로젝트내에서 파일찾기임
```

# Django

```
python3 manage.py sqlmigrate blog 0001_initial sql언어로 뭐가 실행될지 알려준다

```

## Form

Db와 model이 이어진것처럼

frontend와 form이 이어짐

### form의 특징 (딱 3가지만 기억하자)!

- 입력폼을 생성: .as_table(), .as_p(), .as_ul() 기본제공
- 입력폼 값 검증(validation) 및 값 변환 (프론트엔드) 
- 검증을 통과한 값들을 사전타입(cleaned_data이름으로 제공)

- 과정: 즉, get요청으로 처음으로 form = FormClass()>>입력폼 호출됨>>유저가 입력>>post요청>>form = FormClass(request.POST, request.FILES)를 받고>>form.is_valid() 유효성검사>>
  - valid판정시 form.cleaned_data통해 필드별 값 제공받음>> form.save()로 저장후 다른 URL로 이동
  - invalid판정시 form.errors통해 필드별 오류메세지 제공받음>>오류 메세지와 함께 입력 html폼을 노출

```
#뷰 함수에서 구현
def post_new(request):
    if request.method == 'POST':
        form = PostForm(request.POST, request.FILES)
        if form.is_valid():
            post = Post(**self.cleaned_data)
            post.save()
            return redirect(post)
            
    else:
        form = PostForm()
    return render(request, 'blog/post_form.html', {
        'form': form,
    })
```

Tip: 꼭 return render(~~)가 있어서 템플릿 또한 필요하고 form을 넘겨서 form.as_table()으로 입력폼을 생성할수있도록 해주자

```
#form의 html예시
<table>
     <form action="" method="post">
             {% csrf_token %}
             <table>{{ form.as_table }}</table> #이게 오류를 불러와줌, Form에 각 필드가 테이블 행으로  렌더링됨!!!
             <input type="submit" />
     </form>
</table>
```

### [모델에 값저장방법4가지](https://spicyhoro.github.io/2019/11/15/django03/#Django-Style)

### [나머지 요약정리](https://spicyhoro.github.io/2019/11/15/django03/#Form-Fields)









# html

## get

Method="GET"은 헤더만 존재하며 urlencoded방식으로만 전달되며

url뒤쪽에 ?~~~로 붙는다

## post

Method="POST"는 기본적으로 바디 둘다 존재하며

- urlencoded방식

  get과 같은 전달방식이므로 body에 위에 url?뒤쪽에 전부 같은 방식으로 붙는다

- multipart/form-data 방식(파일정말 전송할려면 이방법말고없다)

```
-----------------------------14973275531370807725960869059 #여기부터바디
Content-Disposition: form-data; name="title"
title
-----------------------------14973275531370807725960869059
Content-Disposition: form-data; name="content"
(생략 ...)
```

식으로 아예 다른방식으로 바디에 붙는다. 





# Django-Bootstrap3

bootstrap3 스타일로 HTML을 생성해주는 template tags 제공 설치 쉘>

```
 pip3 install django-bootstrap3
settings.INSTALLED_APPS 에 "bootstrap3"
```

```
#원하는 템플릿에서 

{% raw %}

{# bootstrap3 라이브러리 로드 #}
{% load bootstrap3 %}
{# bootstrap3 라이브러리를 통해 css/javascript 태그 출력 #}
{% bootstrap_css %}
{% bootstrap_javascript %}
<form action="" method="post" class="form">
     {% csrf_token %}
     {% bootstrap_form form %} <!-- bootstrap3 라이브러리를 통해 Form Render -->
     <input type="submit" class="btn btn-primary btn-lg" />
</form>

{% endraw %}
```





















[자세히](https://spicyhoro.github.io/2019/11/15/django03/#django-bootstrap3-%ED%8C%A9%ED%82%A4%EC%A7%80)





# Python 문법

```
[표현식 for 항목 in 반복가능객체 if 조건문]
조금 복잡하지만 for문을 2개 이상 사용하는 것도 가능하다. for문을 여러 개 사용할 때의 문법은 다음과 같다.

[표현식 for 항목1 in 반복가능객체1 if 조건문1
        for 항목2 in 반복가능객체2 if 조건문2
        ...
        for 항목n in 반복가능객체n if 조건문n]
만약 구구단의 모든 결과를 리스트에 담고 싶다면 리스트 내포를 사용하여 다음과 같이 간단하게 구현할 수도 있다.

>>> result = [x*y for x in range(2,10)
...               for y in range(1,10)]
>>> print(result)
[2, 4, 6, 8, 10, 12, 14, 16, 18, 3, 6, 9, 12, 15, 18, 21, 24, 27, 4, 8, 12, 16,
20, 24, 28, 32, 36, 5, 10, 15, 20, 25, 30, 35, 40, 45, 6, 12, 18, 24, 30, 36, 42
, 48, 54, 7, 14, 21, 28, 35, 42, 49, 56, 63, 8, 16, 24, 32, 40, 48, 56, 64, 72,
9, 18, 27, 36, 45, 54, 63, 72, 81]
지금껏 우리는 프로그램 흐름을 제어하는 if문, while문, for문에 대해 알아보았다. 아마도 여러분은 while문과 for문을 보면서 2가지가 아주 비슷하다는 느낌을 받았을 것이다. 실제로 for문을 사용한 부분을 while문으로 바꿀 수 있는 경우도 많고, while문을 for문으로 바꾸어서 사용할 수 있는 경우도 많다.
```
