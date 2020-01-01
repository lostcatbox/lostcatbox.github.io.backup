---
title: Django 기본 세번째이야기
date: 2019-11-15 15:01:48
tags: [Basic, Django]
categories: Django
---



#  Bootstrap3 CSS Style Template

## CSS OpenSource Framework

- 웹프론트엔드 UI를 일관된 모습으로 편하게 구성 가능

- Bootstrap, Material Design for Bootstrap, Material-UI, BULMA , Semantic UI, Pure.css , Zurb Foundation , UIkit

  

## Twitter Bootstrap3

- 원래 이름은 Twitter Blueprint로 Mark Otto와 Jacob Thornton이 만들 었다. 
- 12칸 Grid System
- 다양한 써드파티 유료/무료 테마
- Bootstrap4 알파버젼

## 기본 HTML 템플릿 골격

프로젝트에 템플릿에 layout.html에 골격 만들꺼임





# Django Template Engine (Template Tag)

장고 철학은 fat model, stupid template, thin view



## Template Engines 몇 가지

- Django Template Engine : Django 기본 지원 템플릿 엔진
- Jinja2 : 써드파티 엔진이었으나, 최근에 최소한의 지원이 내장됨.
  - Django Template Engine과 문법이 유사
  - Django Template Engine과 문법이 유사

- Mako, HamlPy
- 장고 프로젝트에서 다른 템플릿 엔진을 쓸 수도 있으나, 가급적이면 기본 장 고 템플릿 엔진에 먼저 익숙해지기를 권장

## Django Template Engine Syntax

```
{% raw %}
{% extends 'base.html' %} >>이것에 extends를 장고 템플릿 태그임, 그뒤는 인자들

{# 파이썬 로직 불가. 템플릿 렌더링 전에 필요한 값을 인자로 받습니다. #}

{% for row in rows %}
    <tr>
        {%for name in row %}
            <td>{{name}}</td>
        {% endfor %}
    </tr>
{% endfor %}
{% endraw %}
```



positional Arguments는 mysum(1,2)처럼 인자의 위치에 기반 대입됨

keyword arguments는 mysum(z=10)처럼 인자의 keyword를 기반으로 대입됨

장고 템플릿태그 인자도 위와같이 2가지 존재

> Mako Syntax(문법다 다르다는것인지)
>



## Django Template Engine

### variables(=변수)(원하는 위치에서 출력)

- {{ first_name }}
- {{ mydict.key }} : dict의 key에 attr처럼 접근 

     ```
     people = {'Tom': 10, 'Steve': 20}
     
     #python code
     people['Tom']
     
     # django template engine  >>syntex 차이남
     {{ people.Tom }}
     ```



- {{ myobj.attr }} 

- {{ myobj.func }} : 함수호출도 attr처럼 접근. 인자있는 함수호출 불가 , func()에서 __() 필요없다.__

- {% raw %} {{ mylist.0 }} {% endraw %} : 인덱스 접근도 attr처럼 접근

  ```
  names[0]
  
  {{names.0}}
  ```

  

### Django Template Tag

- Django Templates용 함수

- {% raw %}{% %}{% endraw %} 홀로 쓰이기도 하며, 2개 이상이 조합되기도 함. {% raw %}{%for~~%} {%endfor%} {% endraw %}처럼 2개이상조합

- __*빌트인 Tag*__ 가 지원되며, 장고앱 별로 커스텀 Tag 추가 가능

- block, comment, csrf_token, extends, for, for ... empty, if, ifchanged, include, load, lorem, now, url, verbatim, with 등

- __Tip: 장고에서 인자를 전달할때는 ,하고 ()는 쓰지 않는다.!!!!!!!!!!!!!__

  



#### block tag

- 템플릿 상속에서 사용

- 자식 템플릿이 오버라이딩할 block 영억을 정의

- 자식 템플릿은 부모가 정의한 block에 한해서 재정의만 가능, 그 외는 모두 무시됨

  ```
  {% block block-name %} 
  
  block 내에 내용을 쓰실 수 있습니다.
  
   {% endblock %}
  ```

  

#### comment tag

- 템플릿 주석

- comment 영역을 서버 단에서 처리하지 않음.   __JS 주석과 헷갈리지마세요__

  즉 이 템플릿주석은 client가 요청하면 서버에서 해석을 안하고 처리안하고

  JS주석(/* ~~뭐라뭐라~~ */ , <! ~~뭐라뭐라~~>)은 이것들은 그사이에 모든 것 서버에서는 처리하고

  Client의 프론트엔드에서 처리안하는것임

- 즉 템플릿단에 주석다는게 좋다 

```
# 한줄 주석
{#~~~~~~#}


#여러줄 주석
{% comment "Optional note" %}  #Optional note는 뺴도됨 설명임
 이 부분은 렌더링되지 않습니다.
{% endcomment %}
```



#### csrf_token tag

- Cross Site Request Forgeries를 막기 위해 CSRF Middleware가 제공 

- 이는 HTML Form의 POST요청에서 CSRF토큰을 체크하며, 이때 CSRF토큰이 필요 

  (장고의 Form에 대해 한 View에서 get(이때 빈 form을 보여줌)(token발급함)요청을 받고 다음에 post요청(이때 token값일치비교) 을 받음 )

- csrf_token tag를 통해 CSRF토큰을 발급받을 수 있습니다.



#### extends tag

- 자식 템플릿에서 부모 템플릿 상속을 명시 

- extends tag는 항상 템플릿의 처음에 위치해야합니다. 

- __상속받은 자식 템플릿은 부모 템플릿에서 정의한 block만 재정의할 수 있습니다.__ 
```
{% raw %}
  {% extends "base.html" %}
{% endraw %}
```
#### for tag

- 지정 객체를 순회

- 파이썬의 for문과 동일

  ```
  <ul>
  {% for athlete in athlete_list %}
      <li>{{ athlete.name}}</li>
  {% endfor %}
  </ul>
  ```

  

#### loop내 추가 지원 Variable

• forloop.counter : 반복 인덱스 (1부터 시작하여 1씩 증가) 

• forloop.counter0 : 반복 인덱스 (0부터 시작하여 1씩 증가) 

• forloop.revcounter : 반복 인덱스 (끝인덱스부터 시작, 1씩 감소) 

• forloop.revcounter0 : 반복 인덱스 (끝인덱스-1부터 시작, 1씩 감소) 

• forloop.first, forloop.last : 첫 실행 여부, 마지막 실행 여부 

• forloop.parentloop : 중첩 loop에서 부모 loop를 지정





#### for ... empty tag (자주씀)

- for tag 내에서 지정 object를 찾을 수없거나, 비었을때 empty block 이 수행

```
<ul>
     {% for athelete in athlete_list %}
         <li>{{ athelete.name }}</li>
     {% empty %}
         empty
     {% endfor %}
</ul>

#python code 에서는

if athelete_list:
    for athelete in athelete_list:
        print(athelete.name)
        
else:
   print("empty")

```

#### if tag 

- 파이썬의 if문과 동일

  ```
  {% if athlete_list %}
       Number of athletes: {{ athlete_list|length }}
  {% elif athlete_in_locker_room_list %}
       Athletes should be out of the locker room soon!
  {% else %}
       No athletes.
  {% endif %}
  ```

## 

#### ifchanged tag

- 변수가 지정되지 않으면, content의 내용이 변경되었을 때 True 판정
   (태그 안에있는것들의 변경여부 판단)
- 변수가 지정되면, 지정 변수값 변경이 되었을 때 True 판정
- 즉 아래 예시는 변경될때 아래것이 프린트되는구조

```
{% raw %}
<h1>Archive for {{ year }}</h1>
{% for date in days %} #변경내역을 html안에서 검사하고싶을때 쓰는방법
     {% ifchanged %}<h3>{{ date|date:"F" }}</h3>{% endifchanged %}
     <a href="{{ date|date:"M/d"|lower }}/">{{ date|date:"j" }}</a>
{% endfor %}

{% for date in days %}
     {% ifchanged date.date %}  #지정변수지정됨!! (위에예시는 인자 안 넘김)
          {{ date.date }}
     {% endifchanged %}
     {% ifchanged date.hour date.date %} #인자를 여러개 받을수있음
          {{ date.hour }}
     {% endifchanged %}
{% endfor %}
{% endraw %}
```





#### include tag

- 다른 템플릿을 로딩/렌더링을 수행하며, 현재 템플릿의 context가 그대로 다른 템플릿으로 전달 (context는 변수목록들)

- include 시에 keyword 인자를 지정하여, 추가 context 지정 가능

  ```
  {% include "foo/bar.html" %}
  {% include "name_snippet.html" with person="Jane" greeting="Hello" %}
  ```

  

#### load tag

- {% raw %} 파이썬에서의 import와 비슷 (템플릿내에서 다른 tag사용하고싶으면)

- 커스텀 Template Tag/Filter Set 로딩

-  load 시에 다수 팩키지 기입 가능 

  {% load custom_tags1 package.other_tags2 %} 

- load 시에 library내 특정 filter/tag 선택적 로딩 기능 

  {% load foo bar from custom_tags1 %}

- 더 알아보기 : Custom template tags and filters {% endraw %}



#### lorem tag(유용함)

- 이걸로 처음에 테스트로 채워놓고 나중에 빼고 원하는 context채우면됨

- 랜덤 채우기 텍스트를 생성

  {% raw %}{% lorem [count] [method] [random] %}  #[]는 생략가능하다는 뜻 {% endraw %}

  

- count : 생성할 단락/단어의 수 (디폴트 : 1) 

- method : 단어일 경우 w 지정, HTML 단락일 경우 p 지정,

  Plain Text 단락일 경우 b 지정 (디폴트: b) 

- random : random 지정/미지정, 지정 시에는 보통의 채우기 텍스트 

  ("Lorem ipsum dolor sit amet ...")를 쓰지 않고, 랜덤 문자열 생성

```
{% raw %}
{% lorem %} : 보통의 채우기 텍스트 출력
{% lorem 3 p %} : HTML 단락 3개 출력
{% lorem 2 w random %} : 랜덤 단어 2개 출력
{% endraw %}
```

#### now tag

- 현재 날짜/시각을 출력 
{% raw %}
- 출력포맷은 date templatetag [사용법 참고](https://docs.djangoproject.com/en/1.10/ref/templates/builtins/#std:templatefilter-date) 
{% endraw %}
  ```
  {% raw %}
  It is {% now "jS F Y H:i" %}
  {% endraw %}
  ```
  
  

#### url tag

- URL Reverse를 수행한 URL문자열을 출력

- 인자처리는 django.shortcuts.resolve_url 함수와 유사하게 처리하나, 

  get_absolute_url처리는 안함

```
{% raw %}
{% url "some-url-name-1" %}
{% url "some-url-name-2" arg arg2 %}
{% url "some-url-name-2" arg arg2 as the_url %} #url문자열을 the_url변수에저장
{% endraw %}
```

#### verbatim tag

- 지정 블락 내에서는 장고 템플릿 엔진을 통한 렌더링을 수행하지 않음.
- 대개 자바스크립트에서 {% raw %} {{ }} {% endraw %} 를 쓸 수 있도록 하기 위한 목적(이부분은 JS가 처리하게하기위함)

```
{% raw %}
{% verbatim %}
     {{if dying}}Still alive.{{/if}}
{% endverbatim %}
{% endraw %}
```

- AngularJS는 장고템플릿엔진과 동일한 interpolation symbol 을 쓰기 때문에 충돌 발생.

  >  방안1) 장고 측에서 verbotim tag 를 통해 angularjs에서 쓸 수 있 도록 영역을 보장해주거나,  {{name}}을 장고템플릿이 처리하지않고 JS에서 처리하기위해
  >
  > 방안2) angularjs 측에서 interpolation symbol을 변경

#### with tag

- 변수에 새로운 값을 assign

  ```
  {% raw %}
  {% with alpha=1 beta=2 %}
   ...
  {% endwith %}
  {% with total=business.employees.count %}  #긴 변수명을 줄이는기능으로사용가능
   {{ total }} employee{{ total|pluralize }}
  {% endwith %}
  
  {% endraw %}
  
  ```



#### 이외의 빌트인

 [공식문서참조](https://docs.djangoproject.com/en/1.10/ref/templates/builtins/#built-in-tag-reference)







# Django의 Template Englnes (Template Filter)

- Django Template Filter

- __템플릿 변수값 변환__을 위한 함수이며, 다수 필터 함수를 연결 가능

  {% raw %}

  {{ var|filter1 }}, {{ var|filter2:인자 }}, {{ var|filter3:인자|filter4 }}

  (filter1에 첫번쨰인자var)

  (filter2에 첫번째인자 var, 두번째 인자 인자)

  (filter3에 첫번째인자 var, 두번째인자 인자, >>>>이걸첫번째인자로받는 filter4)



- [빌트인 Filter](https://docs.djangoproject.com/en/1.10/ref/templates/builtins/#built-in-filter-reference)가 지원되며, 장고앱 별로 커스텀 Filter 추가 가능
{% raw %}
  date, time, timesince, timeuntil, default, default_if_none, join, length, linebreaks, linebreaksbr, pprint, random, safe, slice, striptags, truncatechars, truncatechars_html, truncatewords, truncatewords_html, urlencode, urlize 등
{% endraw %}
#### ## {% raw %} date filter, time filter {% endraw %}

- 날짜/시각 출력형식 지정

- 지정포맷으로 출력

- PHP의 {% raw %} date() {% endraw %}포맷과 유사


  ```
  {% raw %}
  {{ datetime_obj|date:"D d M Y" }} 
  => 'Wed 09 Jan 2008'
  {{ datetime_obj|date:"DATE_FORMAT" }} 
  => 디폴트 'N j, Y' (e.g. Feb. 4, 2003)
  {{ datetime_obj|date:"DATETIME_FORMAT" }}
  => 디폴트 'N j, Y, P' (e.g. Feb. 4, 2003, 4 p.m.)
  {{ datetime_obj|date:"SHORT_DATE_FORMAT" }}
  => 디폴트 'm/d/Y' (e.g. 12/31/2003)
  {{ datetime_obj|date:"SHORT_DATETIME_FORMAT" }}
  => 디폴트 'm/d/Y P' (e.g. 12/31/2003 4 p.m.)
  {{ datetime_obj|time:"TIME_FORMAT" }} 
  => 디폴트 'P' (e.g. 4 p.m.)
  {% endraw %}
  ```

  - {% raw %} DATE_FORMST, DATETIME_FORMAT, SHORT_DATE_FORMAT, SHORT_DATETIME_FORMAT은 프로 젝트 settings 내에서 재정의 {% endraw %}
  -  {% raw %} {{ datetime_obj|date }} 와 같이 인자가 지정되지 않을 경우, DATE_FORMAT 설정이 사용됨 {% endraw %}

## timesince filter, timeuntil filter

- timesince : 과거시각 (past_dt) (1 June 2006), 기준시각 (08:00 on 1 June 2006) 일 경우 : "8 hours" 출력

- {% raw %} timezone 정보가 없는 (offset-naive) datetime object와 timezone 정보가 있는 (offset-aware) datetime object를 서로 비 교할 경우, 빈 문자열을 출력)(비교불가하므로) {% endraw %}

  따라서 from django.utils import timezone으로 불러야 tzinfo=<UTC>가 기본으로 들어가므로 이렇게 import 해서 쓰기  timezone.now()로 해서얻기



```
{{ past_dt|timesince }} 
=> 현재시각 기준 (now - past_dt)
{{ past_dt|timesince:criteria_dt }}  #인자 존재
=> 기준시각 기준 (criteria_dt - past_dt)
{{ future_dt|timeuntil }} 
=> 현재시각 기준 (future_dt - now)
{{ future_dt|timeuntil:past_dt}} # 인자 존재
=> 기준시각 기준 (future_dt - past_dt)
```



(페이스북보면 글 8시간전 작성 이런것에 쓰임)



## default filter, default_if_none filter

- default: 값이 False일 경우, 지정 디폴트값으로 출력

  - False일때는 값이 none이거나 빈 문자열/리스트/튜플 등

-  default_if_none: 값이 None일 경우, 지정 디폴트값으로 출력

  ```
  {{ value|default:"nothing" }} #value가 False일때 value대신 "nothing"을 찍겠다!
  {{ value|default_if_none:"nothing" }}
  ```

  

## join filter

- 순회가능한 객체를 지정 문자열로 연결

- 파이썬의 str.join(list)과 동일(파이썬에서 ' '.join([1,2,3,4]))

  ```
  {{ value|join:" // " }} => ['a', 'b', 'c'] 일 경우, "a // b // c"를 출력
  ```



## length filter

- value의 길이를 출력
- 파이썬의 len(value)과 동일
- Undefined 변수일 경우 0을 출력

```
{{ value|length }} => ['a', 'b', 'c', 'd'] 일 경우 4 를 출력
```

왜냐하면 장고 템플릿에서는 인자(,,,)식으로 못넘기니까 이런식으로 넘김



## linebreaks filter

- 빈 줄은 단위로 \<p>태그로 감싸고, 개행1개는 \<br>태그로 출력

```
value = "Joel\nis a slug"
{{ vaule|linebreaks }}
<p>Joel<br/>is a slug</p>
```

## linebreaksbr filter

- 모든 개행을 \<br>태그로 출력

  ```
  value = "Joel\nis a slug"
  {{ vaule|linebreaks }}
  Joel<br/>is a slug
  ```



## ppint filter

- pprint.pprint() 래핑 (어떤변수값 그대로 출력할 목적)
- 디버깅 목적



## random filter

- 지정 리스트에서 랜덤 아이템을 출력

  ```
  {{ value|random }} => ['a', 'b', 'c', 'd'] 일 경우 'b' 출력 가능
  ```

  

## safe filter

- HTML Escaping 이 수행되지 않도록, 문자역을 SafeString으로 변환
- autoescaping이 off로 지정될 경우, 이 필터는 작동하지 않음.

- 어떤 유저가 댓글에 \<br> 을 올릴떄 html태그로작동안하도록 escaping해야하므로 자동임
- 하지만 어떤때는 작동필요할떄 사용하면됨



## slice filter

- 슬라이싱된 리스트를 출력
- 파이썬의 리스트 슬라이싱 문법과 동일

```
{{ some_list|slice:":2" }} => ['a', 'b', 'c']일 경우 ['a', 'b']
```

## striptags filter

- [X]HTML 태그를 모두 제거하지만, non valid HTML 일 경우 제거가 되지 않을 수 있음
- 좀 더 견고한 제거가 필요하다면, bleach 파이썬 라이브러리 (clean 메소드) 출력

```
value = "<b>Joel</b> <button>is</button> a <span>slug</span>"
{{ value|striptags }} => "Joel is a slug".
```



## truncatechars filter, truncatechars_html filter (글자단위)

- truncatechars : 문자열을 지정 글자갯수까지 줄이며, 줄여질 경우 끝 에 "..."를 추가
- truncatechars_html : html태그를 보호하면서, 문자열을 지정 글자 갯수까지 줄이며, 줄여질 경우 끝에 "..."를 추가

```
value1 = "Joel is a slug"
value2 = "<p>Joel is a slug</p>"
{{ value1|truncatechars:9 }} => "Joel i..."
{{ value2|truncatechars_html:9 }} => "<p>Joel i...</p>"
```



## truncatewords filter, truncatewords_html filter

- truncatewords : 문자열을 지정 단어갯수까지 줄이며, 줄여질 경우 끝 에 "..."를 추가
- truncatewords_html : html태그를 보호하면서, 문자열을 지정 단어 갯수까지 줄이며, 줄여질 경우 끝에 "..."를 추가

```
value1 = "Joel is a slug"
value2 = "<p>Joel is a slug</p>"
{{ value1|truncatewords:2 }} => "Joel is ..."
{{ value2|truncatewords_html:2 }} => "<p>Joel is ...</p>"
```



## urlencode filter

- 지정값을 urlencode 처리
- 안전하게 특정변수값을 넘길수있다
- get요청에서 인자를 붙일수있는데 이떄 인자를 안전하게해서 post요청

```
value = "https://www.example.org/foo?a=b&c=d"
{{ value|urlencode }} => "https%3A//www.example.org/foo%3Fa%3Db%26c%3Dd"
```



## urlize filter

- 링크태그 자동으로 생성해줌, URL 문자열과 이메일주소 문자열을 클릭가능한 링크로 변환/출력

- URL일 경우

  - 문자열이 http://, https://, www. 로 시작할 경우 변환
  - 문자열이 도메인만 지정되었을 경우, 최상위 도메인 이 .com, .edu, .gov, .int, .mil, .net, .org 일 경우 변환
  - 생성된 URL에는 rel="nofollow" 속성이 추가

  - https://goo.gl/aia1t 는 변환되나, goo.gl/aia1t 는 변환 불가 

```
value1 = "Check out www.djangoproject.com"
value2 = "Send questions to foo@example.com"

{{ value1|urlize }}
       => "Check out <a href="http://www.djangoproject.com" rel="nofollow">
       www.djangoproject.com
       </a>"
{{ value2|urlize }}
 			=> "Send questions to <a href="mailto:foo@example.com">foo@example.com</a
```



# HTML Form

웹페이지에서는 form 태그를 통해, 데이터를 전송 

ex) 로그인 폼, 댓글 폼 

하나의 form 태그는 하나 이상의 위젯 (Widget)(UI의 구성요소) 을 가진다.

ex) 블로그에서 유저한테 post를 받을때 제목위젯를 만들어 제목입력하게만들고, 위도경도위젯만들어서 지도에서 찍으면 나중에 post할때 결과값 입력됨(커스텀위젯)

```
<form action="" method="POST"> 

# 속성은 3가지 action='url주소'아래값 보냄, method='get or post'방식으로보낼것이냐?, enc

    <input type="text" /> : 1줄 문자열 입력
    <textarea></textarea> : 1줄 이상의 문자열 입력
    <select></select> : 항목 중 택일
    <input type="checkbox" /> : 체크박스 (한 그룹 내 여러 항목을 다수 선택 가능)
    <input type="radio" /> : 라디오박스 (한 그룹 내 여러 항목 중에 하나만 선택 가능)
    그 외 다수 위젯
</form>
```

## HTML Form 태그 필수 속성

- action: 요청을 보낼 주소

- method

  "GET": 주로 데이터 조회 요청시 (html의 헤더만 존재해서 url?='여기에 요청사항씀')

  'POST': 파괴적인 액션(생성/수정/삭제)에 대한 요청 시 (html의 body(내용)에 요청사항씀)

  __tip__: html은 header, body로 구분되는데 header는 포장지라 보면됨 body는 내용물

- enctype: request.POST 요청시에만 유효 (어떤데이터를 어떤방식으로 패키징을 할것이냐!)

  - application/x-www-form-urlencoded (디폴트) \# urlencoded방식, 파일업로드불가
  - multipart/form-data \# 파일 업로드 가능, 주소뒤에못하고, 바디에만 넣을수있다. 따라서 POST 요청시에만 유효
  - ~~text/plain \# 스펙에는 정의되어있으나, 실제로 쓰이지는 않음~~



##url encoded

html에서 name='title'이므로 전달시에는 {'title':'입력값'}형태로 key:value형태로들어감

key=value 값의 쌍이 &문자로 이어진 형태

```
from urllib import urlencode
print(urlencode({'key1': 'value1', 'key2': 10, 'name': '공유'}))
print('공유'.encode('utf8'))
print(''.join('%{:X}'.format(ch) for ch in '공유'.encode('utf8')))

key2=10&key1=value1&name=%EA%B3%B5%EC%9C%A0
#이것을 url뒤에붙이면 get방식, body에 넣으면 post방식

b'\xea\xb3\xb5\xec\x9c\xa0' #'공유'라는 utf8 방식으로바꿈
%EA%B3%B5%EC%9C%A0
```



## Form Method

- GET 방식 : 엽서에 비유. 물건을 보낼 수 없다. (header only임 body없다)

   application/x-www-form-urlencoded 방식으로만 인코딩하여, GET인자로 전달 

-  POST 방식 : 택배에 비유. 다양한 물건을 보낼 수 있다. (H&B둘다감)

  - GET인자/POST인자 가능 

  - 지정된 enctype으로 인코딩하여, body에 포함시켜 처리

    ```
    <form action="?lang=ko" method="post">
        <input type="text" name="title" />
        <textarea name="copntent" />
        <imput type="text" name="latlng" />
    </form>
    #이런식으로 작성하면 get방식이 url주소뒤에 ?다음에 정보를 넣으므로
    똑같은 식으로 들어감,따라서 get방식으로 전송되고 post방식으로도 전송해볼수있음
    ```

 

### \<form method="GET">

- enctype 지정 불가. enctype 지정을 무시하고 urlencoded된 key/value 쌍을 url 뒤에 붙여, GET인자로서 전달
- 주로 검색폼에서 인자를 넘길 때 씀

```
<form method="GET" action="">
   <input type="text" name="title" />  #하나하나가위젯임
   <textarea name="content"></textarea>
   <input type="file" name="photo" /> 
   #file경로선택, 파일명만 전송됨(enctype= urlencoded 이므로 파일 패키징 못하므로 )
   
   <input type="submit" value="저장" />
</form>
```



> 요청의 실제 패킷 살펴보기
>
> ```
> GET http://localhost:8000/blog/new/?title=title&content=content&photo=filename.jpg HTTP/1.1
> # ?다음부터가 GET인자들이 들어감. key:value형태임
> 
> Host: localhost:8000
> User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:39.0) Gecko/20100101 Firefox/39.0
> Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
> Accept-Language: ko-KR,ko;q=0.8,en-US;q=0.5,en;q=0.3
> Accept-Encoding: gzip, deflate
> DNT: 1
> Referer: http://localhost:8000/blog/new/
> Cookie: csrftoken=bDaUcTBk3CxBH3FJ4X9zmQpjWD6swBG7; _ga=GA1.1.2131557215.1432514035; sessionid=fk7l01xhd9nbwlncoidyxb1amzff9yom
> Connection: keep-alive
> 
> (header 만 있고, body 부분이 없음, __header/body구분은 첫 빈줄 하나로 구분__)
> <이후로 바디시작>
> ```
>
> GET인자 title=title&content=content&photo=filename.jpg
>
> ## 장고 View 호출 시, 인자 현황
>
> request.GET :  실행시 <QueryDict: {'title': ['title'], 'content': ['content'], 'photo': ['filename.jpg']}>
>
> request.POST : <QueryDict: {}>
>
> request.FILES : <MultiValueDict: {}>

# \<form method="POST" enctype="application/x-www-form-urlencoded">

- 디폴트 enctype : application/x-www-form-urlencoded 
- urlencoded된 key/value쌍을 request BODY에 담아서 요청

```
<form method="POST" action="">    #위에예시와 POST로만 바뀜
   <input type="text" name="title" />  #하나하나가위젯임
   <textarea name="content"></textarea>
   <input type="file" name="photo" /> 
   #file경로선택, 파일명만 전송됨(enctype= urlencoded 이므로 파일 패키징 못하므로 )
   
   <input type="submit" value="저장" />
</form>
```

> 요청의 실제 패킷 살펴보기
>
> ```
> POST http://localhost:8000/diary/new/ HTTP/1.1
> Host: localhost:8000
> User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:39.0) Gecko/20100101 Firefox/39.0
> Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
> Accept-Language: ko-KR,ko;q=0.8,en-US;q=0.5,en;q=0.3
> Accept-Encoding: gzip, deflate
> DNT: 1
> Referer: http://localhost:8000/diary/new/
> Cookie: csrftoken=bDaUcTBk3CxBH3FJ4X9zmQpjWD6swBG7; _ga=GA1.1.2131557215.1432514035; sessionid=fk7l01xhd9nbwlncoidyxb1amzff9yom
> Connection: keep-alive
> Content-Type: application/x-www-form-urlencoded
> Content-Length: 46
> 
> title=title&content=content&photo=filename.jpg  #Body가 생김!!!!!!
> ```
>
> POST 인자 title=title&content=content&photo=filename.jpg
>
> ## 장고 View 호출 시, 인자 현황
>
> request.GET : <QueryDict: {}>
>
>  request.POST : <QueryDict: {'title': ['title'], 'content': ['content'], 'photo': ['filename.jpg']}>
>
>  request.FILES :  <MultiValueDict: {}>



# \<form method="POST" enctype="multipart/form-data">

- 파일 업로드 지원 (패키징형식다르므로) (GET방식으로하면 무시됨)

  ```
  <form method="POST" action="" enctype="multipart/form-data">
     <input type="text" name="title" />
     <textarea name="content"></textarea>
     <input type="file" name="photo" />
     <input type="submit" value="저장" />
  </form>
  ```

  > 패킹 요청 분석
  >
  > ```
  > POST http://localhost:8000/diary/new/ HTTP/1.1
  > Host: localhost:8000
  > User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:39.0) Gecko/20100101 Firefox/39.0
  > Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
  > Accept-Language: ko-KR,ko;q=0.8,en-US;q=0.5,en;q=0.3
  > Accept-Encoding: gzip, deflate
  > DNT: 1
  > Referer: http://localhost:8000/diary/new/
  > Cookie: csrftoken=bDaUcTBk3CxBH3FJ4X9zmQpjWD6swBG7; _ga=GA1.1.2131557215.1432514035; sessionid=fk7l01xhd9nbwlncoidyxb1amzff9yom
  > Connection: keep-alive
  > Content-Type: multipart/form-data; boundary=---------------------------14973275531370807725960869059
  > Content-Length: 296 #여기까지 헤더
  > 
  > -----------------------------14973275531370807725960869059 #여기부터바디
  > Content-Disposition: form-data; name="title"
  > title
  > -----------------------------14973275531370807725960869059
  > Content-Disposition: form-data; name="content"
  > (생략 ...)
  > ```
  >
  > ### 장고 View 호출시, 인자 현황
  >
  > request.GET :  
  >
  > request.POST : <QueryDict: {'title': ['title'], 'content': ['content']}>
  >
  > request.FILES : <MultiValueDict: {'photo': [<InMemoryUploadedFile: 사진.png (image/png)>]}>

  즉 post, FILES 호출가능 (진짜 파일패키징해서 전송왔음)

  

# Cross-site-request forgery (CSRF)

- 사이트 간 요청 위조 공격

- 사용자가 의도하지 않게 게시판에 글을 작성하거나, 쇼핑을 하게 하는등의 공격

  ```
  <!-- 공격자 사이트의 웹페이지에 접속하면, 그 즉시 site-victim.com에 새글쓰기 요청이
   사용자 모르게 전달됩니다. -->
  <body onload="document.attack_form.submit();">
     <form name="attack_form" method="post"
       			action="http://site-victim.com/blog/post/new/">
       <input type="hidden" name="title" value="스팸 제목" />
       <input type="hidden" name="content" value="스팸 내용" />
     </form>
  </body>
  
  #즉 위에hidden되어있으므로 유저한테 안보이고 JS로 유저모르게 post요청보내질수있다(공격)
  ```



## CSRF를 막기 위해 POST요청에 한해, csrf token 발급 및 체크

- POST요청에 한해 CsrfViewMiddleware를 통해 csrf token을 체크

   체크 오류 시에는 403 Forbidden 응답

   GET요청에서는 csrf token이 불필요

  > Tip: middleware는 url<><><>view 둘 사이에서 호출되는 함수들!! 이중에 CsrfViewMiddleware가 존재

  > Django스타일은 누가 url접속했을때 get으로 폼보여주고 post로 간다 이때 get단계에서 마지막인자로 csrf token발급하고 입력완료누르면 모든입력값데이터 +csrf token이 post요청됨. 이때 csrf token이 유효한 것일경우 이 post요청을 처리하는 뷰함수를 불러옴

  > 누가 POST로만 쏠경우 csrf token값이 없으므로 post요청처리 뷰함수 안부름



```
<form action="" method="post">
     {% csrf_token %}  # <!-- csrf token 발급 : POST요청에서는 필수 !!! -->
     <input type="text" name="title" />
     <textarea name="content"></textarea>
     <input type="submit" />
</form>
```

- csrf_token != 유저인증 Token (아니다!)
- 대개 GET요청은 조회목적, POST요청은 추가/수정/삭제목적으로 사용

## csrf_exempt 장식자

특정 뷰에 한해 csrf token 체크를 해제할려면, csrf_exempt 장식자 적용 

- 기본 제공되는 보안기능이므로, 어쩔 수 없는 경우 (앱 API 기능을 제공 하는 경우) 를 제외하고는 구지 제거하지 말자. 
- 있어도 개발에 전혀 불편하지가 않다

```
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def my_view(request):
    return HttpResponse('Hello world')
```



##  HttpRequest

- 클라이언트부터의 모든 요청 내용을 담고 있으며, 매 요청 시마다 뷰 함 수의 첫번째 인자로 전달

  \# 모든 뷰함수는 첫번째 인지 request임! request는  HttpRequest인스턴스임

  

HttpRequest objects 에서 폼 처리 관련 속성들 

-  request.method : 요청의 종류, 무조건 "GET" 또는 "POST"  \# 장고안에서는 무조건대문자

- request.GET : GET인자, QueryDict 타입 (GET요청/POST요청 시) 

- request.POST : POST인자, QueryDict 타입 (POST요청 시) 

- request.FILES : POST업로드 파일 인자, MultiValueDict 타입

  

Tip: __MultiValueDict__: ~~원래 dic은 동일 key에 여러개 value 안됨.(오버라이딩되서 마지막께남음)

동일 key의 다수 value를 지원하는 사전 URL의 Query String은 같은 Key로서 다수 Value지정을 지원 

url/?name=Tom&name=Steve&name=Tomi  \# 가능



Tip:__QueryDict__: 수정 불가능한(Immutable) MultiValueDict

> ###MultiValueDict(dict)
>
> ```
> # 동일 key
> 의 다수 value
> 를 지원하는 사전
> >>> from django.utils.datastructures import MultiValueDict
> >>> d = MultiValueDict({'name': ['Adrian', 'Simon'], 'position': ['Developer']})
> >>> d['name']     #이렇게만하면 dic과 차이없음
> 'Simon'
> >>> d.getlist('name')    #key하나에 values다 불러옴
> ['Adrian', 'Simon']
> >>> d.getlist('doesnotexist')   #없는key값임
> []
> >>> d['name'] = 'changed' #오버라이딩, 기존value사라짐
> >>> d
> <MultiValueDict: {'name': ['changed'], 'position': ['Developer']}>
> 
> ```
>
> ### QueryDict(MultiValueDict)
>
> ```
> # 수정 불가능한 (Immutable) MultiValueDict
> # 아래 코드는 Django Shell
> 을 통해서 실행이 가능
> # 수정할려면 clone만들어서해야함 원본은 수정불가
> 
> >>> from django.http import QueryDict
> >>> qd = QueryDict('name=Adrian&name=Simon&position=Developer', encoding='utf8')
> >>> qd['name']
> 'Simon'
> >>> qd.getlist('name')
> ['Adrian', 'Simon']
> >>> qd['name'] = 'changed'
> AttributeError: This QueryDict instance is immutable #수정불가
> ```
>
> 

## HttpResponse (인스턴스!)

- 뷰 함수의 리턴값으로서 HttpResponse의 인스턴스를 기대 - Feat.Middleware가 중간에서 HttpResponse를 기대하므로.

```
# view.py

def post_list(request):   #request를 받으면 리턴값은 HttpResponse인스턴스여야함
    ~~~~~~~~~~~생략~~~~~~~~
    response = render(request, 'blog/post_list.html', {'post_list':qs, 'q': q,})
    #HttpResponse인스턴스인데 render를 통해서 좀더 쉽게 탬플릿을 통한 렌더링
    return response #HttpResponse인스턴스임
```

- 여러 Helper 함수를 통해 손쉽게 HttpResponse 인스턴스 생성 (django.shortcuts.render, django.shortcuts.redirect, django.http.JsonResponse 등)

  ```
  from django.http import Http404, HttpResponse
  #HttpResponse 직접만들기가 귀찮
  
  def post_list(request):
       return HttpResponse('''
       <!doctype html>
       <html>
       <head>
       </head>
       <body>
       <h1> django</h1>
       </body>
       </html>
       ''')
       
       
  #이렇게 보단 템플릿 작성해서 render하자
  #  어느주소로 이동은 redirecgt쓰자
  #JsonResponse 으로 주면 Json으로 응답가능 (HttpResponse에 JsonResponse들어가있음)
  
  ```




# Form

- 장고 유용한 기능
- Model클래스와 유사하게 Form클래스를 정의 (모델이 DB랑 상호작용하듯 프론트엔드와 Form클래스가 상호작용.)
- 주요 역할: 커스텀 Form클래스를 통해.,,,
  - 입력폼 HTML 생성 : .as_table(), .as_p(), .as_ul() 기본제공 
  - __입력폼 값 검증(validation) 및 값 변환__ (프론트엔드)
  - 검증을 통과한 값들을 __사전타입__(cleaned_data이름으로 제공)

## 장고 반드시 이해해야하는 작동원리(마지막보기)

![스크린샷 2019-11-08 오전 11.15.51](https://tva1.sinaimg.cn/large/006y8mN6gy1g8qexr07i4j31h20t87wh.jpg)

\# 아래는 뷰 파일인듯. 명확한이해필요! 

```
def post_new(request):
    if request.method == 'POST':
        form = PostForm(request.POST, request.FILES)
        if form.is_valid():
            post = Post(**self.cleaned_data)
            pst.save()
            return redirect(post)
            
    else:
        form = PostForm()
    return render(request, 'blog/post_form.html', {
        'form': form,
    })
```





## 단계별 구현

### Django Style

폼 처리 시에 같은 URL(즉 같은 뷰)에서 GET/POST로 나눠 처리

- GET방식으로 요청될 떄: 입력폼을 보여줍니다.
- POST방식으로 요청될 때
  - 데이터를 입력받아 유효성 검증 과정을 거칩니다.
  - 검증 성공 시: 해당 데이터를 저장하고 SUCCESS URL로 이동
  - 검증 실패 시: 오류메세지와 함께 입력폼을 다시 보여줍니다.

__Step 1)__ : Form 클래스 정의: 앱에서 forms.py에 

                ```
# myapp/forms.py
from django import forms
class PostForm(forms.Form):
     title = forms.CharField()
     content = forms.CharField(widget=form.Textarea)
                ```

\# 이떄 왜 models에서는 content가 TextField 이냐? 글자수제있는것과 없는것 구별하기위해 , 하지만 Form에서는 글자수 제한없다 그래서. 둘다 그냥 forms.CharField써라

\# widget을 써서 같은 필드타입이지만 사용자가 보는 위젯이 여러줄로 보임



__Step 2)__ :  필드 별로 유효성 검사 함수 추가 적용

validator는 함수단위로 구현하고 항상 value값을 받는다.

```
#myapp/froms.py (myapp이 앱이름에 디렉토리)
from django import forms

def min_length_3_validator(value):
     if len(value) < 3:
          raise forms.ValidationError('3글자 이상 입력해주세요.')
          
# myapp/forms.py (myapp이 앱이름에 디렉토리)
from django import forms 

class PostForm(forms.Form):
     title = forms.CharField(validators=[min_length_3_validator])
     content = forms.CharField(widget=form.Textarea)
     
     #validator함수를 리스트형태로 받아서 변수에 넣음. > 이는 유저로부터 입력받은 title값을 validators(value)의 value값으로 받음. 그래서 위에 value의 len값을 검사가능
```



__Step 3)__ :  View함수 내에서 Form 인스턴스 생성

 GET요청을 통해 View 함수가 호출이 될 때, GET/POST 요청을 구분해서 Form 인스턴스 생성 

```
# myapp/views.py
from .forms import PostForm
if request.method == 'POST':
 # POST 요청일 때
       form = PostForm(request.POST, request.FILES)
else:
 # GET 요청일 때
       form = PostForm()
```







__Step 4)__ : POST요청에 한해 입력값 유효성 검증

```
# myapp/views.py
if request.method == 'POST':
 # POST인자는 request.POST와 request.FILES를 제공받음. 이걸 PostForm 인스턴스만듬
       form = PostForm(request.POST, request.FILES)
 # 인자로 받은 값에 대해서, 유효성 검증 수행
   if form.is_valid(): # 검증이 성공하면, True 리턴
       # 검증에 성공한 값들을 사전타입으로 제공받음.
       # 검증에 성공한 값을 제공받으면, Django Form의 역할은 여기까지 !!!
       # 필요에 따라, 이 값을 DB에 저장하기
       form.cleaned_data
       post = Post(**form.cleaned_data) # DB에 저장하기
       post.save()
       return redirect('/success_url/')
 		else: # 검증에 실패하면, form.errors와 form.각필드.errors 에 오류정보를 저장
         form.errors
else:
			 form = PostForm()
return render(request, 'myapp/form.html', {'form': form})
```











__Step 5)__ :  템플릿을 통해 HTML폼 생성

GET요청이거나 POST요청이지만 유효성 검증에서 실패했을 때 

Form 인스턴스를 통해 HTML폼 출력 오류메세지도 있다면 같이 출력

\# 폼인스턴스를 html폼으로 출력하는데 보통쓰는 것

```
<table>
     <form action="" method="post">
             {% csrf_token %}
             <table>{{ form.as_table }}</table> #이게 오류를 불러와줌, Form에 각 필드가 테이블 행으로  렌더링됨!!!
             <input type="submit" />
     </form>
</table>
```



__Step 6)__ : 

검증을 통과한 값들을 __사전타입__(cleaned_data이름으로 제공)

Model.py에 값을 저장할떄는  4가지 방법

View.py에서 

```
def post_new(request):
	if request.method == 'POST':
		form = PostForm(request.POST, request.FILES) # NOTE: 인자 순서주의 POST, FILES
		if form.is_valid(): # form의 모든 validators 호출 유효성 검증 수행
		# 검증에 성공한 값들은 사전타입으로 제공 (form.cleaned_data)
		# 검증에 실패시 form.error 에 오류 정보를 저장
		'''
		# 저장방법1) - 가장 일반적인 방법
		post = Post()
		post.title = form.cleaned_data['title']
		post.content = form.cleaned_data['content']
		post.save()

		# 저장방법2)
		post = Post(title = form.cleaned_data['title'],
					content = form.cleaned_data['content'])
		post.save()

		# 저장방법3)
		post = Post.objects.create(title = form.cleaned_data['title'],
									content = form.cleaned_data['content'])

		# 저장방법4)
		post = Post.objects.create(**form.cleaned_data) # unpack 을 통해 방법3과 같이 저장
		'''

		# 저장방법5)
		post = form.save() # PostForm 클래스에 정의된 save() 메소드 호출
		return redirect(post) # Model 클래스에 정의된 get_absolute_url() 메소드 호출
	else:
		form = PostForm()
		return render(request, 'dojo/post_form.html',{
		'form': form, 	# 검증에 실패시 form.error 에 오류 정보를 저장하여 함께 렌더링
		})
```







유저가 입력폼에 내용을 채우고 전송(submit)을 하면 해당 URL로 POST요청으로 전달하여 다시 유효성 검증 수행





이제 post = form.save() 로 저장되게 만들고싶다

form.py 에 PostForm클래스에 함수를 만들자

```
def save(self, commit=True):
post = Post(**form.cleaned_data)
    if commit:
       post.save()
    return post
    
    #이러한 방식은 차후에 설명

```





## Form Fields

- Model Fields 와 유사 
  - Model Fields : Database Field 들을 파이썬 클래스화 
  - Form Fields : HTML Form Field 들을 파이썬 클래스화

- {% raw %} BooleanField, CharField, ChoiceField, DateField, DateTimeField, EmailField, FileField, ImageField, FloatField, IntegerField, RegexField 등 {% endraw %}

--------

# 여기까지 잠깐 요약정리(Model과 Form)

__model은 DB를 쉽게 만질수있는 것이다.__

model 수정이 끝나면 해당 앱에 admin.py에 @admin.register(모델의 함수이름)

pass 해주고 보여줄때의 조건등을 설정하고싶으면 바로아래에 class PostAdmin(admin.ModelAdmin): 을 사용하여 list_dispaly, actions등을 사용할수있다.

해당앱의 app_name = 'blog'아래에 urlpatterns에 path('', view.post_detail, name='post_detail')를 하면 나중에 url을 부르고싶을때 html에서 \<a href=""{% url "blog:post_detail" post.id %}"> \</a>만 써주면 부르는 링크 연결가능. (post.id인자까지 넘길수있다.) (템플릿에서 url호출)

즉 model에서는 DB에 저장하는 방식을 담는것, view에서는 model들을 이용한 연산, render를 통해 필요한 인자들 템플릿에 넘기면서 htmlResponse타입으로 리턴, url은 해당 뷰의 함수를 불러냄

__Form은 프론트엔드를 쉽게 만질 수 있도록 도와주는것__

해당앱디렉토리안에 forms.py를 만들고 폼도 model처럼 클래스를 만들고 안에 각 속성을 만든다. 이떄 이속성에 ()안에 추가로 검사, 위젯등을 선택해서 유저한테 보여줄수있다.(폼클래스안에 save()함수도 만드는것추천..), 그리고 검사하는 함수는 이 forms.py안에 정의해준다.

validator(value)라고 항상 value값을 검사하는데 이것은 아래예시를 통해설명

```
class PostForm(forms.Form):
    title = forms.CharField(validators=[min_length_3_validator])
    content = forms.CharField(widget=forms.Textarea) #위젯띄움.
```

위에서 validators가 뒤에 validator함수로 value라는 이름으로 인자를 전달하므로!

그니까 검사도 title입력값이 들어올때 실행된다.

url이 뷰의 함수를 불러오는데 이때 if request.method == "POST": 를 지정하고 else를 쓰면 GET과 POST를 구별해서 각자 실행가능,.

```
def post_new(request):
   if request.method == "POST":
       form = PostForm(request.POST, request.FILES) #인자넘김. #실패시에는 오류이유가 여기담김.
       if form.is_valid():    #유효성이 검사 통과안되면 맨아래 return일어남
                              # 검증에 실패시 form.error 에 오류 정보를 저장
                              # 검증에 성공한 값들은 사전타입으로 제공 (form.cleaned_data)
           post = Post()
           post.title = form.cleaned_data['title']
           post.content = form.cleaned_data['content']
           post.save()
           return redirect('/dojo/')

   else:   #이게 GET요청일때 실행되는것임
       form = PostForm() 
       pass
   return render(request, 'dojo/post_form.html', {
       'form': form,
   })

```

과정을 요약하면 form에서 데이터위젯, 검사등등 하는걸 짜놓고  get이 처음이므로 form= PostForm()이므로 이게 랜더링되어서 템플릿에 담겨서 처음 유저에게 보여진다. 여기에서 

유저는 폼을 채우고 제출하면 POST로 요청되고 csrf검사후 관련뷰 함수호출되고 form.is_valid까지 통과하면 저장하고 다른url로 이동,  오류면 오류 메세지를 띄우고 다시 폼을 노출 (이때 form변수는 오류를 담고있음)





# ModelForm

- Django Form Base

- 지정된 Model로부터 필드정보를 읽어들여, form fields를 세팅

  (위에 예시처럼 직접 필드를 지정하지말고 모델에서필드를 가져와서 구성하면간편)

  ```
  class PostForm(forms.ModelForm):
   class Meta:
         model = Post
         fields = '__all__' # 전체 필드 지정. 혹은 list로 읽어올 필드명 지정가능
  ```

  

- 구성완료하면 Form과 똑같이 동작한다

- 추가기능임) 내부적으로 model instance를 유지

- 추가기능임)  {% raw %} 유효성 검증에 통과한 값들로, 지정 model instance로의  저장(save)를 지원(create or update) {% endraw %}

```
class PostForm(forms.ModelForm):
    class Mega:
        model = Post
        (#fields = '__all__' 이것도 가능)
        fields = ['title', 'content'] # 지정해서 가져옴
        
        
 #이렇게 상속받으면 당연히 validator함수는 models.py에서 쓰자! 정의도옮기고
 #이렇게 모델폼을 상속받으면 self.instance.save()같은 내부적 model instance사용가능
```



## Form Vs ModelForm

```
from django import forms
from .models import Post

class PostForm(forms.Form):
     title = forms.CharField()
     content = forms.CharField(widget=forms.Textarea)
     
# 생성되는 Form Field는 PostForm과 거의 동일 
class PostModelForm(forms.ModelForm):
     class Meta:
         model = Post #모델클래스 이름쓰자
         fields = ['title', 'content']  #모델폼 쓰자 알아서해줌
```



## ModelForm.save(commit=True)

(commit=True여야 DB에 저장 시도 가능)

- Form의 cleaned_data를 Model Instance 생성에 사용하고, 그 Instance를 리턴 

- commit=True : model instance의 save() 를 호출 

  - form.save() != instance.save()  \# form.save()내에서 instance.save()할지말지 정하는 것이기때문에 둘은 다름!

  - ModelForm을 이용하면 알아서 모델의 인스턴스 (post)를 불러와 post.save()실행함

    ```
    #commit=false 예시
    
    if form.is_valid():
          post = form.save(commit=False) #이때 DB에 바로저장안함
          post.ip = request.META['REMOTE_ADDR'] #ip가져오는방법
          post.save() #이때 모조리 저장함
          return redirect('/dojo/')
    ```

    

- commit=False 
  
  - instance.save() 함수 호출을 지연시키고자할 때 사용(나중에 내가따로해줄떄)



## [당부의 말] Form을 끝까지 써주세요.

'''
request.POST 데이터가 form clean함수를 통해 변경되었을 수도 있습니다.
'''

번호데이터를 모두 0100000000로 바꿀수도있다

```
class CommentForm(forms.Form):
     def clean_message(self):
           return self.cleaned_data.get('message', '').strip() # 좌우 공백제거


# ---
form = CommentForm(request.POST)
if form.is_valid():
       # request.POST : 폼 인스턴스 초기 데이터
       message = request.POST['message'] # request.POST를 통한 접근 : BAD !!!
       comment = Comment(message=message)
       comment.save()
       return redirect(post)
      form = CommentForm(request.POST)
if form.is_valid():
       # form.cleaned_data : 폼 인스턴스 내에서 clean함수를 통해 변환되었을 수도 있을 데이터
       message = form.cleaned_data['message'] # form.cleaned_data를 통한 접근 : GOOD !!! #is_valid를 통과한 데이터임
       comment = Comment(message=message)
       comment.save()
       return redirect(post)
```





## ModelForm을 활용한 Model Instance 수정 뷰

__ModelForm을 활용한 post_new뷰와 비교하여, ModelForm 인스턴스 생성 시에 instance 인자로서 Model Instance를 지정해주는 차이 뿐.__

def post_edit(request, id):

   post= get_object_or_404(Post, id=id)

 		나머지 PostModelForm(instance=post만추가해주면)  \# 변경해주는 수정프로그램완성

```
def post_edit(request, id):
     post = get_object_or_404(Post, id=id)
     
     if request.method == 'POST':
         form = PostModelForm(request.POST, request.FILES, instance=post)
           if form.is_valid():
         			  post = form.save()
                return redirect(post)
     else:
    			 form = PostModelForm(instance=post)
     return render(request, 'myapp/post_form.html', {
    			 'form': form,
  	 })
```







#  Form Validation (is_valid()사용)

- Form 인스턴스를 통해 유효성 검사가 수행되는 시점

  

```
def post_new(request):
 if request.method == 'POST':
 form = PostForm(request.POST, request.FILES)
 if form.is_valid(): # 유효성 검사가 수행됩니다.
 form.save()
 else:
 form = PostForm()
```

- 유효성 검사 호출 로직

  ```
  + form.is_valid() 호출
     - form.full_clean() 호출
         - 필드별 유효성 검사 수행하여, 필드별 에러 체크
           - 특정필드.clean()를 통해Form/Model에 Field validators 수행
           - form.clean_특정필드() #form클래스내에 이 맴버함수도 실행
         - form.clean() 호출하여, 다수 필드에 대한 에러 체크
     - 에러가 있었다면 False를 리턴하고 없었다면 True를 리턴
  ```

  

## Form 에서 제공하는 2가지 유효성 검사

- 1) validator 함수를 통한 유효성 검사 

  - 값이 원하는 조건에 맞지 않을 때, ValidationError 예외를 발생 
  - 리턴값을 쓰지 않음 

- 2) Form 클래스 내 clean 멤버함수를 통한 __유효성 검사 및 값 변경__

  - 값이 원하는 조건에 맞지 않을 때, ValidationError 예외를 발생 

  - 리턴값을 통해 값 변환

    ```
    class CommentForm(forms.Form): 
    (생략)
    		def clean_message(self):
    				return self.cleaned_data.get('message', '').strip()
    # 좌우 공백제거
    ```

    

## Tip: ValidationError예외가 발생되면

```
# django/forms/forms.py
  class BaseForm:
     def _clean_fields(self):
       for name, field in self.fields.items():
         # 중략
         try:
             if  isinstance(field, FileField):
                 initial = self.get_initial_for_field(field, name)
                 value = field.clean(value, initial)
                 
             else:
                 value = field.clean(value)
                 
             self.cleaned_data[name] = value #값 갱신하는 부분!
                 
             if  hasattr(self, 'clean_%s' % name):  
             #self는 현재 폼인스턴스, 클린_필드명 attribute(속성)이 존재하면 실행됨 
                 value = getattr(self, 'clean_%s' % name)() #해당맴버를 호출함
                 self.cleaned_data[name] = value #위에 맴버함수 리턴값으로 갱신
          except ValidationError as e:
          self.add_error(name, e) #self가 현재 폼 인스턴스죠!, add_error라는 맴버함수를 통해서 어떤필드에 어떤 에러가 발생했는지 기록함
          
          
```

## validators

-  유효성 검사를 수행할 값 인자를 1개받는 Callable Object(호출가능한 객체, 보통함수)
- 값이 원하는 조건에 안 맞으면 ValidationError 예외를 발생시켜야함 •
  - ValidationError 예외 발생 시, 해당 필드에 대한 오류로서 분류

- 리턴값은 무시됨 
- 함수 validator는 snake_case, 클래스 validator는 CamelCase
  - 클래스 validator의 인스턴스는 함수처럼 호출가능(\__call\_\_사용해서)



### case1) Model Field정의 시에 validators인자 지원

\# 모델폼을 쓰는이유 model에만  추가해놓으면 form에도 같이 적용되서 편함



```
# myapp/validators.py
import re
from django.forms import ValidationError

def phone_number_validator(value):
   if not re.match(r'^010[1-9]\d{7}$'):
       raise ValidationError('{} is not an phone number'.format(value))
       
       
# myapp/models.py
from django.db import models
from .validators import phone_number_validator


class Profile(models.Model):

 '''validators 인자로 phone_number_validator validator 적용
 Model Field validators는 후에 ModelForm을 통해 사용될 수 있습니다.'''
 
 phone_number = models.CharField(validators=[phone_number_validator])
```



### 기본제공  validators

- RegexValidator #ref : 지정 정규표현식에 부합하는 문자열인지 
- EmailValidator #ref : 이메일주소 문자열이 맞는 지 
- URLValidator #ref : URL문자열이 맞는 지 
- MaxValueValidator #ref : 지정값보다 작거나 같은 지 
- MinValueValidator #ref : 지정값보다 크거나 같은 지 
- MaxLengthValidator #ref : 지정길이보다 짧거나 같은 지 
- MinLengthValidator #ref : 지정길이보다 길거나 같은 지
- validate_email #ref : EmailValidator 인스턴스 
- validate_slug #ref : RegexValidator 인스턴스 
- validate_unicode_slug #ref : RegexValidator 인스턴스 
- validate_ipv4_address #ref : RegexValidator 인스턴스 
- validate_ipv6_address #ref : RegexValidator 인스턴스
- validate_ipv46_address #ref 
- validate_comma_separated_integer_list #ref : RegexValidator 인스턴스
- int_list_validator #ref : RegexValidator 인스턴스

### 모델필드에 적용되어있는 디폴트 validators

- models.EmailField #src : CharField상속 + validate_email
- models.URLField #src : CharField상속 + URLValidator() 
- models.GenericIPAddressField #src : ip_address_validators 
- models.SlugField #src : CharField상속 + validate_slug 혹은 validate_unicode_slug



### 클래스 Validator의 인스턴스는 Callable Object(호출가능객체!!)

- 클래스 \__init\_\_으로 자동실행되고 \_\_call\_\_ 은 클래스 인스턴스()하면 함수처럼 쓸수있게하는것
- 클래스의 인스턴스를 함수처럼 쓰는 방법

```
'클래스 validator의 인스턴스는 함수처럼 호출하여 유효성 검사 수행'
phone_number_validator = RegexValidator(r'^010[1-9]\d{7}$')
phone_number_validator('01012341234')
'''
클래스에서 __call__멤버함수를 구현하여, 인스턴스를 호출문법으로 호출
'''
# myapp/validators.py
import re
from django import forms

class SimpleRegexValidator:
   '클래스 Validator 컨셉 구현'
   def __init__(self, pattern):
         self.pattern = pattern
   def __call__(self, value):
         if not re.match(self.pattern, value):
             raise forms.ValidationError('invalid pattern')

# myapp/models.py
from django.db import models
from .validators import SimpleRegexValidator

class Profile(models.Model):
     phone_number = models.CharField(max_length=11, validators=[SimpleRegexValidator(r'^010[1-9]\d{7}$')])
```



## Form clean 멤버함수

- 2가지 유형의 clean 멤버함수에게 다음 역할을 기대 

  1. "필드별 Error 기록" 혹은 "NON 필드 Error 기록" (NON필드는 두가지필드 이상의  필드 가르킴)

     - 값이 조건에 안 맞으면 ValidationError 예외를 통해 오류 기록

     - 혹은 add_error(필드명, 오류내용) 함수호출을 통해 오류 기록

  2. 원하는 포맷으로 값 변경  (form clean멤버함수만 지원함 )
     - 리턴값을 통해 값 변경 지원



- 1. "clean_필드명" 멤버함수 : 특정 필드 별 검사/변경
     -  ValidationError 예외 발생 시, 해당 필드 Error로 분류
  2.  "clean" 멤버함수 : 다수 필드에 대한 검사/변경 
     -  ValidationError 예외 발생 시, non_field_errors로 분류
     -  add_error함수를 통해 필드별 Error기록도 가능



## 언제 validators를 쓰고, 언제 clean을 쓸까요?

- 가급적이면 모든 validators는 모델에 정의하시고, ModelForm을 통해 모델의 validators정보도 같이 가져오세요. (재사용성)
- clean은 언제 쓰나요? (다른곳에서는 안쓸때))(값변경필요할때)
  1. 특정 Form에서 1회성 유효성 검사 루틴이 필요할 때
  2. 다수 필드값을 묶어서, 유효성 검사가 필요할 때 (게임서버 3개일때 서버별로 같은이름가능, )
  3. 필드 값을 변경할 필요가 있을 때 : validator를 통해서는 값을 변경할 수 없어요. 단지 값의 조건만 체크할 뿐

예시(게임서버2개이상인데 각서버마다 이름유니크해야함)

```
#clean 버전
# myapp/models.py
  class GameUser(models.Model):
       server = models.CharField(max_length=10)
       username = models.CharField(max_length=20)
       
# myapp/forms.py
class GameUserSignupForm(forms.ModelForm):
   class Meta:
       model = GameUser
       fields = ['server', 'username']
   def clean_username(self):
       'username 필드값의좌/우 공백을 제거하고, 최소 3글자 이상 입력되었는지 체크'
        username = self.cleaned_data.get('username', '').strip()
         if username:
           if len(username) <3:
               raise forms.ValidationError('3글자 이상 입력해주세요.')
               #이 리턴값으로 self.cleaned_data['username'] 값이 변경됩니다.
               #좌/우 공백이 제거된 (strip) username으로 변경됩니다.
         return username

   def clean(self):
       cleaned_data = super().clean()
       if self.check_exist(cleaned_data['server'], cleaned_data['username']):
       # clean내 ValidationError는 non_field_errors 로서 노출
         raise forms.ValidationError('서버에 이미 등록된 username입니다.')
       return cleaned_data
   def check_exist(self, server, username):
       return GameUser.objects.filter(server=server, username=username).exists()
```

\# 간결하게  clean 덜쓰고 데이터쪽에서 validators및  unique검사

```
from django.core.validators import MinLengthValidator
class GameUser(models.Model):
         server = models.CharField(max_length=10)
         username = models.CharField(max_length=20, validators=[MinLengthValidator(3)])
         
         class Meta:  #모델에서 지원하는기능으로 server, username값을 이은게 유니크한지 검사
         unique_together = [
         ('server', 'username'),    
         ]
         
# 아래는 모델폼.
class GameUserSignupForm(forms.ModelForm):
     class Meta:
         model = GameUser
         fields = ['server', 'username']
     def clean_username(self):
           '값 변환은 clean함수에서만 가능합니다. validator에서는 지원하지 않습니다.'
           return self.cleaned_data.get('username', '').strip()
```

## form.add_error(필드명, 예외/오류내용)

- ValidationError 예외 발생 외에도 form.add_error를 통해 오류기록 지원 
- add_error에 지정된 필드는 self.cleaned_data에서 자동제외 #src 
- __ValidationError는 예외로서 처리되기 때문에 오류기록 시점에 clean 함수가 종료되지만, add_error는 함수호출이기 때문에 clean함수가 이어서 계속 실행이 된다.__



# Form Template Custom Render

## 시작하기전에

다음 Model/Form 코드 기반으로 다양한 Form Render 를 수행해보겠습니다.



```
# myapp/models.py
from django.db import models
class Post(models.Model):
     title = models.CharField(max_length=100)
     content = models.TextField()
     user_agent = models.CharField(max_length=200)
     
# myapp/forms.py
from django import forms
from .models import Post
class PostForm(forms.ModelForm):
     class Meta:
           model = Post
           fields = ['title', 'content']
           widgets = {
           # JavaScript로 브라우저 UserAgent정보를 담을 것이기에, 구지 UI에 노출할 필요가 없음, 각 필드에대한 위젯를 새로 지정가능! 알기!!
           'user_agent': forms.HiddenInput, # user_agent 필드 위젯 변경
           }
```

## 한땀한땀 직접 HTML 마크업하기 

### level 1- 필드별로 하나하나 지정해 서 렌더링 

재활용 불가능함, 자유로움. 

```
{% raw %}

<form action="" method="post">

<legend>Post Form</legend>
 {% csrf_token %}
 {% for error in form.non_field_errors %} <!-- non 필드 errors 목록 노출 -->
 {{ error }}
 {% endfor %}
 {{ form.user_agent }} <!-- 위젯 렌더링 -->

<table>

<tr>

<td>{{ form.title.label_tag }}</td>

<td>
 {{ form.title }} <!-- 위젯 렌더링 -->
 {{ form.title.help_text }} <!-- help_text 노출 -->
 {% for error in form.title.errors %} <!-- title errors 목록 노출 ->
 {{ erorr }}
 {% endfor %}
 </td>
 </tr>

<tr>

<td>{{ form.content.label_tag }}</td>

<td>
 {{ form.content }}
 {{ form.content.help_text }}
 {% for error in form.content.errors %}
 {{ error }}
 {% endfor %}
 </td>
 </tr>
 </table>

<input type="submit" />
</form>
<script>
/* 자바스크립트로 user_agent 필드값 채워넣기 */
var dom = document.getElementById('{{ form.user_agent.id_for_label }}');
dom.value = navigator.userAgent;
</script>

{% endraw %}
```

## #Level 2 - 일괄적으로 렌더링 (비추 )

일괄적으로 렌더링되므로 Hidden속성은의 태그이름이 보이게됨(비추)

```
{% raw %}
<form action="" method="post">

<legend>Post Form</legend>
 {% csrf_token %}
 {% for error in form.non_field_errors %}
 {{ error }}
 {% endfor %}
 <!--
 visible/hidden fields 모두
한 스타일로 렌더링
 hidden fields
에 대해서도 label_tag/help_text
가 출력되기 때문에 비추
 -->

<table>
 {% for field in form %}

<tr>

<td>{{ field.label_tag }}</td>

<td>
 {{ field }}
 {{ field.help_text }}
 {% for error in field.errors %}
 {{ error }}
 {% endfor %}
 </td>
 </tr>
 {% endfor %}
 </table>

<input type="submit" />
</form\>
<script>
var dom = document.getElementById('{{ form.user_agent.id_for_label }}');
dom.value = navigator.userAgent;
</script>

{% endraw %}
```

### 템플릿 Level 3 - visible/hidden 필드를 구분하여 렌더링 (추천 )

필드. 속성 구별해서 for 돌수있다 

재사용또한 쉽다

```
{% raw %}

<form action="" method="post">

<legend>Post Form</legend>
 {% csrf_token %}
 {% for error in form.non_field_errors %}
 {{ error }}
 {% endfor %}
 <!-- hidden fields
는 위젯만 렌더링 -->
 {% for field in form.hidden_fields %}
 {{ field }}
 {% endfor %}
 <!-- visible fields
는 모든 요소 렌더링 -->

<table>
 {% for field in form.visible_fields %}

<tr>

<td>{{ field.label_tag }}</td>

<td>
 {{ field }}
 {{ field.help_text }}
 {% for error in field.errors %}
 {{ error }}
 {% endfor %}
 </td>
 </tr>
 {% endfor %}
 </table>

<input type="submit" />
</form>
<script>
var dom = document.getElementById('{{ form.user_agent.id_for_label }}');
dom.value = navigator.userAgent;
</script>

{% endraw %}
```





### Level 4 - bootstrap3 스타일

Level3를정리한것 부트스트랩3스타일로

(생략..)

```
{% raw %}
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootswatch/3.3.7/journal/bootstrap.min.css" />
    <script src="//code.jquery.com/jquery-2.2.4.min.js"></script>
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h1>Post Form</h1>

                <table>  <form action="" method="POST" class="form-horizontal">
                {%  csrf_token %}
                    <table class="table table-hover table-bordered">



                        {% for error in form.non_field_errors %}}

                            <div class=""alert alert-danger">
                        {{ error }}

                        {% endfor %}

                    {%  for field in form.hidden_fields %}
                       {{ field }}
                    {%  endfor %}

                    {%  for field in form.visible_fields %}
                       <div class="form-group">
                       {{  field.label_tag }}
                       <div class="'col-sm-10">
                           {{ field }}
                           {% if field.help_text %}
                           <p class="help-block">{{  field.help_text }} </p>
                           {% endif %}
                           {% for error in field.errors %}
                               <div class=""alert alert-danger">
                               {{ error }}
                               </div>


                           {%  endfor %}

                       </div>

                    {% endfor %}



            </div>


                        <input type="submit" class="btn btn-primary" />
            </div>
        </div>
    </div>



    </form>

<script>
$(function()
{
 $('.form-group label').addClass('col-sm-2');
 $('.form-group input, .form-group textarea').addClass('form-control');
});
var dom = document.getElementById('{{ form.user_agent.id_for_label }}');
dom.value = navigator.userAgent;
</script>

{% endraw %}
```

현재까지코드



## django-bootstrap3 팩키지

- bootstrap3 스타일로 HTML을 생성해주는 template tags 제공 설치 쉘>

  ``` 
   pip3 install django-bootstrap3
  settings.INSTALLED_APPS 에 "bootstrap3" 
  ```

(개발과정에서 사용)

```
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

 즉 위에 예시들을 간단히 바꿀수있다(개발과정에서 사용)

```
{% raw %}
{% load bootstrap3 %}

{% bootstrap_css %}
{% bootstrap_javascript  %}

<form action="" method="post">
    {%  csrf_token %}
    {% bootstrap_form form %}    
    <input type="'submit" class="btn btn-primary" />
</form>


<script>
$(function()
    var dom = document.getElementById('{{ form.user_agent.id_for_label }}');
    dom.value = navigator.userAgent;
</script>

{% endraw %}
```


