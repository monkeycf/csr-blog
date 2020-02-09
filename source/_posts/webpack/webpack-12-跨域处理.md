---
title: webpack-12-跨域处理
description: 三种方法的webpack跨域处理
categories: webpack
tags:
  - webpack
abbrlink: 2226730837
date: 2019-11-17 15:13:12
---

## webpack处理跨域

1. 代理，重定向

   ```javascript
   devServer: {
       proxy: {
           '/api': { // 捕获路径
               target: 'http://localhost:3000', // 重定向
               pathRewrite: {      
                   api: '' // 重写path
               }  
           } 
       }
   }
   ```

2. 前端mock数据模拟

   ```javascript
   devServer: { 
       before(app) {  
           app.get('/api/user', (req, res) => {   
               res.end('hello')  
           }) 
       }
   }
   ```

3. 服务端运行

   #### webpack-dev-middleware

   ```javascript
   const WebpackDevMiddleware = require('webpack-dev-middleware')
   
   const config = require('./webpack.config')
   const compiler = webpack(config)
   
   app.use(WebpackDevMiddleware(compiler))
   ```

