---
title: 告别 'use-strict'
author: ADoyle <adoyle.h@gmail.com>
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/copyright)'
tags: ['NodeJS']
categories: ['技术']
date: 2016-09-17 13:43:38
updated: 2018-02-25 23:09:01
---



## 概览 (Overview)

~~结论：如果你使用的 node 版本 >= 2.0.0，可以不必再在每个文件头写 `'use-strict';`，因为 node 已经默认开启 strict 模式。~~

------- 2018-02-25 updated -------

很抱歉，并不是。截至 node v9.6.1，node 都没有默认开启 strict 模式，详见[node 源码][0]。
对于 node 来说，执行 `node --use_strict` 才会生效 `implicit strict mode`，你可以通过 `node --v8-options` 找到这个 `--use_strict` 选项。
但是 `--use_strict` 不建议你使用，具体原因见下文。

所以下文所说的部分内容，是不对的。
我做了对应的修正，另外下文还是默认以 node 8 为背景叙事，用到 node 9 的地方我会提示的。

结论：
在 node 端，你最好在每个文件头加上 `'use-strict'`，并且不要使用 `node --use-strict` 选项；
在浏览器端，如果你使用的是 `<script type="module">`，则默认开启了 strict 模式，否则也还是要加 `'use-strict'` 的（不过一般有前端工具帮你处理这事）。

------- 2018-02-25 updated end -------

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

------- 2018-02-25 updated -------

## 你在瞎说

某天我使用了 `Object.freeze` 这个方法，但是没有触发异常，这引起我的警觉。

先来看几个例子，

例1.1:

```js
// a.js
const object1 = {
    property1: 42
};

const object2 = Object.freeze(object1);

object2.property1 = 33;

console.log(object2.property1);
```

注意这段代码没有加 `'use strict'`。
当我执行这段代码 `node a.js`，发现会正常输出 42。而不像规范里说的在严格模式会抛错。
当加了 `'use strict'`，执行才会报错：`TypeError: Cannot assign to read only property 'property1' of object '#<Object>'`。


例1.2:

```js
// b.js
const object1 = {
    property1: 42
};

const object2 = Object.freeze(object1);

object2.property1 = 33;

console.log(object2.property1);
```

```js
// c.js
'use strict';
require('./b');
```

执行 `node c.js`，正常输出 42，对于 b 来说，c 的 `'use strict'` 并不会影响 b 的行为。

所以我去看了 ES2015 的定义和 node 源码实现，发现了几点事实。

截至 node v9.6.1，node 都没有默认开启 strict 模式，详见[node 源码][0]。
对于 node 来说，执行 `node --use_strict` 才会生效 `implicit strict mode`，你可以通过 `node --v8-options` 找到这个 `--use_strict` 选项。

### NodeJS 为什么这么做？

> In the ES6 specification, there are two modes in which a file can be processed:
>
> As a "script" which would generally be everything we are accustomed to in a standard JS environment
>
> ES6 module syntax is not allowed, and for backward-compatibility reasons, content is only treated as strict if it has a prefix directive of "use strict";.
> As a "module"
>
> ES6 module syntax is allowed, and all code is automatically strict mode in all cases.

参考自 https://stackoverflow.com/a/34368143/4622308 和 [node/issues/6429](https://github.com/nodejs/node/issues/6429) 讨论的，node 团队为了向后兼容，以免破坏整个生态链。

### 全局 strict 与模块级别的 strict

对于例1.2 的情况，c 的 `'use strict'` 并不会影响 b 的行为。

而当 `node --use_strict c.js`时，b 会报错。其实无关 c.js 里有没有加 `'use strict'`，b 都会报错。

**所以使用 `node --use_strict` 会使所有执行的 JS 代码都以严格模式运行，包括你所引用的第三方库。**
**你需要慎重使用 `--use_strict`**

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

### Class 里的内容都是严格模式

`All parts of a ClassDeclaration or a ClassExpression are strict mode code.` 这段话是挺重要的，说明 class 声明下都是 strict mode。
来验证一下，把上面那段代码改写成这样：

例1.3:

```js
// a.js
class A {
    f() {
        const object1 = {
            property1: 42
        };

        const object2 = Object.freeze(object1);

        object2.property1 = 33;

        console.log(object2.property1);
    }
}

const a = new A;
a.f();
```

执行发现是会报错的，即在 class 声明里默认使用了严格模式。

### 什么是符合 ECMAScript 2015 规范的 Module ?

对于 `Module code is always strict mode code` 这句话，`Module` 是关键，详见 [ES2015 Module 定义](http://www.ecma-international.org/ecma-262/6.0/#sec-modules)。

因为截至 node 8.x 都没实现 import/export 功能，而在 node 9 里提供了 `--experimental-modules` 来支持 import/export 功能，应该是实现了 ES2015 里定义的 `Module` 吧，你可以在 `node -h` 里找到这个选项。

来验证一下，切到 node 9，使用 `node --experimental-modules a.js` 执行例1.1，你会发现还是没报错，正常输出 42。所以我认为 node 9 --experimental-modules 同样没有完整实现 `Module` 的定义，只是实现了 import/export 语法功能。

## 浏览器端的行为

### chrome devtools

打开 chrome devtools，执行例1.1 的代码会发现没有使用严格模式。

### 页面 script 标签

例1.4，

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width" />
    <title>Index</title>
  </head>
  <body>
    body
    <script charset="utf-8" type="text/javascript">
      const object1 = {
        property1: 42
      };

      const object2 = Object.freeze(object1);

      object2.property1 = 33;

      console.log(object2.property1);
    </script>
  </body>
</html>
```

正常输出 42，没有使用严格模式。这是正常情况，因为浏览器里要使用 `<script type="module">` 才会被视作 ES2015 Module。

例1.5，

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width" />
    <title>Index</title>
  </head>
  <body>
    body
    <script charset="utf-8" type="module">
      const object1 = {
        property1: 42
      };

      const object2 = Object.freeze(object1);

      object2.property1 = 33;

      console.log(object2.property1);
    </script>
  </body>
</html>
```

报错了，启用了严格模式。

其他具体条件我就不一一校验了。结论已经写在了开头。

------- 2018-02-25 updated end -------

[node changelog]: https://github.com/nodejs/node/tree/master/doc/changelogs
[v8 changelog]: https://github.com/v8/v8/blob/master/ChangeLog
[ES5 的语法]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode
[0]: https://github.com/nodejs/node/blob/v9.6.1/deps/v8/src/flag-definitions.h#L183
