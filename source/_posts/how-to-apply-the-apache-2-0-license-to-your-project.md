title: 如何将 Apache License 2.0 应用到你的项目
author: 'ADoyle <adoyle.h@gmail.com>'
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/copyright)'
tags:
  - 开源许可证
  - Apache
  - License
categories:
  - 技术
date: 2015-12-16 21:34:24
updated:
---


## 前言(Intro)

本文主要介绍 Apache License 2.0 的使用，不涉及其他许可证，也不解释其具体内容。

http://choosealicense.com/ 告诉了你如何选择开源许可证，然而并没有解释如何在自己的项目中正确地使用它。

无论是 stackoverflow、quora、知乎、google，都鲜有提到这个许可证的实际使用细节。我最终在 PETER J. FARRELL 的[《How to Apply the Apache 2.0 License to Your Project》][origin]看到了我所需的信息，这篇文章介绍了使用 Apache License 2.0 时的具体步骤和注意点。非常有用。
以下内容是这篇文章的中文翻译：

<!-- more -->

有时我总是被问及一些关于开源许可证的问题，于是写了一个简单的教程介绍如何在你的项目中使用 Apache 2.0 许可证。

1. 首先你需要为你的项目准备一份 Apache 2.0 许可证的拷贝。你可以从 Apache 软件基金会中下载到那份文字说明。
2. 现在，你需要修改一份通告声明，以便于你将它加到自己的文件中去。暂时不必急于行动，你会在第三步看到在哪里放置通告声明。下面是一份通告声明的模板：

        Copyright [yyyy] [name of copyright owner]
        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.

    以下事情你必须做到：

    a) 替换通告声明中所有被方括号包围的条目。这里只有两处需要你替换的地方。
    b) 不要在通告声明中留下方括号。比如，“[yyyy]” 应该替换成 “2009”[^1] （应该是你发布代码的那一年）。重要的事说两遍，不要在通告声明中留下方括号。

3. 将你的通告声明写在每个文件中，以表示该文件应用 Apache 许可证。最常见的误解是，人们以为只要提供许可证的内容就足够表示自己的项目使用了 Apache 许可证。再次强调，你必须把每一份通告声明用合适的“注释语法”写到文件中去（最好是在文件开头）。

4. 然后，你需要在你发布作品的根目录下准备两个文件。最好不要把它们放到你项目中某个深度嵌套的目录中，就把它们放在根目录下。将一个文件命名成 `LICENSE` （没有文件后缀名），你要把第一步下载的许可证的内容全部写到这个文件中去。另一个文件要求命名成 `NOTICE`，用来放置你的通告声明的内容，以及一系列你的项目中用到的第三方类库的名字（最好也列出这些类库的开发者名字，以示尊重）。

5. 如果你的项目中使用的其他代码使用了不同的许可证，你必须确认那些许可证是否与 Apache 2.0 许可证兼容。例如，GPL 2.0 许可证与 Apache 2.0 许可证不兼容。还有，你必须在你重分发的代码中保留所有的原始版权和专利通告。当你对这个文件做了修改，你务必要维持那些声明，并且明确指出做了哪些改动。

嘿！你做完啦！随着项目规模的增大，给每个文件增加通告声明会占据你很多时间。我不建议使用 SVN 关键字或者其他占位符在构建时期动态插入通告声明，因为你的通告声明不会在代码仓库中搜索源代码时显示出来（例如 SVN 或 CVS）。

## 译者注
[^1]: 原文是在 2009 年写的，所以这里是 “2009”。


<!-- 以下是相关链接 -->

[origin]: http://blog.maestropublishing.com/2009/11/19/how-to-apply-the-apache-2-0-license-to-your-project/
