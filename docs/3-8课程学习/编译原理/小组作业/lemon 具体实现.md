编译生成 .ll 文件

```
LOGV=0 ./cminusfc -emit-llvm ../tests/3-ir-gen/testcases/lv
```

编译生成可执行文件

```
LOGV=0 ./cminusfc ../tests/3-ir-gen/testcases/lv
```

测试

```
cd ../tests/3-ir-gen/
./eval.py
```

查看 clang 生成的 .ll 文件是什么样的，注意 clang 用的一定是.c 文件

```
clang -S -emit-llvm ../tests/3-ir-gen/testcases/lv
```

查看具体的语法树

```
./parser ../tests/3-ir-gen/testcases/lv
```

我需要直接测试 globalVar 的创造模式是什么样的。

# Lemon 具体实现

我们首先需要知道我们的语言需要什么样的语法。

我们需要完成的是 判断素数，汉诺塔，矩阵乘法，最⻓公共子序列，整数四则运算。这几个基础的功能就行了。在我们的设计中，我们不支持浮点运算。

## PART 1 Lexer and Parser

我们使用了以下关键字

```c
else if int return void while
```

我们使用了以下保留符号

`+ - * / < <= > >= == != = ; , ( ) [ ] { } /* */`

### 语法

语法来自于《编译原理与实践》第九章（即附表）。这里的第六条语句存在小问题，需要进行修改。

![](img/b510d0dfac0d1e4dbe0355ce4c5e583b_MD5.png)  
![](img/7492023e9c9f5492a51f80ad7b6da452_MD5.png)

### 抽象语法树

```c
struct _syntax_tree_node {
	struct _syntax_tree_node * parent;
	struct _syntax_tree_node * children[SYNTAX_TREE_NODE_CHILDREN_MAX];
	int children_num;

	char name[SYNTAX_TREE_NODE_NAME_MAX];
};
typedef struct _syntax_tree_node syntax_tree_node;
```

我们的 node 只有名字，父字节和子字节。

## PART 2 IR Gen Warm up

要实现一个函数调用，要按照下边的方式

![](img/c6efdf754deb17a29f8808a822e0d1e6_MD5.png)

我们先去处理 statement
