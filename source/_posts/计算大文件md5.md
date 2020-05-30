---
title: 计算大文件md5
description: 计算大文件md5
date: 2020-05-30 15:30:13
tags:
---

# 计算方法

## Web Worker计算MD5

使用后台线程计算MD5

```javascript
/**
 * web work计算md5
 * @param { Array } chunks
 */
function calculateHashWebWork(chunks) {
  return new Promise((resolve) => {
    const work = new Worker('/spark-md5.js');
    work.postMessage({ chunks });
    work.onmessage = (event) => {
      resolve(event.data);
    };
  });
}

// spark-md5.js 计算md5
self.importScripts('spark-md5.min.js');
self.onmessage = (event) => {
  const spark = new SparkMD5.ArrayBuffer();
  const { chunks } = event.data;
  let count = 0;

  function loadNext() {
    const reader = new FileReader();
    reader.readAsArrayBuffer(chunks[count].file);
    reader.onload = (e) => {
      spark.append(e.target.result);
      count += 1;
      if (count < chunks.length) {
        loadNext(count);
      } else {
        // 全部切片完成后 发送消息
        postMessage({ hash: spark.end() });
      }
    };
  }

  loadNext();
};

```

## 时间切片计算MD5

requestIdleCallback将在浏览器的空闲时段内调用的函数排队。这使开发者能够在主事件循环上执行后台和低优先级工作，而不会影响延迟关键事件，如动画和输入响应。

```javascript
/**
 * 时间切片计算md5
 * @param { Array } chunks
 */
export function calculateHashTimeSlice(chunks) {
  return new Promise((resolve) => {
    let count = 0;
    const spark = new sparkMd5.ArrayBuffer();

    /**
     * 计算单个切片
     * @param { Number } index 切片下标
     */
    function appendSpark(index) {
      return new Promise((res) => {
        const reader = new FileReader();
        reader.onload = (event) => {
          spark.append(event.target.result);
          res();
        };
        reader.readAsArrayBuffer(chunks[index].file);
      });
    }

    /**
     * @param {*} deadline
     */
    async function runTaskQueue(deadline) {
      // 还有切片未加入 && （剩余时间 || 超时）
      if (count < chunks.length && (deadline.timeRemaining() > 0 || deadline.didTimeout)) {
        await appendSpark(count);
        count += 1;
      }
      if (count >= chunks.length) {
        // 计算完成返回hash
        resolve({
          hash: spark.end(),
        });
      } else {
        // 浏览器的空闲时段内调用的函数排队
        requestIdleCallback(runTaskQueue, { timeout: 1000 });
      }
    }

    // 浏览器的空闲时段内调用的函数排队
    requestIdleCallback(runTaskQueue, { timeout: 1000 });
  });
}
```

## 抽样计算MD5

抽样策略：头尾取全部，中间模块取前后2字节

```javascript

/**
 * 抽样计算hash
 * @param { File } file 需要计算md5的文件
 */
export function calculateHashSample(file) {
  return new Promise((resolve) => {
    const spark = new sparkMd5.ArrayBuffer();
    const { size } = file;
    const OFFSET = Math.floor(10 * 1024 * 1024); // 取样范围 10M
    const reader = new FileReader();
    let index = OFFSET;
    // 头尾全取，中间抽2字节
    const chunks = [file.slice(0, index)];
    while (index < size) {
      if (index + OFFSET > size) {
        chunks.push(file.slice(index));
      } else {
        const CHUNK_OFFSET = 2;
        chunks.push(file.slice(index, index + 2),
          file.slice(index + OFFSET - CHUNK_OFFSET, index + OFFSET));
      }
      index += OFFSET;
    }
    reader.onload = (event) => {
      spark.append(event.target.result);
      resolve({
        hash: spark.end(),
      });
    };
    reader.readAsArrayBuffer(new Blob(chunks));
  });
}
```

# 时间对比

测试代码如下

![](http://img.chensenran.top/1590825145576.png)

1. Microsoft Edge 83.0.478.37 (64 位)

   ![Microsoft Edge测试结果](http://img.chensenran.top/1590826129545.png)

2. Google Chrome  83.0.4103.61（64 位）

3. 