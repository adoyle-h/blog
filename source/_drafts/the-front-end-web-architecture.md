---
title: 前端应用架构
author: ADoyle <adoyle.h@gmail.com>
tags: []
categories: []
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览 (Overview)

## 前言 (Intro)

传统写前端都是在拼页面，拼逻辑，所有的东西都是零散的，互不相关的。主要因为浏览器帮你做好了很多事情，容错、渲染、安全机制等等。
自从组件化和 SPA 概念开始流行，我发现前端也可以开发应用/系统的思路去做。
利用 webpack 和 create-react-app 提供基础开发环境。
声明一个 class Application，所有模块跟 Application 关联，实现应用逻辑。

https://files.slack.com/files-pri/T0B1KDZQA-F8NPHRUR4/image.png

比如这样的目录结构，我以开发服务端的经验，去做前端的应用开发

因为所有的东西都是零散的，导致很难做批量处理，项目越来越大，之后想全局修改就会变得成本很高。而以 Application 为中心开发，将底层通用逻辑都以 Application 的公共方法来实现，其他模块调用 app.method()，这样可以直接修改这些公共方法，或者继承覆盖来更改实现。

service 模块是用来封装 api 请求的，以替代自己随意用 xhr 或者 fetch 去发请求，统一入口

model 模块借用了 dva 的概念，将页面状态和部分逻辑放到 model 里管理维护。
https://github.com/dvajs/dva/

Components/Containers 是组件的渲染/容器层的开发思路

webpack 在我看来就是一种资源管理器，它让 js 有能力去加载一切外部资源。前端应用在浏览器里运行，它可以动态的去加载资源，无论是图片，css，js，html，markdown，文本文件，svg。也无论资源在本地文件系统还是在 cdn 还是其他 http 服务器。


大致这种层级：

```
业务逻辑: Component/Container/Page
---
应用层: Application
---
基础底层: react、postcss、webpack、babel、create-react-app
---
平台: 浏览器、HTML、JS、CSS
```

于是我的 bundle 入口就变成了这样

https://files.slack.com/files-pri/T0B1KDZQA-F8N2JN0MT/image.png

抽象出 Application 还有一个好处，因为所有操作都跟 app 关联，我就可以将这个变量注入到 window，
于是我可以在浏览器端实时调试 window.app 关联的任何操作。


<!-- more -->



## 参考 (Bibliographies)
- [][B1]

## 引用 (References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"

