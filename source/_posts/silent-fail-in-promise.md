---
title: Promise 吞掉报错信息的问题
author: 'ADoyle <adoyle.h@gmail.com>'
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/copyright)'
tags:
  - Promise
  - JS
  - silent-fail
categories:
  - 技术
date: 2016-04-14 16:29:40
updated: 2016-04-14 16:29:40
---


## 前言(Intro)

当运行下面一段代码，会发生什么？

```js
Promise.resolve().then(function() {
    throw new Error('Ouch!');
});
```

恩，你看不到任何错误信息。
沉默的失败非常可怕。当发生错误时，你无法获知任何当时上下文的信息，仅有的线索只有程序没按正常的流程走。你甚至可能都没有机会察觉到发生了错误。

也许这是一个 Feature，而非 Bug。但我觉得这是一大隐患，所幸有些人也注意到这个问题，并已经在修正了。看看这个[提案][B1]。

[在 nodejs 1.x 起][0]，process 加入了两个事件 `rejectionHandled` 和 `unhandledRejection`，并且在大部分主流 Promise 库中也实现了这样的特性。为了捕获没有处理的 rejected promise。

<!-- more -->

## `rejectionHandled` 和 `unhandledRejection`

具体说明可参见 [NodeJS 的 process API 文档](https://nodejs.org/dist/latest-v5.x/docs/api/process.html#process_event_unhandledrejection)。

### 举个例子 🌰

如何使用 `unhandledRejection`，比如改写前言里的代码：

```js
Promise.resolve().then(function() {
    throw new Error('Ouch!');
});

process.on('unhandledRejection', function() {
    console.log('[unhandledRejection]', arguments);
});
```

你会发现被吞的错误终于吐出来了。

再看 `rejectionHandled` 的细节：

```js
Promise.resolve().then(function() {
    throw new Error('Ouch!');
});

var p = Promise.reject(new Error('WTF'));

setTimeout(function() {
    console.log('before hello');
    p.catch(function() {
        console.log('hello?');
    });
}, 1000);

process.on('unhandledRejection', function() {
    console.log('[unhandledRejection]', arguments);
});

process.on('rejectionHandled', function() {
    console.log('[rejectionHandled]', arguments);
});
```

输出

```
[unhandledRejection] { '0': [Error: WTF], '1': Promise { <rejected> [Error: WTF] } }
[unhandledRejection] { '0': [Error: Ouch!],
  '1': Promise { <rejected> [Error: Ouch!] } }
before hello
[rejectionHandled] { '0': Promise { <rejected> [Error: WTF] } }
hello?
```

`rejectionHandled` 是在 1000 毫秒以后才触发的。注意上面的代码，1000 毫秒以后 p.catch 才执行，实际上正是在 p.catch 执行的时候才触发了 `rejectionHandled` 事件。
`rejectionHandled` 主要是为了获知未捕捉的 rejected promise 何时被捕捉的（异步 catch）。

## 懒人包

[sindresorhus/loud-rejection][] 封装了 `rejectionHandled` 和 `unhandledRejection` 的处理。
你只要 `require('loud-rejection')();` 这么调用一下就会把未捕捉的 promise 里的错误打印出来。

## 参考(Bibliographies)
- [benjamingr - Possibly Unhandled Rejection NodeJS Promise Hook][B1]
- [Node.js Documentation][B2]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: https://gist.github.com/benjamingr/0237932cee84712951a2
[B2]: https://nodejs.org/dist/latest-v5.x/docs/api/process.html

[0]: https://github.com/nodejs/node/pull/758

[sindresorhus/loud-rejection]: https://github.com/sindresorhus/loud-rejection

