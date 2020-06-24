---
title: JS源码实现
description: JS源码实现
categories: JavaScript
tags:
  - JavaScript
abbrlink: 3789819937
date: 2020-02-27 19:03:01
---
最近面试或多或少要求写一写JS的源码，看了很多博客，在此整理一下。
# 改变this指向
## call
```javascript
/**
 * 模拟call
 * @param {Object} obj
 * @param {*} args
 * @return {*}
 */
Function.prototype.call = function (obj, ...args) {
  if (typeof this !== 'function') {
    throw new Error(`${this} is not function...`);
  }
  
  const _fn = Symbol('_fn'); // 唯一
  obj[_fn] = this;

  const result = obj[_fn](...args); // 调用
  delete obj[_fn];
  return result;
}
```
## apply
> apply和call的区别在于传参的方式不同，apply第二个参数为数组

```javascript
/**
 * 模拟apply方法
 * @param {Object} obj
 * @param {Array} args
 * @return {*}
 */
Function.prototype.$apply = function (obj, args = []) {
  if (typeof this !== 'function') {
    throw new Error(`${this} is not function...`);
  }
  
  const _fn = Symbol('_fn');
  obj[_fn] = this;
  
  const result = obj[_fn](...args);
  delete obj[_fn];
  return result;
}
```

## bind
* 作为构造函数，new绑定的优先级高于显示绑定和硬绑定

```javascript
/**
 * 模拟bind方法
 * @param {Object} obj
 * @param {*} args
 * @return {function}
 */
Function.prototype.bind = function (obj, ...args) {
  if (typeof this !== 'function') {
    throw  new Error(`${this} is not function...`);
  }

  const self = this;
  const Fun = function () {} // 用于保存原函数的原型
  const bound = function (...funArgs) {
    return self.call(
      this instanceof Fun ? this : obj, // 判断是否 new 调用
      ...args,
      ...funArgs
    )
  }

  Fun.prototype = self.prototype;
  bound.prototype = new Fun(); // 修改绑定函数的原型
  return bound;
}
```

# reduce
> array.reduce(function(total, currentValue, currentIndex, arr), initialValue)

```javascript
/**
 * 模拟reduce实现
 * @param {function} cb
 * @param {*} initialValue
 * @return {Array|*}
 */
Array.prototype.reduce = function (cb, initialValue) {
  if (typeof cb !== 'function') {
    throw TypeError(`${cb} is not function...`);
  }
  if (this.length === 0) {
    return this;
  }

  let pre = arguments.length < 2 ? this[0] : initialValue;
  // 循环遍历，每一项都调用函数
  this.forEach((item, index, array) => {
    pre = cb(pre, item, index, array);
  })
  return pre;
}
```

# new
1. 创建新对象
2. 修改作用域
3. 运行构造函数
4. 返回新对象或构造函数返回结果
```javascript
/**
 * 模拟new
 * @param {function} constructor
 * @param {*}args
 * @return {*}
 */
function myNew(constructor, ...args) {
  const obj = {}; // 创建对象
  obj.__proto__ = constructor.prototype; // 继承，访问构造器属性
  const result = constructor.apply(obj, args);

  // 如果构造函数返回的是引用类型，则返回该引用类型
  return typeof result === 'object'
    ? result
    : obj;
}
```

# Object.create

```javascript
/**
 * Object.create实现
 * @param prototype
 * @param properties
 * @return {Object}
 */
Object.create = function (prototype, properties) {
  function F() {
  }

  F.prototype = properties;
  const obj = new F();

  if (properties) {
    Object.defineProperties(obj, properties);
  }
  return obj;
}
```

# extend

```javascript
/**
 * 继承实现
 * @param child
 * @param parent
 */
function $extend(child, parent) {
  // 改变__proto__
  Object.setPrototypeOf(child, parent);

  function _fun() {
    this.constructor = child;
  }

  child.prototype =
    parent === null
      ? Object.create(null)
      : ((_fun.prototype = parent.prototype), new _fun());
}
```

# instanceof
```javascript
function instanceOf(obj, target) {
  obj = Object.getPrototypeOf(obj);
  while (obj) {
    if (target.prototype === obj) {
      return true;
    }
    obj = Object.getPrototypeOf(obj);
  }
  return false;
}
```

# Promise.all

```javascript
Promise.all = function(promiseArray) {
    let count = 0;
    const len = promiseArray.length
    const result = new Array(len).fill(null);
    return new Promise((resolve, reject) => {
      promiseArray.forEach((p, index) => {
        p.then((res) => {
          result[index] = res;
          count++;
          if (count === len) {
            resolve(result);
          }
        })
      }).catch(err => reject(err))
    })
  }
```
# Promise.all 并发控制
```javascript
/**
 * 实现并发控制
 * @param limitCount 并发上限
 * @param array 请求参数
 * @param fun 处理函数
 * @return {Promise}
 */
function asyncPool(limitCount, array, fun) {
  const loading = [] // 正在请求数组
  const res = []; // 结果数组

  function queue() {
    // 递归判断
    if (array.length === 0) {
      return Promise.resolve();
    }
    const item = Promise.resolve().then(() => fun(array.shift()));
    res.push(item);
    const e = item.then(() => {
      loading.splice(loading.indexOf(e), 1); // 请求结束,删除元素
    })
    loading.push(e);
    let t = Promise.resolve();
    if (loading.length >= limitCount) {
      t = Promise.race(loading); // 达到并发上限,等待最先返回
    }
    return t.then(() => queue());
  }

  return queue().then(() => Promise.all(res))
}
```