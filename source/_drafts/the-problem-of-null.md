---
title: Null Object 与 Null
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['代码风格']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 概览(Overview)/前言(Intro)


<!-- more -->


输入 id 如果找不到对象，则 `return callback('找不到对象!')`。但是这真的好吗？


对于处理非理想的返回值，一般有以下几个方案：

  1. 抛出异常(throw error形式)
  2. 抛出异常(callback形式)
  3. 返回null
  4. 返回空数组或空对象。或者实现了某些接口的空对象。也就是所谓的[Null Object模式](http://en.wikipedia.org/wiki/Null_Object_pattern)

我比较倾向于第4种。而且[代码整洁之道](http://book.douban.com/subject/4199741/)中作者就明确提出不应该返回null，应该使用空对象。

原因有这么几点：

  1. 对于方案1：这样你就必须写try/catch去捕捉异常，有时候try/catch得写好多层，因为你的错误可能需要不同层级的处理方式。我们也知道，try/catch的效率是挺低的，应该尽量避免使用。
  2. 对于方案2：这样你就必须去判断error存不存在，甚至可能导致每一层都要对error进行处理。（所以TJ大神就领导人民使用generator，虽然他最后还是弃坑了…）
  3. 对于方案3：假如你是java或C++开发者，你会发现代码里会写很多判断对象是否存在的语句，这样使得代码看起来很累赘，甚至会导致代码复杂化。同时也让开发者不能专注于业务代码的编写（因为都去做容错处理了）。
  4. 对于方案4：我暂时没找到缺点。优点却有很多： 
    * 你可以无所顾忌地使用链式(chain)语法。
    * 你不必去手动判断null和error了！
    * 你不必去写if () ... else ...嵌套了！

觉得我说的不好？看看别人是怎么说的吧，参考：

  * [ST - Is returning null bad design?](http://stackoverflow.com/questions/1274792/is-returning-null-bad-design/1274822#1274822)
  * [Wikipedia - Null Object pattern](http://en.wikipedia.org/wiki/Null_Object_pattern)

懒得看英文？那就放一篇中文的吧，参考：

  * [SF - java如不想么每次都判空 if(o !=null) 怎么做？](http://segmentfault.com/q/1010000000114775)

空对象返回用{}取代null比较好，实在需要判断是否为空的话，可以用[isEmpty](http://www.css88.com/doc/underscore/#isEmpty)这样的函数。

这样即可以是Null Object，也可以用类似判断null的方法。一举两得。
因为在获取对象的属性时，很可能会发生NullPointerException错误，而返回空对象就可以有效避免。

还能节省代码：

  * 如果obj存在，你还是得在调用obj.key1.key2前判断obj.key1。
  * 如果obj为null，的确是不用做什么操作。
  * 如果obj为{}，1里写带判断代码都已经有了，那肯定也不会有问题。

所以如果obj返回null，相对与返回{}，不是徒增了判断的代码么？

所以，不要 return null;


## 参考(Bibliographies)
- [][B1]


## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"
