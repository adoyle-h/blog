title: CSS 中的尺寸问题
author: 'ADoyle <adoyle.h@gmail.com>'
tags: ['CSS', '响应式']
categories: ['技术', '前端']
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/blog/copyright.html)'
---

## 概览(Overview)

总结 `px`、`em`、`rem` 以及百分比的用法。
总结单位实际计算需要注意的地方。
以及如何构建响应式的文本布局。

<!-- more -->

## 长度([<length>][0])

基本概念不多说，可以自行 google。这里主要强调几个概念：字体相对的长度单位，视口比例的长度单位，绝对长度单位。

因为浏览器兼容性问题，视口比例的长度单位一般很少用到。
字体相对的长度单位一般使用 `em`，`rem`。
绝对长度单位一般用 `px` 比较多；`pt` 用于印刷所以基本用不到。

## 百分比([<percentage>][1])

当 `translate` 使用百分比时，移动距离是根据自身元素的大小计算得到的。

当 `margin` 使用百分比时，是根据父容器的**宽度**来计算的，允许负值。需要注意的是，无论是 `margin-top`，`margin-right`，`margin-bottom`，`margin-left` 都是根据父容器的宽度计算。

`padding` 与 `margin` 同理。

当 `top` 使用百分比时，是根据父容器的**高度**计算的。`bottom` 同理。

当 `left` 使用百分比时，是根据父容器的**宽度**计算的。`right` 同理。


## 注意点

### em 与 rem 的实际计算

> This unit represents the calculated font-size of the element. If used on the font-size property itself, it represents the inherited font-size of the element.[^1]

由此可知，`em` 实际上不是相对于父容器的字号，于是相对于自身元素的字号（这个字号已经从父容器中继承得到了）。
所以当 `em` 在 `margin`、`padding`、`top`、`width` 中使用时，实际上是根据自身元素的字号大小计算得到对应的值。

当然，`rem` 也可以使用在 `margin` 等属性中使用。实际上它是根据 `html` 元素的字号大小计算得到对应值。

### 文字尺寸

所有浏览器默认的 `font-size` 为 `16px`。

通常在我们使用 `em` 时，我们这样设置 `body { font-size: 62.5%; }` （或者 `font-size: 10px`），因为如果用默认设定，`1em` 就等于 `16px`，这在单位换算上不是很直观。使用 `font-size: 10px` 的话，`1em` 就等于 `10px`。

通常在我们使用 `rem` 时，我们这样设置 `html { font-size: 62.5%; }`，跟 `em` 同理，但 `rem` 是相对于 `<html>` 标签。

## 响应式文字布局

为了构建响应式的布局，需要字体在不同尺寸的媒体下有不同显示。然而 `rem` 不是万能的，不是所有字体都应该被无限放大或者缩小，有些字体应该适度。
所以应该综合使用 `rem`、`em`、`px`。

需要注意的是，IE8 及以下版本不支持 `rem`。

主要参考 [css-tricks 的一篇文章][B1]，思路很简单：

```css
/* 使用 px 设定全局字号基准 */
html {
  font-size: 17px;
}
@media (max-width: 900px) {
  html { font-size: 15px; }
}
@media (max-width: 400px) {
  html { font-size: 13px; }
}

/* 使用 rem 设定模块字号基准 */
.header {
  font-size: 1.5rem;
}
.footer {
  font-size: 0.75rem;
}
.sidebar {
  font-size: 0.85rem;
}

/* 使用 em 设定标签的字号缩放 */
/* 随不同模块的字号基准变化 */
h1 {
  font-size: 3em;
}
h2 {
  font-size: 2.5em;
}
h3 {
  font-size: 2em;
}

/* 使用 em 设定字间距，词间距，段落间距，文字行高 */
.header p {
    font-size: 1em;
    line-height: 1.5em;
    letter-spacing: 0.2em;
    word-spacing: 0.5em;
    margin: 1em 0;
}
```


## 参考(Bibliographies)
- [css-tricks - Font Size Idea: px at the Root, rem for Components, em for Text Elements][B1]
- [tutsplus - 何时使用 Em 与 Rem][B2]

## 引用(References)
[^1]: [MDN 对于 em 的定义][R1]


<!-- 以下是相关链接 -->

[R1]: https://developer.mozilla.org/en-US/docs/Web/CSS/length#Font-relative_lengths

[B1]: https://css-tricks.com/rems-ems/
[B2]: http://webdesign.tutsplus.com/zh-hans/tutorials/comprehensive-guide-when-to-use-em-vs-rem--cms-23984

[0]: https://developer.mozilla.org/zh-CN/docs/Web/CSS/length
[1]: https://developer.mozilla.org/en-US/docs/Web/CSS/percentage