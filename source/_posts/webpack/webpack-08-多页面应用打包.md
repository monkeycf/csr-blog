---
title: webpack-08-多页面应用打包
description: 对多页面应用的打包
categories: webpack
tags:
  - webpack
abbrlink: 601532459
date: 2019-11-17 14:37:33
---

## 多页应用打包

```javascript
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
module.exports = {
    mode: 'development', 
    entry: {  
        home: './src/index.js', 
        other: './src/other.js' 
    },  
    output: {   
        filename: '[name].js',  
        path: path.resolve(__dirname, 'dist'), 
    }, 
    plugins: [    
        new HtmlWebpackPlugin({    
            filename: 'home.html',  
            src: path.resolve(__dirname, 'index.html'), 
            chunks: ['home']
        }),   
        new HtmlWebpackPlugin({  
            filename: 'other.html',   
            src: path.resolve(__dirname, 'index.html'), 
            chunks: ['other']  
        }) 
    ]
}
```


