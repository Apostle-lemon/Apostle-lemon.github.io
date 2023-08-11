# Rust 权威指南

在 Rust 中，我们把代码的集合称作包 (crate).

crate 是 Rust 中最⼩的编译单元，package 是单个或多个 crate 的集合，crate 和 package 都可以被叫作包，因为单个 crate 也是⼀个 package，但 package 通常倾向于多个 crate 的组合。本书中，crate 和 package 统⼀被翻译为包，只在两者同时出现且需要区别对待时，将 crate 译为单元包，将 package 译为包。

在 Rust 程序中，我们约定俗成地使⽤以下画线分隔 的全⼤写字⺟来命名⼀个常量，并在数值中插⼊下画线来提⾼可读性。

在英语技术⽂档中，参数变量和传⼊的具体参数值有⾃⼰分别对应的名称 parameter 和 argument .
