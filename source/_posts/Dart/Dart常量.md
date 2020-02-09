---
title: Dart常量
categories: Dart
description: 常量的定义方式，final const 的区别
tags:
  - Dart常量
abbrlink: 3634359325
date: 2019-11-06 11:49:08
---
## 定义可以省略类型
```dart
// 定义
final String a = "csr";
const String b = 'www';
final c = "com";
const d = "hello";
```

## 不可修改
```dart
// 不能修改
//  a = '123'; error
```

## 不可与 var 同用
```dart
// 不能和 var 同用
// final var d = "123"; error
// const var e = "456"; error
```

## const 赋值，可省略 const 申明的值（2.0以下必须，2.0以上可省略）
```dart
const List ls = const [11, 22, 55];
print(ls);
```

## const 与 final 区别

### 需要确认值
> final 运行时决定值
> const 编译时确定值，可用于定义常量
```dart
  final dt = DateTime.now();
  print(dt);
  //  const dt = DateTime.now(); error
  // 需明确的值，DataTime.now()在运行时才确定
```

### 不可变性可传递
> final 子元素可修改
> const 子元素不可修改，常量特性传到子元素
```dart
  final List ls1 = [11, 22, 33];
  ls1[1] = 44;
  print(ls1);

  const List ls2 = [11, 22, 33];
  //  ls2[1] = 44; error 子元素不可修改，常量特性传到子元素
  print(ls2);
```

### 内存中重复创建
> **identical 比较内存中是否为同一对象**

> const 如遇到相同的内容，不会重新创建新的内存空间
```dart
  final ls3 = [11, 22, 33];
  final ls4 = [11, 22, 33];
  print(identical(ls3, ls4)); // false 

  const ls5 = [11, 22, 33];
  const ls6 = [11, 22, 33];
  print(identical(ls5, ls6)); // true
```