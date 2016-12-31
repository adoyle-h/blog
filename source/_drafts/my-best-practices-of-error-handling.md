title: 我的错误处理最佳实践
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['JavaScript', '错误处理', '代码风格']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览(Overview)/前言(Intro)

与[《我的日志最佳实践》][0] 一起食用味道更佳。

<!-- more -->

## 错误与异常的分类

Joyent 将错误分为两类，操作错误（Operational errors）和程序员错误（programmer errors）。

操作错误，是正确编写的程序在运行时产生的错误。它并不是程序的 Bug，而通常是其它问题导致的，例如：

- 客户端的问题
    - 无效的用户输入
- 系统配置问题
    - 没有配置远程主机的路由
- 网络问题
    - 无法解析主机名
    - 请求超时
    - 端口挂起
- 远程服务的问题
    - 服务器返回 5xx 错误
    - 连接不到服务器
- 系统本身的问题
    - 系统内存不足
    - 打开文件数过多

程序员失误，是程序里的 Bug。这些错误往往可以通过修改代码避免。它们永远都没法被有效的处理。例如：

- 试图读取 undefined 的属性
- 调用异步函数时没有指定回调函数
- 该对象的时候传了一个字符串

而我认为错误应该分为这两类：可预料的错误（expected error），以及编程错误（programing error）

## 定义你自己的错误类型

### 错误码

一般我使用 `[A-Z]\d{3}` 格式的错误码，前面一位字母代表项目的首字母，后面三位数字代表错误码编号。其实两位数字，100 个编码就已足够用了。

### 错误元数据（Metadata）


## 错误继承


## 错误的生命周期

- 创建错误，`new Error`
- 传递错误
- 捕捉错误
- 处理错误

## 传递错误

throw error

callback(error)

event emit error

传递同步函数中的错误，传递异步函数中的错误。

传递编程错误（programing error），传递可预料的错误（expected error，又或者称为操作错误），传递异常（exception），传递。

## 捕捉错误

你不需要也不应该在每一处代码都捕捉错误。

那么何时应该捕捉错误？只有当你有能力（或者应该）合理地处理这个错误时，才去捕捉它；否则，你应该把这个错误抛给上层调用者。

在进程最外层捕捉错误，打印出错误堆栈，并退出进程。（这步通常由语言平台自身实现）


### 如何得到错误？

> 虽然我们在抛错，但是是以一种平静温和的方式抛错，而不是像一个小孩子那样，有什么不对劲就闹脾气大喊大叫。[^1]

throw/try/catch 方式就是后者。
同时，throw/try/catch 是违反直觉的。在我们期待于函数返回值的时候，它却以第三种形式反馈给上层，打破常规，若不尝试抓住（catch）它，它就要捣蛋。

然而，你不能使用 throw 将一次远程调用（如 RPC 或者 HTTP 请求）过程中发生的错误直接抛给调用者，实际上调用者是通过应用层协议中的返回值判断是否发生错误。你也不能使用 throw 将子进程（或子线程）中发生的错误直接抛给父进程，实际上父进程是通过信号来或者来自子进程的信息。

输出/输出（IO）是合乎直觉的，而且不受到格式与环境限制，错误信息也是一种数据，通过 IO 以一种平和的方式传递信息，而无需特殊的设计机制。


## 处理错误

### 打印错误日志

你不需要也不应该在每一处代码都打印错误日志。

当我们需要打印出错误时，只打印一条错误信息是不够的，至少还需要错误堆栈。更好的是把发生错误的上下文信息也打印出来。

终端和文件的错误日志的输出样式最好区分开来，详见[《我的日志最佳实践》 - 日志格式][1]


## 参考(Bibliographies)
- [Joyent - Error Handling in Node.js][B1]
- [StackOverflow - Why should I not wrap every block in “try”-“catch”?][B2]

## 引用(References)
[^1]: [Mostly Adequate Guide - 第 8 章: 特百惠 - “纯”错误处理][R1]


<!-- 以下是相关链接 -->

[R1]: https://github.com/llh911001/mostly-adequate-guide-chinese/blob/master/ch8.md#纯错误处理

[B1]: https://www.joyent.com/developers/node/design/errors
[B2]: http://stackoverflow.com/questions/2737328/why-should-i-not-wrap-every-block-in-try-catch

[0]: http://adoyle.me/blog/my-best-practices-of-log.html
[1]: http://adoyle.me/blog/my-best-practices-of-log.html#