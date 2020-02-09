---
title: TypeScript-类
description: TypeScript类的定义、继承、修饰符、静态方法、静态属性、抽象类、多态
abbrlink: 3404962735
date: 2020-01-08 21:28:39
categories: TypeScript
tag:
- TypeScript
---

# 类的定义

> class 关键字，constructor 构造函数

```typescript
class Person {
  name: string;

  constructor(name: string) {
    this.name = name;
  }
}
```

# 类的继承

> extends 关键字，super 调用父类方法

```typescript
class Student extends Person {
  constructor(name: string) {
    super(name);
  }
}
```

# 修饰符

* private 只能在当前类中访问
* protected 在当前类和子类中访问
* public 在任何地方访问

## get ， set 方法

```typescript
class Person {
  private _name: string;

  constructor(name: string) {
    this._name = name;
  }

  get name(): string {
    return this._name;
  }

  set name(value: string) {
    this._name = value;
  }
}
const p: Person= new Person('小明');
p.name = '小陈';
```

# 静态方法，静态属性

> static 关键字

```typescript
class Person {
  public static age: number = 20;

  static Print(): void {
    console.log(`age is ${Person.age}`);
  }
}

Person.Print();
```

# 抽象类

> abstract 关键字 

```typescript
// 抽象类， 不能被实例化
abstract class Animal {
  projected name: string;

  protected constructor(name: string) {
    this.name = name;
  }

  abstract eat(): void; // 抽象方法
}
// 子类必须实现抽象类的抽象方法
class Dog extends Animal {

  constructor(name: string) {
    super(name);
  }

  // 实现抽象方法
  eat(): void {
    console.log(`${this.name}正在吃狗粮`);
  }
}
```

# 多态

>  父类定义一个方法不去实现，让继承它的子类去实现 每一个子类有不同的表现 

```typescript
// 抽象类， 不能被实例化
abstract class Animal {
  projected name: string;

  protected constructor(name: string) {
    this.name = name;
  }

  abstract eat(): void; // 抽象方法
}
// 子类必须实现抽象类的抽象方法
class Dog extends Animal {

  constructor(name: string) {
    super(name);
  }

  // 实现抽象方法
  eat(): void {
    console.log(`${this.name}正在吃狗粮`);
  }
}

class Cat extends Animal {

  constructor(name: string) {
    super(name);
  }

  // 实现抽象方法
  eat(): void {
    console.log(`${this.name}正在抓老鼠`);
  }
}

let f: Animal; // 声明变量为Animal类型
f = new Cat('Tom');
f.eat();
```

