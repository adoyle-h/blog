---
title: 'CSRF 攻击原理'
author: 'ADoyle <adoyle.h@gmail.com>'
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/copyright)'
tags:
  - Web
  - 安全
  - CSRF
categories:
  - 技术
date: 2016-03-27 15:13:23
updated: 2016-03-27 15:13:23
---

## 前言(Intro)

有一个关键的问题：CSRF 攻击主要是利用 cookie 来伪造受害者的身份来发起恶意请求。（本文只讨论基于 cookie 进行身份验证的情况）
可是根据同源策略，不同源的网站之间的请求，是不会带上 cookie 的。那么 CSRF 攻击是怎么成功的呢？

网上的文章，无论中英文都写得不清不楚，仅对如何预防有详细的解释，却鲜有将攻击原理解释清楚的。

本文只讨论 POST 类型的 CSRF 攻击，因为这个攻击手段最为复杂。

<!-- more -->

我把用户被 CSRF 攻击的流程图画了一遍。主要参考 McAfee 的一篇文章 Jeremiah Blatz 的《CSRF: Attack and Defense》。


       ┌─────────────┐        ┌─────────────┐         ┌─────────────┐
       │             │        │             │         │             │
       │   Browser   │        │ Target Site │         │  CSRF Site  │
       │             │        │             │         │             │
       └─────────────┘        └─────────────┘         └─────────────┘
              │                      │                       │
                      (1)GET
              │─────────────────────▶│                       │

              │ Page with Login Form │                       │
               ◀─────────────────────
              │                      │                       │

              │                      │                       │

              │   (2)POST to Login   │                       │
               ─────────────────────▶
              │                      │                       │
                   Page and Cookies
              │◀─────────────────────│                       │

              │                      │                       │

              │                    (3)GET                    │
               ─────────────────────────────────────────────▶
              │                      │                       │
                        Page with auto-submitting Form
              │◀─────────────────────┼───────────────────────│

              │                      │                       │

              │ (4)POST with cookies │                       │
               ─────────────────────▶
              │                      │                       │
                  CSRF attack done
              │◀─────────────────────│                       │

              │                      │                       │


    (1) User gets target site home page.
        And Server responds with login page HTML.

    (2) User sends username and password to server.
        And Server gives user a session cookie, and returns HTML with a form
        in it.

    (3) User navigates to site with CSRF booby trap.
        And CSRF site returns an HTML page that includes a form that submits
        to the target site. This form is set to automatically submit itself.

    (4) User’s browser submits itself sending session cookie along with
        request. Server performs some action of the attacker’s choosing.

### 预备知识

可以参考 [wooyun wiki - CSRF][B1]

### 前置条件

要使 CSRF 攻击奏效，必须同时满足以下几个条件：

- 浏览器支持（没有禁用）cookie
- 目标网站没有做 CSRF 相关的预防措施
- 目标网站基于 cookie/session 来做身份认证
- 用户已在目标网站登陆，并且没有登出，并且没有清空 cookie，并且 cookie 没有过期

### cookie 去哪了？

攻击者是无法获知 cookie 的，也就是说，这整个攻击过程都是在用户浏览器内进行的。
攻击者要做的只是构造 (3) 步的陷阱 url，构造一个会自动提交表单的页面，并让用户去点击这个 url 就行了。

在用户从 Target Site 访问 CSRF Site 的 url 时，的确不会将 cookie 带过去。
然而在 CSRF Site 返回的自动提交表单页面（表单的 action 指向 Target Site），表单提交的 POST 请求却会带上用户在 Target Site 里的 cookie。

我的疑惑就在这里。

当你在任何网站，向 Target Site 发送 ajax 请求（不论你使用 XMLHttpRequest 还是 Fetch），请求头都不会带上 cookie。因为这是个跨域问题，同源策略进行了限制。
只有当一些“自然”的请求，比如 a 标签、image 标签（这就是 GET 型 CSRF 的攻击手段），或者表单提交，在 CSRF Site 向 Target Site 发送请求过程中，浏览器会自动带上 cookie。（同源策略你去哪了？！）

以上过程你可以打开浏览器的开发者工具来监测请求是否真的有带 cookie。
你可以参考[这份代码](https://gist.github.com/4be2e24b0cc517fd426b)来构造 CSRF Site。


## 参考(Bibliographies)
- [wooyun wiki - CSRF][B1]
- [跨站点请求伪造 (CSRF) 测试 (OTG-SESS-005)][B2]
- [OWASP - Cross-Site Request Forgery][B3]
- [hyddd - 浅谈 CSRF 攻击方式][B4]
- [stackoverflow - Why is jquery's .ajax() method not sending my session cookie][B5]

## 引用(References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: http://wiki.wooyun.org/web:csrf
[B2]: https://kennel209.gitbooks.io/owasp-testing-guide-v4/content/zh/web_application_security_testing/testing_for_cross_site_request_forgery_csrf_otg-sess-005.html
[B3]: https://www.owasp.org/index.php/CSRF
[B4]: http://www.cnblogs.com/hyddd/archive/2009/04/09/1432744.html
[B5]: http://stackoverflow.com/questions/2870371/why-is-jquerys-ajax-method-not-sending-my-session-cookie
