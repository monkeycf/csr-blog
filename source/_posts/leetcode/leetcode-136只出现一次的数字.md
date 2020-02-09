---
title: leetcode-136只出现一次的数字
tags:
  - 异或运算
description: leetcode第136题，异或运算
categories: leetcode
abbrlink: 3259562324
date: 2020-01-22 14:56:38
---

# 题目描述

给定一个非空整数数组，除了某个元素只出现一次以外，其余每个元素均出现两次。找出那个只出现了一次的元素。

* 说明：

你的算法应该具有线性时间复杂度。 你可以不使用额外空间来实现吗？

* 示例 1:

输入: [2,2,1]
输出: 1

* 示例 2:

输入: [4,1,2,1,2]
输出: 4

# 解题思路

使用异或运算

* 如果我们对 0 和二进制位做 XOR 运算，得到的仍然是这个二进制位
  a ⊕ 0 = a
* 如果我们对相同的二进制位做 XOR 运算，返回的结果是 0
  a ⊕ a = 0
* XOR 满足交换律和结合律
  a ⊕ b ⊕ a = ( a ⊕ a ) ⊕ b = 0 ⊕ b = b

# AC代码

* 执行用时 :64 ms, 在所有 JavaScript 提交中击败了89.24%的用户

* 内存消耗 :35.3 MB, 在所有 JavaScript 提交中击败了80.71%的用户

```javascript
/**
 * @param {number[]} nums
 * @return {number}
 */
var singleNumber = function(nums) {
  return nums.reduce((pre, cur) => pre ^ cur)
};
```

