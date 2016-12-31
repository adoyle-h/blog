title: 如何定义 JS 函数的参数
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['JavaScript', '代码风格']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 前言(Intro)

JavaScript 有个不成文的规定，异步函数的回调应该作为函数最后一个参数。然而这有时候会让函数重构变得麻烦。

在 JavaScript 项目中，你也许会看到这样的异步函数定义:

```js
/**
 * 根据 id 获取对应的值
 */
function getSomething(id, options, callback) {
    if (!callback) {
        callback = options;
        options = {};
    }
    // ...
}
```

这个函数看起来挺好的没有任何问题。只不过当某一天需要给这个函数加一个必选参数 `requiredTerm` 时该怎么办？
对于 `options` 这个参数，从语义上来说，它集合了一堆可选参数并且本身就是可选的（所以才有 2~5 行的判断），因此不能把 `requiredTerm` 放到 `options` 里。
那么 `getSomething(id, options, callback, requiredTerm)`？不行，`callback` 应该放在最后。
那么 `getSomething(id, requiredTerm, options, callback)`？这样的话得在函数内部加更多判断，以兼容之前的写法。因为函数在很多地方被调用，一般不会去把所有地方都改一遍，所以只能兼容之前的写法。
那么 `getSomething(params, options, callback)`，params 里放置所有必选参数，与 options 相对应？还是得兼容之前的调用，判断更麻烦了。

综合考虑，当要重构一个函数时，为了兼容之前的写法，你就没法保证让这个函数始终保持简单。除非你事先就考虑过该如何处理这个问题。

我想到一种方案，那就是将除了 callback 的所有参数全都放进一个 object 来进行传参。型如：`function getSomething(params, callback) {}`。

<!-- more -->

## 所有参数都放在一起

### 优点

- 不需要考虑参数顺序
    - 因此新增参数变得非常简单
- 


### 缺点

## 参考(Bibliographies)
- [][B1]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"
