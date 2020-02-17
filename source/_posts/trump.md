---
title: trump
tags:
  - trump
categories: 
  - trump
description: >-
  A modern JavaScript utility library delivering modularity, performance, &amp;
  extras.
abbrlink: 3643414376
date: 2020-02-17 13:53:43
---

# trump

* [github](https://github.com/monkeycf/trump): https://github.com/monkeycf/trump
* [npm](https://www.npmjs.com/package/@monkeycf/trump): https://www.npmjs.com/package/@monkeycf/trump
* [document](https://trump.chensenran.top): https://trump.chensenran.top

# 组织架构

* TypeScript
* Jest
* webpack
* ESLint
* Prettier
* VuePress
* pre-commit
* Treavis CI

## TypeScript

* 项目使用TypeScript版本为3.7.5

* 编译脚本

  ```js
  npm run build
  ```

  

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "commonjs",
    "lib": [
      "DOM",
      "DOM.Iterable",
      "ESNext"
    ],
    "outDir": "./lib", // 输出的目录，npm发布的入口
    "isolatedModules": false,
    "strict": true,
    "moduleResolution": "node",
    "baseUrl": ".",
    "paths": {
      "*": [
        "./*",
        "types/*"
      ]
    },
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true
  },
  "exclude": [
    "node_modules"
  ],
  "include": [ // 源文件的路径
    "types/**/*",
    "src/**/*"
  ]
}
```

## Jest

* 实现单元测试

* 运行测试

  ```javascript
  npm run test
  ```

## webpack

* 运行example目录下的例子

* 运行脚本

  ```javascript
  npm run start
  ```

  

## ESLint

* 代码监测工具

* 运行脚本

  ```javascript
  npm run lint
  ```

  ```json
  module.exports = {
    parser: '@typescript-eslint/parser', // ESLint的解析器
    extends: ['plugin:@typescript-eslint/recommended'],
    plugins: ['@typescript-eslint'],
    env: {
      browser: true,
      node: true,
    }
  };
  ```

## Prettier

* 代码格式化工具

* 运行脚本

  ```javascript
  npm run fix
  ```

## VuePress

* Vue静态网站生成器，构建相关API文档（[doc](https://trump.chensenran.top): https://trump.chensenran.top）

* 文档预览

  ```javascript
  npm run docs:dev
  ```

* 文档打包

  ```javascript
  npm run docs:build
  ```

## pre-commit

* 管理维护（在预提交时运行相关脚本，以实现对提交代码的审核）

## Treavis CI

* 持续集成服务

* 相关配置

  目前有3个job，其中 'npm release' 只在修改tag的提交中运行。

  ```yml
  // .travis.yml
  language: node_js
  node_js:
    - '12'
  install:
    - npm install
  jobs:
    include:
      - stage: test
        script:
          - npm run unit
      - stage: GitHubPages
        script:
          - npm run docs:build
        deploy:
          provider: pages
          skip_cleanup: true
          github_token: $GET_REPO_TOKEN
          keep_history: true
          local_dir: ./docs/.vuepress/dist
          fqdn: trump.chensenran.top
          on:
            branch: master
      - stage: npm release
        if: tag IS present
        node_js: "12"
        script: npm run build
        deploy:
          provider: npm
          email: $NPM_EMAIL
          api_key: $NPM_TOKEN
          skip_cleanup: true
          tag: latest
          on:
            tags: true
  ```