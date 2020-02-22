---
title: Grid布局
tags:
  - Grid
categories:
  - CSS
description: Grid布局相关属性及用法
abbrlink: 3615068729
date: 2020-02-22 22:46:33
---

# Grid布局

![](http://img.chensenran.top/1582385835420.png)

## 容器属性

### display

* grid
* inline-grid
* subgrid : 嵌套

### grid-template-columns / grid-template-rows

> 定义轨道大小和线名

* [line-name line-name-second] \<tarck-size> [line-name]
* repeat(num, value) : 重复部分
  * repeat(auto-fill, 100px) : 单元格宽度确定，容器不确定。auto-fill：尽可能多的排列
* fr : 设置为自由空间的一部分
* minmax(minValue, maxValue) : 产生长度的范围
* auto : 浏览器决定

### grid-template-areas

> 重复网格区域的名称，扩展到这些单元格。（grid-area 引用名称）

* '\.' : 空单元
* 'none' : 没有定义网格的区域

### grid-template

> grid-template-columns 、grid-template-rows、grid-template-areas 简写

* none : 初始值

* subgrid : grid-template-columns 、grid-template-rows为subgrid，grid-template-areas为初始值

* grid-template-rows / grid-template-columns

  ```css
  grid-template: [header-left] "head head" 30px [header-right]
                 [main-left]   "nav  main" 1fr  [main-right]
                 [footer-left] "nav  foot" 30px [footer-right]
                 / 120px 1fr;
  ```

### column-gap / row-gap

> 网格线的大小，行列的间距

* \<number>

###  gap

> \<row-gap> / \<column-gap>简写

### justify-items / align-items / place-items

* jusify-items : 项目的水平位置

![](http://img.chensenran.top/1582384374826.png)

* align-items : 项目的垂直位置

![](http://img.chensenran.top/1582384444138.png)



* place-items

  > \<align-items> 和 \<justify-items> 缩写

可选值为：

* start
* end
* center
* stretch

### justify-content / align-content / place-content

* justify-content : 表格的水平位置

![](http://img.chensenran.top/1582384766966.png)

* align-content : 表格的垂直位置

* place-content

  > \<align-content> 和 \<justify-content> 简写

可选值为：

* start
* end
* center
* space-between
* space-around
* space-evenly

### grid-auto-columns / grid-auto-rows

> 隐式网格大小，和 grid-template-columns 、grid-template-rows 用法相同

### grid-auto-flow

> 容器放置的顺序

* row  \<dense>
* column \<dense>

下图为 grid-auto-flow : column

![](http://img.chensenran.top/1582385208388.png)



下图为 grid-auto-flow : column dense

![](http://img.chensenran.top/1582385281591.png)

### grid

*  \<grid-template> 
* \<grid-template-rows> / [ auto-flow && dense? ] \<grid-auto-columns>?
* [ auto-flow && dense? ] \<grid-auto-rows>? / \<grid-template-columns>

## 项目属性

### grid-column-start / grid-column-end / grid-row-start / grid-row-end

> griditem 的起始位置

* \<line> : 线名字
* span \<number> : 跨越指定数量的网格
* span \<name> : 跨域网格，直到指定的网格线
* auto

### grid-column / grid-row

> grid-column : 为 grid-column-start / grid-column-end 简写
>
> grid-row : 为 grid-row-start / grid-row-end 简写

### grid-area

> 放置在哪个区域内

* \<name> : 与 grid-template-area 内设置的值相对应 或与grid-column 、grid-row 一起确定

### justify-self / align-self

> 单元格内的位置

* start
* end
* center
* stretch