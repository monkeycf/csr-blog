---
title: 字节跳动-Data-前端开发实习生面经
description: 记字节跳动Data前端开发实习面试。
categories: 面经
tags:
  - 面经
abbrlink: 4264422933
date: 2020-04-07 10:45:33
---
记字节跳动Data前端开发实习面试。

# 一面
因为原来的面试官临时开会，等了一会换了一个面试官，好事多磨啊。面试气氛还是很和谐的，每块内容都有涉及，并且会深入一些。大概有JavaScript基础、算法、计算机网络、设计模式。
1. 自我介绍

2. this探讨

   * 说说有哪些改变this指向的方法

     > this是在执行环境决定的，有call、apply、bind的方法，在new对象的时候也会修改this

   * 阅读代码说结果

     >  从基础到复杂，题目比较多，大概记得这些

     ```javascript
     function a() {
       console.log(this.name);
     }
     
     a();
     ```

     ```javascript
     var name = 1;
     a();
     ```

     ```javascript
     a.prototype.name = 2;
     a()
     ```

     ```javascript
     function b() {
       this.value = this.name;
     }
     b();
     ```

     ```javascript
     let c = {name: 3};
     c.say = a;
     let d = c.say;
     
     c.say();
     d();
     ```

3. bind实现

   * 假如要兼容IE，请简单实现一下bind（上题自己挖的坑）

     ```javascript
     // 当时写的代码，没考虑参数
     Function.prototype.bind = function (obj) {
       return () => {
         this.call(obj);
       }
     }
     ```

   * 这里为什么用箭头函数，上面那个function可以换成箭头函数嘛

     > 因为箭头函数本身没有this，绑定外层的this。上面的那个function不能换成箭头函数

4. 你看过Vue的源码嘛？简单实现一下发布订阅模式

   > 源码浅浅看过😀，但是没全部看懂。
   >
   > 脑子里一下就想起on，emit，off，once，当时写到一半就被叫停了，好不容易遇到easy的。。。

   ```javascript
   class EventHelper {
     construct() {
       this._eventMap = {}
     }
   
     on(fn, cb) {
       this._eventMap[fn]
         ? this._eventMap.push(cb)
         : this._eventMap[fn] = [cb];
     }
   
     emit(fn, ...args) {
       if (this._eventMap[fn]) {
         this._eventMap[fn].forEach((cb) => cb.apply(this, args))
       }
     }
   
     off(fn) {
       if (this._eventMap[fn]) {
         delete (this._eventMap[fn])
       }
     }
   
     once(fn, cb) {
       this.on(fn, () => {
         cb();
         setTimeout(() => {
           this.off(fn);
         })
       })
     }
   }
   ```

5. UDP & TCP

   * 说说两者的区别

   * 怎么判断这个包是UDP还是TCP

     > 好狠，一下没想起来。一开始答了TCP三次握手😂，后来冷静想想IP的报文段里好像有这个标识。

6. HTTPS

   * 说说原理

     > 吧啦吧啦，讲了TLS，非对称加密，对称加密。。。

   * 中间人攻击

     > 大概讲了一下过程

   * 是不能对数据修改，还是对数据修改后，接受端不认

     > 大概讲了一下数字签名

7. 浏览器缓存

   * 说说都有哪些方法

     > Cache-control、ETag、Last-modify

   * 说说什么时候必须使用ETag

     > 一下子没想出来，就说了什么时候需要使用last-modify（还好面试官放过我了😝）
     >
     > 查了查：last-modified不识别s（秒）单位里的修改，所以如果资源在s（秒）单位里发生了修改，那last-modified也不会发生改变

8. 二叉树左侧看

   > 我的想法就是树的层次遍历。面试官说大概思路差不多，就是用null做标识符可能不太雅观

   ```javascript
                   1
               2       3
            4   5    6   7
                            8
   
   => 1248
   
   // 当时大概的代码
   function leftSee(node) {
     const arr = [];
     arr.push(null)
     arr.push(node);
     while (arr.length > 0) {
       let t = arr.shift();
       if (t === null) {
         arr.push(null);
         t = arr.shift();
         if (t == null) return;
         console.log(t.value);
       }
       if (t.left) {
         arr.push(t.left)
       }
       if (t.right) {
         arr.push(t.right)
       }
     }
   }
   ```

# 二面

二面的面试官给人的感觉比较”随意“，感觉整个面试就像是在聊天。但是问的内容很发散，可能一个问题会涉及很多知识点。

自我感觉答的不是很好，主要的点达到了，但是很多都没有答全，面完都以为自己要挂了。感觉在平时写项目的时候需要更多的思考，这么写有什么优点，好在哪里，为什么好，又有什么缺陷。

1. 自我介绍

2. 说说Vue3的新特征

   > 真实，真的真实！
   >
   > 当时主要说了两点：1. Proxy 替代了 Object.defineProperty，因为 Object.definePropetry 无法监听嵌套属性，需要递归，也无法监听数组，需要重写方法。2. 支持自定义渲染，目前Vue2底层的渲染API没有向开发者提供，像mpvue就是fork了整个Vue的源码，然后改了底层的渲染。其他还提了一下TypeScript，对象式声明，运行包大小。。

3. 虚拟DOM

   * 说说虚拟DOM和原始DOM相比的优缺点

     > 只说出了优点：1. 利用JS的计算换取对DOM的操作，提高性能。2. 不需要直接操作DOM。3. 跨平台开发，weex

   * 根据svelte框架，类比一下你还能说出什么缺点嘛？

     > 我没听过svelte，面试官就简单介绍了一下那个框架的卖点。
     >
     > 懵逼脸🙃

4. BFC

   * 是什么

     > 块级格式化上下文，还有IFC、FFC、GFC

   * 什么情况下使用

     > 外边距塌陷，清除内部子元素浮动

   *  该怎么触发

     > ......愣是没想全😐，就想起来float不为none

5. 移动端

   * 移动端适配

     > @media 媒体查询加载不同的css，Flex，float布局。。

   * rem 和 em 的区别

     > 感觉答的不好，之说出rem是基于HTML元素的字体大小决定的

6. Vuex用过modules吧，说说A文件内的actions怎么修改B的state

   > 1. 直接在A文件内引入B文件，调用B的actions😁。2. dispatch第三个参数为{root: true}

7. TypeScript

   * 变量后面加上感叹号什么意思

     > 忘了🙃，应该是非空断言

   * 类型断言的方法

   * 好处、缺点

8. Node

   > 问我node掌握如何，我就说我只会使用，原理部分还在学习中。。。用过express和Egg

9. 异步

   * 看代码

     ```javascript
     async function test() {
       return 1
     }
     async function call() {
       const a = test();
       const b = await test();
       console.log(a, b);
     }
     call();
     ```

   * 这样写的结果是什么，有什么地方可以改进的嘛

     ```javascript
     async function test() {
       const resp1 = await getApi1();
       const resp2 = await getApi2();
       console.log(resp1, resp2);
       return 1
     }
     ```

     > 因为await会阻塞，所以getApi2要等getApi1返回结果了才会触发，可以使用Promise.all同时发起

10. Promise.all

    大概写下Promise.all的原理吧

    > 没看过，只能靠临场发挥了（自己挖的坑，哭着也要爬出来😭）
    >
    > 边写边与面试官交流，到后面说大致思路差不多，但还要我回去看看。。。
    
    ```javascript
    Promise.prototype.all = function(promiseArr) {
        const len = promiseArr.length;
        const result = new Array(len);
        let flag = 0;
        return new Promise((resolve, reject) => {
          promiseArr.forEach((cb, index) => {
            Promise.resolve(cb).then(
              res => {
                result[index] = res; // 注意数组中的顺序，当时直接写了push🙃
                if (++flag === len) {
                  resolve(result);
                }
              },
              error => {
                reject(error)
              })
          })
        })
      }
    ```
    
    

# 三面

三面的面试官应该是个主管，很和蔼，一上来就问我饭吃了嘛，面了很久了吧，要不要休息一下😊

三面个人觉得是比较轻松的一面，不涉及具体的API如何实现，主要考察从一个问题如何给出一个切实可行的解决方案，有很强的发散性思维，面试官会一步步引导给出一个较全面的解决方案。期间有提到用Vuex管理数据，面试官就直接说这个和Vuex没关系。面试官表达的需求很清楚，只要按照提出的需求切实的解决就ok

fortunately，三面结束，面试官说本来还要HR面，现在有点晚了，就明天吧。

1. 自我介绍

2. 重点项目介绍，难点挑战

   > 我主要说了项目版本的迭代、中台的权限控制、模块化。。。

3. 权限控制方案，怎么实现的，整体的思路如何

4. 模块化是怎么划分的，具体做过哪些

5. 提出了一个输入框远程搜索提示的功能

   * 讲讲你实现的思路

     > 提了大概的思路，防抖，巴拉巴拉

   * 如果多次输入相同的内容怎么办

     > 可以缓存在localStorage中，在发起请求之前先在本地查一下

   * 这样每次都需要去localStorage取，有没有更好的方案

     > 页面加载的时候从localStronge取出来存在一个Map中，页面离开的时候再将新的Map存到localStronge中

   * 如果服务端的数据跟新了怎么同步localStronge中的数据

     > 可以借鉴浏览器的缓存，加标识符将数据分为两部分：一段时间不会修改的，那么使用”强缓存"；经常会修改的使用“协商缓存”，每次使用去服务器查一下看下有没有修改

6. 说说版本是怎么迭代的

7. 什么时候来实习

# 我提的问题

1. 一面：

   * 这段时间我学了Flutter和React，你觉得在有限的时间里是学更多的框架会使用，还是某一个比较深入的学习呢？

   * 字节的技术栈

2. 二面：

   面试官后面有事，没给我提问的机会😥

3. 三面：

   * 字节有什么培养新人的方法嘛？
   * 是研发为主，还是业务驱动？

# 友情链接

感觉[PanJiaChen](https://github.com/PanJiaChen) （[vue-element-admin](https://github.com/PanJiaChen/vue-element-admin)）大佬的[内推码](https://panjiachen.github.io/vue-element-admin-site/zh/job/)
