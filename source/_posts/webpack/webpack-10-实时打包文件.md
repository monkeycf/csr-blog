---
title: webpack-10-实时打包文件
description: 实时打包文件，并在打包前清除历史文件
categories: webpack
tags:
  - webpack
abbrlink: 769749626
date: 2019-11-17 14:57:49
---

## 实时打包文件

```javascript
watch: true,
watchOptions: {
  poll: 1000, // 每秒监听次数
  aggregateTimeout: 500, // 防抖，打包延时
  ignored: /node_modules/ // 不监听文件
},
```

## clean-webpack-plugin清空打包目录文件

```javascript
plugins: [
  new CleanWebpackPlugin(['dist'], {
    root: __dirname,
    verbose: true,//是否在console中打印日志，true为是
    dry: false,//false为默认值，代表删除，true代表模拟删除，其实是不删除
    watch: true,//默认为false，代表在此编译的时候不删除，true为删除，开启watch的时候，最好为true
    exclude: ['index.html'],//表示忽略的文件
  })
]

```

