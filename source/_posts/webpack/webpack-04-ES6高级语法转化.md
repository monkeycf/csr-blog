---
title: webpack-04-ES6高级语法转化
description: 使用babel对ES6等高级语法的转化
categories: webpack
tags:
  - balbel
  - webpack
abbrlink: 1359659862
date: 2019-11-17 13:43:23
---

## 转化ES6语法使用babel-loader

1. @babel/core

   > babel的核心模块

2. @babel/preset-env

   > 转义为指定版本的es语法

3. babel-loader

*注意报错，根据需求引入babel的插件*

```javascript
{
  test: /\.js$/,
  use: {
    loader: 'babel-loader',
    options: { // 使用babel-loader将es6转为es5   
      presets: [
        '@babel/preset-env'
      ],
    }
  }
}
```

## 高级语法和API兼容

1. @babel/plugin-transform-runtime 和 @babel/runtime

   > 可实现高级语法处理，如 Generator 语法

2. @babel/polyfill

   > 可处理高级api，如includes

## 总结

### 1. 基础loader

1. babel-loader

2. @babel/core  转化的核心模块

3. @babel/preset-env 这是个大包，转化js语法的

### 2.类似generator、promise语法转化

```javascript
npm i @babel/plugin-transform-runtime -D

npm i @babel/runtime --save
```

### 3.es7部分语法支持

1. @babel/plugin-proposal-decorators  这是es7中对class的装饰器的转化（先）

2. @babel/plugin-proposal-class-properties  这是es7中对class新增语法的转化 (后)

### 4.类似includes语法支持

```javascript
npm i @babel/polyfill
```


