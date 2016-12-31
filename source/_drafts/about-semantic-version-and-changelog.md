title: 关于 Semantic Version 与 ChangeLog 的思考
author: 'ADoyle <adoyle.h@gmail.com>'
tags: []
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览(Overview)/前言(Intro)


[Bönnemann 在 JSConf 的演说][1]

[cracks][] 用于根据上一次的测试案例是否通过，来判定改动是否是不兼容的。
[semantic-release][] 用于自动化版本升级并发布。

然而大部分项目都不能做到完全的测试案例，测试覆盖度低。因此很多时候，都是人工判断某次 commit 是否有 breaking change。

<!-- more -->



## 参考(Bibliographies)
- [][B1]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"


[1]: https://www.youtube.com/watch?v=tc2UgG5L7WM "We fail to follow SemVer – and why it needn’t matter by Stephan Bönnemann at JSConf Budapest 2015"
[cracks]: https://github.com/semantic-release/cracks
[semantic-release]: https://github.com/semantic-release/semantic-release
