---
title: vue2源码-2-变化侦测
tags:
  - Vue2
  - Vue2源码
categories:
  - Vue2
description: vue2中收集依赖与追踪
abbrlink: 4222516761
date: 2020-02-21 16:52:48
---
# Vue工作机制
![](http://img.chensenran.top/1582276323672.png)
# 依赖收集与追踪
## 发布、订阅模式
![Vue底层原理关系图](http://img.chensenran.top/1582276549906.png)
### Object
![](http://img.chensenran.top/1582276474688.png)
### Array
1. 与Object不同，通过方法来改变内容，所以通过**创建拦截器**去覆盖数组原型实现追踪变化
2. 不污染全局Array.prototype，只针对需要侦听变化的数组，使用__proto__覆盖原型方法
3. 在拦截器中，向依赖发消息，依赖数组保存在Observer实例上
4. \_\_ob__:
    1. 标记数组是否被侦听，并保证只侦听一次
    2. 通过\_\_ob__拿到Observer实例上保存的依赖数组
    
5. 对每个元素都转化响应式并侦听
6. 对push、unshift、splice添加的新数据侦听
7. 无法拦截数组特有语法
8. 可拦截方法：
    * push
    * pop
    * shift
    * unshift
    * splice
    * sort
    * reverse
    
# 编译
简单编译流程：解析器->优化器->代码生成器
![](http://img.chensenran.top/1582277331516.png)

![](http://img.chensenran.top/1582277240344.png)
