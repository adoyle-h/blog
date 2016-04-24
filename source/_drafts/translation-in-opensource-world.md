title: 如何进行开源翻译
author: 'ADoyle <adoyle.h@gmail.com>'
tags: []
categories: []
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 前言(Intro)

源文件更新如何跟踪？

<!-- more -->

## 排版

## 翻译文件

## 翻译平台
- [Zanata](http://zanata.org/)
- [Transifex](https://www.transifex.com/)
- [launchpad](https://launchpad.net/)
- [pootle](http://pootle.translatehouse.org/)
- [poeditor](https://poeditor.com/)

## 翻译工具
- [poedit]

## 编译工具

`brew install gettext`

```
ln -s /usr/local/opt/gettext/bin/msgfmt /usr/local/bin
ln -s /usr/local/opt/gettext/bin/msgunfmt /usr/local/bin
ln -s /usr/local/opt/gettext/bin/gettext /usr/local/bin
ln -s /usr/local/opt/gettext/bin/xgettext /usr/local/bin
```

```
msgunfmt xxx.mo -o xxx.po
msgfmt xxx.po -o xxx.mo
```

- [Sphinx]

### gettext
`gettext` 是一个函数，`xGettext` 是一个工具。它们都是用来从源代码中提取文本信息的。


### Sphinx
这个 Sphinx 并不是指搜索引擎，而是文档产生工具。

使用Sphinx步骤：

┌────────┐                      ┌────────┐          ┌────────┐                     ┌────────┐
│        │  Sphinx or xGettext  │        │  Poedit  │        │   msgfmt or Poedit  │        │
│  .rst  │─────────────────────▶│  .pot  │─────────▶│  .po   │────────────────────▶│  .mo   │
│        │                      │        │          │        │                     │        │
└────────┘                      └────────┘          └────────┘                     └────────┘

.pot，用来生成每种语言的 .po 文件的模板
.po 给人阅读，*.mo给机器在国际化处理时候使用

3..rst--->.pot
这个过程使用Sphinx进行转换，貌似也可以使用xgettext进行转换(i dont know how to do),
sphinx-build -b gettext ./source ./pots
4..pot--->.po
这个过程是翻译人员填充翻译内容，可以使用专用的翻译工具poedit，或者使用编辑器进行编辑，注意填充头信息
5..po--->.mo
使用msgfmt进行编译，使用poedit进行翻译，会自动生成*.mo文件

## 参考(Bibliographies)
- [ubuntu - 软件翻译/Old][B1]
- [Ubuntu 简体中文小组工作指南][B2]
- [ubuntu - 软件翻译指南][B3]
- [自由软件中文化工作指南(L10N)][B4]
- [使用Sphinx(python)进行翻译][B5]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: http://wiki.ubuntu.org.cn/%E8%BD%AF%E4%BB%B6%E7%BF%BB%E8%AF%91/Old "备注"
[B2]: http://wiki.ubuntu.org.cn/TranslatorsGuideline
[B3]: http://wiki.ubuntu.org.cn/%E8%BD%AF%E4%BB%B6%E7%BF%BB%E8%AF%91%E6%8C%87%E5%8D%97
[B4]: http://people.ubuntu.com/~happyaron/l10n/l10n-guide-zh-cn.pdf
[B4]: http://rdongxie.github.io/use-sphinx-to-translate/
