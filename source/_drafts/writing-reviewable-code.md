---
title: 书写可审核的代码 & 控制你的版本提交
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['代码审核', '编码风格']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 概览(Overview)
本文主要介绍应对于代码组织，控制代码变化的策略。

<!-- more -->

## 原则(Rules)
### 每个提交(commit)要尽可能小而简单。
试想一下，一个1000行改动的提交，与5个200行改动的提交。哪个更容易理解？

小而简单的提交，要好过庞大而复杂的提交。他们更易于理解，测试，审核。

### 最小的提交应该符合单一职责原则
一个最小的提交(commit)应该符合单一职责原则(Single Responsibility Principle，SRP)。
即，每个提交应该只做一件事。就如一个函数应该就只完成一个功能。

#### 每个提交要尽可能小，但要**适度**。
提交内容不能小到丧失了它完整的意义。
提交的内容，要完全符合提交的含义。比如提交描述里写的是完成某个功能，那么内容里的代码改动必须是能够实现描述所说的。

### 一对一
一个想法对应于一个提交。(one idea is one commit)

### 拆分
把一个大的提交，拆分成许多小提交。如同将大问题拆分成小问题，每个提交致力于解决一个问题。

#### 什么时候拆分？

### 友好的提交信息
书写友好的提交信息。比如描述这个提交的内容；解决了什么问题；完成了什么功能等等。

## 好处
### 有利于明白/回顾做了什么

### 有利于自动化发布(Release)
Release阶段，通常要准备版本号的更新，Change Log的更新，资源文件的整理/打包，代码的编译打包。
除了*Change Log的更新*，其他都可以实现自动化处理。若是开发团队完全遵守以上提出的原则，实现自动化发布是完全可能的。

### 有利于自动化测试
如果一次上传(push)太多功能，如果其中有个几个错误，那么由于混入了很多功能，反而不利于测试时暴露出问题所在。

## 副作用(Side Effects)
- 拆分大提交有时会严重影响到开发速度


## 参考(Bibliographies)
- [Phabricator Flavor Text - Writing Reviewable Code][B1]
- [Phabricator Flavor Text - Recommendations on Revision Control][B2]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[B1]: https://secure.phabricator.com/book/phabflavor/article/writing_reviewable_code/
[B2]: https://secure.phabricator.com/book/phabflavor/article/recommendations_on_revision_control/
