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

结论：~~如果你使用的 node 版本 >= 2.0.0，可以不必再在每个文件头写 `'use-strict';`，因为 node 已经默认开启 strict 模式。~~

[2017/07/12 updated]

很抱歉，并不是。截至 node v8.1.4，node 都没有默认开启 strict 模式，详见[node 源码][0]。

[2017/07/12 updated-end]

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

## 有问题？

然而，你可能会遇到 `Block-scoped declarations (let, const, function, class) not yet supported outside strict mode` 这样的报错。

这是因为 node (v4) 的 `implicit strict mode` 只实现了 [ES5 的语法][]，并没有实现到 ES6。所以当你用到 `let`、`const` 等关键字，还是需要手动加上 `'use strict';`。

-----

[2017/07/12 updated]

## ECMAScript 2015

[10.2.1 Strict Mode Code](http://www.ecma-international.org/ecma-262/6.0/#sec-strict-mode-code)

> An ECMAScript Script syntactic unit may be processed using either unrestricted or strict mode syntax and semantics. Code is interpreted as strict mode code in the following situations:
>
> Global code is strict mode code if it begins with a Directive Prologue that contains a Use Strict Directive (see 14.1.1).
> Module code is always strict mode code.
> All parts of a ClassDeclaration or a ClassExpression are strict mode code.
> Eval code is strict mode code if it begins with a Directive Prologue that contains a Use Strict Directive or if the call to eval is a direct eval (see 12.3.4.1) that is contained in strict mode code.
> Function code is strict mode code if the associated FunctionDeclaration, FunctionExpression, GeneratorDeclaration, GeneratorExpression, MethodDefinition, or ArrowFunction is contained in strict mode code or if the code that produces the value of the function’s [[ECMAScriptCode]] internal slot begins with a Directive Prologue that contains a Use Strict Directive.
> Function code that is supplied as the arguments to the built-in Function and Generator constructors is strict mode code if the last argument is a String that when processed is a FunctionBody that begins with a Directive Prologue that contains a Use Strict Directive.
> ECMAScript code that is not strict mode code is called non-strict code.

对于 `Module code is always strict mode code` 这句话，如何定义 `Module` 是关键。

## 什么是符合 ECMAScript 2015 规范的 Module ?

## 浏览器端

## NodeJS

> In the ES6 specification, there are two modes in which a file can be processed:
>
> As a "script" which would generally be everything we are accustomed to in a standard JS environment
>
> ES6 module syntax is not allowed, and for backward-compatibility reasons, content is only treated as strict if it has a prefix directive of "use strict";.
> As a "module"
>
> ES6 module syntax is allowed, and all code is automatically strict mode in all cases.

https://stackoverflow.com/a/34368143/4622308

通过 `node --v8-options` 可以看到 `--use_strict (enforce strict mode)` 这个选项。
然而截至 node v8.1.4，node 都没有默认开启 strict 模式，详见[node 源码][0]。

全局 strict 与模块级别的 strict:

使用 `node --use_strict` 会使所有执行的 JS 代码都以严格模式运行，包括你所引用的第三方库。

正如 [node/issues/6429](https://github.com/nodejs/node/issues/6429) 讨论的，node 团队为了向后兼容


[2017/07/12 updated-end]

[node changelog]: https://github.com/nodejs/node/tree/master/doc/changelogs
[v8 changelog]: https://github.com/v8/v8/blob/master/ChangeLog
[ES5 的语法]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode
[0]: https://github.com/nodejs/node/blob/v8.1.4/deps/v8/src/flag-definitions.h#L183
