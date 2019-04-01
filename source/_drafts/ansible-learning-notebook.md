---
title: Ansible 学习笔记
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['ansible']
categories: ['运维']
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 前言(Intro)

基本概念什么的 google 能找到一大把资料，这里就不重复了。仅记录使用 ansible 过程中需要注意的地方。

<!-- more -->

## 任务与模块

### task 与 handler


## 角色

## 配置变量

### 调试(debug)
在任务中使用

```
# vars/main.yml

---
instances:
  node: 1
  node2: 2
```


```
# tasks/main.yml

## 使用 var 关键字
- name: debug via "var"
  debug: var=instances   # 注意不要使用 var={{ instances }} 这样的写法

- name: debug via "var"
  debug: var=instances['node']   # 注意不要一定要用引号括起来

- name: debug via "var"
  debug: var=instances.node

- name: debug via "var"
  debug:
    var=instances.node  # 貌似也可以这么写也行，不懂为什么

- name: debug via "var"
  debug:
    var: instances.node  # 也可以这么写

## 使用 msg 关键字
- name: debug via "msg"
  debug: msg="instances={{ instances }}"   # 这里就需要大括号了

- name: debug via "msg"
  debug: msg="instances.node={{ instances.node }}, instances.node2={{ instances.node2 }}"

```

### 设置默认变量

### 使用状态参数

### 平铺变量，不要使用命名空间

如果你不需要使用默认变量，可以不必遵守这条。
因为 ansible 的变量不支持嵌套覆盖，比如如下示例：

命名空间的写法：

```
# roles/ruby/defaults/main.yml
ruby:
  version: 2.1
  experimental: false

# vars.yml
ruby:
  version: 2.1
  experimental: true
```

注意 `vars.yml` 中的 `version: 2.1` 不能省略，否则最终生成的变量 `ruby` 里只有 `experimental=true` 这一对键值。
所以建议用以下写法，命名空间 `ruby` 以 `ruby_` 前缀的方式加到每个变量上，用来平铺变量。

```
# roles/ruby/defaults/main.yml
ruby_version: 2.1
ruby_experimental: false

# vars.yml
ruby_experimental: true
```

这样当你在模板中使用 `ruby_version`，其实用的是 `roles/ruby/defaults/main.yml` 里的；使用 `ruby_experimental` 时候，用的是 `vars.yml` 中的 `ruby_experimental: true`。

> 以上例子出自 [reinteractive - Ansible (Real Life) Good Practices - Prefer scalar variables][B1]


### 使用标记(Tag)

## 安全加密(Vault)

### 独立放置需要加密的敏感数据
`ansible-vault` 能够针对单个文件或者目录进行加密。

不要把所有变量一块加密，因为这让操作变得麻烦，而且多人协作时，依然不安全。

## 工具

### 利用 Git Hook

### 如何查看/比较/编辑被加密的数据

## 参考(Bibliographies)
- [reinteractive - Ansible (Real Life) Good Practices][B1]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: https://www.reinteractive.net/posts/167-ansible-real-life-good-practices "备注"


[0]: http://docs.ansible.com/ansible/debug_module.html "ansible - debug module"
