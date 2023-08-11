# 8 Attack Traceback

源 IP 地址不可靠，因为有 IP Spoofing 的可能。
Ingress filtering 可以解决，但是部署上有困难。

## 8.1 IP Traceback

这种方式是改变 router, 使其在 packet 中加入路径信息以溯源。由 start, end, length 三个字段组成要记录的路径信息。

## 8.2 ICMP Traceback

**iTrace**

- 每个路由器对它所转发的包中的一个进行取样（实际上是以一定概率），然后将包的内容和相邻路由器的信息复制到 ICMP Traceback 消息中
- 路由器使用 HMAC 和 X.509 数字证书对回溯消息进行认证
- 路由器向目的地发送 ICMP 回溯消息

一些问题

- 要求所有发送攻击流量的路由器都启用了 iTrace，构建完整的攻击路径
- 然而 ICMP 报文通常被过滤，因为 ICMP Ping Flood 攻击
- 并不是所有数据包都在每一跳上采样

## 8.3 Path Validation

首先需要指明要通过的路径，然后再去验证是否真的走过了那些路径。

OPT 方式设计了 PVF 和 OPV。OPV 则是由 source 进行计算，指定了每个节点应该具有的 OPV，用以防止路径被篡改。如果路径没有被篡改，再用秘钥更新 PVF。

## 8.4 Link Testing

每个包都要进行标记吗？应该总是采样某些包吗？

Only when needed

- 追踪离受害者最近的路由器
- 确定发起攻击流量的上行链路
- 递归地应用前面的技术，直到到达攻击源
- 基于攻击持续进行的假设

具体而言：

### 8.4.1 Input Debugging

- 查找攻击签名，即所有攻击报文所包含的共同特征
- 将攻击签名发送给上游路由器，由上游路由器对攻击包进行过滤，并确定进入端口
- 在上游路由器上递归地应用上述技术，直到到达攻击源

困难：

- 在 ISP 级别上进行通信和协调追溯需要相当大的管理开销

### 8.4.2 Controlled Flooding

- 需要协作的主机
- 强制主机将 link 泛洪到上游路由器
- 由于受害链路上的缓冲区被所有入站链路共享，导致攻击链路泛洪，使得攻击报文被丢弃
- 在上游路由器上递归地应用上述技术，直到到达攻击源

困难：

- 需要一张精确的拓扑图
- 如果有多个攻击源（如 DDoS），会有高开销

## 8.5 Logging-Based Traceback

post-attack traceback

如果在路由器上记录报文，支持查询，就可以在之后进行回溯

- 路由器存储包日志
- 攻击对象会向最近的路由器查询攻击报文的报文外观
- 含有攻击报文的路由器会递归地查询上游路由器，直至到达攻击源

![](img/bb8059ff8265f98d1d143dd85a5a29ee_MD5.png)

记录什么信息呢？

- Raw Packet？路由器上的高存储开销
- Hash of invariant content per packet？在高流量的情况下，存储开销仍然很高

咋整捏？

### 8.5.1 Bloom Filter

每个采样包使用多个哈希值，对采样包中的不变内容进行多次哈希，使用一个 bitmap 保存哈希结果

需要检验时，检查是否采样包的所有哈希值都在 bitmap 里

不会有 false negative，但是会有 false positive

在 m-size bitmap, n members, k hash functions 的情况下，false positive 的概率大约是：

![](img/7b6785a600473640e0b4d63161800720_MD5.png)

  

### 8.5.2 SPIE System

Source Path Isolation Engine
