# Lab3 实验文档

## 0. 前言

Lab3 实验建立在 Lab2 的基础上，带领大家进一步理解源代码到 IR 的生成过程。同前置实验一样，需要你使用 `LightIR` 框架自动产生 `cminus-f` 语言的 LLVM IR。经过 Lab2 的练手，相信你已经初步掌握了 LightIR 的使用，并且对于 LLVM IR 也有了一定的理解。

在本次实验中，你的 **核心任务** 是使用访问者模式来实现 IR 的自动生成。完成这一阶段后，调用 clang 从 IR 进一步生成可执行文件，这样一个初级的 cminus-f 编译器就完成了。

### 主要工作

1. 阅读 [cminus-f 的语义规则](../common/cminusf.md)，我们将按照语义实现程度进行评分
2. 阅读 [LightIR 核心类介绍](../common/LightIR.md)
3. 阅读 [实验框架](#1-实验框架)，理解如何使用框架以及注意事项
4. 修改 `src/cminusfc/cminusf_builder.cpp` 来实现 IR 自动产生的算法，使得它能正确编译任何合法的 cminus-f 程序。
5. 在 `report.md` 中解释你的设计，遇到的困难和解决方案

**友情提示**：

1. 助教们在 `cminusf_builder.cpp` 中提供了基础实现，比如 `CminusfBuilder::visit(ASTFunDeclaration &node)` 等函数。这些函数为示例代码，请你在开始实验前先 **仔细阅读学习** 文件中的这些代码片段，理解其含义和作用。
2. 助教们在 `cminusf_builder.cpp` 提供的部分函数是不完整的，无法通过所有测试用例。需要你补充代码的地方已经用 `TODO` 标出。我们提供的 `cminusf_builder.cpp` 只可以满足测试用例 `lv0_1` 中的 `return.cminus`。虽然 `eval.py` 会显示其他一些测试用例也是 `success`，但它对应的 `.ll` 文件是不正确的，不要因其显示 `success` 忽略了对应的代码补充，那会影响你后面较复杂样例的正确性。
3. 简要阅读 `cminusf_builder.hpp` 和其他头文件中定义的函数和变量，理解项目框架也会为你的实验提供很大的帮助。
4. 请独立完成实验，不要抄袭他人代码。
5. 为方便同学们更好完成实验，补充提示文档，参见 [Lab3 More Tips](./more-tips.md)。

## 1. 实验框架

本次实验使用了由 C++ 编写的 LightIR 来生成 LLVM IR。为了便于大家进行实验，该框架自动完成了语法树到 C++ 上的抽象语法树的转换。

我们可以使用 [访问者模式](../2-ir-gen-warmup/README.md#31-%E4%BA%86%E8%A7%A3-visitor-pattern) 来设计抽象语法树中的算法。大家可以参考 [lab2的样例](../../tests/2-ir-gen-warmup/calculator/calc_builder.cpp) 和 [打印抽象语法树的算法](../../src/common/ast.cpp#L394-737)，

以及运行 `test_ast` 来理解访问者模式下算法的执行流程。

在 `include/cminusf_builder.hpp` 中，我们还定义了一个用于存储作用域的类 `Scope`。它的作用是辅助我们在遍历语法树时，管理不同作用域中的变量。它提供了以下接口：

```cpp
// 进入一个新的作用域
void enter();
// 退出一个作用域
void exit();
// 往当前作用域插入新的名字->值映射
bool push(std::string name, Value *val);
// 根据名字，寻找到值
Value* find(std::string name);
// 判断当前是否在全局作用域内
bool in_global();
```

你需要根据语义合理调用 `enter` 与 `exit`，并且在变量声明和使用时正确调用 `push` 与 `find`。在类 `CminusfBuilder` 中，有一个 `Scope` 类型的成员变量 `scope`，它在初始化时已经将 `input`、`output` 等函数加入了作用域中。因此，你们在进行名字查找时不需要顾虑是否需要对特殊函数进行特殊操作。

## 2. 运行与调试

### 2.1 构建并运行 Cminusfc

```sh
cmake ..
make clean
make -j
# 安装库 libcminus_io.a 至系统目录
make install
```

编译后会产生 `cminusfc` 程序，它能将 cminus 文件输出为 LLVM IR，也可以利用 clang 将 IR 编译成二进制可执行文件。程序逻辑写在 `src/cminusfc/cminusfc.cpp` 中。

当需要对 `.cminus` 文件测试时，可以这样使用：

```sh
# 假设 cminusfc 的路径在你的$PATH中
# 1. 利用构建好的 Module 生成 test.ll
# 注意，如果调用了外部函数，如 input, output 等，则无法使用lli运行
cminusfc test.cminus -emit-llvm

# 假设libcminus_io.a的路径在$LD_LIBRARY_PATH中，clang的路径在$PATH中
# 1. 利用构建好的 Module 生成 test.ll
# 2. 调用 clang 来编译 IR 并链接上静态链接库 libcminus_io.a，生成二进制文件 test
cminusfc test.cminus
```

### 2.2 测试

自动测试脚本和所有测试样例都是公开的，它在 `tests/3-ir-gen` 目录下，使用方法如下：

```sh
# 在 tests/3-ir-gen 目录下运行：
./eval.py
```

测试结果会输出到同文件夹的 `eval_result` 下。

### 2.3 日志工具

分析输出日志是进行程序调试的好方法，为方便大家进行实验，助教们提供了一个轻量级的日志分析工具 `logging`，可分等级打印调试信息，更详细的说明请阅读 [使用文档](../common/logging.md)。

### 2.4 一些建议

1. 请比较通过你编写的编译器产生的 IR 和通过 clang 产生的 IR 来找出可能的问题或发现新的思路
2. 可以使用 logging 工具来打印调试信息
3. 可以使用 GDB 等软件进行动态分析，可以单步调试来检查错误的原因

## 3. 实验要求

### 3.1 目录结构

```
.
├── CMakeLists.txt
├── Documentations
│   ├── ...
│   ├── common
│   |   ├── LightIR.md                  <- LightIR 相关文档
│   |   ├── logging.md                  <- logging 工具相关文档
│   |   └── cminusf.md                  <- cminus-f 的语法和语义文档
│   └── 3-ir-gen
│       └── README.md                   <- lab3 实验文档说明（你在这里）
├── include                             <- 实验所需的头文件
│   ├── ...
│   ├── lightir/*
│   ├── cminusf_builder.hpp
|   └── ast.hpp
├── Reports
│   ├── ...
│   └── 3-ir-gen
│       └── report.md                   <- lab3 所需提交的实验报告，请详细说明你们的设计（需要上交）
├── src
│   ├── ...
│   └── cminusfc
│       ├── cminusfc.cpp                <- cminusfc 的主程序文件
│       └── cminusf_builder.cpp         <- lab3 需要修改的文件，你们要在该文件中用访问者模式实现自动 IR 生成的算法（需要上交）
└── tests
    ├── ...
    └── 3-ir-gen
        ├── testcases                   <- 助教提供的测试样例
        ├── answers                     <- 助教提供的测试样例
        └── eval.py                     <- 助教提供的测试脚本

```

# logging 工具使用

## 介绍
为了方便同学们在之后的实验中 debug，为大家设计了一个C++简单实用的分级日志工具。该工具将日志输出信息从低到高分成四种等级：`DEBUG`，`INFO`，`WARNING`，`ERROR`。通过设定环境变量`LOGV`的值，来选择输出哪些等级的日志。`LOGV`的取值是**0～3**,分别对应到上述的4种级别(`0:DEBUG`,`1:INFO`,`2:WARNING`,`3:ERROR`)。此外输出中还会包含打印该日志的代码所在位置。

## 使用
项目编译好之后，可以在`build`目录下运行`test_logging`，该文件的源代码在`tests/test_logging.cpp`。用法如下：
```cpp
#include "logging.hpp"
// 引入头文件
int main(){
    LOG(DEBUG) << "This is DEBUG log item.";
    // 使用关键字LOG，括号中填入要输出的日志等级
    // 紧接着就是<<以及日志的具体信息，就跟使用std::cout一样
    LOG(INFO) << "This is INFO log item";
    LOG(WARNING) << "This is WARNING log item";
    LOG(ERROR) << "This is ERROR log item";
    return 0;
}
```

接着在运行该程序的时候，设定环境变量`LOGV=0`，那么程序就会输出级别**大于等于0**日志信息：
```bash
user@user:${ProjectDir}/build$ LOGV=0 ./test_logging
[DEBUG] (test_logging.cpp:5L  main)This is DEBUG log item.
[INFO] (test_logging.cpp:6L  main)This is INFO log item
[WARNING] (test_logging.cpp:7L  main)This is WARNING log item
[ERROR] (test_logging.cpp:8L  main)This is ERROR log item
```
输出中除了包含日志级别和用户想打印的信息，在圆括号中还包含了打印该信息代码的具体位置（包括文件名称、所在行、所在函数名称），可以很方便地定位到出问题的地方。

假如我们觉得程序已经没有问题了，不想看那么多的DEBUG信息，那么我们就可以设定环境变量`LOGV=1`，选择只看**级别大于等于1**的日志信息：
```bash
user@user:${ProjectDir}/build$ LOGV=0 ./test_logging
[INFO] (test_logging.cpp:6L  main)This is INFO log item
[WARNING] (test_logging.cpp:7L  main)This is WARNING log item
[ERROR] (test_logging.cpp:8L  main)This is ERROR log item
```
当然`LOGV`值越大，日志的信息将更加简略。如果没有设定`LOGV`的环境变量，将默认不输出任何信息。

这里再附带一个小技巧，如果日志内容多，在终端观看体验较差，可以输入以下命令将日志输出到文件中：
```
user@user:${ProjectDir}/build$ LOGV=0 ./test_logging > log
```
然后就可以输出到文件名为log的文件中啦～
