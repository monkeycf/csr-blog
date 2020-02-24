---
title: Mockjs
tags:
  - mockjs
categories:
  - mockjs
description: mockjs使用，在vue项目上使用
abbrlink: 577341194
date: 2020-02-24 23:54:49
---

# 语法
## DTD（数据模板定义规范）
```javascript
// 属性名   name
// 生成规则 rule
// 属性值   value
'name|rule': value
```
生成规则 有 7 种格式：
1. 'name|min-max': value
2. 'name|count': value
3. 'name|min-max.dmin-dmax': value
4. 'name|min-max.dcount': value
5. 'name|count.dmin-dmax': value
6. 'name|count.dcount': value
7. 'name|+step': value

生成规则和示例：

1. 属性值是字符串 String

  * 'name|min-max': string

    通过重复 string 生成一个字符串，重复次数大于等于 min，小于等于 max。

  * 'name|count': string

     通过重复 string 生成一个字符串，重复次数等于 count。

2. 属性值是数字 Number

    * 'name|+1': number

      属性值自动加 1，初始值为 number。

    * 'name|min-max': number

      生成一个大于等于 min、小于等于 max 的整数，属性值 number 只是用来确定类型。

    * 'name|min-max.dmin-dmax': number

      生成一个浮点数，整数部分大于等于 min、小于等于 max，小数部分保留 dmin 到 dmax 位。

      ```javascript
      Mock.mock({
          'number1|1-100.1-10': 1,
          'number2|123.1-10': 1,
          'number3|123.3': 1,
          'number4|123.10': 1.123
      })
      // =>
      {
          "number1": 12.92,
          "number2": 123.51,
          "number3": 123.777,
          "number4": 123.1231091814
      }
      ```

3. 属性值是布尔型 Boolean

    * 'name|1': boolean

      随机生成一个布尔值，值为 true 的概率是 1/2，值为 false 的概率同样是 1/2。

    * 'name|min-max': value

      随机生成一个布尔值，值为 value 的概率是 min / (min + max)，值为 !value 的概率是 max / (min + max)。

4. 属性值是对象 Object

    * 'name|count': object

      从属性值 object 中随机选取 count 个属性。

    * 'name|min-max': object

      从属性值 object 中随机选取 min 到 max 个属性。

5. 属性值是数组 Array

    * 'name|1': array

      从属性值 array 中随机选取 1 个元素，作为最终值。

    * 'name|+1': array

      从属性值 array 中顺序选取 1 个元素，作为最终值。

    * 'name|min-max': array

      通过重复属性值 array 生成一个新数组，重复次数大于等于 min，小于等于 max。

    * 'name|count': array

      通过重复属性值 array 生成一个新数组，重复次数为 count。

6. 属性值是函数 Function

    * 'name': function

      执行函数 function，取其返回值作为最终的属性值，函数的上下文为属性 'name' 所在的对象。

7. 属性值是正则表达式 RegExp

    * 'name': regexp

      根据正则表达式 regexp 反向生成可以匹配它的字符串。用于生成自定义格式的字符串。

      ```javascript
      Mock.mock({
          'regexp1': /[a-z][A-Z][0-9]/,
          'regexp2': /\w\W\s\S\d\D/,
          'regexp3': /\d{5,10}/
      })
      // =>
      {
          "regexp1": "pJ7",
          "regexp2": "F)\fp1G",
          "regexp3": "561659409"
      }
      ```

## DPD（数据占位符定义规范）
占位符 只是在属性值字符串中占个位置，并不出现在最终的属性值中。
```
@占位符
@占位符(参数 [, 参数])
```
# Mock.mock()
> Mock.mock( rurl?, rtype?, template|function( options ) )

* rurl：需要拦截的URL，字符串或正则
* rtype：Ajax请求类型
* template：数据模板，对象或模板
* function：响应数据的函数
* options：本请求的选项集，包含url/type/body

# Mock.setup()
> 配置拦截 Ajax 请求时的行为。支持的配置项有：timeout。

```javascript
Mock.setup({
    timeout: '200-600'
})
```

# Mock.Random
> Mock.Random 是一个工具类，用于生成各种随机数据。

```javascript
var Random = Mock.Random
Random.email()
// => "n.clark@miller.io"
Mock.mock('@email')
// => "y.lee@lewis.org"
Mock.mock( { email: '@email' } )
// => { email: "v.lewis@hall.gov" }
```

扩展
```javascript
Random.extend({
    constellation: function(date) {
        var constellations = ['白羊座', '金牛座', '双子座', '巨蟹座', '狮子座', '处女座', '天秤座', '天蝎座', '射手座', '摩羯座', '水瓶座', '双鱼座']
        return this.pick(constellations)
    }
})
Random.constellation()
// => "水瓶座"
Mock.mock('@CONSTELLATION')
// => "天蝎座"
Mock.mock({
    constellation: '@CONSTELLATION'
})
// => { constellation: "射手座" }
```

## Basic
1. Random.boolean( min?, max?, current? ) => 一个随机的布尔值
2. Random.natural( min?, max? ) => 一个随机的自然数
3. Random.integer( min?, max? ) => 一个随机的整数
4. Random.float( min?, max?, dmin?, dmax? ) => 一个浮点数
5. Random.character( pool? ) => 一个随机字符
    pool: 'lower'/ 'upper'/'number'/'symbol'/字符串选项
6. Random.string( pool?, min?, max? ) => 一个随机字符串
7. Random.range( start, stop?, step? ) => 一个整型数组

## Date
1. Random.date( format? ) => 一个随机日期的字符串
2. Random.time( format? ) => 一个随机时间的字符串
3. Random.datetime( format? ) => 一个随机的日期和时间的字符串
4. Random.now( unit?, format? ) => 当前的日期和时间字符串

## Image
1. Random.image( size?, background?, foreground?, format?, text? )
2. Random.dataImage( size?, text? ) => 一段随机的base64编码

## Color
1. Random.color()
2. Random.hex()
3. Random.rgb()
4. Random.rgba()
5. Random.hsl()

## Text
1. Random.paragraph( min?, max? ) => 一段文本
2. Random.cparagraph( min?, max? ) => 一段中文文本
3. Random.sentence( min?, max? ) => 一句话
4. Random.csentence( min?, max? ) => 一句中文句子
5. Random.word( min?, max? ) => 几个个字母
6. Random.cword( pool?, min?, max? ) => 几个汉字
7. Random.title( min?, max? ) => 一句标题
8. Random.ctitle( min?, max? ) => 一个中文标题

## Name
1. Random.first()
2. Random.last()
3. Random.name( middle? )
4. Random.cfirst()
5. Random.clast()
6. Random.cname()

## Web
1. Random.url( protocol?, host? )
2. Random.protocol()
3. Random.domain()
4. Random.tld() => 一个顶级域名
5. Random.email( domain? ) => 随机邮箱
6. Random.ip()

## Address
1. Random.region() => 区域（华北）
2. Random.province() => 省
3. Random.city( prefix? ) => 市
4. Random.county( prefix? ) => 县
5. Random.zip() => 邮政编码

## Helper
1. Random.capitalize( word ) => 首字母大写
2. Random.upper( str ) => 全部大写
3. Random.lower( str ) => 全部小写
4. Random.pick( arr ) => 随机选取元素
5. Random.shuffle( arr ) => 打乱数组

## Miscellaneous
1. Random.guid() => GUID
2. Random.id() => 18位身份证
3. Random.increment( step? ) => 全局递增整数

# 在Vue2项目中结合webpack4使用mock

## 方案

基于webpack-dev-server实现mock-serve。 通过chokidar来观察mock 文件夹内容的变化 ，并在发生变化时会清除之前注册的mock-api接口，重新动态挂载新的接口，从而支持热更新。

```javascript
// 参考：https://github.com/PanJiaChen/vue-element-admin/blob/master/mock/mock-server.js
const chokidar = require('chokidar')
const bodyParser = require('body-parser')
const chalk = require('chalk')
const path = require('path')
const Mock = require('mockjs')

// 获取绝对路径
const mockDir = path.join(process.cwd(), 'mock')

/**
 * 注册路由
 * @param app
 * @return {{mockStartIndex: number, mockRoutesLength: number}}
 */
function registerRoutes(app) {
  let mockLastIndex
  const mocks = require('./index.js') // Mock数据
  const mocksForServer = mocks.map(route => {
    return responseFake(route.url, route.type, route.response)
  })
  for (const mock of mocksForServer) {
    app[mock.type](mock.url, mock.response) // 添加路由 mock serve
    mockLastIndex = app._router.stack.length
  }
  const mockRoutesLength = Object.keys(mocksForServer).length

  return {
    mockRoutesLength: mockRoutesLength,
    mockStartIndex: mockLastIndex - mockRoutesLength
  }
}

// 删除缓存
function unregisterRoutes() {
  Object.keys(require.cache).forEach(i => {
    if (i.includes(mockDir)) {
      delete require.cache[require.resolve(i)]
    }
  })
}

// 创建mock server
const responseFake = (url, type, respond) => {
  return {
    url: new RegExp(`${process.env.VUE_APP_BASE_API}${url}`),
    type: type || 'get',
    response(req, res) {
      console.log('request invoke:' + req.path)
      res.json(Mock.mock(respond instanceof Function ? respond(req, res) : respond))
    }
  }
}

module.exports = app => {
  // parse app.body
  // https://expressjs.com/en/4x/api.html#req.body
  app.use(bodyParser.json())
  app.use(bodyParser.urlencoded({
    extended: true
  }))

  const mockRoutes = registerRoutes(app)
  let mockRoutesLength = mockRoutes.mockRoutesLength
  let mockStartIndex = mockRoutes.mockStartIndex

  // 监测文件，热跟新
  chokidar.watch(mockDir, {
    ignored: /mock-server/,
    ignoreInitial: true
  }).on('all', (event, path) => {
    if (event === 'change' || event === 'add') {
      try {
        // 移除mock route
        app._router.stack.splice(mockStartIndex, mockRoutesLength)
        
        // 清除缓存
        unregisterRoutes()

        const mockRoutes = registerRoutes(app)
        mockRoutesLength = mockRoutes.mockRoutesLength
        mockStartIndex = mockRoutes.mockStartIndex

        console.log(chalk.magentaBright(`\n > Mock Server hot reload success! changed  ${path}`))
      } catch (error) {
        console.log(chalk.redBright(error))
      }
    }
  })
}
```

