---
title: 可重排序列表的设计方案
author: ADoyle <adoyle.h@gmail.com>
tags: ['排序', '数据库', '数据结构']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 前言 (Intro)

### 场景

> 对于一个相册，其图片顺序是可以手动调整的，调整后的顺序将保存到数据库中。
> 如何设计一种方案，能够方便查询：如支持顺序、逆序，分页查询；加入新图片、删除图片和调整图片顺序时，能尽可能少的对数据库进行操作？

本文将提出一种针对可重排序列表 (reorderable list) 的增删改查及存储方案。

<!-- more -->

## 数据模型

计算数据模型实质是一个包含 N 棵二叉排序树 (Sorted Binary Tree) 的森林。

### 前提

#### 定义

- item: 每个元素的记录格式为 [itemId, treeId, order]
- order: 某个元素的顺序权重。默认顺序按 order 数字升序排列，小的靠前，大的靠后。（为了便于理解，order 是只作用于二叉树内的）
- itemId: 元素的主键
- treeId: 树的 id
- list: 表示列表顺序
    - `list: []` 表示空列表。
    - `list: [a]` 表示有一个元素 a。
    - `list: [a, b]`。表示有两个元素，顺序是 `a < b`。

#### 步骤

1. 预估列表的最大长度，记为 MaxLen。
2. 计算二叉排序树的最大容量，记为 Cap。Cap 要同时满足两个条件：

    Cap = sup(MaxLen)
    Cap = 2^n - 1, (n 为大于 1 的整数)

3. 构建二叉排序树，每个节点预设 order 值。树的构建和 order 计算方法如下：
    1. order 范围为 [0, Cap] 的整数
    2. 根节点的 order 为 `(Cap - 1)/2`
    3. 每个节点的左边所有子孙节点的 order 都小于当前节点；右边所有子孙节点的 order 都大于当前节点
    4. 所有中间节点的 order 都是所在区间的中间值
    5. 该树是满二叉树

#### 假设

假设最多有 `a, b, c, d, e` 5 个元素需要排序。
则 MaxLen = 5，Cap = 7。

于是初始状态是这样的：
{% asset_img 0.png 图0. 初始状态, list: [] %}

### 新增 (Create)

接下来，将解释如何一步步编排 `a, b, c, d, e` 的顺序。

第一步
{% asset_img 1.png 图1. 加入 a, list: [a] %}

第二步
{% asset_img 2.png 图2. 加入 b, list: [b, a] %}

第三步
{% asset_img 3.png 图3. 加入 c, list: [c, b, a] %}

第四步
{% asset_img 4.png 图4. 加入 d, list: [c, b, d, a] %}

第五步
{% asset_img 5.png 图5. 加入 e, list: [c, b, d, a, e] %}

---

以上只是刚好都有空位的情况，你会注意到如果第四步 `d < c`，那么应该如何放置 d？

{% asset_img 4-2.png 图4-2. 加入 d, list: [d, c, b, a] %}

这里的策略是，当前树没有空余的位置放置新元素，则把这个元素放到另一棵树里，如果那棵树还放不下，则放下下棵树，以此类推。
可以预测，列表长度为 MaxLen，最多需要 MaxLen 棵二叉树。

于是产生第二棵树，顺序权重 Tree1 > Tree2。
虽然 Tree2 的 order 分布和 Tree1 一模一样，但是计算权重时 Tree2 中最大节点的 order 要比 Tree1 最小节点的 order 小。
实际上权重是由 tree 的权重和当前节点的 order 计算而来的。

#### 森林里最多有 MaxLen 棵树

虽然看上去还是 `list: [c, b, d, a, e]` 的顺序，但是经过一系列的变换，每个元素的存储位置有所改动。
森林可能会达到这样一种状态，每个元素分布在一棵独立的树上：

{% asset_img forest.png 图6. %}

森林的树个数最大为 MaxLen，是因为在最分散的情况下，不可能有两个元素存在同一个树上。

#### 森林秩序

所以这之后只要调整树之间的顺序关系即可。

[tree1, tree2, tree3, tree4, tree5]


### 查询 (Retrieve)

### 删除 (Delete)

当图5 的情况下，删除 b，使顺序为 `[c, d, a, e]`。数据结构如下图所示：

{% asset_img d-1.png 图7. 删除 b, list: [c, d, a, e] %}

可以看到，其他元素的 order 没有变化，只有 b 受影响。

### 换序 (Update)


## 数据库设计

## 释义

### 特殊的二叉排序树

在本算法中该二叉排序树的特性：

- 根节点的 order 是奇数
- 叶节点的 order 全是偶数

### 节点个数理论上限

以 JavaScript 为例，其最大整数为 9007199254740991 (保证不丢失精度)

```js
Number.MAX_SAFE_INTEGER // => 9007199254740991
Math.sqrt(Number.MAX_SAFE_INTEGER) // => 94906265.62425154
```

又因为森林中要包含 MaxLen 棵这样的二叉树，
又因为 `Cap = 2^n - 1` 的约束，
所以每棵树最多可以有 `2^26 - 1 = 67108863` 个节点。

所以列表长度的范围为 `[3, 67108863]`。

### DEMO

暂无

## 参考 (Bibliographies)
- [][B1]

## 引用 (References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"

