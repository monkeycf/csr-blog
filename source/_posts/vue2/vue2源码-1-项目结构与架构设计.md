---
title: Vue2源码-1-项目结构与架构设计
tags:
  - Vue2
  - Vue2源码
categories: Vue2
description: Vue2源码的项目结构和架构设计
abbrlink: 263498561
date: 2020-02-12 22:41:20
---

# Vue2项目结构

|— dist                                  # 构建后的文件

|— flow                                 # Flow的类型声明

|— packages                        # 文件内的包作为单独NPM包发布

|— scripts                             # 与构建相关的脚本和配置文件

|— src                                    # 源代码

|—— compiler                      # 与模 板编译相关

|—— core                              # 通用的、与平台无关的运行时的代码

|——— components            # 通用的抽象组件

|——— global-api                 # 全局API代码

|——— instance                   # Vue.js 实例的构造函数和原型方法

|———observer                   # 实现侦测的代码

|——— util                            # 一些方法

|——— vdom                       # 实现虚拟DOM的代码

|—— platform                      # 特定平台的代码

|—— server                           # 与服务端渲染相关的代码

|—— sfc                                  # 单文件组件解析逻辑

|—— shared                          # 项目的公用工具代码

|—types                                  # TypeScript类型定义。

# 版本

|                      | UMD                | CommonJS              | ES Module（基于构建工具） | ES Module（直接用于浏览器） |
| -------------------- | ------------------ | --------------------- | ------------------------- | --------------------------- |
| 完整版               | vue.js             | vue.common.js         | vue.esm.js                | vue.esm.browser.js          |
| 运行版本             | vue.runtime.js     | vue.runtime.common.js | vue.runtime.esm.js        |                             |
| 完整版（生产环境）   | vue.min.js         |                       |                           | vue.esm.browser.min.js      |
| 运行版本（生产环境） | vue.runtime.min.js |                       |                           |                             |

* 完整版：包含编译器和运行版本
* 编译器：将模板字符串编译成JavaScript渲染函数
* 运行版本：创建Vue实例，渲染视图和虚拟DOM
* UMD：可以通过\<script>标签直接在浏览器中使用
* CommonJS：配合较旧的打包工具
* ES Module：
  * 配合现代打包工具
  * 为浏览器提供（\<script type="module">)

# 架构设计

整体分为三部分：核心代码、跨平台相关、公用工具函数

![vue程序架构设计](http://img.chensenran.top/1581574071527.png)

![](http://img.chensenran.top/1581574276855.png)
