---
title: whereMyPost
date: 2020-01-08 15:17:08
categories: Project
tags: [Project, Crawling]
---

# whereMyPost

## 만든이유

- 택배를 조회할 때 우리는 항상 네이버, 다음, 해당 택배 홈페이지를 들어가서 번호를 입력하게된다

  이것을 카카오톡api를 사용하여 플러스 친구로 만들어 놓는다면 얼마나 편할까?

## 구현할 기능(중요도 순)

- 택배사 선택후 운송장 번호 입력하면 택배 정보가 뜨는 (url로 안내함 or return값 전부 보여주던가)
- 사용자가 조회 한번 햇던 운송장 번호와 택배사를 저장해놓고 바로 다시조회할수있도록구현

# Realize

## 각 택배사 api사용(실패)

[cj대한통운](https://www.cjlogistics.com/ko/tool/parcel/tracking) 을 기준으로 input한 데이터들을 처리하는 방식을 분석하고 똑같이

localhost:8000에서 구현시도

```
DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>whereMyPost</title>
</head>
<body>

<div class="number-box">
    <input type="text" id="paramInvcNo" name="paramInvcNo" value="운송장 번호 입력해주세요" style="width:353px;" maxlength="12">
    <input type="submit" id="btnSubmit" title="Search">
</div>
"363219681522"
{{ post }}

<script
  src="https://code.jquery.com/jquery-1.12.4.js"
  integrity="sha256-Qw82+bXyGq6MydymqBxNPYTaUXXq7c8v3CwiYwLLNXU="
  crossorigin="anonymous"></script>
<script src="https://www.cjlogistics.com/static/pc/global/template/js/jquery-migrate-1.4.1.min.js"></script>
<script src="https://www.cjlogistics.com/static/pc/global/template/js/front.js?v=2020010811"></script>
<script src="https://www.cjlogistics.com/static/pc/global/template/js/string.js"></script>
<script src="https://www.cjlogistics.com/static/pc/global/template/js/common.js?v=2020010811"></script>

	<!-- //공통 : js -->
   	<script type="text/javascript">
		var GLOBAL_SESSION_ID = "anonymousUser";
		var GLOBAL_CSRF_NAME = "_csrf";
		var GLOBAL_CSRF_VALUE = "1d119052-7262-401c-8fec-9f102beca2cb";
		var GLOBAL_UPLOAD_URL = "/cjlwupload/";
		var GLOBAL_DOMAIN_KOREAN = "";
		var GLOBAL_DOMAIN_ENGLISH = "";
	</script>

</body>


<script>
			$('#btnSubmit').on('click', function (e) {
				fncValidate();
			});


			function fncValidate() {
                var paramInvcNo = $('#paramInvcNo').val();
                console.log(paramInvcNo)


                $.ajax({
                    url: 'https://www.cjlogistics.com/ko/tool/parcel/tracking-detail',
                    type: 'GET',
                    dataType: 'jsonp',
                    data: GLOBAL_CSRF_NAME + '=' + GLOBAL_CSRF_VALUE + '&paramInvcNo=' + paramInvcNo,
                    timeout: 1000,
                    async: false,

                    })
                    .done(function (json) {
                        console.log(json)
                    })
                    .fail(function (xhr, status, error) {
                        console.log(error)
                    })
                    .always(function (xhr, status) {
                        console.log("요청은 완료됨")

                    });
            };





```





### 오류 발생

```
tracking-detail:1 Failed to load resource: the server responded with a status of 405 (Method Not Allowed)
```

### 실패 원인

- CORS (???)

  ajax로 요청시 같은 도메인이 아닐시 거부됨

  이를 해결하기 위해 json대신 jsonp의 형식을 지원해줘야하는데

  이는 오픈해주시는 api 가 지원안해주시면 소용없다. (???)

- 오픈api가 아니면 현재 실력으로 뚫기 어렵다고 판단.

## Crawling으로 구현(1차 시도)

### 설치 및 기본 요령([블로그참조](https://beomi.github.io/gb-crawling/posts/2017-02-27-HowToMakeWebCrawler-With-Selenium.html))

```
# 뷰에 쓰는 크롤링함수 모았음
from selenium import webdriver
from selenium.webdriver.support.select import Select
from bs4 import BeautifulSoup

driver = webdriver.Chrome('../chromedriver')
driver.implicitly_wait(15)
driver.get('https://search.naver.com/search.naver?sm=top_hty&fbm=1&ie=utf8&query=%ED%83%9D%EB%B0%B0%EC%A1%B0%ED%9A%8C')


#select클래스를 이용하여 쉽게 요소들중에서 찾을수있다.
select = Select(driver.find_element_by_class_name('_select'))

# select by visible text
select.select_by_visible_text('CJ대한통운')

# select by value
driver.find_element_by_id('numb').send_keys('349159576510')

driver.find_element_by_xpath('//*[@id="_doorToDoor"]/div[1]/div[2]/input[2]').click()

html = driver.page_source
soup = BeautifulSoup(html, 'html.parser')
post_detail = soup.select('#_doorToDoor > div._output > div.artb > table > tbody > tr')


post_list = []

for x in post_detail:
    post_list.append(x.text.strip())

print(post_list)
```

### 실패 원인

자동화 프로그램을 네이버가 걸려서 애초에 조회가 불가능하게만듬,



## Crawling으로 구현(2차 시도)

각 택배사 홈페이지에 따라 크롤링하는 방법을 선택

맨 처음으로 CJ대한통운으로 선택,





