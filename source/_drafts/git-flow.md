---
title: 理解 Gitflow
author: ADoyle <adoyle.h@gmail.com>
tags: ['Git', 'Git Flow']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

*****
<a name="前言-intro"></a>
## 前言 (Intro)

什么是 Gitflow？

不是指 [git-flow](https://github.com/nvie/gitflow) 这种工具。

Gitflow 是一种工作流 (Workflow)。

正如软件产品的架构，能够体现出其团队组织的结构。

Git 工作流的组织，离不开产品开发的组织结构以及团队的协作流程。

所以，论 Gitflow 如何组织，我认为主要取决于三个因素：人、工具、流程。

*****
<a name="概览-overview"></a>
## 概览 (Overview)

<!-- MarkdownTOC -->

- [场景](#场景)
- [现有可供借鉴的工作流](#现有可供借鉴的工作流)
    - [词汇定义](#词汇定义)
    - [1. Centralized Workflow](#1-centralized-workflow)
    - [2. Feature Branch Workflow/Github Workflow](#2-feature-branch-workflowgithub-workflow)
    - [3. Forking Workflow](#3-forking-workflow)
    - [4. Gitflow Workflow](#4-gitflow-workflow)
    - [5. Gitlab Workflow](#5-gitlab-workflow)
    - [6. One-Line Workflow](#6-one-line-workflow)
- [执行 Gitflow 时要考虑的因素](#执行-gitflow-时要考虑的因素)
- [问题 \(FAQ\)](#问题-faq)
- [其他](#其他)
    - [Commit](#commit)
    - [Branch](#branch)
    - [Tag](#tag)
    - [Merge vs Rebase vs Cherry-pick](#merge-vs-rebase-vs-cherry-pick)
    - [Feature Toggle](#feature-toggle)
    - [物件或流程的组织，脱离不了人的组织](#物件或流程的组织，脱离不了人的组织)

<!-- /MarkdownTOC -->

<!-- more -->

*****
<a name="场景"></a>
## 场景

Git 工作流只是一个经验谈，**它不是万能的**。

不同场景下可能会采取不一样的工作流。

回忆或者设想一下，当以下人员一起协作时，你是怎样使用 Git 的？

- 一个人
    - 想怎么做就怎么做。(DWYWD, Do what you wanna do)
- 两个人
    - 可以很正规，也可以比较随意，遇到冲突，沟通一下立刻解决问题。
- 一群人
    - 正规的工作流，避免冲突，减少沟通时间。


要做什么样的东西？

- 类库 (Library)
- 框架 (Framework)
- 产品 (Product)
- 文档 (Document)
- 图片 (Picture)

*****
<a name="现有可供借鉴的工作流"></a>
## 现有可供借鉴的工作流

强烈推荐阅读 [Atlassian - Comparing Workflows](https://www.atlassian.com/git/tutorials/comparing-workflows)。

1. Centralized Workflow
2. Feature Branch Workflow/[Github Workflow](https://guides.github.com/introduction/flow/)
3. Forking Workflow
4. Gitflow Workflow
5. Gitlab Workflow
6. One-Line Workflow

*****
<a name="词汇定义"></a>
### 词汇定义

- 节点/提交：一次 git commit 所产生的提交
- 线：一条分支历史线
- 发布/release：代码开发环境发布到线上环境
- 可部署/deployable：能够通过生产环境的冒烟测试（不能保证没有功能性错误或者其他不明显的 Bug）

*****
<a name="1-centralized-workflow"></a>
### 1. Centralized Workflow

中心化的工作流。

![Centralized.svg](http://7xniyb.com1.z0.glb.clouddn.com/share/Centralized.svg)

采用 rebase 方式更新 master 分支。

优点：

- 回溯历史清晰

缺点：

- 无法多人协作开发大功能

*****
<a name="2-feature-branch-workflowgithub-workflow"></a>
### 2. Feature Branch Workflow/[Github Workflow](https://guides.github.com/introduction/flow/)

![](http://7xniyb.com1.z0.glb.clouddn.com/share/Feature.svg)

![Feature 分支](http://7xniyb.com1.z0.glb.clouddn.com/share/07.svg)

[详细文章](http://scottchacon.com/2011/08/31/github-flow.html)

Feature Branch Workflow 和 Github Workflow 的主要区别在于主分支上的节点是否随时可发布。

缺点:

- 无法维护多版本

*****
<a name="3-forking-workflow"></a>
### 3. Forking Workflow

![fork-flow.svg](http://7xniyb.com1.z0.glb.clouddn.com/share/fork-flow.svg)

开源平台用的多，因为自己不是某个项目的成员，只能 Fork 然后提 PR。

缺点：

- 反馈可能会很慢，进度变慢
- 无法多人协作开发大功能

*****
<a name="4-gitflow-workflow"></a>
### 4. Gitflow Workflow

![](http://ww3.sinaimg.cn/large/006aQyYMgw1f418mdb132j30vy16cai2.jpg)

![Gitflow.svg](http://7xniyb.com1.z0.glb.clouddn.com/share%2FGitflow.svg)

最有名，最经典的工作流。

- [Vincent Driessen 的《A successful Git branching model》](http://nvie.com/posts/a-successful-git-branching-model/)
- [Git-Flow Cheatsheet](http://danielkummer.github.io/git-flow-cheatsheet/index.zh_CN.html)
- [Gitflow 命令行工具](https://github.com/petervanderdoes/gitflow-avh)

优点：

- 针对各个情况都有妥善的应对措施

缺点：

- 概念多，学习成本相对较高
- 执行起来略麻烦

*****
<a name="5-gitlab-workflow"></a>
### 5. Gitlab Workflow

![](http://7xniyb.com1.z0.glb.clouddn.com/share/environment_branches.png)
![](http://7xniyb.com1.z0.glb.clouddn.com/share/release_branches.png)

结合 Gitflow 和 Github-flow。

特点：

- 多环境多分支，如 staging、pre-production、production
- 上游 (master) 优先
- 活用 merge 和 cherry-pick


*****
<a name="6-one-line-workflow"></a>
### 6. One-Line Workflow

![](http://7xniyb.com1.z0.glb.clouddn.com/share/one-line.png)

One-Line Workflow 表面看起来跟 Centralized Workflow 一样。但实际操作有着很高的要求。

举个例子：[phabricator](https://github.com/phacility/phabricator)

只有一条线，但是每一个节点都是可部署的。每一个节点代表一个完整的修改（修一个 Bug，或者新增一个 Feature）。

**优点**

- 历史线看起来很清晰

**缺点**

- 每个节点需要可发布，实践门槛会非常高
- 无法维护多版本

*****
<a name="执行-gitflow-时要考虑的因素"></a>
## 执行 Gitflow 时要考虑的因素

**前提：**

- 学习成本
    - 引入的概念越多，学习成本就越高
    - 安装的工具、环境依赖的复杂程度
- 使用效率
    - Git 命令操作熟练度
    - 其他工具的使用

*****

**因素：**

> 打星号的为主要考量因素

- *项目性质
    - 类库 (Library)
    - 框架 (Framework)
    - 产品 (Product)
    - 文档 (Document)
    - 设计 (Design)
- *迭代/发布周期
    - 固定长周期，Gitflow 更适合，面对各种情况有对应的处理方式
    - 短周期（1~3 小时，1~2 天），Github Flow 更合适
- *如何修复 Bug
- *如何开发 Feature
    - 并行开发
    - 大功能中的子功能
- *如何快速发布紧急修改
    - 修复紧急 Bug
    - 临时修改文案
- 如何测试
    - 单元测试
    - 集成测试
    - 端到端测试
    - 冒烟测试
- 如何进行代码审核
- 发布时间
    - 发布延时是否会影响到开发后续功能
- 如何维护版本
    - *是否要长期维护多个版本
    - patch
    - fix
- 是否具备代码回滚的能力
- 发布 (release) 的复杂程度
    - 是否要更新版本号
    - 是否要更新 Changelog
    - 是否要编译打包代码及环境
- 粒度
    - 功能的粒度
    - 提交的粒度
- CI、CD 等自动化系统的配合
    - 自动化测试
    - 自动化发布

*****

**要求:**

- 不影响其他人的开发
- 开发过程中不影响线上运行
- 独立的功能之间不会相互影响
- 视觉要求
  - 回溯历史清晰
  - commit message 如何撰写

*****
<a name="问题-faq"></a>
## 问题 (FAQ)

> 前后端共同开发，需要联调，如果联调出问题要继续调整，分支应该如何组织？

需要考虑三个因素：

1. 对于发布版本的影响
2. 对于开发的互相影响
3. 线的合并问题

![](http://7xniyb.com1.z0.glb.clouddn.com/share%2Fmix-feature.png)


*****

> 何时测试代码？

至少在合并分支前进行一次测试。

*****

> 何时审核代码？

合并分支前审核。如果一个 PR 既包含前端，也包含后端代码，可以通过文件目录来分别审核。

*****

> 多人共同开发一个模块，导致很多冲突，如何解决？

很多情况下是因为分工不明确，或是项目目录结构分配不科学导致的。

其他情况例如同时修改了某一块基础类库的代码，处理一下冲突即可，不会很频繁的发生。

*****
<a name="其他"></a>
## 其他

<a name="commit"></a>
### Commit

一个 commit 只做一件事。

*****
<a name="branch"></a>
### Branch

- 公共分支
- 个人分支

公共分支绝对不能修改历史信息（导致 commit hash 改变）。  
而个人分支上想怎么干就怎么干。

公共分支可以对应代码运行环境，比如 develop、test、stage、production。  
也可以对应职能，比如 feature/xxx、fix/xxx。

当自己在个人分支上开发，rebase 优于 merge。  
而在公共分支上，则只能使用 merge。

*****
<a name="tag"></a>
### Tag

用来标记版本号，无其他作用。

*****
<a name="merge-vs-rebase-vs-cherry-pick"></a>
### Merge vs Rebase vs Cherry-pick


*****
<a name="feature-toggle"></a>
### Feature Toggle
当开发大功能时，需要很长时间，可能要开很多子分支。  
为了保证部分完成但总体还不能上线的代码不影响工程，功能“开关”是一种控制方式。类似 AB Test。

*****
<a name="物件或流程的组织，脱离不了人的组织"></a>
### 物件或流程的组织，脱离不了人的组织

![组织结构图](http://ww3.sinaimg.cn/large/006aQyYMgw1f418mzcmb0j30m815odn9.jpg)

> 图取自 [FastCodesign - Comically Explained: The 6 Kinds Of Corporate Org Charts](http://www.fastcodesign.com/3047939/infographic-of-the-day/comically-explained-the-6-kinds-of-corporate-org-charts/4)
