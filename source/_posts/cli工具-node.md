---
title: cli工具(node)
description: node实现cli工具
abbrlink: 2011156422
date: 2020-05-25 21:13:54
---

# 初始化工程

```javascript
// bin/index.js 指定脚本解释器为node
#!/usr/bin/env node
```

```json
// package.json
"bin": {
 "create": "./bin/index.js"
}
```

```shell
// 将npm 模块链接到对应的运⾏项⽬中去
npm link
```

# 定制命令行界面

```javascript
// bin/index.js
const program = require('commander'); // commander包
program.version(require('../package').version);

program
 .command('init <name>')
 .description('init project')
 .action(name => {
	console.log('init ' + name);
})

program.parse(process.argv);
```



# 欢迎界面

```javascript
// /lib/init.js
const { promisify } = require('util');
const figlet = promisify(require('figlet'));
const clear = require('clear');
const chalk = require('chalk');
const log = content => console.log(chalk.green(content));
module.exports = async name => {
 // 打印欢迎画⾯
 clear();
 const data = await figlet('Create' + name);
 log(data);
}
```

```javascript
program
 .command('init <name>')
 .description('init project')
 .action(require('../lib/init'))
```

# 克隆模板

```javascript
// /lib/download.js
const { promisify } = require('util');
module.exports.clone = async function(repo,desc) {
 const download =promisify(require('download-git-repo'));
 const ora = require('ora');
 const process = ora(`下载.....${repo}`);
 process.start();
 await download(repo, desc);
 process.succeed();
}

// /lib/init.js
log('创建项⽬:' + name);
await clone('github:monkeycf/vue-template', name); // 项目
```



# 安装依赖

```javascript
// promisiy化spawn
// 对接输出流
const spawnHandler = async (...args) => {
  const spawn = require('cross-spawn');
  return new Promise(resolve => {
    const proc = spawn(...args)
    proc.on('close', () => {
      resolve()
    })
  })
};


log('安装依赖');
await spawnHandler('npm', ['install'], {
  stdio: 'inherit',
  cwd: `./${name}`,
});
log(chalk.green('安装依赖成功'));
```

