---
title: webpack-03-样式处理
description: 对样式的处理，包括loader、文件抽离、文件压缩、自动添加浏览器前缀
categories: webpack
tags:
  - webpack
abbrlink: 137571459
date: 2019-11-17 13:17:09
---

## loader：

特点：

- 单一功能
- 可以写成字符串、数组、对象
- 默认执行顺序：从下往上，从右往左 （ pre -> normal -> inline -> post）

## 样式处理

### css-loader

> 处理@import这样的css语法

### style-loader

> 将css插入到head中



**处理顺序 css -> style**

```javascript
module:{//模块
  rules: [ // 配置规则 
    {
      test: /\.css$/,
      use: [
        {
          loader: 'style-loader',
          options: {
            insert: 'top', // 插入的style位于html head中定义的style上方    
          }
        },
        'css-loader'
      ]
    }
  ]
}
```

## 抽离样式

### mini-css-extract-plugin 

> 打包css为单独文件

```javascript
new MiniCssExtractPlugin({ 
    filename: 'main.[hash:8].css'
})
// 并修改loader，把style-loader改成MiniCssExtractPlugin.loader
```

## 自动添加浏览器前缀

### postcss-loader 和 autoprefixer

调用'postcss-loader'，并配置postcss.config.js

```javascript
module.exports = { 
    plugins: [require('autoprefixer')]
}
```

## css文件压缩

### optimize-css-assets-webpack-plugin 和 uglifyjs-webpack-plugin 

> 打包后css文件压缩。**注意生成环境才有作用**

**使用optimize-css-assets-webpack-plugin压缩css后，js不会被压缩，必须使用uglifyjs-webpack-plugin 实现js压缩。**

```javascript
optimization: {// 优化项  
    minimizer: [    
        new UglifyJsPlugin({   
            cache: true, // 使用缓存  
            parallel: true, // 并发打包
            sourceMap: true, // 映射文件  
        }),    
        new OptimizeCSSPlugin({}) 
    ]
},
```

