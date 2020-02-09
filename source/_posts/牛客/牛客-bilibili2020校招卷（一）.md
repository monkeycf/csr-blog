---
title: 牛客-bilibili2020校招卷（一）
abbrlink: 2045299701
date: 2019-11-25 09:56:06
description: 牛客#bilibili2020校招一卷
categories: 牛客
tags:
  - 算法
---

# 错题整理

## 块级元素

块级元素与行内元素的区别：

* 格式：默认情况下，块级元素会新起一行。
* 内容模型：一般块级元素可以包含行内元素和其他块级元素。这种结构上的包含继承区别可以使块级元素创建比行内元素更”大型“的结构。

##  box-sizing 

*  content-box ： 默认值，标准盒子模型。 width 与 height 只包括内容的宽和高， 不包括边框（border），内边距（padding），外边距（margin）。 

*  border-box ： width 和 height 属性包括内容，内边距和边框，但不包括外边距。 
*  inherit ： 从父元素继承 box-sizing 属性的值。 （子元素不会默认继承父元素的值）

## 位运算

| 运算       | 示例    | 说明                                                         |
| ---------- | ------- | :----------------------------------------------------------- |
| 按位与     | a & b   | 对于每一个比特位，只有两个操作数相应的比特位都是1时，结果才为1，否则为0。 |
| 按位或     | a \| b  | 对于每一个比特位，当两个操作数相应的比特位至少有一个1时，结果为1，否则为0。 |
| 按位异或   | a ^ b   | 对于每一个比特位，当两个操作数相应的比特位有且只有一个1时，结果为1，否则为0。 |
| 按位非     | ~ a     | 反转操作数的比特位，即0变成1，1变成0。                       |
| 左移       | a << b  | 将 a 的二进制形式向左移 b (< 32) 比特位，右边用0填充。       |
| 有符号右移 | a >> b  | 将 a 的二进制表示向右移` b `(< 32) 位，丢弃被移出的位。      |
| 无符号右移 | a >>> b | 将 a 的二进制表示向右移` b `(< 32) 位，丢弃被移出的位，并使用 0 在左侧填充。 |

### 按位逻辑操作符

### 与

> 可用于判断奇偶性

```javascript
5 & 1 // 1
4 & 1 // 0
-5 & 1 // 1
-4 & 1 // 0
```

#### 或

> 可用于取整（舍尾）

```javascript
11.8 | 0 // 11
-4.3 | 0 // 4
```

#### 异或

> 不同则为1

#### 非

> 对每一个比特位执行**非（NOT）操作**。 
>
> 对任一数值 x 进行按位非操作的结果为 -(x + 1)。例如，~5 结果为 -6。 

```javascript
// 判断是否在字符串中
var str = 'rawr';
var searchFor = 'a';

// 这是 if (-1*str.indexOf('a') <= 0) 条件判断的另一种方法
if (~str.indexOf(searchFor)) {
  // searchFor 包含在字符串中
} else {
  // searchFor 不包含在字符串中
}
```

### 按位移动操作符

#### << (左移)

>  该操作符会将第一个操作数向左移动指定的位数。向左被移出的位被丢弃，右侧用 0 补充。 

> 在数字 **x** 上左移 **y** 比特得到 **x \* Math.pow(2,y)**. 

#### >> (有符号右移)

> 该操作符会将第一个操作数向右移动指定的位数。向右被移出的位被丢弃，拷贝最左侧的位以填充左侧。 

#### >>> (无符号右移)

> 该操作符会将第一个操作数向右移动指定的位数。向右被移出的位被丢弃，左侧用0填充。因为符号位变成了 0，所以结果总是非负的。（译注：即便右移 0 个比特，结果也是非负的。） 



##  [1 < 2 < 3, 3 < 2 < 1]  

```javascript
[true, true];
```



> 在js中 0 == false和1 == true是正确的 
>
> 因此在分析3<2<1时，我们可以将其分为两步，首先是3<2返回是false，也就等价于0。
> 所以0<1结果自然是true了。 

## ['1', '2', '3'].map(parseInt) 

> map((item, index, thisArr) => ( newArr ))
>
> parseInt(string, radix)

map给parseInt传递了三个参数:

```
parseInt(item, index, thisArr)
```

其中第三个参数会被 parseInt 忽略，因此会依次执行：

```javascript
parseInt('1', 0)
// radix 为 0，默认以十进制解析字符串，返回 1
parseInt('2', 1)
// radix 为 1，不在 2 ~ 36 之间，返回 NaN
parseInt('3', 2)
// radix 为 2， 字符串却为 3，超出二进制的表示范围，因此要解析的字符串和基数矛盾，返回 NaN
```

> 综上，最后返回的数组为 [1, NaN, NaN]

```javascript
parseInt(1/0,19) //18
parseInt(false,16) //250
parseInt(parseInt,16) //15
parseInt('0x10') //16
parseInt('10',2) //2
```

## 转义字符

![转义字符](http://img.chensenran.top/1574652430474.jpg)

# 编程题整理

 ### 找出有序数组中和为sum的两个数

#### 输入描述:

>  第一行：数组长度第二行：数组各项的值第三行：sum

#### 输出描述:

> 若存在，输出和为sum的两个数，以空格分隔；若不存在，输出notfound

#### 示例1

##### 输入

```
5
1 3 4 6 8
10
```

##### 输出

```
4 6
```

#### 示例2

##### 输入

```
5
1 3 4 6 8
13
```

##### 输出

```
notfound
```

#### 思路

使用双指针，因为是有序数组，所以从左右两侧逼近。

#### AC代码

```javascript
function findSumOfTowItem(len,arr,sum) {
    let left = 0, right = len - 1;
    while(left < right) {
        const sumOfTow = +arr[left] + +arr[right];
        if(sumOfTow == sum){
            return arr[left] + " " + arr[right];
        }else if(sumOfTow < sum) {
            left++;
        }else {
            right--;
        }
    }
    return "notfound"
}
let t = 1,len,arr,sum;
while (line = readline()) {
    var temp = line.split(" ");
    if (t === 1) {
        len = temp;
    } else if (t===2){
        arr = temp;
    } else{
        sum = temp;
    }
    t++;
}
 
print(findSumOfTowItem(len,arr,sum));
```

###  括号闭合 

> 判断由"()[]{}"6种括号组成的字符串是否合法
>
> 1. 所有括号必须闭合
> 2. 左括号必须在正确的位置闭合

#### 输入描述:

由6种符号组成的字符串

#### 输出描述:

合法则输出"true"，不合法输出"false"

#### 示例1

##### 输入

```
(]
```

##### 输出

```
false
```

#### 示例2

##### 输入

```
{[][()()]}
```

##### 输出

```
true
```

#### 示例3

##### 输入

```
{([)]}
```

##### 输出

```
false
```

#### 思路

使用栈进行逐一匹配。

#### AC代码

```javascript
function check(arr){
  let t = [];
  const pushItem = (item) => {
    t.push(item);
    return true;
  }
  const popItem = (item) => {
    const type = t.pop();
    if (type === '{') {
      return item === '}';
    }
    if (type === '[') {
      return item === ']';
    }
    if (type === '(') {
      return item === ')';
    }
  }
  const actions = new Map([
    ['(', pushItem],
    ['{', pushItem],
    ['[', pushItem],
    [')', popItem],
    ['}', popItem],
    [']', popItem]
  ])
  for (let i = 0; i < arr.length; i++) {
    const action = [...actions].filter(([key, value]) => key === arr[i]);
    const [key, value] = action[0];
    const flag = value.call(this, arr[i]);
    if (!flag) {
      return false;
    }
  }
  return true;
}
 
while (line = readline()) {
    let arr = line.split("");
    print(check(arr));
}
```

###  上楼梯 

 有n级台阶，每一步可以走1级或2级，问一共有多少种走法 

#### 输入描述:

台阶的级数n

#### 输出描述:

走法数量

#### 示例1

##### 输入

```
2
```

##### 输出

```
2
```

##### 说明

```
走法为1+1或2
```

#### 示例2

#### 输入

```
3
```

##### 输出

```
3
```

##### 说明

```
走法为1+1+1或1+2或2+1
```

#### 思路

动态规划。从第三级台阶开始，次数等于前两级台阶和。

#### AC代码

```javascript
function stepTypeHandler(num) {
  const arr = new Array(+num).fill(1);
  arr[1] = 2;
  for (let i = 2; i < arr.length; i++) {
    arr[i] = arr[i - 1] + arr[i - 2];
  }
  return arr[num - 1];
}
 
 
while (line = readline()) {
    print(stepTypeHandler(line));
}
```

