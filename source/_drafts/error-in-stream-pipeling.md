---
title: NodeJS Stream 的错误处理
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['Stream', '错误处理']
categories: ['技术', 'NodeJS']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览(Overview)/前言(Intro)

在我们使用 stream 来写代码时，很可能写下这样的代码：

```js
rstream
    .pipe(foo)
    .pipe(bar)
    .on('error', function (err) {
        // handle the error
    });
```

```js
rstream
    .on('error', handleError)
    .pipe(foo)
    .on('error', handleError)
    .pipe(bar)
    .on('error', handleError);
```
<!-- more -->

## 错误递进(forward error)

### 反例

1. 如果

```js
src.on('error', function(err) {
    dest.emit('error', err);
});
```

```js
net.createServer(function (socket) {
    socket.pipe(new Encryptor()).pipe(socket);
});
```


## 解决方案

## 参考(Bibliographies)
- [][B1]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: https://groups.google.com/forum/#!topic/nodejs/lJYT9hZxFu0/discussion
