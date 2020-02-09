---
title: TypeScript-数据类型
description: TypeScript的数据类型
categories: TypeScript
tag:
  - TypeScript
abbrlink: 2078814664
date: 2020-01-08 22:14:57
---

# 布尔类型（boolean)

> false true

```typescript
let flag: boolean = false;
let type: boolean = true;
```

# 数字类型（number）

```typescript
let num: number = 1;
```

# 字符串类型（string）

```typescript
let str: string = '123';
```

# 数组类型（array）

```typescript
let list: number[] = [1, 2, 3];
let arr: Array<number> = [1, 2, 3];
```

# 元组（tuple）

```typescript
let x: [string, number];
x = ['1', 2];
x.push('2'); // 超过定义个数，会使用联合类型替代(string | number)
```

# 枚举（enum）

```typescript
enum Color {
  Red,// 0
  Green = 2,// 2
  Blue // 3
}

let color: Color = Color.Blue;

let colorStr: string = Color[3];
console.log(colorStr); // Blue, 找到3的对应值
```

# 任意类型（any）

```typescript
let list: any[] = [1, true, "free"];

list[1] = 100;
```

# null 和 undefined

> 默认情况下`null`和`undefined`是所有类型的子类型。 (除了指定 `--strictNullChecks`标记 )

# void类型

> 当一个函数没有返回值时，其返回值类型是 void
>
> 只能为它赋予undefined和null

# never类型

> never类型表示的是那些永不存在的值的类型 

```typescript
// 返回never的函数必须存在无法达到的终点
function error(message: string): never {
    throw new Error(message);
}

// 推断的返回值类型为never
function fail() {
    return error("Something failed");
}

// 返回never的函数必须存在无法达到的终点
function infiniteLoop(): never {
    while (true) {
    }
}
```

# 类型断言

1. 尖括号

   ```typescript
   let someValue: any = "this is a string";
   
   let strLength: number = (<string>someValue).length;
   ```

   

2. as语法

   ```typescript
   let someValue: any = "this is a string";
   
   let strLength: number = (someValue as string).length;
   ```

   

