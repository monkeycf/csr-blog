---
title: webpack-13-resolve配置
description: resolve
categories: webpack
tags:
  - webpack
abbrlink: 238912262
date: 2019-11-17 16:32:59
---

## resolve

* modules

  ```javascript
  modules: [path.resolve(__dirname, 'node_modules')], // 只在 node_modules 文件夹中寻找
  ```

* alias

  配置别名 vue -> vue.runtime

  ```javascript
  alias: { 
      bootstrap: 'bootstrap/dist/css/bootstrap.css'
  }
  ```

* mainFields

  配置主要字段

  ```javascript
  mainFields: ['style', 'main']
  ```

* mainFiles

  ```javascript
  mainFiles: [], // 入口文件的名字
  ```

* extensions

  查找文件后缀

  ```javascript
  extensions: ['.css', '.js', '.vue']
  ```

