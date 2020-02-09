---
title: 'leetcode#171Excel表列序号'
categories: leetcode
description: leetcode第171题
tags:
  - 进制
abbrlink: 1957337873
date: 2019-11-26 22:51:22
---

## 题目描述

给定一个Excel表格中的列名称，返回其相应的列序号。

例如，

    A -> 1
    B -> 2
    C -> 3
    ...
    Z -> 26
    AA -> 27
    AB -> 28 
    ...
示例 :

> 输入: "A"
> 输出: 1
> 示例 2:

> 输入: "AB"
> 输出: 28
> 示例 3:

> 输入: "ZY"
> 输出: 701

## 解题思路

进制转换，从低位开始乘以26的次方。

## AC代码

执行用时 :76 ms, 在所有 javascript 提交中击败了94.10%的用户

内存消耗 :34.8 MB, 在所有 javascript 提交中击败了54.67%的用户

```javascript
/**
 * @param {string} s
 * @return {number}
 */
var titleToNumber = function(s) {
  const len = s.length;

  if (len === 0) return 0;
  let sum = 0;
  for (let i = 0; i < len; i++) {
    sum = sum * 26 + (s.charCodeAt(i) - 64);
  }
  return sum;
};
```

