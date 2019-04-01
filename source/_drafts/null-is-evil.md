---
title: Null is Evil
author: 'ADoyle <adoyle.h@gmail.com>'
tags: []
categories: []
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 概览(Overview)/前言(Intro)

我很讨厌 null，因为编码生涯中见得最多的错误就是 `xxx is not defined`，`Cannot read property 'xxx' of null`，因它而踩过的坑更是数之不尽。

其实，我最讨厌的是定义不明确的函数，以及忘了判断 null 的代码。

<!-- more -->

## 定义不明确的函数

对于强类型语言，以 C 举例：

```C
int function plus(int a, int b);
```

对于弱类型语言，以 JS 举例：

```js
/**
 * @param  {Number} a
 * @param  {Number} b
 * @return {Number}
 * @method plus(a, b)
 */
function plus(a, b) {}
```

> 我拿你当 Int，你却给我 Null？


## Maybe & Optional & Null Object

Haskell 的 Maybe，或者 Java/Swift 的 Optional，是一种能够避免遗漏判断 null 的措施。

本质上，它们是一种 Null Object。

## 预判与容错

你需要预判数据是否为 null。

你不应该总是容忍 null，不要总是为变量设定默认值。


## 参考(Bibliographies)
- [][B1]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"
