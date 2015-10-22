title: 测试之道
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['测试']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览(Overview)


<!-- more -->

## 为什么要测试？
- 自信地发布
- 自信地重构
- 修复BUG以后，避免(人工)回归测试。
- 帮助提高代码质量，编写易于测试(低耦合)的代码。

## 知识

### Test Double
- Dummy Object
- Test Stub
- Test Spy
- Fake Object
- Mock Object

### 測試術語
在介紹Test Double之前先介紹兩個測試常用術語：

SUT：System Under Test或Software Under Test的簡寫，代表待測程式。如果是單元測試，SUT就是一個function或method。
DOC：Depended-on Component（相依元件），又稱為Collaborator（合作者）。DOC是SUT執行的時候會使用到的元件。例如，有一個函數X如果執行失敗會寄送email，則email元件就是函數X的DOC。

在做單元測試的時候，測試對象是SUT，但因為SUT會呼叫其他物件，使得SUT相依於DOC。換句話說，要測試SUT，DOC也必須存在，這使得測試變得更複雜。例如，請參考下圖的Observer設計模式，假設鄉民們要測試Subject的notify函數，因此Subject的notify函數是SUT，Observer是DOC（因為notify函數會呼叫Observer的update函數）。notify函數所影響的對象是Observer，透過測試notify無法直接觀察到Observer的update函數是否有真的被呼叫，這樣的相依性使得測試notify變得困難。[^3]


### [fake、mock、stub][0]
行为验证、状态验证

许多人只会在真实的对象使用起来比较不合适的时候才会去使用一个test double。一个更加常见的使用test double的例子是：如果我们在填充订单失败的时候，需要发送一个email信息。但是问题是我们并不想在测试期间真正的给用户发送信息。所以替代它的就是我们使用了一个email系统的test double，这样我们就可以进行控制和操纵。[^2]

#### 什么时候去使用一个mock（或者其他的stub）

classic风格的TDD是尽可能的使用真实的对象，并且在真实的对象不适合使用的时候才会去使用double。
mockist风格的一个重要的分支就是行为驱动开发（Behavior Driven Development）（BDD）。[^2]


## 问题
### 耦合度高的代码怎么测试？
```js
var polls = {
    add: function (poll) { /*...*/ },
    getList: function (callback) { /*...*/ }
};

var submit = { add: function (p) { polls.add(p); } };

var view = {
    init: function () { polls.getList(this.render); },
    render: function (list) { list.forEach(/*...*/); }
};
```

`polls`对象有两个方法`add`和`getList`，`submit`和 `view` 对象依赖`polls`里的方法。

高耦合的代码难以测试，因为很难进行mock和stub。
使用**依赖注入**和**桥接模式**可以解决这个问题，重构代码：

```js
var polls = {
    add: function(poll) {
        $.post("/polls", poll);
    },
    getList: function(callback) {
        $.get("/polls", function(data) {
            callback(data.list);
        });
    }
};

var pollBridge = {
    add: polls.add,
    getList: polls.getList
};

var submit = {
    init: function(polls) {
        this.polls = polls;
    },
    add: function(poll) {
        this.polls.add(poll);
    }
};

var view = {
    init: function(polls) {
        this.polls = polls;
        this.polls.getList(this.render);
    },
    render: function(list) {
        list.forEach(function(poll) {
            $("<li />", { html: poll }).appendTo("#output");
        });
    }
};

submit.init(pollBridge);
submit.add("What is your favorite color?");
submit.add("What programming language do you list best?");
submit.add("Do you enjoy Visual Basic 6?");
submit.add("Have you ever pair programmed before?");
submit.add("Do you unit test your code?");

view.init(pollBridge);
```

### 违反单一原则的代码如何测？
某些函数太劳心(Mixed Concerns)，比如下面这段代码很难进行测试

```js
var people = {
    list: [],
    add: function (person) {
        this.list.push(person);

        $("#numberOfPeople").html(this.list.length);
    }
};
```

重构如下：

```js
var people = {
    list: [],
    initialize: function() {
        $(this).on("person.added", this.render.bind(this));
    },
    add: function (person) {
        this.list.push(person);
        $(this).trigger("person.added", [person]);
    },
    render: function(e, person) {
        $("#numberOfPeople").html(this.list.length);
        $("#lastPersonAdded").html(person.name);
    }
};

people.initialize();
people.add({ name: "Brendan Eich" });
people.add({ name: "John Resig" });
```

## 节选
> Before introducing the tools, it's important to emphasis the reason we write tests in the first place: confidence. We write tests to inspire confidence that everything is working as expected. If something breaks we want to be sure we'll catch it, and quickly understand what went wrong. Every line of every single test file should be written for this purpose.[^1]

## 困境
### 如何测试闭包中的函数？
目前没有办法。只能在编码阶段人为暴露出接口，才能进行测试。

### 如何测试匿名函数？
比如下面这段代码。

```js
$.ajax({
    url: "/people",
    success: function (data) {
        var $list = $("#list");
        $.each(data.people, function (index, person) {
            $("<li />", {
                text: person.fullName
            }).appendTo($list);
        });
    }
});
```

目前没有办法。只能改善编码风格，重构代码如下：

```js
function render(data) {
    var $list = $("#list");
    $.each(data.people, function (index, person) {
        $("<li />", {
            text: person.fullName
        }).appendTo($list);
    });
}

$.ajax({
    url: "/people",
    success: render
});
```

## 不要盲目地测试
### 先写测试，还是先写代程序？
1. "写测试+写程序" 所花的时间，大概是纯写程式的1.5～2倍時間。
2. 使用测试框架、测试该测的部分、写出好的测试，都需要学习时间以及功力。

### x
> 1. 每個專案類型不盡相同，有的是要求高正確性且牽扯到金流問題且開發時間充裕。有的純粹只是 event，用過極丟。有的是幫人外包，只要求規格正確，開發時間不寬裕。有些則是混合型。有些部分的程式碼則是相當難以寫測試（如 View），C/P 值極低。應該考慮每個專案的類型甚至是 component 去決定哪部分該嚴厲的規定寫測試，而哪些部分可有可無。

>2. Startup 前期應不應該導入 TDD/BDD ? 我認為不應該。為什麼，很多人都認為 TDD / BDD 是為了確保「程式的正確性」，所以無論如何我們都應該執行。卻忽略了 Startup 的成功要素是「快速驗證你的 Idea 的正確性」、「快速應付市場變化調整的速度」、「在市場廝殺中節省成本存活下來」。

>3. 寫測試只是為了要能自動驗證「程式的正確性」、降低「程式出錯的機率」，但團隊合作開發程式最重要的是團隊中的「溝通」，大家對 function 和架構要有一定程度以上的理解，共同撰寫程式要有一定程度以上的 convention。變更任何重大架構（如 core function, db schema, 底層設計前）都要提醒大家。
>
>如果每個人都只寫自己的，然後想改什麼東西照自己心情，沒有人想舉手之勞通知大家、跟隊友溝通。坦白說，那寫測試有個屁用，可能只是不會爆 production code，development 拉下來還是爛光光，還是要修到死。
>
>完全不溝通、不制定規範，卻期待寫測試能夠解決一切，這樣的想法不是很奇怪嗎？

4. 無論如何，就算寫了再完美的測試，再完美的程式碼。程式還是可能在你完全預期不到的狀況爆掉，所以應該做的是要接受無論如何就是要修 bug 的這件事，然後想辦法把修 bug 的成本儘量壓低，也把因為 bug 會產生的損失也儘量壓低。

不要期待測試是萬靈丹。否則期待越大，失望也大。[^4]

## 结论
- 避免使模块间的耦合度过高
- 清楚任何闭包中的私有方法都难以测试
- 清楚匿名函数都难以测试



## 参考(Bibliographies)
- [fredkschott - Node.js Handbook - Testing Essentials][B1]
- [pluralsight - 6-examples-of-hard-to-test-javascript][B2]


## 引用(References)
[^1]: [zihua.li - 在 Node.js 中测试模块的内部成员][R1]
[^2]: [Mocks Aren't Stubs（Mock和Stub是有区别的）][R2]
[^3]: [teddy-chen-tw - 什麼是測試替身？][R3]
[^4]: [XDite - 不要盲目的 BDD / TDD，我對寫測試的看法][R4]


<!-- 以下是相关链接 -->

[R1]: http://zihua.li/2014/03/test-private-methods-in-nodejs/
[R2]: http://www.myexception.cn/software-architecture-design/1076228.html
[R3]: http://teddy-chen-tw.blogspot.jp/2014/09/test-double1.html
[R4]: http://wp.xdite.net/?p=2478


[B1]: http://fredkschott.com/post/2014/05/nodejs-testing-essentials/
[B2]: http://blog.pluralsight.com/6-examples-of-hard-to-test-javascript

[0]: http://stackoverflow.com/questions/346372/whats-the-difference-between-faking-mocking-and-stubbing
