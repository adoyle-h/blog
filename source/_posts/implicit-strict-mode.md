---
title: 告别 'use-strict'
author: ADoyle <adoyle.h@gmail.com>
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/copyright)'
tags: ['NodeJS']
categories: ['技术']
date: 2016-09-17 13:43:38
updated:
---



## 概览 (Overview)

结论：如果你使用的 node 版本 >= 2.0.0，可以不必再在每个文件头写 `'use-strict';`，因为 node 已经默认开启 strict 模式。

<!-- more -->

## More

我在配置 eslint 的过程中发现高版本的 node 已经实现了 `implicit strict mode`，即无须使用 `--use_strict` flag 也无须在文件头写入 `'use strict';`，默认开启严格模式。
那么从何时起实现了这功能？

我找寻了 [node changelog][] 以及 [v8 changelog][]，并没有获得相关信息。
[node.green](http://node.green/) 提供 node 层面的功能检测。然而它覆盖的版本不够多(4.x 从 4.3.2 开始)。
所幸它是开源的，我使用 [williamkapke/node-compat-table](https://github.com/williamkapke/node-compat-table) 在本地跑了一遍，结果如下：

![](http://7xniyb.com1.z0.glb.clouddn.com/blog/Monosnap%202016-09-17%2013-14-50.png)

至少从 2.0.0 版本开始就完全实现了 `implicit strict mode`， 1.5.0 还要开启 `harmony flag`，1.0.0 版本还不可用。

因为 1.x、2.x、3.x 的版本是过渡阶段，基本不会考虑使用，所以就不细分下去了。

[node changelog]: https://github.com/nodejs/node/tree/master/doc/changelogs
[v8 changelog]: https://github.com/v8/v8/blob/master/ChangeLog
