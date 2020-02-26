---
title: JS引用类型
tags:
  - JavaScript
description: 使用对象、创建并操作数组、理解基本的Javascript类型、使用基本类型和基本包装类型
categories: JavaScript高级程序设计
abbrlink: 60633937
date: 2020-02-26 09:44:54
---

# Object类型

```javascript
const obja = new Object();
const objb = {};
```

# Array类型

```javascript
const arra = new Array(20);
const arrb = []; 
```

length属性：不是只读的，可修改。

## 检测数组

```javascript
if (Array.isArray(arr)){
  // do some
}
```

## 方法

* join()
* push()
* pop()

* push()
* unshift()

* shift()

* reverse()
* sort() => 升序
* concat()
* slice()
* splice() => 删除的元素
* indexOf()
* lastIndexOf()
* every() => 每一项true，则true
* filter() => 返回true的元素数组
* forEach()
* map() => 调用结果组成的新数组
* some() => 某一项true，则true
* reduce()
* reduceRight()

# Date类型

* Date.parse()
* Date.now()
* getTime()
* getFullYear()
* getMonth()
* getDate()
* getDay()
* getHours()
* getMinutes()
* getSeconds()
* getMillseconds()

# RegExp类型

标志：

* g：全部
* i：不区分大小写
* m：多行模式

方法：

* exec()
* test()

# Function类型

由于函数是对象，因此函数名实际上是一个指向函数对象的指针，不会与某个函数绑定

**没有重载！！！**

* 函数声明：解析器会率先读取函数声明，并使其在执行任何代码前可用（函数声明提升）
* 函数表达式：必须等到解析器执行到它所在的代码才会被解析

## 内部属性

* arguments
  * arguments.callee
  * arguments.caller
* this

## 属性和方法

* length：希望接受的命名参数个数
* prototype：保存所有实例方法的真正所在
* call()
* apply()
* bind()

# 基本包装类型

* Number
* Boolean
* String

```javascript
let s1 = "some";
let s2 = s1.substring(2);
```

1. 创建一个string类型的一个实例
2. 在实例上调用指定的方法
3. 销毁这个实例

基本包装类型的对象，只存于一行代码的执行瞬间，然后立即销毁。

可以显示调用创建基本包装类型的对象，且type 的值为object

## Number

* toString() // 转进制
* toFixed()
* toExponential()
* toPrecision()

## String

* length
* charAt()
* charCodeAt()
* concat()
* slice()
* substr()
* substring()
* indexOf()
* lastIndexOf()
* trim()
* toLowerCase()
* toUpperCase()
* match()
* search()
* replace()
* split()
* localeCompare()
* fromCharCode

# 单体内置对象

## Global

* isNaN()
* isFinite()
* parseInt()
* parseFloat
* encodeURI()
* encodeURIComponent()
* decodeURI()
* decodeURIComponent()
* eval()
* window

## Math

* min()
* max()
* ceil()
* floor()
* round()
* random() => [0, 1)
