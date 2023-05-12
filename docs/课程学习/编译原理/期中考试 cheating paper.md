# 期中考试 Cheating Paper

## 正则表达式

![](img/059313fab854e8ef370fffcc4109fa8f_MD5.png)  

注意一下 kleen star，kleen 代表可以有 0 次，也就是转圈圈的那个是 kleen star，但是普通的转移不是 kleen star。

## Conver NFA to DFA

1 计算 start symbol 的 closure  
2 对每个 input symbol，得到一个转换后的状态  
3 计算这个转换后状态的 closure  
4 重复，直到没有新的状态产生

## Minimize DFA

算法是这样的：首先要找出的 是所有不等价的状态偶对。若 x 是终结符而 Y 不是，或者（通过迭代）x->( input a ) x'，且 y->( input a ) y', 但 x‘和 y' 不等价，则状态 x 和 y 不等价。用这种迭代方式寻找新的不等价状态偶对。如果没有更多的不等价状态，则停止。停止后，如果 XY 仍不是不等价偶对，则它们就是等价状态。

## What's the Language Described

注意不要忘了 empty string 的情况。

## Calculate the Nullable, FIRST, FOLLOW Set

1 首先计算 nullable，这个非常好计算  
2 计算 FIRST  
3 如果他是 nullable 的，那么先将 epsilon 加上。然后看每一条 rule，看开头的那个。
4 如果开头的那个是 terminal，自信写上。
5 如果开头的是 nonterminal，那么就是 a->bc，FIRST(b) 属于 FIRST(a)。这时候我们还需要接着检查 b，如果 b 是 nullable 的，那么 FIRST(c) 也属于 FIRST(a)。以此类推。
6 计算 FOLLOW 的时候，主要是通过产生式的右边判断出 follow 的关系。
7 如果右边那个后面跟了个 terminal，自信写上  
8 如果后边跟了个 nonterminal，则后面的 FIRST 属于当前的 FOLLOW。同时要判断这个 nonterminal 是不是 nullable 的。
9 如果这个在最后边，那么就是左侧的 FOLLOW 是右侧的 FOLLOW 的子集。

## Construct the LL(1) Parsing Table

1 首先需要有 nullable, FIRST, FOLLOW 这三个 set  
2 行是 nonterminal，列是 terminal。
3 对于每个 terminal，如果在当前 nonterminal 的 FIRST 集合内，则可以导出相应的 terminal 的规则需要被填入。如果当前的 nonterminal 是 nullable 的，并且这个 terminal 在 nonterminal 的 FOLLOW 集合内，那么可以导出为空的规则也需要被填入。

给个例子

![](img/dd67e757c23cd842a9bf7ed5db60d3c0_MD5.png)  
![](img/2a81e78361bd7deba4d1b4b7bcdf1aaf_MD5.png)  
![](img/15719fe4b3c31c6e986867132a543fd7_MD5.png)

## Remove Left Recursive

消除左递归，只需要将 S->SB, S->A 转换成 S->AT, T->BT, T->epsilon 就好。
LL(1) grammar 不能是 left recursive 的

## Left Factoring

提取左因子，只需要将 A → aBc，A → aBd 变化为 A → aB A'，A' → c | d 即可。

## SLR

SLR 就是在 LR 的基础上，采取 reduce 的条件有所增加。也即，只有当 symbol 属于当前产生式左侧的 FOLLOW 时，才会使用 reduce 进行规约。

## LR（1）

如果要说明他是 LR（1）的话，给出对应的 table 肯定没有问题。凭直觉就是看看有没有 shift-reduce conflict 和 reduce reduce conflict。查看 shift-reduce conflict 就是看当前可以 reduce 的情况和可以 shift 的情况的 symbol 是不是同一个 symbol。

## LALR（1）

LALR（1）就是将 LR(1) 中，产生式全相同，只有 lookahead symbol 不同的项进行了合并。the parsing method of YACC is LALR(1)。
