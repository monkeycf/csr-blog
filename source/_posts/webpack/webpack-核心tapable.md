---
title: webpack-核心tapable
description: webpack核心tapable
categories: webpack
tags:
  - webpack
  - tapable
abbrlink: 3809815838
date: 2019-11-14 19:01:57
---

# tapable

![](http://img.chensenran.top/1573739888959.png)

**核心原理：发布订阅模式。**

webpack本质上是一种事件流的机制，它的工作流程就是将各个插件串联起来，而实现这一切的核心就是Tapable。Tapable其实就是一个用于事件发布订阅执行的插件架构。



##  同步

### SyncHook

 同步钩子，能够同步执行注册的监听函数 

#### 使用

```javascript
let {SyncHook} = require('tapable');
class Lesson {
    constructor() {  
        this.hook = {     
            arch: new SyncHook(['name'])  
        } 
    }
    tap() {
        this.hook.arch.tap('node', (name) => {
            console.log(name)
        })   
        this.hook.arch.tap('vue', (name) => {  
            console.log(name) 
        })
    } 
    start() {
        this.hook.arch.call('csr'); 
    }
}
let t = new Lesson();
t.tap() // 注册狗子
t.start() // 使用钩子
```

#### 原理实现

```javascript
class SyncHook {  
    constructor(args) {  
        this.tasks = []
    } 
    tap(args, task) { 
        this.tasks.push(task) 
    }  
    call(...args) { 
        this.tasks.forEach(task => task(...args)); 
    }
}
let hook = new SyncHook(['name']);

hook.tap('node', (name) => {
    console.log('node1', name)
})
hook.tap('vue', (name) => { 
    console.log('vue2', name)
})

hook.call('csr')
```

### SyncBailHook

 SyncBailHook同步熔断保险钩子,即return一个非undefined的值，则不再继续执行后面的监听函数 

#### 使用

```javascript
let {SyncBailHook} = require('tapable');

class Lesson {
  constructor() {
    this.hook = {
      arch: new SyncBailHook(['name'])
    }
  }

  tap() {
    this.hook.arch.tap('node', (name) => {
      console.log(name)
      return 'break;'
    })
    this.hook.arch.tap('vue', (name) => {
      console.log(name)
    })
  }

  start() {
    this.hook.arch.call('csr');
  }
}

let t = new Lesson();
t.tap() // 注册狗子
t.start() // 使用钩子
```
#### 原理实现
```javascript
class SyncBailHook {
  constructor(args) {
    this.tasks = []
  }

  tap(args, task) {
    this.tasks.push(task)
  }

  call(...args) {
    let res; // 返回值
    let index = 0; // 下表
    do {
      res = this.tasks[index++](...args);
    } while (res === undefined && index < this.tasks.length)
  }
}

let hook = new SyncBailHook(['name']);
hook.tap('node', (name) => {
  console.log('node1', name)
  return "no"
})
hook.tap('vue', (name) => {
  console.log('vue2', name)
})
hook.call('csr')
```

### SyncWaterfallHook

 SyncWaterfallHook 同步瀑布钩子，上一个监听函数的返回值会传递给下一个监听函数 

#### 使用

```javascript
let {SyncWaterfallHook} = require('tapable');

class Lesson {
  constructor() {
    this.hook = {
      arch: new SyncWaterfallHook(['name'])
    }
  }

  tap() {
    this.hook.arch.tap('node', (name) => {
      console.log(name)
      return 'it is ok'
    })
    this.hook.arch.tap('vue', (data) => {
      console.log(data)
    })
  }

  start() {
    this.hook.arch.call('csr');
  }
}

let t = new Lesson();
t.tap() // 注册狗子
t.start() // 使用钩子
```

#### 原理实现
```javascript
class SyncWaterfallHook {
  constructor(args) {
    this.tasks = []
  }

  tap(args, task) {
    this.tasks.push(task)
  }

  call(...args) {
    let [first, ...other] = this.tasks;
    let ret = first(...args);
    other.reduce((a, b) => {
      return b(a);
    }, ret)
  }
}

let hook = new SyncWaterfallHook(['name']);
hook.tap('node', (name) => {
  console.log('node1', name)
  return "no"
})
hook.tap('vue', (name) => {
  console.log('vue2', name)
})
hook.call('csr')

```
### SyncLoopHook
SyncLoopHook,同步遇到某个不返回undefined的监听函数，就重复执行
#### 使用
```javascript
let {SyncLoopHook} = require('tapable');

class Lesson {
  constructor() {
    this.index = 0;
    this.hook = {
      arch: new SyncLoopHook(['name'])
    }
  }

  tap() {
    this.hook.arch.tap('node', (name) => {
      console.log('node',name)
      return ++this.index === 3 ? undefined : 'it is ok';
    })
    this.hook.arch.tap('vue', (data) => {
      console.log(data)
    })
  }

  start() {
    this.hook.arch.call('csr');
  }
}

let t = new Lesson();
t.tap() // 注册狗子
t.start() // 使用钩子
```
#### 原理实现
```javascript
class SyncLoopHook {
  constructor(args) {
    this.tasks = []
  }

  tap(args, task) {
    this.tasks.push(task)
  }

  call(...args) {
    this.tasks.forEach(task => {
      let ret;
      do {
        ret = task(...args)
      } while (ret !== undefined);
    })
  }
}

let hook = new SyncLoopHook(['name']);
let total = 0;
hook.tap('node', (name) => {
  console.log('node1', name)
  return ++total === 3 ? undefined : "no"
})
hook.tap('vue', (name) => {
  console.log('vue2', name)
})
hook.call('csr')
```

## 异步并行

### AsyncParallelHook
异步并行
#### 普通异步方法
使用tapAsync注册（每个注册方法都有一个回调函数），使用callAsync调用
##### 使用
```javascript
let {AsyncParallelHook} = require('tapable');

class Lesson {
  constructor() {
    this.index = 0;
    this.hook = {
      arch: new AsyncParallelHook(['name'])
    }
  }

  tap() {
    this.hook.arch.tapAsync('node', (name, cb) => {
      setTimeout(() => {
        console.log('node', name)
        cb();
      }, 1000)
    })
    this.hook.arch.tapAsync('vue', (data, cb) => {
      setTimeout(() => {
        console.log('vue', data)
        cb();
      }, 500)
    })
  }

  start() {
    this.hook.arch.callAsync('csr', () => {
      console.log('end')
    });
  }
}

let t = new Lesson();
t.tap() // 注册狗子
t.start() // 使用钩子
```
##### 原理实现
```javascript
class AsyncParallelHook {
  constructor(args) {
    this.tasks = []
  }

  tapAsync(args, task) {
    this.tasks.push(task)
  }

  callAsync(...args) {
    let lastFunction = args.pop(); // 取出最后一个函数，call的回调函数
    let index = 0;
    const done = () => {
      index++;
      if (index === this.tasks.length) {
        lastFunction();
      }
    }
    this.tasks.forEach(task => {
      task(...args, done);
    })
  }
}

let hook = new AsyncParallelHook(['name']);
let total = 0;
hook.tapAsync('node', (name, cb) => {
  setTimeout(() => {
    console.log('node1', name)
    cb()
  }, 1000)
})
hook.tapAsync('vue', (name, cb) => {
  setTimeout(() => {
    console.log('vue2', name)
    cb();
  }, 500)
})
hook.callAsync('csr', () => {
  console.log('end')
})

```
#### Promise方法
使用tapPromise注册，promise调用
##### 使用
```javascript
let {AsyncParallelHook} = require('tapable');

class Lesson {
  constructor() {
    this.index = 0;
    this.hook = {
      arch: new AsyncParallelHook(['name'])
    }
  }

  tap() {
    this.hook.arch.tapPromise('node', (name) => {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          console.log('node', name)
          resolve()
        }, 1000)
      })
    })
    this.hook.arch.tapPromise('vue', (data) => {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          console.log('vue', data)
          resolve()
        }, 500)
      })
    })
  }

  start() {
    this.hook.arch.promise('csr')
      .then(() => {
        console.log('end')
      });
  }
}

let t = new Lesson();
t.tap() // 注册狗子
t.start() // 使用钩子
```
##### 原理实现
```javascript
class AsyncParallelHook {
  constructor(args) {
    this.tasks = []
  }

  tapPromise(args, task) {
    this.tasks.push(task)
  }

  promise(...args) {
    let tasks = this.tasks.map(task => task(...args))
    return Promise.all(tasks)
  }
}

let hook = new AsyncParallelHook(['name']);
let total = 0;
hook.tapPromise('node', (name) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log('node1', name)
      resolve()
    }, 1000)
  })
})
hook.tapPromise('vue', (name) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log('vue2', name)
      resolve()
    }, 500)
  })
})
hook.promise('csr')
  .then(() => {
    console.log('end')
  })
```

### AsyncParallelBailHook

带保险的异步并发

## 异步串行
### AsyncSeriesHook

异步串行

#### 普通方法
##### 使用
```javascript
let {AsyncSeriesHook} = require('tapable');

class Lesson {
  constructor() {
    this.index = 0;
    this.hook = {
      arch: new AsyncSeriesHook(['name'])
    }
  }

  tap() {
    this.hook.arch.tapAsync('node', (name, cb) => {
      setTimeout(() => {
        console.log('node', name)
        cb()
      }, 1000)
    })
    this.hook.arch.tapAsync('vue', (data, cb) => {
      setTimeout(() => {
        console.log('vue', data)
        cb();
      }, 500)
    })
  }

  start() {
    this.hook.arch.callAsync('csr',() => {
        console.log('end')
      });
  }
}

let t = new Lesson();
t.tap() // 注册狗子
t.start() // 使用钩子
```
##### 原理实现
```javascript
class AsyncSeriesHook {
  constructor(args) {
    this.tasks = []
  }

  tapAsync(args, task) {
    this.tasks.push(task)
  }

  callAsync(...args) {
    let finalCallback = args.pop(); // 最后call的回调函数
    let index = 0;
    let next = () => {
      if (index === this.tasks.length) return finalCallback();
      this.tasks[index](...args, next)
      index++;
    }
    next();
  }
}

let hook = new AsyncSeriesHook(['name']);
hook.tapAsync('node', (name, cb) => {
  setTimeout(() => {
    console.log('node1', name)
    cb()
  }, 1000)
})
hook.tapAsync('vue', (name, cb) => {
  setTimeout(() => {
    console.log('vue2', name)
    cb();
  }, 500)
})
hook.callAsync('csr', () => {
  console.log('end')
})
```
#### Promise方法
##### 使用
```JavaScript
let {AsyncSeriesHook} = require('tapable');

class Lesson {
  constructor() {
    this.index = 0;
    this.hook = {
      arch: new AsyncSeriesHook(['name'])
    }
  }

  tap() {
    this.hook.arch.tapPromise('node', (name) => {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          console.log('node', name)
          resolve()
        }, 1000)
      })

    })
    this.hook.arch.tapPromise('vue', (data) => {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          console.log('vue', data)
          resolve();
        }, 500)
      })
    })
  }

  start() {
    this.hook.arch.promise('csr')
      .then(() => {
        console.log('end')
      });
  }
}

let t = new Lesson();
t.tap() // 注册狗子
t.start() // 使用钩子
```

##### 原理实现
```javascript
class AsyncSeriesHook {
  constructor(args) {
    this.tasks = []
  }

  tapPromise(args, task) {
    this.tasks.push(task)
  }

  promise(...args) {
    let [first, ...other] = this.tasks;
    return other.reduce((p, n) => {
      return p.then(() => n(...args))
    }, first(...args))
  }
}

let hook = new AsyncSeriesHook(['name']);
hook.tapPromise('node', (name) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log('node1', name)
      resolve()
    }, 1000)
  })
})
hook.tapPromise('vue', (name, cb) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log('vue2', name)
      resolve();
    }, 500)
  })
})
hook.promise('csr')
  .then(() => {
    console.log('end')
  })
```
### AsyncSeriesBailHook

带保险的异步串行

### AsyncSeriesWaterfallHook

异步瀑布钩子，上一个监听函数的返回值会传递给下一个监听函数 

#### Promise 用法

##### 使用

```javascript
let {AsyncSeriesWaterfallHook} = require('tapable');

class Lesson {
  constructor() {
    this.index = 0;
    this.hook = {
      arch: new AsyncSeriesWaterfallHook(['name'])
    }
  }

  tap() {
    this.hook.arch.tapPromise('node', (name) => {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          console.log('node', name)
          resolve('data')
        }, 1000)
      })

    })
    this.hook.arch.tapPromise('vue', (data) => {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          console.log('vue', data)
          resolve();
        }, 500)
      })
    })
  }

  start() {
    this.hook.arch.promise('csr')
      .then(() => {
        console.log('end')
      });
  }
}

let t = new Lesson();
t.tap() // 注册狗子
t.start() // 使用钩子
```
##### 原理实现
```javascript
let {AsyncSeriesWaterfallHook} = require('tapable');

class Lesson {
  constructor() {
    this.index = 0;
    this.hook = {
      arch: new AsyncSeriesWaterfallHook(['name'])
    }
  }

  tap() {
    this.hook.arch.tapPromise('node', (name) => {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          console.log('node', name)
          resolve('data')
        }, 1000)
      })

    })
    this.hook.arch.tapPromise('vue', (data) => {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          console.log('vue', data)
          resolve();
        }, 500)
      })
    })
  }

  start() {
    this.hook.arch.promise('csr')
      .then(() => {
        console.log('end')
      });
  }
}

let t = new Lesson();
t.tap() // 注册狗子
t.start() // 使用钩子
```