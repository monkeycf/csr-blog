---
title: webpack-06-图片处理
description: 'file-loader,url-loader,html-withimg-loader'
categories: webpack
tags:
  - webpack
abbrlink: 3697560692
date: 2019-11-17 14:17:56
---

## 图片处理

### file-loader

处理js中使用的文件

```javascript
{ 
    test: /\.(jpg|png)$/,  
    use: 'file-loader'
}
```

### html-withimg-loader

在html中直接只用img

```javascript
{ 
    test: /\.html$/, 
    use: 'html-withimg-loader'
}
```

### url-loader

可以把较小的图片直接转为base64（依赖于file-loader)

```javascript
{ 
    test: /\.(jpg|png)$/, 
    use: { 
        loader: 'url-loader',  
        options: {   
            limit: 200 * 1024, // 小于此大小会直接转为base64，插入到HTML文件中
            outputPath : '/img/'
            publicPtah: 'http://img.chensenran.top'
        }
    }
},
```
