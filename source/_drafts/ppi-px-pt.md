---
title: ppi-px-pt
author: ADoyle <adoyle.h@gmail.com>
tags: []
categories: []
copyright: '未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank" href="//adoyle.me/blog/copyright.html">本站版权声明</a>'
---

## 概览 (Overview)
## 前言 (Intro)


<!-- more -->


## 基本概念

### dpi

dot per inch

### ppi

pixel per inch

### px

pixel


ppi 具体大小，决定 px 的大小
when ppi 96, 1pt = (1pt / 72 * 96) px = 1.333...px

12 pt = (12 pt /72 * 96) px = 16px

device pixel
system pixel
reference pixel

![](https://www.w3.org/TR/css3-values/pixel2.png)
![](https://www.w3.org/TR/css3-values/pixel1.png)

lastprint 和 monitor 原本的 ppi 是固定的，然而为什么在 lastprint 一个 1px 用 4 个小红点表示，在 monitor 只用一个小红点表示？
这是因为 CSS 的 px，实际上全名叫 reference pixel 导致的，它也是个相对的概念。

### pt

1 pt = 1/72 inch

### 换算公式

![](http://sebastien-gabriel.com/designers-guide-to-dpi/images/density-relationship.jpg)

[](http://hax.iteye.com/blog/374323)

### 图片 ppi

### 浏览器 ppi

### 系统 ppi

### 设备 ppi

举例，[MacBook Pro (Retina, 15 英寸, 2015 年中) - 技术规格](https://support.apple.com/kb/SP719?locale=zh_CN)

Retina 显示屏：15.4 英寸 (对角线) LED 背光显示屏 (采用 IPS 技术)；分辨率 2880 x 1800 (220 ppi)

系统分辨率，1440 x 900 (110 ppi)


### 喷墨打印机、扫描仪、液晶显示器

在浏览器中 12pt 等于 16px。

是因为 [CSS 规范](https://www.w3.org/TR/css3-values/#absolute-lengths)中定义里这个转换关系。
然而实际上在不同屏幕下，相同 px 的元素，会有不一样的物理宽度。这里的 `in` 并不是绝对物理单位，`1/72 in` 其实是 CSS 定义的一个单位，名叫 reference pixel。
文中说明了根据不同分辨率的设备采取的处理。

> For a CSS device, these dimensions are anchored either
>  - (i) by relating the physical units to their physical measurements, or
>  - (ii) by relating the pixel unit to the reference pixel.
>For print media and similar high-resolution devices, the anchor unit should be one of the standard physical units (inches, centimeters, etc). For lower-resolution devices, and devices with unusual viewing distances, it is recommended instead that the anchor unit be the pixel unit. For such devices it is recommended that the pixel unit refer to the whole number of device pixels that best approximates the reference pixel.

http://screensiz.es/monitor

## 计算浏览器中的 PPI

```js
// 把 dom 插入到 dom 树，浏览器才会给它计算实际的尺寸样式。
// 所以 document.body.appendChild 是必要的。
var e = document.body.appendChild(document.createElement('DIV'));
e.style.width = '1in';  // 1 英尺
e.style.padding = '0';  // 注意 border 和 padding 对于宽度计算的影响。
e.style.borderWidth = '0'; // 注意 border 和 padding 对于宽度计算的影响。
console.log(e.offsetWidth);  // CSS 的 px 单位。
```

## 媒体查询

`@media print and (min-resolution: 300dpi)`

`print` 和 `screen` 的区别

[](https://www.w3.org/TR/css3-mediaqueries/#resolution)

[](http://cssmediaqueries.com/overview.html)

## 参考 (Bibliographies)
- [The 72 PPI Web Resolution Myth][B1]
- [A few scanning tips][B2]
- [Wikipedia - Dots per inch][B3]
- [JOHN GRUBER - Pixel Perfect][B4]
- [A Pixel Identity Crisis][B5]
- [Designer's guide to DPI][B6]

## 引用 (References)
[^1]: [][R1]


<!-- 以下是相关链接 -->

[R1]: <url> "备注"

[B1]: http://www.photoshopessentials.com/essentials/the-72-ppi-web-resolution-myth/
[B2]: http://www.scantips.com/no72dpib.html
[B3]: https://en.wikipedia.org/wiki/Dots_per_inch
[B4]: http://daringfireball.net/2012/08/pixel_perfect
[B5]: http://alistapart.com/article/a-pixel-identity-crisis
[B6]: http://sebastien-gabriel.com/designers-guide-to-dpi/

