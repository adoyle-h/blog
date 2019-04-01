---
title: Async.js 的 eachLimit 与 NodeJS 的异步 IO
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['Async.js', 'NodeJS', 'IO']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 前言(Intro)

一个月前，某位同事问了我一个很好的问题（因为当时我没能答出来），大意如下：

> 为何 [async.js][async] 要提供一系列 limit 函数，如 each 和 eachLimit，parallel 和 parallelLimit？
> 对于下面这种情况：
    ```js
    var arr = [1, 2, 3];
    async.each(arr, doSomethingAsync, callback);
    ```
> 即使 arr 的长度非常大，应该也是没有问题的，因为 node 的 IO 是有线程池操纵的。
> arr 的长度为 n，node 并不会在短时间内发送 n 个 io 请求。这对于本地服务端来说没有负担。
> 那么就没有必要使用 `async.eachLimit(arr, 10, doSomethingAsync, callback);`

我也觉得很有道理，当时能想到的理由就只有不给被请求的服务端造成负担。

所以，来研究一下，NodeJS 是如何处理异步 IO 的。

<!-- more -->

## libuv

libuv 为 NodeJS 提供了跨平台，线程池，事件池，异步 I/O 等能力。

### 网络 IO 与文件 IO 的不同

文件 I/O，DNS 查询等操作，是由自身的线程池（Thread Pool）来实现的。
网络 I/O 是由（跟具体平台相关的） epoll、IOCP、kqueue 来实现的。

## 请求的声明周期

业务逻辑层，libuv，系统内核

## 结论(Conclusion)


## 参考(Bibliographies)
- [][B1]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: http://docs.libuv.org/en/v1.x/design.html
[B2]: http://docs.libuv.org/en/v1.x/threadpool.html#threadpool
[B3]: http://liyangready.github.io/2015/08/14/nodejs%E7%9C%9F%E7%9A%84%E6%98%AF%E5%8D%95%E7%BA%BF%E7%A8%8B%E5%90%97%EF%BC%9F/

[async]: https://github.com/caolan/async#documentation
[libuv]: https://github.com/libuv/libuv
