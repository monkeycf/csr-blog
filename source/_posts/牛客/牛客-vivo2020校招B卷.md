---
title: '牛客#vivo2020校招B卷'
abbrlink: 1883259812
date: 2019-11-23 23:29:54
description: 牛客#vivo2020校招B卷(矿石车、入职编号、跳盒子)
categories: 牛客
tags:
  - 算法
---

# 矿石车

## 题目描述：

小v最近在玩一款挖矿的游戏，该游戏介绍如下：

> 1、每次可以挖到多个矿石，每个矿石的重量都不一样，挖矿结束后需要通过一款平衡矿车运送下山；
>
> 2、平衡矿车有左右2个车厢，中间只有1个车轮沿着导轨滑到山下，且矿车只有在2个车厢重量完全相等且矿石数量相差不超过1个的情况下才能成功运送矿石，否则在转弯时可能出现侧翻。

假设小v挖到了n（n<100）个矿石，每个矿石重量不超过100，为了确保一次性将n个矿石都运送出去，一旦矿车的车厢重量不一样就需要购买配重砝码。请问小v每次**最少**需要购买多少重量的砝码呢? （假设车厢足够放下这些矿石和砝码，砝码重量任选）

### **输入描述:**

> 输入n个正整数表示每个矿石的重量

### **输出描述:**

> 输出一个正整数表示最少需要购买的砝码重量

## 输入

> 3 7 4 11 8 10

## 输出

> 1

## 说明

> 小v可以将重量3,7和11的矿石放到左车厢，重量4，8和10 放到右车厢，然后购买重量为1的砝码放到左车厢

### 备注:

> 如果n为奇数则左右车厢里的矿石数量相差一个，如果n为偶数则车厢两边的矿石数量相等



## 解题思路

将数组分成前后个数相等的两组（若为个数单数，前部分比后部分少1个）。遍历前数组，在后数组中寻找是否可以替换的数，以前一部分的和接近临界值（总数/2）。

## AC代码

```javascript
function solution(stones) {
  if (stones.length === 0) return 0;
  const len = Math.floor(stones.length / 2);
  let leftSum = 0, sum = 0;
  for (let i = 0; i < stones.length; i++) {
    if (i < len) {
      leftSum += +stones[i];
    }
    sum += +stones[i];
  }
  sum /= 2;
  let flag = false;
  do {
    flag = false;
    for (let i = 0; i < len; i++) {
      let t = Math.abs(sum - leftSum);
      for (let j = len; j < stones.length; j++) {
        const temp = Math.abs(sum - (leftSum - +stones[i] + +stones[j]))
        if (temp < t) {
          flag = true;
          leftSum = leftSum - +stones[i] + +stones[j];
          [stones[i], stones[j]] = [stones[j], stones[i]];
          t = temp;
        }
      }
    }
  } while (flag);
  return Math.abs(sum - leftSum) * 2;
}
```

## 反思

​	一开始被左右两数组的个数差不超过1限制，向两个数组里添加元素。后来分成两组后，首先满足了个数的要求。再不断使前一部分的和不断解决总和的一半。

# 入职编号

> 未通过，不能理解题目的要求



#  跳盒子 

## 题目描述

> ​     有n个盒子排成了一行，每个盒子上面有一个数字a[i]，表示在该盒子上的人最多能向右移动a[i]个盒子（比如当前所在盒子上的数字是3，则表示可以一次向右前进1个盒子，2个盒子或者3个盒子）。  

  现在小v从左边第一个盒子上开始体验游戏，请问**最少**需要移动几次能到最后一个盒子上？

### **输入描述:**

> 输入 ：2 2 3 0 4表示现在有5个盒子，上面的数字分别是2, 2, 3, 0, 4。

### **输出描述:**

> 输出：2小v有两种跳法：跳法1：盒子1 -> 盒子2 -> 盒子3 -> 盒子5，共3下跳法2：盒子1 -> 盒子3 -> 盒子5，共2下跳法2的步骤数最少，所以输出最少步数：2。

## 输入

> 2 2 3 0 4

## 输出

> 2

## 备注

> 如果没有盒子或跳不到最后一个盒子上，则返回-1；如果已经在最后盒子上，则直接返回0。

## 解题思路

动态规划

* 初始化所有位置为 -1（不能到达），0位置为0（需要0步到达）
* 从1位置开始向后循环（i）
  * 从0开始，判断该位置下表（j） + 该位置可跳跃值 是否大于循环下表（i）
  * 大于或等于，则循环位置（i）值 = （j）位置的值 + 1
* 返回数组末尾值

## AC代码

```javascript
function solution(boxes) {
  const len = boxes.length;
  const arr = new Array(len).fill(-1);
  arr[0] = 0;
  for (let index = 1; index < len; index++) {
    for (let j = 0; j <= index - 1; j++) {
      if (arr[j] >= 0 && parseInt(boxes[j]) + j >= index) {
        arr[index] = arr[j] + 1;
        break;
      }
    }
  }
  return arr[len - 1];
}
```

