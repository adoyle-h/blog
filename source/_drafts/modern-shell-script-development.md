---
title: 现代化 Shell Script 开发指南
author: ADoyle <adoyle.h@gmail.com>
tags: []
categories: []
copyright: >-
  未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank"
  href="//adoyle.me/blog/copyright.html">本站版权声明</a>
---

![题图](//cdn.adoyle.top/share/)

<!-- ## 概览 (Overview) -->
<!-- ## 前言 (Intro) -->

本文是我使用 Bash ShellScript 编程的阶段性总结，内容部分取自我的 [TIL - 学习 Bash](http://adoyle.me/Today-I-Learned/linux/bash-learning.html) 和 [MDT - Shell Script Development](http://adoyle.me/my-development-tools/shell-script/)。本文写完就基本不会更新了，TIL 和 MDT 会不定期更新。

我将分享一些自己的最佳实践。有用的开发工具、书籍等资料。

<!-- more -->

## 正文

## 环境

主要用 bash 4，特殊情况用 bash 3。

Bash 各版本变化请看 http://wiki.bash-hackers.org/scripting/bashchanges

## 开发工具

- [shellcheck](https://github.com/koalaman/shellcheck): 能够帮助你发现脚本里的隐患。必装。

## 模板

如果你看过[我写的脚本代码][0]，会发现每个脚本代码基本上遵照差不多的书写格式。我在 vim 里定义了两个模板 (UltiSnips)，用来帮助我快速创建脚本文件。

### 类库

```bash
```

### Bash 命令

Bash 命令和类库不都是些 shell script 吗，有什么区别？
类库的低复杂度，写起来比较简单轻松。Bash 程序需要更全面的设计，比如参数解析，异常捕获。


```sh
```

[bash3boilerplate][B5] 这个模板也不错。

### 退出码 (Exit Code)

> All of the Bash builtins return an exit status of zero if they succeed and a non-zero status on failure, so they may be used by the conditional and list constructs. All builtins return an exit status of 2 to indicate incorrect usage, generally invalid options or missing arguments.

-- https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html


## 黑魔法


## 坑 (Pitfalls)

### 退出码遮盖 (Exit Code Masking)

`local var=$(cmd)`

Shellcheck 的 [SC2155](https://github.com/koalaman/shellcheck/wiki/SC2155) 规则

比如运行下面这段代码，

```sh
foo() {
  local a=$(cmd)
  echo rc=$?

  local b
  b=$(cmd)
  echo rc=$?
}
foo
```

你会看到这样的结果，

```
-bash: cmd: 未找到命令
rc=0
-bash: cmd: 未找到命令
rc=127
```

因为 `local` 也是一个命令，它的退出码是 0 遮盖了 `$(cmd)` 的退出码。

### set -o errexit 不一定有效

[set -o errexit considered harmful](https://github.com/yaccz/errexit-considered-harmful/blob/master/00.man-page.rst)

运行下面这段代码，

```sh
#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
[[ -n "${XTRACE:+x}" ]] && set -o xtrace
[[ -n "${VERBOSE:+x}" ]] && set -o verbose
[[ -n "${DEBUG:-}" ]] && IS_DEBUG=true || IS_DEBUG=false
[[ $- =~ [x] ]] && PS4='+[${BASH_SOURCE[0]}:${LINENO}|${FUNCNAME[0]:+${FUNCNAME[0]}}()|$?]: '

foo() {
  echo true
  return 10
}

bar() {
  local result
  result=$(foo)
  echo "rc=$?"
  [[ $result == true ]];
}

if bar; then
    echo 1
fi

echo 2

bar

echo 3
```

你会看到这样的结果，

```
rc=10
1
2
```

根据 errexit 的定义，理论上应该在第一次执行完 `result=$(foo)` 就报错退出的。但是实际还是继续执行下去了。

答案在 [BashFAQ/105](https://mywiki.wooledge.org/BashFAQ/105) 有解释。

虽然 errexit 不一定有效，但你写命令时还是需要加上这行，因为这能帮助你避免 80% 的错误。

[Safe ways to do things in bash - How to use errexit](https://github.com/anordal/shellharden/blob/master/how_to_do_things_safely_in_bash.md#how-to-use-errexit)

### echo 的坑

其他不同之处，参考这两篇文章

[这篇文章](https://github.com/anordal/shellharden/blob/master/how_to_do_things_safely_in_bash.md#echo--printf)里提到 echo 把参数当做选项的问题，但没有具体举例，有点难以理解。
于是我写了以下几个例子，

```sh
bash-3.2# echo -n 123
123bash-3.2# echo '-n 123'
-n 123
bash-3.2# echo "-n 123"
-n 123
bash-3.2# echo -- -n 123
-- -n 123
bash-3.2# a="-n 123"
bash-3.2# echo "$a"
-n 123
bash-3.2# echo $a
123bash-3.2# b=( -n 123 )
bash-3.2# echo "${b[@]}"
123bash-3.2# echo "${b[*]}"
-n 123
bash-3.2# echo -- "${b[*]}"
-- -n 123
bash-3.2# echo -- "${b[@]}"
-- -n 123
```

我在 bash 3 和 bash 4 都试了以上几些例子，你发现 `b=( -n 123 ); echo "${b[@]}"` 这个是不符合直觉的。
你也可以通过 docker 容器 `docker run --rm -it bash:3` 来快速尝试。

- https://unix.stackexchange.com/a/77564
- https://www.in-ulm.de/~mascheck/various/echo+printf/

### alias 无效

在非交互式的命令里运行 alias 是无效的。想在非交互式的命令里使用 alias 必须设置 `shopt -s expand_aliases` 才可以，记得关闭 `shopt -u expand_aliases`。

具体参考
https://stackoverflow.com/a/44382678
https://unix.stackexchange.com/a/158040

### Note that A && B || C is not if-then-else. C may run when A is true.

[SC2015](https://github.com/koalaman/shellcheck/wiki/SC2015)


### 其他

更多坑请看 [Bash Pitfalls][B4]。

### 文件名里的空格问题

```sh
"$filename"
"$filepath"
```

### IFS

## Bash v3 和 v4 的区别

关系到你要不要兼容 v3 的写法。

## 书写风格

参考 Google 的 [Style Guide/Shell](https://google.github.io/styleguide/shell.xml)

### 不用 function 关键字声明函数

```sh
# Do not
function foo() {
}

# Do that
bar() {
}
```

因为 Bash 和 KornShell (ksh) 支持 function 关键字，但传统的 Bourne shell (sh) 和 [POSIX 标准][1] 不支持。
如果你需要考虑跨平台兼容性，就不要用 function 关键字来声明函数。

## 模块化

### 导入模块

## 工具集

### 命令行参数解析

- https://github.com/Mosai/workshop/blob/master/doc/dispatch.md

## 脚本与命令

既可以通过 source 也可以直接执行

## 环境变量

## 堆栈信息

## 单一脚本代码组织结构

## 复杂项目文件组织结构

- https://github.com/ralish/bash-script-template

## Flatten

模块化代码打包成一个 shell 文件。

## Setting traps

## 流式处理 (Stream & Pipe)

## 测试

现代化的 Bash 测试框架

[sstephenson/bats](https://github.com/sstephenson/bats) 2016 年就停止更新了。后来我发现 [bats-core](https://github.com/bats-core/bats-core) 的 fork 了 bats 开启新的维护。

断言库。类似的 [ztombol/bats-assert](https://github.com/ztombol/bats-assert) 没人维护，bats-core 的成员 jasonkarns fork 了一份 [jasonkarns/bats-assert](https://github.com/jasonkarns/bats-assert-1)。

### 测试的坑

run 不支持管道操作。见 [issue](https://github.com/sstephenson/bats/issues/69)

比如下面这个例子是会报错的

```
@test "printf '%s\n\%s\n' a b | wc -l | tr -d ' '" {
  run printf '%s\n\%s\n' a b | wc -l | tr -d ' '
  assert_success
  assert_output 2
}
```

但可以有两种变通方法：

```
@test "printf '%s\n\%s\n' a b | wc -l | tr -d ' '" {
  test() {
    printf '%s\n\%s\n' a b | wc -l | tr -d ' '
  }
  run test
  assert_success
  assert_output 2
}
```

或者

```
@test "printf '%s\n\%s\n' a b | wc -l | tr -d ' '" {
  local result
  result=$(printf '%s\n\%s\n' a b | wc -l | tr -d ' ')
  assert_equal "$result" 2
}
```

## 包管理器

从任意指定仓库安装 bash 脚本

- https://github.com/bpkg/bpkg

### SemVer

## 参考 (Bibliographies)

**强烈推荐读一遍以下文章。**

- [GNU Bash 手册][B3]: 必读。
- [Bash Hackers Wiki][B2]: 干货满到溢出来了。
- https://github.com/dylanaraps/pure-bash-bible
- [GreyCat's wiki - Bash Pitfalls][B4]
  - https://guide.bash.academy/ : 同一作者的最新 Bash Guide
- [Command-line-text-processing](https://github.com/learnbyexample/Command-line-text-processing): 文本处理
- [Kevin van Zonneveld - Best Practices for Writing Bash Scripts][B1]
  - 其最新实践 http://bash3boilerplate.sh/
- [Defensive BASH Programming](http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/)
- [David Pashley - Writing Robust Bash Shell Scripts](https://www.davidpashley.com/articles/writing-robust-shell-scripts/)
- [12 Factor CLI Apps][B6]

非必读

- [Linux Shell Scripting Tutorial (LSST) v2.0](https://bash.cyberciti.biz/guide/Main_Page)

## 引用 (References)

[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: https://kvz.io/blog/2013/11/21/bash-best-practices/
[B2]: http://wiki.bash-hackers.org/
[B4]: http://mywiki.wooledge.org/BashPitfalls
[B5]: http://bash3boilerplate.sh/
[B3]: https://www.gnu.org/software/bash/manual/
[0]: https://github.com/adoyle-h?utf8=%E2%9C%93&tab=repositories&q=&type=&language=shell
[1]: https://www.wikiwand.com/zh/POSIX
[B6]: https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46
