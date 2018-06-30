---
title: Web App 的分层结构
author: ADoyle <adoyle.h@gmail.com>
tags: ['前端', '架构', 'Web App']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览 (Overview)

## 前言 (Intro)

这篇文章继承于《》

我的目的

几个问题：

几个思想：

## 什么是 Web App？

> In computing, a web application or web app is a client–server computer program in which the client (including the user interface and client-side logic) runs in a web browser.

这是维基百科中的定义[^1]。

采用前端技术构建，在浏览器端运行的应用。

https://www.wikiwand.com/en/Web_application

2015 年就有人提出了最贴切的描述: https://blog.andyet.com/2015/01/22/native-web-apps

三方面：

- 应用运行时
- 功能的拆分
- 工程的架构

## 要解决的问题

1. 提高前端工程代码的复用率，引导开发者构建类库或框架，构建新项目时就不必做重复工作。
2. 前端难以观测 JS 的运行状态，不方便定位错误。
  - 你只能通过界面展示的问题或者前端日志（错误堆栈，其他日志）来判断是否出错。
3. 前端难以在运行时动态调试。
  - 通常调试是修改源代码，重新编译，在浏览器里重新运行一遍，看结果。尤其是线上问题，可能还要多一个发布的步骤。
  - 另一种方法是打断点，单步运行，你需要一个个设置断点，在文件代码跳转上就花费很多时间。打断点也说明你大概知道问题范围在哪。

是否可以这样做？前端应用在运行时，如果某个地方报错了，那么会有一个状态列表展示出某个组件的报错信息。

## 问题

### 为什么不用 XXX 框架？

移交控制权。
是否能快速响应我的需求？
如果不能，是改需求，还是改实现？

### 如果有人说有一套万能的框架能够解决所有问题

那我能断言，这个人一定在吹牛。因为没有人能够体验所有的场景，所有的需求。既然你不懂我的需求，那如何制作一个能解决我需求的框架？

## Web App 定义

Web App 是针对 Web 场景的 App。

Web App 遵循 App Core 定义:

1. 负责中心化调度，负责集成模块。
2. 管理应用生命周期，管理模块生命周期。


```typescript
class WebAppCore extends AppCore {
}

class WebApp extends WebAppCore {
}
```

## CLI App 定义

CLI App 是针对 shell 场景的 App。

## Mobile App 定义

Mobile App 是针对移动端场景的 App。

## 功能

Web App 所负责的功能：

- 模块依赖注入
- 中心化调度
- 模块生命周期管理
- 应用声明周期管理


Web App 不与 HTML DOM 相关，这应该是 web ui 模块负责的。
Web App 不管数据如何绑定，这应该是数据流管理模块负责的。
Web App 不管 API 是如何发送的，这应该是 Service 模块负责的。

- 组件
- 模板
- 元数据
- 数据绑定
- 指令
- 服务

这些都是模块应该去负责实现，与 web app 自身无关。开发者使用 web app 去加载那些模块来获得对应的能力。

## 定制

大概就是 app = index(public(private(web-app-lib)))

### 目录结构

```
app/
├── index.js
├── public.js
└── privates.js
```

### App 实例

```javascript
// app/index.js
import WebApp from './public';
import history from '../lib/history';
import * as helper from 'helper';
import * as util from 'util';
import logger from 'logger';

const app = new WebApp({
    logger: logger.child({tag: 'Application'}),
    dva: {
        history,
    },
});

// 自己挂载（赋值）自己的工具，只要避免覆盖 App 的内置方法就行
app.helper = helper;
app.util = util;

export default app;
```

### App 公共属性

```javascript
// app/public.js
import _APP from './privates';

const debug = require('debug')('app:public');

const delay = (ms) => new Promise((resolve) => setTimeout(() => resolve(), ms));

class APP extends _APP {
    // 这里只放给 app 调用者使用的代码，即 public 属性
    async yourBusinessLogic() {
        return '';
    }
    yourBusinessLogic2() {
        return '';
    }
};

export default APP;
```

### App 私有属性

```javascript
// app/privates.js
import Application from '@alife/tx-web-application-lib';

const debug = require('debug')('app:private');

export default class _APP extends Application {
    // private 属性放到这，推荐用 _ 前缀命名
    _privateMethod() {
        return '';
    }
};
```

## 使用

在你的入口文件里引入 app，即上文定制的 app/index.js 文件。

```javascript
// index.js
import app from './app';
import * as util from './util';
import router from './router';
import models from './models';
import plugins from './plugins';
import * as services from './services';

(async () => {
    app.injectToGlobal();

    util.forOwn(services, (service, name) => {
        app.service(name, service);
    });

    models.forEach((model) => {
        app.model(model);
    });

    plugins.forEach((plugin) => {
        app.mods.plugin(plugin);
    });

    app.mods.router(router);

    app.start('#root');
})();
```

## Web Site vs Web App

目前为止，大部分网站还是分离的页面 Web Page，是 Web Site，不是 Web App。

JS in HTML 是零碎的。

Web App 是一个应用程序。

### MVC

## JAMStack

侧重于编译期，利用 Markup 语言和模板。

https://jamstack.org/

传统写前端都是在拼页面，拼逻辑，所有的东西都是零散的，互不相关的。主要因为浏览器帮你做好了很多事情，容错、渲染、安全机制等等。
自从组件化和 SPA 概念开始流行，我发现前端也可以开发应用/系统的思路去做。
利用 webpack 和 create-react-app 提供基础开发环境。
声明一个 class Application，所有模块跟 Application 关联，实现应用逻辑。

https://files.slack.com/files-pri/T0B1KDZQA-F8NPHRUR4/image.png

比如这样的目录结构，我以开发服务端的经验，去做前端的应用开发

因为所有的东西都是零散的，导致很难做批量处理，项目越来越大，之后想全局修改就会变得成本很高。而以 Application 为中心开发，将底层通用逻辑都以 Application 的公共方法来实现，其他模块调用 app.method()，这样可以直接修改这些公共方法，或者继承覆盖来更改实现。

service 模块是用来封装 api 请求的，以替代自己随意用 xhr 或者 fetch 去发请求，统一入口

model 模块借用了 dva 的概念，将页面状态和部分逻辑放到 model 里管理维护。
https://github.com/dvajs/dva/

Components/Containers 是组件的渲染/容器层的开发思路

webpack 在我看来就是一种资源管理器，它让 js 有能力去加载一切外部资源。前端应用在浏览器里运行，它可以动态的去加载资源，无论是图片，css，js，html，markdown，文本文件，svg。也无论资源在本地文件系统还是在 cdn 还是其他 http 服务器。


大致这种层级：

![前端栈]()


这就跟盖房子一样，首先确定要造在哪里，即 Platform。然后打地基，即 Basement。接着建设骨架，构建房屋墙面，即 Application。最后室内室外装潢，根据住户需求装饰房屋，即 Customization。



于是我的 bundle 入口就变成了这样

https://files.slack.com/files-pri/T0B1KDZQA-F8N2JN0MT/image.png

抽象出 Application 还有一个好处，因为所有操作都跟 app 关联，我就可以将这个变量注入到 window，
于是我可以在浏览器端实时调试 window.app 关联的任何操作。


<!-- more -->

## 分层结构


## React vs Angular


## 编译期 vs 运行期

编译期生成的是静态文件，是静态的网站。

运行期是动态的应用。

## Progressive Web App

Progressive Web App (PWA) 是拥有离线特性的 Web App。

Web App Manifest, Service Worker, 推送 API

## Hybrid App

跨平台

移动端，CLI


## 授之以鱼，不如授之以渔

## 上下文

nodejs 的 koa 和 express 框架里有 context 这个概念。它代表的是一次请求的上下文，换句话说，是单位请求范围内的全局变量。

app 是应用程序的上下文，单位应用范围内的全局变量。

window 是浏览器标签页的上下文，单位页面范围内的全局变量。


## 参考 (Bibliographies)

- [Hux - 下一代 Web 应用模型 —— Progressive Web App][B1]

## 引用 (References)

[^1]: https://www.wikiwand.com/en/Web_application


<!-- 以下是相关链接 -->

[R1]: https://www.wikiwand.com/en/Web_application

[B1]: https://huangxuan.me/2017/02/09/nextgen-web-pwa/

