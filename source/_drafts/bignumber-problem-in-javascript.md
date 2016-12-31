title: JS 中的大数问题
author: 'ADoyle <adoyle.h@gmail.com>'
tags: []
categories: []
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览(Overview)/前言(Intro)


<!-- more -->


> 浮点数范围：
> 
> as  large  as ±1.7976931348623157 × 10的308次方
> as small as ±5 × 10的−324次方
> 精确整数范围：
> 
> The JavaScript number format allows you to exactly represent all integers between
> −9007199254740992  and 9007199254740992 （即正负2的53次方）
> 数组索引还有位操作：
>
> 正负2的31次方
> -- sunshine1988 [^1]

所以 JS 中的整数什么时候会失去精确度？

```
> umber.MAX_SAFE_INTEGER
9007199254740991

> Number.MAX_VALUE
1.7976931348623157e+308

> Number.MIN_SAFE_INTEGER
-9007199254740991

> Number.MIN_VALUE
5e-324N
```

所以当你比较整数时候，建议使用 `MAX_SAFE_INTEGER`


## 参考(Bibliographies)
- [俊森: JS 的整型你懂了吗？][B1]

## 引用(References)
[^1]: [CNode - 在Javascript中，最大的Number是多少？][R1]


<!-- 以下是相关链接 -->

[R1]: https://cnodejs.org/topic/4fb3722c1975fe1e132b5a9a "备注"

[B1]: http://segmentfault.com/a/1190000002608050 "备注"
