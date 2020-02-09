---
title: webpack-15-区分不同环境
description: 区分不同的环境变量
categories: webpack
tags:
  - webpack
abbrlink: 2849467898
date: 2019-11-17 16:39:55
---

## 区分不同环境变量

#### webpack-merge

>  这个插件内部有个smart函数，其作用：合并两个配置文件 

可使用三个文件

* webpack.base.js 基础公共配置
* webpack.dev.js 开发环境配置
* webpack.prod.js 生产环境配置

```javascript
const {smart} = require('webpack-merge')
const base = require('./webpack.base')

module.exports = smart(base, {  
    mode: 'production'
})
```

