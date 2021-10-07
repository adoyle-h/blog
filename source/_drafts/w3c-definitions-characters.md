---
title: "字符编码：基本概念"
author: ADoyle <adoyle.h@gmail.com>
tags: []
categories: ['翻译']
copyright: >-
  未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank"
  href="//adoyle.me/blog/copyright.html">本站版权声明</a>
---

> 本文翻译自 W3C 的文章《[Character encodings: Essential concepts][origin]》

<!-- more -->

----

<!-- 译文 -->

本文介绍了一些字符[^1]和字符编码[^2]的基本概念，以便在其他相关文章中理解。

## UNICODE

**Unicode** 是一个通用字符集。即，为了在电脑上使用现有的大多数语言的书面文字，集中定义所需字符的一套标准。它的目标是（在很大程度上已经是了）其他所有字符集的超集。

电脑或互联网上的文本是由许多字符组成的。**字符**由字母表中的字母、标点符号或其他符号组成。

以前，不同的组织收集了不同的字符，并为它们创建了编码[^3]——有的涵盖了基于拉丁语的西欧语言（不包括保加利亚和希腊等欧盟国家）；有的涵盖了特定的远东语言（例如日语）；有的以相当特别的方式为表达世界某处的小众语言而设计的编码。

因此令人遗憾的是，你既不能保证你的应用程序能够支持所有编码，也不能保证任意编码可以支持表达任意语言。此外，通常不可能在同一网页或数据库中组合使用不同的编码，因此使用“传统”的编码难以支持多语言页面。

于是 Unicode 联盟创建了一套巨大的单一字符集，旨在包含世界上任何书写系统所需的所有字符。甚至包括古代文字（如楔形文字、哥特文字和埃及象形文字）。 如今它已是互联网和操作系统架构的基础部分，并且所有主要互联网浏览器和应用程序都支持它。Unicode 标准还描述了处理字符的属性和算法。

这种方法可以更轻松地处理多语言页面和系统，并且比大多数传统编码系统更好地满足你的需求。

The following shows Unicode script blocks as of Unicode version 5.2:

以下展示的是基于 5.2 版本的 Unicode 的 Unicode 脚本代码。

![unicodeblocks.png](//cdn.adoyle.top/blog/w3c-definitions-characters/unicodeblocks.png)

Unicode 字符集中的前 65,536 个码位[^4]可以说构成了**基本多文种平面**[^5] (Basic Multilingual Plane，简称 BMP)。BMP 包含了大多数常用的字符。

Unicode 字符集还包含大约一百万个码位的预留空间。这范围内的字符称为**辅助字符**[^6]。

![unicodeplanes.png](//cdn.adoyle.top/blog/w3c-definitions-characters/unicodeplanes.png)

更多有关 Unicode 的信息，请参阅 [Unicode 主页](http://www.unicode.org/)，或阅读教程 「[An Introduction to Writing Systems & Unicode.](https://r12a.github.io/scripts/tutorial/)」。


## 字符集、编码字符集和编码

能够清楚分辨出字符集和字符编码的概念，这点很重要。

字符集或曲目包含可能用于特定目的的字符集——无论是在计算机中支持西欧语言所需的字符，还是中国孩子在三年级将在学校学习的字符（与计算机无关） .

A character set or repertoire comprises the set of characters one might use for a particular purpose – be it those required to support Western European languages in computers, or those a Chinese child will learn at school in the third grade (nothing to do with computers).

A coded character set is a set of characters for which a unique number has been assigned to each character. Units of a coded character set are known as code points. A code point value represents the position of a character in the coded character set. For example, the code point for the letter á in the Unicode coded character set is 225 in decimal, or 0xE1 in hexadecimal notation. (Note that hexadecimal notation is commonly used for referring to code points, and will be used here.) A Unicode code point can have a value between 0x0000 and 0x10FFFF.

Coded character sets are sometimes called code pages.

The character encoding reflects the way the coded character set is mapped to bytes for manipulation in a computer. The picture below shows how characters and code points in the Tifinagh (Berber) script are mapped to sequences of bytes in memory using the UTF-8 encoding (which we describe in this section). The code point values for each character are listed immediately below the glyph (ie. the visual representation) for that character at the top of the diagram. The arrows show how those are mapped to sequences of bytes, where each byte is represented by a two-digit hexadecimal number. Note how the Tifinagh code points map to three bytes, but the exclamation mark maps to a single byte.

![encodings-utf8.png](//cdn.adoyle.top/blog/w3c-definitions-characters/encodings-utf8.png)

This explanation glosses over some of the detailed nomenclature related to encoding. More detail can be found in Unicode Technical Report #17.

One character set, multiple encodings. Many character encoding standards, such as those in the ISO 8859 series, use a single byte for a given character and the encoding is a straightforward mapping to the scalar position of the characters in the coded character set. For example, the letter A in the ISO 8859-1 coded character set is in the 65th character position (starting from zero), and is encoded for representation in the computer using a byte with the value of 65. For ISO 8859-1 this never changes.

For Unicode, however, things are not so straightforward. Although the code point for the letter á in the Unicode coded character set is always 225 (in decimal), in UTF-8 it is represented in the computer by two bytes. In other words there isn't a trivial, one-to-one mapping between the coded character set value and the encoded value for this character.

In addition, in Unicode there are a number of ways of encoding the same character. For example, the letter á can be represented by two bytes in one encoding and four bytes in another. The encoding forms that can be used with Unicode are called UTF-8, UTF-16, and UTF-32.

![encodings.png](//cdn.adoyle.top/blog/w3c-definitions-characters/encodings.png)


UTF-8 uses 1 byte to represent characters in the ASCII set, two bytes for characters in several more alphabetic blocks, and three bytes for the rest of the BMP. Supplementary characters use 4 bytes.

UTF-16 uses 2 bytes for any character in the BMP, and 4 bytes for supplementary characters.

UTF-32 uses 4 bytes for all characters.

In the following chart, the first line of numbers represents the position of a character in the Unicode coded character set. The other lines show the byte values used to represent that character in a particular character encoding.

![table.png](//cdn.adoyle.top/blog/w3c-definitions-characters/table.png)

更多有关字符和编码的信息，请参阅「[Introducing Character Sets and Encodings](https://www.w3.org/International/getting-started/characters)」，或阅读教程「[Handling character encodings in HTML and CSS](https://www.w3.org/International/tutorials/tutorial-char-enc/)」以及文章「[Choosing & applying a character encoding](https://www.w3.org/International/questions/qa-choosing-encodings.en)」。


## 文档字符集

对于 XML 和 HTML（从 4.0 版开始），ISO/IEC 10646 和 Unicode 标准就将文档字符集定义为通用字符集 (Universal Character Set, UCS)。（为简单起见并符合惯例，我们将 UCS 简称为 Unicode）

这意味着描述如何处理 XML 和 HTML 的逻辑过程是用 Unicode 所定义的字符集来写的。（实际上，这意味着浏览器通常会在内部将所有文本转换为 Unicode）

注意，这并不代表所有 HTML 和 XML 文档都必须使用 Unicode 编码！然而这确实表示文档只能包含由 Unicode 定义的字符[^9]。只要它被正确声明并且是 Unicode Repertoire 的子集，任何编码都可以用于你的文档。

更多有关文档字符集的信息，请参阅「[Document character set](https://www.w3.org/International/questions/qa-doc-charset)」。


## CHARACTERS & CLUSTERS

Although we have used it without much qualification so far in this article, the term 'character' is used here in an abstract and somewhat vague way to refer to the smallest component of written language that has semantic value. However, the term 'character' is often used to mean different things in different contexts: it can variously refer to the visual, logical, or byte-level representation of a given piece of text. This makes the term too imprecise to use when specifying algorithms, protocols, or document formats, unless you explicitly define what you mean by it. If the term 'character' is used in those contexts in a technical sense, the recommendation is to use it as a synonym for code point (described above).

It is particularly important to remember that bytes only rarely equate to characters in Unicode, as shown in the earlier examples.

However, particularly in complex scripts, what a user perceives as a smallest component of their alphabet (and so what we will call a user-perceived character) may actually be a sequence of code points. For example, the Vietnamese letter ề will be perceived as a single letter even if the underlying code point sequence is U+0065 LATIN SMALL LETTER E + U+0302 COMBINING CIRCUMFLEX ACCENT​ + U+0300 COMBINING GRAVE ACCENT​. Similarly, a Bangla speaker may view ksha (ক্ষ), which is composed of the sequence U+0995 BENGALI LETTER KA + U+09CD BENGALI SIGN VIRAMA + U+09B7 BENGALI LETTER SS,) as a single letter.

It is often important to take into account these user-perceived characters. For example, it is common to treat certain combinations of code points as a single unit for various editing operations, such as line-breaking, cursor movement, selection, deletion, etc. It would usually be problematic if a user selection accidentally omitted part of the letters just mentioned, or if a line-break separated a base character from its following combining characters.

In order to approximate user-perceived character units for such operations, Unicode uses a set of generalised rules to define grapheme clusters – sequences of adjacent code points that can be treated as a unit by applications. A single alphabetic character like e is a grapheme cluster, but so also is any combination of base character and following combining character(s), such as ề mentioned above.

- user-perceived character ![viet.png](//cdn.adoyle.top/blog/w3c-definitions-characters/viet.png)
- (possible) decomposition & grapheme cluster boundaries	![viet-parts-gc.png](//cdn.adoyle.top/blog/w3c-definitions-characters/viet-parts-gc.png)


Currently there are, however, some limitations to the grapheme cluster rules: for example, the rules split the Bangla user-perceived character kshī (ক্ষী) into two adjacent grapheme clusters, rather than enveloping the whole orthographic syllable. Applications that need to work with user-perceived characters in Bangla therefore need to apply some script-specific tailoring of the grapheme cluster rules.

- user-perceived character ![ksha.png](//cdn.adoyle.top/blog/w3c-definitions-characters/ksha.png)
- decomposition & grapheme cluster boundaries	 ![ksha-parts-gc.png](//cdn.adoyle.top/blog/w3c-definitions-characters/ksha-parts-gc.png)


The appropriate units for editing operations sometimes vary according to what you want to do. For example, if you backspace over the Hindi word `हूँ (U+0939 DEVANAGARI LETTER HA + U+0942 DEVANAGARI VOWEL SIGN UU​ + U+0901 DEVANAGARI SIGN CANDRABINDU​)` the application will typically first delete each of the two combining characters, and then the base. However, if you 'forward-delete' while the cursor is at the left of the word most applications will delete the whole grapheme cluster in one go.

CSS, in order to refer to an indivisible text unit in a given context, uses the term typographic character unit. The definition of what constitutes a typographic character unit depends on the operation that is being applied. So when working with the example of ề above, when deleting forwards there would be a single typographic character unit, but three when backspacing. Also, typographic character units cover the cases such as Bengali ksha, which grapheme clusters currently don't. The determination of what constitutes a typographic character unit in a given language and editing context is deferred to the application, rather than spelled out in rules.


## CHARACTERS & GLYPHS

A font is a collection of glyphs. In a simple scenario, a glyph is the visual representation of a code point. The glyph used to represent a code point will vary with the font used, and whether the font is bold, italic, etc. In the case of emoji, the glyphs used will vary by platform.

In fact, more than one glyph may be used to represent a single code point, and multiple code points may be represented by a single glyph.

Emoji provide another example of the complex relationship between code points and glyphs.

![glyphs.png](//cdn.adoyle.top/blog/w3c-definitions-characters/glyphs.png)

The emoji character for "family" has a code point in Unicode: 👪 [U+1F46A FAMILY]. It can also be formed by using a sequence of code points: 👨‍👩‍👦 [U+1F468 U+200D U+1F469 U+200D U+1F466]. Altering or adding other emoji characters can alter the composition of the family. For example the sequence 👨‍👩‍👧‍👧 [U+1F468 U+200D U+1F469 U+200D U+1F467 U+200D U+1F466] results in a composed emoji glyph for a "family: man, woman, girl, boy" on systems that support this kind of composition. Many common emoji can only be formed using sequences of code points, but should be treated as a single user-perceived character when displaying or processing the text.

## CHARACTER ESCAPES
A character escape is a way of representing a character without actually using the character itself.

For example, there is no way of directly representing the Hebrew character א in your document if you are using an ISO 8859-1 encoding (which covers Western European languages). One way to indicate that you want to include that character in HTML is to use the escape &#x05D0;. Because the document character set is Unicode, the user agent should recognize that this represents a Hebrew aleph character.

Examples of escapes in HTML / XHTML and CSS, and advice on when and how to use them, can be found in the article Using character escapes in markup and CSS.

## THE HTTP HEADER
When you retrieve a document from a server, the server normally sends some additional information with the document. This is called the HTTP header. Here is an example of the kind of information about the document that is passed by HTTP header with a document as it travels from the server to the client.

The second line from the bottom in this example carries information about the character encoding for the document.

```
HTTP/1.1 200 OK
Date: Wed, 05 Nov 2003 10:46:04 GMT
Server: Apache/1.3.28 (Unix) PHP/4.2.3
Content-Location: CSS2-REC.en.html
Vary: negotiate,accept-language,accept-charset
TCN: choice
P3P: policyref=http://www.w3.org/2001/05/P3P/p3p.xml
Cache-Control: max-age=21600
Expires: Wed, 05 Nov 2003 16:46:04 GMT
Last-Modified: Tue, 12 May 1998 22:18:49 GMT
ETag: "3558cac9;36f99e2b"
Accept-Ranges: bytes
Content-Length: 10734
Connection: close
Content-Type: text/html; charset=UTF-8
Content-Language: en
```

If your document is dynamically created using scripting, you may be able to explicitly add this information to the HTTP header. If you are serving static files, the server may associate this information with the files. The method of setting up a server to pass character encoding information in this way will vary from server to server. You should check with the server administrator.

As an example, Apache servers typically provide a default encoding, which can usually be overridden by directory-specific settings. For example, a webmaster might add the following line to a .htaccess file to serve all files with a .html extension as UTF-8 in this and all child directories:

```
AddType 'text/html; charset=UTF-8' html
```

更多有关 HTTP HEADER 修改加密的信息，请参阅「[Setting the HTTP charset parameter](https://www.w3.org/International/O-HTTP-charset)」。

----

作者：Richard Ishida, W3C.

感谢给予反馈的贡献者：Addison Phillips

<!-- 译毕 -->

## 译者注

[^1]: 字符 Characters
[^2]: 字符编码 Character Encodings
[^3]: 编码 Encodings
[^4]: 码位 Code Point Positions
[^5]: https://zh.wikipedia.org/zh-hans/Unicode%E5%AD%97%E7%AC%A6%E5%B9%B3%E9%9D%A2%E6%98%A0%E5%B0%84
[^6]: 辅助字符 Supplementary Characters
[^9]: 即可以用不同的编码表达相同字符

<!-- 以下是相关链接 -->

[origin]: https://www.w3.org/International/articles/definitions-characters/
