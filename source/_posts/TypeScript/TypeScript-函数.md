---
title: TypeScript-函数
description: TypeScript函数
categories: TypeScript
tag:
  - TypeScript
abbrlink: 709073101
date: 2020-01-08 22:48:22
---

# 函数的定义

```typescript
let myAdd: (baseValue: number, increment: number) => number =
  (x: number, y: number): number => {
    return x + y;
  };

let myAdd: (baseValue: number, increment: number) => number =
  function (x: number, y: number): number {
    return x + y;
  };
```

# 可选参数

>  在参数名旁使用 `?`实现可选参数的功能

```typescript
function add(x: number, y?: number): number {
  return x + y;
}
```

# 默认参数

> 与普通可选参数不同的是，带默认值的参数不需要放在必须参数的后面。 如果带默认值的参数出现在必须参数前面，用户必须明确的传入 `undefined`值来获得默认值。 

```typescript
function buildName(firstName = "Will", lastName: string) {
    return firstName + " " + lastName;
}

let result1 = buildName("Bob");                  // error, too few parameters
let result2 = buildName("Bob", "Adams", "Sr.");  // error, too many parameters
let result3 = buildName("Bob", "Adams");         // okay and returns "Bob Adams"
let result4 = buildName(undefined, "Adams");     // okay and returns "Will Adams"
```

# 剩余参数

> 同时操作多个参数

```typescript
function buildName(firstName: string, ...restOfName: string[]) {
  return firstName + " " + restOfName.join(" ");
}

let buildNameFun: (fname: string, ...rest: string[]) => string = buildName;
```

# 重载

```typescript
function pickCard(x: { suit: string; card: number; }[]): number;
function pickCard(x: number): { suit: number; card: number; };
function pickCard(x): any {
  if (typeof x == "object") {
    return Math.floor(Math.random() * x.length);
  }
  else if (typeof x == "number") {
    return {suit: x, card: x % 13};
  }
}
```

