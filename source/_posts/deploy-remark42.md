---
title: 部署 Remark42 评论系统
author: ADoyle <adoyle.h@gmail.com>
copyright: >-
  未经授权，不得全文转载。转载前请先阅读<a rel="license" target="_blank"
  href="//adoyle.me/blog/copyright.html">本站版权声明</a>
date: 2023-04-07 13:34:45
updated: 2023-04-07 13:34:45
---

之前我的博客一直用 [Disqus](https://disqus.com/) 评论系统，但它有几个缺点：

1. 被墙。虽然可以用 [DisqusJS](https://github.com/SukkaW/DisqusJS) 来反向代理到 Disqus，但是只能看不能发评论。
2. 邮件通知需要开通付费功能。

[Remark42](https://remark42.com/) 的优点：

1. 数据由自己掌控。
   - 需要自己部署，支持 Docker。
   - 数据存在一个文件里，类似 sqlite。很轻量级。
2. 支持各种应用的 Oauth 登录。
   - 但需要自己去每个平台里配置 Oauth App，挺麻烦的。如果没配置，就只能用最基础的 username+email 登录。
3. 支持邮件通知。
4. 支持 Markdown 语法。
5. 支持 Emoji。
4. 支持匿名评论。（不过我的博客没有开，必须绑定邮箱才能留言）
5. 支持评论排序。
6. 支持评论点赞和踩的功能。
7. 支持暗黑配色。

<!-- more -->

## 从 Disqus 导入数据到 Remark42

主要看[这篇文章](https://remark42.com/docs/backup/migration/)。

使用 `docker exec -it remark42 import` 时有两个坑

### 需要改 xml 数据

当你从 Disqus 导出 xml 数据后，你需要修改里面的 `<link>`。因为它存的是完整的 url。而你渲染页面一般只用到 path，不需要 protocol 和 domain。所以你需要全量替换一下。

你可以向 Remark42 服务器发起 POST 请求来看是否匹配 link，不过首先要启用[评论计数功能](#评论计数)。

```
POST https://remark-blog.woxiang.fun/api/v1/counts

POST BODY: ["/path"]
```

如果 link 匹配，则会返回对应的评论数。如果没匹配，评论数为 0。

### ssl 证书问题

因为我给 Remark42 配置填的是 `REMARK_URL=https://...` 的，执行 `remark42 import` 实际上是根据 xml 数据重新通过，需要用到 ssl 证书，它在 docker 里执行可能容器里没有网站的证书。

两种解决方案：

1. 创建容器后，手动把证书复制到容器里。`docker cp .cert remark42:/etc/ssl/certs`。
2. 创建容器前，先把证书下载到你本机的 /etc/ssl/certs，创建容器时挂载 volume。`-v /etc/ssl/certs:/etc/ssl/certs`。

## 评论计数

Remark42 支持[评论计数 (Counter Widget)](https://remark42.com/docs/configuration/frontend/#counter-widget)。

在你的 Remark42 配置里加上 `components: ["counter"]` 就可以启用，默认是关闭的。

然后在 html 里添加 `<span class="remark42__counter"></span>`，它会在浏览器加载完 Remark42 后自动找到这个 span，然后在里面加上评论数。比如变成这样 `<span class="remark42__counter">7</span>`。

## 推荐的配置项

有些配置项默认是关闭的，建议开起来。

- TIME_ZONE=Asia/Shanghai
- EMOJI=true
- ALLOWED_HOSTS='self',remark42.yourdomain.com,http://localhost:12000,http://127.0.0.1:12000
- AUTH_SAME_SITE=none

## 修改 CSS 样式

因为 remark42 是在 iframe 里的，无法直接应用 CSS。有两种解决方法：

1. 用 js 等 remark42 加载完毕后添加 css。
2. 在你的反向代理网关中将 `/web/remark.css` 代理到你的文件。如果你开了 last-comment 插件，还要代理 `/web/last-comments.css`。具体参考[这篇文章](https://maxmastalerz.com/blog/how-to-customize-remark42-css-via-a-proxy-workaround) ([链接备份](https://web.archive.org/web/20211027163406/https://maxmastalerz.com/blog/how-to-customize-remark42-css-via-a-proxy-workaround/))。

```
server {
    listen      80;
    server_name remark42.yourdomain.com;

    #...

    location = /web/remark.css {
        alias /path/to/your/remark-updated.css;
    }

    location = /web/last-comments.css {
        alias /path/to/your/last-comments-updated.css;
    }

    location /web-orig/ {
        # 这里的 localhost:8080 是你部署的 remark42 进程监听的地址
        proxy_pass http://localhost:8080/web/;
    }
}
```

然后在你的 remark-updated.css 内容是这样：

```
@import '/web-orig/remark.css';

/* As an example, let's remove the padding from around the Remark42 comment box. */
body {
	padding: 0;
}
```

last-comments.css 同理

```
@import '/web-orig/last-comments.css';
```

另外可以关注 [remark42/issues/5](https://github.com/umputun/remark42/issues/5) 看看官方有没有提供解决方案。


## Remark42 缓存问题

Remark42 的静态资源文件 (embed.mjs, iframe.html, remark.mjs, remark.css) 都设置了 `Cache-Control: max-age=3600, no-cache`。参考[讨论](https://github.com/umputun/remark42/discussions/1549)。

你可以在 nginx 里将 response 的 Cache-Control header 给改掉，使客户端缓存。
