---
title: webpack-关于loader
abbrlink: 3209949814
date: 2019-11-16 12:27:30
description: 模拟实现简单loader
categories: webpack
tags:
  - webpack
---

## loader寻找路径

```javascript
resolveLoader: { // 配置解析文件
  modules: ['node_modules','。/src/loaders']
},
```

## loader的执行顺序：

> **pre -> normal -> inline -> post**

```javascript
 enforce: 'pre'  // 改变loader的顺序 pre，post，normal
```

### inline-loader

```javascript
const a = require('inline-loader!./a.js')
// -！不会让文件再进行pre+normal的loader处理了
// ! 不要normal
// ！！ 除了inline，其他什么都不要
const a = require('-!inline-loader!./a.js')
```

## loader分类：

* pitchLoader
* normalLoader

![](http://img.chensenran.top/1573878274068.png)

![](http://img.chensenran.top/1573878356709.png)

## 手动实现loader

### loader-utils

使用loader-utils包可以获取config中的相关配置

```javascript
const options = loaderUtils.getOptions(this);
```



## 代码下载

* [babel-loader](http://img.chensenran.top/babel-loader-1573984511959.zip)

* [banner-loader](http://img.chensenran.top/banner-loader-1573984622740.zip)

* [less-loader](http://img.chensenran.top/less-loader-1573984713912.zip)

* [css-loader](http://img.chensenran.top/css-loader-1573984923662.zip)

* [style-loader](http://img.chensenran.top/style-loader-1573985011474.zip)

* [url-loader](http://img.chensenran.top/url-loader-1573985064193.zip)

* [file-loader](http://img.chensenran.top/file-loader-1573985124943.zip)

## 相关代码

### babel-loader

```javascript
let babel = require("@babel/core");
//loaderUtils 拿到预设  便于后期转化代码
let loaderUtils = require("loader-utils");
function loader(source) { // this loaderContext
  //Object.keys方法  属性转成一个数组
  let options = loaderUtils.getOptions(this);
  // console.log(this.resourcePath)  运行时返回一个绝对路径
  //console.log(options);
  // options 打印为{ presets: [ '@babel/preset-env' ] }
  let cb = this.async() // loader上下文 默认有async这个方法 异步执行 在哪执行调用cb就可以
  //babel的transform有三个参数  第一个 转换哪些代码  第二个 转换选项  第三个 异步回调函数
  babel.transform(source,{
    ...options, //对象展开
    sourceMap: true, //调试工具 需要webpack.config.js 也要配置 source-map
    filename:  this.resourcePath.split('/').pop()//文件名  不然运行时 webpack下边是unkown

  },function(err,result){
    //异步回调  return source就不起作用了
    cb(err,result.code,result.map)  // 异步 cb(123) 会错误 必须严格按照参数来 
    // 第一个 错误  第二个  代码  第三个 sourceMap
  })
  // return source; 不起作用
}
module.exports = loader;
```

### banner-loader

```javascript
let loaderUtils = require('loader-utils')
//骨架校验
let validateOptions = require('schema-utils')
//读取文件模块
let fs = require('fs')
function loader(source){
  this.cacheable && this.cacheable() //一般这样用 
  //this.cacheable(false) //缓存  自动缓存
  let options = loaderUtils.getOptions(this)
  let cb = this.async() //异步必备
  let schema = {
    type: 'object',
    properties: {
      text: {
        type: 'string',

      },
      filename: {
        type: 'string'
      }
    }
  }
  //将骨架和参数对比   'banner-loader'出问题（如果报错）
  validateOptions(schema,options,'banner-loader')
  if(options.filename){
    this.addDependency(options.filename) //自动地 添加文件依赖   加入这一句话 开启实时监控 webpack也会监控这个文件 这个文件更新也会实时更新
    fs.readFile(options.filename,'utf-8',function(err,data){
      cb(err,`/**${data}**/${source}`)
    })
  }else {
    //同步也得 cb调用了
    cb(null,`/**${options.text}**/${source}`)
  }
  // return source 又是异步  需要创建一个cb
}

module.exports = loader
```

### less-loader

```javascript
let less = require('less')
function loader(source) {
  let css
  less.render(source,(err,r) => {
    css = r.css
  })
  return css
}

module.exports = loader

```

### css-loader

```javascript
function loader(source) {
  let reg = /url\((.+?)\)/g
  //第一次查找肯定是从零开始查找
  let pos = 0
  let arr = ['let list = []']
  while(current = reg.exec(source)) {
    let [matchUrl,g] = current
    //reg.lastIndex 对应着匹配最后一个字符的长度 matchUrl对应着url('./lala.jpg')的长度
    //相减可以得到前边的不包含 url的值
    let last = reg.lastIndex - matchUrl.length
    arr.push(`list.push(${JSON.stringify(source.slice(pos,last))})`)
    //把 g 替换成ruquire的写法
    arr.push(`list.push('url('+ require(${g}) +')')`)
    pos = reg.lastIndex
    // 添加后边的
    arr.push(`list.push(${JSON.stringify(source.slice(pos))})`)
    arr.push(`module.exports = list.join(' ')`)
   return arr.join('\r\n')
  }
  return source
}

module.exports = loader
```

### style-loader

```javascript
let loaderUtils = require('loader-utils')
let style = ''
function loader(source) {
  console.log(source)
  return `style = document.createElement('style')
  style.innerHTML = ${JSON.stringify(source)}
  document.head.appendChild(style)`
}
//在 style-laoder pitch上写一个返回值  就不执行后边  没有pitch source是一个css解析完成的字符串
loader.pitch = function(remainingRequest){
  //loaderUtils.stringifyRequest(this,'!!'+remainingRequest) 会把绝对路径转化为相对路径 
  // 这样做是为了 相当于引入一个inline-loader来处理css-loader返回的值  不需要再走其他的loader 需要加'!!'
  // 参照 pitch用法以及inline-loader使用方式来理解
  // 就是 把 css转化的 list数组 转化为 style-loader能看懂的 字符串 
  return `style = document.createElement('style')
  style.innerHTML = require(${loaderUtils.stringifyRequest(this,'!!'+remainingRequest)})
  document.head.appendChild(style)`
}
module.exports = loader
```

### url-loader

```javascript
let loaderUtils = require('loader-utils')
// 获取后缀名
let mime = require('mime')
function loader(source) {
  let {limit} = loaderUtils.getOptions(this)
  if(limit && limit>source.length){
    //转成base64编码
    return `module.exports = "data:${mime.getType(this.resourcePath)};base64,${source.toString('base64')}"`
  }else {
    // 返回file-loader  this和source通过call传入 防止参数变乱
    return require('./file-loader').call(this,source)
  }
}
loader.raw = true //转为二进制
module.exports = loader
```

### file-loader

```javascript
let loaderUtils = require('loader-utils')
function loader(source){
  //根据当前格式 来生成图片路径 
  let filename = loaderUtils.interpolateName(this,'[hash].[ext]',{content: source}) //根据当前内容来产生hash值
  this.emitFile(filename,source)  //内部方法 发射文件
  //处理 图片 需要返回一个模块
  return `module.exports = "${filename}"`
}
loader.raw = true  //返回二进制
module.exports = loader
```

