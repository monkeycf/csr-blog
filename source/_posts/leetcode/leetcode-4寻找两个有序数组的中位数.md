---
title: 'leetcode#4寻找两个有序数组的中位数'
categories: leetcode
description: leetcode第4题
tags:
  - 算法
  - 中位数
  - 二分
  - 数组
abbrlink: 2361497007
date: 2019-10-29 22:06:13
---

## 题目描述

给定两个大小为 m 和 n 的有序数组 nums1 和 nums2。

请你找出这两个有序数组的中位数，并且要求算法的时间复杂度为 O(log(m + n))。

你可以假设 nums1 和 nums2 不会同时为空。

**示例 1:**

> nums1 = [1, 3]
> nums2 = [2]
> 则中位数是 2.0

**示例 2:**

> nums1 = [1, 2]
> nums2 = [3, 4]
> 则中位数是 (2 + 3) / 2 = 2.5



## 解题思路
**中位数**：两边的个数相同

设数组长度为m,n(保证m < n)，在任意位置将数组A分成两部分：

|left_A|right_A|
|-|-|
|A[0], A[1], A[2] ... A[i-1] | A[i], A[i+1] ... A[m-1]|


 同理，对数组B也进行划分：

|left_B|right_B|
|-|-|
|B[0], B[1] ... B[j-i] | B[j], B[j+1] ... B[n-1]|


对两个数组进行同时比较

|left|right|
|-|-|
|A[0], A[1], A[2] ... A[i-1] | A[i], A[i+1] ... A[m-1]|
|B[0], B[1] ... B[j-i] | B[j], B[j+1] ... B[n-1]|

可得：
* len(left) = len(right)
* max(left) ≤ min(right)

当满足以上两个条件时，我们将数组分成了两个长度相同的部分，且右边的元素都比左边大。由此及可算出中位数。

> median = max(left) + min(right) / 2

推到以上两个条件得
> 1. i + j = m − i + n − j（或：m - i + n - j + 1）
> 如果 n >= m，则 i ∈ [0, m), j = (m + n + 1) / 2 - i
> 2. B[j−1] ≤ A[i] && A[i-1] ≤ B[j]

为了满足以上两个条件，我们只需要在[0, m)中寻找i，使得
**B[j−1] ≤ A[i] && A[i-1] ≤ B[j]**

接着进行二叉树搜索，使得满足该条件。
> * 设leftInde = 0, rightIndex = m.length
> * i = (leftIndex + rightIndex) / 2
> j = (m + n + 1) / 2 - i
> * 至此我们肯定保证了左右两边的数组长度相等，则判断是否满足 B[j−1] ≤ A[i] && A[i-1] ≤ B[j]即可。

可能会有三种不同的情况：
> 1. B[j-1] > A[i] 表明i太小，leftIndex = i + 1
> 2. A[i-1] > B[j] 标明i太大，rightIndex = j -1
> 3. 满足B[j−1] ≤ A[i] && A[i-1] ≤ B[j]，找到中位数

**对于临界值的处理 (i = 0, i = m, j = 0, j = n)**

## 复杂度分析
* 时间复杂度：O(log(m))
* 空间复杂度: O(1)


## AC代码
* 执行用时：124 ms, 在所有 javascript 提交中击败了95.59%的用户
* 内存消耗：39 MB, 在所有 javascript 提交中击败了88.52%的用户

```javascript
/**
 * @param {number[]} nums1
 * @param {number[]} nums2
 * @return {number}
 */
var findMedianSortedArrays = function (nums1, nums2) {
  let m = nums1.length,
    n = nums2.length;
  // 调整nums1为较短数组
  if (m > n) {
    [nums1, nums2] = [nums2, nums1];
    m = nums1.length;
    n = nums2.length;
  }
  // 判断是否较短数组为空
  if (m === 0) {
    if (n & 1) {
      return nums2[(n - 1) / 2];
    }
    return (nums2[(n / 2)] + nums2[(n / 2 - 1)]) / 2;
  }

  let leftIndex = 0, rightIndex = m; // i的边界值
  const t = Math.floor((m + n + 1) / 2); // 所有数据的一半个数
  let i, j;
  while (leftIndex <= rightIndex) {
    i = Math.floor((leftIndex + rightIndex) / 2);
    j = t - i;
    if (i < rightIndex && nums1[i] < nums2[j - 1]) {
      leftIndex = i + 1;
    } else if (i > leftIndex && nums1[i - 1] > nums2[j]) {
      rightIndex = i - 1;
    } else {
      // TODO：注意边界值处理
      let left = -Infinity;
      if (i === 0) {
        left = nums2[j - 1];
      } else if (j === 0) {
        left = nums1[i - 1];
      } else {
        left = Math.max(nums1[i - 1], nums2[j - 1]);
      }
      if ((m + n) & 1) {
        return left;
      }
      let right = -Infinity;
      if (i === m) {
        right = nums2[j];
      } else if (j === n) {
        right = nums1[i];
      } else {
        right = Math.min(nums1[i], nums2[j]);
      }
      return (left + right) / 2;
    }
  }
};
```
## 反思
这道题尝试了很多次才通过。一开始的想法是利用二分法不断对缩小两个数组的查找范围。分别找到两个数组的中位数，比较大小并且向中间区域缩小范围。最终没有实现，因为在最后中位数判断时，出现无法判断哪个是所求的中位数。

AC的思路很巧妙，利用数组大小不变的特性维护左右两边元素个数相同的特点。并且利用中位数左边的元素一定比右边小的特点，来寻找所有的值。但是在coding的过程中，临界值处理上困到了一些小困难，花费了一些时间。