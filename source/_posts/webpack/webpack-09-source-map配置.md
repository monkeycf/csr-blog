---
title: webpack-09-source-map配置
description: source-map的配置
categories: webpack
tags:
  - webpack
abbrlink: 2431670147
date: 2019-11-17 14:50:58
---

## source-map

> 该配置是用于映射源码的，用于调试功能

## 配置

1. 源码映射,会单独生成一个sourcemap文件(.map格式),出错了,会标识出错的当前列和行

   ```javascript
   module.exports = {
       devtool:'source-map'
   }
   ```

2. 不会产生单独的sourcemap文件(.map格式) ，但是可以显示行和列

   ```javascript
   2. module.exports = {
          devtool:'eval-source-map'
      }
   ```

3. 会单独生成一个sourcemap文件(.map格式) ,但不会产生单独的列,只能定位到行 但是是一个单独的映射文件,用得不多

   ```javascript
   module.exports = {
       devtool:'cheap-module-source-map',//产生后你可以保留起来，用于调试
   }
   ```

   4. 不会产生单独的sourcemap文件(.map格式)，继承在打包后的文件中，不会产生列,只能定位到行

      ```javascript
      module.exports = {
         devtool:'cheap-module-eval-source-map',
      }
      ```