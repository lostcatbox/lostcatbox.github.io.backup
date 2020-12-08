---
title: python-test-univ
tags:
---

# 터틀 별그리기

```python
import turtle

turtle.color('red', 'yellow')

turtle.begin_fill()
for _ in range(5):
    turtle.forward(100)
    turtle.right(360 / 5 * 2) #144도
turtle.end_fill()

turtle.done()
```

# 터틀 동그라미 그리기

```python
import turtle

turtle.color('red', 'yellow')

turtle.begin_fill()
for _ in range(5):
    turtle.forward(100)
    turtle.right(360 / 5 * 2)
turtle.end_fill()

turtle.done()
```

# 정삼각형, 정사각형 그리기(n각형)

```python
import turtle
t = turtle.Turtle() t.shape("turtle")
s = turtle.textinput("", "몇각형을 원하시나요?:") 
n=int(s)
for i in range(n): 
  t.forward(100)
  t.left(360/n)
```

# 클릭선까지 그리기

```python
import turtle
def draw(x, y): 
  t.goto(x, y)

t = turtle.Turtle() 
t.shape("turtle") 
t.pensize(10)
s = turtle.Screen() 
s.onscreenclick(draw)
```



# 랜덤하게 거북이 움직이기

```python
import turtle 
import random
t = turtle.Turtle() 
t.shape("turtle")
for i in range(30):
  length = random.randint(1, 100)
  t.forward(length)
  angle = random.randint(-180, 180)
  t.right(angle)
```

# 클릭시 거북이 움직임

```python
import turtle

t = turtle.Turtle()
t.shape("turtle")


def drawit(x, y):
    t.penup()
    t.goto(x, y)
    t.pendown()
    t.begin_fill()
    t.color("green")
    square(50)
    t.end_fill()


def square(length):  # length는 한 변의 길이
    for i in range(4):
        t.forward(length)
        t.left(90)


s = turtle.Screen()  # 그림이 그려지는 화면을 얻는다.
s.onscreenclick(drawit)
s.mainloop()
```

# 시험문제(클릭좌표로 이동)

```
#시험문제
import turtle

def draw(x, y):
    t.goto(x, y)

t = turtle.Turtle()
t.shape("turtle")
t.pensize(10)
s = turtle.Screen()
s.onscreenclick(draw)
```

# 시험문제(거북이 경주)

```python
#거북이 경주(시험문제)
import turtle
import random
t1 = turtle.Turtle() # 첫 번째 거북이
t2 = turtle.Turtle() # 두 번째 거북이
t1.color("pink")
t1.shape("turtle")
#t1.shapesize(5)
#t1.pensize(5)
t2.color("blue")
t2.shape("turtle")
#t2.shapesize(5)
#t2.pensize(5)

t1.penup()
t1.goto(-300, 0)
t2.penup()
t2.goto(-300, -100)

for i in range(100): # 100번 반복한다.
     d1 = random.randint(1, 60) # 1부터 60 사이의 난수를 발생한다.
     t1.forward(d1) # 난수만큼 이동한다.
     d2 = random.randint(1, 60) # 1부터 60 사이의 난수를 발생한다.
     t2.forward(d2) # 난수만큼 이동한다.
```

# 이미지 파일 삽입 방법

```python
##이미지 파일 삽입 방법
screen =turtle.Screen()
image1 = "/Users/lostcatbox/lecture/review_coding_test/rabbit.gif" #윈도우 기준 \\임
image2 = "/Users/lostcatbox/lecture/review_coding_test/turtle.gif"
screen.addshape(image1)
screen.addshape(image2)


t1 = turtle.Turtle()  # 첫 번째 거북이
t2 = turtle.Turtle()  # 두 번째 거북이
t1.color("pink")
t1.shape(image1)
# t1.shapesize(5)
# t1.pensize(5)
t2.color("blue")
t2.shape(image2)
# t2.shapesize(5)
# t2.pensize(5)
```

# 태극 마크

```python
#태극 마크
def draw_shape(radius, color1):
    t.left(270)
    t.width(3)
    t.color("black", color1)
    t.begin_fill()
    t.circle(radius / 2.0, -180)
    t.circle(radius, 180)
    t.left(180)
    t.circle(-radius / 2.0, -180)
    t.end_fill()


t = turtle.Turtle()
t.reset()
draw_shape(200, "red")
t.setheading(180)
draw_shape(200, "blue")
```

# 슬라이싱, 딕셔너리 리스트

appnd

 인덱스

remove

del

pop()

.sort()

# GUI

```
from tkinter import *

window = Tk()  #최상위 원도우 생성
l1 = Label(window, text="Fahrehtiwejrwj") #글자 표기
l2 = Label(window, text="c") #글자 표기
l1.pack()
l2.pack()
e1 = Entry(window) #엔트리는 사용자에게 입력을 받음
e1.pack()
b1 = Button(window, text="FtoC")
b2 = Button(window, text="CtoF")
b1.pack() #위젯 생성후 꼭 pack()을 써서 포장해줘야함
b2.pack()

window.mainloop() #loop~

#배치관리자,pack(압축배치), grid(격자 배치)(행과열), place(절대관리자)
# 버튼 이벤트 처리
from tkinter import *

def process1():
    my_f = float(e1.get()) #get으로 가져옴
    my_c = (my_f-32)*5/9
    e2.insert(0,my_c)

def process2():
    my_c = float(e2.get()) #get으로 가져옴
    my_f = (my_c*9/5)+32
    e1.insert(0,my_f)

window = Tk()  #최상위 원도우 생성
l1 = Label(window, text="Fahrehtiwejrwj", font="helvetica 16 italic") #글자 표기
l2 = Label(window, text="c",font="helvetica 16 italic") #글자 표기
l1.grid(row=0,column=0)
l2.grid(row=1,column=0)
e1 = Entry(window, bg="yellow", fg="white") #엔트리는 사용자에게 입력을 받음
e2 = Entry(window,bg="yellow", fg="white") #엔트리는 사용자에게 입력을 받음
e1.grid(row=0,column=1)
e2.grid(row=1,column=1)
b1 = Button(window, text="FtoC", command=process1)
b2 = Button(window, text="CtoF", command=process2)
b1.grid(row=2,column=0) #위젯 생성후 꼭 pack()을 써서 포장해줘야함
b2.grid(row=2,column=1)

window.mainloop() #loop~

#마지막 절대 위치 place

from tkinter import * 
window = Tk()
w = Label(window, text="박스 #1", bg="red", fg="white") 
w.place(x=0, y=0)
w = Label(window, text="박스 #2", bg="green", fg="black") 
w.place(x=20, y=20)
w = Label(window, text="박스 #3", bg="blue", fg="white") 
w.place(x=40, y=40)
window.mainloop()

# #이미ㅣㅈ 표시
from tkinter import *
def change_img():
    path = inputBox.get()
    img = PhotoImage(file = path) 
    imageLabel.configure(image = img) 
    imageLabel.image = img
window = Tk()
photo = PhotoImage(file="wl.gif") 
imageLabel = Label(window, image=photo) 
imageLabel.pack()
inputBox = Entry(window) 
inputBox.pack()
button = Button(window, text='Submit', command=change_img) 
button.pack()
window.mainloop()



# 계산기(아마 시험?)
from tkinter import * 
window = Tk()
window.title("My Calculator")
display = Entry(window, width=33, bg="yellow") 
display.grid(row=0, column=0, columnspan=5)
button_list = ['7', '8', '9', '/', 'C', '4', '5', '6', '*', ' ', '1', '2', '3', '-', ' ', '0', '.', '=', '+', ' ']
row_index = 1
col_index = 0
for button_text in button_list:
    Button(window, text=button_text, width=5).grid(row=row_index, column=col_index) 
    col_index += 1
    if col_index > 4:
        row_index += 1 
        col_index = 0


window.mainloop()
```

