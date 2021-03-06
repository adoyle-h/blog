---
title: '我的 Scrum 实践'
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['Scrum', '敏捷', '团队协作']
categories: ['管理']
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 前言(Intro)

本文将由浅入深介绍 Scrum。其关键组成，优点与缺点，以及个人的一些实践经验。

<!-- more -->

## 什么是 Scrum？
Scrum 是一种敏捷软件开发的方法学，用于迭代式增量软件开发过程。[^1]
Scrum 源于英语，意思是橄榄球运动中争球的意思。
在项目开发中，它强调迅速，自我管理和可适应性。

## 谁会用到 Scrum？
- 产品经理
- 项目经理
- 开发人员
- 测试人员
- 设计人员

即负责这个项目的团队内的所有成员。

## 为什么要用Scrum？
### 反思自己的团队
- 需求不明确？
    - 需求变得太快？
    - 开发速度赶不上提需求的速度？
- 实现功能需要太长时间？
- 进度停滞不前？
    - 不清楚任务卡在哪个地方？
- 修 BUG 多于开发新功能？
- 团队缺乏沟通？
    - 不知道产品目标是什么？
    - 不清楚当前项目进度？
    - 不清楚同伴的进度？
    - 分工不清？

### 我（们）期望怎样的开发？
- 适应变化
- 快速迭代
- 沟通高效
- 执行高效
- 目的明确

## Scrum 特性/优点
- 快速迭代（周期一般为 1~4 个星期）
- 适应变化
    - 双向反馈
- 量化开发
    - 估算需求的投入量
    - 估算团队生产率
- 自我管理
- 进度跟踪
    - 每一个人知道谁负责什么，以及什么时候完成。
- 透明直观

## 进行 Scrum 的前提条件
- 所有参与者都十分了解并认同 Scrum。
- 每位参与者都在项目中积极主动，能做到自我管理，自我约束。
- 不会有人同时参与两个及以上的项目。

## 基本原则
- 自我组织，自我管理
- 沟通至上
- 互相尊重
- 注重实践

## 术语
### Sprint
指一次迭代开发周期。

### 任务积压（Backlog）
一个按优先级排列的需求列表。

- Product Backlog：整个产品生命周期中产生的所有需求
- Sprint Backlog：本次 Sprint 迭代所要做的需求

### 看板(Kanban，Board)
一块团队全员可视的，可操作的，实时更新的任务面板。
用户故事、技术任务、信息资料都作为卡片附加在看板上。

能够可视化地体现任务进度，职责分工等信息。

### 用户故事(User Story)
用户故事来源于用户需求。

用户故事可以通过以下模板进行描述：

`作为一个<角色>, 我想要通过某种<行动>, 以实现我的目的<商业价值>`

由此可见用户故事包括三个要素：

- 角色 => who => 谁要使用这个功能
- 行动 => what => 需要完成什么样的功能
- 目的 => why => 为什么需要这个功能，这个功能带来什么样的价值。

#### 六个特性 - INVEST
一个好的用户故事应该遵循 INVEST 原则。[^2]

INVEST = Independent, Negotiable, Valuable, Estimable, Small, Testable

- 独立性（Independent）
- 可协商性（Negotiable）
- 有价值（Valuable）
- 可以估算性（Estimable）
- 短小（Small）
- 可测试性（Testable）

#### 字段
用户故事一般包含以下几个内容/字段：

- ID：即统一标识符，自增长的数字，以供索引。
- Name：简短的描述性的名称。
- Priority：优先级。由产品经理制定，数值越高越重要。但这只是相对的概念，比如对于重要程度为 1 的来说，2 和 100 的重要程度是一样的。目的只是为了排序。
- Initial estimate：初步估算完成该故事所需的工作量。以`人/月`或`人/天`为基本单位。由开发团队制定。
- Demo：大略描述这个故事应该如何在 Sprint 演示会议上进行演示，其实就是验收测试。
- Notes：注解。相关信息、解释说明和对其它资料的引用等等。

还可以添加其他内容/字段，如：

- Category：故事属于什么分类下。
- Bug tracking ID：如果你有使用 Bug 跟踪系统，那么了解一下故事与 Bug 之间的直接联系就会对你很有帮助。


### 燃烬图(Burndown Chart)
这是一个用于体现剩余工作量的工作图表。由横轴（X）和纵轴（Y）组成，横轴表示时间，纵轴表示工作量。[^3]
这种图表可以直观地体现当前工作进度。
同时，当一次迭代周期结束，可以通过这个图表分析出整体工作效率状态。

### ~~Scrum 扑克~~
开发团队用来评估初始工作量的工具。
个人认为这只会拖慢速度，没什么用，所以不打算介绍。

## 团队组成
**跨职能**，**多角色**的**小**团队，团队小更易管理，人数一般为 3~9 人。

### 角色
- Scrum Master：是执行 Scrum 的带头人，确保团队合理的运作 Scrum，并帮助团队移除实施中的障碍。通常由项目经理扮演。
- 产品负责人：确定产品的方向和愿景，定义产品发布的内容、优先级及交付时间等等。通常由产品经理扮演。
- 开发：技术实现
- 设计：详细设计，出设计稿
- 测试：功能测试，功能验收

## Scrum 流程

整个 Scrum 过程中除了具体开发，主要围绕两个 Backlog 和四个会议。

两个 Backlog 分别为 Product Backlog 和 Sprint Backlog。
四个会议：

- Sprint 计划会议
- 每日站立会议
- Sprint 演示会议
- Sprint 回顾会议

很多时候 Sprint 演示会议是可以省略的，没有必要每次对外进行演示。有时候，演示会和回顾一块进行。

开会也许是许多技术和设计人员最为厌恶的。但是我认为会议可以是有意义的，能够让大家统一目标，分享意见，快速纠错。
然而开会必须要遵守以下几点：

- 开会之前必须通知每个人会议主题、预计用时，提前准备好相关资料让大家预览。
- 明确目的，不跑题，保证对话质量，用最短的时间得到一致的结果。
- 每个会议无论时间长短，都必须有记录、总结，出一份详尽的会议成果。

### 编写 Product Backlog

Product Backlog 是在整个产品生命周期中不断更新的。

#### 目的
- 制定产品功能需求。

#### 参与人员
- 产品负责人，主要负责 Product Backlog 的编写，优先级的指定
- 其他人，负责提意见（非项目团队成员也可以参与进来）

#### 原则
- 只存在一个 Product Backlog。
- 只存在一个产品负责人。
- 每个 Backlog 条目不涉及具体技术实现，只负责描述业务功能或者用户需求。
- Backlog 可以包含用户故事，或者功能 BUG，或者技术改进。
- 产品负责人之外的人也可以向 Product Backlog 中添加故事，但是他们更改/指定优先级。确定优先级是产品负责人独有的权利。他们也不能添加时间估算，这是开发团队独有的权利。
- 产品负责人应当理解每个故事的含义(通常故事都是由他来编写的，但是有的时候其他人也会添加一些请求，产品负责人对它们划分先后次序)。他不需要知道每个故事具体是如何实现的，但必须知道为什么这个故事会放在这里。
- 产品负责人只需要关注业务目标，开发团队指出如何解决问题。

#### 用时
因环境而定。

#### 成果
- 已排序的 Product Backlog。

### Sprint 计划会议
#### 目的
- 为了让团队获得足够的信息，能够在本次 Sprint 内不受干扰地工作。
- 从 Product Backlog 中梳理出本次 Sprint 需要完成的任务，放到 Sprint Backlog 中。
- 确立本次 Sprint 的完成目标，指明奋斗方向。
- 确立本次 Sprint 的参与成员名单。（每次 Sprint 可以人员不一样，但是 Sprint 进行中时最好不要有人员调动）
- 确立 Sprint 截止日期，即确定此次 Sprint 时间长度。（一般为 1~4 周，具体可根据团队生产率计算）
- 确立每日站立会议的时间及地点。（非常重要）

#### 参与人员
- 产品负责人
- 可能跟任务相关的人员

#### 用时
时间较长。可能为 1~5 个小时。因为产品需要叙说各个需求的细节，回复其他人的疑问。

#### 内容

1. 产品负责人对 Sprint 目标进行总体介绍。
    - 按优先级从高到底描述此次 Sprint 需要完成的用户故事。
    - 此时每个用户故事应有较为合理通顺的逻辑，并有原型图等等。
    - 确定 Sprint 截止时间。演示的时间。

2. 开发/设计人员估算时间，以`人/天`为单位进行评估。如果用时过长，最好及时提醒产品负责人。

3. 产品负责人根据情况，拆分 Product Backlog 里的条目。或者修改任务优先级。理清每个条目的含义。

4. 团队选择要放入 Sprint Backlog 中的用户故事。计算生产率，Sprint Backlog 是否到达团队开发的容量上限。

5. 为每日站立会议安排固定的时间地点(如果和上次不同的话)。

#### 成果
- 本次 Sprint 参与成员名单
- Sprint 目标
- Sprint Backlog
- Sprint 截止日期
- 每日站立会议的时间及地点

#### Sprint 计划会议之后

技术主管等负责人将用户故事拆分成具体的技术任务，加到 Sprint Backlog 中，并关联对应的故事。

### 每日站立会议
#### 目的
- 促进交流，鼓励士气
- 尽早提出问题，快速纠错
- 明确每天的目标，明确各自的任务进度

#### 参与人员
- 团队成员

#### 用时
尽可能短时间，控制在 15 分钟以内。

#### 讨论内容
- 对今天应该做什么是否有不明白的地方？
- 是否遇到什么无法独立解决的问题，或者短时间内无法处理的问题？
- 分享一些对于团队可能有帮助的建议或者想法


### Sprint 演示会议

很多时候 Sprint 演示会议是可以省略的，没有必要每次对外进行演示。有时候，演示会和回顾一块进行。

#### 时间
在 Sprint 所有需求完成之后，Sprint 回顾会议之前

演示时间可能很短，十几分钟。交流时间可能很长。

#### 目的
- 验收 Sprint 计划中所提的功能需求

其他额外的效果：

- 让其他人可以了解你的团队在做些什么。
- 团队的成果得到认可。提高团队积极性。
- 演示可以吸引相关干系人的注意,并得到重要反馈。
- 演示迫使团队真正得完成工作。

#### 参与人员
- 团队成员
- 提出需求的用户
- 其他可能对项目感兴趣的人

### Sprint 回顾会议

#### 时间
每一次 Sprint 完成后进行回顾。

根据要讨论的内容范围，可能为 1~4 个小时。

#### 目的
- 分析一次迭代中遇到的问题，踩过的坑，或者需要以后注意的地方（包括技术，流程，团队协作等等问题）
- 促进团队交流

#### 参与人员
- 团队所有成员

#### 内容
- Scrum Master 向大家展示 Sprint Backlog。在团队的帮助下对 Sprint 做总结。包括重要事件和决策等。
- 轮流发言。每个人都有机会在不被人打断的情况下讲出自己的想法，他认为什么是好的，哪些可以做的更好，哪些需要在下次 sprint 中改变。
- 我们对预估生产率和实际生产率进行比较。如果差异比较大的话，我们会分析原因。
- 快结束的时候，Scrum Master 对具体建议进行总结，得出下次 Sprint 需要改进的地方。

#### 成果
- 问题记录与其解决方案
- 未能解决的问题列表
- 用于下次 Sprint 的建议


## Scrum 工具
- [Trello][]
- [Teambition][]
- [Worktile][]
- 纸、马克笔、白板

## 最后（The last but not least）
- 看了这么多，还等什么，立刻行动起来。
- 不能恪守教条，实践是检验真理的唯一标准。
- 团队构成和项目场景的不同，决定了 Scrum 实施方式的不同。所以没有通用的最佳 Scrum 实践，只有快速实践快速试错，走出适用自己的道路。
- Scrum 需要每个人的积极配合参与，否则效率还不如传统迭代开发。所以队友如果不能接受，不要把你的意愿强加给别人。
- 敏捷并不只是“快速开发，快速交付”，更重要的是“快速响应，快速调整”。
- 不要让它成为[官僚主义者的游戏][B2]

## 参考(Bibliographies)
- [《硝烟中的Scrum和XP - 我们如何实施Scrum》，作者: Henrik Kniberg，出版社: infoQ][B1]
- [geniusmart - 《Scrum—官僚者们的游戏》][B2]

## 引用(References)
[^1]: [wikipedia - Scrum][R1]
[^2]: [Scrum 中文网 - 什么是用户故事（User Story）?][R2]
[^3]: [wikipedia - 燃尽图][R3]

<!-- 以下是相关链接 -->

[R1]: https://zh.wikipedia.org/wiki/Scrum
[R2]: http://www.scrumcn.com/agile/scrum/4823.html
[R3]: https://zh.wikipedia.org/wiki/%E7%87%83%E5%B0%BD%E5%9B%BE

[B1]: http://book.douban.com/subject/3390446/
[B2]: http://www.jianshu.com/p/bfb00db24640

[Trello]: http://www.trello.com/
[Teambition]: https://www.teambition.com/
[Worktile]: https://worktile.com/
