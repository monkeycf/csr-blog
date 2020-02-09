---
title: webpack-14-定义环境变量
description: webpack环境变量
categories: webpack
tags:
  - webpack
abbrlink: 2969611587
date: 2019-11-17 16:37:26
---

## 定义环境变量

>  当我们在配置的时候，需要区分所配置的属性参数是属于生产环境还是开发环境。每个环境对应的配置都不同。这就是环境变量最重要的意义。 
>
> 使用webpack内置插件DefinePlugin

```javascript
new webpack.DefinePlugin({  
    DEV: JSON.stringify('dev'),
 		DEV:'"dev"'
		EXPRESSION:'1+1', // 这样解析出来就是2，而不是'1+1'，
		FLAG：'true', // 解析出来就是true
})
```

