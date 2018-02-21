---
title: /bin/bash 与 bash v4
author: ADoyle <adoyle.h@gmail.com>
tags: []
categories: []
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 前言 (Intro)

很早以前安装了 `brew install bash` 安装了最新的 bash 4.4.12 版本。

<!-- more -->

## TL;DR

我的系统:

OS: 64bit Mac OS X 10.11.6 15G1217
Kernel: x86_64 Darwin 15.6.0


几个误区:

### screenfetch

使用 `screenfetch` 会得到 `Shell: bash 4.4.12`

### $SHELL 与 $BASH

无论是 $SHELL 还是 $BASH，都无法准确反映当前正在运行的 bash。

比如我在外层 shell 中的输出:

```sh
$ echo $BASH
/usr/local/bin/bash
$ echo $SHELL
/bin/bash
```

而实际用的是 /usr/local/Cellar/bash/4.4.12/bin/bash

同时在 tmux 里的输出:

```sh
$ echo $BASH
/bin/bash
$ echo $SHELL
/usr/local/bin/bash
```

实际用的也是 /usr/local/Cellar/bash/4.4.12/bin/bash


### man bash

在 tmux 里执行 `man bash`

```
NAME
       bash - GNU Bourne-Again SHell

SYNOPSIS
       bash [options] [file]

COPYRIGHT
       Bash is Copyright (C) 1989-2005 by the Free Software Foundation, Inc.
...
GNU Bash-3.2                                                   2006 September 28                                                       BASH(1)
```

在最外层 shell 里执行 `man bash`

```
NAME
       bash - GNU Bourne-Again SHell

SYNOPSIS
       bash [options] [command_string | file]

COPYRIGHT
       Bash is Copyright (C) 1989-2016 by the Free Software Foundation, Inc.
...
GNU Bash 4.4                                                    2016 August 26                                                         BASH(1)
```

### bash --version

无论在 tmux 还是在外层 shell 执行 `bash --version` 都会一字不差地输出：

```
GNU bash，版本 4.4.12(1)-release (x86_64-apple-darwin15.6.0)
Copyright (C) 2016 Free Software Foundation, Inc.
许可证 GPLv3+: GNU GPL 许可证第三版或者更新版本 <http://gnu.org/licenses/gpl.html>

本软件是自由软件，您可以自由地更改和重新发布。
在法律许可的情况下特此明示，本软件不提供任何担保。
```

### 定位关键

1. `tty`，用来输出伪终端号 ttyid。
2. `ps -ef | grep <ttyid>`，用来得到进程号 pid
3. `lsof -p <pid>`，查到当前进程使用的是哪个 shell

最终结果，
这是在外层 shell 的输出：

```sh
lsof -p 50123
COMMAND   PID   USER   FD   TYPE DEVICE  SIZE/OFF     NODE NAME
bash    50123 adoyle  cwd    DIR    1,2      4692   647349 /Users/adoyle
bash    50123 adoyle  txt    REG    1,2    628496   404515 /bin/bash
```

这是在 tmux 里的输出：

```sh
lsof -p 48579
COMMAND   PID   USER   FD   TYPE DEVICE  SIZE/OFF     NODE NAME
bash    48579 adoyle  cwd    DIR    1,2       816  1329195 /Users/adoyle/
bash    48579 adoyle  txt    REG    1,2    969276 46330076 /usr/local/Cellar/bash/4.4.12/bin/bash
```

### 原因

当打开 Terminal.app 或者 iTerm2 时，它们默认都会去 login shell，即执行 `/usr/bin/login`。

> and executes the user's command interpreter (or the program specified on the command line if -f is specified).

根据 `man login` 手册的说明，login 会在最后打开交互式 shell。
事实证明默认使用的是 `/bin/bash`，即 GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin15)


`man shells` 会发现

     SHELLS(5)                   BSD File Formats Manual                  SHELLS(5)

     NAME
     shells -- shell database

     DESCRIPTION
     The shells file contains a list of the shells on the system.  For each shell a single line should be present, consisting of the shell's
     path, relative to root.

     A hash mark (``#'') indicates the beginning of a comment; subsequent characters up to the end of the line are not interpreted by the rou-
     tines which search the file.  Blank lines are also ignored.

     FILES
     /etc/shells  The shells file resides in /etc.

     SEE ALSO
     getusershell(3)

     HISTORY
     The shells file format appeared in 4.3BSD-Tahoe.

     4.2 Berkeley Distribution        June 5, 1993        4.2 Berkeley Distribution

更改 /etc/shells

其实 `brew info bash` 最后有一行 Caveats:

> In order to use this build of bash as your login shell,
> it must be added to /etc/shells.

然而我之前没有注意到😂，但好像加了也没什么用😂


`$BASH_VERSINFO` `$BASH_VERSION` 也是错误的版本号

### 正确找当前运行 bash 版本的方法：


## 参考 (Bibliographies)
- [][B1]

## 引用 (References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"

