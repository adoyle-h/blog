---
title: 同一文件的两次 zip 内容不一致
author: ADoyle <adoyle.h@gmail.com>
copyright: '未经授权，不得全文转载。转载前请先阅读[本站版权声明](http://adoyle.me/copyright)'
tags:
  - zip
categories:
  - 技术
date: 2018-06-30 19:45:29
updated: 2018-06-30 19:45:29
---



## 前言 (Intro)

有个朋友提了这样的一个问题：

> 同样的文件，用 zip 打包两次，打包出来的文件 md5 怎么不一样啊？

我自己做了一遍惊讶地发现真是如此，第一反应是打包混入了时间戳。但 google 却没找到恰当的答案。于是开启了我的探索之旅。

<!-- more -->

## 复现问题

### 复现环境

这是我复现该问题时的环境配置。

- 系统：MacOS 10.13.5 (17F77)
- 终端：GNU bash，版本 4.4.12(1)-release (x86_64-apple-darwin15.6.0)
- zip：系统自带的。Zip 3.0 (July 5th 2008), by Info-ZIP. Compiled with gcc 4.2.1 Compatible Apple LLVM 9.0.0 (clang-900.0.31) for Unix (Mac OS X) on Oct  6 2017.
- md5：系统自带的。

### 复现步骤

```sh
echo hahahaha > xx
rm -f a.zip b.zip
zip a.zip xx
zip b.zip xx
md5 a.zip b.zip
```

请手动一步步来执行这个步骤，不要一次性复制粘贴执行。
你会看到相同内容的 xx 文件产生的 a.zip 和 b.zip 的 md5 值是不同的。

如果你一次性复制粘贴执行该段代码，有小概率会得到相同的 md5 值。至于为何会这样，留到最后再解答。

既然已经确认结果，就考虑为何会有这样的结果。
理论上来说，相同内容的文件计算得到的 md5 必然是相同的。我假设 md5 程序运算不会出错，那么问题圈定在 zip 打包后的文件，每次内容都不一样。

因为 zip 的打包过程我们不知道，~~macOS 的闭源生态阻止我们查看源代码~~。首先想到查看是否有标准文档。

## ZIP 标准文档

> ZIP文件格式是一种数据压缩和文档储存的文件格式，原名Deflate，发明者为菲尔·卡茨（Phil Katz），他于1989年1月公布了该格式的资料。

查看[维基百科][wiki-0]第一句话就说明存在 ZIP 标准文档，其原稿是[《APPNOTE.TXT - .ZIP File Format Specification》][B1]。

粗略阅读这篇文档，我大概知道了 ZIP 文件的结构。

```txt
   4.3.6 Overall .ZIP file format:

      [local file header 1]
      [encryption header 1]
      [file data 1]
      [data descriptor 1]
      .
      .
      .
      [local file header n]
      [encryption header n]
      [file data n]
      [data descriptor n]
      [archive decryption header]
      [archive extra data record]
      [central directory header 1]
      .
      .
      .
      [central directory header n]
      [zip64 end of central directory record]
      [zip64 end of central directory locator]
      [end of central directory record]
```

意思是 ZIP 包里的每个文件，会压缩成这样的结构块

```txt
      [local file header]
      [encryption header]
      [file data]
      [data descriptor]
```

你可以根据关键词查到更细粒度的结构描述，比如 local file header 你会看到

```txt
   4.3.7  Local file header:

      local file header signature     4 bytes  (0x04034b50)
      version needed to extract       2 bytes
      general purpose bit flag        2 bytes
      compression method              2 bytes
      last mod file time              2 bytes
      last mod file date              2 bytes
      crc-32                          4 bytes
      compressed size                 4 bytes
      uncompressed size               4 bytes
      file name length                2 bytes
      extra field length              2 bytes

      file name (variable size)
      extra field (variable size)
```

zip 最后是目录记录块

```txt
      [central directory header n]
      [zip64 end of central directory record]
      [zip64 end of central directory locator]
      [end of central directory record]
```

## 搜索线索

然而阅读标准文档是最枯燥乏味的，我懒得把全文仔仔细细读一遍。
我猜 zip 文件变化是由于压缩打包过程中引入了跟时间相关的变量，于是查询关键词 `time` `date` 还有 `stamp`。
先把文档下载到本地，然后用 [ag][] 命令来搜索关键词。

![搜索 time.png](http://adoyle-me.oss-cn-beijing.aliyuncs.com/share/zip-checksum/Hyper%202018-06-30%2015-23-40.png)
![搜索 date 和 stamp.png](http://adoyle-me.oss-cn-beijing.aliyuncs.com/share/zip-checksum/Hyper%202018-06-30%2015-24-33.png)

整理一下就是 `last mod file time`，`last access time`，`creation time` 这三个线索。

那么来看一下 zip 会不会对文件时间进行修改。我用到了 gstat (GNU stat) 命令。（在 Mac 中调用 GNU 命令工具，需要装 `brew install coreutils`）

```sh
echo hahahaha > xx
gstat xx
rm -f a.zip b.zip
zip a.zip xx
gstat xx
zip b.zip xx
gstat xx
```

![gstat.png](http://adoyle-me.oss-cn-beijing.aliyuncs.com/share/zip-checksum/Hyper%202018-06-30%2017-30-46.png)

你会发现 access time 变了。再回文档找一下查询 `access time` 关键词的句子。找到三处。

```txt
A.2 Field Code  Description

   400D     IFS Access Time                     4 bytes
```

```txt
   4.5.5 -NTFS Extra Field (0x000a):

           Atime      8 bytes    File last access time


   4.5.7 -UNIX Extra Field (0x000d):

        Atime       4 bytes       File last access time
```

A.2 看起来不太像，先放着。4.5.5 和 4.5.7 都出现了 Atime 字段，结构类似，就以 4.5.7 为例来解释一下。

```txt
   4.5.7 -UNIX Extra Field (0x000d):

        The following is the layout of the UNIX "extra" block.
        Note: all fields are stored in Intel low-byte/high-byte
        order.

        Value       Size          Description
        -----       ----          -----------
(UNIX)  0x000d      2 bytes       Tag for this "extra" block type
        TSize       2 bytes       Size for the following data block
        Atime       4 bytes       File last access time
        Mtime       4 bytes       File last modification time
        Uid         2 bytes       File user ID
        Gid         2 bytes       File group ID
        (var)       variable      Variable length data field
```

意思就是有这么一个结构块，它是以 `0x000d` 开头做标志位，然后存 `TSize` 说明接下来的块大小，然后分别存 Atime，Mtime，Uid，Gid 等字段。
看起来离答案很接近了。

## 推导差异

从文档和到目前做的调查来看，基本上可以确定是因为 zip 改动了文件的 last access time，从而改变了 zip 包的内容导致 md5 值不一样。

但这依然只是猜想，我们需要决定性的证据。

于是我打算分析实际文件的字节码来跟文档比对。

### 实验步骤

写了一个简单的脚本，命名为 `s`。

```sh
#!/usr/bin/env bash
# shellcheck disable=SC1090

file=xx
echo "$1" > $file
rm -f a.zip b.zip
sleep 1   # 以防万一，下文「其他」章节会解释为什么要有这行
zip a.zip $file
zip b.zip $file
xxd -e -g 2 a.zip > a
xxd -e -g 2 b.zip > b
vimdiff a b
```

解释一下，xxd 命令是用来将二进制转成十六进制的工具，`-e` 参数是表示用小端字节序 (little-endian byte order) 显示，`-g 2` 是按 2 字节分为一组。
ZIP 标准文档里有写哪些字段是用小端存储，哪些字段是用大端存储。标准里大部分都是用小端字节序，所以用了 `-e` 参数。
P.S. 你也可以用 hexdump 命令来做进制转换。

vimdiff 是用 vim 来查看两个文件的文本差异，因为 vimdiff 不能直接用来比较二进制文件，所以先用 xxd 转成十六进制文件。

然后执行 `./s hahahaha`。

![raw-diff.png](http://adoyle-me.oss-cn-beijing.aliyuncs.com/share/zip-checksum/Hyper%202018-06-30%2018-59-26.png)

左边是 a.zip 文件的十六进制，右边是 b.zip 文件的十六进制。
你可以看到不同的就只有一个字节 `82` 和 `83`。

「搜索线索」章节找到的三处 `access time` 关键点，只要找出字节里对应的标志位就行了，即 `0x000d` `0x000a` `400D`。
结果却一个都没有找到！
试了好几次都没有！WTF

试了很多次，仔细观察和对比其实还是能发现一些共同点和差异。比如同一个文件在不同时间点 zip 多次，以及不同文件 zip 的结果。建议你自己试试，我不多赘述了。
`hahahaha` 作为文本内容不方便做标记，我换成了 `1234567890`，你可以看到这样。

![another-raw-diff.png](http://adoyle-me.oss-cn-beijing.aliyuncs.com/share/zip-checksum/Hyper%202018-06-30%2019-18-07.png)

![another-explained-raw-diff.png](http://adoyle-me.oss-cn-beijing.aliyuncs.com/share/zip-checksum/Hyper%202018-06-30%2019-18-07%202.png)

再回来看标准文档记录的 ZIP 结构，

```txt
      [local file header]
      [encryption header]
      [file data]
      [data descriptor]
```

```txt
   4.3.7  Local file header:

      local file header signature     4 bytes  (0x04034b50)
      version needed to extract       2 bytes
      general purpose bit flag        2 bytes
      compression method              2 bytes
      last mod file time              2 bytes
      last mod file date              2 bytes
      crc-32                          4 bytes
      compressed size                 4 bytes
      uncompressed size               4 bytes
      file name length                2 bytes
      extra field length              2 bytes

      file name (variable size)
      extra field (variable size)
```

`[file data]` 的位置可以根据文件内容 (1234567890) 定位到，发现变化的字节是在 `[file data]` 之前，
所以是在 `[local file header]` 或者 `[encryption header]` 里。

`[encryption header]` 是要根据 `4.5.12 -Strong Encryption Header (0x0017)` 才会写进，在进制文件里没有搜到 0017 标识。所以就没有 `[encryption header]`。
于是根据 `[local file header]` 里的顺序推算过来，发现变化的字节是在所处的位置。`file name (variable size)` 或 `extra field (variable size)` 因为这两个字段的大小是不固定的。而文件名是固定的，所以范围缩小到 extra field。

之后又经历了一番搜索，终于找到另一份文档。Apple 关于 [extra-field 部分文档][B2]。发现其中有一个标志位能在进制文件里搜到，那就是 `0x5455`。
生成了多个文件比较发现 `0x5455` 是固定的。变量范围终于圈定在 `Extended Timestamp Extra Field`。

### Apple 的 Extra fields

想到 Mac 的 zip 是 Apple 自己实现的，很可能会填充某些特殊的字段。`0x5455` 就是一例，它代替了标准文档里的 `0x000d` 和 `0x000a`。

```txt
         -Extended Timestamp Extra Field:
          ==============================

          The following is the layout of the extended-timestamp extra block.
          (Last Revision 19970118)

          Local-header version:

          Value         Size        Description
          -----         ----        -----------
  (time)  0x5455        Short       tag for this extra block type ("UT")
          TSize         Short       total data size for this block
          Flags         Byte        info bits
          (ModTime)     Long        time of last modification (UTC/GMT)
          (AcTime)      Long        time of last access (UTC/GMT)
          (CrTime)      Long        time of original creation (UTC/GMT)
```

解释一下 Size 对应的字节。

> All integer fields in the descriptions below are in little-endian (Intel) format unless otherwise specified.  Note that "Short" means two bytes, "Long" means four bytes, and "Long-Long" means eight bytes, regardless of their native sizes.  Unless specifically noted, all integer fields should be interpreted as unsigned (non-negative) numbers.

- Byte 1 字节
- Short 2 字节
- Long 4 字节
- Long-Long 8 字节

于是可以分析得到这图：

![explained-diff.png](http://adoyle-me.oss-cn-beijing.aliyuncs.com/share/zip-checksum/Hyper%202018-06-30%2018-59-26%202.png)

## 结论

变量的确是 Access Time。它存储在 local file header 的额外字段 (extra fields) 的扩展时间戳字段 (Extended Timestamp Extra Field) 中。

探索之旅终于达到了终点。

## 最后：如何使 zip 结果一致

如果你想每次 zip 打包出来的文件内容都一样，使用 `-X` 或 `--no-extra` 参数可以避免将 extra fields 打包进去。

```sh
echo hahahaha > xx
rm -f a.zip b.zip
zip -X a.zip xx
zip -X b.zip xx
md5 a.zip b.zip
```

每次结果都是一致的。

## 其他

### 为什么有时两次 md5 值是一样的？

写了另一个脚本，命名为 `d`。

```sh
#!/usr/bin/env bash
# shellcheck disable=SC1090

file=xx
echo "$1" > $file
# 为了方便，grep 带上 Access: 2018 这个前缀，2018 年以后的读者请自行修改脚本
gstat $file | grep 'Access: 2018'
rm -f a.zip b.zip
zip a.zip $file >/dev/null
gstat $file | grep 'Access: 2018'
zip b.zip $file >/dev/null
gstat $file | grep 'Access: 2018'
diff a.zip b.zip
```

轮询 100 次 `for i in {1..100}; do ./d hahahaha;echo ""; done`。

然后统计结果可以发现，zip 里存的 access time 只精确到秒，如果两次 zip 的时间 `YYYY-MM-DD HH-mm-SS` 都一样，则两次 zip 文件内容结果相同。

（其实也可以不用做实 (zhuang) 验 (bi)，ZIP 文档里写着 access time 的格式是 The time values are in standard Unix signed-long format, indicating the number of seconds since 1 January 1970 00:00:00，说明只记录秒数。）

在 `echo "$1" > $file` 这步 AcTime 已经确定，当 `zip a.zip $file` 时读取 file 文件的 Actime 计算打包，结束时刷新 file 的 AcTime。
这两步的 AcTime 决定了最后两个 zip 包的内容是否完全一样。
上文的 `s` 脚本里加上 `sleep 1` 就是为了保证让两次 AcTime 差在一秒以上。

### mac 的 zip 源代码

在撰写本文的过程中发现，mac 的 zip 其实是[开源的][1]……我找了一下获取 access time 的[代码](https://opensource.apple.com/source/zip/zip-6/zip/zip/zipfile.c.auto.html)，搜索 `local int ef_scan_ut_time(ef_buf, ef_len, ef_is_cent, z_utim)` 函数，能找到下面这段代码。

```c
if (flags & EB_UT_FL_ATIME) {
  if ((eb_idx+4) <= eb_len) {
      z_utim->atime = LG((EB_HEADSIZE+eb_idx) + ef_buf);
      eb_idx += 4;
      Trace((stderr,"  Unix EF acctime = %ld\n", z_utim->atime));
  } else {
      flags &= ~EB_UT_FL_ATIME;
  }
}
```

`LG` 是转成小端字节序的函数。
`EB_UT_FL_ATIME` 和 `EB_HEADSIZE` 的定义都能在 [zip.h 文件](https://opensource.apple.com/source/zip/zip-6/zip/zip/zip.h.auto.html) 里找到。
`ef_buf` 是来自 zlist 的 extra 字段。

```c
/* Structures for in-memory file information */
struct zlist {
  /* See central header in zipfile.c for what vem..off are */
  ush vem, ver, flg, how;
  ulg tim, crc, siz, len;
  extent nam, ext, cext, com;   /* offset of ext must be >= LOCHEAD */
  ush dsk, att, lflg;           /* offset of lflg must be >= LOCHEAD */
  ulg atx, off;
  char *name;                   /* File name in zip file */
  char *extra;                  /* Extra field (set only if ext != 0) */
  char *cextra;                 /* Extra in central (set only if cext != 0) */
  char *comment;                /* Comment (set only if com != 0) */
  char *iname;                  /* Internal file name after cleanup */
  char *zname;                  /* External version of internal name */
  int mark;                     /* Marker for files to operate on */
  int trash;                    /* Marker for files to delete */
  int dosflag;                  /* Set to force MSDOS file attributes */
  struct zlist far *nxt;        /* Pointer to next header in list */
};
```

### zipinfo

在探索过程中我偶然发现 `zipinfo` 这个命令，非常好用。比如

```sh
𝕬 zipinfo a.zip

Archive:  a.zip
Zip file size: 161 bytes, number of entries: 1
-rw-r--r--  3.0 unx        7 tx stor 18-Jun-30 16:03 xx
1 file, 7 bytes uncompressed, 7 bytes compressed:  0.0%
```

这里 `unx` 里的 `x` 是一个标志位，它代表文件包含 extra field。具体解释可以看 `man zipinfo`，查找 `extra field` 关键字：

```txt
The second character may also take on four values, depending on  whether
there  is an extended local header and/or an ``extra field'' associated with the file (fully explained in PKWare's APPNOTE.TXT,
but basically analogous to pragmas in ANSI C--i.e., they provide a standard way to include non-standard information in the  ar-
chive).  If neither exists, the character will be a hyphen (`-'); if there is an extended local header but no extra field, `l';
if the reverse, `x'; and if both exist, `X'.  Thus the file in this example is (probably) a text file, is  not  encrypted,  and
```

它还能将 zip 文件的内容翻译出来，执行 `zipinfo -v <file>`。

```sh
𝕬 zipinfo -v a.zip

Archive:  a.zip
There is no zipfile comment.

End-of-central-directory record:
-------------------------------

  Zip archive file size:                       161 (00000000000000A1h)
  Actual end-cent-dir record offset:           139 (000000000000008Bh)
  Expected end-cent-dir record offset:         139 (000000000000008Bh)
  (based on the length of the central directory and its expected offset)

  This zipfile constitutes the sole disk of a single-part archive; its
  central directory contains 1 entry.
  The central directory is 72 (0000000000000048h) bytes long,
  and its (expected) offset in bytes from the beginning of the zipfile
  is 67 (0000000000000043h).


Central directory entry #1:
---------------------------

  xx

  offset of local header from start of archive:   0
                                                  (0000000000000000h) bytes
  file system or operating system of origin:      Unix
  version of encoding software:                   3.0
  minimum file system compatibility required:     MS-DOS, OS/2 or NT FAT
  minimum software version required to extract:   1.0
  compression method:                             none (stored)
  file security status:                           not encrypted
  extended local header:                          no
  file last modified on (DOS date/time):          2018 Jun 30 16:03:10
  file last modified on (UT extra field modtime): 2018 Jun 30 16:03:09 local
  file last modified on (UT extra field modtime): 2018 Jun 30 08:03:09 UTC
  32-bit CRC value (hex):                         16b28489
  compressed size:                                7 bytes
  uncompressed size:                              7 bytes
  length of filename:                             2 characters
  length of extra field:                          24 bytes
  length of file comment:                         0 characters
  disk number on which file begins:               disk 1
  apparent file type:                             text
  Unix file attributes (100644 octal):            -rw-r--r--
  MS-DOS file attributes (00 hex):                none

  The central-directory extra field contains:
  - A subfield with ID 0x5455 (universal time) and 5 data bytes.
    The local extra field has UTC/GMT modification/access times.
  - A subfield with ID 0x7875 (Unix UID/GID (any size)) and 11 data bytes:
    01 04 f5 01 00 00 04 14 00 00 00.

  There is no file comment.
```

注意这里的 file last modified 并不是 extra field 里的值，而是 local file header 里的 last mod file time 和 last mod file date 字段。

`zipinfo` 没有翻译 extra field 内部的内容，所以你看不到 access time 的值，只是简要说明了一下：

```txt
  The central-directory extra field contains:
  - A subfield with ID 0x5455 (universal time) and 5 data bytes.
    The local extra field has UTC/GMT modification/access times.
  - A subfield with ID 0x7875 (Unix UID/GID (any size)) and 11 data bytes:
    01 04 f5 01 00 00 04 14 00 00 00.
```

## 参考 (Bibliographies)

- [PKWARE - APPNOTE.TXT - .ZIP File Format Specification][B1]
- Apple 开源的 zip 项目中关于 [extra-field 部分文档][B2]

<!-- 以下是相关链接 -->

[B1]: https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT
[B2]: https://opensource.apple.com/source/zip/zip-6/unzip/unzip/proginfo/extra.fld
[wiki-0]: https://www.wikiwand.com/zh-hans/ZIP%E6%A0%BC%E5%BC%8F
[1]: https://opensource.apple.com/source/zip/
[ag]: https://github.com/ggreer/the_silver_searcher
