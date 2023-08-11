# 编译原理 Hw6

![](img/b00a1eed428e461a8a50bbfa47426ca3_MD5.png)

![](img/367ad037fdbe99b4b1bee962f02e2813_MD5.png)


8.2

a.  
MOVE(MEM(ESEQ(s, e1)), e2)=> SEQ (s,  MOVE (MEM(e1), e2)

![](img/63a70a61be566c4a16323d6c9fad589a_MD5.png)

![](img/a1475f67e74942dbb76dc8dbcbe437f3_MD5.png)

b.  
MOVE(MEM(e1), ESEQ(s, e2)) ֜ SEQ (MOVE(t, e1), SEQ(s, MOVE(MEM(t), e2)))

c.  
MOVE(MEM(ESEQ(SEQ(CJUMP(LT, TEMPi, CONST0, Lout, Lok), LABELok) TEMPi)), CONST1)

![](img/fe62555a879305515023b8a4c7dbf3d7_MD5.png)

8.6

1 m ← 0  
2 v ← 0  
————————————————————————————————————————————————————————————  
3 if v ≥ n goto 15  
————————————————————————————————————————————————————————————  
4 r ← v  
5 s ← 0  
————————————————————————————————————————————————————————————  
6 if r < n goto 9  
————————————————————————————————————————————————————————————  
7 v ← v + 1  
8 goto 3  
————————————————————————————————————————————————————————————  
9 x ← M[r ]  
10 s ← s + x  
11 if s ≤ m goto 13  
————————————————————————————————————————————————————————————  
12 m ← s  
————————————————————————————————————————————————————————————  
13 r ← r + 1  
14 goto 6  
————————————————————————————————————————————————————————————  
15 return m

8.7

LABEL(1)  
MOVE(m,CONST(0))  
MOVE(v,CONST(0))  
JUMP(LABEL(3))  
LABEL(3)  
CJUMP(GE,v,n,LABEL(15),LABEL(4))  
LABEL(4)  
MOVE(r,v)  
MOVE(s,CONST(0))  
JUMP(LABEL(6))  
LABEL(6)  
CJUMP(LT,r,n,LABLE(9),LABLE(7))  
LABEL(7)  
MOVE(v,BINOP(PLUS,v,CONST(1)))  
JUMP(LABEL(3))  
LABEL(9)  
MOVE(x,MEM(BINOP(PLUS,MEM(e),BINOP(MUL,i,CONST(w)))))  
MOVE(s,BINOP(PLUS,s,x))  
CJUMP(LE,s,m,LABLE(13),LABLE(12))  
LABEL(12)  
MOVE(m,s)  
JUMP(LABEL(13))  
LABEL(13)  
MOVE(r,BINOP(PLUS,r,CONST(1)))  
JUMP(LABEL(6))  
LABEL(15)  
JUMP(LABEL(done))  
LABEL(done)

轨迹集合为 1>3>4>6>79>12>13,15
