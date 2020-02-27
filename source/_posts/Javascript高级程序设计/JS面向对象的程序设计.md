---
title: JS面向对象的程序设计
tags:
  - JavaScript
description: 对象属性、创建对象、继承
categories: JavaScript高级程序设计
abbrlink: 664560717
date: 2020-02-27 10:02:53
---

# 属性类型

## 数据属性

* [[Configurable]]：是否可以通过delete删除属性，能否修改属性特征
* [[Enumerable]]：能否用过for-in循环返回属性
* [[Writable]]：是否修改属性的值
* [[Value]]：包含属性的数据值

## 访问器属性

* [[Configurable]]：是否可以通过delete删除属性，能否修改属性特征
* [[Enumerable]]：能否用过for-in循环返回属性
* [[Get]]：读取属性时调用的函数
* [[Set]]：写入属性时调用的函数

## 定义读取属性

```javascript
Object.defineProperty(obj, "name", {})
Object.defineProperties(obj, {
  "name": {}
});
Object.getOwnPropertyDescriptor(obj, "name")
```

# 创建对象

## 工厂模式

用函数封装特定接口创建对象的细节，但是无法识别对象

```javascript
function createPerson(name, age, job) {
  return {
    name,
    age,
    job,
    getName() {
      return this.name;
    }
  };
}
```

## 构造函数模式

调用构造函数的过程：

1. 创建一个新对象
2. 将构造函数的作用域赋给新对象（所以this就指向了该对象）
3. 执行构造函数
4. 返回新对象

构造函数模式的问题：

1. 不同实例上的同名函数是不相等的

```javascript
function Person(name, age) {
  this.name = name;
  this.age = age;
  this.getName = () => this.name;
}
```

## 原型模式

可以让所有对象实例共享所含的属性和方法

![](http://img.chensenran.top/1582772357763.png)

![](http://img.chensenran.top/1582772435935.png)

如图所示，实例的\__proto__属性指向他的构造函数的prototype。

* 通过Object.getPrototypeOf(obj)可以返回这个对象的原型。

* 通过Object.hasOwnProperty("name")可以检测一个属性是否存在该实例中，而不是在原型中。

* 通过Object.keys()可以取得随向上所有可枚举的实例属性。

原型模式的问题：

* 省略了为构造函数传参的过程，所有实例默认情况下将取得相同的属性值
* 共享的本性（特别对包含引用类型值的属性）

```javascript
function City() {
}

City.prototype.name = 'HANGZHOU';
City.prototype.getName = function () {
  return this.name;
}

// 更简单的原型语法
function City() {
}

City.prototype = {
  name: 'HANGZHOU',
  getName() {
    return this.name;
  }
}
Object.defineProperty(City.prototype, "constructor", {
  enumerable: false,
  value: City
})
```

## 组合使用构造函数和原型模式

构造函数模式用于定义实例属性，原型模式用于定义方法和共享属性

```javascript
function City(name) {
  this.name = name;
}

City.prototype.getName = function () {
  return this.name;
}
```

## 动态原型模式

```javascript
function City(name) {
  this.name = name;
  if (typeof this.getName === 'undefined') {
    // 此处不能使用对象字面量重写
    City.prototype.getName = function () {
      return this.name;
    }
  }
}
```

## 寄生构造函数模式

创建一个函数，该函数的作用仅仅是封装创建对象的代码，然后在返回新创建的对象。

问题：构造函数返回的对象与构造函数外部创建的对象没有什么不同，所以不能依赖instanceof来确定对象类型

```javascript
function SpecialArray(...arr) {
  const values = [];
  values.push.apply(values, arr);
  values.toPipedString = function () {
    return this.join('|');
  }
  return values;
}
```

## 稳妥构造函数模式

**稳妥对象**：没有公共属性，并且方法也不引用this的对象（安全性） 

稳妥构造函数与寄生构造函数类似，但有两点不同：

* 新创建对象的实例方法不引用this
* 不适用new操作符调用构造函数

```javascript
// 稳妥构造函数
function Person(name) {
  const o = {};
  // 可以在这里定义私有变量和函数
  o.getName = function () {
    return name;
  }
  return o;
}

const tom = Person('Tom')
console.log(tom.getName()); // 除了通过getName方法，其他方法都不能访问name属性
```

# 继承

## 原型链

利用原型让一个引用类型继承另一个引用类型的属性和方法。

![](http://img.chensenran.top/1582785916295.png)

问题：

* 主要问题是包含引用类型值的原型
* 在创建子类型的实例时，不能想超类型的构造函数中传递参数

```javascript
function SuperType() {
  this.name = 'super';
}

SuperType.prototype.getName = function () {
  return this.name;
};

function SubType() {
  this.subName = 'sub';
}

SubType.prototype = new SuperType(); // 子类的原型为 父类的实例

SubType.prototype.getSubName = function () {
  return this.subName;
}
```

## 借用构造函数

问题：

* 方法都在构造函数中定义，因此函数复用就无从谈起
* 在父类的原型中定义的方法，对于子类是不可见的。必须所有类都采用构造函数模式

```javascript
function SuperType(name) {
  this.arr = [1, 2];
  this.name = name;
}

function SubType(name) {
  SuperType.call(this, name);
}
```

## 组合继承

使用原型链实现对原型属性和方法的继承，解用构造函数来实现对实例属性的继承。

问题：会调用两次父类的构造函数

```javascript
function SuperType(name) {
  this.name = name;
}

SuperType.prototype.getName = function () {
  return this.name;
}

function SubType(name) {
  SuperType.call(this, name); // 第二次调用
}

SubType.prototype = new SuperType();
SubType.prototype.constructor = SubType; // 第一次调用
```

## 原型式继承

```javascript
function object(o)　{
  function F(){}
  F.prototype = o;
  return new F();
}
// Obejct.create()
```

**包含引用类型值的属性始终都会共享响应的值**（浅复制）

## 寄生式继承

```javascript
function createAnother(o){
  const clone = Object.create(o);
  clone.say = function(){
    return 'hi';
  }
  return clone;
}
```

## 寄生组合式继承

通过构造函数来继承属性，通过原型链的混成形式来继承。

不必为了指定子类型的原型而调用超类型的构造函数，使用寄生式继承超类型的原型。

```javascript
function SuperType(name) {
  this.name = name;
}

SuperType.prototype.getName = function () {
  return this.name;
}

function SubType(name) {
  SuperType.call(this, name);
}

SubType.prototype = Object.create(SuperType.prototype);
SubType.prototype.constructor = SubType;
```