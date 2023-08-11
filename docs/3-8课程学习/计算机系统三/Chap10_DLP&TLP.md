# DLP&TLP

vector processor 向量机 scalar processor 标量机  
array processor 阵列机

【有例题】

注意是 8 个 beat

阵列机需要有 ICN，interconnection network。有立方体网络 cube interconnection network 和 PM（plus minus）2I single-stage interconnection network 两种形式。【放2个公式】

Shuffle exchange 网络 【有一个公式】

linear array, circular array, loop with chord array, tree array, extensions of tree array, star array, grid, 2d torus, hypercube, cube with loop

multi-stage interconnection network: 不同的多级互连网络区分在于 1 switch unit，switch unit 可以内部有 switch function 2 topology 即由什么网络构成在一起。每一 level 的 input 和 output 是怎么连接的, 即怎么绑定在一起 3 control mode

multi-stage cube interconnection 为例。有多少个阶段采用 log 进行计算。cube 只对二输入产生二输出。每个 switch 究竟与什么编号的线进行连接取决于 switch function。 cube0 产生的影响：相邻两个。cube1 产生的影响：4个，4567->6745。cube2 : 8 个。cube012 和几组几元不是简单的对应，而是稍微复杂的对应，但是 cube 的状态可以直接通过 f() 得出。

一组4元的交换，指的是输入是 ABCD，输出是 DCBA。

multi-stage shuffle exchange network 又被称为 omega network，它是 cube 网络的逆网络。

【真数据相关，反相关，输出相关一定会考】
