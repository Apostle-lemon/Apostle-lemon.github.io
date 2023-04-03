# 7 Traffic Analysis

filter malicious traffic

## 7.1 Firewall

一个 barrier，双向流量都需要通过，分别用 firewall security policy 指定两方向有什么流量可以通过。

**目标**：

- 所有从内部到外部的流量都必须通过防火墙，反之亦然。
- 只有 local security policy 定义的授权流量才被允许通过。
- 防火墙本身是不受渗透的。

### 7.1.1 Design Techniques

Service Control - 确定可访问的服务类型（入站或出站）

- 根据 IP 地址、协议或端口号对流量进行过滤
- 提供代理软件，在传递服务请求之前接收并解释每个服务请求
- 托管服务器软件本身，例如 Web 或电子邮件服务  

Direction Control - 确定特定服务请求被允许发起和通过防火墙的方向

User Control - 根据试图访问服务的用户来控制对服务的访问

- 一般适用于本地用户
- 也适用于外部用户通过安全认证技术（如 IPsec 认证头）

Behavior Control - 控制特定服务的使用方式

- 例如，过滤电子邮件以消除垃圾邮件，或允许外部访问本地 Web 服务器上的部分信息

### 7.1.2 Types of Firewalls

#### 7.1.2.1 Packet Filtering Firewall

对每个传入和传出的 IP 数据包应用一组规则，转发或丢弃报文

- 在单个数据包的基础上做出过滤决策
- 不考虑更高层次的上下文
- 如果没有匹配，则默认丢弃，或者默认转发

（实际上按照图片，应该是对传输层 segment 进行过滤；会考虑双方的 IP, port 以及包中的 Flags，如 ACK）

#### 7.1.2.2 Stateful Inspection Firewall

数据包和它们的上下文都由防火墙检查，也是传输层的

#### 7.1.2.3 Application Proxy Firewall

作为一个应用层的 relay，使得客户端和服务端从不直接交互，而是以防火墙作为代理，同时可以检查数据包的全部内容

#### 7.1.2.4 Circuit-Level Proxy Firewall

作为一个 transport layer 的 relay，代理主机和对方完成 TCP 连接建立；一旦建立连接后就正常转发，不检查内部内容。

### 7.1.3 Where Firewall Stand

#### 7.1.3.1 DMZ Networks

DMZ - DeMilitarized Zone 停火区

**External Firewall**

- 为 DMZ 系统提供与外部连接需求一致的访问控制和保护

**Internal Firewall**

- 增加更严格的过滤能力，保护内部网络免受来自 DMZ 的攻击，反之亦然；保护内部网络之间的安全。

![](img/028ad1f0e09112e0d9af56efe1243308_MD5.png)

  

#### 7.1.3.2 Virtual Private Networks

在较低的协议层使用加密和身份验证，通过不安全的 Internet 提供安全连接

- 比使用专用线路的专用网络便宜
- 常用协议：IPsec

![](img/5b0653dc2fa2fa12558d253bd770a20d_MD5.png)

  

#### 7.1.3.3 Distributed Firewalls

独立防火墙设备和基于主机的防火墙在中央管理控制下协同工作

![](img/e0242cb18ce3b9ba0bba1886ad2e79b9_MD5.png)

  

## 7.2 IDS | Intrusion Detection System

individually secure packets yet collaboratively malicious (e.g. TCP SYN Flood)

检测异常的活动模式或与已知入侵相关的活动模式，提供入侵的早期预警，以便采取防御行动。（只报告不过滤）

### 7.2.1 Intrusion Behavior Pattern

入侵者的行为与合法用户的不同之处是可以量化的：

![](img/fb207a8a809d3804f38dc8a1ed49b73c_MD5.png)

  

### 7.2.2 How to Detect Intrusion

#### 7.2.2.1 Audit Record

审计记录

- 记录用户正在进行的活动
- 向 IDS 输入记录
- Native Audit Record  
使用操作系统内可用的审计软件收集用户活动信息  
不需要额外的收集软件  
可能不包含所需的信息或可能不以方便的形式包含信息

- Detection-Specific Audit Record  
使用专用工具生成只包含 IDS 所需信息的审计记录  
独立、便携  
额外的开销  
Example fields - Subject, Action, Object, Exception Condition, Resource-Usage, Time-Stamp

#### 7.2.2.2 **Statistical Anomaly Detection**

- Threshold Detection - 在一段时间内，统计特定事件类型的发生次数，如果超过合理数量，则报告入侵
- Profile-Based Detection - 描述一些用户的过去行为，如果发生重大偏差，报告入侵

#### 7.2.2.3 **Rule-Based Detection**

- 通过观察系统中的事件并应用一组规则来检测入侵，这些规则可以决定给定的活动模式是否可疑
- 分析历史审计记录，以识别使用模式并生成描述这些模式的规则

### 7.2.3 Distributed IDS

- 在需要监控的系统上作为后台进程运行；这些系统分别收集安全相关事件的数据，并传输给中央管理员
- 有一个叫 LAN monitor 的东西，LAN monitor 与主机代理模块类似，但是不同的是它能够分析局域网流量，并将检测结果报告给中央管理器。
- 中央管理员处理来自 LAN monitor 和 host agents 的报告，处理并关联它们从而报告入侵

![](img/a7df930b40ac6ff23c6781b6cfec52ee_MD5.png)

  

### 7.2.4 Honeypot

- 诱饵系统，旨在引诱潜在的攻击者远离关键系统
- 收集关于攻击者活动的信息
- 鼓励攻击者在系统上停留足够长的时间，以便管理员作出响应

![](img/43fd718c5704929eefe8a9b5e81e9f12_MD5.png)

  

### 7.2.5 Honeywords

- 将假密码（Honeywords）与每个用户的帐户关联
- 窃取（哈希）密码文件的攻击者无法区分密码和 Honeywords
- 尝试使用 Honeywords 登录会引发警报

![](img/560a45d5e0f4e65f3a623873a67ebc8f_MD5.png)

**密码**

- 注册一个新密码：Salt + password -> Hash
- Salt 由服务器随机生成，和用户 ID 一起记录在数据库中
- 验证密码 - 通过用户 ID 获取 Salt 然后 hash

**Salt 用途**

- 防止重复密码在密码文件中可见
- 大大增加了离线字典攻击的难度
- 这大大增加了查明一个人是否在两个或多个系统上使用了相同密码的难度。

### 7.2.6 IDS Detection Accuracy

**Detection Rate / True Positive Rate** `**TP**`

- 假设存在入侵，IDS 正确输出警报的可能性有多大
- False Negative Rate `FN = 1 - TP`

**False Alarm / False Positive Rate** `**FP**`

- 假设没有入侵，IDS 错误输出警报的可能性有多大
- True Negative Rate `TN = 1 - FP`

## 7.3 IPS | Intrusion Prevention System

- **Anomaly Detection** | 异常检测 - 识别不同于合法用户的行为
- **Signature/Heuristic Detection** | 特征/启发式检测 - 识别恶意行为

## 7.4 Advanced Traffic Analysis

- 模式识别（时间分布，或者流量分布 | event-based / shape-based），甚至机器学习

但是，恶意用户可能会使用手段隐藏流量模式：

- Traffic Obfuscation | 混淆  
加密流量以隐藏有效负载  
使用代理以隐藏整个数据包  
引入噪声流量以隐藏模式

例如，ditto 通过 padding 来混淆数据包大小，通过冗余数据包混淆传输间隔

![](img/7f75dcb1ff0340092ea3d250b3e5a41a_MD5.png)

咋整捏？

- Active Probing，大意就是主动发一个探测器过去，看看对面反应正不正常
