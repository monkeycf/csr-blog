---
title: Dart变量的两种类型
categories: Dart
description: Dart变量的两种类型（弱类型、强类型）
tags:
  - Dart变量
abbrlink: 290223578
date: 2019-11-05 22:19:08
---
## 弱类型
### var
* 如果没有初始值，可以变成任何类型
```dart
  // 没有初始值
  var dome1;
  dome1 = 123;
  dome1 = "helo";
```
* 如果有初始值，类型被锁定
```dart
  // 有初始值，确定类型 无法改变类型
  var dome2 = 123;
  // dome2 = "hello"; error
```

### dynamic
* 动态任意类型，编译阶段不检查检查类型
```dart
  dynamic dome3 = 123;
  dome3 = "hello";
  // dome3.text(); error 运行时报错 
```

### Object
* 动态任意类型，编译阶段检查类型
```dart
  Object dome4 = 123;
  dome4 = "hello";
  // dome4.text(); error 编译时报错
```

## 强类型

### 常见类型
|名称|说明|
|-|-|
|num|数字|
|int|整型|
|double|浮点|
|bool|布尔|
|String|字符串|
|StringBuffer|字符串buffer|
|DateTime|时间日期|
|Duration|时间区间|
|List|列表|
|Sets|集合|
|Maps|kv容器|
|enum|枚举|

```dart
  String str = "hello";
  int i = 12;
  double d = 12.12;
  bool b = false;
  DateTime dt = new DateTime.now();
  List l = [str, i, d, b, dt];
```
### 默认值
一切都是 Object，默认值为 null
```dart
  String a;
  print(a);
  assert(a == null);
```
> assert 检查点函数，如果不符合条件直接抛出错误并终止程序进程

## 如何使用
* 在写 API 接口的时候，请用强类型，一旦不符合约定，接收数据时能方便排查故障
* 你在写个小工具时，可以用弱类型，这样代码写起来很快，类型自动适应