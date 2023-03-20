# Mapreduce

mapreduce：MapReduce 是一种编程模型及其相关实现，用于处理和生成大型数据集。

map : Map 函数，用于处理键/值对，生成一组中间键/值对。

reduce：Reduce 函数，将与同一个中间键相关联的所有中间值进行合并。

![](https://lemonapostlepicgo.oss-cn-hangzhou.aliyuncs.com/img/202303072353559.png)

mapreduce 的核心工作原理即如图所示。

mapreduce 首先限制了用户编写的函数类型，即用户必须提供两种函数，一种是将一个 key/value 键值对生成一组 key/value 键值对的 map 函数，另一种是可以将 key/\< the values which have the same key\> 生成零个或一个输出（这个输出仍然可以是数组）

![](https://lemonapostlepicgo.oss-cn-hangzhou.aliyuncs.com/img/202303072356549.png)

下面是一个 map 和 reduce 函数的例子。这个 mapreduce 函数可以被用来数出每个文章中，每个词出现了多少次。在 map 函数中，其会输出在给定的一个 document name 中，{word, 1} 这样的 key/value 组。而 reduce 函数则会将具有相同的 key（在这个例子中，相同的 key 就代表了相同的 word）的所有 value 相加，以统计每个词出现了多少次。

我们可以看到在 mapreduce 框架中，output file 一般是不会聚合成一个 file 的，因为这些 output file 接下来可能会作为其他的 mapreduce 的输入，或者是将这些输出应用在其他的基于分布式系统的应用上。

mapreduce 框架中采取了一些措施来保证数据的一致性，错误恢复，采用了 locality 即将执行 map 函数这个 task 分配给那些距离源数据较近的物理机，以节省网络带宽这一宝贵的资源。
