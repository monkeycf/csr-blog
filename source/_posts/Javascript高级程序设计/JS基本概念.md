---
title: JS基本概念
tags:
  - JavaScript
description: 语法、数据类型、流程控制句、函数
categories: JavaScript高级程序设计
abbrlink: 3719758484
date: 2020-02-13 14:39:40
---

## 严格模式

```javascript
"use strict"
```

## 数据类型

* undefined
* boolean
* string
* number
* object
* function

> 注意：

1. Boolean

   ```javascript
   [] == true // false
   !![] == true // true
   ```

2. Number

   * 浮点数最高精度17位

   * ```javascript
     isFinite(num) // boolean num是否位于最小与最大数值之间
     ```

   * NAN

     * isNaN(num)

     * NaN 与任何值不相等

       ```javascript
       NaN == NaN // false
       ```

   * 数值转化

     * Number(num)

       ```javascript
       Number('123a') //NaN
       ```

     * parseInt(num, system)

       ```javascript
       parseInt(num, system) // num：需要转化的值，system：进制
       ```

     * parseFloat(num)

3. String

   * toString(system)

4. Object

   * 实例都具有的属性和方法
     * constructor：保存当前构造函数
     * hasOwnProperty(propetryName)：属性是否属于当前实例，而不在原型链上
     * isPrototypeOf(object)：传入的对象是否属于当前对象的原型
     * propertyIsEnumerable(propetryName)：该属性是否可枚举
     * toLocaleString()
     * toString()
     * valueOf()



## 语句

### label语句

```javascript
let mum = 0;
outermost:
for(let i = 0; i < 10; i++){
    for(let j = 0; j < 10; j++){
        if(j === 5){        
            break outermost;
        }
        num++;
    }
}

console.log(num) // 5
```

### with语句

将代码的作用域设置到一个特定的对象中

with (expression) statement;

## 函数

* arguments
* 不存在函数签名的特性，没有函数重载

