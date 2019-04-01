---
title: 我的日志最佳实践
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['log']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 概览(Overview)/前言(Intro)


<!-- more -->

## 日志的好处
- 调试
- 监控与预警
- 非实时的数据分析
- 查看历史

## 日志格式
使用 json 代替传统的 printf-style 输出格式

Logging objects instead of a format string enables you to more easily index and trace operations across hundreds of different machines and different software systems. With traditional format strings it is too fail deadly for the programmer to not log all the necessary information for a later operator to trace an operation.

### 伸缩性
> JSON is crazy verbose. But you pay for flexibility, we want to remove and add fields at will everyday with new business requirements. Its a pain to maintain csv log versions or use the "never remove a column" rule.

### 键值对 (key-value pair)


## 传统字符串格式的缺点
- 难以建立索引
- 伸缩性不好。一旦增加或改变输出的数据字段，为了可读性，就需要重新构造 message。
- 格式容易被破坏，从而难以解析(parse, filter or grep)。（正则表达式不是万能的）

## 日志内容
- 日志发生的日期和时间，包含时区信息和毫秒（至少精确到毫秒），建议使用 ISO-8601 时间格式
- 日志级别，例如 debug、info 和 error
- 相应的会话标识，用于识别是哪个客户端或者是其他请求所产生的日志
- 可读的日志内容
- 适当的上下文的数据

## 日志类型
- 业务层
- 数据层
- 框架层

## 注意点

### 不要跨行(\n)，一个日志保持在一行内

### 不同关注领域写不同的日志文件
当访问和调用极其频繁，有时候你会发现把你的工程里什么信息都打印到一个日志文件里，会让你看得头昏脑胀。
最简单的示范就是Apache的访问日志和错误日志是分开的。
同样，你也可以把更加安静的事件（偶尔出现）与更加喧闹的事件分开存储。
如，对外的开放平台可以打印三种日志文件：connection log（建立链接和关闭链接，附带接入参数），message log（内部调用链），stacktrace log（异常的堆栈打印）。

### 将性能数据标准化输出

### 日志的第一受众是人类还是机器？
首先要机器可读，一旦机器可读，就能转化为人类可读。

### 不要忽略错误

```
try {
  // an exception is thrown
} catch(error) {
  // nothing to do with error
}
```

要么打印 error 级别，要么打印 warn 级别。并且把 error 相关的 message、stack 信息打印出来。

这是错误处理要讨论的事，请阅读我的另一篇文章，[「」](source/_drafts/my-best-practices-of-error-handling.md) 有介绍。

## 在哪里打印日志
- 访问数据库的dao层；
- 访问外部资源的ext层；
- 访问mq的方法；
- 等等，一切不在你自己负责的工程掌握的部分（外部），或一切你认为自己工程的性能危险点，都需要加入性能监控日志。

## 错误级别
- 级别不要设置太多，选择太多就会冗余

## 日志带来的开销

## Q&A
### 为什么容许一条错误日志有多行输出？
三点原因：

- 容易阅读
- 传输消息协议的容量上限
- 存储单条日志的容量上限

### 为什么 Apache log，syslog 等经典设施，都用的是 printf-style 日志格式？
因为在 unix 哲学氛围 和 grep、awk 等工具作用下，直接处理文本更合适。

然而时代在变化，随着解析 json 的命令行工具（如 [jq][0]）诞生，以 json 作为日志格式变得可行。

## Logging Checklist

- [ ]


## 参考(Bibliographies)
- [Paul's Journal - Write Logs for Machines, use JSON][B1]
- [Joyent - Service logging in JSON with Bunyan][B2]
- [splunk - Logging best practices][B3]
- [loggly - JSON: Best Practices for Logging][B4]
- [Hacker news][B5]
- [写给开发者：记录日志的 10 个建议](https://juejin.im/entry/58b647438fd9c50061220349)
- [CODING HORROR - The Problem With Logging](https://blog.codinghorror.com/the-problem-with-logging/)

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: https://journal.paul.querna.org/articles/2011/12/26/log-for-machines-in-json/
[B2]: http://blog.nodejs.org/2012/03/28/service-logging-in-json-with-bunyan/
[B3]: http://dev.splunk.com/view/logging-best-practices/SP-CAAADP6
[B4]: https://community.loggly.com/customer/portal/articles/1189777-json-best-practices-for-logging
[B5]: https://news.ycombinator.com/item?id=3896833

[0]: http://stedolan.github.io/jq/`
