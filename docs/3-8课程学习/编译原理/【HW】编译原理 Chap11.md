# 【HW】编译原理 Chap11

## 11.1

![](img/c98f435b20ef4ef68b80e00818091c4b_MD5.png)

对于这里，我们不能确定是 L 还是 1，下面是根据 l 来处理的。

![](img/3732c169a5afa24b6776ced11165a2cf_MD5.png)

我们首先进行活跃分析

| statement        | pred  | use   | def   | live-in | live-out |
| ---------------- | ----- | ----- | ----- | ------- | -------- |
| 1 c<-r3          |       | r3    | c     | r3,r1,l | r1,l,c   |
| 2 p<-r1          | 1     | r1    | p     | r1,l,c  | p,l,c    |
| 3 if p=0 goto L1 | 2     | p     |       | p,l,c   | p,l,c    |
| 4 r1<-M_p        | 3     | p     | r1    | p,c     | r1,p,c   |
| 5 call f         | 4     | r1    | r1,r2 | r1,p,c  | r1,p,c   |
| 6 s<-r1          | 5     | r1    | s     | r1,p,c  | p,s,c    |
| 7 r1<-M_p+4      | 6     | p     | r1    | p,s,c   | r1,s,c   |
| 8 call f         | 7     | r1    | r1,r2 | r1,s,c  | r1,s,c   |
| 9 t<-r1          | 8     | r1    | t     | r1,s,c  | s,t,c    |
| 10 u<-s+t        | 9     | s,t   | u     | s,t,l,c | u,l,c    |
| 11 goto L2       | 10    |       |       | u,l,c   | u,l,c    |
| 12 L1 u<-l       | 3,11  | l     | u     | l,c     | u,c      |
| 13 L2 r1<-u      | 11,12 | u     | r1    | u,c     | c,r1     |
| 14 r3<-c         | 13    | c     | r3    | c,r1    | r1,r3    |
| 15 return        | 14    | r1,r3 |       | r1,r3   |          |

然后我们画出冲突图

![](img/cfe12e7da9ca978c23d6e99b0e4640ef_MD5.png)

然后我们执行合并操作。  
我们看到 r3 和 c 是可以进行合并的，判断标准是 george。  
我们看到 t 和 r1 是可以进行合并的，判断标准时 george。

我们进行简化后可以发现, U 是可以进行简化的。

![](img/63636c8bf9f17062f18798f6663865c7_MD5.png)

之后我们可以开始着色，我们看到 l 与 r1, r3 两种颜色相连，因此只能选择 r2 这一种颜色。

对于 P 和 S 而言，发生了实际溢出，因此我们需要重写这个函数，使得刚开始将 P 和 S 分别存入到内存中。每次需要使用 P 与 S 时，将其从内存中取出，并赋予一个新的临时变量。

对于 U 而言，将其赋予 r1 颜色。

我严重怀疑这里不应该是 l，而应该是 1，因为如果是 L 之后的工作量太大了。因为不想重新开始做，所以只讲了思路。

## 11.3

![](img/66b0f64fef21c345e1fd691ff17bd7c7_MD5.png)

a 用四种颜色进行填充，如果不进行合并，选择栈的内容

| stack | potensial conflict | actual conflict | give color |
| ----- | ------------------ | --------------- | ---------- |
| a     | yes                | no              | r3         |
| b     | no                 | no              | r4         |
| c     | no                 | no              | r3         |
| d     | no                 | no              | r2         |
| e     | no                 | no              | r3         |
| f     | no                 | no              | r2         |
| g     | no                 | no              | r1         |

注意我们这里上方是栈底，下方是栈顶

b 进行合并

采用的是 briggs，我们可以看到合并后的 abcde，e,b,c 的度都变成了3，因此 >= 4 的度的邻居只有两个。

![](img/fb4e6fc2019771253704aaf8cae0dab4_MD5.png)

| stack | potensial conflict | actual conflict | give color |
| ----- | ------------------ | --------------- | ---------- |
| b     | no                 | no              | r4         |
| c     | no                 | no              | r2         |
| e     | no                 | no              | r4         |
| d     | no                 | no              | r3         |
| a     | no                 | no              | r2         |
| fg    | no                 | no              | r1         |
