---
title: BOM
tags:
  - JavaScript
categories: JavaScript高级程序设计
description: window、location、history
abbrlink: 4090752603
date: 2020-03-04 10:40:54
---

# window

> 浏览器的一个实例

1. 全局变量不能通过delete操作符删除，而直接在window对象上定义的属性可以
2. 尝试访问未声明的变量会抛出错误，但是通过查询window对象，可以得到该变量是否存在



* top：始终指向最高层框架，浏览器窗口
* parent：始终指向当前框架的直接上层框架

# 窗口位置

## 窗口相对于屏幕

* window.screenLeft
* window.screenTop

## 窗口大小

* window.outerHeight、window.outerWidth 返回浏览器本身尺寸
* window.innerHeight、window.innerWidth 返回视口（除去边框）的大小
* document.documentElement.clientHeight、document.documentElement.clientWidth 返回DOM可见区域大小（不算滚动条）

## 间歇调用和超时调用

* setTimeout
* setInterval

# 系统对话框

* alert
* confirm
* prompt

* window.print() //打印
* window.find(msg) // 查询

# location

* hash
* host
* hostname
* href
* pathname
* port
* protocol
* search

```js
// URLSearchParams
var paramsString = "q=URLUtils.searchParams&topic=api"
var searchParams = new URLSearchParams(paramsString);

for (let p of searchParams) {
  console.log(p);
}

searchParams.has("topic") === true; // true
searchParams.get("topic") === "api"; // true
searchParams.getAll("topic"); // ["api"]
searchParams.get("foo") === null; // true
searchParams.append("topic", "webdev");
searchParams.toString(); // "q=URLUtils.searchParams&topic=api&topic=webdev"
searchParams.set("topic", "More webdev");
searchParams.toString(); // "q=URLUtils.searchParams&topic=More+webdev"
searchParams.delete("topic");
searchParams.toString(); // "q=URLUtils.searchParams"
```

* assign
* href
* replace // 重定向
* reload // 重新加载

## history

* go
* back
* forward
* length // == 0 检查是否是第一个打开的窗口

