---
title: HTTP API 设计
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['HTTP', 'API']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 概览(Overview)/前言(Intro)


<!-- more -->

## 请求(Request)

### QueryString 参数

建议使用不会让别人可能误解的词，如 `lt`，`lte`，`gte`，`gt`

避免使用 `since`，`max` 这种单词，比如 `since=1` 究竟是 `≥ 1` 还是 `> 1`？


## 响应(Response)

### 数据格式



有几种分歧。

一、

#### 正常数据

#### 元数据

#### 错误格式

```json
{
    "code": "123",
    "message": "something wrong",
    "detail": "xxx is broken in server",
    "url": "http://docs.service.com/errors/123"
}
```

- code: 错误码。
- message: 一句话概括的错误信息。
- detail: 更具体错误的信息。
- url: 指向官方的错误文档，提供错误的完全解释，以及相应的处理措施。

### 保持数据完整

完整的定义：

必选字段

值、数组、对象


数组查询，完整性。

实际所得数量与查询数量不相等。

### 分页





## 参考(Bibliographies)
- [][B1]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"
