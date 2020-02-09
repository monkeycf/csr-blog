---
title: webpack-02-html插件及webpack-dev-server
categories: webpack
tags:
  - webpack
description: html-webpack-plugin和webpack-dev-server基础配置
abbrlink: 1781771991
date: 2019-11-17 12:50:30
---

## webpack-dev-server

开发环境配置

```javascript
devServer: { // 开发服务器的配置 
    port: 3000, // 端口号
    progress: true, // 显示进度条  
    contentBase: ('./dist'), // 设置启动目录
    open: true, // 打开浏览器
    compress : true, // 资源采用gzip压缩
},
```



## webpack配置插件

```javascript
plugins:[]
```



## html-webpack-plugin

打包html文件

```javascript
new HtmlWebpackPlugin({  
    template: './src/index.html', 
    filename: 'index.html', 
    minify: { 
        removeAttributeQuotes: true, // 删除双引号   
        collapseWhitespace: true, // 压缩空行 
    }, 
    hash: true, // 给生成的js文件，添加hash戳(比如：bundle.ab24e2bd.js?ab24e2bd1cf2c8ab6a33)
})
```

