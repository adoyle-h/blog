---
title: BDD In NodeJS
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['BDD', '测试', 'NodeJS']
categories: ['技术']
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 概览(Overview)/前言(Intro)


<!-- more -->


## BDD
BDD是TDD的超集。即BDD包含了TDD所有的东西。

是一种敏捷软件开发的技术。它鼓励软件项目中的开发者、QA和非技术人员或商业参与者之间的协作。

### 优点
- 拥有TDD的所有优点
- 简单直观。非技术人员也能够编写测试，任何人都能看懂测试案例。
- 关注用户行为或故事(story)，对功能点测试完备
- 由外而内构建测试，由文档到代码

## Mocha
测试框架

### 优点
- 支持TDD/BDD
- 支持前端/后端
- 学习成本很低
- 简洁，灵活，自由度高

### Install
`npm install -g mocha`

### 构件
- describe
- it
- anonymous function

- before
- after
- beforeEach
- afterEach
- only
- skip

### 同步
```js
var assert = require('chai').assert;

describe('Array', function() {
  describe('#indexOf()', function() {
    it('should return -1 when the value is not present', function(){
      assert.equal(-1, [1, 2, 3].indexOf(5));
    });

    it('2', function() {
      assert.equal(-1, [1, 2, 3].indexOf(0));
    });

    it('3', function() {
      assert.equal(1, [1, 2, 3].indexOf(2));
    });
  });
});
```

### 异步
```js
describe('User', function(){
  describe('#save()', function(){
    it('should save without error', function(done){
      var user = new User('Luna');
      user.save(function(err){
        if (err) done(err);
        done();
      });
    })
  })
});
```

### 未定的测试
```js
describe('Array', function(){
  describe('#indexOf()', function(){
    it('should return -1 when the value is not present');
  });
});
```

### before
after的使用与before同理。

```js
describe('Array', function(){
  before(function(){
    // ...
  });

  describe('#indexOf()', function(){
    it('should return -1 when not present', function(){
      [1,2,3].indexOf(4).should.equal(-1);
    });
  });
});
```


同一个describe下可以有多个before，执行顺序与代码顺序相同。  
同一个describe下的执行顺序为before, beforeEach, afterEach, after。  
当一个it有多个before的时候，执行顺序从最外围的describe的before开始，其余同理。


### beforeEach
beforeEach只对当前describe下的所有子孙it生效。

```js
describe('Connection', function(){
  var db = new Connection
    , tobi = new User('tobi')
    , loki = new User('loki')
    , jane = new User('jane');

  beforeEach(function(done){
    db.clear(function(err){
      if (err) return done(err);
      db.save([tobi, loki, jane], done);
    });
  })

  describe('#find()', function(){
    it('respond with matching records', function(done){
      db.find({ type: 'User' }, function(err, res){
        if (err) return done(err);
        res.should.have.length(3);
        done();
      })
    })
  })
})
```


### only
```js
describe('Array', function(){
  describe.only('#indexOf()', function(){

  })
})
```
### skip
skip describe

```js
describe('Array', function(){
  describe.skip('#indexOf()', function(){
    ...
  })
})
```

或者，skip 子用例

```js
describe('Array', function(){
  describe('#indexOf()', function(){
    it.skip('should return -1 unless present', function(){

    })

    it('should return the index when present', function(){

    })
  })
})
```

## Chai
断言库

### 优点
- 支持Assert、Expect、Should
- 有各种插件增强功能

### Install
后端
`npm install --save-dev chai`

前端

```html
<script src="chai.js" type="text/javascript"></script>
```

### Assert
```js
var assert = require('chai').assert
  , foo = 'bar'
  , beverages = { tea: [ 'chai', 'matcha', 'oolong' ] };

assert.typeOf(foo, 'string', 'foo is a string');
assert.equal(foo, 'bar', 'foo equal `bar`');
assert.lengthOf(foo, 3, 'foo`s value has a length of 3');
assert.lengthOf(beverages.tea, 3, 'beverages has 3 types of tea');
```

### Expect
```js
var expect = require('chai').expect
  , foo = 'bar'
  , beverages = { tea: [ 'chai', 'matcha', 'oolong' ] };

expect(foo).to.be.a('string');
expect(foo).to.equal('bar');
expect(foo).to.have.length(3);
expect(beverages).to.have.property('tea').with.length(3);
```

```js
var answer = 43;

// AssertionError: expected 43 to equal 42.
expect(answer).to.equal(42);

// AssertionError: topic [answer]: expected 43 to equal 42.
expect(answer, 'topic [answer]').to.equal(42);
```

### Should
```js
var should = require('chai').should() //actually call the the function
  , foo = 'bar'
  , beverages = { tea: [ 'chai', 'matcha', 'oolong' ] };

foo.should.be.a('string');
foo.should.equal('bar');
foo.should.have.length(3);
beverages.should.have.property('tea').with.length(3);
```

#### 其他用法

```js
var should = require('chai').should();
db.get(1234, function (err, doc) {
  should.not.exist(err);
  should.exist(doc);
  doc.should.be.an('object');
});
```

- should.exist
- should.not.exist
- should.equal
- should.not.equal
- should.Throw
- should.not.Throw


### [Plugin](http://chaijs.com/plugins)
- HTTP
- Promise
- SPY
- JQuery


## 前端测试

### Mocha in Browser
```html
<html>
<head>
  <meta charset="utf-8">
  <title>Mocha Tests</title>
  <link rel="stylesheet" href="mocha.css" />
</head>
<body>
  <div id="mocha"></div>
  <script src="jquery.js"></script>
  <script src="chai.js"></script>
  <script src="mocha.js"></script>
  <script>
    mocha.setup('bdd')
    mocha.reporter('spec');
    should = chai.should();
  </script>
  <script src="test.js"></script>
  <script>
    mocha.checkLeaks();
    mocha.globals(['jQuery']);
    mocha.run();
  </script>
</body>
</html>
```

### 工具
#### [Sinon.js](https://github.com/cjohansen/Sinon.JS)
spies、stubs、mocks工具。

特性：

- fake 计时器
- fake ajax
- fake 服务器
- 沙盒模式
- 断言库

#### [rewire](https://github.com/jhnns/rewire)
对node模块的私有成员进行测试。

rewire使用和node的`require`非常相似。

```js
var myModule = rewire("path/to/your/test/module");
```

实际上myModule会多出两个方法，`__set__`和`__get__`

```
myModule.__set__("path", "/dev/null");
myModule.__get__("path"); // = '/dev/null'
```

如此就可以直接注入stub，或者对私有成员进行测试了。

rewire不直接读取代码来加载函数，而是使用nodejs自身的require去加载模块。  
使用的是node模块缓存中的数据，因此与测试环境与真实环境是一致的。

客户端JS测试可以也使用，参见[这里](https://github.com/jhnns/rewire#client-side-bundlers)

#### [gremlins.js](https://github.com/marmelab/gremlins.js)
- 模拟用户随机操作，可做fuzzing测试
- 模拟点击、拖动、滚屏
- 自定义测试流程
- 增强插件
- 监控、分析

#### [superagent](https://github.com/visionmedia/superagent)
模拟HTTP请求

#### [supertest](https://github.com/visionmedia/supertest)
HTTP断言库，用于测试HTTP服务器

- 支持Express

#### [Zombie.js](https://github.com/assaf/zombie)
- 客户端测试模拟环境，并且可用于在headless浏览器测试

#### [PhantomJS](https://github.com/ariya/phantomjs#)
- Webkit内核
- JavascriptCore

#### [SlimerJS](https://github.com/laurentj/slimerjs/)
- Gecko内核
- SpiderMonkey(Mozilla的JS引擎)

#### [CasperJS](https://github.com/n1k0/casperjs)
- 用于测PhantomJS、SlimerJS的工具

#### [intern](https://github.com/theintern/intern)
- 看介绍很牛X

#### [PhantomCSS](https://github.com/Huddle/PhantomCSS)
- 基于PhantomJS和Resemble.js的，CSS测试工具。

#### [Mockery](https://github.com/mfncooper/mockery)
mock 工具

#### [sandboxed-module](https://github.com/felixge/node-sandboxed-module)
mock框架

#### [proxyquire](https://github.com/thlorenz/proxyquire)
mock框架

#### [testem](https://github.com/airportyh/testem)
待评论


## 参考(Bibliographies)
- [Stackoverflow - Proxyquire, rewire, SandboxedModule, and Sinon: pros & cons][B1]
- [UNIT TESTING, THE CLOCK WAY][B2]

## 引用(References)
[^1]: [][R1]

<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: http://stackoverflow.com/questions/24190043/proxyquire-rewire-sandboxedmodule-and-sinon-pros-cons
[B2]: http://www.clock.co.uk/blog/tools-for-unit-testing-and-quality-assurance-in-node-js
