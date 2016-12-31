title: JSON Schema 的应用
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['JSON', 'JSON Schema']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 什么是 JSON Schema？
JSON Schema 是一种用于描述和验证 JSON 数据结构的格式。
一种建议标准，仍然处于起草阶段(Draft 4)。
一种机器可读，且人类可读的 JSON 格式。

<!-- more -->

## 基本结构
```json
{
    "title": "Example Schema",
    "type": "object",
    "properties": {
        "firstName": {
            "type": "string"
        },
        "lastName": {
            "type": "string"
        },
        "age": {
            "description": "Age in years",
            "type": "integer",
            "minimum": 0
        }
    },
    "required": ["firstName", "lastName"]
}
```

- [简单例子](http://json-schema.org/example1.html)
- [复杂例子](http://json-schema.org/example2.html)

## JSON Schema 有什么用？
### 语言无关的校验规则
通常我们用正则表达式来进行规则校验，可是正则表达式无法进行结构性的校验。
JSON Schema 非常灵活，功能很广泛。

### 描述 API接口 或者 函数接口
将数据校验从业务层放到底层

### JSON 自描述

## [JSON Hyper Schema][B6]
JSON Schema 的扩展。针对 HTTP 设计的。

## 应用场景
### no-sql 数据库
虽然 mongodb 是 Schemaless 的， 但是 mongoose 这种 ORM 还是提供了 schema 设计。

### 包管理器的 JSON 配置文件。
如 npm、bower 等等。对 package.json 的格式进行校验。

### [JSON 在线编辑器][json-editor]
技术人员写好 json schema，非技术人员就能用编辑器填入数据，生成 json。

### [JSON Resume][JSON-Resume]

### HTTP 请求校验与响应描述
使用[JSON Hyper Schema][B6]
可以参考[Elegant APIs with JSON Schema][B3]这篇文章。

#### 响应
作为一种独立的 API 资源，可以单独请求到某个资源的 JSON Schema。

### 函数 API 校验

### RESTful API 的设计模型
如 [API Blueprint][B4]、[Swagger][B5] 等 DSL。

## 一些工具
### JS
- [garycourt/JSV](https://github.com/garycourt/JSV)
- [apiaryio/Amanda](https://github.com/apiaryio/Amanda)
- [jdorn/json-editor][json-editor]
- [interagent/prmd](https://github.com/interagent/prmd). JSON Schema tools and doc generation for HTTP APIs


## 参考(Bibliographies)
- [json-schema.org][B1]
- [Understanding JSON Schema][B2]
- [@brandur - Elegant APIs with JSON Schema][B3]
- [API Blueprint][B4]
- [Swagger][B5]
- [JSON Hyper Schema][B6]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: http://www.searchcio.com.cn/whatis/word_4547.htm

[B1]: http://json-schema.org/
[B2]: http://spacetelescope.github.io/understanding-json-schema/index.html
[B3]: https://brandur.org/elegant-apis
[B4]: http://apiblueprint.org/
[B5]: https://github.com/swagger-api/swagger-spec
[B6]: http://json-schema.org/latest/json-schema-hypermedia.html

[json-editor]: https://github.com/jdorn/json-editor
[JSON-Resume]: https://jsonresume.org/
