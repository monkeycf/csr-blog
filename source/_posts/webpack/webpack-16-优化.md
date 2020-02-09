---
title: webpack-16-优化
description: webpack的优化
categories: webpack
tags:
  - webpack
abbrlink: 1579032732
date: 2019-11-17 16:44:03
---

## noParse

>  这是module中的一个属性，作用：
> 不去解析属性值代表的库的依赖 , 以增加打包速率 

```JavaScript
module: {
    noParse: /jquery/
}
```

## exclude和include

> loader解析时指定和排除查找目录

```javascript
exclude:/node_modules/,//解析不包含的目录,两者写其一即可
include:path.resolve('src'),//即系包含的目录,两者写其一即可
```

## IgnorePlugin

>   忽略第三方包指定目录，让这些指定目录不要被打包进去 

```javascript
// 以moment为例
// webpack.config.js
plugins: [
    new webpack.IgnorePlugin(/\.\/locale/,/moment/)
],

//index.js
import moment from 'moment';
import 'moment/locale/zh-cn'; // 因打包时忽略引入，可手动引入语言包。否则设置无效

moment.locale('zh-cn');
```



## dllplugin

> 将不变的包单独打包，后续就不再进行打包

## happypack

> 多线程打包

```javascript
let HappyPack = require('happypack');

module.exports = {
    ...
    module:{
        rules:[
            {
                test:/\.js$/,
                use:'HappyPack/loader?id=js'//这个id=js就代表这是打包js的
            },
            {
                test:/\.css$/,
                use:'HappyPack/loader?id=css'//这个id=css就代表这是打包css的
            }
        ]
    },
    plugins:[
        new HappyPack({这个id:js就代表这是打包js的
            id:'css',//
            use:['style-loader','css-loader']
        }),
        new HappyPack({这个id:js就代表这是打包js的
            id:'js',//
            use:[{//use是一个数组，这里写原先在rules的use里的loader配置
                loader:'babel-loader',
                options:{
                    presets:[
                        '@babel/presets-env',
                        '@babel/presets-react'
                    ]
                }
            }]
        })
    ]
}
```



## webpack在生产环境自带优化项

### tree-shaking

>  使用import语法，在生产化境下 会自动删除没用的代码。（require无效）

### scope hosting

>  作用域提升

```javascript
let a = 1;
let b = 2;
let c = 3;
let d = a + b + c;
console.log(d); // console.log(6);
```

## 抽离公共模块(多页面应用)

```javascript
optimization: {  
    splitChunks: { // 分割代码  
        cacheGroups: { // 缓存组  
            comment: { // 公共代码      
                chunks: 'initial',
                minSize: 0,        
                minChunks: 2, // 最小引用次数    
            },    
            vendor: { // 第三方模块      
                priority: 1, // 权重，先运行   
                test: /node_modules/, // 使用node_modules文件夹中的包时 单独打包  
                chunks: 'initial',    
                minSize: 0,    
                minChunks: 2, 
            }  
        }
    }
},
```

## 懒加载（动态加载）

> 使用*import()*，可以实现懒加载

```javascript
import('./a')
```

## 热更新

1. 在devServer中开启hot配置为true
2. 添加两个webpack的内置插件，分别为new webpack.NamedModulesPlugin()和new webpack.HotModuleReplacementPlugin(),前者用于打印更新的模块路径，告诉我们哪个模块热更新了；后者是热更新插件。

```javascript
// webpack.config.js
let path = require('path');
let webpack = require('webpack');
let HtmlWebpackPlugin = require('html-webpack-plugin');
module.exports = {
  devServer:{
    port:3001,
    open:true,
    contentBase:'./dist',
    hot:true,//启用热更新
  },
  ...
  plugins:[
  	new webpack.NamedModulesPlugin(),//打印更新的模块路径，告诉我们哪个模块热更新了
  	new webpack.HotModuleReplacementPlugin(),//热更新插件
  	new HtmlWebpackPlugin({
    	template:'./src/index.html',
    	filename:'index.html'
  	})
	]
}
```

