---
title: 'leetcode#297二叉树的序列化与反序列化'
categories: leetcode
description: leetcode第297题
tags:
  - 二叉树
abbrlink: 2353831610
date: 2019-11-14 16:06:38
---

## 题目描述

序列化是将一个数据结构或者对象转换为连续的比特位的操作，进而可以将转换后的数据存储在一个文件或者内存中，同时也可以通过网络传输到另一个计算机环境，采取相反方式重构得到原数据。

请设计一个算法来实现二叉树的序列化与反序列化。这里不限定你的序列 / 反序列化算法执行逻辑，你只需要保证一个二叉树可以被序列化为一个字符串并且将这个字符串反序列化为原始的树结构。

**示例:** 

> 你可以将以下二叉树：

![二叉树](http://img.chensenran.top/1573721707240.png)

> 序列化为 "[1,2,3,null,null,4,5]"
> **提示:** 这与 LeetCode 目前使用的方式一致，详情请参阅 LeetCode 序列化二叉树的格式。你并非必须采取这种方式，你也可以采用其他的方法解决这个问题。

**说明:** 不要使用类的成员 / 全局 / 静态变量来存储状态，你的序列化和反序列化算法应该是无状态的。

## 解题思路

* 序列化：序列化的思路参考树的层次遍历的方式，使用队列。如果改节点是叶子节点，则入队两个null。
* 反序列化：也是用队列，因为一个非空节点必定对应两个子节点。以此解析即可。



## 复杂度分析

序列化：

* 时间复杂度：O(n)
* 空间复杂度：O(n)

反序列化：

* 时间复杂度：O(n)
* 空间复杂度：O(n)

## AC代码

>  执行用时 :116 ms, 在所有 javascript 提交中击败了62.41%的用户
>
> 内存消耗 :44.4 MB, 在所有 javascript 提交中击败了20.00%的用户

```javascript
/**
 * Definition for a binary tree node.
 * function TreeNode(val) {
 * this.val = val;
 * this.left = this.right = null;
 * }
 */

/**
 * Encodes a tree to a single string.
 *
 * @param {TreeNode} root
 * @return {string}
 */
var serialize = function(root) {
  if (!root) return '';
  const queue = [];
  let result = [];
  queue.push(root);

  while (queue.length) {
    const temp = queue.shift();
    if (!temp) {
      result.push('null');
      continue;
    }
    result.push(temp.val);
    queue.push(temp.left);
    queue.push(temp.right);
  }
  return result.join(',');
};

/**
 * Decodes your encoded data to tree.
 *
 * @param {string} data
 * @return {TreeNode}
 */
var deserialize = function(data) {
  if (data.length === 0) return null;
  data = data.split(',');
  const queue = [];
  const root = new TreeNode(data[0]);
  queue.push(root);
  let index = 1;
  while (queue.length) {
    const temp = queue.shift();
    if (data[index] != 'null') {
      let left = new TreeNode(data[index]);
      temp.left = left;
      queue.push(left)
  	} else {
      temp.left = null;
    }
    index++;
    if (data[index] != 'null') {
      let right = new TreeNode(data[index]);
      temp.right = right;
      queue.push(right);
    } else {
      temp.right = null;
    }
    index++;
  }
  return root;
};

/**
 * Your functions will be called as such:
 * deserialize(serialize(root));
 */
```



## 反思

这题一共提交了8次才通过。最初序列化的想法是形成一个完全二叉树，这样在反序列化时就可更加便捷。但是在每层只有少量节点的树中，会造成很大的空间和时间上的浪费，最终导致超出时间限制。

当此节点为叶子节点时，只需要下一层标识左右节点都为null，就可以判断为叶子节点。