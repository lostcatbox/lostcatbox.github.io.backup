---
title: front-end-prac3
date: 2019-12-22 13:05:14
categories: Frontend
tags: [Frontend, Django, Ajax]
---

#  Ajax with Django #3

## 코드 구현

- STEP #1) Detail 페이지에서 댓글 쓰기
- STEP #2) validation 에러가 발생한다면?
- STEP #3) Post Detail 댓글창에 Ajax 숨결을 ~
- STEP #4) Bootstrap4 Modal을 통한 댓글 쓰기
- STEP #5) Bootstrap4 Modal을 통한 댓글 수정
- STEP #6) MEDIA 프로젝트 셋팅
- STEP #7) 댓글 Ajax 파일 업로드
- STEP #8) 댓글 목록에 이미지를 노출시켜봅시다

## 댓글 Ajax 쓰기

### STEP #1) Detail 페이지에서 댓글 쓰기

아직은 JavaScript를 사용하지 않아요.

Tip: 클래스에 오버라이드 할경우 ctrl+o누르면 뭐가 가능한지 알려줌

- 기존 댓글쓰기는
  - comment_new:GET 요청 시에 : 빈 Comment Form HTML을 보여주 고, 댓글을 써서 comment_new에서 POST요청을 받도록 함. 
  - comment_new:POST 요청 시에 : 받은 POST 데이터를 통해 Form 처리 
- 지금 바꿔볼 내용은
  - post_detail뷰:GET 에서 빈 Comment Form HTM

기존 CommentCreateView/CommentUpdateView CBV에서는 Form Class를 지정하지 않고, 내부적으로 자동생성토록 했었음. 

그런데, PostDetailView에서 Comment Form 노출을 위해서는 CommentForm 이 필요.

```
# blog/forms.py
from django import forms
from .models import Comment
class CommentForm(forms.ModelForm):
     class Meta:
         model = Comment
         fields = ['message']

# blog/views.py
from .forms import CommentForm

class PostDetailView(DetailView):
     model = Post
     # 중략
     def get_context_data(self, **kwargs):
         context = super().get_context_data(**kwargs)
         context['comment_form'] = CommentForm() # 빈 CommentForm을 만들기만 할 뿐, 입력된 데이터는 CommentCreateView에서 처리, 빈 모델폼인자 생성후 넘기는과정
         return context
         
class CommentCreateView(CreateView):
     model = Comment
     # fields = ['message'] # 제거하고, form_class 지정
     form_class = CommentForm
     # 생략

class CommentUpdateView(UpdateView):
     model = Comment
     # fields = ['message'] # 제거하고, form_class 지정
     form_class = CommentForm
     # 생략
```

```
# blog/templates/blog/post_detail.html

{% load bootstrap3 %}
<!-- 중략 -->
<form id="comment-form" action="{% url "blog:comment_new" post.pk %}" method="post"> // 아주중요!!! 지금까지는 post를 같은 url로 보내서 같은 view cbv에서 처리했었음, 하지만 action에 url를 지정하여 post요청을 다른 곳으로 보내서 다른 view cbv가 처리가능
     {% csrf_token %}
     {% bootstrap_form comment_form %}
     <input type="submit" class="btn btn-primary btn-block" value="댓글쓰기" />
</form>
아래 링크는 제거

{# <a href="{% url "blog:comment_new" post.pk %}" class="btn btn-primary btn-block">댓글쓰기</a> #} {# 장고 탬플릿 주석문법 #}
```

__이제 Post Detail 화면에 댓글을 쓸 수 있어요__



### STEP #2) validation 에러가 발생한다면?

에러 발생을 위해 Form 클래스에 validator를 추가했습니다.

```
import re
from django import forms
from .models import Comment

class CommentForm(forms.ModelForm):
     class Meta:
         model = Comment
         fields = ['message']
         
     def clean_message(self):
         message = self.cleaned_data.get('message', None)
         if message:
             if not re.search(r'[ㄱ-힣]', message):
		             raise forms.ValidationError('메세지에 한글이 필요합니다.')
         return message
```

- /pk/comments/new/ 주소에서 에러가 발생합니다.
- 그런데, 매번 스크롤이 TOP에 위치해있어요. :( 좀 더 개선해보죠.
  - 즉 댓글을 쓰고나면 url로 다시 이동되어 scroll에 top으로 다시 돌아감.

### STEP #3) Post Detail 댓글창에 Ajax 숨결을 ~

댓글을 입력하는 창 넘어가는것 자체는 그냥 전부 detail에서 해버리면 전환없이 그대로일듯





```
# blog/views.py
class CommentCreateView(CreateView):
     model = Comment
     form_class = CommentForm
     def form_valid(self, form):
     comment = form.save(commit=False)
     comment.post = get_object_or_404(Post, pk=self.kwargs['post_pk'])
     response = super().form_valid(form)
     if self.request.is_ajax():  #ajax요청일때는 jsonresponse로 응답!
         return JsonResponse({
             'id': comment.id,
             'message': comment.message,
             'updated_at': comment.updated_at,
             'edit_url': resolve_url('blog:comment_edit', comment.post.pk, comment.pk),
             'delete_url': resolve_url('blog:comment_delete', comment.post.pk, comment.pk),
             }) //js단에서 url reverse를 할수없으니까 같이 넘겨줘야됨!
     return response
     
     def form_invalid(self, form):  # ajax로 valid아닐때도 ajax로 응답
         if self.request.is_ajax():
                 return JsonResponse(dict(form.errors, is_success=False)) #사전형태로 응답, js에서 is_success를 보고 내가 처리기준으로둘것이다
              return super().form_invalid(form)

     def get_success_url(self):
     		return resolve_url(self.object.post)
```



```
# blog/templates/blog/post_detail.html

<script>
$(function() {
 		$('#comment-form').submit(function(e) {
 				e.preventDefault();
         var $form = $(this);   //this는 현재 폼 요소를 지징함>>jquery객체로만듬
         var url = $form.attr('action');  //attr중에 action에는 어디로보낼지 경로 담겨있는것을 가져옴
         var data = $form.serialize();  //csrfmiddlewaretoken과 message를 담고있는 url encoded된 문자열을 반환해줌
         
         $.post(url, data)  //ajax로 post함! 클래스뷰에서 판단가능
 						.done(function(obj) {   //post해서 응답받은것을 아직 전체 레이아웃이 포함된 html을 받음,
                 if ( obj.is_success === false ) {
                 		alert(obj.message);
                 }
                 else {
                 		console.log(obj);
                 		
                     $('#comment-list').prepend([
                         '<li id="comment-' + obj.id + '">',
                             obj.message,
                             '&dash;',
                             '<a href="' + obj.edit_url + '">',
                             		'<small>' + obj.updated_at + '</small>',
                             '</a>',
                            '<a href="' + obj.delete_url + '" class="ajax-post-confirm" data-target-id="comment-' + obj.id + '" data-message="정말 삭제하시겠습니까?">',
                             		'<small>삭제</small>',
                             '</a>',
                         '</li>'
                 ].join(''));
                 
                 $form[0].reset(); //현재form에 0번째 js에 reset()씀 즉,form에있는 내용들 삭제해줌.
                 }
             })
             .fail(function(xhr, textStatus, error) {
                 console.log("fail");
                 alert('failed : ' + error);
             });
     });
});
</script>
```

하지만 이렇게 js로 모두 짜는건 현실적으로 힘듬



#### Underscorejs Template으로 변경

bower.json 에 추가

```
{
     "name": "askdjango",
     "dependencies": {
         "jquery": "~3.2.1",
         "bootstrap": "~3.3.7",
         "underscore": "~1.8.3"
     } 
 }
```

#### 레이아웃 템플릿에 추가

````
<script src="{% static "jquery/dist/jquery.min.js" %}"></script>
<script src="{% static "bootstrap/dist/js/bootstrap.min.js" %}"></script>
<script src="{% static "jquery.csrf.js" %}"></script>
<script src="{% static "underscore/underscore-min.js" %}"></script>
````

#### underscore.js 템플릿 정의

```
#blog/templates/post_detail.html
<script type="text/x-template" id="comment-template">
     <li id="comment-<%= id %>">  //underscroe변수 정의방법
         <%= message %>
         &dash;
         <a href="<%= edit_url %>">
		         <small><%= updated_at %></small>
         </a>
         
         <a href="<%= delete_url %>"
             class="ajax-post-confirm"
             data-target-id="comment-<%= id %>"
             data-message="정말 삭제하시겠습니까?">
             		<small>삭제</small>
         </a>
     </li>
</script>

```

#### submit 콜백에서 underscore.js 템플릿 활용 

```
<script>
$(function(){
     var raw_template = $('#comment-template').html();  // 코멘트 템플릿에있는문자열을 모두 가져옴
     var tpl = _.template(raw_template);  //이걸로 underscrore 템플릿생성
		 $('#comment-form').submit(function(e){
 			  e.preventDefault();
 					
         var $form = $(this);
         var url = $form.attr('action');
         var data = $form.serialize();
         
         $.post(url, data)
             .done(function(obj){
                 if ( obj.is_success === false ) {
                    alert(obj.message);
                 }
                 else {
                     console.log(obj);
                     $('#comment-list').prepend(tpl(obj));
                     $form[0].reset();
                 }
             })
				     .fail(function(xhr, textStatus, error){
										console.log("fail");
										alert('failed : ' + error);
 					 	});
		 });
 // 생략
});
</script>
```



#### submit 버튼 중복 클릭을 막아봅시다.

submit ajax 요청처리시간이 길어질 경우, 유저는 submit 버튼을 여러 번 누를 수 있습니다. 이때 유저가 누 른 수만큼 ajax 요청이 추가로 전달되게 됩니다. 

```
js에서 함수를 딜레이 주는 방법 
setTimeout(function() { 함수넣기
}, 3000);
```



submit 요청을 처리 중에는 submit 버튼을 비활성화하여, 이를 방지할 수 있습니다.

아래 코드 추가해주기

```
#blog/templates/post_detail.html
$('#comment-form').submit(function(e) {
     e.preventDefault();
     var $form = $(this);
     var $submit = $form.find('[type=submit]');
     
     $submit.prop('disabled', true); // post요청 전에 , form에 type=submit들이 disabled로서 기능못하게막음, prop는 선택한 한곳 의 script의 속성값 추가
     
     // 중략
     
     .always(function () {
                $submit.prop('disabled', false);
                }) //post요청이 끝나고 나서, 항상 다시 기능가능하게만듬
});
```



### STEP #4) Bootstrap4 Modal을 통한 댓글 쓰기

요즘은 json으로 백엔드에서 응답해주고 그것을 js로 처리하지만 

서버 응답은 JSON이 아닌 HTML로 처리해보겠습니다. (JavaScript는 Ajax요청에만 최소화)

comment-form JSON 관련 JavaScript/뷰 코드 모두 제거하고, Ajax 요청에 대한 응답 시에는 템플릿에서 레이아웃을 제거

```
# blog/views.py
class CommentCreateView(CreateView):
     model = Comment
     form_class = CommentForm
     
     def form_valid(self, form):
         comment = form.save(commit=False)
         comment.post = get_object_or_404(Post, pk=self.kwargs['post_pk'])
         response = super().form_valid(form)
         
         if self.request.is_ajax(): # render_to_response가 호출되지 않습니다.
             return render(self.request, 'blog/_comment.html', {
             		'comment': comment,
             })
             
             
         return response
         
         
     def get_success_url(self):
    		 return resolve_url(self.object.post)
    		 
     def get_template_names(self):
         if self.request.is_ajax():
         		return ['blog/_comment_form.html']  //우리가 추가할 폼
         return ['blog/comment_form.html']  //원래 쓰던 폼
```

```
# blog/templates/blog/_comment_form.html

{% load bootstrap3 %}

<form action="" method="post">
     {% csrf_token %}
     {% bootstrap_form form %}
     <input type="submit" class="btn btn-primary" />
</form>
```

```
# blog/templates/blog/comment_form.html

{% extends "blog/layout.html" %}

{% block content %}
<div class="container">
     <div class="row">
         <div class="col-sm-12">
    		     {% include "blog/_comment_form.html" %}  따로 빼놓고 view에서는 각자선택가능
		     </div>
     </div>
</div>
{% endblock %}
```

```
# blog/tempaltes/blog/post_detail.html : Modal Markup

<div class="modal fade" id="comment-form-modal" tabindex="-1">
     <div class="modal-dialog">
         <div class="modal-content">
             <div class="modal-header">
                 <h5 class="modal-title">Comment Form</h5>
                 <button type="button" class="close" data-dismiss="modal">
                 		<span>&times;</span>
                 </button>
             </div>
             <div class="modal-body">
                 ...<br/>
                 ...<br/>
                 ...<br/>
                 ...<br/>
             </div>
         </div>
     </div>
</div>
```

blog/templates/blog/post_detail.html 템플릿에서 댓글 개별 HTML 마크업(li>안에 삭제등등버튼들)을 blog/_comment.html로 이관합니다. _

이는 댓글 Ajax 생성 후에 응답으로서 blog/_comment.html 템플릿을 활용하기 위함입니다. 

이관후 원래있던자리엔 아래 코드 중간 한줄 추가

```
{% for comment in post.comment_set.all %} 
   {% include "blog/_comment.html" %}
{% endfor %}
```





기존 post_detail.html 코드를 그대로 옮기되, 이 템플릿 처리시에는 comment 변수 하나만 넘겨도 처리되도록, post.pk 코드를 comment.post.pk로 수정합니다.=

```
# blog/templatges/blog/_comment.html  //이는 서버에서 렌더링까지해서 html을 응답으로주는 컨셉에 맞춘것

<li id="comment-{{ comment.pk }}">
     {{ comment.message }}
     &dash;
     <a href="{% url "blog:comment_edit" comment.post.pk comment.pk %}">
     		<small>{{ comment.updated_at }}</small>
     </a>

     <a href="{% url "blog:comment_delete" comment.post.pk comment.pk %}"
         class="ajax-post-confirm"
         data-target-id="comment-{{ comment.pk }}"
         data-message="정말 삭제하시겠습니까?">
          <small>삭제</small>
     </a>
</li>
```

```
# blog/templates/blog/post_detail.html

<a href="{% url "blog:comment_new" post.pk %}" class="btn btn-primary btn-block comment-form-btn">댓글쓰기</a>

<script>
$(function(){
     // modal 창의 form submit 이벤트에 대한 리스너
     $(document).on('submit', '#comment-form-modal form', function(e){ //comment-form-modal에서 form태그에서 submit이벤트 발생시,
         e.preventDefault();
         console.log("Submit");
         
         var $form = $(this);
         var url = $form.attr('action');
         var data = $form.serialize();
         
         $.post(url, data)
             .done(function(html){
                 console.log("---- done ----");
                 console.log(html);
                 
             var $resp = $(html);  //응답으로 받은 html을 랩핑해서 jquery object만듬
             
             if ( $resp.find('.has-error').length > 0 ) { //에러가 있다면 .has-error에 들어있다.
                 // validation 에러일 경우, 에러 HTML 응답
                 // form 태그의 속성정보는 그대로 유지하고, 필드 HTML
                만 변경
                 var fields_html = $resp.html();
                 $('#comment-form-modal .modal-body form').html(fields_html);
             }
             else {                               //에러가없는경우
                 $resp.prependTo('#comment-list');
                 $('#comment-form-modal').modal('hide');
                 $form[0].reset();
             }
         })
         .fail(function(xhr, textStatus, error){
         		alert('failed : ' + error);
         });
 });
```

"댓글 쓰기" 버튼이 클릭되면, Comment Form HTML을 서버로부터 받아와서, 그 내용으로 Modal 창을 띄웁니다.

```
$(document).on('click', '.comment-form-btn', function(e) {
 		e.preventDefault();
 		
 		var action_url = $(this).attr('href');
 		
    // 저장 후, 업데이트할 엘리먼트의 ID
    // - 새 "댓글쓰기"에서는 undefined
    var target_id = $(this).data('target-id');  //target-id값 가져옴
    
    $.get(action_url)
    
         .done(function(form_html) {
             var $modal = $('#comment-form-modal');
             
             $modal.find('.modal-body').html(form_html); //form에서 내용을 작성에서 submit으로 두면,,(???)
             
             $form = $modal.find('.modal-body form');
             $form.attr('action', action_url);   //action url로 post요청보낼꺼임
             
             if ( target_id ) {  //target_id값 존재시
                 // modal form에 data-target-id속성 기록
                 // - $form.data('target-id', target_id); 를 써봤으나,
                 // 지정이 되지않아서 attr로 변경
                 $form.attr('data-target-id', target_id);
                 // 이렇게 하면 submit일때 target_id값 있는건 id맞추는 수정 없는건 prependTo로넘김
             }
             else {
		             $form.removeData('target-id');
             }
             
             $modal.on('shown.bs.modal', function(e) {
             		$(this).find('textarea:first').focus();
             });
             $modal.modal();
         })
         .fail(function(xhr, textStatus, error) {
		         alert('failed : ' + error);
         });
   });
});
```

### STEP #5) Bootstrap4 Modal을 통한 댓글 수정

blog/templates/blog/_comment.html 에서 수정링크에 comment

form-btn Class Name 추가 

수정 완료시, 내용 갱신을 위해 data-target-id 지정

(참고사항은 class=comment-form-btn은 두개지만 하나는 detail에 있고 하나는 템플릿에서의 detail이다.

```
<li id="comment-{{ comment.pk }}">
     {{ comment.message }}
     &dash;
     <a href="{% url "blog:comment_edit" comment.post.pk comment.pk %}" class="comment-form-btn" data-target-id="comment-{{ comment.pk }}">
		     <small>{{ comment.updated_at }}</small>
     </a>
     
     <a href="{% url "blog:comment_delete" comment.post.pk comment.pk %}"
         class="ajax-post-confirm"
         data-target-id="comment-{{ comment.pk }}" //수정시에 반드시 id값을 맞춰서 들어가야됨
         data-message="정말 삭제하시겠습니까?">
          <small>삭제</small>
     </a>
</li>
```

뷰에서 템플릿 렌더링 수정

```
class CommentCreatView(CreateView):
    model = Comment
    form_class = CommentForm

    def form_valid(self, form):
        comment = form.save(commit=False) #여기에서 아직세이브안됫으므로 comment_pk값이 지정이 안됫으므로 아래에서 super().form_valid(form)으로 저장후에 if절 적용
        comment.post = get_object_or_404(Post, pk=self.kwargs['post_pk']) #kwargs는 url인자
        response = super().form_valid(form)

        if self.request.is_ajax():  # render_to_response가 호출되지 않습니다.
            return render(self.request, 'blog/_comment.html', {
                'comment': comment,
            })
        return response


    def get_success_url(self):
        #현재 저장한 object가 self.object에 존재함!!!
        return resolve_url(self.object.post)

    def get_template_names(self): //updateview에서도 구별해서!
        if self.request.is_ajax():
            return ['blog/_comment_form.html']
        return ['blog/comment_form.html']

comment_new = CommentCreatView.as_view()
```

blog/templates/blog/post_detail.html 템플릿에서 data-target-id 처리

```
$(document).on('click', '.comment-form-btn', function(e) {
     e.preventDefault();
     var action_url = $(this).attr('href');
     var target_id = $(this).data('target-id');
     
     $.get(action_url)
         .done(function(form_html) {
             var $modal = $('#comment-form-modal');
             
             $modal.find('.modal-body').html(form_html);
             
             $form = $modal.find('.modal-body form');
             $form.attr('action', action_url);
             
             if ( target_id ) {  //target_id가 있다면 true
                 $form.attr('data-target-id', target_id);
                 }
             else {
             		$form.removeData('data-target-id'); // modal창이 뜰때마다 form태그가 새로이 지정되어서 불필요
             }
             
             $modal.on('shown.bs.modal', function(e) { //모달창 보여진후, 그때에 textarea:firt를 찾아서 커서를!! ㄲ
             		$(this).find('textarea:first').focus();
             });
             $modal.modal();
         })
         .fail(function(xhr, textStatus, error) {
         		alert('failed : ' + error);
         });
 });
 
 
 
# blog/templates/blog/post_detail.html

<a href="{% url "blog:comment_new" post.pk %}" class="btn btn-primary btn-block comment-form-btn">댓글쓰기</a>

<script>
$(function(){
     // modal 창의 form submit 이벤트에 대한 리스너
     $(document).on('submit', '#comment-form-modal form', function(e){
         e.preventDefault();
         console.log("Submit");
         
         var $form = $(this);
         var url = $form.attr('action');
         var data = $form.serialize();
         
         $.post(url, data)
             .done(function(html){
                     console.log("---- done ----");
                     console.log(html);

                 var $resp = $(html);
                 var target_id = $form.data('target-id'); //target-id

                 if ( $resp.find('.has-error').length > 0 ) {
                     // validation 에러일 경우, 에러 HTML 응답
                     // form 태그의 속성정보는 그대로 유지하고, 필드 HTML
                    만 변경
                     var fields_html = $resp.html();
                     $('#comment-form-modal .modal-body form').html(fields_html);
                 }
                 else {
                     if ( target_id ) {  //target_id있으면 해당 id값찾아서 그곳의 html을 $resp.html()값으로 바꿔줌
                  		   $('#' + target_id).html($resp.html());
                     }
                     else {
                  		   $resp.prependTo('#comment-list'); //없다면 그냥목록추가
                     }
                     $('#comment-form-modal').modal('hide');
                     $form[0].reset();
                 }
             })
             .fail(function(xhr, textStatus, error){
                alert('failed : ' + error);
             });
 });
```

### STEP #6) 다음 STEP에서는 파일업로드를 할텐데

일단 MEDIA 관련 최소 처리를 해봅시다.

```
# askdjango/settings.py
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

# askdjango/urls.py
from django.conf import settings
from django.conf.urls.static import static

# 중략
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

MEDIA 관련 내용은 장고 기본편 - Media Files 유저가 업로드한 파일은 어떻 게 관리될까요?를 참고하세요.



### STEP #7) 댓글 Ajax 파일 업로드

모델에 photo필드 추가

```
# blog/models.py
class Comment(models.Model):
     post = models.ForeignKey(Post)
     message = models.TextField()
     photo = models.ImageField(blank=True)
     created_at = models.DateTimeField(auto_now_add=True)
     updated_at = models.DateTimeField(auto_now=True)
     
     class Meta:
		     ordering = ['-id']
```

폼에 photo필드 추가

```
# blog/forms.py

import re
from django import forms
from .models import Comment

class CommentForm(forms.ModelForm):
     class Meta:
         model = Comment
         fields = ['message', 'photo']
     
     def clean_message(self):
         message = self.cleaned_data.get('message', None)
         if message:
        		 if not re.search(r'[ㄱ-힣]', message):
         					raise forms.ValidationError('메세지에 한글이 필요합니다.')
         return message
```

Comment Form 템플릿에 enctype 변경 CBV는 이미 파일 업로드를 받도록 되어있습니다

__파일 업로드이므로 꼭 enctype변경__

```
{% load bootstrap3 %}

<form action="" method="post" enctype="multipart/form-data">
     {% csrf_token %}
     {% bootstrap_form form %}
     <input type="submit" class="btn btn-primary" />
</form>
```

그런데, 댓글 작성 시에 파일을 지정해서 올려도 admin을 통해 확인해보면 파일이 저장되어있지 않습니다.

__자바스크립트 단에서 파일도 같이 전송하기 jQuery의 serialize()는 urlencoded방식으로 form data를 직렬화하기 때문에, 파일전송은 불가합니다__

```
> $('form').serialize();
"csrfmiddlewaretoken=MKzLxrvoY4VVWcmsgfzjKQf9OQ7wpkGedKjPfLgHNSzb0aKc6qGf3wzymqJkbO7C&message=%EC%82%AC%EC%A7%841"

```

이를 처리해주는 파일업로드 라이브러리를 추가로 사용해주시는 것이 좋습니다

- jQuery Form Plugin
- jQuery File Upload 라이브러리 (only 파일업로드)

#### jQuery Form Plugin

bower.json 수정 후에, bower install

```
{
     "name": "askdjango"
    ,
     "dependencies": {
         "jquery": "~3.2.1"
        ,
         "bootstrap": "~3.3.7"
        ,
         "underscore": "~1.8.3"
        ,
         "jquery-form": "~4.2.2"
     } 
 }
```

```
# askdjango/templates/layout.html

<script src="{% static "jquery/dist/jquery.min.js" %}"></script>
<script src="{% static "bootstrap/dist/js/bootstrap.min.js" %}"></script>
<script src="{% static "jquery.csrf.js" %}"></script>
<script src="{% static "underscore/underscore-min.js" %}"></script>
<script src="{% static "jquery-form/dist/jquery.form.min.js" %}"></script>
```

Comment Form, submit 핸들러를 ajaxSubmit으로 변경

```
# post_detail.html일부분
$(document).on('submit', '#comment-form-modal form', function(e) {
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
                                $('#comment-form-modal .modal-body form').html(fields_html);
                        }
                        else {
                            if (target_id) {
                                $('#' + target_id).html($resp.html());
                            }
                            else {
                                $resp.prependTo('#comment-list');
                            }

                            $('#comment-form-modal').modal('hide');
                            $form[0].reset();
                        }
                },
                error: function(xhr, textStatus, error) {
                    alert('failed : ' + error);
                },
                complete: function(xhr, textStatus) {
                }
        });
    })
```



($.post(url, data)를 쓰면 encode로 (문자열)로 보내줘서 이미지 파일자체도 파일명만들어간다

따라 post처리를 ajaxSubmit으로 바꿈) 

__이제 파일 업로드까지 Ajax로 모두 잘 처리됩니다.__



### STEP #8) 댓글 목록에 이미지를 노출시켜봅시다.

```
blog/templates/blog/_comment.html

<li id="comment-{{ comment.pk }}">
     {% if comment.photo %} //모두가 photo가 있는 것이 아니므로 꼭 해주기
    		 <img src="{{ comment.photo.url }}" style="width: 100px;" />
     {% endif %}
     
     {{ comment.message }}
     &dash;
     <a href="{% url "blog:comment_edit" comment.post.pk comment.pk %}" class="comment-form-btn" data-target-id="comment-{{ comment.pk }}">
    		 <small>{{ comment.updated_at }}</small>
     </a>
     
     <a href="{% url "blog:comment_delete" comment.post.pk comment.pk %}"
         class="ajax-post-confirm"
         data-target-id="comment-{{ comment.pk }}"
         data-message="정말 삭제하시겠습니까?">
          <small>삭제</small>
     </a>
</li>
```

### 다음 시간은 본 코스 마지막 시간.

- 이미지 썸네일 처리 • 댓글 레이아웃 개선 • 댓글 페이징처리 • 댓글 Ajax 새로고침 • 사용자 인증 연동

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

<canvas id="canvas"></canvas>

<script>
var chartData = {
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

window.onload = function() {
     var ctx = document.getElementById('canvas').getContext('2d');
     window.chart = new Chart(ctx, {
         type: 'line',
         data: chartData
     });
};
</script>
```

## 백엔드에서 데이터 넘겨주기 (1) 템플릿 렌더링 시에 데이터 넘겨주기

### 유틸리티 코드) 웹툰 평점 크롤링

```
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

def get_comic_info(comic_id, comic_title):
		 ep_list = []
		 
     for page in range(1, 6): # 최대 5페이지
         params = {
             'titleId': comic_id,
             'page': page,
         }
         resp = requests.get('http://comic.naver.com/webtoon/list.nhn', params=params)
         html = resp.text
         soup = BeautifulSoup(html, 'html.parser')
         
         for tr in soup.select('#content table tr'):
             try:
                 link = tr.select('.title a[href*=detail]')[0]
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
             if ep in ep_list:
             		return ep_list
             		
             ep_list.append(ep)
             
     return {
         'title': comic_title,
         'ep_list': ep_list,
     };
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
             {% if not forloop.last %},{% endif %}
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
                 {% if not forloop.last %},{% endif %}
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
from django.http import JsonResponse
from django.shortcuts import render
from .utils import get_comic_info

def index(request):
		 return render(request, 'mychart/index.html')
		 
def data_json(request):
 comic = get_comic_info(20853, '마음의 소리')
 
 data = {
     'labels': [ep['title'] for ep in comic['ep_list']],
     'datasets': [{
         'label': '평점',
         'backgroundColor': 'rgb(255, 99, 132)',
         'backgroundColor': 'rgba(255, 99, 132, 0.5)',
         'borderColor': 'rgba(255, 99, 132, 1)',
         'pointBackgroundColor': 'rgba(255, 99, 132, 1)',
         'pointBorderColor': '#fff',
         'data': [ep['rating'] for ep in comic['ep_list']],
     }],
 }
 
 return JsonResponse(data)
```

### 템플릿 코드

```
<!doctype html> <html> <head>

<meta charset="utf-8" />

<script src="//www.chartjs.org/dist/2.7.0/Chart.bundle.js"></script>

<script src="//code.jquery.com/jquery-2.2.4.min.js"></script>
</head>
<body>

<canvas id="canvas"></canvas>

<script>
window.onload = function(){
     $.get('{% url "data_json" %}')
         .done(function(data){
         var ctx = document.getElementById('canvas').getContext('2d');
         var chart = new Chart(ctx, {
             type: 'line',
             data: data
		     });
     })
     .fail(function(xhr, textStatus, error){
    		 alert('failed : ' + error);
     });;
};
</script>
</body>
</html>
```

## 백엔드에서 데이터 넘겨주기 (3) django-chartjs 활용

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

