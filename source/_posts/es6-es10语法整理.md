---
title: es6-es10语法整理
description: ES6-ES10 JavaScript语法整理
categories: JavaScript
tags:
  - es6-es10
  - JavaScript
abbrlink: 3122517155
date: 2019-10-30 10:40:59
---
# ES6
## 类

``` javascript
//类
class Animal {
  // constructor 构造函数
  constructor(name, color) {
    this.name = name;
    this.color = color;
  }

  toString() {
    console.log(`name: ${this.name}, color: ${this.color}`);
  }
}

let animal = new Animal('dog', 'black');
animal.toString(); // name: dog, color: black

console.log(animal.hasOwnProperty('name')); // true
console.log(animal.hasOwnProperty('color')); // true
console.log(animal.__proto__.hasOwnProperty('toString')); // true

// 类的继承
class Cat extends Animal {
  constructor(action) {
    super('cat', 'white');
    this.action = action;
  }

  toString() {
    super.toString();
  }
}

let cat = new Cat('run');
cat.toString(); // name: cat, color: white

console.log(cat instanceof Cat); // true
console.log(cat instanceof Animal); // true
```

## 模块化

**ES6允许在一个模块中使用export来导出多个变量或函数。**

```javascript
// 导出
export let name = 'Tom';
export const sqrt = Math.sqrt;
export {name, sqrt};

export function fun() {
  return 'hello';
}

// 导入
import {name} form 'dome'
```

## 箭头函数

**注意this**
```javascript
(() => 1)
(v => v + 1)
((a, b) => a + b)
(() => {
  alert("hello");
})
(e => {
  return !e
})
```
## 设置默认值
```javascript
((a, b = 10) => a + b)
```

## 模板字符串
```javascript
let str = `name is ${name}`;
```

## 解构
```javascript
let foo = ["one", "two", "three", "four"];
let [one, two, ...dome] = foo
console.log(one, two, dome) // one two [ 'three', 'four' ]

// 交换
console.log(one, two);
([one, two] = [two, one]);
console.log(one, two);

const student = {
  stuName: 'Tom',
  age: 20
}
const {stuName, age} = student;
console.log(stuName, age)
```

## 延展操作符
```javascript
let arr1 = [0, 1, 2],
  arr2 = [4, 5, 6];
let arr3 = [...arr1, ...arr2];
let obj1 = {name: 'Tome'},
  obj2 = {name: 'Sam'};
let obj3 = {...obj1, ...obj2};
```

## 对象属性简写
```javascript
const t1 = 'hello', t2 = 2;
const objDome = {
  t1, t2
}
```

## Promise
```javascript
let waitSecond = new Promise((resolve, reject) => {
  setTimeout(resolve, 1000)
})
waitSecond
  .then(() => {
    console.log('hello')
    return waitSecond;
  })
  .then(() => {
    console.log('hi')
  })
  .catch((e) => console.error(e))
  .finally(() => console.log('finally'))
```


## let 和 const

# ES7
## Array.prototype.includes()
```javascript
let arr = [6, 2, 5];
console.log(arr.includes(6, 1)); //  false 从下表1开始寻找6
```

## 幂指数运算
```javascript
console.log(2 ** 10); // 1024
```

# ES8
## async await
```javascript
async function process(array) {
  for await (let i of array) {
    console.log(i)
  }
}
```
## Object.values()
```javascript
const obj = {
  a: 1,
  b: 2,
  c: 3,
}
const value = Object.values(obj);
console.log(value); // [ 1, 2, 3 ]
```
## Object.entries()
```javascript
for (let [key, value] of Object.entries(obj)) {
  console.log(`key:${key},value:${value}`)
}
```

## String padding
```javascript
// String.prototype.padStart
// String.padStart(targetLength,[padString])
console.log('0.0'.padStart(5, '12')) // 120.0
console.log('0.0'.padStart(10)) //        0.0 ,参数省略为空格

// String.prototype.padEnd
// String.padEnd(targetLength,padString])
console.log('0.0'.padEnd(5, '1')) // 0.011
console.log('0.0'.padEnd(5)) // 0.0     ,参数省略为空格
```

## 函数参数列表结尾允许逗号

## Object.getOwnPropertyDescriptors()
> 用来获取一个对象的所有自身属性的描述符,如果没有任何自身属性，则返回空对象。
```javascript
const obj2 = {
  name: 'Tom',
  getName(){
    return this.name;
  }
}

console.log(Object.getOwnPropertyDescriptors(obj2))
/*
{ name:
   { value: 'Tom',
     writable: true,
     enumerable: true,
     configurable: true },
  getName:
   { value: [Function: getName],
     writable: true,
     enumerable: true,
     configurable: true } }
 */
```

## SharedArrayBuffer对象
> SharedArrayBuffer 对象用来表示一个通用的，固定长度的原始二进制数据缓冲区，类似于 ArrayBuffer 对象，它们都可以用来在共享内存（shared memory）上创建视图。与 ArrayBuffer 不同的是，SharedArrayBuffer 不能被分离。

## Atomics对象
详见 [MDN](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Atomics)

# ES9
## 异步迭代
```javascript
const fun = async (arr) => {
  for await (let i of arr) {
    console.log(i)
  }
}
```
## Promise.finally()
> finally()允许你指定最终的逻辑

## Rest/Spread 属性
> 可以使用扩展运算符拷贝一个对象，像是这样 obj2 = {...obj1}，但是 这只是一个对象的浅拷贝。另外，如果一个对象A的属性是对象B，那么在克隆后的对象cloneB中，该属性指向对象B。

## 正则表达式命名捕获组
```javascript
const reDate = /(?<year>[0-9]{4})-(?<month>[0-9]{2})-(?<day>[0-9]{2})/,
  match = reDate.exec('2019-10-30'),
  {year, month, day} = match.groups
console.log(year, month, day) // 2019 10 30
console.log(('2019-10-30').replace(reDate, `${month}-${day}-${year}`)); // 10-30-2019
```

## 正则表达式反向断言
```javascript
// 肯定反向断言
const reLookbehind = /(?<=\D)\d+/,
  match1 = reLookbehind.exec('$123.89');
console.log(match1[0]); // 123
// 否定反向断言
const reLookBehindNeg = /(?<!\D)\d+/,
  match2 = reLookBehindNeg.exec('$123.89');
console.log(match2[0]) // 23
```

## 正则表达式dotAll模式
```javascript
console.log(/hello.world/.test('hello\nworld')); // false
console.log(/hello.world/s.test('hello\nworld')); // true
```

## 正则表达式 Unicode 转义
> 此特性可以避免使用特定 Unicode 区间来进行内容类型判断，提升可读性和可维护性.
```javascript
const reGreekSymbol = /\p{Script=Greek}/u;
console.log(reGreekSymbol.test('π')); // true
```

## 非转义序列的模板字符串

# ES10

## 行分隔符（U + 2028）和段分隔符（U + 2029）符号现在允许在字符串文字中，与JSON匹配
> 以前，这些符号在字符串文字中被视为行终止符，因此使用它们会导致SyntaxError异常。


## 更加友好的 JSON.stringify
> 如果输入 Unicode 格式但是超出范围的字符，在原先JSON.stringify返回格式错误的Unicode字符串。现在实现了一个改变JSON.stringify的第3阶段提案，因此它为其输出转义序列，使其成为有效Unicode（并以UTF-8表示）

## Array的 flat()方法和 flatMap()方法 
> node -v >= 11
```javascript
/*
 * flat()和 flatMap()本质上就是是归纳（reduce） 与 合并（concat）的操作。
 * Array.prototype.flat()
 * flat() 方法会按照一个可指定的深度递归遍历数组，并将所有元素与遍历到的子数组中的元素合并为一个新数组返回。
 */
let arr1 = [1, 2, [3, 4]];
console.log(arr1.flat());// [ 1, 2, 3, 4 ] 默认值是 1
let arr2 = [1, 2, [3, 4, [5, 6, [7, 8, [9, 10]]]]];
console.log(arr2.flat(Infinity));// [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
// flatMap() 方法首先使用映射函数映射每个元素，然后将结果压缩成一个新数组。它与 map 和 深度值1的 flat 几乎相同，但 flatMap 通常在合并成一种方法的效率稍微高一些。这里我们拿map方法与flatMap方法做一个比较。
let arr3 = ["今天天气不错", "", "早上好"]
arr3.flatMap(s => s.split(''));// ["今", "天", "天", "气", "不", "错", "早", "上", "好"]
```

## trimStart()方法和 trimEnd()方法
```javascript
let str = '   123 ';
console.log(str.trimStart(), str.trimEnd());
```

## Object.fromEntries() (node -v >= 12)
> Object.fromEntries() 是 Object.entries() 的反转。
```javascript
const entries = new Map([
  ['foo', 'bar'],
  ['baz', 42]
]);

console.log(Object.fromEntries(entries));
```

## Symbol.prototype.description() 
> node 暂未实现

## String.prototype.matchAll
> 方法返回一个包含所有匹配正则表达式及分组捕获结果的迭代器。
```javascript
const str1 = 'table football, foot';
const matches = str1.matchAll(new RegExp('foo*', 'g'));
console.log(Array.from(matches, m => m[0]));
```

## Function.prototype.toString()现在返回精确字符，包括空格和注释

## 修改 catch 绑定，catch可无参数 
> node暂未实现
```javascript
/*
 * try {
 * } catch () {
 * }
 */
```

## 新的基本数据类型 BigInt 
> node -v >= 10.4 
> 更多详见 [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt)


```javascript
const theBiggestInt = 9007199254740991n;

const alsoHuge = BigInt(9007199254740991);
// ↪ 9007199254740991n

const hugeString = BigInt("9007199254740991");
// ↪ 9007199254740991n

const hugeHex = BigInt("0x1fffffffffffff");
// ↪ 9007199254740991n

const hugeBin = BigInt("0b11111111111111111111111111111111111111111111111111111");
// ↪ 9007199254740991n
```

## globalThis 可以获取全局对象。
> node -v >= 12
```javascript
(function () {
  console.log(this === globalThis);
}())
```

## import() 可动态导入，分配给变量

## Legacy RegEx（暂未解决）

## 私有的实例方法和访问器（暂未解决）
