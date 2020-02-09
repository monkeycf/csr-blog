---
title: 'leetcode#69X的平方根'
abbrlink: 632519899
date: 2019-11-28 13:44:20
categories: leetcode
description: leetcode第69题
tags:
  - 算法
  - 二分
---

## 题目描述

实现 int sqrt(int x) 函数。

计算并返回 x 的平方根，其中 x 是非负整数。

由于返回类型是整数，结果只保留整数的部分，小数部分将被舍去。

> 示例 1
>
> 输入: 4
> 输出: 2



> 示例 2:
>
> 输入: 8
> 输出: 2



> 说明: 8 的平方根是 2.82842..., 
> 由于返回类型是整数，小数部分将被舍去。



## 解题思路

二分逼近，从左右边界向中间逼近。（注意边界值的处理，可能会出现死循环）

## AC代码

执行用时 :80 ms, 在所有 javascript 提交中击败了88.67%的用户

内存消耗 :35.5 MB, 在所有 javascript 提交中击败了59.66%的用户

```javascript
/**
 * @param {number} x
 * @return {number}
 */
var mySqrt = function (x) {
  let left = 0, right = (x / 2 + 1) | 0;

  while (left < right) {
    let t = (left + right + 1) >>> 1;
    let num = t ** 2;
    if (num === x) {
      return t;
    } else if (num < x) {
      left = t;
    } else {
      right = t - 1;
    }
  }
  return right | 0;
};
```

