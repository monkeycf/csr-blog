---
title: webpack-11-小插件
categories: webpack
description: clean-webpack-plugin，copy-webpack-plugin，BannerPlugin
tags:
  - webpack
abbrlink: 1792782665
date: 2019-11-17 15:10:56
---

## webpack小插件

1. clean-webpack-plugin 可清除原打包文件

   ```javascript
   const { CleanWebpackPlugin } = require('clean-webpack-plugin')
   const webpackConfig = {
       plugins: [
           new CleanWebpackPlugin(),
       ],
   };
    
   module.exports = webpackConfig;
   ```

2. copy-webpack-plugin 可拷贝文件

   ```javascript
   new CopyWebpackPlugin([ 
       {from: 'src', to: './'}
   ])
   ```

3. BannerPlugin 在打包的文件开始处添加信息（webpack内置）

   ```javascript
   const webpack = require('webpack')
   new webpack.BannerPlugin('make by csr hhh')
   ```

