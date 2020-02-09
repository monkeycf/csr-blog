---
title: webpack-01-基础配置与打包文件解析
description: webpack基础配置与打包后的文件解析
categories: webpack
tags:
  - webpack
abbrlink: 1805775917
date: 2019-11-09 11:23:10
---

## webpack

模块打包

* 代码转换
* 文件优化
* 代码分割
* 模块合并
* 自动刷新
* 代码校验
* 自动发布



## webpack安装

- 安装本地的webpack
- webpack webpack-cli -D



## webpack可以进行0配置

- 打包工具 -> 输出后的结果（js模块）
- 打包（支持js的模块化）

## 手动配置webpack

- 默认配置文件的名字 webpack.config.js 或 webpackfile.js

  （node_modules->webpack-cli->bin->config-yargs.js 配置）

- 模式：produce development

- entry：入口

- output：打包后的文件配置

```javascript
const path = require('path')
module.exports = {  
    mode: 'production',//模式 默认两种 production development  
    entry: './src/index.js', //入口 
    output: {   
        filename: 'bundle.js', //打包后的文件名  
        path: path.resolve(__dirname, 'dist'), // 路径必须是决定路径 
    }
}
```

## 打包后的文件分析

- 实现单例缓存（key，value），require方法
- 个文件模块

```javascript
(function (modules) { 
    // webpackBootstrap  
    // 定义一个缓存 
    // 以形式key ： {} 存储 
    var installedModules = {}; 
    // 现了require 
    function __webpack_require__(moduleId) {    
        // Check if module is in cache   
        if (installedModules[moduleId]) { // 检查是否在缓存中  
            return installedModules[moduleId].exports;  
        }   
        // Create a new module (and put it into the cache)   
        var module = installedModules[moduleId] = {   
            i: moduleId, 
            l: false,     
            exports: {} 
        }; 
        // Execute the module function 
        modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);   
        // Flag the module as loaded  
        module.l = true;    
        // Return the exports of the module   
        return module.exports; 
    } 
    // Load entry module and return exports 
    return __webpack_require__(__webpack_require__.s = "./src/index.js");
})
({ 
    "./src/a.js":  
    (function (module, exports) {  
        eval("module.exports = \"a\";"); 
    }), 
    "./src/index.js":  
    (function (module, exports, __webpack_require__) {  
        eval("let str = __webpack_require__("./src/a.js")console.log(str);");
    })
});
```

##  配置命令行

```javascript
"scripts": {  
	"build": "webpack --config webpack.config.my.js"
},
```

**注意：命令行运行时 --config webpack.config.my.js不会被认为是一个参数，那么可以写成如下： **

```javascript
// error npm run build --config webpack.config.base.js
npm run build -- --config webpack.config.base.js
```



