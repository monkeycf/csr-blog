---
title: script元素属性
categories: JavaScript高级程序设计
description: script元素属性
tags:
  - JavaScript
abbrlink: 2575492771
date: 2020-01-06 21:36:11
---

# async

异步执行脚本，**仅适用于外部脚本**

立即下载脚本，但不应该妨碍页面中的其他操作。

* 如果 async="async"：脚本相对于页面的其余部分异步地执行（当页面继续进行解析时，脚本将被执行）

- 如果不使用 async 且 defer="defer"：脚本将在页面完成解析时执行
- 如果既不使用 async 也不使用 defer：在浏览器继续解析页面之前，立即读取并执行脚本



#  crossorigin

允许本地获取到跨域脚本的错误信息

> 引入跨域的脚本，如果这个脚本有错误，因为浏览器的限制（根本原因是协议的规定），是拿不到错误信息的。当本地尝试使用 `window.onerror` 去记录脚本的错误时，跨域脚本的错误只会返回 `Script error`。

> 允许本地获取到跨域脚本的错误信息，两个条件:
>
> 1. 跨域脚本的服务器必须通过 `Access-Controll-Allow-Origin` 头信息允许当前域名可以获取错误信息
> 2. 当前域名的 `script` 标签也必须指明 `src` 属性指定的地址是支持跨域的地址，也就是 crossorigin 属性。  

值：

* anonymous：不设置凭据标志
* use - credentials：请求将提供凭据



# defer

表示标本可以延迟到文档完全被解析和显示之后再执行，在 DOMContentLoaded 事件前执行。

**仅对外部文件有效**

#  integrity

 包含用户代理可用于验证已提取资源是否已无意外操作，如CDN。

>  密码散列可以唯一标识一个数据块，任何两个文件的密码散列均不相同

# nomodule

标明这个脚本在支持 ES2015 modules 的浏览器中不执行

#  nonce

用于  script-src Content-Security-Policy（CSP，内容安全策略，防XSS和数据注入攻击)中白名单内联脚本的密码（一次性）

#  referrerpolicy

获取脚本时的referer

详见[MDN]( https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/script#referrerpolicy )中的referrerpolicy

# src

这个属性定义引用外部脚本的URI，这可以用来代替直接在文档中嵌入脚本。

指定了 src 属性的script元素标签内不应该再有嵌入的脚本。

# type

此属性指示所表示的脚本类型。该属性的值属于以下类别之一:

* 省略或JavaScript MIME类型：这表明脚本是JavaScript。
  * HTML5规范要求作者省略该属性，而不是提供冗余的MIME类型。
  * 在早期的浏览器中，这标识了嵌入或导入(通过src属性)代码的脚本类型。
* 模块：将代码视为JavaScript模块。
  * 脚本内容的处理不受字符集和延迟属性的影响。
* 任何其他值：嵌入的内容被视为数据块，浏览器不会处理它。开发人员必须使用非JavaScript MIME类型的有效MIME类型来表示数据块。src属性将被忽略。