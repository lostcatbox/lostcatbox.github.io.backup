---
title: Html/Css
date: 2020-07-01 18:27:28
categories: [Html/Css]
tags: [Network,Html,Css,Front-End,Basic]
---

[자세히](http://webberstudy.com/)

[html, xml차이](https://www.crocus.co.kr/1493)

[html이 어떻게동작, DOM](https://wit.nts-corp.com/2019/02/14/5522)

[html, DOM 차이]([https://velog.io/@godori/DOM%EC%9D%B4%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80](https://velog.io/@godori/DOM이란-무엇인가))

# HTML

## 요소(Element)와 속성(Attribute)

예시에서 img요소에 src, alt 속성을 추가되었다.

```html
<tag> {{내용}} </tag>  #열리는 태그. 닫히는 태그
<img/> #스스로 닫는 태그, 안에 담을 내용이 없기때문
<img src="http://webberstudy.com/attach/html-1/sample.png" alt="샘플 이미지" /> #예시
```

예시에서는 a요소에서 href속성을 추가한다면 텍스트클릭시 해당페이지로 이동

(href=Hyper Reference, src=source)

```html
<a href="http://webberstudy.com">웨버스터디 홈으로 가기</a>
```



> 태그와 요소를 혼동하여 사용할때가있다
>
> 정확한 개념은
>
> 태그는 `<tag>` ,` </tag>`,` <tag/>` 각각이 태그이다
>
> 요소는 `<tag> {{내용}} </tag>` 전체가 tag요소이다

> 절대주소, 상대주소
>
> 절대주소는 http://~~ 전체주소를 다 적는 방식
>
> 상대 주소는 해당 파일을 기준으로 주소를 찾는것
>
> - 예시에서는 abc.css와 해당 html의 위치가 같은 폴더 안에 있다
>
>   하위 폴더에있다면 속성값은 "폴더/abc.css"
>
>   상위 폴더에 있다면 속성값은 "../abc.css"
>
>   최상위폴더에서부터 시작 속성값은 "/"
>
> - 파일위치가 바뀌는 오류날수있는 상대주소의 단점이며, 피하고싶다면 최상위폴더에서부터 작성하는것도 좋다
>
> ```html
> <link href="abc.css" type="text/css" rel="stylesheet" />
> ```

## head 요소

html태그안에는 head와 body로 나뉨

### Doctype

 HTML문서의 맨 처음에 명시하는 부분으로 문서의 버전의 관한 정보를 나타냄

```html
<!doctype HTML> # HTML5라는 것을 명시함
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> #XHTML 1.0독타입
```

### head 요소의 역할

head요소의 정의는 문서의 메타데이터(웹 페이지에 직접적으로 보이지 않는 정보) 집합이다. js,css파일 연결, 이 페이지의 제목, 검색엔진 노출여부, 등등

### head 내 위치하는 요소들

-  title

```html
<title>문서의 제목</title> #브라우저 창 제목이나 페이지탭,검색에도 활용됨
```

- meta  요소

  메타에서 담을 수 있는 종류는 여러 종류가 있으며, 페이스북이나 트위터 등에서 요구하는 임의의 메타정보들도 있다.

```html
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> # 예시에서는 현재 페이지의 인코딩에 관한 정보를 담는다, 브라우저가 이 메타를 일고 글자를 올바르게 랜더링한다. 

<meta name="Description" content="소개 내용" /> #예시2는 디스크립션 메타이며 현재 페이지에 대한 설명을 담고 있으며, 이 정보는 주로 검색엔진이 확인한다, 160자 이내권장

<meta name="robots" content="noindex, nofollow" /> #
이 메타는 이 페이지를 검색엔진이 수집을 할 지 안 할지를 정하는 정보입니다. 위와 같이 content 값을 'noindex, nofollow'로 줄 경우, 검색엔진은 여러분의 페이지를 색인 하지 않습니다.
```

- link, style, script 요소

  ```html
  <link href="style.css" type="text/css" rel="stylesheet" /> #css파일 연결, 나머지 속성은 css에관한것들
  
  <style type="text/css">
    body{
      color:#333;
    }
  </style>  #css파일하지않고 바로 html 에서 스타일 적용
  
  <script type="text/javascript" src="abc.js"> </script>  # js파일 연결
  
  
  <script type="text/javascript">
    //script Text
  </script>  #js 바로 html에서 작성
  ```

## 블록과 인라인

body요소는 크게 블로요소와 인라인 요소로 나눈다.

반드시알아야할것

블록 요소안에는 인라인, 블록 모두 포함가능하지만

인라인 요소 안에는 인라인만 가능하다



### 블록 요소

블록 요소는 일단 __기본적으로 줄 바꿈이 일어나는 형태로 영역의 너비가 상위 영역의 전체 너비만큼 되는 형태입니다.__ 이 블록 요소에 들어가는 요소들로는 h1~6 요소, p 요소, div 등이 있습니다. 이게 글 만으로는 언뜻 이해되지 않을 것 같은데요, 아래 예제를 보도록 하겠습니다.

```html
<h1>블록 요소</h1>
<p>p 요소는 블록 형태입니다.</p>
<div>div 역시 블록 형태입니다.</div>
```

### 인라인 요소

요소는 블록 요소와 반대되는 형태로 줄 바꿈이 일어나지 않는 요소들 입니다. 인라인 형태의 요소들로는 a, img, strong, span 요소 등이 있습니다. 다음의 예제를 보시죠.

```html
<strong>이 요소는 strong 요소 입니다.</strong>
<a href="">링크가 있는 a 요소 역시 인라인 형태입니다.</a>
<span>이것은 span 요소입니다.</span>
```



























일단, __아이디(id)는 페이지에서 딱 한번만 선언 가능합니다.__ 어떤 한 요소에서 'main-menu'라는 아이디 명을 사용한다면, 페이지 내 다른 요소들은 절대로 'main-menu'라는 아이디를 사용할 수 없습니다. 그래야 a 요소로 해당 아이디 요소에 이동이 가능합니다.

반면, __클래스는 여러 번 사용이 가능합니다.__ 그렇기 때문에 클래스는 이름을 좀 더 범용적으로 짓고, 아이디는 이름을 좀 더 특수하게 짓습니다. 예를 들어 다음의 코드를 봐주세요, 소설의 장을(Chapter) 작성했습니다

DOM개념 중요 <<반드시 찾아서 정리하기 (???)

class="btn btn-primary"는 두개 DOM을 가지고있는 것을 일치판단후 스타일적용해주는 것

```html
<div class="class-wrap">
      <div class="top-info">
        <div class="video-box">
          <iframe src="{{value}}" width="560" height="315" frameborder="0" allow="autoplay;fullscreen" allowfullscreen style="border-radius: 10px"></iframe>
        </div>
        <div class="cnts">
          <div class="c-name">{{value}}</div>
          <h2>{{value}}</h2>
          <p>{{value}}</p>
          <div class="data-list">
            <h3>{{value}}</h3>
            <p><button onclick=window.open('{{value}}')>{{value}}</button></p>
          </div>
```



# CSS

## CSS

```css
.class-wrap {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 16px
}

.class-wrap .top-info .cnts .c-name {
  font-size: 18px;
  font-weight: bold;
  color: #bbb
}

.class-wrap .top-info .cnts h2 {
  color: #111
}

.class-wrap .top-info .cnts .in-review {
  margin-top: 15px
}

.class-wrap .top-info .cnts ul.d-list {
  border-top: 1px solid #ddd
}

.class-wrap .top-info .cnts>p {
  flex: 1 0 auto;
  margin-top: 30px;
  font-size: 14px;
  font-family: "NotoSans-Light", "Roboto", "Droid Sans", "Malgun Gothic", "Helvetica", "Apple-Gothic", "애플고딕", "Tahoma", dotum, "돋움", gulim, "굴림", sans-serif
}

.class-wrap .top-info .cnts .data-list h3 {
  font-size: 14px
}

.class-wrap .top-info .cnts .data-list h3:before {
  content: '';
  display: inline-block;
  width: 20px;
  height: 20px;
  margin-right: 12px;
  vertical-align: middle;
  background: url("../images/icon_detail.png") no-repeat -90px -1px
}

.class-wrap .top-info .cnts .data-list p {
  margin-top: 8px;
  font-size: 16px
}


```



## SCSS

```scss
.class-wrap {
	@include inlay;
	.top-info {
		.cnts {
			.c-name {
				font: {
					size: 18px;
					weight: bold;
				}
				color: #bbb;
			}
			h2 {
				color: #111;
			}
			.in-review {
				margin-top: 15px;
			}
			ul.d-list {
				border-top: 1px solid #ddd;
			}
			> p {
				flex: 1 0 auto;
				margin-top: 30px;
				font: {
					size: 14px;
					family: $font-thin;
				}
			}
			.data-list {
				h3 {
					font-size: 14px;
					&:before {
						content: '';
						display: inline-block;
						width: 20px;
						height: 20px;
						margin-right: 12px;
						vertical-align: middle;
						background: url('../images/icon_detail.png') no-repeat -90px -1px;
					}
				}
				p {
					margin-top: 8px;
					font-size: 16px;
				}
			}
			.btn-apply {
				text-align: center;
				a {
					display: inline-block;
					background-color: $color-point;
					color: #fff;
					font-weight: bold;
				}
			}
		}
	}
	@include respond-to(pc) {
		.top-info {
			display: flex;
			.video-box {
				flex: 1;
				margin-right: 50px;
			}
			.cnts {
				display: flex;
				flex-direction: column;
				position: relative;
				width: 31%;
				padding: 30px 35px;
				border: 1px solid #e0e0e0;
				border-radius: 10px;
				box-sizing: border-box;
				h2 {
					margin-top: 14px;
					font-size: 22px;
					line-height: 28px;
				}
				.btn-apply {
					text-align: center;
					a {
						width: 253px;
						height: 53px;
						font-size: 20px;
						line-height: 56px;
					}
				}
			}
		}
	}

```

# JS

$는 jquery를 의미한다.







# 참고 사이트

[html](http://webberstudy.com/html-css/html-1/div-span-and-class-attr/)

