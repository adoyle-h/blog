---
title: 应用架构风格 Miesian
author: ADoyle <adoyle.h@gmail.com>
tags: ['架构', '架构风格', '框架', '应用']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览 (Overview)
## 前言 (Intro)

我设计了一套应用架构风格，取名为 Miesian。本文将介绍它的设计思路、技术实现，以及应用场景。

Miesian 主要做两件事：

1. 帮助你构建模块化的应用 (Application) 或者应用框架 (Framework)。
2. 帮助建立一个应用和模块的生态。

理论上这套架构风格能应用在任何语言，任何平台（包括前端、服务端、移动端）。
但是它不能解决跨语言及跨平台的问题，即同一个模块、框架不能跨语言或跨平台使用。这应该是语言实现层面要解决的事（比如 NodeJS 使 JS 能在服务端运行），并不是 Miesian 要解决的。
Miesian 只是给你一种应用开发的设计模式，某种程度上降低你的开发思考成本。

你可以开发出 Miesian 风格的服务端程序，也可以开发出 Miesian 风格的前端程序。

它不代替社区现有成熟的框架，你可以基于社区框架进行封装开发出 Miesian 风格的框架。

一个应用由业务层和非业务层组成。

非业务层，由应用底层和底层框架构成。

split monolithic application into modules.

## 要解决的问题

首先提出四个问题和现象，

1. 框架是开发者的从个人经验中抽象出的积累。一个框架通常只是针对某些场景解决某类问题。那么对于框架开发者未设想过的场景问题，应该如何解决？
2. 一个大而全的框架，学习和使用成本太高。我能否只用我觉得好的部分，不用管其他部分，同时不会被这个框架里其他部分所定下的约束影响？
3. 一个语言生态圈里会存在很多功能类似的框架，但多个框架之间不能互相兼容，框架生态里的模块也不能互相复用。如何让整个社区共建可以共享的框架模块生态，避免过多的重复劳动？
4. 你是否曾遇到这样的场景：因为框架问题不能实现需求，要实现得改框架。你可能不够了解源代码内部细节，当你要花时间 fork，研究改代码，编译，发布，再集成到自己的系统。修改一个框架的成本太高。


对于问题 1，某些框架设计得不好，不具备可扩展性，限制了使用者的自由；有些框架约束力太强，使用它就意味着在处理某类问题会非常高效，但处理其他问题就会各种碰壁，非常低效。种种原因，最后使用者不得不尝试换另一个框架，或者自己 DIY 一套框架。而其结果也只不过是解决了某类问题，不具备通用性。

我们根据经验总结出一套框架去解决一类或多类问题。然而对于应用项目而言，需求变量太多，场景不定，我们做不出一套万能框架去实现所有的需求。
框架开发者是基于某种场景开发框架的。如果你的需求不在这种场景，那框架很可能满足不了你的需求。这时候就很难办，你很难去改框架，只能去绕过，在外围处理这个问题。
所以你一旦用了什么框架，必然会处在某些约束下，有些是你在使用前就明确的限制，有些是你在使用时才发现的隐性约束。

对于问题 3 的生态问题，我发现大家总是再造一个又一个标准不同又不能互相兼容的全家桶。每个人的项目都有值得学习的地方，却很少能单独拿出优秀的特性供别的项目使用。框架里的模块能否在社区通用，全家桶能否是互相兼容的？


以上问题是否是你所关心的？如果不是的话，那么这篇文章可以到此为止，因为 Miesian 所解决的对你没有帮助。

<!-- more -->

## 定义

Miesian 是一个应用架构风格 (Application Architectural Style)。

Miesian 定义了一个应用 (Application) 分为几个部分：

- Application Business Logic
- Application Framework (iterative)
  - App
    - BaseApp
  - Mod (Module)
    - BaseMod

1. Application 没有任何实际功能，一开始是个空壳。
2. Application 拥有什么功能。取决于应用开发者给它加载了哪些模块。
3. Application 分两部分：App 和 Mod。
  - App 只负责以下几件事，除此之外什么都不做。
    - 集成并管理模块
    - 调度模块
    - 给模块注入初始化模块所需的数据
  - Mod 只负责实现模块功能。

Miesian 的组成单元都基于 OOP 设计。因为大部分的程序语言都可以实现 OOP 的编码风格。

## 使用场景

### 现状

服务端:

以 NodeJS 为例，相对于社区现有的框架 Express, Koa, Hapi, Micro，为什么要基于 Miesian 开发框架？

Miesian 的使用场景不是代替现有的框架，相反，它是为了集成社区已有成熟的类库和框架的框架。

以 Koa 为例。Koa 本身只负责 http 服务器，它丰富的插件生态，帮助开发者完成一系列的功能。
但是这意味着开发者要自己手动将 Koa 和 Koa 插件组装起来，因而会组成和各种各样的工程形态。
EggJS 就是一例，EggJS 基于 Koa 开发。封装了很多 Koa 插件，也自己形成一套 Egg 插件生态。

Miesian 集成 Koa 生态，甚至可以集成 EggJS 进行开发。

通常你使用一个框架来开发自己的应用，框架只是你应用中的一部分，你还会集成社区中的其他模块，以及你自己的模块。
所以通常来说你会在项目初期按照自己的想法改造框架。Miesian 为你提供了一个清晰的架构。

你会发现 Koa, Egg, Micro, Hapi 都实现了自己的一套插件系统，他们做到了可扩展，但是没做到不同平台间的可复用。
那 Miesian 的插件系统不也是一个轮子吗？是的，Miesian 的插件系统跟那些是平级的。但是 Miesian 的插件 (Mod) 具备最少的约束。Miesian 是一份开发约定，不会因系统升级而产生变动，它是最稳定不变的。

### 前端

Angular

Vue

React

## 例子

比如实现一个 MVC 架构的应用。我可以把 MVC 拆成 3 个模块 MMod VMod CMod，分别负责 Model View Controller。

理想情况下 MMod VMod CMod 都可以互相独立实现。参考 [Redux][] (Model) 和 [React][] (View) 的实现。CMod 就是负责放置你的业务逻辑代码的模块。

那么当 MMod 需要从 VMod 获取数据应该怎么办？

MMod 要做的是完成数据计算存储读取的功能。它的数据需要从别的地方拿过来，比如 View 层产生的数据输入。
MMod 和 VMod 只要提供接口来读写数据即可。中间的数据传递交给其他 Mod 来处理。类似 [React-Redux][] 这样的 Mod 来协调 MMod 和 VMod。

那么如何把 MMod VMod CMod 这三个组合起来成为 MVC？就需要有类似 [DVA][] 的 Mod 来协调。

当然也可以把 MVC 当做一个整体，实现一个 MVCMode。


## 核心理念

### Less is more

最底层的应用框架应该最为克制。它应该确保一个简单清晰的骨架，可以承载大量的模块，且不会显得混乱。

定义越少，约束就越少，操作的空间就越大，使用者的自由度就越高。

### 依赖注入

依赖注入这套有点像 Spring。中心化 App 又有点像 Angular 和 Vue 和 DVA。

比如 [Spring][]，[Angular][]，[Vue][] 就是一个大框架，这种框架有很多（虽然它设计得最好），但是这种框架会附带很多约束

spring 虽然设计得最好，但是这种框架会附带很多约束。

因为模块是独立的，我可以把有问题的模块替换掉。组织逻辑是放在 app 层的，那我也很容易替换 app 里的方法

把所有东西都拆分成模块粒度了，app 只负责组装。

### 分层设计，分而治之

框架负责提供一套应用架构组织方案以及搭建工具。
用户负责组织模块实现业务逻辑。
模块负责解决一类问题，提供某种功能。

解铃还须系铃人

功能放到模块里，用户自己组织模块，构造一个框架，一个全家桶，一个应用，而用户对自己所选择的负责。

纵向：每一层只是做一个功能的整合。
横向：功能分布于单个模块实现。

专注于分层设计，可扩展，模块化。明确职责划分。
专注于运行时。

### 不约束

不约束你的工程目录结构。
不约束你的模块接口。
不约束你应该做什么。

一切由用户自己决定，框架工具只起到辅助作用。
应用项目一开始是空的，只有一个约定：中心化调度。没有其他额外的约束。
用户根据自己的需求和分析决定用什么模块，随着添加的模块越来越多，约束才渐渐形成。而这过程是用户可控的，用户有能力独自解决约束引发的问题。

### 可扩展，可替换

你觉得不好的模块，可轻松替换。


## AppCore 定义

1. 负责中心化调度，负责集成模块。
2. 管理应用生命周期，管理模块生命周期。

AppCore 是一种高层的抽象，定义了工程的骨干，App (Application) 是主轴，Mod (Module) 是附属在主轴上的东西。

AppCore 不实现任何除了调度模块之外的功能，这些功能应该都是模块去负责实现。
开发者使用 app 去加载那些模块来获得对应的能力。

AppCore 的实例可以不是单例的。它要具备创建多个实例的能力。因此 App 框架不能有共享状态。

## 模块定义

模块是一种类，或满足某些定义的鸭子类型。

模块负责完成某种功能，它应该满足 KISS 原则。

模块通常分两种：

- 单例的，比如 Logger，Config 模块，这些只要一个实例就够了。
- 多实例，比如 Controller，View，Mod 模块。

模块可以是功能的封装，还可以是框架的封装，应用的封装。

## App 定义

AppCore 只做了以上两件事情。必然不会满足于你的需求，而且我也不期望你直接去修改 AppCore。
AppCore 提供最稳定最核心的功能。
分层设计很重要，你来实现一个 App，App 继承自 AppCore。
由于 App 是由你负责维护的，所以你可以给 App 添加任何特性，想做成框架也好，全家桶也好。没有任何阻碍。

我推荐给 App 增加函数，指挥各种模块。记住，App 负责调度，模块负责实现功能。

## 好处

定义这样一个 App，它能给你带来以下好处：

- 从应用逻辑角度管理模块依赖和加载。
- 可以在运行时与 App 交互，便于动态调试。
- 可以在运行时观测 App 的状态，所有模块的状态。
- 一种约定，而不是约束。这种约定不约束你的工程应该怎么做。
- 它帮助应用开发者集成并管理模块，引导功能开发者将功能集中到单一模块中。
- 框架易扩展，所有衍生框架都可以使用生态里的所有模块。

## 代码定义

```typescript
interface Mod {
    static get supportPlatforms() : string[]
    static get dependencies() : string[]
    static get MOD_STATUS() : MOD_STATUS
    static extendApp(extend) : void

    new (modConfig: any)

    MOD_STATUS: MOD_STATUS

    // Available values:
    // - 'idle': not started
    // - 'running': started and running
    // - 'crashed': started but something failed
    status: string

    // Start the module
    async start() : void

    // Stop the module
    // Do we need to stop the module?
    async stop() : void

    // Stop and destroy the module
    async destroy() : boolean
}
```

```typescript
class AppCore {
    static get APP_STATUS() : APP_STATUS
    static get platform() : string

    // Load a Module class to App class
    static load(modType: string, modClass: Mod) : void

    // Unload a Module class from App class
    static unload(modType: string) : void

    // Extend the App class in safe way
    static extend(props: object) : void

    new (config: object)

    // Available values:
    // - 'idle': not started
    // - 'running': started and running
    // - 'crashed': started but something failed
    status: string
    Mods: object
    mods: object

    APP_STATUS: APP_STATUS

    // Extend the app in safe way
    extend(props: object) : void

    // delegate app.method to mod.method
    delegate(appMethod: string, modType: string, opts: {
        modName: string = 'singleton'
        modMethod: string = appMethod
        this: Mod
    }) : void

    // for customize the app instance
    setup(props: {mods: object}) : void

    // Start the app
    async start() : void

    // Stop the app
    // Do we need to stop the app?
    async stop() : void

    // Stop and destroy the app
    async destroy() : boolean

    // Load a Module class to App instance
    app.load(modType: string, modClass: Mod | object) : void

    // Unload a Module from App instance
    app.unload(modType: string) : void

    // Create a mod instance
    mods[modType](name: string, modConfig: any) : Mod

    // Set a mod instance
    mods[modType](name: string, mod: Mod) : Mod

    // Get a mod instance
    mods[modType](name: string) : Mod

    // All mod instances store in a namespace
    mods[modType].namespace : object
}
```

AppCore 是单例的。

## 集成模块

模块都通过依赖注入的方式注入到 app 中。

```javascript
import {Mod} from 'miesian';

// Define your Module
class Router extends Mod {}

// Load your Module class to app instance
app.load('router', Router);

// Or load your Module class to App Class
App.load('router', Router);

// Create and inject a Mod instance
app.mods.router('router-A', {foo: 'bar'});

// Create a Mod instance
const routerB = new Router({foo: 'bar'});
// Inject the mod instance
app.mods.router('router-B', routerB);

// Get a Mod
const routerA = app.mods.router('router-A');
```

```javascript
import {Mod} from 'miesian';
import assert from './assert';

class AssertMod extends WebMod {
    assert(...args) {
        return assert(...args);
    }
}

export default AssertMod;
```

```javascript
import assert from './assert';

export default const {
    assert(...args) {
        return assert(...args);
    },
};
```


## 应用的生命周期

![a picture about lifecycle of app]()


## 意义

AppCore 帮助社区建立统一的标准，这个标准很简单：

1. app 负责中心化调度，负责集成模块。
2. 模块负责提供自己的功能。

基于这样的一种约定，没有额外的约束。这种约定不约束你的工程应该怎么做。它只是帮助你集成并管理模块。

如果社区真能按我想的发展，那么会有很多很多模块，大家不需要再造一个又一个标准不同不能互相兼容的全家桶。大家造的模块是能通用的，造的全家桶是能兼容的。

Application 想要什么功能。取决于它加载了哪些模块。
引导开发者把功能拆解到模块，模块做好一件事情。那么 app 干嘛用，它是逻辑上的中心，所以它是平台无关，技术无关的。

基于这样的结构。应用维护者就负责 app 的维护。剩下的全部交给模块。至于模块怎么实现，看社区，社区会实现各种各样的模块。

使用的时候继承 AppCore 实现自己的 app，所有模块都是你自己决定去不去加载。AppCore 提供很简单的函数去把模块集成进 app，也就是个依赖注入。
你可以覆盖集成的函数，来实现自己的逻辑。

## 模块依赖

当 A 模块依赖 B 还 C 模块，应该如何处理？

A 模块需要声明它依赖什么模块。比如声明一个数组: dependencies ['config', 'logger']

在 App load 对应的模块，

A 模块内部就可以使用 this.mods.config, this.mods.logger

### 设计模式

致力于表现低耦合，易组合，易扩展的架构。

主要用到了两种设计模式：组合模式 (Composite Pattern) 和代理模式 (Proxy Pattern)。

### 为什么要中心化调度?

你可以在运行时与 App 交互，便于动态调试。
可以在运行时观测 App 的状态，所有模块的状态。


## 调用底层 API

在 Application 层之下的，都是底层。

底层，比如说平台层，会提供基础的 API。不建议直接调用这些 API。我们可以做一个轻量级的代理。

`app.mods.platform.api()` 通过引用 app 的 platform Module 来调用平台及基础 API。

## 扩展

```typescript
class App extends AppCore {
}
```

```typescript
class AppBigger extends App {
}

class AppBiggerBigger extends AppBigger {
}
```

## 定制

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
import App from './public';
import * as helper from 'helper';
import * as util from 'util';
import logger from 'logger';

const app = new App({
    logger: logger.child({tag: 'Application'}),
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

## 分层设计

### APP 的分层

class AppCore  只实现中心化调度，模块加载和管理
class WebApp extends AppCore  前端特化的 App，WebApp 本身还是实现中心化调度，模块加载和管理，只不过设置了一些 web 相关的 Mod，它就拥有了 web 端的特性。
class YourWebApp extends WebApp  你可以基于我做的 WebApp 框架再基于业务进行改造

### Mod 的分层

就封装一下社区现有的类库

## 集成与封装

模块负责实现特定功能。他们的 API 设计千差万别。首先将模块封装成 Mod，注入到 App。

那么剩下的就是如何组织这些模块，让调用更简单，让逻辑更清晰。


WebApp.load('logger', LoggerMod);  把 LoggerMod 注入到 WebApp。

app.mods.logger('singleton', modsProps.logger);  实例化一个 LoggerMod
app.delegate('log', 'logger');
然后在实例化的 app 里 setup，设置 app.log 代理到 loggerMod.log 方法。这样我就可以直接调用 app.log 来打印日志


app 管理 mod 加载，mod 通过依赖注入的形式注入到 app。app 管理自己的声明周期和 mod 的声明周期。

至于怎么注入，是最上层应用开发者自己决定的事。

所以几乎没有负担，用户完全可以自己扩展，覆盖 app 的行为，还能自己写 mod，还能替换 app 框架里已有的 mod。

## 跨平台

类库无法跨平台，类库只能在一个平台下共享。

跨平台的是架构风格，你用其他语言一样能实现此风格的架构。

## 职责划分

把单一功能放到模块里实现。「模块实现者」。

当构建一个应用时，存在三种角色：「框架开发者」，「应用开发者」，「业务开发者」。

框架开发者。其交付的是一个应用框架，帮助应用开发者构建应用。
因为外界会依赖这个框架，因此需要考虑应用自身的扩展性。

应用开发者。其交付的是一个完整的应用，为用户提供服务。
技术层面，应用没有对外的依赖，只有业务层面的对外依赖。

业务开发者，使用应用框架来搭建业务，它们主要工作是实现业务需求。



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

## 可能存在的问题

### 模块冲突

### 依赖子模块

依赖检查，检查子模块是否已加载。

### 模块间依赖

## 最后

我根据上文实现了一套 JS 库: [miesian](https://github.com/adoyle-h/miesian)。该库提供了 Mod 和 AppCore 基类，以及一些 Mod。（目前可能还不能运行，可以看下代码实现）

我也基于 miesian 实现了自己的 [WebApp](https://github.com/adoyle-h/web-app)。
如果你对上述架构风格在 Web 场景的应用感兴趣，那么请见我的下一篇文章：[《Redefined Web App》](http://adoyle.me/blog/redefined-web-app.html)。

我期望这套架构风格能够应用到整个开源社区，同时构建起一个 Mod 和 App 生态圈。每个模块都是独立的，专一的。每个人可以根据自己的需求制作应用框架，


## 参考 (Bibliographies)

- https://spring.io/
- https://angular.io/guide/architecture
- https://cn.vuejs.org/v2/guide/instance.html
- [][B1]

## 引用 (References)

[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: <url> "备注"
[Spring]: https://spring.io/
[Angular]: https://github.com/angular/angular.js
[Vue]: https://github.com/vuejs/vue
[DVA]: https://github.com/dvajs/dva
[React-Redux]: https://github.com/reactjs/react-redux
[Redux]: https://github.com/reactjs/redux
[React]: https://github.com/facebook/react
