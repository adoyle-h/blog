# ADoyle's Blog

个人博客，请勿 fork，可以 star 或 watch。

不喜勿喷。

## 渲染

博客文章使用 markdown 编写，单行换行(`<br/>`)，空行分段。

使用 [hexo][] 渲染。
主题是 [adoyle-h/hexo-theme-fluid](https://github.com/adoyle-h/hexo-theme-fluid)。

## 分支

- gh-pages: 生成 github page
- master: gh-pages 的源文档。稳定，不会重写提交历史。包括草稿等修改都在这个分支上进行。

## 文档

- 未发布文档: source/_drafts
- 已发布文档: source/_posts

## 本地开发

- `make init` 初始化项目
- `make serve` 启动 http 服务并动态渲染
- `./draft name` 创建新的草稿
- `./post name` 创建新的文档

## Git commit message

message 遵循以下格式之一:

- post(post-name): publish/update/fix ...
- draft(draft-name): add/update/fix ...
- other: ...

## 提意见

欢迎建 issue 提意见，或者直接在文章下的评论栏里留言。

## [版权声明](http://adoyle.me/blog/copyright.html)

未经作者授权，严禁全文转载。违者必究。
具体规则请阅读版权声明。


<!-- links -->

[hexo]: https://github.com/hexojs/hexo
