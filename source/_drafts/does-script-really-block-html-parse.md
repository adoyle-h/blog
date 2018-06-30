---
title: Script 标签会阻塞 HTML 解析吗？
author: ADoyle <adoyle.h@gmail.com>
tags: ['前端', 'HTML']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 前言 (Intro)

加载 `<script>` 会阻塞 HTML 解析吗？
你可能会说，当然会阻塞啊，不是常说“css 放 head，script 放 body 底部”吗？因此才有 `<script>` 的 async、defer 属性，要不然要它 (defer) 何用？

如果你不确定，可以看下的 [How browsers work][B4] 的 [HTML Parser 章节](http://taligarsiel.com/Projects/howbrowserswork1.htm#HTML_Parser)。

> html解析过程是至上而下的，当html解析器遇到诸如<script>、<link>等标签时，就会去下载相应内容。且加载、解析、执行JavaScript会阻止解析器往下执行。

加载 `<script>` 的确会阻塞 HTML 解析，但是因为推测解析的功能，将 script 触发下载的时间大幅提前。

<!-- more -->

## 问题

script 的耗时分成三部分：下载 + 编译 + 执行

首先明确这篇文章要探究的几个问题：

1. script 文件的下载、编译、执行过程（或者其中某一步骤）是否会阻塞 html 的解析？
2. 多个 script 文件是并行下载还是顺序下载的，即多个 script 触发开始下载的时间点？

因此我们不关心浏览器页面的渲染时间以及是否重新渲染。也不关心 css 文件的下载时间。

另外我们要讨论的是首次渲染 HTML 文件以及 `<script>` 直接写在 `<head>` 或 `<body>` 内的场景，而不是通过 JS 来动态插入 `<script>` 的场景。

## 并行下载还是顺序下载？

无论是 [whatwg 的描述][^1]:

> For classic scripts, if the async attribute is present, then the classic script will be fetched in parallel to parsing and evaluated as soon as it is available (potentially before parsing completes). If the async attribute is not present but the defer attribute is present, then the classic script will be fetched in parallel and evaluated when the page has finished parsing. If neither attribute is present, then the script is fetched and evaluated immediately, blocking parsing until these are both complete.

![This is all summarized in the following schematic diagram](https://html.spec.whatwg.org/images/asyncdefer.svg)

还是 [w3c 的描述][^2]:

> There are three possible modes that can be selected using these attributes. If the async attribute is present, then the script will be executed asynchronously, as soon as it is available. If the async attribute is not present but the defer attribute is present, then the script is executed when the page has finished parsing. If neither attribute is present, then the script is fetched and executed immediately, before the user agent continues parsing the page.

>> The exact processing details for these attributes are, for mostly historical reasons, somewhat non-trivial, involving a number of aspects of HTML. The implementation requirements are therefore by necessity scattered throughout the specification. The algorithms below (in this section) describe the core of this processing, but these algorithms reference and are referenced by the parsing rules for script start and end tags in HTML, in foreign content, and in XML, the rules for the document.write() method, the handling of scripting, etc.

都说 `<script>` 会阻塞 html 解析，那意思就是如果 html 写了两个 script 标签，那么先下载并执行第一个 script，然后才下载第二个 script 这样的过程吧。
但是我写了一个 html 在 chrome 里试了一下，发现 script 是并行下载，没有阻塞的。


### 例子

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <title>test</title>
  </head>
  <body>
    hello
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react/16.4.1/cjs/react.production.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/lodash@4.17.10/lodash.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react-dom/16.4.1/cjs/react-dom-test-utils.production.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react-router/4.3.1/react-router.min.js"></script>
  </body>
</html>
```

![对应的解析过程.png](http://7xniyb.com1.z0.glb.clouddn.com/share/script_and_html_parse_2018-06-25_13-22-17.png)

实际测试发现 script 的解析加载并没有阻塞住 html 的解析。

标准文档错了吗？

## HTML 推测解析

答案就是 HTML 推测解析（Speculative Parsing），也称作预测解析。也有称为 预加载（Preload）。
注意是预加载，而不是预构建或预渲染。

推测解析主要针对

- 脚本
- 外部 CSS
- 来自 img 标签的图片

> Firefox 也会预加载 video 元素的 poster 属性，而 Chrome 和 Safari 会预加载 @import 规则的内联样式。



请阅读这篇译文：[《更快地构建DOM: 使用预解析, async, defer 以及 preload》][B1]


Gecko 内核

- https://developer.mozilla.org/en-US/docs/Mozilla/Gecko/HTML_parser_threading
- https://developer.mozilla.org/en-US/docs/Web/HTML/Optimizing_your_pages_for_speculative_parsing

WebKit 内核

- 


其他参考资料: http://taligarsiel.com/Projects/howbrowserswork1.htm#Speculative_parsing

2008 年 IE 8 预览版引入了 Speculative Download 的概念。从 2009 年开始，IE 8 和 Firefox 3.5 正式支持 Speculative Parsing 特性。
没考证到 Chrome 是从何时开始的，实测当前的 Chrome 是支持该特性的。实测 Safari 目前版本（11.1.1 (13605.2.8) ）仍不支持该特性。
遗憾的是这到目前为止仍是浏览器厂商自己的黑魔法，并没有定在 HTML 标准中。
因此不能保证所有浏览器都是这么实现的，况且预测解析存在预测失败的情况，那时将付出更多的工作。

推测解析只是把 script 的开始下载时间提前了，但并不改变 script 的执行阻塞 html 解析的行为。

没有推测解析

![](https://www.w3cplus.com/sites/default/files/blogs/2017/1709/dom-9.png)

用了推测解析

![](https://www.w3cplus.com/sites/default/files/blogs/2017/1709/dom-10.png)


若想改变 script 的执行阻塞 html 解析的行为，你需要用到 script 标签的 `async` 或者 `defer` 属性。

defer 属性是这样

![](https://www.w3cplus.com/sites/default/files/blogs/2017/1709/dom-11.png)

async 属性是这样

![](https://www.w3cplus.com/sites/default/files/blogs/2017/1709/dom-12.png)


## 注意点

`document.write()` 会改变 DOM 树的状态，预构建过程会失败。


## preload 属性

除了 script，你还可以赋予其他 DOM 元素这样的特性，只要使用 `rel="preload"` 属性即可。
该属性的浏览器兼容性请看[](https://caniuse.com/#search=preload)。

还有 `rel="prefetch"` 参考文章[^3]

## 衍生问题

### 预测解析失败的情况

script 有用 `document.write()` 改变 DOM 树的状态，会导致预加载过程失败。



### script compo 服务有没有必要？

因为普通的 script 还是 compo script，多个 script 下载开始时间都是几乎没差别的。
而多个 script 和 compo 后的 script，文件体积也是差不多的，实际可能拆成多个 script 的 gzip 压缩率更高。
两者编译和执行代码的时间也是差不多的。

唯一的差别就是浏览器的请求并发数的限制（对于 HTTP/1.0 和 HTTP/1.1 协议来说）。每个域名的请求并发数通常是 6，所有域名请求的并发总数是 10。

针对 HTTP/2 协议的资源请求，就更不用考虑请求并发数的限制了。因为 HTTP/2 的多路复用特性。[参考文章][B7]

## 参考 (Bibliographies)

- [][B1]，其[原文][B2]
- [JavaScript阻塞剖析与改善][B3]
- [How browsers work][B4]
- [HTTP/2笔记之流和多路复用][B7]
- [Preload，Prefetch 和它们在 Chrome 之中的优先级][B8]

## 引用 (References)

[^0]: [][R1]
[^1]: https://html.spec.whatwg.org/multipage/scripting.html#attr-script-defer
[^2]: https://www.w3.org/TR/2014/REC-html5-20141028/scripting-1.html#the-script-element
[^3]: https://github.com/xitu/gold-miner/blob/master/TODO/preload-prefetch-and-priorities-in-chrome.md


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: https://www.zcfy.cc/article/building-the-dom-faster-speculative-parsing-async-defer-and-preload-x2605-mozilla-hacks-8211-the-web-developer-blog-4224.html
[B2]: https://hacks.mozilla.org/2017/09/building-the-dom-faster-speculative-parsing-async-defer-and-preload
[B3]: http://www.cnblogs.com/giggle/p/5513769.html
[B4]: http://taligarsiel.com/Projects/howbrowserswork1.htm
[B7]: http://www.blogjava.net/yongboy/archive/2015/03/19/423611.html
[B8]: https://juejin.im/post/58e8acf10ce46300585a7a42
