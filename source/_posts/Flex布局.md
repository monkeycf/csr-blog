---
title: Flex布局
tags:
  - Flex
categories:
  - CSS
description: Flex布局相关属性及用法
abbrlink: 2875753233
date: 2020-02-21 21:52:06
---

# Flex布局

![](http://img.chensenran.top/1582300462845.jpg)

## 容器属性

### flex-direction

> 主轴方向。

* row : 从左向右
* row-reverse : 从右向左
* column : 从上向下

* column-reverse : 从下向上

### flex-wrap

> 单行或者多行，是否允许换行

* nowrap : 不换行
* wrap : 第一行在上方
* wrap-reverse : 第一行在下方

### flex-flow

> flex-direction | flex- wrap 简写

### justify-content

> 主轴对齐方式

* flex-start : 左对齐
* flex-end : 右对齐
* center : 居中
* space-between : 两端对齐，中间间隔相等
* space-around : 每个项目两侧的间隔相等，所以项目之间的间隔比边缘大一倍

### align-items

> 交叉轴上的对齐方式

* stretch : 充满（默认）
* flex-start : 起点对齐
* flex-end : 终点对齐
* center : 中点对齐
* baseline : 第一行文字底部为基准线

### align-content

> 多跟轴线对齐方式

* stretch : 充满（默认）
* flex-start : 起点对齐
* flex-end : 终点对齐
* center : 中点对齐
* space-between : 轴线两端对齐，中间间隔相等
* space-around : 每个项目两侧的间隔相等，所以项目之间的间隔比边缘大一倍

## 项目属性

### order

> 定义项目排列顺序

### flex-basis

> 定义了在分配多余空间之前，项目占据的主轴空间，浏览器根据这个属性，计算主轴是否有多余空间

### flex-grow

> 定义项目的放大比例

* 默认值为 0，即如果存在剩余空间，也不放大 

* 如果所有项目的 flex-grow 属性都为 1，则它们将等分剩余空间。

* 如果一个项目的 flex-grow 属性为 2，其他项目都为 1，则前者占据的剩余空间将比其他项多一倍。

### flex-shrink

> 定义了项目的缩小比例

*  默认值: 1，即如果空间不足，该项目将缩小，负值对该属性无效。 
*  如果一个项目的 flex-shrink 属性为 0，其他项目都为 1，则空间不足时，前者不缩小。 

### flex

> flex-grow , flex-shrink, flex-basis 缩写

* flex 的默认值是 0 1 auto 
* auto ：1 1 auto
* none：0 0 auto

### align-self

> 单个项目与其他项目不一样的对齐方式

* align-self: auto | flex-start | flex-end | center | baseline | stretch;