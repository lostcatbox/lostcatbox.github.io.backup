---
title: Markdown 기본사용법
date: 2019-10-20 15:01:55
tags: Markdown
categories: Markdown
---

# #따라오시기 전 <br>

--------

- 마크업 언어의 한 종류.
- 헥소의 [Tag Plugins 문서](https://hexo.io/ko/docs/tag-plugins.html) 참조.
- [블로그 참조](https://tbr74.github.io/2017/07/09/Study-Hexo-2017-07-09-hexo-markdown/)
-명령어 뒤에 띄어쓰기를 해야 명령으로 인식합니다
-직접 해보면서 따라오세요

---------

# 머리글
--------------
```
markdown
# text
## text2
### text3
#### text4
##### text5
```
__(박스아래에는 실행결과를 표시해드립니다)__

# text
## text2
### text3
#### text4
##### text5
(5개이상부터는 4개와 같은 것을 볼 수 있습니다)

-------
# 링크
------

```
{% raw %}
[텍스트](http주소) << 텍스트만 보임
<http주소> <<주소가 보이고 클릭하면 이동
[![텍스트](이미지경로.jpg or 이미지주소)](http주소) << 이미지만 보이고 클릭하면 이동
{% endraw %}
```

[고양이](http://img.hani.co.kr/imgdb/resize/2018/0313/00500561_20180313.JPG)
<http://img.hani.co.kr/imgdb/resize/2018/0313/00500561_20180313.JPG>
[![고양이](http://img.hani.co.kr/imgdb/resize/2018/0313/00500561_20180313.JPG)](https://www.google.com/)
~~(맨마지막은 사진뷰어가 실행될것이다... 블로거 현재 테마가 뷰어로 불러오는거라.. 가볍게무시해주자)~~


코드 블럭
-------
이것은 '```'뒤에 언어를 명시하면 해당 언어의 문법에 맞게 하이라이트를 해준다.
(참고로 맥북을 쓸때 저거대신 ₩가 나오면 정상.. 옵션키누르면서 눌러보자!)

```
​```language // python, bash
`3개 시작하는곳 옆에 적어넣으면된다!
```
```
python
for cat in cats
    return "고양이"
```
------
# 검정색 백그라운드
-------
```
<pre> ~~ </pre>
```
<pre> 고양이 개좋아~!
</pre>
(태그속성이므로 꼭 마지막에 닫아주는 </~~> 필요)

------
# 글자효과들
------
```
**catissosweet**, __catissosweet__ (굵게, 강조)
*catissosweet*, _catissosweet_ (기울여)
~~catissosweet~~ (취소선)
<u> ~~ </u> (밑줄)
**cat_is_so**_sweet_ (응용)
```
**catissosweet**, __catissosweet__ (굵게, 강조)
*catissosweet*, _catissosweet_ (기울여)
~~catissosweet~~ (취소선)
<u> ~~ </u> (밑줄)
**cat_is_so**_sweet_ (응용)

-----
# 수평선
-----

```
-------, *********** (여러개면 됨)
```

------
******
-----
# 줄바꿈
----
```
고양이<br>좋아
```

고양이<br>좋아

-----
# 리스트
------
```
1. cat
2. is
3. so
4. sweet
```
1. cat
2. is
3. so
4. sweet
------
# tables
-----
표라고 생각하자
```
|cat|is|so|sweet|
|:-:|:-:|:-:|:-:|
|고양이|하다|존나|달콤한|
```

|cat|is|so|sweet|
|:-:|:-:|:-:|:-:|
|고양이|하다|존나|달콤한|

-----
# Youtube 링크
-----
```
{% raw %}
{% youtube video_id %}
아래는 예시 코드
{% youtube LVpmk8v7s2c %}
{% endraw %}
```

{% youtube LVpmk8v7s2c %}

-----
# 참조. hexo 초안작성법
-----
```
{% raw %}
$ hexo new draft [파일명]  <<초안 생성됨
$ hexo publish [파일명] <<초안을 포스트로 옮기기
$ hexo server --draft <<원래 초안은 로컬에서 안보이지만 보이게해주는 명령어
{% endraw %}
```


