---
title: Vue Router笔记
tags:
  - vue-router
categories:
  - vue-router
description: Vue Router笔记
abbrlink: 1000998621
date: 2020-03-01 13:25:54
---
# Vue Router功能

- 嵌套的路由/视图表
- 模块化的、基于组件的路由配置
- 路由参数、查询、通配符
- 基于 Vue.js 过渡系统的视图过渡效果
- 细粒度的导航控制
- 带有自动激活的 CSS class 的链接
- HTML5 历史模式或 hash 模式，在 IE9 中自动降级
- 自定义的滚动条行为



# 基础

```javascript
// 0. 如果使用模块化机制编程，导入Vue和VueRouter，要调用 Vue.use(VueRouter)

// 1. 定义 (路由) 组件。
// 可以从其他文件 import 进来
const Foo = { template: '<div>foo</div>' }
const Bar = { template: '<div>bar</div>' }

// 2. 定义路由
// 每个路由应该映射一个组件。 其中"component" 可以是
// 通过 Vue.extend() 创建的组件构造器，
// 或者，只是一个组件配置对象。
// 我们晚点再讨论嵌套路由。
const routes = [
  { path: '/foo', component: Foo },
  { path: '/bar', component: Bar }
]

// 3. 创建 router 实例，然后传 `routes` 配置
// 你还可以传别的配置参数, 不过先这么简单着吧。
const router = new VueRouter({
  routes // (缩写) 相当于 routes: routes
})

// 4. 创建和挂载根实例。
// 记得要通过 router 配置参数注入路由，
// 从而让整个应用都有路由功能
const app = new Vue({
  router
}).$mount('#app')

// 现在，应用已经启动了！
```

# 动态路由匹配

> /user/:id

一个“路径参数”使用冒号 `:` 标记。当匹配到一个路由时，参数值会被设置到 `this.$route.params`

| 模式                          | 匹配路径            | $route.params                          |
| :---------------------------- | :------------------ | :------------------------------------- |
| /user/:username               | /user/evan          | `{ username: 'evan' }`                 |
| /user/:username/post/:post_id | /user/evan/post/123 | `{ username: 'evan', post_id: '123' }` |

$route.query： URL查询参数、$route.hash

## 响应路由参数的变化

> 从 `/user/foo` 导航到 `/user/bar`，**原来的组件实例会被复用**。因为两个路由都渲染同个组件，比起销毁再创建，复用则显得更加高效。**不过，这也意味着组件的生命周期钩子不会再被调用**。

1. 监测$route对象

   ```javascript
   const User = {
     template: '...',
     watch: {
       '$route' (to, from) {
         // 对路由变化作出响应...
       }
     }
   }
   ```

2. beforeRouteUpdate

   ```javascript
   const User = {
     template: '...',
     beforeRouteUpdate (to, from, next) {
       // react to route changes...
       // don't forget to call next()
     }
   }
   ```

## 捕获所有路由

匹配任意路径，通配符*

**注意使用顺序，应放最后**，this.$route.params.pathMatch存放匹配路由

```javascript
{
  // 会匹配所有路径
  path: '*'
}
{
  // 会匹配以 `/user-` 开头的任意路径
  path: '/user-*'
}
```

## 匹配顺序

先定义先匹配

# 嵌套路由

在 VueRouter 的参数中使用children配置

**以 `/` 开头的嵌套路径会被当作根路径。 这让你充分的使用嵌套组件而无须设置嵌套的路径**

```js
const router = new VueRouter({
  routes: [
    { path: '/user/:id', component: User,
      children: [
        // 当 /user/:id 匹配成功，
        // UserHome 会被渲染在 User 的 <router-view> 中
        { path: '', component: UserHome },
        {
          // 当 /user/:id/profile 匹配成功，
          // UserProfile 会被渲染在 User 的 <router-view> 中
          path: 'profile',
          component: UserProfile
        },
        {
          // 当 /user/:id/posts 匹配成功
          // UserPosts 会被渲染在 User 的 <router-view> 中
          path: 'posts',
          component: UserPosts
        }
      ]
    }
  ]
})
```

# 编程式导航

1. router.push(location, onComplete?, onAbort?)

   onComplete：导航成功完成 (在所有的异步钩子被解析之后) 

   onAbort：终止 (导航到相同的路由、或在当前导航完成之前导航到另一个不同的路由) 的时候进行相应的调用

   返回Promise

   | 声明式                  | 编程式             |
   | ----------------------- | ------------------ |
   | \<router-link :to="...> | `router.push(...)` |

   **path存在，则params会被忽略**

   ```javascript
   // 字符串
   router.push('home')
   
   // 对象
   router.push({ path: 'home' })
   
   // 命名的路由
   router.push({ name: 'user', params: { userId: '123' }})
   
   // 带查询参数，变成 /register?plan=private
   router.push({ path: 'register', query: { plan: 'private' }})
   ```

2. router.replace(location, onComplete?, onAbort?)

   替换掉当前的 history 记录。

   | 声明式                           | 编程式              |
   | -------------------------------- | ------------------- |
   | \<router-link :to="..." replace> | router.replace(...) |

3. router.go(n)

   ```javascript
   // 在浏览器记录中前进一步，等同于 history.forward()
   router.go(1)
   
   // 后退一步记录，等同于 history.back()
   router.go(-1)
   
   // 前进 3 步记录
   router.go(3)
   
   // 如果 history 记录不够用，那就默默地失败呗
   router.go(-100)
   router.go(100)
   ```

# 命名路由

在创建 Router 实例的时候，在 `routes` 配置中给某个路由设置名称

```javascript
const router = new VueRouter({
  routes: [
    {
      path: '/user/:userId',
      name: 'user',
      component: User
    }
  ]
})
router.push({ name: 'user', params: { userId: 123 }})
```

# 命名视图

```
/settings/emails                                       /settings/profile
+-----------------------------------+                  +------------------------------+
| UserSettings                      |                  | UserSettings                 |
| +-----+-------------------------+ |                  | +-----+--------------------+ |
| | Nav | UserEmailsSubscriptions | |  +------------>  | | Nav | UserProfile        | |
| |     +-------------------------+ |                  | |     +--------------------+ |
| |     |                         | |                  | |     | UserProfilePreview | |
| +-----+-------------------------+ |                  | +-----+--------------------+ |
+-----------------------------------+                  +------------------------------+
```

- `Nav` 只是一个常规组件。
- `UserSettings` 是一个视图组件。
- `UserEmailsSubscriptions`、`UserProfile`、`UserProfilePreview` 是嵌套的视图组件。

```html
<!-- UserSettings.vue -->
<div>
  <h1>User Settings</h1>
  <NavBar/>
  <router-view/>
  <router-view name="helper"/>
</div>
```

```javascript
{
  path: '/settings',
  // 你也可以在顶级路由就配置命名视图
  component: UserSettings,
  children: [{
    path: 'emails',
    component: UserEmailsSubscriptions
  }, {
    path: 'profile',
    components: {
      default: UserProfile,
      helper: UserProfilePreview
    }
  }]
}
```

# 重定向和别名

```javascript
const router = new VueRouter({
  routes: [
    { path: '/a', redirect: { name: 'foo' }, alias: '/b'}
  ]
})

const router = new VueRouter({
  routes: [
    { path: '/a', redirect: to => {
      // 方法接收 目标路由 作为参数
      // return 重定向的 字符串路径/路径对象
    }}
  ]
})
```

# 路由组件传参

使用props将组件与路由解耦

```javascript
const router = new VueRouter({
  routes: [
    { path: '/user/:id', component: User, props: true },

    // 对于包含命名视图的路由，你必须分别为每个命名视图添加 `props` 选项：
    {
      path: '/user/:id',
      components: { default: User, sidebar: Sidebar },
      props: { default: true, sidebar: false }
    }
  ]
})
```

## Props类型

1. Boolean

   route.params 将会被设置为组件属性

2. 对象

   props是一个对象，它会被按原样设置为组件属性。当 props 是静态的时候有用

3. 函数

   创建一个函数返回 props

   ```javascript
   const router = new VueRouter({
     routes: [
       { path: '/search', component: SearchUser, props: (route) => ({ query: route.query.q }) }
     ]
   })
   ```

# History模式

> mode: 'history'

# 导航守卫

## 全局守卫

1. 全局前置守卫

   ```javascript
   router.beforeEach((to, from, next) => {
     // ...
   })
   ```

   - to: Route: 即将要进入的目标 路由对象
   - from: Route: 当前导航正要离开的路由
   - next: Function: 一定要调用该方法来 **resolve** 这个钩子。执行效果依赖 next 方法的调用参数。
     - next(): 进行管道中的下一个钩子。如果全部钩子执行完了，则导航的状态就是 **confirmed** (确认的)。
     - next(false): 中断当前的导航。如果浏览器的 URL 改变了 (可能是用户手动或者浏览器后退按钮)，那么 URL 地址会重置到 from 路由对应的地址。
     - next('/') 或者 next({ path: '/' }): 跳转到一个不同的地址。当前的导航被中断，然后进行一个新的导航。你可以向 next 传递任意位置对象，且允许设置诸如 replace: true、name: 'home' 之类的选项以及任何用在 router-link 的 to prop 或 router.push 中的选项。
     - next(error): (2.4.0+) 如果传入next 的参数是一个 Error 实例，则导航会被终止且该错误会被传递给 router.onError() 注册过的回调。

2. 全局解析守卫

   router.beforeResolve

   导航被确认之前，同时在所有组件内守卫和异步路由组件被解析之后，解析守卫就被调用

3. 全局后置守卫

   ```javascript
   router.afterEach((to, from) => {
     // ...
   })
   ```

## 路由独享守卫

```javascript
const router = new VueRouter({
  routes: [
    {
      path: '/foo',
      component: Foo,
      beforeEnter: (to, from, next) => {
        // ...
      }
    }
  ]
})
```

## 组件内守卫

```javascript
const Foo = {
  template: `...`,
  beforeRouteEnter (to, from, next) {
    // 在渲染该组件的对应路由被 confirm 前调用
    // 不！能！获取组件实例 `this`
    // 因为当守卫执行前，组件实例还没被创建
    next(vm => {
    // 通过 `vm` 访问组件实例
  	})
  },
  beforeRouteUpdate (to, from, next) {
    // 在当前路由改变，但是该组件被复用时调用
    // 举例来说，对于一个带有动态参数的路径 /foo/:id，在 /foo/1 和 /foo/2 之间跳转的时候，
    // 由于会渲染同样的 Foo 组件，因此组件实例会被复用。而这个钩子就会在这个情况下被调用。
    // 可以访问组件实例 `this`
  },
  beforeRouteLeave (to, from, next) {
    // 导航离开该组件的对应路由时调用
    // 可以访问组件实例 `this`
    next(false) // 取消离开
  }
}
```

## 导航解析流程

1. 导航被触发。
2. 在失活的组件里调用离开守卫。
3. 调用全局的 beforeEach 守卫。
4. 在重用的组件里调用 beforeRouteUpdate 守卫。
5. 在路由配置里调用 beforeEnter。
6. 解析异步路由组件。
7. 在被激活的组件里调用 beforeRouteEnter。
8. 调用全局的 beforeResolve守卫 。
9. 导航被确认。
10. 调用全局的 afterEach 钩子。
11. 触发 DOM 更新。
12. 用创建好的实例调用 beforeRouteEnter 守卫中传给 next 的回调函数。

# 路由元信息

定义路由的时候可以配置 `meta` 字段

通过$route.matched 数组访问

# 过渡效果

```html
<transition>
  <router-view></router-view>
</transition>
```

## 单个路由过渡

可在大部分组件内使用transition

```javascript
const Foo = {
  template: `
    <transition name="slide">
      <div class="foo">...</div>
    </transition>
  `
}
```

## 基于路由的动态过渡

```html
<!-- 使用动态的 transition name -->
<transition :name="transitionName">
  <router-view></router-view>
</transition>
```

```javascript
// 接着在父组件内
// watch $route 决定使用哪种过渡
watch: {
  '$route' (to, from) {
    const toDepth = to.path.split('/').length
    const fromDepth = from.path.split('/').length
    this.transitionName = toDepth < fromDepth ? 'slide-right' : 'slide-left'
  }
}
```

# 数据获取

1. 导航完成后，在组件生命周期钩子中获取数据
2. 导航完成之前获取（beforeRouteEnter、beforeRouteUpdate）

# 滚动

```javascript
scrollBehavior (to, from, savedPosition) {
	// return 期望滚动到哪个的位置
  if (savedPosition) {
    return savedPosition // 浏览器 前进/后退 保持原状
  } else if(to.hash){
    return {
      selector: to.hash
    }
  } else {
    return { x: 0, y: 0 }
  }
}
```

> 异步滚动

```javascript
scrollBehavior (to, from, savedPosition) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve({ x: 0, y: 0 })
    }, 500)
  })
}
```

# 路由懒加载

```javascript
const Foo = () => import('./Foo.vue')
```

组件按组分块

```javascript
const Foo = () => import(/* webpackChunkName: "group-foo" */ './Foo.vue')
```

