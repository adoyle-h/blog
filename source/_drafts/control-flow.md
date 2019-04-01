---
title: 控制流
author: ADoyle <adoyle.h@gmail.com>
tags: []
categories: []
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 概览 (Overview)
## 前言 (Intro)


<!-- more -->

## 正文

## 本质

本质是 Flow-based Programming Language

workflow patterns

## 事件驱动？

事件驱动的本质还是控制流。
事件只不过是一个约定的数据结构。


## 表达式 (Expression)

资源是个抽象，操作是个抽象。

不描述怎么做 (How)，而是描述期望是什么 (What)。

资源/执行者，需要达到怎样的期望状态。

## 名字的意义

命名是为了保持引用，如果没有需要保持引用的对象，则命名毫无必要。

## 设计

第一个节点如果是个 Node 引用的表达式，则会建立订阅关系。
如果是个 Operator 表达式，则不建立订阅关系。

一个 Control Flow 只有一个输入端，有 N 个输出端。

## FaaS 方案

### AWS Lambda

https://aws.amazon.com/cn/lambda/

### Fission

https://github.com/fission/fission

### Fn

https://github.com/fnproject/fn

### Kubeless

基于 k8s

https://github.com/kubeless/kubeless

### Funktion

基于 k8s。

https://github.com/funktionio/funktion

### Serverless Framework

https://github.com/serverless/serverless

### OpenFaaS

https://github.com/openfaas/faas

### Firecracker

https://github.com/firecracker-microvm/firecracker

## Workflow 方案

### COMIA

### 另一种 COMIA

```js
module.exports = [
    async ({}) => ({
        name: 'renderPage',
        json: true,
        text: true,
        catchError: true,

        flow: async ({inputs, get, app}) => {
            // const = get('control', 'getReleaseName');
            // const system = app.system.name;
            const system = get('system');
            const model = get('model', 'FeRelease');
            const [query] = await model.resolve({
                findOne: {
                    where: {
                        name: 'hahah',
                        utcDestroy: null,
                    },
                },
            });

            return {data: 123};
        },
    }),

    async () => ({
        name: 'getReleaseName',
        ifNotFoundThrowError: true,
        flow: {
            'paths': [
                'in > v > t1 > r > t2 > [_, c]',
                '[foo, c] > if > [a, b]',
                '[x, z] > y',
                'q > m >',
                'c > out',
            ],

            'nodes': {
                foo: {
                    resolve: ['bar']
                },
                x: () => 1,
                r: {
                    type: 'router',
                    name: '',
                },
                m: {
                    type: 'model',
                    name: 'FeRelease',
                    config: {},
                    resolve: [{
                        find: 'one',
                        where: {
                            name: 'hahah',
                            utcDestroy: null,
                        },
                    }],
                },
                if: {
                    type: 'if',
                    resolve: [{
                        condition: ({inputs}) => {
                            return inputs[0] === 'bar';
                        },
                    }],
                },
                m3: {
                    from: 'model/FeRelease',
                    resolve: ({inputs}) => [{
                        findOne: {
                            where: {
                                name: inputs[0],
                                utcDestroy: null,
                            },
                        },
                    }],
                },
                m2: ({inputs, get}) => {
                    const [name] = inputs;
                    return [get('model/FeRelease', )];
                },
                l: {
                    type: 'log',
                    name: 'haha',
                },
                v: '/Validator/business-c/default',
                r: '/ResourceHTTP/xxx',
                t2: {
                    resolve: ({inputs}) => {
                        return [inputs.haha];
                    }
                },
                t1: ({inputs}) => {
                    return [inputs + 1];
                },
            },
        },
    }),
];
```

### Slang

https://bitspark.de/slang/docs/

### NoFlow

https://noflojs.org/

### NodeRed

https://nodered.org/

### AWS SimpleWorkflow

### AWS Step Functions

https://aws.amazon.com/cn/step-functions/

### Fn Flow

https://github.com/fnproject/flow

### Azure LogicApps

### Stackstorm Workflows

https://docs.stackstorm.com/workflows.html

ActionChain

### OpenStack Mistral

https://docs.openstack.org/mistral/latest/overview.html

### Airbnb - Airflow

http://airflow.apache.org/

[Google Cloud Composer](https://cloud.google.com/composer/docs/quickstart) 是 Airflow 的使用者

### Uber Cadence

### Argo Workflow

https://github.com/argoproj/argo

### Fission Workflow

基于 Fissions。

https://docs.fission.io/workflows/

### Funktion Flow

基于 Funktion

https://funktion.fabric8.io/docs/#create-a-flow

### Openwhisk

基于 k8s。

https://github.com/apache/incubator-openwhisk

太重了，即是 FaaS 又是 Workflow

### CNCF Serverless Workflow

https://github.com/cncf/wg-serverless/blob/master/workflow/spec/spec.md

### OpenWDL

https://github.com/openwdl/wdl

## Workflow on FaaS

## Workflow and Dataflow

## Workflow and BPM

Business process modeling (BPM)

## Miesflow

对一类事物的封装，称为 Mod。对这类事物具体的对象，称为 Node。
封装服务，将数据以包 (Pack, Payload) 的形式发给控制中心服务。
控制中心坑距 Workflow 的规则，分派包（事件、消息）给的其他 Node。

## 参考 (Bibliographies)

- [Flow-based Programming][B1]
- [Serverless and Workflows: The Present and the Future][B2]
- [Workflow Patterns][B3]

## 引用 (References)

[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: http://www.jpaulmorrison.com/fbp/
[B2]: https://thenewstack.io/serverless-and-workflows-the-present-and-the-future/
[B3]: http://www.workflowpatterns.com/
