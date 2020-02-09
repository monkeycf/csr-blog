---
title: webpack-模拟简单webpack
description: 模拟实现简单webpack
abbrlink: 2020820168
date: 2019-11-15 21:23:05
categories: webpack
tags:
  - webpack
---

## 基本思路：

1. 获取模块内容
2. 生成对应模块id（文件的相对路径）
3. 解析源码为AST
4. 修改AST节点，require-->\__webpack_require__   文件路径为相对路径
5. 保存依赖模块数组
6. 将AST打包回源码
7. 遍历递归依赖数组，修改依赖模块
8. 使用ejs模板打包代码

## 相关配置

### bin

bin相当于运行哪一个命令，执行哪一个文件

```javascript
"bin":{
    "csr-pack": "./bin/csr-pack.js"
}
```

### npm link的流程

> ```javascript
> // 在csr-pack目录下 注意package.json中的bin配置以及后边是bin目录下的csr-pack.js 
> npm link 
> // 在webpack-go5下
> npm link csr-pack
> ```

## AST 抽象语法树

### babylon

把源码转化为AST

### @babel/traverse

遍历AST节点

### @babel/types

替换AST节点

### @babel/generator

将AST打包为源码



> process.cwd()
>
> 获取当前工作目录



## 手写loader思路:

1. loader其实就是一个函数
2. 新增style-loader 和less-loader两个函数
3. 配置webpack.config.js中rules，为两个文件的绝对路径 
4. 在getSource获取源码时，对文件路径进行正则匹配
5. 匹配成功的文件 进行从后往前调用函数处理



##　plugin： 使用tapable实现生命周期控制



## 代码下载

[下载csr-pack代码](http://img.chensenran.top/csr-pack-1573983594396.zip)



## 主要相关代码

```javascript
// compiler.js
const path = require('path');
const fs = require('fs');
const babylon = require('babylon')
const types = require('@babel/types')
const traverse = require('@babel/traverse').default
const generator = require('@babel/generator').default
const ejs = require('ejs')
const {SyncHook} = require('tapable')

class Compiler {
  /**
   * 构造函数
   * @param config 配日信息
   */
  constructor(config) {
    this.config = config;
    this.entryId; // 需要保存入口文件的路径 './src/index.js'
    // 入口路径
    this.entry = config.entry;
    this.modules = {};
    this.root = process.cwd(); // 工作路径
    this.assets = {}; // 输出的多个文件
    this.hooks = {
      entryOptions: new SyncHook(),
      compile: new SyncHook(),
      afterCompile: new SyncHook(),
      afterPlugins: new SyncHook(),
      run: new SyncHook(),
      emit: new SyncHook(),
      done: new SyncHook(),
    };

    // 调用插件
    let plugins = this.config.plugins;
    if (Array.isArray(plugins)) {
      plugins.forEach(plugin => {
        plugin.apply(this);
      })
    }
  }

  /**
   * 获取文件内容，并处理loader
   * @param modulePath 文件的绝对路径
   * @return {string | ArrayBuffer} // 文件内容
   */
  getSource(modulePath) {
    let content = fs.readFileSync(modulePath, 'utf8');
    // 获取需要处理的loader数组
    let {rules} = this.config.module;
    rules.forEach(rule => {
      // 对test选项进行正则匹配
      if (rule.test.test(modulePath)) {
        let use = rule.use;
        let len = use.length - 1;

        function normalLoader() {
          // 使用loader函数处理
          content = require(use[len--])(content);
          // 不止一个loader，递归调用后续loader进行依次处理
          if (len >= 0) {
            normalLoader();
          }
        }

        normalLoader();
      }
    })
    return content;
  }

  /**
   * 解析修改源码
   * @param source // 源码
   * @param parentPath // 父路径
   * @return {{sourceCode: *, dependencies: *}} // sourceCode：修改后的源码，dependencies：子依赖模块
   */
  parse(source, parentPath) {
    // 源码解析为AST
    let ast = babylon.parse(source);
    let dependencies = []; // 模块依赖数组
    traverse(ast, {
      CallExpression(p) {
        let {node} = p; // 对应的节点
        if (node.callee.name === 'require') {
          node.callee.name = ' __webpack_require__';

          let moduleValue = node.arguments[0].value;
          moduleValue = moduleValue + (path.extname(moduleValue) ? '' : '.js'); // 判断是否有后缀名
          moduleValue = `./${path.join(parentPath, moduleValue)}`.replace(/\\/g, '/'); // 修改为相对路径
          dependencies.push(moduleValue); // 添加依赖模块
          node.arguments = [types.stringLiteral(moduleValue)]; // 修改AST节点
        }
      }
    })
    let sourceCode = generator(ast).code;
    return {sourceCode, dependencies};
  }

  /**
   * 构建模块
   * @param modulePath 文件的绝对路径
   * @param isEntry 是否为主入口文件
   */
  buildModule(modulePath, isEntry) {
    // 拿到模块的内容
    let source = this.getSource(modulePath);
    // 生成模块id  = modulePath - root
    let moduleName = `./${path.relative(this.root, modulePath)}`.replace(/\\/g, '/');
    // 保存主入口路径
    if (isEntry) {
      this.entryId = moduleName
    }
    // 解析需要改造的源码 并返回依赖列表
    const {sourceCode, dependencies} = this.parse(source, path.dirname(moduleName));
    // 把相对路径和模块中的内容对应起来
    this.modules[moduleName] = sourceCode;

    // 遍历 递归依赖列表
    dependencies.forEach(dep => {
      this.buildModule(path.join(this.root, dep), false); // 不是主入口
    })
  }

  /**
   * 写入打包完成的文件
   */
  emitFile() {
    this.hooks.emit.call();

    const outputPath = path.resolve(this.config.output.path, this.config.output.filename); // 输出文件路径
    const ejsFile = this.getSource(path.resolve(__dirname, 'main.ejs'));
    const renderFile = ejs.render(ejsFile, {
      entryId: this.entryId,
      modules: this.modules,
    })
    this.assets [outputPath] = renderFile;
    fs.writeFileSync(outputPath, renderFile);
  }

  /**
   * 执行函数
   */
  run() {
    this.hooks.run.call();

    this.hooks.compile.call();
    // 执行 并且创建模块的依赖关系
    this.buildModule(path.resolve(this.root, this.entry), true)
    this.hooks.afterCompile.call();

    // 创建一个文件，打包后的文件
    this.emitFile();

    this.hooks.done.call();
  }
}

module.exports = Compiler;
```

