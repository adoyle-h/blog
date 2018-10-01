---
title: 我的 Bash 编程最佳实践
author: ADoyle <adoyle.h@gmail.com>
tags: []
categories: []
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览 (Overview)
## 前言 (Intro)

本文是我使用 Bash ShellScript 编程的阶段性总结，内容部分取自我的 [TIL - 学习 Bash](http://adoyle.me/Today-I-Learned/linux/bash-learning.html) 和 [MDT - Shell Script Development](http://adoyle.me/my-development-tools/shell-script/)。本文写完就基本不会更新了，TIL 和 MDT 会不定期更新。

我将分享一些自己的最佳实践。有用的开发工具、书籍等资料。

<!-- more -->

## 环境

主要用 bash 4，特殊情况用 bash 3。

Bash 各版本变化请看 http://wiki.bash-hackers.org/scripting/bashchanges

## 开发工具

- [shellcheck](https://github.com/koalaman/shellcheck): 能够帮助你发现脚本里的隐患。必装。

## 参考手册

- [GNU Bash 手册][B3]。必读。
- [Bash Hackers Wiki][B2]。干货满到溢出来了。
- https://github.com/dylanaraps/pure-bash-bible
- https://mywiki.wooledge.org/BashPitfalls
- [Command-line-text-processing](https://github.com/learnbyexample/Command-line-text-processing): 文本处理

## 包管理器

从任意指定仓库安装 bash 脚本

- https://github.com/bpkg/bpkg

### SemVer

## 模板

如果你看过[我写的脚本代码][0]，会发现每个脚本代码基本上遵照差不多的书写格式。我在 vim 里定义了两个模板 (UltiSnips)，用来帮助我快速创建脚本文件。

1. 脚本模板：低复杂度，写起来比较简单轻松。
2. Bash 程序模板：虽然脚本也是程序，但脚本的复杂度较低。程序模板提供更全面的设计，比如参数解析，异常捕获。

### 脚本模板

```bash
#!/usr/bin/env ${1:bash}
# shellcheck disable=${2:SC1090}
set -o errexit
set -o nounset
set -o pipefail
[[ -n "${XTRACE:+x}" ]] && set -o xtrace
[[ -n "${VERBOSE:+x}" ]] && set -o verbose
[[ -n "${DEBUG:-}" ]] && IS_DEBUG=true || IS_DEBUG=false
[[ $- =~ [x] ]] && PS4='+[${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:+${FUNCNAME[0]}}()]: '
endsnippet

snippet sh-vars "Magic shell variables" b
readonly SCRIPT_DIR="$(cd -P -- "$(dirname -- "\$0")" && pwd -P)"
readonly SCRIPT_BASENAME="$(basename "\$0")"
readonly SCRIPT_PATH="${SCRIPT_DIR}/$SCRIPT_BASENAME"

readonly ARGS="$@"
readonly ARG1="\${1:-}"
```

### Bash 程序模板

```sh
#!/usr/bin/env bash
#
# Filename:
# Description:
# Author: ADoyle <adoyle.h@gmail.com>
# LICENSE: Apache License, Version 2.0
# First Created: 2017-07-26T07:13:55Z
# Last Modified: 2017-07-26T17:32:16Z
# Version: 0.1.0
# Bash Version: 4.x
# Source:
# Project:

# shellcheck disable=SC1090,SC2155
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
[[ -n "${XTRACE:+x}" ]] && set -o xtrace
[[ -n "${VERBOSE:+x}" ]] && set -o verbose
[[ -n "${DEBUG:-}" ]] && IS_DEBUG=true || IS_DEBUG=false
[[ $- =~ [x] ]] && PS4='+[${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:+${FUNCNAME[0]}}()]: '

#######################################################################
#                           initialization                            #
#######################################################################

usage() {
cat <<EOF
Usage: $0 [Options] <required> [optional]

Options:
    -h --help               Show help

Parameters:
    <required>
    <optional>
EOF
}


declare -A dispatch_cmd_opts
declare -a dispatch_cmd_args

opt_parse() {
  while [ $# -gt 0 ];do
    case $1 in
      -i)
        dispatch_cmd_opts[input]=$2
        shift
        ;;
      --input)
        dispatch_cmd_opts[input]=$2
        shift
        ;;
      -h)
        dispatch_cmd_opts[help]=true
        ;;
      --help)
        dispatch_cmd_opts[help]=true
        ;;
      *)
        dispatch_cmd_args+=("$1")
        ;;
    esac
    shift
  done

  # declare -p dispatch_cmd_opts
}

#######################################################################
#                           private methods                           #
#######################################################################


#######################################################################
#                           public methods                            #
#######################################################################

main() {
  opt_parse "$@"
  local arg0=${dispatch_cmd_args[0]:-}

  if [[ ${dispatch_cmd_opts[help]:-} == true ]] || [[ -z "$arg0" ]]; then
    usage
    exit 0
  fi
}

main "$@"
```

[bash3boilerplate][B5] 这个模板也不错。

## 书写风格

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

## 框架

## 自动化测试

https://github.com/sstephenson/bats

### 单元测试

## 堆栈信息

## 单一脚本代码组织结构

## 复杂项目文件组织结构

- https://github.com/ralish/bash-script-template

## Flatten

模块化代码打包成一个 shell 文件。


## 参考 (Bibliographies)

- [Kevin van Zonneveld - Best Practices for Writing Bash Scripts][B1]
  - 其最新实践 http://bash3boilerplate.sh/
- [Bash Hackers Wiki][B2]
- [Defensive BASH Programming](http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/)
- [GNU Bash manual][B3]

## 引用 (References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: https://kvz.io/blog/2013/11/21/bash-best-practices/
[B2]: http://wiki.bash-hackers.org/
[B5]: http://bash3boilerplate.sh/
[B3]: https://www.gnu.org/software/bash/manual/
[0]: https://github.com/adoyle-h?utf8=%E2%9C%93&tab=repositories&q=&type=&language=shell
[1]: https://www.wikiwand.com/zh/POSIX
