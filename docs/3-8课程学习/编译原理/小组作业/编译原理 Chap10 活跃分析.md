# 编译原理 Chap10 活跃分析

## 怎么计算 Live-in

如果我 use 了，那么肯定是 live-in 的 （初步）

如果我 live-out 了，并且不是我 def 的，那么肯定是 live-in 的。（检查的时候，live_out - def 是 live_in 的子集）

## 怎么计算 Live-out

live-in 的前继节点都需要添加进 live-out
