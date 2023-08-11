# Lemon 大纲

由于浙大的编译原理实验指导太过于 fly bitch，因此我们参考了《编译原理与实践》，且参考了中科大的实验指导，整体采用了中科大的框架，实现了 Cminus。下面的实践采用的是 linux 环境。

## PART 0 - Environment

我们采用了 docker 镜像进行环境的配置，这样便不再需要配置 bison, flex, llvm 以及系统路径等操作。我们通过共享文件夹的操作使得不用进入容器内部进行编辑。

一些 docker 的常用命令

```bash
docker version # 查看 Docker 版本
docker run hello-world # 运⾏ hello-world 容器
docker ps -a # 查看所有容器
docker images # 查看所有镜像（也可以⽤ docker image ls）
docker pull ksqsf/llvm # 拉取 ksqsf/llvm 镜像
docker create --name compiler-labs ksqsf/llvm 
docker start -ai compiler-labs # 启动 compiler-labs 容器，并进⼊交互模式
docker rm compiler-labs # 删除 compiler-labs 容器
```

共享文件夹设置

`docker create --name compiler-labs -v "$(pwd):/labs" -it ksqsf/llvm`  

进入容器环境  
`docker start -ai compiler-labs`

我们在进入了容器环境后，就可以在 `/labs` 中看到我们的宿主机上的一系列文件。

## PART 1 - Lexer and Parser

这一部分需要完成基于 `flex` 的词法分析器和基于 `bison` 的语法分析器。

为了完成基于 flex 的词法分析器，我们需要完善 src/parser/lexical_analyzer.l 这个文件。为了完成语法分析器，我们需要完成 `src/parser/syntax_analyzer.y` 这个文件。

### 编译、运行和测试

由于我们使用了 docker 环境，因此这部分变得十分简单。

- 编译

```sh
$ mkdir build
$ cd build
$ cmake ..
$ make
```

如果构建成功，会在该目录下看到 `lexer` 和 `parser` 两个可执行文件。

- 运行

```sh
# 词法测试
$ ./build/lexer ./tests/parser/normal/local-decl.cminus
Token	      Text	Line	Column (Start,End)
280  	       int	0	(0,3)
284  	      main	0	(4,8)
272  	         (	0	(8,9)
282  	      void	0	(9,13)
273  	         )	0	(13,14)

# 语法测试
$ ./build/parser ./tests/parser/normal/local-decl.cminus
>--+ program
|  >--+ declaration-list
|  |  >--+ declaration
```

- 验证  
  可以使用 `diff` 与标准输出进行比较。

  ```sh
  $ cd 2022fall-Compiler_CMinus
  $ export PATH="$(realpath ./build):$PATH"
  $ cd tests/parser
  $ mkdir output.easy
  $ parser easy/expr.cminus > output.easy/expr.cminus
  $ diff output.easy/expr.cminus syntree_easy_std/expr.syntax_tree
  [输出为空，代表正确通过了测试]

```

或者使用脚本进行批量测试

  ```sh
  $ ./test_syntax.sh easy
  [info] Analyzing FAIL_id.cminus
  error at line 1 column 6: syntax error
  ...
  [info] Analyzing id.cminus
  
  $ ./test_syntax.sh easy yes
  ...
  [info] Comparing...
  [info] No difference! Congratulations!
  ```

## PART 2 - IR Gen Warm up

在这一部分中，我们要学习的是 LLVM IR，LightIR，Vistor pattern。这里的 LightIR 是中科大的 TA 提取了 llvm 官网的 [Reference Manual](https://llvm.org/docs/LangRef.html) 中的子集。

### 利用 Clang 生成的 .ll 文件

参考 clang 输出 .ll 文件的内容 `clang -S -emit-llvm <name>.c`，手动将 `tests/2-ir-gen-warmup/c_cases/` 下的 .c 文件翻译成 .ll 文件。

可以通过 `lli <name>.ll; echo $?` 检测结果是否正常。`lli` 会运行 .ll 文件，`echo $?` 会将程序运行的结果输出。

### Light IR 部分

参考 tests/2-ir-gen-warmup/ta_gcd/gcd_array_generator.cpp，编写四个 c 文件对应的 generator。

### Vistor Pattern

阅读理解 `tests/2-ir-gen-warmup/calculator` 下面的相关文件。

### 编译，测试与运行

Light IR 部分在 build 目录下运行

```bash
  cmake ..
  make
  make install
```

visitor pattern 部分通过以下方式验证

``` shell
# 在 build 目录下操作
$ make
$ ./calc
Input an arithmatic expression (press Ctrl+D in a new line after you finish the expression):
4 * (8 + 4 - 1) / 2
result and result.ll have been generated.
$ ./result
22
```

## PART 3 - Cminus

### 编译、运行和调试

构建并运行 Cminusfc

```bash
cmake ..
make clean
make 
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

自动测试脚本和所有测试样例都是公开的，它在 `tests/3-ir-gen` 目录下，使用方法如下：

```sh
# 在 tests/3-ir-gen 目录下运行：
./eval.py
```

测试结果会输出到同文件夹的 `eval_result` 下。
