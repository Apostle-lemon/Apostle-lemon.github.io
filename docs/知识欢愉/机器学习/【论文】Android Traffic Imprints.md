# Mass Discovery of Android Traffic Imprints Through Instantiated Partial Execution

## 0 Abstract

我们可以根据网络流量中，是否含有一个 APP 的签名信息 ( individual traffic signature，在这文章也叫做 imprints)，来判定此网络流量是否由一个 APP 发起。

以往的方式是通过自动工具访问 APP 的 UI 界面，以此来产生各种流量，对这些流量进行分析，得到 imprints。但是这种传统的方式有缺点：① 耗时长 ② 覆盖率低。

这篇文章介绍了一种叫 Tiger 的技术，将程序分段。而后通过实例化的方式，移除那些对 APP 产生流量中不变量 (e.g., a special URL, a key-value pair, a hidden app ID used by the developer) 没有影响的变量，这样可以大大加速分析进程。并且同时保证了正确率。

## 1 Introduction

对于安卓 APP 而言，简单的通过 协议，端口，主机名等方式不能判定网络流量是否由它产生。

## 2 Background

没啥要点。

## 3 Finding Imprints with Tiger

首先介绍了这个 Tiger 的框架。Tiger 当中最重要的部分是 instantiated partial execution (IPE) engine。

![](img/9208b2f653e0892a2be3666fe70dda9e_MD5.png)

预处理阶段 PRE-PROCESSOR，会将应用程序反汇编成中间表示。然后在应用程序的不同方法之间会构建调用图 call graph，对于涉及网络 API 的部分 ($network\ sink$)，则会创建控制流图 control flow graph。预处理阶段的主要目的是将数据转换成利于 IPE 处理的方式。

IPE 拿到的是 network sinks CFG。IPE 阶段的主要目的是找到影响这个 sinks 输出中的不变量的语句。

![](img/89568f9667a2848b23bdb11e5472e9ee_MD5.png)

我们以这张图片为例子，假设 V3 是这个 network sink 的 output。在 Tiger 语言中，采用了一种叫做相关树 PDT $Possibly Dependent Tree$ 的数据结构（理解成树就好）。这个树的根是 v3，即这个 sink 的输出内容。每个叶子节点的子节点，是对叶子节点的值有影响的变量或者函数。

对于变量而言，我们很容易评估其对最后的输出产生的影响，例如这里 v3 = v2。

对于函数而言，则会需要对 cfg 进行分析。如果对所有的函数方法执行这样的分析，复杂性会很高，tiger 采用了两种方式来避免陷入那些难以处理的数据结构。

一种方式是定位变量的来源，Sources of invariants and coarse slicing。这个方法的原理是，一个 app 的网络签名通常来自程序中的一些不变值，例如 constants, resource and manifest fles。这样的话对于影响输出的函数来说，ide 检查 CG，提取函数调用的子图，来查看子图中是否含有不变值（例如，android.os.Bundle.getStringArray() 用于从清单中读取，android.content.res.Resources.getString() 用于访问资源文件）。如果这个函数不含有不变值，那我们就不再需要分析这个函数。例如图 3 中的 D 函数不再需要进行分析，因为它只存在获取地址位置的 API。

另外一种方式则是差分分析，Differential analysis。这个方法是用来减少函数参数的分析的。函数会有输入的参数，我们假设为 $I_1,I_2,…,I_n$ 和返回值 R。假设我们已经知道了 $I_1,I_2,…,I_K$ 不会对返回的不变量产生影响，而 $I_{k+1},I_{k+2},…,I_{n}$ 我们并不知道其是否会对返回中的不变量产生影响。我们首先需要做的是确定不变量，我们会将 $I_{k+1},I_{k+2},…,I_{n}$ 的值固定，而采用两组不同 $I_1,I_2,…,I_K$ 赋值，运行这个函数两遍，找到返回值 R 中不变的因素，这个因素（我们不妨叫做 M，方便阐述）就是不变量。然后对于 $I_{k+1},I_{k+2},…,I_{n}$ 中的每一项，例如我们先选取 $I_{k+1}$，我们给予他不同的值，检查 M 是否发生了改变。如果 M 没有发生改变，那么说明这个 $I_{k+1}$ 对不变量没有贡献，因此可以直接实例化这个参数。

如果一个变量或者函数对于这个 APP 网络流量中的 invarient 没有贡献，那么就会采用实例化的方式，减少对其的分析。

当我们拥有了所有与网络不变量不相关的函数/变量后，Tiger 使用不同的参数（用于实例化与不相关变量的不同值）运行两次。然后，将 HTTP 消息中的常见部分（包括常见键、值和其他 URL 元素的集合）标识为该流量的 token（可以理解成签名？）。

由于我们是将程序进行切片的，因此在获得了所有切片的 token 后，我们会取一个并集。并且这个并集进行一个内容检查，与其他的通用的应用程序的 token 相比较，如果一个 token 是非常常见的，就从并集中删除这个元素。

这样，我们最终得到的这个并集就被称为 prints，也即这个 APP 的网络标记。
