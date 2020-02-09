---
title: TypeScript-接口
abbrlink: 46133822
date: 2020-01-09 21:12:13
tags:
- TypeScript
description: TypeScript接口
categories: TypeScript
---

# 属性接口

```typescript
interface PersonInfo {
  firstName: string;
  secondName?: string;// 可选属性
}

function printName(info: PersonInfo) {
  console.log(info.firstName + info.secondName);
}

printName({
  firstName: 'zhang',
});
```

# 函数类型接口

```typescript
interface encrypt {
  (key: string, value: string): string;
}

let md5: encrypt = function (key: string, value: string): string {
  return key + value;
};
```

# 可索引接口

## 对数组约束

```typescript
interface UserArr {
  [index: number]: string;
}

let arr1: UserArr = ['aaa'];
```

## 对对象约束

```typescript
interface UserObj {
  [index: string]: string;
}

let obj: UserObj = {name: 'aaa'};
```

# 类类型接口

> 与抽象类类似

```typescript
interface UserAnimal {
  name: string;

  eat(str: string): void;
}

class UserDog implements UserAnimal {
  name: string;

  constructor(name: string) {
    this.name = name;
  }

  // 参数可选
  eat(): void {
    console.log(this.name);
  }
}
```

# 接口的扩展

## 可继承

```typescript
interface food {
  eat(): void;
}

interface Banana extends food {
  work(): void;
}
```

