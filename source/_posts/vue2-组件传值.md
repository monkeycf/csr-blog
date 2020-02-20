---
title: vue2-组件传值
tags:
  - vue2
categories:
  - vue2
description: vue2中组件的传值
abbrlink: 593345607
date: 2020-02-20 19:11:15
---

# v-model
> v-model 本质上不过是语法糖（v-bind:value 和 v-on:input）

```javascript
Vue.component('base-checkbox', {
  // 添加model属性
  model: {
    prop: 'topTitle',
    event: 'change'
  },
  props: {
    topTitle: String // 注意：仍需申明props
  },
  template: `
    <input
      v-bind:value="topTitle"
      v-on:change="$emit('change', $event.target.value)"
    >
  `
})
```
现在可以在父组件传入 title 属性值，并且在子组件中可通过事件修改
```html
<base-input v-model="title"></base-input>
```



# 父组件向子组件传值

## props
可以说这是比较常见的一种vue父组件传值给子组件的方法。
**注：prop为单向流，子组件不应直接修改该值。应该使用计算属性使用props**
```javascript
Vue.component('base-list', {
  props: {
    value: {
      type: String,
      default: 'default value',
      validator (value) {
        return value.length < 20;
      }
    },
    id: {
      type: Number,
      required: true,
      validator(value) {
        return value > 0;
      }
    }
  },
  computed:{
    userId() {
      return this.id;
    }
  },
  template: `<p>编号：{{ userId }}</p>`
})
```
props应该尽可能的将属性写完成，这样可以更好地防止出乎意料的错误发生。

如果需要传递对象所有属性，可直接省略对象名。
```html
<!-- 注意 v-bind 不可简写 -->
<base-list v-bind="post"></base-list>
```



## $children / $refs

所有的子组件都会保存在$children数组中，该数组乱序。
注：在控制台将vue实例打印出来我们可以发现很多以$和_（下划线）开头的属性。$开头的属性是提供给用户使用的，_ 开头的属性是vue内部使用的。开发者不应该直接修改以 _ 开头的属性，以免造成不可预料的错误（当然，直接修改也有很多surprise >_<）。

直接给子元素添加ref属性，通过$refs直接访问。
```html
<div id="app">
  <base-title ref="essay"></base-title>
</div>
```
```javascript
Vue.component('base-title', {
  data() {
    return {
      value: null
    }
  },
  template: `<p>{{value}}</p>`
})

new Vue({
  created() {
    // 注意：this.$refs['essay']可能为undefined，需要进行保护
    this.$refs['essay']["value"] = Date.now();
  }
}).$mount('#app');
```



## $attrs

> 官网定义：包含了父作用域中不作为 prop 被识别 (且获取) 的特性绑定。

这句话看起来有点绕，但其实很好理解。大白话就是：父组件传入子组件，但是props中没有定义的属性。
**注：该属性只读**

该属性在传值中并不常用，但是在创建高级别的组件/多层嵌套的时候非常有用。
```html
<div id="app">
  <base-card v-bind="post"></base-card>
</div>
```

```javascript
// 子组件
Vue.component('base-card', {
  props: ['name'], // 此处简写props，但在实际使用中建议写完整，并且通过计算属性调用
  mounted() {
    // $attrs 父组件传入值中，没有被props识别的。可继续向子组件传值
    console.log(this.$attrs)
  },
  template: `
    <div>
      <p>姓名：{{ name }}</p>
      <base-age v-bind="$attrs"></base-age>
    </div>
    `
})

// 孙组件
Vue.component('base-age',{
  props:['age'],
  template: `<p>{{age}}</p>`
})

new Vue({
  data() {
    return {
      post: {
        value: 'monkeycf',
        id: 24
      },
    }
  }
}).$mount('#app');
```



## $listeners

> 包含了父作用域中的 (不含 .native 修饰器的) v-on 事件监听器。

和$attrs属性一样，该属性为**只读**，并且在创建更高层次的组件时很有用。
```html
<div id="app">
  <base-card v-on:update:change-age="changeAge"></base-card>
</div>
```
```javascript
// 子组件
Vue.component('base-card', {
  // $listeners 表示父作用域中v-on的监听器
  // 注：此处v-on不能简写
  template: `
    <p>
      <base-age v-on="$listeners"></grand>
    </p>`
})

// 孙组件
Vue.component('base-age', {
  template: `<button @click="$emit('update:change-age')">click this</button>`
})
```



# 子组件向父组件传值



## $emit

> 触发当前示例上的时间

第一个参数为事件名，第二个参数为需要传递的值（如有多个需要传递的值，可以使用对象的方式传递）
其实绑定在事件上的函数是以数组的形式存储的，所以对于一个事件可能会触发多个事件。



## $parent

> 父示例，如果有的话

直接暴力的访问父组件，并且修改属性值。（个人觉得这个方法不太好。。。）

```javascript
Vue.component('base-card', {
  template: `
    <button @click="$parent['time'] = Date.now()">change</button>`,
})

new Vue({
  data() {
    return {
      time: 10
    }
  }
}).$mount('#app');
```



## .sync

这其实是一个缩写。
```html
<base-name 
  v-bind:name = "post.name"
  v-on:update:name = "post.name = $event"
></base-name>
  
<base-name :name.sync="post.name"></base-name>
```
```javascript
// 子组件调用
this.emit('update:name', 'new name');
```


# EventBus

事件总线（个人觉得用起来很方便，但是不太容易维护）

使用：
1. 新建一个Vue示例（或直接在根组件添加一个特殊属性，如$bus)
    ```javascript
    const eventBus = new Vue();
    ```
2. 在该实例上添加事件
    ```javascript
    eventBus.$on('change', (value) => {
      // do something
    })
    ```
3. 调用事件
   ```javascript
   eventBus.$emit('chage','new value')
   ```
4. 移除事件
   ```javascript
   eventBus.$off('change');
   // 当然也可以移除某个函数
   // eventBus.$off('change', fun);
   ```

# Vuex
作为vue的核心插件，这里就不再多多累赘了，可详见官网[vuex](https://vuex.vuejs.org)
