---
title: 常见排序算法
description: 常见排序算法
abbrlink: 3963924866
date: 2020-02-26 19:03:01
---

# 冒泡排序

重复遍数组，两两之间相互比较，按照一定规则交换。

优化：当一次遍历未发生交换时，排序结束

时间复杂度：平均：O(n^2)，最差：O(n^2)

空间复杂度：O(1)

```javascript
/**
 * 优化冒泡排序
 * @param {Array}arr
 * @return {Array}
 */
function optimizeBubbleSort(arr) {
  const len = arr.length;
  if (len < 2) {
    return arr;
  }
  for (let i = 0; i < len; i++) {
    let flag = false;
    for (let j = len; j > i; j--) {
      if (arr[i] > arr[j]) {
        flag = true;
        [arr[i], arr[j]] = [arr[j], arr[i]];
      }
    }
    if (!flag) break;
  }
  return arr;
}
```

# 选择排序

与冒泡排序相比，每次循环记录最大（最小）的索引值，一遍循环结束后再进行交换。

时间复杂度：平均：O(n^2)，最差：O(n^2)

空间复杂度：O(1)

```javascript
/**
 * 选择排序
 * @param {Array}arr
 * @return {Array}
 */
function selectionSort(arr) {
  const len = arr.length;
  if (len < 2) {
    return arr;
  }
  for (let i = 0; i < len; i++) {
    let flag = i;
    for (let j = i + 1; j < len; j++) {
      if (arr[flag] > arr[j]) {
        flag = j;
      }
    }
    if (flag !== i) {
      [arr[flag], arr[i]] = [arr[i], arr[flag]];
    }
  }
  return arr;
}
```

# 插入排序

将当前元素，插入到之前已有序的元素中。

时间复杂度：平均：O(n^2)，最差：O(n^2)

空间复杂度：O(1)

```javascript
/**
 * 插入排序
 * @param {Array}arr
 * @return {Array}
 */
function insertSort(arr) {
  if (arr.length < 2) {
    return arr;
  }
  for (let i = 1; i < arr.length; i++) {
    let index = i - 1;
    const value = arr[i];
    while (index >= 0 && arr[index] > value) {
      arr[index + 1] = arr[index];
      index--;
    }
    arr[index + 1] = value;
  }
  return arr;
}
```

# 希尔排序

对插入排序的改进版。先将整个待排序的数组分割成诺干个子序列，分别进行插入排序。不断进行，直至全部数组进行一次插入排序。

```javascript
/**
 * 希尔排序
 * @param {Array}arr
 * @return {Array}
 */
function shellSort(arr) {
  const len = arr.length;
  if (len < 2) {
    return arr;
  }
  let gen = len / 2 | 0; // 间隔，增量
  while (gen > 0) {
    for (let i = gen; i < len; i++) { // 对诺干个子序列进行插入排序
      const temp = arr[i];
      let index = i - gen;
      while (index >= 0 && arr[index] > temp) {
        arr[index + gen] = arr[index]
        index -= gen;
      }
      arr[index + gen] = temp;
    }
    gen = gen / 2 | 0;
  }
  return arr;
}
```

# 归并排序

分治算法，将元素不断一分为二。接着将小数组进行归并操作。

时间复杂度：O(nlogn)

空间复杂度：O(n)

```javascript
/**
 * 归并排序
 * @param {Array} arr
 * @param {number} begin
 * @param {number} end
 * @return {Array}
 */
function mergeSort(arr, begin = 0, end = arr.length) {
  if (end - begin < 2) {
    return arr.slice(begin, end);
  }
  const mid = begin + ((end - begin) / 2 | 0);
  // 分治，向下递归
  return merge(mergeSort(arr, begin, mid), mergeSort(arr, mid, end));
}

/**
 * 合并两个数组
 * @param {Array}leftArr
 * @param {Array}rightArr
 */
function merge(leftArr, rightArr) {
  const res = [];
  // 归并操作
  while (leftArr.length && rightArr.length) {
    res.push(
      leftArr[0] < rightArr[0]
        ? leftArr.shift()
        : rightArr.shift()
    )
  }
  while (leftArr.length) {
    res.push(leftArr.shift())
  }
  while (rightArr.length) {
    res.push(rightArr.shift())
  }
  return res;
}
```

# 快速排序

分治算法，根据选择的基准数将数组一分为二。一侧都比基准数小或等于，一侧都比基准数大。

时间复杂度：平均：O(nlogn)  最差：O(n^2)

空间复杂度：O(logn) ~ O(n)

```javascript
/**
 * 快速排序
 * @param {Array} arr
 * @param {number} begin
 * @param {number} end
 * @return {Array}
 */
function quickSort(arr, begin = 0, end = arr.length) {
  const len = end - begin;
  if (len <= 1) return arr;
  
  const temp = arr[begin]; // 基准值
  let l = begin, r = end - 1;
  while (l < r) {
    while (l < r && temp < arr[r]) {
      r--;
    }
    arr[l] = arr[r];
    
    while (l < r && temp >= arr[l]) {
      l++;
    }
    arr[r] = arr[l];
  }
  arr[l] = temp;
  
  // 分别递归
  quickSort(arr, begin, l);
  quickSort(arr, l + 1, end);
  return arr;
}
```

# 堆排序

大根堆/小根堆。创建一个堆，并把队尾与队首进行交换，不断维护堆。

时间复杂度：O(nlogn)

空间复杂度：O(1)

```javascript
/**
 * 堆排序
 * @param {Array}arr
 * @return {Array}
 */
function heapSort(arr) {
  if (arr.length < 2) return arr;

  createHeap(arr); // 创建堆

  let lastIndex = arr.length - 1;
  while (lastIndex) {
    swap(arr, 0, lastIndex);
    lastIndex--;
    heap(arr, 0, lastIndex);
  }
  return arr;
}

/**
 * 创建堆
 * @param {Array}arr
 */
function createHeap(arr) {
  const len = arr.length;
  let index = len / 2 | 0; // 非叶子节点的索引值
  while (index > -1) {
    heap(arr, index--, len - 1);
  }
}

/**
 * 创建一个堆
 * @param {Array}arr
 * @param {number}index
 * @param {number}laseIndex
 * @return {boolean}
 */
function heap(arr, index, laseIndex) {
  const leftIndex = index * 2 + 1, rightIndex = (index + 1) * 2;
  let flag = index; // 最小元素索引值
  if (leftIndex <= laseIndex && arr[flag] > arr[leftIndex]) {
    flag = leftIndex;
  }
  if (rightIndex <= laseIndex && arr[flag] > arr[rightIndex]) {
    flag = rightIndex;
  }
  // 最小元素为根元素，则无需递归
  if (flag !== index) {
    swap(arr, index, flag);
    heap(arr, flag, laseIndex);
  }
}

/**
 * 交换元素
 * @param arr
 * @param l
 * @param r
 */
function swap(arr, l, r) {
  [arr[l], arr[r]] = [arr[r], arr[l]];
}
```

# 计数排序

利用空间换取时间，数据的范围必须是有限确定的。

```javascript
/**
 * 计数排序
 * @param {Array<number>}arr
 * @param {number}minValue
 * @param {number}maxValue
 * @return {Array<number>}
 */
function countSort(arr, minValue, maxValue) {
  // 创建计数数组
  const result = arr.reduce((pre, cur) => {
    const differenceValue = cur - minValue;
    pre[differenceValue]++;
    return pre;
  }, new Array(maxValue - minValue + 1).fill(0));

  let index = 0;
  result.forEach((item, itemIndex) => {
    for (let i = 0; i < item; i++) {
      arr[index++] = itemIndex + minValue;
    }
  })
  return arr;
}
```



