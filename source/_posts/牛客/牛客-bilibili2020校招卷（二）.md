---
title: 牛客-bilibili2020校招卷（二）
description: '牛客#bilibili2020校招二卷'
categories: 牛客
tags:
  - 算法
abbrlink: 1241392941
date: 2019-11-25 11:51:11
---

# 错题整理

##  canvas和svg 

| Canvas                                                 | SVG                                                          |
| :----------------------------------------------------- | :----------------------------------------------------------- |
| 通过Javascript来绘制2D图形。                           | 一种使用XML描述的2D图形的语言                                |
| 是逐像素进行渲染的。                                   | SVG基于XML意味着，SVG DOM中的每个元素都是可用的，可以为某个元素附加Javascript事件处理器。 |
| 其**位置发生改变**，会重新进行绘制。                   | 在 SVG 中，每个被绘制的图形均被视为对象。如果 SVG 对象的**属性发生变化**，那么浏览器能够自动重现图形。 |
| **依赖**分辨率                                         | **不依赖**分辨率                                             |
| 不支持事件处理器                                       | 支持事件处理器                                               |
| 弱的文本渲染能力                                       | **最适合带有大型渲染**区域的应用程序（比如谷歌地图）         |
| 能够以 .png 或 .jpg 格式保存结果图像                   | 复杂度高会减慢渲染速度（任何过度使用 DOM 的应用都不快）      |
| 最**适合图像密集型**的游戏，其中的许多对象会被频繁重绘 | **不适合游戏应用**                                           |

## preload & prefetch

### preload 

使用 `preload` 可以对当前页面所需的脚本、样式等资源进行预加载，而无需等到解析到 `script` 和 `link` 标签时才进行加载。 

### prefetch

`prefetch` 加载的资源一般不是用于当前页面的，即未来很可能用到的这样一些资源，利用浏览器空闲时间来下载 

### 总结

对当前页面需要的资源，使用 `preload` 进行预加载，对其它页面需要的资源进行 `prefetch` 预加载。

## transition

> 不是所有的CSS样式值都可以过渡，只有具有中间值的属性才具备过渡效果 
>
> 必须设有初始值

[初始值示例]( https://codepen.io/CHENSENRAN/pen/RwwmLYX )

## 重绘和回流

### 浏览器渲染过程

![](http://img.chensenran.top/1574659924240.png)

1. 解析HTML，生成DOM树，解析CSS，生成CSSOM树
2. 将DOM树和CSSOM树结合，生成渲染树(Render Tree)
3. Layout(回流):根据生成的渲染树，进行回流(Layout)，得到节点的几何信息（位置，大小）
4. Painting(重绘):根据渲染树以及回流得到的几何信息，得到节点的绝对像素
5. Display:将像素发送给GPU，展示在页面上。

### 生成渲染树

![](http://img.chensenran.top/1574660007099.png)

1. 从DOM树的根节点开始遍历每个可见节点。
2. 对于每个可见的节点，找到CSSOM树中对应的规则，并应用它们。
3. 根据每个可见节点以及其对应的样式，组合生成渲染树。



### 回流

> 当render树中的一部分或者全部因为大小边距等问题发生改变而需要重建的过程叫做回流（改变大小）

#### 何时发生回流

1. 添加或者删除可见的DOM元素；

2. 元素位置改变；

3. 元素尺寸改变——边距、填充、边框、宽度和高度

4. 内容改变——比如文本改变或者图片大小改变而引起的计算值宽度和高度改变；

5. 页面渲染初始化；

6. 浏览器窗口尺寸改变——resize事件发生时；

### 重绘

> 当元素的一部分属性发生变化，如外观背景色不会引起布局变化而需要重新渲染的过程叫做重绘（改变样式）

#### 何时发生重绘

1.  元素的属性或者样式发生变化。 

### 总结

**注意：回流必将引起重绘，而重绘不一定会引起回流。**

## 防抖和节流

## 防抖

> 任务频繁触发的情况下，只有任务触发的间隔超过指定间隔的时候，任务才会执行。（重复点击，在最后一次点击后才执行）

场景： 输入框查询

```javascript
function debounce(fn) {
	// 创建一个标记用来存放定时器的返回值
  let timeout = null;
  return function() {
  	// 前一个定时器清除
 	 	clearTimeout(timeout);
 		// 创建新的 setTimeout，
    // 这样就能保证点击按钮后的 interval 间隔内
    // 如果用户还点击了的话，就不会执行 fn 函数
    timeout = setTimeout(() => {
      fn.call(this, arguments);
    }, 1000);
  };
}
```

### 节流

> 指定时间间隔内只会执行一次任务。 

场景：

1. 懒加载要监听计算滚动条的位置，使用节流按一定时间的频率获取。
2. 用户点击提交按钮，假设我们知道接口大致的返回时间的情况下，我们使用节流，只允许一定时间内点击一次。

```javascript
function throttle(fn) {
	// 标记
  let canRun = true;
  return function() {
	  if(!canRun) {
  	  return;
    }
    canRun = false;
    // 定时器
    setTimeout(() => {
    	fn.call(this, arguments);
      canRun = true;
    }, 1000);
  };
}
```

# 编程题整理

##  复数乘法 

> 输入两个表示复数的字符串，输出它们相乘的结果的字符串
>
> 复数字符串用a+bi表示(a, b 为整数, i为虚数单位，i2=1)

### 输入描述

```
两个表示复数的字符串
```

### **输出描述:**

```
两个数相乘的结果的字符串
```

### 示例1

#### 输入

```
1+2i
2+1
```

#### 输出

```
0+5i
```

#### 说明

```
(1+2i)(2+i) = (2 + i + 4i + 2i * i) = 0 + 5i
```

### 示例2

#### 输入

```
1+-2i
3+4i
```

#### 输出

```
11+-2i
```

#### 说明

```
(1+-2i)(3+4i) = (3 + 4i - 6i - 8i * i) = 11+-2i
```

### AC代码

```javascript
function pluralMultiply(num1, num2) {
  let [key1, value1] = num1.toString().split('+');
  let [key2, value2] = num2.toString().split('+');
  value1 = value1.replace('i', '');
  value2 = value2.replace('i', '');
  return `${(+key1 * +key2) - (+value1 * +value2)}+${(+key1 * +value2) + (+key2 * +value1)}i`
}
let t = 1,num1,num2;
while (line = readline()) {
    if(t === 1){
        num1 = line;
    }else{
        num2 = line;
    }
    t++;
}
print(pluralMultiply(num1,num2));
```

##  一年中的第几天 

> 输入一个"YYYY-MM-dd"格式的日期字符串，输出该天是当年的第几天（1 月 1 日是每年的第 1 天） 

### 输入描述:

```
一个"YYYY-MM-dd"格式的表示日期的字符串
```

### **输出描述:**

```
该天是当年的第几天
```

### 示例1

#### 输入

```
2019-01-09
```

#### 输出

```
9
```

### 示例2

#### 输入

```
2004-03-01
```

#### 输出

```
61
```

#### 说明

```
2004年为闰年，所以是第31+29+1=61天
```

### AC代码

```javascript
function getDay(date) {
  const arr = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  const d = new Date(date);
  const month = d.getMonth();
  let sum = 0;
  for (let i = 0; i < month; i++) {
    sum += arr[i];
    if (i === 1) {
      const year = d.getFullYear();
      if (year % 100 === 0) {
        if (year % 400 === 0) {
          sum++;
        }
      } else if (year % 4 === 0) {
        sum++;
      }
    }
 
  }
  sum += d.getDate();
  return sum;
}
while(line = readline()){
    print(getDay(line))
}
```

##  k个一组翻转链表 

给你一个链表，每 k 个节点一组进行翻转，请返回翻转后的链表。

如果节点总数不是 k 的整数倍，那么请将最后剩余的节点保持原有顺序。 

给定这个链表：1->2->3->4->5
当 k = 2 时，应当返回: 2->1->4->3->5
当 k = 3 时，应当返回: 3->2->1->4->5 

### **输入描述:**

```
第一行：依次输入链表中的各个元素，以"#"结束第二行：每组数量k
```

### **输出描述:**

```
处理后的链表中的各个元素，以"->"连接
```

### 示例1

#### 输入

```
1 2 3 4 5 #
2
```

#### 输出

```
2->1->4->3->5
```

### 示例2

#### 输入

```
1 2 3 4 5 #
3
```

#### 输出

```
3->2->1->4->5
```

### AC代码

```javascript
function arrayReverseHandler(arr, num) {
  const t = [];
 
  let count = 0, result = [];
  const pushResult = (temp) => {
    count = 0;
    while (temp.length) {
      result.push(temp.pop());
    }
  }
  arr.forEach((item) => {
    count++;
    t.push(item);
    if (item === '#') {
      t.pop()
    } else if (count === +num) {
      pushResult(t);
    }
  })
  result = result.concat(t);
  return result.join('->');
}
let t = 1,arr,num;
while(line = readline()) {
    if(t++ === 1){
        arr = line.split(" ");
    } else{
        num = line;
    }
}
print(arrayReverseHandler(arr,num))
```

