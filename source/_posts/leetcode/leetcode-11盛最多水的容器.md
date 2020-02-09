---
title: 'leetcode#11盛最多水的容器'
categories: leetcode
description: leetcode第11题
tags:
  - 算法
  - 双指针
  - 数组
abbrlink: 3449751240
date: 2019-11-01 00:16:32
---

## 题目描述
给定 n 个非负整数 a1，a2，...，an，每个数代表坐标中的一个点 (i, ai) 。在坐标内画 n 条垂直线，垂直线 i 的两个端点分别为 (i, ai) 和 (i, 0)。找出其中的两条线，使得它们与 x 轴共同构成的容器可以容纳最多的水。

说明：你不能倾斜容器，且 n 的值至少为 2。

![题目描述](http://img.chensenran.top/1572538770271.jpg)

图中垂直线代表输入数组 [1,8,6,2,5,4,8,3,7]。在此情况下，容器能够容纳水（表示为蓝色部分）的最大值为 49。

**示例:**

> 输入: [1,8,6,2,5,4,8,3,7]
> 输出: 49

## 解题思路

矩形的面机 = 底 * 高 = （下标插值 * 较短高度）

当首末位置时，下标插值最大。双指针指向两个下标，并向内减小。
减小条件：左 < 右，并且向值小的方向减小。（因为面积取决于较小的数值，所以尽可能保留较大的数值）。

用一个常量保存最大值，直至循环结束。

*末尾附leetcode题解图*

## 复杂度分析
* 时间复杂度：O(n)
* 空间复杂度：O(1)O(1)


## AC代码
* 执行用时：68 ms, 在所有 javascript 提交中击败了90.17%的用户
* 内存消耗：35.3 MB, 在所有 javascript 提交中击败了83.61%的用户

```javascript
var maxArea = function (height) {
  let left = 0, right = height.length - 1, max = -Infinity;
  while (left < right) {
    max = Math.max(max, (right - left) * Math.min(height[left], height[right]));
    (height[left] < height [right] ? left++ : right--);
  }
  return max;
};
```

## 反思

这道题一开始我想的是按照数值进行排序（元素内包含下标），然后寻找面积最大值。这样的时间复杂度会增加到O(nlog(n)),因为要进行一次排序。

但是双指针进行向内缩小范围，就不用进行排序。因为已经是有序的序列了，这样可以缩小时间复杂度至O(n)。

### *附leetcode题解图*

![第一步](http://img.chensenran.top/1572539158521.png)

![第二步](http://img.chensenran.top/1572539284834.png)

![第三步](http://img.chensenran.top/1572539399365.png)

![第四步](http://img.chensenran.top/1572539424146.png)

![第五步](http://img.chensenran.top/1572539461521.png)

![第六步](http://img.chensenran.top/1572539482990.png)

![第七步](http://img.chensenran.top/1572539518865.png)

![第八步](http://img.chensenran.top/1572539544162.png)