---
title: HTML Render vs Parse
date: 2020-07-15 12:11:51
categories: [Html]
tags: [Html, English, Basic]
---

>  영어 공부 때문에 어순이 영어 기준으로 되어있습니다
>
> 원본사이트는 자세히를 눌러 보실수있습니다

# Render vs Parse

[자세히](https://dev.to/saurabhdaware/html-parsing-and-rendering-here-s-what-happens-when-you-type-url-and-press-enter-3b2o)

![스크린샷 2020-07-15 오후 1.08.53](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggrj3rpcjsj313c0guwgg.jpg)

 ## HTML 파싱과 렌더링: 당신이 URL을 type하고 엔터를 누를때 여기에 무엇이 일어나는지 있다

안녕! 나는 쓰고있다 한 시리즈의 기사들 웹 실행 핵s라고 불리는 그리고 이것은 될것이다 첫번째 기사 이 시리즈들로부터

이 기사는 목적으로한다 보여주것이다 어떻게 브라우저가 parse render하다  HTML 과 CSS을 이것은 결국 도와주다 우리를 이해하는 과정에서 어떻게 우리가 요술을 부리다 브라우저가 개선하다 parser가 웹 성능에

### TLDR

- 파싱과 렌더링은 바꾸다 HTML 내용을 웹페이지로 색깔과 배경과 그림을 함께
- HTML Parsing: HTML Text>tokenization>DOM Tree
- CSS Parsing: CSS Text>tokenization>CSSOM Tree
- DOM and CSSOM 합병된다 형성하는 것 Render Tree 
- Render Tree 가지다 모든 정보 요구된 마크와 페인트 스크린을하는것에
- Render Tree >Layout>Paint
- Layout은 하다 수학 위치시키는것을 위해 요소들을
- Paint 색칠하다 그 요소들을 색깔, 바탕, 그림자 등등으로

좋아

처음으로, 보자 무엇이 얼어나는지를 할때 당신이 치다 URL 그리고 엔터 눌렀을때

### 어떻게 브라우저가 동작하는가

우리는 URL를 치고 엔터 누르고 서버가 응답하다 index.html로

그러나, HTML  내용은 아니다 우리가 볼 수 있는 것이 할때 우리가 웹사이트를 방문할때

우리는 웹페이지를 본다 색깔과 배경과 애니메이션과 사진들과 함께

그래서 거기에는 과정이있다 전환하다 HTML 내용을 예쁜 웹사이트로, 그리고 그것은 parsing과 rendering이다

### HTML Parsing

그래서 우리는 HTML 내용을 가지고있다 시작단계에서 지나가다 한 과정을 tokenization이라 불려오는, tokenization은 흔한 과정이다 거의 모든 프로그래밍 언어에서 코드가  분할되는곳 몇몇의 토큰으로 이해하는것을 쉽게 하는 parsing하는동안. 이것은 어디이다 HTML's parser가 이해하다 무엇이 시작이고 무엇이 태그의 끝이고, 어떤 태그가 그것이고, 무엇이 태그안에 있는지

현재 우리는 알다, html tag 시작하다 위에서 그리고 헤드 태그는 시작하다 html 끝나기 전에 그래서 우리는  알아낼수이다. 헤드는 있다 html안에 그리고 만들다  트리를 헤드가끝남. 그러므로 우리는 어떤 것을 얻을수있다  parse tree라는 불려오는 그것은 결국에 되다 DOM tree가 마치 보여지는것 아래 그림처럼

![스크린샷 2020-07-15 오후 2.20.30](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggrl623kcrj311q0lc447.jpg) 

DOM tree 는 무엇이다 우리가 접근하다 우리가 하다 `document.getElementById` or `document.querySelector` in JavaScript.

HTML와 같이, CSS는 지나치다 비슷한 과정 어디에서 우리가 가지다 CSS text 와 그리고  tokenization CSS의  최종적으로 만들기위해서 어떤것 불려지는 a CSSOM or CSS Object Model

이것은 무엇이다 CSS Object Model 처럼 보이는것이다.

![스크린샷 2020-07-15 오후 2.24.40](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggrlad6nhdj311k0kqq82.jpg)

놀랍다. 이제 우리는 가지다 DOM과 CSSOM 그래서 우리는 모든 정보를 얻었다 요구되는것들 우리 스프린를 페인트하는 것을 얻기위한

### Rendering of Web Page

렌더링을 위해서,  DOM 과 CSSOM들은 합병되다 어떤것을 형성하기위해 불리워지는 a Render Tree. Render Tree 갖는다 정보를 요구되는 표시와 페인트하는것 요소들을 스크린에서

![스크린샷 2020-07-15 오후 2.30.09](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggrlg2aa5sj31180l0wmi.jpg)

또한 a Render Tree를 형성하는 동안, 요소들( `<head>`, `<link>`, `<script>`)와 요소들( 'display: none' in CSS) 들은 무시된다 때문에 그들은 렌더링되지 않기 때문에 스크린에서

에 주목하라 요소들이 'opacity:0' or 'visibility: none'와 함께 포함된다 render tree 에, ~조차도 그들이 페인트되지는 않는다 스크린

그들은 그들의 위치를 가져와 render한다 빈공간으로서 그리고 그러므로 그들은 요구된다 계산에서

그래서 이제 우리는 render tree를 얻었다 모든 정보를 가진 페이지를 만들때 필요한. 이제 renderer는 사용하다 이 정보를 Layout과 Paint을 만들기 위해, 우리는 이야기할 것이다 Layout과 Paint에 대해 다음 포인트에서 

그 전에 여기는 ~이다. 전체적인 과정 이 보여지는

![스크린샷 2020-07-15 오후 1.08.53](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggrj3rpcjsj313c0guwgg.jpg)

### Layout

layout은 어디이다 요소들이 표시되는 곳이다 화면에서. 그 layout은 모든 계산들과 수학들을 포함하다, 요소들의 위치뒤에서 그래서 그것은 모든 속성을 이용하다 관련된 위치에 (세로, 가로, 위치, ....)  Render Tree로부터 그리고 위치시키다 요소들을 스크린에

### Paint

Layout이후에 Paint가 일어난다. Paint는 이용하다 속성들 (color, background-color, border-color, box-shadow, etc.) 색으로 스크린을 페인팅하기위해서

Paint과정후에, 우리는 볼수있다 내용을 스크린에서 그리고 처음 시간 우리가 어떤것을 본다 백색화면에서 다른 것을 은 불러진다 'First Paint'. 그 First Paint기간은 사용되어진다 실행에서 보고하다 보여주는것을 얼마나 길게 당신 웹사이트가 취하다 어떤것을 보여주는 것을 스크린에

### 잡았다

이제, 몇가지 중요한 포인트가 있다 주목해야할 전체과정에서 parsing 과 rendering의

파싱과정이 멈추다  `<link>`, `<script>`, and `<style>` tag를 만났을때

그래서 만약 나는 \<script src="path/to/script"\>\</script\>를 HTML 미들에 가지고잇다면, Parser 는 거기에서 멈추다, 그 스크립트를 가져오고, 응답을 기다리고, 그것을 실행하고, 그리고 나서 그것을 계속하다 파싱과정.

이것은 이유다 우리가 \<script\>  를 놓다 body마지막에, ~를 위해 우리가 완성하다 파싱과정를 먼저

비슷한 일이 발상한다 언제, 우리가 \<link rel="stylesheet" href="path/to/css" /\> 를 놓았을때. 

Parser는 CSS를 가져오다 그리고 확실하게 하다 CSSOM가 준비가 되도록 ~전에 스크린에 내용을 놓는것

이것은 이유다 우리가 볼수없다 그것의 a flash of CSSless content  ~전에 페이지가 로드되다 대신에 우리가 보다 내용을 ~와 함께 그것의 CSS가 로드된, 적용된상태로

~조차도 내가 말했다 parsing은 멈추다  link, script태그를 만났을때, 거기에는 방법들이 있다 그것을 피할수있는 사용하는것`async` and `defer` on the `<script>` tag and `rel="preload"` on `<link>`