---
title: about-work
author: 'ADoyle <adoyle.h@gmail.com>'
tags: []
categories: []
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 概览(Overview)/前言(Intro)


<!-- more -->

## 前提
在讨论问题之前，我想先陈述并默认以下几点**前提**：
1. 永远存在BUG，并且永远处理不完。

## 建议
### 1. 深入理解Git Flow
我觉得公司目前的Git Flow用得不是太好。建议审慎思考[git flow](http://nvie.com/posts/a-successful-git-branching-model/)的意义，然后开发出**适合公司的git flow**。

为了明确表达我的意图，请耐心看我对git flow的理解：

##### master分支
代表了生产环境。一旦在此分支上创建新提交，就是一次release，打上Tag。
master分支上只有两种行为：
1. 从release分支上合并而创建新提交。
2. 从hotfix分支上合并而创建新提交。

第一点意为不能直接从develop发布到master分支，要走develop -> release -> master的流程。原因见release分支。

##### develop分支
代表开发环境。只做两件事情：
1. 从develop分支建立出新的`Support分支`。
2. 接受来自`Supporting分支`的合并。

`Supporting分支`在`目前的git flow`中有以下这些：
##### feature分支
代表一个新特性/需求的开发。一旦feature分支合入develop意味着特性开发的完成。不管是否有BUG，只要合入就算完成特性开发。因为`前提1`，所以要改BUG可以在这之后新建`Supporting分支`处理。


##### release分支
主要有两个作用：
1. 作为一个可用于生产环境的发布/待发布版本。
2. 若作为待发布版本的分支，可在**这个分支**上修正bug（开发方式与develop一样），并为发布版本准备元数据（版本号、构建日期等等）。

几点重要之处：
1. 一个release分支代表了一次发布。
2. release分支一旦创建，即便合并到master分支以后，也**永远存在**。
3. master分支相当于在各个release分支上切换的浮标，master分支代表着当前生产环境所处的release版本。
4. 那么tag有什么用？tag是作为release的中间过程的浮标，比如最新为1.1.2版本的release分支上有着1.0.0，1.1.0，1.1.1，1.1.2等tag。tag也作为不同release的标记，如1.0.0和2.0.0。通过tag可快速切换到想要的提交。

##### hotfix分支
它是为了处理这样的问题：
生产环境的release版本处于一个不预期状态，需要立即修正。

两点重要之处：
1. hotfix只关注于生产环境上的出现问题，而非开发环境。
2. 并不是生成环境上出现的所有问题，都需要立刻使用hotfix分支修复。而是修复**不容忽视、急需处理的问题**。因为`前提1`的存在。

hotfix处理完成之后，**同时**合并到develop和master分支上，**并且更新相关的release分支**，代表修复完成。


#### 增强Git Flow
关于`Supporting分支`，原作者在[它的文章](http://nvie.com/posts/a-successful-git-branching-model/)中写道
> The branch types are categorized by how we use them.

所以Supporting分支的存在，因人而异，你可以用不到，你也可以根据自己的使用目的创建新的Supporting类型。
所以我提出以下几个分支：

##### fix分支
因为feature分支是用来开发特性的，用它来修BUG的话，从语义上说不通。又因为hotfix只用于修复生产环境的紧急BUG。对于普通的BUG来说用不到hotfix。因此才有了fix分支。

fix分支关注开发环境的问题，同时也关注来自生产环境的问题（即非hotfix所需解决的问题）。
它的开发方式和feature分支一样，从develop创建，到合并入develop结束。



### 2. 让开发环境和生产环境的进度保持差距
尽管客户(老板)想立刻就看到效果，我也依然不建议“develop一更新，master就更新”的这种做法。

master应该是**稳定的**分支。这个稳定不仅指的是“不会报错”，同时还指功能上的稳定，不会频繁变动同一个地方/功能。发布在master上的代码，都应该是经过审慎思考才最终决定了的，除了hotfix。

develop应该领先master一些feature或fix（具体数量由你控制）。这样就有反思的余韵，后悔的余地。从而尽量减少hotfix的创建。

这样的话，每次发布一个版本，就可以列出一个change列表。这次release发布了哪些新功能，修复了哪些BUG。
这个列表会起到**振奋人心**的作用，让用户/开发者都感到项目在改善。

如果master随着develop更新而频繁更新，那么用户就会麻木。那么即使加入了一个新功能，修复了一个BUG，因为项目总是在更新，新的变化很难引起人的注意。
所以我们真的需要那么频繁的更新吗？（现状的更新频率大致以小时为单位）

### 3. 让开发和生产的环境保持一致
develop和product的跑相同或相似的环境条件，就能避免很多问题。如果不一致的话，有时甚至会阻碍到开发人员定位BUG。

如何做到一致？
1. 通过虚拟化技术，使用vagrant、docker来统一程序运行环境。
2. 参考[The Twelve-Factor App](http://12factor.net/)，制作可自由部署于云平台，符合`Unix进程模型`的程序。开发时将代码和配置分离。发布时再将代码、配置、运行环境等等整个打包生成release。参见[12factor第五章 - build-release-run](http://12factor.net/build-release-run)。
3. 搭建云平台，使用openstack或者基于docker的[kubernetes](https://github.com/GoogleCloudPlatform/kubernetes)。

### 4. 让每个决策有据可循
关键做到文档化。有以下几点好处：
1. 文档能够永久保留，即使负责人不在了，又或者时间过去了很久，看文档就能解释一切。
2. 写文档有助于梳理思路。
3. 写文档有助于阐述观点。当场说给别人听，你可能会忘了某些重要内容，别人也可能听漏或者记不住那么多。不如写完给别人看。

所以需求文档、设计文档、BUG文档、会议文档……都必不可少。把文档放到WIKI中去，方便索引。

### 5. 理解决策，才能提高执行力
- 比如我们推行一个工具，如果不介绍为什么要使用它，使用这个工具的理论背景。那么我们纯粹是摆弄工具，而不能领会真意。
- 比如我们要执行一个上级的决策，如果上级只是说要做什么，而不解释为什么要做。那么我们很可能会曲解意思，传达到下级时说不定就不是原本的决策了。
- 比如程序员要开发一个功能或者修复一个BUG，如果不详细解释what/why/how，那么会让人走很多弯路。

所以尽可能详尽地去解释，沟通至上。最好根据`建议4`文档化你要说的，这样才能更好的让人理解与传播。

### 6. 让别人理解你的观点
当你想要阐述某个观点的时候，最好的方法是什么？

我认为有三种
- 做演讲
- 写成文档
- 做成思维脑图

`做演讲`其实太花时间，而且效果因人而异。其实不推荐。
`写成文档`的理由已在`建议4`中说明了。
`思维导图`能够简单，清晰地呈现你所想的一切。而且制作和传播非常方便。学习门槛低。效率高。



## 问题
现在来说说问题……

### 1. 为什么待处理的BUG的级别都很高？以至于要创建那么多的hotfix。导致项目阻塞于处理BUG。

#### 原因
我认为问题出在**过早地**从develop合并到master分支从而让功能/更新立刻上线。
所以一旦发现错误，肯定是从生产环境那边来的，于是BUG理所当然的就标上了高优先级。
而更深层的原因是没有考虑到master和release分支的意义。

#### 解决方案
使用`建议1`。


### 2. 为什么开发跟不上新需求？

#### 原因
我认为是提需求方没有与开发团队做好沟通。
我觉得一个人能做的事情有限，同样一个团队也是有能力范围。一旦需求的“生产速度”超出了开发团队的“消费速度”，那么就会产生积压，使团队倍感压力。

#### 解决方案
使用Scrum开发，使用看板式工具。让非技术人员也能清楚理解项目进度，团队的开发效率，需求积压状况。这样才能防止提出不合理(不符合现状)的需求。
估算出团队的开发效率，用报表和数字说话。


### 3. 为什么我们感到被动？

#### 原因
因为一直以来我们都是被安排做什么事，很少能主动。根本原因是有些人不知道怎么主动，没有途径，因为习惯被动了。（中国的教育现状）

#### 解决方案
使用Scrum开发，注重团队交流，培养团队的自我管理能力。让团队人员自己选取感兴趣的任务。让每个人主动贡献自己的力量。


### 4. 为什么有些代码在本地能跑通，却在生产环境跑不通？

#### 原因
我认为是开发和生产的环境不一致导致的。

#### 解决方案
参见`建议3`。


### 5. 能否将生产环境快速回滚到任意版本？

#### 原因
有很多原因需要我们把生产环境还原到上个版本。那么该如何做？
只是checkout code并不能真正的回滚。因为生产环境还依赖服务，数据，配置等等。

#### 解决方案
参见`建议3`的第2步。并使用一些部署工具对release进行管理。


### 6. 如何协调特性开发与BUG修复？

#### 原因
做一个项目的时候，总会出现各种各样的BUG。
然而修复BUG可能需要耗费大量的时间。有句话说“程序员10%的时间是在写功能代码，剩下的90%是在改BUG”。
那么我们应该如何协调特性开发与BUG修复。特别是在我们正在开发特性的时候，出现BUG我们应该如何应对？

#### 解决方案
目前我还没有最好的解决方案。只给出一个例子，希望能引出更好的。

将特性开发与BUG修复分成两类团队：feature团队和bug团队。
feature团队专注于功能开发，他们也会处理BUG，只不过这些BUG来自当前他们正在开发的功能代码上，而非项目之前隐藏着的BUG。
bug团队专注于修复项目的所有BUG。他们有自己的开发周期。有着自己对于BUG重要性排列的开发计划。

feature团队和bug团队没有对接。但有一点，bug团队的组成依赖feature团队。
bug团队由两类人组成：
- 团队负责人
- 技术人员
团队负责人另订。
技术人员来自多个feature团队。也就是说，每个feature团队出一人到bug团队，待上1~2个迭代周期。然后再回到feature团队。

这么做有以下好处：
- feature团队的成员到经过在bug团队的历练后，就会明白自己挖坑给别人跳的痛苦。有助于提升开发人员的代码质量。
- 在bug团队中，或许会有不同于在feature团队的视野，人员返回feature团队后能对项目给出更好的改善意见。

也有缺点：
- bug和feature团队的迭代周期必须一致，否则bug团队的人员迁入迁出就会出现问题。但实际上迭代周期不应该也不会一致。
- bug团队是只负责一个项目还是负责所有的项目？人数太多，团队规模就会太大。人数太少，就会应对不了那么多BUG。

### 7. 为什么有人会觉得工具不好用？

#### 原因
主要有以下几点
1. 工具确实不好用。
2. 工具好用，但是学习门槛高。
3. 人的问题。如不愿接受新事物，懒得学习等等。

每个优秀工具的背后，都有一套理论体系的支持，或者一个设计哲学，又或者一个理念。
如果我们绕过对这些体系、哲学、理念的学习，而直接去用这个工具。就有可能觉得这个工具不好用或者其他问题。

#### 解决方案
不求所有人都精通理论和工具，成为这方面的专家。但至少要了解掌握为什么要用它，怎么用它。做一些适当的培训和普及是相当有必要的。
工具是为了提高工作效率，而不是成为绊脚石。



## 参考(Bibliographies)
- [][B1]

## 引用(References)
[^1]: [][R1]



<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"
