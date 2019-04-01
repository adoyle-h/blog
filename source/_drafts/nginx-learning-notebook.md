---
title: nginx 学习笔记
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['nginx']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 概览(Overview)/前言(Intro)


<!-- more -->

## server 匹配

当有多个 server 配置监听相同端口，nginx 通过请求的 HOST 等数据进行匹配。
如果依然没有匹配到，则使用默认的 server，在默认的行为配置中，默认的 server 就是第一个 server。而这个是可以通过 `listen` 指令的 `default_server` 参数改变的。
这也就意味着，当一个不期望的请求到达 nginx，会使用第一个 server 配置。

### server_name 匹配优先级

1. 准确的名称
2. 最长的，以 `*` 通配符开头的名字，比如 `*.example.org`
3. 最长的，以 `*` 通配符结尾的名字，比如 `mail.*`
4. 第一个匹配到的正则表达式

### 通配符

`*` 通配符，只有符合以下条件才能生效：

- 只能使用一次
- 只能在名字（两个点之间的单词）的开头或者结尾
- 只能出现在靠近点的两边

特殊情况： `.example.org` 相当于 `example.org` 和 `*.example.org`。

### 正则表达式

使用 PREs 语法


### 无效域名

可以使用 `server_name  _;` 进行匹配。

### 匹配效率

按速度最快从高到低排：

- 准确的名称
- 通配符名称
- 正则表达式


### 请求丢弃

默认情况下，当一个请求的 HEADER 中没有 `HOST` 字段，这个请求会被返回 444。
Nginx 系统自行定义了以下 server：

```
server {
    listen      80;
    server_name "";
    return      444;
}
```

## location 路径匹配

location 只匹配 pathname，不包含 querystring。

1. 无序地寻找最精确的路径匹配（非正则）
    a. 当只找到一个路径，如果它是 `/` 这种通用前缀，nginx 会暂存这个路径，去执行第 2 步
    b. 当匹配到多个路径，则选择最精确（长）的那个。
2. 有序地检查正则表达式匹配。
    a. 如果匹配到多条正则，则选择第一个匹配的。
    b. 如果没有，则使用 1.a 步中暂存的那个路径，如果没有暂存，则未找到匹配路径



## 参考(Bibliographies)
- [][B1]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"
