---
title: webpack-05-全局变量处理
description: 对全局变量处理，需注意是否可以暴露给window
categories: webpack
tags:
  - webpack
abbrlink: 2938557385
date: 2019-11-17 14:09:05
---

## 全局变量处理

以jQuery为例。

### expose-loader (能暴露给window)

#### 使用内敛loader

```javascript
import $ from 'expose-loader?$!jquery';
console.log(window.$)
```

#### 使用普通loader

```javascript
{  
    test: require.resolve('jquery'), 
    use: 'expose-loader?$'
}
```

### 模块注入（ProvidePlugin，不能暴露给window）

```javascript
new webpack.ProvidePlugin({  
    $: 'jquery'
})
```

### 忽略外部引用模块（ 能暴露给window ）

```javascript
externals: { 
    'jquery': '$'
},
```


