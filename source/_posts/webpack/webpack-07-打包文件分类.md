---
title: webpack-07-打包文件分类
description: 打包后的文件分成文件夹存放，统一添加前缀域名
categories: webpack
tags:
  - webpack
abbrlink: 1234541781
date: 2019-11-17 14:25:10
---

## 归类

> 给图片归类到img目录下
> 在url-loader下配置outputPath，大于limit的图片就会生成到dist下的img文件夹下，同时所有路径都会加上这个/img/

```javascript
rules:[
  {
    test: /\.(png|jpg|gif)$/,
    use: {
      loader: 'url-loader',
      options: {
        limit: 2,//200k，小于200k使用base64来转换
        outputPath: '/img/'//大于上面的limit的图片就会生成到dist下的img文件夹下，同时所有路径都会加上这个img/
      }
    }
  }
]
```

> 给css归类到css目录下

```javascript
plugins:[
  new MiniCssExtractPlugin({
    filename: '/css/[name].[chunkhash:8].css',//抽离出来的css的文件名称，并在dist下生成css文件夹，将该文件放到该css目录下，引入的时候会自动加上/css/
  })
],
```

## 加域名前缀
1. 对所有输出资源加域名前缀
   在output配置下家属性publicPath

2. 在引用的资源前，统一加上这个额publicPath，比如打包后的css路径是/css/main.css，那么引用的时候就会成为publicPath值+’/css/main.css’

   ```javascript
   output: {
     filename: 'bundle.[hash:8].js',
     path: path.resolve(__dirname, './dist'),
     publicPath: 'http://www.chensenran.top',//在引用的资源前，统一加上这个额publicPath，比如打包后的css路径是css/main.css，那么引用的时候就会成为publicPath值+'css/main.css'
   }
   ```

   如果有些资源使用了CDN分发，有些没有使用，那么只需要对使用了的资源统一加上域名就可以了
   比如图片使用CDN分发，那么在图片的loader加上publicPath配置

   ```javascript
   rules: [
     {
       test: /\.(png|jpg|gif)$/,
       use: {
         loader: 'url-loader',
         options: {
           limit: 2,//200k，小于200k使用base64来转换
           outputPath: '/img/',//大于上面的limit的图片就会生成到dist下的img文件夹下，同时所有路径都会加上这个/img/
           publicPath: 'http://www.chensenran.top'
         }
       }
     }
   ]
   ```

   