title: Arcanist 使用详解
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['Phabricator', 'Arcanist']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览(Overview)
Arcanist 是一个 Phabricator 的命令行接口，同时也是一个涵盖了许多工功能的集成工具。

<!-- more -->

## 主要功能
- 通过命令行操作 Phabricator 上的行为
- 版本控制工具(Git、SVN、HG)的统一集成
- 代码检查
- 单元测试
- 覆盖率测试
- 其他小工具


## 配置(Configuration)
### 优先级
有以下五个级别，排名有先后。

1. args。通过命令行参数导入。
2. local。配置文件保存在`.git/arc/config`中，有些配置选项就在`.git/arc`下。可通过`arc set-config --local`命令设置。
3. project。配置文件保存在项目根目录下的`.arcconfig`文件。通过编辑文件生效。
4. user。配置文件保存在`~/.arcrc`。通过`arc set-config`命令设置。
5. system。配置文件保存在`/etc/arcconfig`。
5. default。默认配置在系统程序的配置文件中。

### 自动补全
自动补全脚本在`arcanist/resources/shell/bash-completion`中  
在.bashrc或者.zsh中添加`source <脚本的绝对路径>`  
然后`source ~/.bashrc`


## 命令(Commands)
### help
显示帮助。  
使用`--full`参数显示详细帮助。

### which

### diff

### get-config
使用`arc get-config --verbose`，查看更详细的配置信息。

```yaml
  local Value : -
project Value : -
   user Value : -
 system Value : -
default Value : false
```


## 工作流(Workflow)


## 参考(Bibliographies)
- [Arcanist User Guide: Commit Ranges][B1]


## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[B1]: https://secure.phabricator.com/book/phabricator/article/arcanist_commit_ranges/
