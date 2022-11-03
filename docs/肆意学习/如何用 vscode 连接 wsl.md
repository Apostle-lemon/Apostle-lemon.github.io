# 如何用 Vscode 连接 Wsl

参考这篇文章的内容即可  
[Developing in the Windows Subsystem for Linux with Visual Studio Code](https://code.visualstudio.com/docs/remote/wsl#:~:text=From%20VS%20Code,-Alternatively%2C%20you%20can&text=Start%20VS%20Code.,menu%20to%20open%20your%20folder.)

如何为 wsl 指定 CPU 核心的数目，请查阅这篇文章  

[Advanced settings configuration in WSL | Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig)  

当然你可能会惊讶的发现，即便是修改了 .wslconfig 仍然没有变化，那么可能因为你是 utf-8 格式保存的，而不是以 ansi 编码保存的文件。这个解决方案是从这里看来的 [WSL入坑与踩坑_guokaijietti的博客-CSDN博客](https://blog.csdn.net/guokaijietti/article/details/108966012)
