---
title: 我的 eslint 配置最佳实践
author: ADoyle <adoyle.h@gmail.com>
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/copyright)'
tags:
  - eslint
categories:
  - 技术
date: 2016-09-28 22:10:14
updated:
---



## 前言 (Intro)

任何一个开发者或者团队，都应该有一套自己的开发约定。

我参考了 airbnb 的 [eslint-config-airbnb][B1]，并根据自己的编程经验配置了一个 [eslint-config-adoyle-style][0]。
实践了很长一段时间，今天总结一下如何写一个可扩展的，兼容多场景的 eslint 配置文件。

<!-- more -->

## 目录结构

以下是主要的配置文件布局。

```
.
├── browser           // 适用于浏览器环境的配置
│   ├── es6.js        // 适用于浏览器环境的 es6 配置
│   └── index.js      // 入口点，适用于浏览器环境的 es5 配置
├── eslint            // eslint 核心配置，文件划分根据 http://eslint.org/docs/rules/
│   ├── best_practices.js
│   ├── commonjs.js
│   ├── es6.js
│   ├── possible_errors.js
│   ├── strict.js
│   ├── stylistic_issues.js
│   └── variables.js
├── node              // 适用于 node 环境的配置
│   ├── es6.js        // 适用于 node 环境的 es6 配置
│   └── index.js      // 入口点，适用于 node 环境的 es5 配置
└── plugin            // 可选插件的配置
    ├── import.js     // https://github.com/benmosher/eslint-plugin-import
    ├── react-a11y.js // https://github.com/evcohen/eslint-plugin-jsx-a11y
    └── react.js      // https://github.com/yannickcr/eslint-plugin-react
```

## 主要思路

主要思路是入口点文件作为基础配置，然后选择附加其他配置（例如 es6 或者 plugin 配置），按顺序覆盖之前的配置。

例如在你的 `.eslintrc` 里这么定义，

只加载 node 环境的 es5 语法配置：

```js
{
  "extends": "adoyle-style/node"
}
```

加载 node 环境的 es5 + es6 配置：

```js
{
  "extends": [
    "adoyle-style/node",
    "adoyle-style/node/es6"
  ],
}
```

又比如浏览器环境 + es6 + react：

```js
{
  "extends": [
    "adoyle-style/browser",
    "adoyle-style/browser/es6",
    "adoyle-style/plugin/import",
    "adoyle-style/plugin/react-a11y",
    "adoyle-style/plugin/react",
  ],
}
```


## 插件

所有插件配置都是可选的，放在 `plugin/` 目录。
如果使用某个 `eslint-plugin`，那么可以选择使用对应的我已写好的配置。

### 自动检测

我对每个插件的配置文件开头都附加了这么一段：

```js
const util = require('../lib/util');
util.checkPlugin('eslint-plugin-import');
```

`checkPlugin('eslint-plugin-import')` 用来检查如果 `.eslintrc` 里指定了这个插件配置，
那么会在每次执行 eslint 时自动检测项目里是否安装了 `eslint-plugin-import`，
并且检查其版本是否符合 `eslint-config-adoyle-style` 的 `package.json` 中的 `optionalDependencies.eslint-plugin-react` 的 semver。
如果检查有错，就会抛错通知使用者。

### package.json

以下是 `eslint-config-adoyle-style` 的 `package.json` 中的一部分。

```js
"peerDependencies": {
  "eslint": "~3.5.0"
},
"optionalDependencies": {
  "eslint-plugin-import": "~1.15.0",
  "eslint-plugin-jsx-a11y": "~2.2.2",
  "eslint-plugin-react": "~6.2.2"
}
```

`peerDependencies` 设置配置兼容的 eslint 版本，我设置的比较严格，因为最新 eslint 版本的每条规则我都有显式配置，所以限定 eslint 的版本起点很高范围很小。
`optionalDependencies` 列出 eslint 插件的兼容版本。


## 其他

目前只整理了三个插件的配置，写了 browser 和 node 端的配置，未来还会补上测试用的配置。

## 参考 (Bibliographies)
- [eslint-config-airbnb][B1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: https://github.com/airbnb/javascript/tree/master/packages/eslint-config-airbnb

[0]: https://github.com/adoyle-h/eslint-config-adoyle-style
