---
title: 守护进程调研
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['守护进程', '工具']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 概览(Overview)
本文将介绍以下守护进程。

| 名称                        | 语言   | 版本   |
| :--                         | :--    | :--    |
| [monit][]                   | C      | v5.9   |
| [supervisor(d)][supervisor] | Python | v3.1.2 |
| [PM2][]                     | NodeJS |        |
| [God][]                     | Ruby   |        |
| [foreman][]                 | Ruby   |        |

**以下操作都在ubuntu 12.04 x86_64进行。**

<!-- more -->

## [monit][]
monit是一个用来管理和监控进程，程序，文件，目录和unix文件系统的工具。  
它可以自动启动或重启挂掉的进程，也可以停止一个占用太多资源的进程。  
还可以监视文件系统的变化，如时间戳改变，校验和改变，大小改变等等。

monit是非侵入式的。

monit通过简单的配置文件和语法来控制。monit日志可以记录系统日志和自身的日志。  
还可以发邮件通知，自定义警报消息。  
monit还能监控网络连接，支持TCP/IP网络检查，端口检查等等。  
monit还提供http(s)接口以供通过浏览器访问管理。

### 特点(Feature)
- web管理界面
- 邮件通知
- 用户验证机制
- 进程/进程组管理，批量控制方便。
- DSL，自定义脚本，能对系统性能参数、文件属性等占用进行细粒度控制
- CPU、内存、硬盘监控。
- 支持daemon进程

### 安装
#### 依赖/环境
支持linux、mac、windows环境。

需要安装`PAM`(Pluggable Authentication Modules)。  
ubuntu上应该是执行`sudo apt-get install libpam0g-dev`。

#### 二进制包安装
1. 到[monit][]下载到二进制包。
2. 解压后获得这些文件：`bin  conf  COPYING  man`。
3. 执行``sudo ln -s `pwd`/monit /usr/local/bin/monit``。将`conf/monitrc`放到`~/.monitrc`。
4. 执行``ln -s `pwd`/monitrc ~/.monitrc``。将`monit`放到`/usr/local/bin/`里。

#### 源码安装
通过源码编译安装monit。

1. 到[tildeslash/monit](https://bitbucket.org/tildeslash/monit/ "bitbucket")使用`git clone`下载到源码
2. 切换到项目目录，执行`./bootstrap`
3. 执行`./configure`。可能会提示需要安装`PAM`，当然你也可以不使用PAM，执行`./configure --help`查看具体选项。
4. `make && make install`


### 配置
默认配置查找`~/.monitrc`文件，若这个文件不存在，则查找`/etc/monitrc`或者其他配置。  
你也可以使用`monit -c <absolute-path-to-your-config>`指定配置文件。

详见[monit#files](http://mmonit.com/monit/documentation/monit.html#files)

### 使用
使用之前，执行`monit -t`检查配置文件是否正确，  
看到`Control file syntax OK`即可。

执行`monit`启动，一旦启动，monit将在后台运行。  
你可以访问`http://127.0.0.1:2812/`，使用用户名`admin`，密码`monit`登录。  
使用`monit quit`关闭程序。



## [supervisor(d)][supervisor]

supervisor是一个客户端/服务端系统，用于在类unix系统上管理进程。

supervisor的父进程是`/sbin/init`。受控程序以子进程的运行。

### 特点(Feature)
- client/server模式
- web管理界面
- 邮件通知(插件)
- 用户验证机制
- 事件监听
- 进程/进程组管理，批量控制方便。
- 发送信号(Signal)
- 重定向stdout、stderr
- 丰富的第三方库/扩展
- 扩展简单，event hook，XML-RPC

### 缺点
- 不能控制本身自带daemon的程序(如nginx)，因为supervisord管理的进程必须由supervisord来启动。
- web界面信息太少。

### 组件
#### supervisord
Supervisor的server部分称为supervisord。主要负责管理子进程，响应客户端的命令，log子进程的输出，创建和处理不同的事件。

#### supervisorctl
Supervisor的命令行客户端。它可以与不同的supervisord进程进行通信，获取子进程信息，管理子进程。

#### Web Server
Supervisor的web服务器，用户可以通过浏览器对子进程进行监控，管理等等，作用与supervisorctl一致。

#### XML-RPC Interface
XML-RPC接口，提供XML-RPC服务来对子进程进行管理，监控。

### 安装
#### 依赖/环境
Python 2.4及以后版本，不支持Python 3。

支持Linux (Ubuntu 9.10)，Mac OS X (10.4/10.5/10.6)，Solaris (10 for Intel)，FreeBSD 6.1。支持大多数类Unix系统。（也就是说不支持windows）

#### 命令
`sudo easy_install supervisor` 或者 `sudo pip install supervisor`

### 配置
配置文件用于`supervisord`和`supervisorctl`  
也可使用命令行参数来设定配置，且命令行参数优先级高于配置文件。  
**推荐**所有参数都在配置文件中写好。

supervisor按照以下顺序来查找配置文件。

1. $CWD/supervisord.conf
2. $CWD/etc/supervisord.conf
3. /etc/supervisord.conf

你也可以使用`-c <absolute-path-to-your-config>`命令行参数指定配置文件。


你可以使用`echo_supervisord_conf`命令来生成配置文件模板，例如

```sh
echo_supervisord_conf > /etc/supervisord.conf
echo_supervisord_conf > /path/to/supervisord.conf
```

默认生成的文件已经对大部分进行配置。如果要快速上手，只需要配置[program:x]的部分即可。  
**配置文件至少要有一个program配置项。**

具体配置详见[supervisord/configuration](http://supervisord.org/configuration.html)

### 使用
执行`supervisord`启动supervisord。
执行`supervisorctl help`，查看子命令。


## [PM2][]

### 特点(Feature)


### 安装


### 配置


### 使用



## [God][]
据说有点坑，控制不了进程。

### 特点(Feature)


### 安装


### 配置


### 使用



## [foreman][]

### 特点(Feature)


### 安装


### 配置


### 使用


## 结论

<table>
    <tr>
        <td rowspan="2">名称\功能点</td> <td colspan="3">跨平台</td>
    </tr>
    <tr>
        <td>windows</td> <td>linux</td> <td>mac</td>
    </tr>
    <tr>
        <td>monit</td> <td>✓</td> <td>✓</td> <td>✓</td>
    </tr>
</table>


## 参考(Bibliographies)
- [进程的守护神 - Supervisor][B1]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[B1]: http://linbo.github.io/2013/04/04/supervisor/
[monit]: http://mmonit.com/monit/ "monit官网"
[supervisor]: http://supervisord.org/ "supervisord官网"
[PM2]: https://github.com/Unitech/pm2 "Github - PM2"
[God]: http://godrb.com/ "Godrb官网"
[foreman]: http://theforeman.org/ "Foreman官网"
