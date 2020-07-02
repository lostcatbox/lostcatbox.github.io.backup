---
title: Html/Css/Js
date: 2020-07-01 18:27:28
categories: [Html]
tags: [Network,Html, Basic]
---

[자세히](http://webberstudy.com/)

# HTML 

## 요소와 속성

```html
<tag> {{내용}} </tag>  #열리는 태그. 닫히는 태그
<img/> #스스로 닫는 태그, 안에 담을 내용이 없기때문
<img src="http://webberstudy.com/attach/html-1/sample.png" alt="샘플 이미지" /> #예시
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

