title: '定义 created_at 与 updated_at 字段'
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['数据库', '数据']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 前言(Intro)

许多 ORM 都默认提供了这样的功能：在定义表的时候，默认添加上 `created_at` 和 `updated_at` 字段，甚至还有 `deleted_at`。

于是我产生一个疑问，是否应该为每一个表都加上这两个字段？

<!-- more -->

## 优点

- 能够知道这条记录的创建时间。
- 能够根据创建时间排序。
- 能够让人知道这条数据最新的更改时间。
- 利于调试。
- 利于挖掘其他商业价值。

## 缺点

- 这两个字段的存储是个不小的开销。
- 每次更新记录，都得更新 `updated_at`，有性能开销。
- 多一个字段，就又增加了很多索引的组合。

## 理论
理论上，每个表都应该有 `created_at` 和 `updated_at` 字段，因为数据的价值大于存储与更新的开销。

## 实际
实际上，每个表都至少应该有 `created_at`，而 `updated_at` 是可选的。

因为你无法保证未来不会出现需要根据创建时间排序的需求，而到了那时，如果某张表没有 `created_at` 字段，就无法实现排序。那时你也无法补充上 `created_at` 的数据。
实际上，很多应用场景都需要涉及创建时间，所以 `created_at` 是必要的。

首先，应用 `updated_at` 的场景没有 `created_at` 那么多。
其次，如果在未来需要根据 `updated_at` 来排序，可以用 `created_at` 补上，虽然无法表示真实情况，但在业务上来讲，或许是可以接受的。
所以我认为不必给每张表都加上这个字段。

另外，“更新时间”的含义其实是模糊的，在数据库角度来讲，是某条记录最近一次被修改的时间；而在业务角度来讲，“更新时间”并不一定等于数据的更改时间。
不要对有歧义的事物，定义通用的做法。

## 参考(Bibliographies)
- [stackoverflow - Why have created_at and updated_at?][B1]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: http://stackoverflow.com/questions/33167596/why-have-created-at-and-updated-at
