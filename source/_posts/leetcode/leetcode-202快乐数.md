---
title: 'leetcode#202快乐数'
categories: leetcode
description: leetcode第202题
tags:
  - 算法
  - 快慢指针
abbrlink: 518869312
date: 2019-11-24 13:51:09
---

## 题目描述

编写一个算法来判断一个数是不是“快乐数”。

一个“快乐数”定义为：对于一个正整数，每一次将该数替换为它每个位置上的数字的平方和，然后重复这个过程直到这个数变为 1，也可能是无限循环但始终变不到 1。如果可以变为 1，那么这个数就是快乐数。

示例: 

> 输入: 19
> 输出: true
> 解释: 
> 12 + 92 = 82
> 82 + 22 = 68
> 62 + 82 = 100
> 12 + 02 + 02 = 1

## 解题思路

使用快慢指针。因为存在循环，所以可以使用快慢指针解决这个问题。一个指针做一次，另一个指针做两次。当两个指针相同时，说明刚好经过一次循环。

## AC代码

执行用时 :68 ms, 在所有 javascript 提交中击败了94.36%的用户

内存消耗 :36 MB, 在所有 javascript 提交中击败了33.74%的用户

```javascript
/**
 * @param {number} n
 * @return {boolean}
 */
var isHappy = function(n) {
  let left = n, right = n;
  do {
    left = fun(left);
    right = fun(right);
    right = fun(right);
  } while (left !== right)

  return left === 1;

  function fun(num) {
    let arr = num.toString().split('')
    let t = arr.reduce((acc, cur, index, src) => {
      return acc + Math.pow(parseInt(cur), 2);
    }, 0)
    return t;
  }
};
```

