# Mkdocs 深度设置

mkdocs 渲染仍然有很多不支持的功能，这些我们想要但它不提供的功能则需要我们以添加插件的形式来使用。

## 双链

通过如下链接可以解决双链的渲染问题 [orbikm/mkdocs-ezlinks-plugin: Plugin for mkdocs which enables easier linking between pages (github.com)](https://github.com/orbikm/mkdocs-ezlinks-plugin)

## Mkdocs 本地调试

由于网页的热加载在 github page 上的话会消耗很长的时间用于 git push 以及 mkdocs 的 build。因此我们需要知道如何在本地查看到我们 mkdocs 的内容。这里我们就需要本地调试。

我们需要执行`mkdocs serve`，之后便可以在本地地址 <http://127.0.0.1:8000/> 上看到 mkdocs 的内容。
