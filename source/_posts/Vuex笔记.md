---
title: Vuex笔记
tags:
  - Vuex
categories:
  - Vuex
description: Vuex使用笔记
abbrlink: 2056824029
date: 2020-02-29 23:29:07
---
# Vuex

* Vuex 的状态存储是响应式的
* 改变 store 中的状态的唯一途径就是显式地**提交 (commit) mutation**

# Sate

单一状态树

在计算属性中返回某个状态。

* store.state.count

* 把 store 对象提供给 “store” 选项，这可以把 store 的实例注入所有的子组件

  ```javascript
  this.$store.state.count
  ```

* mapSate

  ```javascript
  mapState({
    // 箭头函数可使代码更简练
    count: state => state.count,
  
    // 传字符串参数 'count' 等同于 `state => state.count`
    countAlias: 'count',
  
    // 为了能够使用 `this` 获取局部状态，必须使用常规函数
    countPlusLocalState (state) {
      return state.count + this.localCount
    }
  })
  ```



# Getter

store 的计算属性

* 通过属性访问

  ```javascript
  getters: {
    doneTodos: state => {
      return state.todos.filter(todo => todo.done)
    }
  }
  
  // 接受getters作为第二参数
  doneTodosCount: (state, getters) => {
    return getters.doneTodos.length
  }
  ```

* 通过函数访问

  返回函数，这样可以实现根据id查询，不会有缓存

  ```javascript
  getTodoById: (state) => (id) => {
    return state.todos.find(todo => todo.id === id)
  }
  ```

* mapGetters

```javascript
...mapGetters([
  'doneTodosCount',
  'anotherGetter',
  // ...
])

mapGetters({
  // 把 `this.doneCount` 映射为 `this.$store.getters.doneTodosCount`
  doneCount: 'doneTodosCount'
})
```

# Mutation

* 更改 Vuex 的 store 中的状态的唯一方法是提交 mutation。每个 mutation 都有一个字符串的 **事件类型 (type)** 和 一个 **回调函数 (handler)**。

* **mutation 必须是同步函数**

* 使用常量替代 Mutation 事件类型

  在mutation-types.js导出常量

```javascript
mutations: {
  increment (state, payload) {
    state.count += payload.amount
  }
}
store.commit('increment', {
  amount: 10
})
```

* mapMutations

```javascript
...mapMutations([
  'increment', // 将 `this.increment()` 映射为 `this.$store.commit('increment')`

  // `mapMutations` 也支持载荷：
  'incrementBy' // 将 `this.incrementBy(amount)` 映射为 `this.$store.commit('incrementBy', amount)`
]),
...mapMutations({
  add: 'increment' // 将 `this.add()` 映射为 `this.$store.commit('increment')`
})
```

# Action

- ction 提交的是 mutation，而不是直接变更状态。
- Action 可以包含任意异步操作。

```javascript
actions: {
  increment ({ commit }) {
    commit('increment')
  }
}

store.dispatch('increment')
```

* mapActions

```javascript
...mapActions([
  'increment', // 将 `this.increment()` 映射为 `this.$store.dispatch('increment')`

  // `mapActions` 也支持载荷：
  'incrementBy' // 将 `this.incrementBy(amount)` 映射为 `this.$store.dispatch('incrementBy', amount)`
]),
...mapActions({
  add: 'increment' // 将 `this.add()` 映射为 `this.$store.dispatch('increment')`
})
```

* Promise、async/await

```javascript
actions: {
  actionA ({ commit }) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        commit('someMutation')
        resolve()
      }, 1000)
    })
  }
}

async actionB ({ dispatch, commit }) {
  await dispatch('actionA') // 等待 actionA 完成
  commit('gotOtherData', await getOtherData())
}
```

# Module

## 局部状态

可以访问模块的局部状态对象

根节点状态则为 `context.rootState`

## 命名空间

`namespaced: true` 的方式使其成为带命名空间的模块

### 在带命名空间的模块内访问全局内容

* 全局 state 和 getter，`rootState` 和 `rootGetters` 会作为第三和第四参数传入 getter，也会通过 `context` 对象的属性传入 action
* 全局命名空间内分发 action 或提交 mutation，将 `{ root: true }` 作为第三参数传给 `dispatch` 或 `commit` 即可
* 注册全局 action，你可添加 `root: true`，并将这个 action 的定义放在函数 `handler`

```javascript
...mapActions('some/nested/module', [
  'foo', // -> this.foo()
  'bar' // -> this.bar()
])
```

* 通过使用 `createNamespacedHelpers` 创建基于某个命名空间辅助函数

```javascript
import { createNamespacedHelpers } from 'vuex'

const { mapState, mapActions } = createNamespacedHelpers('some/nested/module')
```



# 严格模式

严格模式下，无论何时发生了状态变更且不是由 mutation 函数引起的，将会抛出错误。**不要在发布环境下启用严格模式**

```javascript
strict: process.env.NODE_ENV !== 'production'
```

