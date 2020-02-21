---
title: Vue2源码-6-VNode
abbrlink: 1711503651
date: 2020-01-22 11:26:04
tags:
 - Vue2
 - Vue2源码
description: VNode简介
categories: Vue2
---

# VNode

> vnode可以理解为**节点描述对象**，描述了应该怎样去创建真实的DOM节点

## 作用

Vue2对状态侦测策略采用了中等粒度。当状态发生变化时，只通知到组件级别，然后组件内使用虚拟DOM来渲染视图。

> 对vnode进行缓存，并将上一次缓存的vnode和当前新创建的vnode进行对比，只更新发生变化的节点。

## 类型

### 注释节点

* text
* isComment

```json
{
  text: '注释节点',
  isComment: true
}
```

```javascript
/**
 * src/core/vdom/vnode.js
 * 创建注释节点
 */
export const createEmptyVNode = (text: string = '') => {
  const node = new VNode()
  node.text = text
  node.isComment = true
  return node
}
```

### 文本节点

* text

```json
{
  text: 'Hello world!'
}
```



```javascript
/**
 * src/core/vdom/vnode.js
 * 创建文本节点
 */
export function createTextVNode (val: string | number) {
  return new VNode(undefined, undefined, undefined, String(val))
}
```

### 克隆节点

#### 作用

> 优化静态节点和插槽节点

#### 区别

克隆节点和被克隆节点之间的唯一区别是isCloned属性，克隆节点为true

```javascript
/**
 * src/core/vdom/vnode.js
 * 克隆节点
 */
export function cloneVNode (vnode: VNode): VNode {
  const cloned = new VNode(
    vnode.tag,
    vnode.data,
    // #7975
    // clone children array to avoid mutating original in case of cloning
    // a child.
    vnode.children && vnode.children.slice(),
    vnode.text,
    vnode.elm,
    vnode.context,
    vnode.componentOptions,
    vnode.asyncFactory
  )
  cloned.ns = vnode.ns
  cloned.isStatic = vnode.isStatic
  cloned.key = vnode.key
  cloned.isComment = vnode.isComment
  cloned.fnContext = vnode.fnContext
  cloned.fnOptions = vnode.fnOptions
  cloned.fnScopeId = vnode.fnScopeId
  cloned.asyncMeta = vnode.asyncMeta
  cloned.isCloned = true // 唯一区别
  return cloned
}
```

### 元素节点

* tag：节点的名称（p、ul、li、div）
* data：节点上的数据（style、class）
* children：子节点列表
* context：当前节点的Vue实例

``` json
{
  children: [VNode, VNode],
  context: {...},
  data: {...},
  tag: "p"
}
```

### 组件节点

* componentOptions：选项参数（propsData、tag、children）
* componentInstance：组件的实例

```json
{
  componentInstance: {...},
  componentOptions: {...},
  context: {...},
  data: {...},
  tag: 'vue-component-child'
}
```

### 函数式组件

* functionalContext
* functionalOptions

