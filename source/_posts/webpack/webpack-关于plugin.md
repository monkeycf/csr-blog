---
title: webpack-关于plugin
description: 模拟实现简单plugin
categories: webpack
tags:
  - webpack
abbrlink: 302735564
date: 2019-11-17 18:22:51
---

## webpack如何调用plugin

>  node_modules下的webpack下的lib中的Compiler.js

```javascript
//node_modules下的webpack下的lib中的compile.js
// 有一些钩子
const childCompiler = new Compiler(this.context);
if (Array.isArray(plugins)) {
	for (const plugin of plugins) {
		plugin.apply(childCompiler);
	}
}
```

## 代码下载

[AsyncPlugin](http://img.chensenran.top/AsyncPlugin-1573986344865.zip)

[DonePlugin](http://img.chensenran.top/DonePlugin-1573986513412.zip)

[FileListPlugin](http://img.chensenran.top/FileListPlugin-1573986599709.zip)

[HtmlWebpackPlugin](http://img.chensenran.top/HtmlWebpackPlugin-1573986682662.zip)

## 相关代码

### AsyncPlugin

```javascript
class AsyncPlugin {
  
  apply(compiler){
    //这样是一个同步代码
    console.log(2)
    compiler.hooks.emit.tapAsync('AsyncPlugin',(compliation,cb)=>{
      setTimeout(()=>{
        console.log('等一下')
        cb()
      },1000)
    })
    compiler.hooks.emit.tapPromise('AsyncPlugin',(compliation)=>{
      return new Promise((resolve,reject)=>{  
        setTimeout(()=>{
          console.log('再等一下')
          resolve()
        },1000)
      })
    })
  }
}
module.exports = AsyncPlugin
```

### DonePlugin

```javascript
class DonePlugin{
  apply(compiler) // compiler.hooks
  {
    //这样是一个同步代码
    console.log(1)
    //第一个参数无所谓，放啥都可以  tapable的时候也是
    compiler.hooks.done.tap('DonePlugin',(states)=>{
      console.log('编译完成哦哦哦')
    })
  }
}
//还需要导出一下
module.exports = DonePlugin
```

### FileListPlugin

```javascript
class FileListPlugin {
  constructor({ filename }) {
    this.filename = filename;
  }
  apply(compiler) {
    //文件准备好了，要进行发射
    compiler.hooks.emit.tapAsync("FileListPlugin", (compilation, cb) => {
      // compilcation有很多的属性
      // 打包的资源都会放在compilcation的assets属性上
      // console.log(compilation.assets)
      let content = `##  文件名    资源大小\r\n`;
      let assets = compilation.assets;
      //Object.entries() 可以把对象变成一个数组
      Object.entries(assets).forEach(([filename, staObj]) => {
        content += `-  ${filename}    ${staObj.size()}\r\n`;
      });

      assets[this.filename] = {
        source() {
          return content;
        },
        size() {
          return content.length;
        }
      };
      cb()
    });
  }
}
module.exports = FileListPlugin;
```

### HtmlWebpackPlugin

```javascript
const HtmlWebpackPlugin = require('html-webpack-plugin');
//把外链标签变成内联
class InlineSourcePlugin{
  constructor({test}){
    this.reg = test //正则
  }
  processTag(tag,compilation) {
    let newTag,url
    if(tag.tagName==='link'&&this.reg.test(tag.attributes.href)){
      newTag = {
        tagName: 'style',
        attributes: {
          type: 'text/css'
        }
      }
      url = tag.attributes.href
    }else if(tag.tagName==='script'&&this.reg.test(tag.attributes.src)){
      newTag = {
        tagName: 'script',
        attributes: {
          type: 'application/javascript'
        }
      }
      url = tag.attributes.src
    }
    if(url){
      newTag.innerHTML = compilation.assets[url].source() //文件内容
      //删除这一个资源
      delete  compilation.assets[url]
      return newTag
    }
    return tag
  }
  processTags(data,compilation){
    let bodyTags = []
    let headTags = []
    data.headTags.forEach(headTag => {
      headTags.push(this.processTag(headTag,compilation))
    })
    data.bodyTags.forEach(bodyTag => {
      bodyTags.push(this.processTag(bodyTag,compilation))
    })
    return {...data,headTags,bodyTags}
  }
  apply(compiler){
    //要通过 HtmlWebpackPlugin的钩子来实现这一功能 根据官网文档修改
    compiler.hooks.compilation.tap('InlineSourcePlugin', (compilation) => {
      HtmlWebpackPlugin.getHooks(compilation).alterAssetTagGroups.tapAsync(
        'AfterPlugin', 
        (data, cb) => {
          //将link变成内联  script变成内联
          data = this.processTags(data,compilation) //compilation.assets 资源
          cb(null, data)
        }
      )
    })
  }
}

module.exports = InlineSourcePlugin
```

