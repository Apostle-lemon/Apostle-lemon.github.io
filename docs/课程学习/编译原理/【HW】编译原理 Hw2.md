# Chapter 3

## 3.6

![](img/b285d26476aff2c1bfa0a75b16b54042_MD5.png)

## 3.9

![](img/1dd8862e36d099d3abcc1920bdc95292_MD5.png)

![](img/cc600bff11aa3abdafbbba4ac648cab3_MD5.png)

## 3.13

![](img/7a7f094c337cced1b4187c90a64e152f_MD5.png)

FOLLOW(S) = {}  
FOLLOW(X) = {$}  
FOLLOW(M) = {a，c}

我们首先说明岂不是 SLR 的。

![](img/afcdbf447759ab775b90684a297f77d0_MD5.png)

首先绘制出部分的状态图，我们从左到右，从上到下分别编号为 1，2，3，4，5，6。我们观察 5 号状态，其在当前读到的字符为 c 时，既可以进行 shift 操作，又可以进行 reduce 操作（因为 $c \in follow(M)$）。产生了 shift reduce conflict，因此其不是 SLR 的。

接下来我们说明其是 LALR（1）的，首先我们构造 LR（1）的状态转换图。

![](img/962e01ba46bf891a3d0470e6952f720b_MD5.png)

接下来我们给出其对应的表格

|     | M   | X   | a   | b   | c   | d   | $   |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1   | g3  | g2  |     | s4  |     | s5  |     |
| 2   |     |     |     |     |     |     | a   |
| 3   |     |     | s6  |     |     |     |     |
| 4   | g7  |     |     |     |     | s8  |     |
| 5   |     |     | r5  |     | s9  |     |     |
| 6   |     |     |     |     |     |     | r2  |
| 7   |     |     |     |     | s10 |     |     |
| 8   |     |     | s11 |     | r5  |     |     |
| 9   |     |     |     |     |     |     | r3  |
| 10  |     |     |     |     |     |     | r2  |
| 11  |     |     |     |     |     |     | r4  |

可以看到我们并没有产生冲突，因此这个语言是 LALR（1）的

## 3.14

![](img/fd6c9d8217db8fec32e73e0bf0b7207d_MD5.png)

我们首先说明这个文法不是 LALR（1）的，同样的，我们画出了部分的 LR（1）的状态转移图。

![](img/d2b903340b27c55e41879709d41c934d_MD5.png)

我们可以看到这里描红边的两个状态，除了超前查看的符号不一样，其他都一样，因此我们在形成 LALR(1) 的时候，会将其组合成一个状态。

```
E→A. ],)
F→A. ],)
```

因此我们会产生 reduce reduce conflict

接下来我们说明这个文法是 LL(1) 的

|     | nullable | follow | first      |
| --- | -------- | ------ | ---------- |
| S   | no       | $      | (,],)      |
| X   | no       | $      | ),]        |
| E   | yes      | ],)    | $\epsilon$ |
| F   | yes      | ],)    | $\epsilon$ |
| A   | yes      | ],)    | $\epsilon$ |

|     | (     | )             | \[  | \]            |
| --- | ----- | ------------- | --- | ------------- |
| S   | S->(X | S->F)         |     | S->E]         |
| X   |       | X->E)         |     | X->F]         |
| E   |       | E->A          |     | E->A          |
| F   |       | F->A          |     | F->A          |
| A   |       | A->$\epsilon$ |     | A->$\epsilon$ |

这里没有 conflict, 所以他是 LL(1) 的
