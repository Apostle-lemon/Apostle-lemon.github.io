# Socket AI

socket AI 做的事情是将 chatgpt 应用于检查 npm 和 PyPI 包

静态分析方法不能 capturing all the subtleties  
人工分析方法费用过高。

socket AI 发布了一个人人都可以使用的，ai driven 的漏洞检测应用。这个应用的漏洞检测是 AI 驱动的，这是和大模型没有关系的。当在一个软件包中检测到潜在问题时，应用会标记它进行审查，并请求ChatGPT总结其发现。

当 socket 识别出问题后，会将开源代码交给 chatGPT 来评估风险，这样增加了额外的审阅者。

由于 chatgpt 的上下文窗口是有限的，因此对于极大的文件或者跨文件，并不能表现出良好的效果。

LLM 