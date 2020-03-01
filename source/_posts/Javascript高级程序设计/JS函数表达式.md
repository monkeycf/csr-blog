---
title: JS函数表达式
tags:
  - JavaScript
categories:
  - JavaScript高级程序设计
description: 函数表达式的特征，实现递归、闭包、私有变量
abbrlink: 1592492931
date: 2020-03-01 15:22:43
---

# 函数

1. 函数声明

   **函数提升**：执行代码前会先读取函数声明

   ```javascript
   function functionName(arg0, arg1, arg2) {
     // 函数体
   }
   ```

2. 函数表达式（匿名函数）

   ```javascript
   const functionName = function(arg0, arg1, arg2) {
     // 函数体 
   }
   ```

# 递归

> arguments.callee 指向正在执行的函数的指针

```javascript
// 匿名函数实现
const factorial = (function f(num) {
  if (num <= 1) {
    return 1;
  } else {
    return num * f(num - 1);
  }
});
```

# 闭包

**闭包**：有权访问另一个函数作用域中的变量的函数

**作用域链**：是一个指向变量对象的指针列表，只引用但不实际包含变量对象

![](http://img.chensenran.top/1583051309606.png)

* **闭包**只能取得包含函数中任何变量的最后一个值。

* **this对象**是在运行时基于函数的执行环境绑定的。

* 块级作用域

```javascript
(function(){
  // 块级作用域
})();
```

* 私有变量

  任何在函数中定义的变量，都可以认为是私有变量，包括函数的参数、局部变量和在函数内部定义的其他函数

  1. 在构造函数中定义特权方法

     问题：构造函数针对每个实例都会创建同样一组新方法

     ```javascript
     function MyObject() {
       // 私有变量和私有函数
       let num = 10;
     
       function getIndex() {
         return num;
       }
     
       // 特权方法（公有）
       this.getNumber = function () {
         return num;
       }
     }
     ```

  2. 静态私有变量

     问题：所有实例都共享同一静态属性

     ```javascript
     (function () {
       // 私有变量和私有函数
       let index;
     
       function getIndex() {
         return index;
       }
     
       // 构造函数（全局变量）
       MyObject = function () {
     
       }
     
       //
       MyObject.prototype.publicGetIndex = function () {
         return index;
       }
     })();
     ```

# 模块模式

**单例**：只有一个实例的对象。

```javascript
const singleton = function() {
  // 私有变量和函数
	const components = [];
  components.push('1'); // 初始化
  
  // 公有方法和属性
  return {
    getComponentCount: function(){
      return components.length;
    },
    addComponent: function(component) {
      if (typeof component == "object") {
        components.push(component);
      }
    }
  }
}();
```

# 小结

函数表达式：

* 函数表达式不同于函数声明，注意函数提升

* arguments.callee

闭包有权访问包含函数内部的所有变量。

* 闭包的作用域链包含它自己的作用域、包含函数的作用域和全局作用域
* 通常，函数的作用域及其变量都会在函数执行结束后销毁。但是闭包，这个函数的作用域将会一直存在内存中知道闭包不存在为止。

模仿块级作用域：

* 创建并立即调用一个函数
* 可以使用构造函数模式、原型模式实现自定义类型的特权方法，使用模块模式实现单例的特权方法

