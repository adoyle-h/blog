---
title: 依赖与约束
author: ADoyle <adoyle.h@gmail.com>
tags: []
categories: []
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 前言 (Intro)

先下一个定义，依赖分内部依赖和外部依赖，这是相对于“我”来说的。
我能直接参与改动并发布到线上的依赖就是内部依赖，否则就是外部依赖。

引入一个依赖，意味着引入至少一个约束。

所以站在应用开发者的角色，我想尽量避免引入不必要的外部依赖，从而避免引入约束。

约束会造成什么影响？就是你接受到一个需求，因为存在某种约束，导致必然不能完成这样的需求。

内部依赖肯定也存在约束，但我们有能力改造它以修正这个约束，从而完成需求。


<!-- more -->

## 正文

## 为什么不用 XXX 框架/服务/工具？

首先，为什么要用 XXX？我需要列出

## 存在万能的框架/服务吗？

不存在。

那么当别人不能满足我的需求时，我应该怎么办？事情就不做了吗？


## 避免依赖全家桶

你可能会选择一个大而全的东西，但就我的经验来说，我会告诫你不要这么做。

因为全家桶或许会提高很大效率，但是面向一个特定场景开发出来的，也就是说在它面向的场景里是能提效的。
但对于它没有考虑过的场景，很可能会限制住你的行动。


## 如何选择？

我是否必须用这些外部依赖？
外部依赖能给我带来什么好处，给我带来什么约束（包括潜在约束）？
这些约束是否有能力绕过？

## 快速响应

### 当使用者有一个问题或需求出现时，服务者能否满足？

如果是外部依赖自身面临的问题或者需求，那自然它们必须会自行解决。
然而当我（使用者）有一个需求，并且这个需求可能不在它们的考虑场景内，那么它们是否会快速响应我的需求？还是直接告诉我不可以实现？

### 服务者能否快速响应使用者的需求？

突然半夜有个紧急 bug，我把依赖方叫起来陪着我一块改 bug？对方在休假怎么办？

内部服务不会提供 7x24 小时的技术服务。


## 参考 (Bibliographies)

- [][B1]

## 引用 (References)

[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"
