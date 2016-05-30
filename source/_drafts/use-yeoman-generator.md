---
title: Yeoman-generator 踩坑记
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['yeoman']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览(Overview)/前言(Intro)


<!-- more -->

### generators 目录中不要嵌套 generators 目录

否则执行 `yo app` 会进入到 `generators/generators/index.js` 里去，而不会去找 `generators/app/index.js`。
即使在 package.json 里写了 `"files": ["generators/app"]` 也没有用

### 安装依赖的建议

尤其是写子生成器 (sub-generator) 的时候，不要在 install 回调中使用 `this.npmInstall` 等安装函数。
因为安装过程是异步的，而 install 过程中你无法控制异步。当你想要控制异步流程，比如安装之前再用 `this.prompt` 询问意见，会极其麻烦。

所以在 `generator-generator` 以及 `generator-node` 的实现中，只在 `generators/app` 的 install 回调中执行一次 `this.npmInstall()`，而在其他子生成器中，全都使用 `this.fs.writeJSON` 的方式将依赖版本号先写入 `package.json` 里去;

### composeWith 的坑

每个生成器的回调函数

### yeoman-environment 吞错误信息

当你使用 `yeoman-environment` 来构建自己的 yeoman 启动程序时，可能会发现生成器里 throw 出的错误被吞了，你完全得不到提示。

## 参考(Bibliographies)
- [
leozdgao - 写一个自己的 Yeoman Generator][B1]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: https://leozdgao.me/write-yeoman-generator/
