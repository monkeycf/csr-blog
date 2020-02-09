---
title: 'leetcode#172阶乘后的零'
categories: leetcode
description: leetcode第172题
tags:
  - 阶乘
abbrlink: 596210080
date: 2019-11-26 22:37:06
---

## 题目描述

给定一个整数 n，返回 n! 结果尾数中零的数量。

示例 1:

> 输入: 3
> 输出: 0
> 解释: 3! = 6, 尾数中没有零。

示例 2:

> 输入: 5
> 输出: 1
> 解释: 5! = 120, 尾数中有 1 个零.

说明: 你算法的时间复杂度应为 O(log n) 。

## 解题思路

计算末尾0的个数，实则是求5的个数。（ 2 * 5 === 10）

## AC代码

执行用时 :68 ms, 在所有 javascript 提交中击败了87.97%的用户

内存消耗 :33.9 MB, 在所有 javascript 提交中击败了64.55%的用户

```javascript
/**
 * @param {number} n
 * @return {number}
 */
var trailingZeroes = function(n) {
  let sum = 0;
  while (n > 1) {
    n = Math.floor(n / 5);
    sum += n;
  }
  return sum;
};
```

