---
title: DOM
categories: JavaScript高级程序设计
description: 尽量减少DOM操作
tags:
  - DOM
abbrlink: 4150170345
date: 2019-11-04 10:40:04
---
## node 类型
JavaScript中所有节点类型都继承于Node类型，因此所有节点类型都共享着相同的基本属性和方法。

1. nodeName 和 nodeValue属性
2. 节点关系
**NodeList不是Array的实例，是有生命、有呼吸的对象。**
3. parentNode属性指向文档树中的父节点。
4. hasChildNodes() 查询该节点是否包含一个或多个子节点
5. appendChild() 向childNodes列表的末尾添加一个节点
6. insertBefore() 
```javascript
let returnedNode = someNode.insertBefore(newNode,someNode.lastChild);
```
7. replaceChild() 替换节点
8. removeChild()
9. cloneNode() // true 深拷贝，false 浅拷贝

## 寻找元素
* getElementById()
* getElementsByTagName() 获得 HTMLCollection对象，通过 namedItem() 根据name特性取得集合中的项

## 取得特性
* getAttribute()
* setAttribute()
* removeAttribute()

# 小结
![小结1](http://img.chensenran.top/1572839285302.png)
![小结2](http://img.chensenran.top/1572839341114.png)

