title: 我的 Linux 基础命令速查表
author: 'ADoyle <adoyle.h@gmail.com>'
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/copyright)'
tags: ['Linux', '命令', 'cheatsheet']
categories: ['技术']
date: 2015-10-14 14:09:59
updated: 2015-10-24 19:33:40
---


## 前言(Intro)

这是一份随时更新的列表，列出了一些常用的命令组合，供自己日常使用查阅，欢迎交流。

本文内容整合在[我的命令速查表][0] 中，可以使用 [chrisallenlane/cheat][1] 来快速查询命令。

<!-- more -->

## 用户

### ls

```bash
# 显示当前目录下的所有一级子目录
ls -d */
```

## 管道、流
### |

### >

### <

### tee

### sed

### awk

### grep

### xargs

## 系统

### wc
```bash
# 计算文件行数
wc -l <file>

# 计算字符个数
wc -m <file>

# 计算单词个数
wc -w <file>
```

### realpath
> Mac 用户需要安装 `coreutils` 来获得 `realpath`。

查看文件（真实）完整路径。意味着软链接将输出真实路径。

```bash
realpth <file>
```

### lsof
查看任何文件信息（注意 Linux 里一切皆文件）

```bash
# 查看本地端口占用
lsof -i :<port>

# 查看本地 TCP 端口占用
lsof -i TCP:<port>
```

```bash
# 查看某个用户打开的所有文件信息
lsof -u <username>
```

```bash
# 查看某个命令所关联的所有文件信息
lsof -c <command>
```

```bash
# 查看某个进程的所有信息
lsof -p <pid>
```

```bash
# 查看某个文件正在被什么进程使用
lsof <file>
```

你甚至可以使用它来找到被删除的文件！（前提是有某个进程正在使用这个文件）

> 当 UNIX 计算机受到入侵时，常见的情况是日志文件被删除，以掩盖攻击者的踪迹。管理错误也可能导致意外删除重要的文件，比如在清理旧日志时，意外地删除了数据库的活动事务日志。有时可以恢复这些文件，并且 lsof 可以为您提供帮助。
当进程打开了某个文件时，只要该进程保持打开该文件，即使将其删除，它依然存在于磁盘中。这意味着，进程并不知道文件已经被删除，它仍然可以向打开该文件时提供给它的文件描述符进行读取和写入。除了该进程之外，这个文件是不可见的，因为已经删除了其相应的目录条目。[^1]

> Linux 的优点在于，它保存了文件的名称，甚至可以告诉我们它已经被删除。在遭到破坏的系统中查找相关内容时，这是非常有用的内容，因为攻击者通常会删除日志以隐藏他们的踪迹。[^1]


题外话，其实 `lsof` 大部分信息都来自于 `/proc/` 目录，然而 `/proc/` 目录并非 unix/linux 标准，像 Mac OSX、FreeBSD 等系统，都没有 `/proc/`。

## 网络

### nc (netcat)
C/S 模式的网络工具，通常用于查看端口，但还能做其他事情。

```bash
# 查看远端地址是否开启端口
# -v 详细信息
# -z 用来扫描端口时，不发送任何数据
# -u 默认是 TCP，加这个参数使用 UDP
nc -vz <host> <port>
```

```bash
# 简易服务器，监听端口，并将结果输出到文件
nc -l <port> > output
```

```bash
# 建立 TCP 链接，然后你就可以发送数据了
nc <host> <port>
```

## 编辑

### less
is more

### nl
给文件插入行号

```bash
# 给非空行插入行号
nl <file>
```

```bash
# 给所有行插入行号
nl -b a <file>
```


## 参考(Bibliographies)
- [][B1]

## 引用(References)
[^1]: [IBM DeveloperWorks - 使用 lsof 查找打开的文件][R1]


<!-- 以下是相关链接 -->

[R1]: http://www.ibm.com/developerworks/cn/aix/library/au-lsof.html "备注"

[B1]: <url> "备注"

[0]: https://github.com/adoyle-h/my-command-cheat
[1]: https://github.com/chrisallenlane/cheat
