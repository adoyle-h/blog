---
title: how-i-use-yoman
author: ADoyle <adoyle.h@gmail.com>
tags: []
categories: []
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 前言 (Intro)

Yo 不只在项目搭建初期使用，它可以在整个项目生命周期中发挥作用。

<!-- more -->


自从[2015 年末](https://github.com/yeoman/environment/issues/11)就支持 `yo <local-generator-path>` 这样的操作。

所以目前 yo 的 generator 有三种读取方式。

1. `npm i -g <generator>`
2. `npm i -D <generator>`
3. `本地 generator 路径`


## 需求

我想要针对某个公司或私人项目做一个文件模板，但可能这个模板会经常变动，如果每次发版本显得很麻烦。这时候可以选择第三种方式。

因为这个模板只作用于当前这个项目，不必给其他项目使用，封装成 npm 包反而烦琐。


## 参考 (Bibliographies)
- [][B1]

## 引用 (References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"

