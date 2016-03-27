---
title: 《介绍 Famous 框架》之《相遇 BEST》
author: 'ADoyle <adoyle.h@gmail.com>'
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/copyright)'
tags:
  - 框架
  - 响应式编程
categories:
  - 翻译
  - 技术
  - 前端
date: 2015-11-01 19:44:24
updated:
---


> 本文节选翻译自[《Introducing the Famous Framework》][origin]的“Meet BEST”部分

<!-- more -->


### 相遇 BEST

我们想出了 BEST（B：行为，E：事件，S：状态，T：树）。BEST 是一个新的架构模式，为了构建可重用的，可替换的组件，无论组件是独立的还是宏观的，其表现都是可预测的。我们的框架是 BEST 的一个具体实现。

![](http://ww2.sinaimg.cn/large/006aQyYMgw1exk5p4ko6kj31kw0vr78z.jpg)

你可以把 BEST 想象成一个事件驱动的 MVC 的衍生品。MVC 提供了用来管理状态和持久化的模型，用来向用户表现状态并且收集输入的视图，以及一个用来代理交互并连接模型和视图逻辑的控制器。如下图所示：

![](http://ww4.sinaimg.cn/large/006aQyYMgw1exk5q0k5onj31kw0vw40d.jpg)

数十年来 MVC 被各种语言用各种方式来创造软件。尽管这些年 MVC 在许多项目中获得巨大成功，它也有许多公认的痛点，如 [0](https://weblogs.java.net/blog/editor/archive/2009/11/05/eric-spiegelberg-avoiding-mvc-controller-bloat) [1](http://stackoverflow.com/questions/5193368/keeping-asp-net-mvc-controller-size-down) [2](http://www.sitepoint.com/mvc-problem-solution/) [3](http://typicalprogrammer.com/php-mvc-maintenance-very-costly/) [4](https://www.airpair.com/angularjs/posts/top-10-mistakes-angularjs-developers-make#4-controller-bloat)。

这些痛点许多都是关于控制器的，这个 MVC 里常常蓬头垢面的中间人。一个通常的 MVC 的场景，状态从模型中被带到控制器里，它在控制器里产生一份拷贝，然后被发送给了视图。用户也许会改变这个状态（比如，填写表单），于是这个状态又被返回给控制器。控制器也许要存储这份状态的另一份拷贝，有可能因此影响到应用状态的其他部分（比如，登陆一个用户，向购物车中增加订单）。控制器可能会也可能不会发送这个状态给模型进行持久化——它依赖于具体业务实现。

假设一个应用有着 20 个程序员和 100 个正在开发的新特性，想象一下代码将如何编排。或者更好的是，不用想象，只需看一看任何使用 MVC 艰难战斗着的代码库。控制器通常承担着不可避免的复杂性的冲击——同步并管理每个不同版本的状态，并且这些状态在许多功能中互相依赖。**而且**这些状态往返于模型和视图之间会让复杂度直线上涨。

因此控制器是 BEST 不同于 MVC 的关键。**事实上，你可以将 BEST 想象成一个事件驱动的 MVC 的变体。它将控制器输入输出的职责分离成两个概念：行为和事件**

![](http://ww4.sinaimg.cn/large/006aQyYMgw1exk5nil20yj31kw0vqgqc.jpg)

### 例子

让我们通过一个简单的例子过一遍 BEST。

**树：** 从树开始讲解是最简单的，因为你非常熟悉它并且它表现非常直观。它是组件的**层级结构**，并且使用 **HTML** 书写。这是我们喜欢网络语言语义的原因之一。HTML 擅于表现 UI 的层级结构，它已在网络中被广泛地使用这一特性。

这是一个树的例子，混合使用了原生 HTML（div 标签）：

```
tree: `
    <node id="square">
        <div></div>
    </node>
`
```

这棵树是一个无关逻辑的 UI 骨架。

**事件：** 事件是你收集应用逻辑中的数据的地方。例如，`点击时，x 增加 1` 或者 `数据加载时，把从服务端接受的数据更新到推特数组，并且把 isLoading 设置为 false`。事件是我们使用 JavaScript 编程的关键。

所有应用状态的变动发生在事件处理器内部，并且事件处理器能够人为地排除其他事件。它们非常类似于面向对象系统中的*方法*，只不过这些处理器是被事件触发而非直接调用的。

利用另一个 JavaScript 和 CSS 的类似特性：**选择器**，事件能够被附加到树的元素上。选择器让事件和树在各自分离的情况下维系在一起，正如传统 web 开发中允许 CSS 和 HTML 在各自分离的情况下维系在一起一样。

在上面的例子中，选择器 `#square` 允许我们使用 id 来定位节点，于是我们声明事件来把它像这样附到节点上：

```js
events: {
    '#square': {
        'click': function($state) {
            $state.set('numberOfClicks', 1 + $state.get('numberOfClicks'));
        }
    }
}
```

组件状态通过状态管理器来管理，就是上面例子中的 `$state` 变量。为什么需要状态管理器？部分原因是因为它允许我们在事件和状态之间用另一种独立的概念进行管理。


**状态：** 状态是你的组件中的内部数据和设置。不像 MVC 模型，通常有大量的 getter/setter 用于数据查询和持久化的逻辑。BEST 状态是严格声明的，且无关逻辑的。也就是说，一个组件的状态总是可以用 JSON 进行无损地序列化和反序列化。这是我们赞扬 JavaScript **状态化的**并且**声明式的**的地方。

```js
states: {
    numberOfClicks: 0
}
```

在上面的事件例子中，当我们增加 `numberOfClicks` 变量的值，它同样更新这个定义在这的初始为 0 的 `numberOfClicks` 变量。

**行为：** 行为连接状态和树，完成整个循环。行为是函数，可以理解为函数式编程——这是 Haskell 灵感闪耀之处。它们不只是函数，它们还是状态映射，可以理解为函数 `f(x)` 是一个“x 的映射”。我们使用依赖注入将**状态名字**设置到**行为函数的参数**—— `numberOfStates` 作为一个数组参数注入到行为函数中，如 `function(numberOfStates)`。

如同事件，行为也可以使用选择器附加到树的元素上。行为较之事件更像 CSS。一种想法认为行为是“函数化的 CSS”，并且实际上这就是我们认为的 JavaScript 中的函数化。例如：

```js
behaviors: {
    '#square': {
        'rotation-z': function(numberOfClicks) {
            return numberOfClicks * Math.PI / 2;
        }
    },
    'div' : {
        'background-color': 'red',
        'text-content': function(numberOfClicks){
            return numberOfClicks + " clicks!";
        }
    }
}
```

在这个例子中，在 `square` 被点击前，`square` 的 `rotation-z` 会等于 `0 * Math.PI / 2`，即 `0`。当用户点击了 `#square` 元素，事件处理器“click”会被触发，`div` 的 `text-content` 会变成 `0 click!`。事件处理器更新了 `numberOfClicks` 状态，这会自动引发行为函数重新进行计算。`#square` 的 `rotation-z` 会对应变成 `1 * Math.PI / 2`，`div` 中的内容也会相应地更新成 "1 clicks!"，然后整个循环就完成了。


<!-- 以下是相关链接 -->

[origin]: https://blog.famous.org/introducing-the-famous-framework/
[0]: https://en.wikipedia.org/wiki/Turtles_all_the_way_down