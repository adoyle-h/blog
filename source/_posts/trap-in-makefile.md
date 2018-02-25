---
title: Makefile 的一个陷阱
author: 'ADoyle <adoyle.h@gmail.com>'
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/copyright)'
tags:
  - Makefile
categories:
  - 技术
date: 2016-04-24 22:16:10
updated: 2016-04-24 22:16:10
---


## 前言(Intro)

问题是这样的，我写了一个 Makefile，大致内容如下，

```Makefile
.PHONY: b c1 c2

b: c1 c2
	echo b

c%:
	echo $@
```

然而执行 `make b` 却只打印出 `b`；
执行 `make c1` 的结果却是 `make: Nothing to be done for 'c1'`。

为何会无法执行 c1 和 c2？！

<!-- more -->

## 找原因

`Nothing to be done for` 的出现，有可能是因为没有可执行的命令。
但在这里似乎不是这个问题。

为了寻找这个问题，我从最简单的写法开始推：

```Makefile
b: c
	echo b

c:
	echo c
```
```sh
> make b
echo c
c
echo b
b

> make c
echo c
c

```
正常。

```Makefile
.PHONY: b c

b: c
	echo b

c:
	echo c
```
```sh
> make b
echo c
c
echo b
b

> make c
echo c
c

```
正常。

```Makefile
.PHONY: b c1 c2

b: c1 c2
	echo b

c1:
	echo c1

c2:
	echo c2
```

```sh
> make b
echo c1
c1
echo c2
c2
echo b
b

> make c1
echo c1
c1

> make c2
echo c2
c
```
正常。

```Makefile
.PHONY: b c1 c2

b: c1 c2
	echo b

c%:
	echo $@
```
```sh
> make b
echo b
b

> make c1
make: Nothing to be done for 'c1'.

> make c2
make: Nothing to be done for 'c2'.
```

不正常。
跟之前的相比，变化的是 `.PHONY` 中添加了 c1 和 c2 项。这个问题一定跟 `.PHONY` 相关。

## 原因

参见 [GNU - makefile](http://www.gnu.org/software/make/manual/make.html#Phony-Targets)。有这么一行：

> The implicit rule search (see Implicit Rules) is skipped for .PHONY targets. This is why declaring a target as .PHONY is good for performance, even if you are not worried about the actual file existing.

所以，当用 `%` 这种使用通配符的规则（即 Implicit Rule），只要对应的实际项存在于 `.PHONY` 中，这条规则就会被跳过。

读文档不仔细，就容易踩到坑。
Makefile：怪我咯？

## 其他

在调试的过程中，还发现其他几点需要注意的地方。

一、
我用 `$(warning)` 来打印调试变量，奇怪的是在先决条件 (prerequisites) 中使用 warning 无法打印出 % 的值。
比如

```Makefile
%.c: $(warning %.o)

%.o:
	touch %.o;
```

`make a.c` 打印出的是 `Makefile:1: %.o`，然而去掉 warning，实际上 `make a.c` 是可以执行到 `%.o` 里的命令的。
我猜可能是 `a.c` 对应的值还没映射到 %， warning 就打印了。或者因为 % 是个特殊的变量，从而 warning 无法打印。具体没有研究过，瞎猜的。


二、
```Makefile
.PHONY: c

b: c
	touch b

c:
	touch c
```

这里虽然 b 不在 .PHONY 里，但是 `make b` 依然可以无限次执行。原因在于 c 是伪命令，会影响到 b。

只要把 c 从 .PHONY 中去掉，执行 `make b`（已经存在 b 文件的情况下），就会得到 `make: 'b' is up to date.` 的提示。

所以写 Makefile 的时候要注意链式依赖里有没有依赖伪命令，以此提高执行效率。

