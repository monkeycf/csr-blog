---
title: sass相关知识点
description: sass的特色功能、语法格式、拓展功能、注释、SassScript、@-rule、控制指令、函数指令、混合指令、输出格式
categories: sass
tags:
  - sass
abbrlink: 2713175653
date: 2019-11-18 13:55:45
---

## 特色功能

- 完全兼容 CSS3
- 在 CSS 基础上增加变量、嵌套 (nesting)、混合 (mixins) 等功能
- 通过函数进行颜色值与属性值的运算
- 提供控制指令等高级功能
- 自定义输出格式

## 语法格式

1. SCSS

   所有符合 CSS3 语法的样式表也都是具有相同语法意义的 SCSS 文件

2. Sass（缩排语法）

## CSS拓展功能

### 选择器嵌套

```scss
div {
  .hi {
    color: red;
  }
}
```

### 引用父元素 &

```scss
a {
  &:hover {
    color: #ffb3ff;
  }
}

#main {
  color: black;
  &-sidebar { border: 1px solid; }
}
```

### 属性嵌套

> 例如border-color属性嵌套

```scss
div {
  border: {
    color: red;
  }
}

.funky {
  font: 20px/24px {
    family: fantasy;
    weight: bold;
  }
}
```

### 占位符选择器 （%foo）

> 暂时空



## 注释

### css注释

> 标准css注释，编译后保留

```scss
/*
 *  标准的css注释，编译后保留
 */
```

### sass注释

> 单行注释，只在sass中保留

```scss
// 单行注释，只在sass中保留
```

### 重要注释

> 重要注释，在压缩文件中保留（通常为版本信息）

```scss
/*!
 * 重要注释！
 */
```

## SassScript

>  在 CSS 属性的基础上 Sass 提供了一些名为 SassScript 的新功能。 SassScript 可作用于任何属性，允许属性使用变量、算数运算等额外功能。 

### 变量

>  变量以美元符号开头，赋值方法与 CSS 属性的写法一样

#### 块级作用域

> 变量支持块级作用域，嵌套规则内定义的变量只能在嵌套规则内使用（局部变量），不在嵌套规则内定义的变量则可在任何地方使用（全局变量）。 

#### global

> 将局部变量转换为全局变量可以添加 **!global**

```scss
div {
  $normalFontSize: 20px !global;
  $blue: blue;
  font-size: $normalFontSize;
  color: $blue;

  p {
    font-size: calc(#{$normalFontSize} + 2px);
  }
}

body {
  font-size: $normalFontSize;
  width: 50px * 5;
}
```

### 数据类型

#### 数字

> 1, 2, 13, 10px

#### 字符串，有引号字符串与无引号字符串

> "foo", 'bar', baz

#### 颜色

> blue, #04a3f9, rgba(255,0,0,0.5)

#### 布尔型

> true, false

#### 空值

> null

#### 数组 (list)，用空格或逗号作分隔符

> 1.5em 1em 0 2em, Helvetica, Arial, sans-serif

```scss
$stars: (
        (size: 40px, left: 22px, top: 97px),
        (size: 32px, left: 42px, top: 70px),
        (size: 31px, left: 464px, top: 273px),
        (size: 28px, left: 240px, top: 402px),
        (size: 25px, left: 289px, top: 557px)
);

@for $i from 1 through length($stars) {
  $item: nth($stars, $i);

  &:nth-child(#{$i}) {
    width: map-get($item, size);
    height: map-get($item, size);
    left: map-get($item, left);
    top: map-get($item, top);
  }
}
```

```scss
$name:"lili","yaya","sansa";  //注意数组list的写法
@each $i in $name {
  .#{$i} {
    width: 10px;
  }
}
```



#### maps, 相当于 JavaScript 的 object

> (key1: value1, key2: value2)

```scss
$name2: (name21:"lili", name22:"yaya", name23:"sansa");
@each $i in $name2 {
  .test9.#{$i} {
    width: 10px;
  }
}

$name3: (name31:1, name32:2, name33:3);
@each $key, $value in $name3 {
  .test10.#{$key} {
    width: 10px*$value;
  }
}
```



### 运算

#### 除法运算

> `/` 在 CSS 中通常起到分隔数字的用途，SassScript 作为 CSS 语言的拓展当然也支持这个功能，同时也赋予了 `/` 除法运算的功能。 

- 如果值，或值的一部分，是变量或者函数的返回值
- 如果值被圆括号包裹
- 如果值是算数表达式的一部分

```scss
p {
  font: 10px/8px;             // Plain CSS, no division
  $width: 1000px;
  width: $width/2;            // Uses a variable, does division
  width: round(1.5)/2;        // Uses a function, does division
  height: (500px/2);          // Uses parentheses, does division
  margin-left: 5px + 8px/2px; // Uses +, does division
  font: #{$font-size}/#{$line-height}; // 使用变量，也使用 分隔符 /
}
```

#### 颜色运算符

```scss
p {
  color: #010203 + #040506; // #050709
}
```

>  当包含alpha channel 时，透明度必须相等才可以进行计算。

```scss
p {
  color: rgba(255, 0, 0, 0.75) + rgba(0, 255, 0, 0.75); // rgba(255, 255, 0, 0.75);
}
```

#####  alpha channel 调整

* opacify 增减
* transparentize 直接调整

```scss
$translucent-red: rgba(255, 0, 0, 0.5);
p {
  color: opacify($translucent-red, 0.3); // rgba(255, 0, 0, 0.8);
  background-color: transparentize($translucent-red, 0.25); // rgba(255, 0, 0, 0.25);
}
```

####  字符串运算

>  如果有引号字符串（位于 `+` 左侧）连接无引号字符串，运算结果是有引号的，相反，无引号字符串（位于 `+` 左侧）连接有引号字符串，运算结果则没有引号。 

```scss
p:before {
  content: "Foo " + Bar; // "Foo Bar"
  font-family: sans- + "serif"; // sans-serif
}
```

> 在有引号的文本字符串中使用 `#{}` 插值语句可以添加动态的值： 

```scss
p:before {
  content: "I ate #{5 + 10} pies!"; // "I ate 15 pies!"
}
```

#### 布尔运算 (Boolean Operations)

> SassScript 支持布尔型的 `and` `or` 以及 `not` 运算

#### 数组运算 (List Operations)

>  数组不支持任何运算方式，只能使用 list functions 控制

### 圆括号

> 圆括号可以用来影响运算的顺序

```scss
p {
  width: 1em + (2em * 3);
}
```

### 函数

#### 关键词参数

> 关键词参数给函数提供了更灵活的接口，以及容易调用的参数。关键词参数可以打乱顺序使用，如果使用默认值也可以省缺，另外，参数名被视为变量名，下划线、短横线可以互换使用。 

```scss
p {
  color: hsl($hue: 0, $saturation: 100%, $lightness: 50%);
}
```

### &

```scss
.foo.bar .baz.bang, .bip.qux {
  $selector: &; // & -> ((.foo.bar .baz.bang), .bip.qux)
}
```

> 判断&是否存在

```scss
@mixin does-parent-exist {
  @if & {
    &:hover {
      color: red;
    }
  } @else {
    a {
      color: red;
    }
  }
}
```

### 变量定义 `!default`

**变量是 null 空值时将视为未被 `!default` 赋值。**

```scss
$content: "First content";
$content: "Second content?" !default;
$new_content: "First time reference" !default;

#main {
  content: $content; // "First content"
  new-content: $new_content; // "First time reference"
}
```

## @-Rules 与指令

### @import

>  许其导入 SCSS 或 Sass 文件。
>
> 被导入的文件将合并编译到同一个 CSS 文件中
>
> 被导入的文件中所包含的变量或者混合指令 (mixin) 都可以在导入的文件中使用。 

 Sass 允许同时导入多个文件，例如同时导入 rounded-corners 与 text-shadow 两个文件： 

```scss
@import "rounded-corners", "text-shadow";
```

> 导入文件也可以使用 `#{ }` 插值语句，但不是通过变量动态导入 Sass 文件，只能作用于 CSS 的 `url()` 导入方式： 



**注意：**

 通常，`@import` 寻找 Sass 文件并将其导入， 除以下情况：

- 文件拓展名是 `.css`；
- 文件名以 `http://` 开头；
- 文件名是 `url()`；
- `@import` 包含 media queries。

#### 分音 (Partials)

 如果需要导入 SCSS 或者 Sass 文件，但又不希望将其编译为 CSS，只需要在文件名前添加下划线 

> 将文件命名为 `_colors.scss`，便不会编译 `_colours.css` 文件。

```scss
@import "colors";
```

#### 嵌套 @import

> 可以将 `@import` 嵌套进 CSS 样式或者 `@media` 中，与平时的用法效果相同，只是这样导入的样式只能出现在嵌套的层中。 

```scss
// example.scss
.example {
  color: red;
}

// main
#main {
  @import "example";
}

// =>
#main .example {
  color: red;
}
```

###  @media

> 允许其在 CSS 规则中嵌套 

```scss
.sidebar {
  width: 300px;
  @media screen and (orientation: landscape) {
    width: 500px;
  }
}
```

> @media 的 queries 允许互相嵌套使用，编译时，Sass 自动添加 and

```scss
@media screen {
  .sidebar {
    @media (orientation: landscape) {
      width: 500px;
    }
  }
}
```

> `@media` 可以使用 SassScript（比如变量，函数，以及运算符）代替条件的名称或者值：

```scss
$media: screen;
$feature: -webkit-min-device-pixel-ratio;
$value: 1.5;

@media #{$media} and ($feature: $value) {
  .sidebar {
    width: 500px;
  }
}
```

### @extend

>  一个选择器下的所有样式继承给另一个选择器

```scss
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.error.intrusion {
  background-image: url("/image/hacked.png");
}
.seriousError {
  @extend .error;
  border-width: 3px;
}
```

编译为

```css
.error, .seriousError {
  border: 1px #f00;
  background-color: #fdd; }

.error.intrusion, .seriousError.intrusion {
  background-image: url("/image/hacked.png"); }

.seriousError {
  border-width: 3px; }
```

#### 延伸复杂的选择器

>  Class 选择器并不是唯一可以被延伸 (extend) 的，Sass 允许延伸任何定义给单个元素的选择器 

```scss
.hoverlink {
  @extend a:hover;
}
a:hover {
  text-decoration: underline;
}
```

编译为

```css
a:hover, .hoverlink {
  text-decoration: underline; }
```

#### 多重延伸

> 同一个选择器可以延伸给多个选择器，它所包含的属性将继承给所有被延伸的选择器
>
>  多重延伸可以使用逗号分隔选择器名，比如 `@extend .error, .attention;` 与 `@extend .error;` `@extend.attention` 有相同的效果。 

```scss
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.attention {
  font-size: 3em;
  background-color: #ff0;
}
.seriousError {
  @extend .error;
  @extend .attention;
  border-width: 3px;
}
```

编译为

```css
.error, .seriousError {
  border: 1px #f00;
  background-color: #fdd; }

.attention, .seriousError {
  font-size: 3em;
  background-color: #ff0; }

.seriousError {
  border-width: 3px; }
```

#### 继续延伸

> 当一个选择器延伸给第二个后，可以继续将第二个选择器延伸给第三个 

```scss
.error {
  border: 1px #f00;
  background-color: #fdd;
}
.seriousError {
  @extend .error;
  border-width: 3px;
}
.criticalError {
  @extend .seriousError;
  position: fixed;
  top: 10%;
  bottom: 10%;
  left: 10%;
  right: 10%;
}
```

编译为：

```css
.error, .seriousError, .criticalError {
  border: 1px #f00;
  background-color: #fdd; }

.seriousError, .criticalError {
  border-width: 3px; }

.criticalError {
  position: fixed;
  top: 10%;
  bottom: 10%;
  left: 10%;
  right: 10%; }
```

#### 选择器列

* 暂时**不可以**将选择器列 (Selector Sequences)，比如 `.foo .bar` 或 `.foo + .bar`，延伸给其他元素

* 可以将其他元素延伸给选择器列

##### 合并选择器列

1. 当两个列 (sequence) 合并时，如果没有包含相同的选择器，将生成两个新选择器：第一列出现在第二列之前，或者第二列出现在第一列之前：

```scss
#admin .tabbar a {
  font-weight: bold;
}
#demo .overview .fakelink {
  @extend a;
}
```

编译为

```css
#admin .tabbar a,
#admin .tabbar #demo .overview .fakelink,
#demo .overview #admin .tabbar .fakelink {
  font-weight: bold; }
```

2. 如果两个列 (sequence) 包含了相同的选择器，相同部分将会合并在一起，其他部分交替输出。在下面的例子里，两个列都包含 `#admin`，输出结果中它们合并在了一起：

```scss
#admin .tabbar a {
  font-weight: bold;
}
#admin .overview .fakelink {
  @extend a;
}
```

编译为

```css
#admin .tabbar a,
#admin .tabbar .overview .fakelink,
#admin .overview .tabbar .fakelink {
  font-weight: bold; }
```

#### @extend-Only 选择器

#### !optional 声明

#### 在指令中延伸

> Sass 不可以将 `@media` 层外的 CSS 规则延伸给指令层内的 CSS 
>
> **如果在 `@media` （或者其他 CSS 指令）中使用 `@extend`，必须延伸给相同指令层中的选择器。 **

```scss
@media print {
  .error {
    border: 1px #f00;
    background-color: #fdd;
  }
  .seriousError {
    @extend .error;
    border-width: 3px;
  }
}
```

但不可以这样：

```scss
.error {
  border: 1px #f00;
  background-color: #fdd;
}

@media print {
  .seriousError {
    // INVALID EXTEND: .error is used outside of the "@media print" directive
    @extend .error;
    border-width: 3px;
  }
}
```

### @at-root

将会渲染到根目录下而不是作用块内。

```scss
.parent {
  ...
  @at-root {
    .child1 { ... }
    .child2 { ... }
  }
  .step-child { ... }
}
```

编译为

```css
.parent { ... }
.child1 { ... }
.child2 { ... }
.parent .step-child { ... }
```

#### @at-root (without: ...)

```scss
@media print {
  .page {
    width: 8in;
    @at-root (without: media) {
      color: red;
    }
  }
}
```

编译为：

```css
@media print {
  .page {
    width: 8in;
  }
}
.page {
  color: red;
}
```

#### @at-root (with: ...)

### @debug

> 打印计算值到控制台，便于调试

### @warn

> 打印标准错误输出流

@warn 和 @debug 的区别

* 可以使用 quiet 关闭警告
* 追踪栈也会一起打印出来，以便调试

```scss
@mixin adjust-location($x, $y) {
  @if unitless($x) {
    @warn "Assuming #{$x} to be in pixels";
    $x: 1px * $x;
  }
  @if unitless($y) {
    @warn "Assuming #{$y} to be in pixels";
    $y: 1px * $y;
  }
  position: relative; 
  left: $x;
  top: $y;
}
```

### @error

> 抛出致命错误

```scss
@mixin adjust-location($x, $y) {
  @if unitless($x) {
    @error "$x may not be unitless, was #{$x}.";
  }
  @if unitless($y) {
    @error "$y may not be unitless, was #{$y}.";
  }
  position: relative; left: $x; top: $y;
}
```

## 控制指令

>  控制指令是一种高级功能，日常编写过程中并不常用到，主要与混合指令 (mixin) 配合使用 

### if()

> 不建议使用

```scss
div {
  font-size: if(false, 1px, 2px);
}
```

### @if

当 `@if` 的表达式返回值不是 `false` 或者 `null` 时，条件成立，输出 `{}` 内的代码：

```scss
p {
  @if 1 + 1 == 2 { border: 1px solid; }
  @if 5 < 3 { border: 2px dotted; }
  @if null  { border: 3px double; }
}
```

编译为

```css
p {
  border: 1px solid; }
```

#### @eles

```scss
$type: monster;
p {
  @if $type == ocean {
    color: blue;
  } @else if $type == matador {
    color: red;
  } @else if $type == monster {
    color: green;
  } @else {
    color: black;
  }
}
```

编译为

```css
p {
  color: green; }
```

### @for

*  @for $var from <start> through <end>  , [start, end]
*  @for $var from <start> to <end>  , [start, end)

```scss
@for $i from 1 through 3 {
  .item-#{$i} { width: 2em * $i; }
}
```

### @each

> `@each` 指令的格式是 $var in  <list>

```scss
@each $animal in puma, sea-slug, egret, salamander {
  .#{$animal}-icon {
    background-image: url('/images/#{$animal}.png');
  }
}
```

#### Multiple Assignment

```scss
@each $animal, $color, $cursor in (puma, black, default),
                                  (sea-slug, blue, pointer),
                                  (egret, white, move) {
  .#{$animal}-icon {
    background-image: url('/images/#{$animal}.png');
    border: 2px solid $color;
    cursor: $cursor;
  }
}
```

编译为：

```css
.puma-icon {
  background-image: url('/images/puma.png');
  border: 2px solid black;
  cursor: default; }
.sea-slug-icon {
  background-image: url('/images/sea-slug.png');
  border: 2px solid blue;
  cursor: pointer; }
.egret-icon {
  background-image: url('/images/egret.png');
  border: 2px solid white;
  cursor: move; }
```

```scss
@each $header, $size in (h1: 2em, h2: 1.5em, h3: 1.2em) {
  #{$header} {
    font-size: $size;
  }
}
```

编译为：

```css
h1 {
  font-size: 2em; }
h2 {
  font-size: 1.5em; }
h3 {
  font-size: 1.2em; }
```

### @while

> `@while` 指令重复输出格式直到表达式返回结果为 `false` 

```scss
$i: 6;
@while $i > 0 {
  .item-#{$i} { width: 2em * $i; }
  $i: $i - 2;
}
```

```css
.item-6 {
  width: 12em; }

.item-4 {
  width: 8em; }

.item-2 {
  width: 4em; }
```

## 混合指令

### 定义混合指令 `@mixin`

> 混合指令的用法是在 `@mixin` 后添加名称与样式 

```scss
@mixin clearfix {
  display: inline-block;
  &:after {
    content: ".";
    display: block;
    height: 0;
    clear: both;
    visibility: hidden;
  }
  * html & { height: 1px }
}
```

### 引用混合样式 `@include`

```scss
.page-title {
  @include large-text;
  padding: 4px;
  margin-top: 10px;
}
```

### 参数

 参数用于给混合指令中的样式设定变量，并且赋值使用(可以设定默认值 )

```scss
@mixin sexy-border($color, $width: 1in) {
  border: {
    color: $color;
    width: $width;
    style: dashed;
  }
}
```

#### 关键词参数

> 类似于解构

```scss
p { @include sexy-border($color: blue); }
h1 { @include sexy-border($color: blue, $width: 2in); }
```

#### 参数变量

可以使用参数变量 `…` 声明（写在参数的最后方）告诉 Sass 将这些参数视为值列表处理：

```scss
@mixin box-shadow($shadows...) {
  -moz-box-shadow: $shadows;
  -webkit-box-shadow: $shadows;
  box-shadow: $shadows;
}
.shadows {
  @include box-shadow(0px 4px 5px #666, 2px 6px 10px #999);
}
```

编译为

```css
.shadowed {
  -moz-box-shadow: 0px 4px 5px #666, 2px 6px 10px #999;
  -webkit-box-shadow: 0px 4px 5px #666, 2px 6px 10px #999;
  box-shadow: 0px 4px 5px #666, 2px 6px 10px #999;
}
```

 参数变量也可以用在引用混合指令的时候 (`@include`) 

```scss
@mixin colors($text, $background, $border) {
  color: $text;
  background-color: $background;
  border-color: $border;
}
$values: #ff0000, #00ff00, #0000ff;
.primary {
  @include colors($values...);
}
```

编译为

```css
.primary {
  color: #ff0000;
  background-color: #00ff00;
  border-color: #0000ff;
}
```

### 向混合样式中导入内容

在引用混合样式的时候，可以先将一段代码导入到混合指令中，然后再输出混合样式，额外导入的部分将出现在 `@content` 标志的地方：

 **注意：** 当 `@content` 在指令中出现过多次或者出现在循环中时，额外的代码将被导入到每一个地方。 

```scss
@mixin apply-to-ie6-only {
  * html {
    @content;
  }
}
@include apply-to-ie6-only {
  #logo {
    background-image: url(/logo.gif);
  }
}
```



编译为

```css
* html #logo {
  background-image: url(/logo.gif);
}
```

#### Variable Scope and Content Blocks

> mixin的变量是块作用域不能在全局使用

```scss
$color: white;
@mixin colors($color: blue) {
  background-color: $color;
  @content;
  border-color: $color;
}
.colors {
  @include colors { color: $color; }
}
```

编译为

```css
.colors {
  background-color: blue;
  color: white;
  border-color: blue;
}
```

## 函数指令

```scss
$grid-width: 40px;
$gutter-width: 10px;

@function grid-width($n) {
  @return $n * $grid-width + ($n - 1) * $gutter-width;
}

#sidebar { width: grid-width(5); }
```

编译为

```css
#sidebar {
  width: 240px; }
```

与 mixin 相同，也可以传递若干个全局变量给函数作为参数。一个函数可以含有多条语句，需要调用 `@return` 输出结果。

## 输出格式

Sass 提供了四种输出格式，可以通过 `:style option` 选项设定，或者在命令行中使用 `--style` 选项。

### :nested

Nested （嵌套）样式是 Sass 默认的输出格式，能够清晰反映 CSS 与 HTML 的结构关系。选择器与属性等单独占用一行，缩进量与 Sass 文件中一致，每行的缩进量反映了其在嵌套规则内的层数。当阅读大型 CSS 文件时，这种样式可以很容易地分析文件的主要结构。

```css
#main {
  color: #fff;
  background-color: #000; }
  #main p {
    width: 10em; }

.huge {
  font-size: 10em;
  font-weight: bold;
  text-decoration: underline; }
```

### :expanded

Expanded 输出更像是手写的样式，选择器、属性等各占用一行，属性根据选择器缩进，而选择器不做任何缩进。

```css
#main {
  color: #fff;
  background-color: #000;
}
#main p {
  width: 10em;
}

.huge {
  font-size: 10em;
  font-weight: bold;
  text-decoration: underline;
}
```

### :compact

Compact 输出方式比起上面两种占用的空间更少，每条 CSS 规则只占一行，包含其下的所有属性。嵌套过的选择器在输出时没有空行，不嵌套的选择器会输出空白行作为分隔符。

```css
#main { color: #fff; background-color: #000; }
#main p { width: 10em; }

.huge { font-size: 10em; font-weight: bold; text-decoration: underline; }
```

### :compressed

Compressed 输出方式删除所有无意义的空格、空白行、以及注释，力求将文件体积压缩到最小，同时也会做出其他调整，比如会自动替换占用空间最小的颜色表达方式。

```css
#main{color:#fff;background-color:#000}#main p{width:10em}.huge{font-size:10em;font-weight:bold;text-decoration:underline}
```

## 知识结构

![知识结构]( http://img.chensenran.top/1574177707099.jpg )