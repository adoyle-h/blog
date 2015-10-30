title: 我如何使用 Tmux
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['Tmux']
categories: ['技术', 'Shell']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览(Overview)/前言(Intro)

Tmux 是终端多路复用模拟器。简而言之，是一个终端分屏神器。

<!-- more -->


## 当遇到 "Device not configured" 问题

很可能是因为资源限制，比如伪终端（pseudotty）的上限，这有个 [issue][0] 很好地解答了这个问题。建议检查一下资源使用是否到达了上限。

如果是伪终端到达上限，可以使用以下命令：

```bash
# 这个命令在 mac 下测试过可用，其他系统不能保证
# 255 是伪终端上限，可以自己指定，默认是 127
echo "kern.tty.ptmx_max=255" | sudo tee -a /etc/sysctl.conf
sudo chown root:wheel /etc/sysctl.conf
sudo chmod 644 /etc/sysctl.conf
```


## 参考(Bibliographies)
- [][B1]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"


[0]: https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/issues/30