---
title: 单向用户接口架构
author: 'ADoyle <adoyle.h@gmail.com>'
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/copyright)'
tags:
  - 架构
  - 响应式编程
  - FRP
categories:
  - 翻译
  - 技术
  - 前端
date: 2015-11-01 19:46:52
updated:
---



> 本文翻译自[《Unidirectional User Interface Architectures》][origin]

<!-- more -->

这篇文章不全面地概述了所谓的“单向数据流”架构。这不意味着这是一篇初学者教程，可以把它当做一篇对比这些架构差异和特点的概述。在文章最后，我将介绍一个明显不同于它们的新架构。这篇文章只讨论客户端的 Web UI 框架。

## 术语

在没有通用术语的情况下介绍这些架构将会是令人迷惑的，所以让我们假设存在以下术语：

> **用户事件** 是来自于输入设备的，由用户直接产生的事件。例如：鼠标点击，滚动，键盘按键，触摸屏触碰等等。

许多架构也许会使用“视图”（View）这个术语来指代非常不同的含义。相对的，我们使用“渲染视图”[^1]来代表“视图”的通常理解。

> **用户接口渲染视图** 是指屏幕上的图形输出。通常靠 HTML 或者其他类似的高等声明式代码（如 JSX）来表达。

> **用户接口（UI）程序** 是指任何可以捕捉用户事件作为输入，然后输出渲染视图的程序。例如一个持续的进程，而不是一次性的转换。

假定 DOM 和其他例如框架和类库的层次默认存在于用户和架构之间。

> **模块间箭头的所有权。**`A--> B` 不同于 `A -->B`。前者是被动编程（Passive Programming），而后者是响应式编程。更多参见[这里](http://cycle.js.org/observables.html#reactive-programming)

> 如果子组件的结构和框架整体结构是相同的，这个单向架构就被称为是**分形的**。

在分形架构中，整个框架能被包装成一个组件，用于规模更庞大的应用中。

在非分形架构中，对于那些在具有层次结构的部分之上的，不可重复的部分被称为**编排者**。

## FLUX

第一个必须介绍的是 [Flux][]。虽然它不能说是绝对的原创，但是至少根据流行度，对于许多人而言它是第一个单向的架构。

**构成：**
  - **Store**：管理业务数据和状态
  - **View**：一个由 React 组件构成的层次结构
  - **Action**：从 View 触发的用户事件中创建的事件
  - **Dispatcher**：一个用于分发所有 action 的事件总线

![flux-unidir-ui-arch](http://ww2.sinaimg.cn/large/006aQyYMgw1exkfo4alh3j30zk0qoabw.jpg)

**特性：**

**调度器（Dispatcher）。** 因为这是个事件总线，所以它是单件（Singleton）的。许多 Flux 变体移除了调度器的需求，而且其他单向架构中也没有类似于调度器的东西。

**只有 View 拥有可组合的组件。** 层次结构只出现在 React 组件中，Store 和 Action 都不会出现这种结构。React 组件是一个 UI 程序，通常不作为 Flux 内部架构来详细讨论。因此 Flux 不是分形的，编排者是 Dispatcher 和 Store。

**用户事件处理器在渲染视图里声明。** 换句话说，React 组件的 `render()` 函数既指挥用户（渲染视图）交互，也处理用户事件（比如 `onClick={this.clickHandler}`）。

## REDUX

[Redux][] 是一个 Flux 的变体，其调度器被改为一个单件的 Store。这个 Store 起初没有被实现，相对的，需要给出一个 reducer 函数作为 Store 的工厂函数用来产生这个 Store。

**构成：**
  - **单件 Store**：管理状态，并且有一个 `dispatch(action)` 函数
  - **Provider**：Store 的订阅者，与一些如 React、Angular 这样的“视图层”框架进行交互
  - **Actions**：由 Provider 引发的用户事件创建的事件
  - **Reducers**：把一个 action 和上一个状态转换到新状态的纯函数

![redux-unidir-ui-arch](http://ww2.sinaimg.cn/large/006aQyYMgw1exkfosh8aej30zk0qogni.jpg)

**特性：**

**Store 工厂。** 一个 Store 是通过 `createStore()` 工厂函数，接受一系列 reducer 函数作为参数创建的。这也有一个元数据工厂函数 `applyMiddleware()`，它接受中间件函数作为参数。中间件是一种使用附加链式函数来重载 store 的 `dispatch()` 函数的机制。

**Providers。** Redux 在构建 UI 程序时是与“视图层”框架松耦合的。Provider 能被 React、Angular 或者其他框架使用。在这个架构中，“视图”是一个 UI 程序。和 Flux 一样，Redux （根据设计）也不是分形的，而 Store 是编排者。

**用户事件处理器可能会也可能不会声明在渲染视图。** 这依赖于 Provider 的处理。

## BEST

[Famous 架构][Famous Framework]介绍了一种 MVC 的变体：BEST[^2]。MVC 的控制器（Controller）被分为两种单向元素：Behavior 和 Event。

**构成：**
  - **State**: 类似于 JSON 的声明，用于初始化状态
  - **Tree**: 一个声明式的由组件构成的层次结构
  - **Event**: 改变状态的事件监听器（附加在 Tree 上）
  - **Behavior**: 根据状态变化的 Tree 的动态属性

![best-unidir-ui-arch](http://ww1.sinaimg.cn/large/006aQyYMgw1exkfnanz73j30zk0qowgi.jpg)

**特性：**

**多范式。** State 和 Tree 完全是声明式的。Event 是命令式的。Behavior 是函数式的。有些部分是响应式的，其他部分是被动式的。（例如，Behavior 响应了 State，Tree 被动于 Behavior）

**Behavior。** 本文提到的其他架构中都没有这个概念，Behavior 把 UI 渲染视图（即 Tree）从它的动态属性里分离了出来。据宣称这是不同的概念：Tree 相对于 HTML，Behavior 相对于 CSS。

**用户事件处理器的声明独立于渲染视图。** BEST 是少有的一个不在渲染视图附加用户事件处理器的单向架构。用户事件处理器属于 Event，不属于 Tree。

在这个架构中，“视图层”就是 Tree，“组件”是一个 BEST 元组，它个是 UI 程序。BEST 是一个分形架构。

## MODEL-VIEW-UPDATE

它也被称为 [Elm 架构][Elm Arch]，Model-View-Update（以下简称 MVU）与 Redux 类似，主要是因为后者是从这个架构中获得启发的。这是一个纯函数架构，因为它使用了 [Elm][Elm]，这是个应用于 Web 的函数式编程语言。

**构成：**
  - **Model**: 一种定义了状态数据结构的类型
  - **View**: 一种转变状态到渲染视图的纯函数
  - **Actions**: 一种定义了通过信箱发送用户事件的类型
  - **Update**: 一种把一个 action 和之前状态转变为新状态的纯函数

![mvu-unidir-ui-arch](http://ww1.sinaimg.cn/large/006aQyYMgw1exkfolzorrj30zk0qojtt.jpg)

**特性：**

**层次结构无处不在。** 在之前的架构中层次结构只存在于“视图层”，然而在这个 MVU 架构中，这样的结构也存在于 Model 和 Update。甚至 Action 也可以嵌套包含 Action。

**组件分离成多个元素。** 因为层次结构无所不在，“组件”在 Elm 架构中是一个元组，其组成元素是：Model 类型，Model 初始实例，View 函数，Action 类型，以及 Update 函数。在整个架构中组件不能偏离这样的结构。每个组件是一个 UI 程序，并且架构是分形的。

## MODEL-VIEW-INTENT

作为一个基于 [RxJS][] 的 Observable[^3] 实现的完全响应式的单向架构，Model-View-Intent（以下简称 MVI） 同时也是 [Cycle.js][] 框架的主要架构模式。_可观测的_事件流，以及基于 Observable 的函数遍布于这个框架的每个地方。

**构成：**
  - **Intent**: 一种函数，用于把用户事件 Observable 转换成 action Observable
  - **Model**: 一种函数，用于把 action Observable 转换成状态 Observable
  - **View**: 一种函数，用于把状态 Observable 转换成渲染视图 Observable
  - **Custom element**: 渲染视图中可作为 UI 程序的部分。它可以实现成 MVI，或者 web 组件。对于 View 是可选的。

![mvi-unidir-ui-arch](http://ww1.sinaimg.cn/large/006aQyYMgw1exkfobq326j30zk0qo407.jpg)

**特性：**

**重度依赖 Observable。** 架构每一部分的输出都被处理成一个可观察的事件流。因此，如果没有 Observable，将会很难表示“数据流”和“变化”。

**Intent。** 大致上可以跟 BEST 的 _Event_ 相比较，用户事件处理器在 Intent 中声明，独立于渲染视图。不像 BEST，Intent 产生 action Observable 流，这很类似于 Flux，Redux 以及 Elm。但仍有不同于 Flux 及其他框架的地方，MVI 的 action 不直接传递给 Dispatcher 或者 Store。它们只是被其所监听的 Model 简单地调用。

**完全响应式的。** 用户渲染视图响应了 View 的输出，而 View 又响应了 Model 的输出，Model 又响应了 Intent 的输出（即 action），Intent 又响应了用户事件。

MVI 元组是一个 UI 程序。只有当所有自定义元素是用 MVI 实现时，这个架构才是分形的。

## NESTED DIALOGUES

本文将介绍一个全新的单向架构：嵌套对话（NESTED DIALOGUE）。它目前主要应用于 [Cycle.js][]，而其他具体实现也必须完全基于 Observable。它是 MVI 架构的衍生品。

MVI 序列可以被函数化组合成的一个独立的函数，也就是“对话”（Dialogue）:

![dialogue-mvi-unidir-ui-arch](http://ww2.sinaimg.cn/large/006aQyYMgw1exkfnqbd1vj30zk0qot9w.jpg)

如图所示，**对话**是一个函数，它接受一个用户事件的 Observable 作为输入（Intent 的输入），并且输出一个渲染视图的 Observable（View 的输出）。因此对话是一个 UI 程序。

我们可以扩展对话的定义，允许用户之外的其他目标，只要每个目标有一个 Observable 输入和 Observable 输出。例如，如果有一个通过 HTTP 连接用户和服务器的对话接口，这个对话将接受两个 Observable 作为输入，即用户事件的 Observable 和 HTTP 响应的 Observable。然后它会输出两个 Observable，即渲染视图 Observable 和 HTTP 请求 Observable。这个概念出自 Cycle.js 的 [Drivers](http://cycle.js.org/drivers.html)。

将 MVI 重构成一个对话将会是这样：

![single-dialogue-unidir-ui-arch](http://ww4.sinaimg.cn/large/006aQyYMgw1exkfoyv3vqj30zk0qomyi.jpg)

为了在更庞大的程序中重用对话函数，并把它作为 UI 程序的子组件，关键在于将对话各自嵌套：

![nested-dialogues-unidir-ui-arch](http://ww4.sinaimg.cn/large/006aQyYMgw1exkfp5k0ybj30zk0qo40b.jpg)

这些在不同对话层次的 Observable 连线是一个数据流图。它不必是个无环图。也存在一些情况，比如子组件中的动态列表在数据流图中是一定存在环的。具体例子不在本文讨论范围内。

嵌套对话实际上是一个元架构（meta-architecture）：它对于组件的内部结构没有要求，允许我们将上述任何一个架构加入到一个嵌套的对话组件中。唯一的约束是对话的两端接口：输入端必须是一个（或一系列）Observable，输出端也如此。如果一个 UI 程序是 Flux 或者 MVU 结构，或者其他能够将输入输出由 Observable 表示的结构，那么这个 UI 程序就能够嵌入到嵌套对话中，成为一个对话函数。

这个架构因此是分形的（只需考虑对话接口）并且通用的。

See this [TodoMVC implementation](https://github.com/cyclejs/todomvc-cycle) and [this small app](https://github.com/cyclejs/cycle-examples/tree/master/bmi-nested) as examples of Nested Dialogues with Cycle.js.

查看它在 [TodoMVC 的实现][todomvc]，还有这个[小程序][2]作为 Cycle.js 的嵌套对话示例。

## 带有个人偏见的总结

尽管嵌套对话的优雅设计与通用性在理论上能够将其他架构作为子组件嵌套使用，我主要还是对 Cycle.js 应用的架构组织更感兴趣。我正在寻找一个感觉**自然**、**灵活**并且同样结构的 UI 架构，

我相信嵌套对话是很_自然的_，因为它直接表达了 UI 程序在做什么：一个持续的进程（就是 Observable），它接受用户事件作为输入（即输入 Observable），还产生渲染视图作为输出（即输出 Observable）。

它也自然是个_灵活的_架构，因为正如我们所见，对话的内部架构能够自由地用任何模式实现。这就是它与 MVU 的差异，后者约定了严固的结构。分形架构比非分形的更可重用，我很高兴内嵌对话也有这种属性。

然而，一些通用的_结构_有利于引导开发过程。尽管我相信对话的内部结构应该是 Flux，但我想 MVI 本质上更适合于 Observable 的输入/输出接口。于是尽管我想要不使用 MVI 来实现对话，不得不承认大部分时间自己还是把它当做 MVI 来架构。

我不打算自命不凡地说它是最好的用户接口架构，因为我还在探索它，并且仍然需要在更多地方尝试以便比较它的优劣。只不过在现阶段嵌套对话是我最有自信的赌注。


## 译者注
[^1]: 原文是“rendering”。若译成“渲染”的话，会当成一个动词，“渲染视图”比较贴近上下文。
[^2]: 关于 BEST 的文章，我翻译了原文，详见[这篇][BEST 翻译]
[^3]: Observable，意为“可观察对象”。个人感觉五个字太长了，而且在响应式编程中 Observable 的概念已经十分普及。所以就不翻译了。


<!-- 以下是相关链接 -->

[origin]: http://staltz.com/unidirectional-user-interface-architectures.html
[Flux]: https://github.com/facebook/flux/
[Redux]: http://rackt.github.io/redux/
[Famous Framework]: https://blog.famous.org/introducing-the-famous-framework/
[Elm]: http://elm-lang.org/
[Elm Arch]: https://github.com/evancz/elm-architecture-tutorial/
[RxJS]: https://github.com/Reactive-Extensions/RxJS
[Cycle.js]: http://cycle.js.org/
[todomvc]: https://github.com/cyclejs/todomvc-cycle
[BEST 翻译]: http://adoyle.me/blog/meet-best.html
[2]: https://github.com/cyclejs/cycle-examples/tree/master/bmi-nested
