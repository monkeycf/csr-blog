---
title: vue2源码-4-变化侦测相关的API实现原理
tags:
  - vue2
  - vue2
description: vue2变化侦测相关的API实现原理,watch/set/delete
categories: vue2源码
abbrlink: 429737347
date: 2020-01-21 13:22:18
---

# vm.$watch

- vm.$watch( expOrFn, callback, [options])

- **参数**：

  - {string | Function} expOrFn
  - {Function | Object} callback
  - {Object} [options]
    - {boolean} deep *（发现对象内部值的变化）*
    - {boolean} immediate*（ 立即以表达式的当前值触发回调，例：父组件给子组件 传值，最初绑定值时也执行函数）*

- **返回值**：{Function} unwatch

- **用法**：

  观察 Vue 实例上的一个表达式或者一个函数计算结果的变化。回调函数得到的参数为新值和旧值。表达式只接受监督的键路径。对于更复杂的表达式，用一个函数取代。

## watch的内部原理

> vm.$watch其实是对Watcher的的一种封装

```javascript
// src/core/instance/state.js 
Vue.prototype.$watch = function (
    expOrFn: string | Function,
    cb: any,
    options?: Object
  ): Function {
    const vm: Component = this
    if (isPlainObject(cb)) {
      return createWatcher(vm, expOrFn, cb, options)
    }
    options = options || {}
    options.user = true
    // 创建一个新的Watcher
    const watcher = new Watcher(vm, expOrFn, cb, options)
    if (options.immediate) {
      try {
        cb.call(vm, watcher.value)
      } catch (error) {
        handleError(error, vm, `callback for immediate watcher "${watcher.expression}"`)
      }
    }
    // 返回一个取消观察数据的函数
    return function unwatchFn () {
      // 把watcher实例从当前正在观察的状态的依赖列表中删除
      watcher.teardown()
    }
  }
}
```

> 在dep（依赖列表）中收集每个watcher，同时在watcher中记录被添加到哪几个dep

![Watcher 和 Dep的关系](http://img.chensenran.top/1579590815841.png)

* watcher和dep多对多的关系
  * 如果watcher中的expOrFn参数是一个表达式，那么肯定只收集一个Dep
  * 如果Watcher中的expOrFn参数是一个函数，此时如果该函数中使用了多个数据，那么这时的Watcher就被多个Dep收集

### deep参数原理

> 触发当前这个被监听数据的收集依赖的逻辑之外，还要把当前监听的这个值在内的所有子值都触发一遍收集逻辑

// src/core/observer/watcher.js

![]( http://img.chensenran.top/1579592927649.png )

**traverse()必须在popTarget()**

```javascript
const seenObjects = new Set()

/**
 * Recursively traverse an object to evoke all converted
 * getters, so that every nested property inside the object
 * is collected as a "deep" dependency.
 */
export function traverse (val: any) {
  _traverse(val, seenObjects)
  seenObjects.clear()
}

function _traverse (val: any, seen: SimpleSet) {
  let i, keys
  const isA = Array.isArray(val)
  /**
   * Object.isFrozen(obj)
   * 是否已经被冻结，（详见MDN，与不可扩展 Object.isExtensible(obj) 的区别）
   */
  // 判断是否为Array和Object，或者是否已经被冻结
  if ((!isA && !isObject(val)) || Object.isFrozen(val) || val instanceof VNode) {
    return
  }
  // 拿到dep的id，确保不会重复收集依赖
  if (val.__ob__) {
    const depId = val.__ob__.dep.id
    if (seen.has(depId)) {
      return
    }
    seen.add(depId)
  }
  if (isA) {
    // 如果是数组，则循环数组。数组中每个元素都进行收集
    i = val.length
    while (i--) _traverse(val[i], seen)
  } else {
    // 如果是object，对每个key的value都进行收集
    /**
     * 重点：traverse必须要在popTarget前
     * val[keys[i]]会触发getter，也就是会触发收集依赖的操作。此时 Dep.target 还没有被清空，所以当前的watcher会被收集。
     * 也就是key的dep收集了当前Object的Watcher，以实现key对应的value改变，当前Watcher会更新。
     */
    keys = Object.keys(val)
    i = keys.length
    while (i--) _traverse(val[keys[i]], seen)
  }
}
```

# vm.$set

* vm.$set( target, propertyName/index, value )

- 参数**：

  - {Object | Array} target
  - {string | number} propertyName/index
  - {any} value

- **返回值**：设置的值。

- **用法**：

  向响应式对象中添加一个属性，并确保这个新属性同样是响应式的，且触发视图更新。它必须用于向响应式对象上添加新属性，因为 Vue 无法探测普通的新增属性 (比如 `this.myObject.newProperty = 'hi'`)

> vm.$set的具体实现其实在observer中抛出的set方法

![](http://img.chensenran.top/1579596746652.png)

```javascript
// src/core/observer/index.js
/**
 * Set a property on an object. Adds the new property and
 * triggers change notification if the property doesn't
 * already exist.
 */
export function set (target: Array<any> | Object, key: any, val: any): any {
  if (process.env.NODE_ENV !== 'production' &&
    (isUndef(target) || isPrimitive(target))
  ) {
    warn(`Cannot set reactive property on undefined, null, or primitive value: ${(target: any)}`)
  }
  // 对数组的处理
  if (Array.isArray(target) && isValidArrayIndex(key)) {
    // 判断新的下标值是否超出数组长度
    target.length = Math.max(target.length, key)
    target.splice(key, 1, val)
    return val
  }
  // 如果key存在已被侦测的Object中，则直接修改key对应的值
  if (key in target && !(key in Object.prototype)) {
    target[key] = val
    return val
  }
  const ob = (target: any).__ob__
  /**
   * 使用target._isVue来判断target是否是Vue.js实例
   * 使用ob.vmCount判断是不是跟数据对象
   */
  if (target._isVue || (ob && ob.vmCount)) {
    process.env.NODE_ENV !== 'production' && warn(
      'Avoid adding reactive properties to a Vue instance or its root $data ' +
      'at runtime - declare it upfront in the data option.'
    )
    return val
  }
  if (!ob) {
    target[key] = val
    return val
  }
  // 将新增属性转化成getter/setter的形式
  defineReactive(ob.value, key, val)
  ob.dep.notify()
  return val
}
```

# Vue.delete

- Vue.delete( target, propertyName/index )

- 参数**：

  - {Object | Array} target
  - {string | number} propertyName/index

- **用法**：

  删除对象的属性。如果对象是响应式的，确保删除能触发更新视图。这个方法主要用于避开 Vue 不能检测到属性被删除的限制，但是你应该很少会使用它。

## 手动更新

> 使用delete，手动更新dep

```javascript
delete this.obj.a
this.obj.__ob__.dep.notify() // 手动向依赖发送变化通知
```

## 原理

> vm.$delete的具体实现其实在observer中抛出的del方法

![](http://img.chensenran.top/1579599021815.png)

```javascript
/**
 * Delete a property and trigger change if necessary.
 */
export function del (target: Array<any> | Object, key: any) {
  if (process.env.NODE_ENV !== 'production' &&
    (isUndef(target) || isPrimitive(target))
  ) {
    warn(`Cannot delete reactive property on undefined, null, or primitive value: ${(target: any)}`)
  }
  if (Array.isArray(target) && isValidArrayIndex(key)) {
    target.splice(key, 1)
    return
  }
  const ob = (target: any).__ob__
  if (target._isVue || (ob && ob.vmCount)) {
    process.env.NODE_ENV !== 'production' && warn(
      'Avoid deleting properties on a Vue instance or its root $data ' +
      '- just set it to null.'
    )
    return
  }
  // 判断key是不是target自身的属性
  if (!hasOwn(target, key)) {
    return
  }
  // 从target中删除key属性，并向依赖发送消息
  delete target[key]
  // 判断删除的属性是否是响应式的
  if (!ob) {
    return
  }
  ob.dep.notify()
}
```

