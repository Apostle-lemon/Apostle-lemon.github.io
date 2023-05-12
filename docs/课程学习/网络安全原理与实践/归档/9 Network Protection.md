# 9 Network Protection

## 9.1 Firewall / IDS / IPS

监测 / 过滤恶意流量

## 9.2 Load Balancing

将网络流量分配给多个 server，以缓解单个 server 的负载以及故障

![](img/c117345b1e745fb63b5c9dc9daedba7a_MD5.png)

- Least Connection Method  
将流量直接发送到当前活动连接最少的 server

- Least Response Time Method  
将流量直接发送到具有最少活动连接和最低平均响应时间的服务器

- Round Robin Method  
按照顺序将流量分给某个 server（这次分给 1 号，下次就分给 2 号）

- IP Hash  
对 IP 做 hash，将 packet 分给 IP hash 出的 server

## 9.3 Traffic Scrubbing

使用数据清理服务，对流量进行分析，过滤恶意流量  
此类服务提供者应该配备足够的资源，以承受高容量的 traffic flood

一旦攻击被检测到，那就让这个流量进入 scrubbing service

- 分析并过滤恶意流量
- 将其中包含的合法流量发给 user

## 9.4 User Authentication

The basis for most types of access control and for user accountability

识别用户并对用户声称的身份进行验证

**Identification Step**

向安全系统提供一个 ID

**Verification Step**

提供或生成用于验证用户和 ID 之间绑定的身份验证信息

**方式**

- 用户知道的信息  
password，personal identification number(PIN), 提前准备好的问题的答案
- 用户拥有的信息  
电子卡，智能卡，物理密钥
- 用户“是谁”（唯一辨认）
静态生物特征  
指纹，视网膜，脸
- 用户的行为  
动态生物特征  
声音模式、笔迹、打字的节奏

## 9.5 Token

复习 PPT 甚至没有

- 用于用户认证的用户拥有的东西
- e.g. 电子卡，智能卡，生物 ID 卡

## 9.6 Access Control

Authorize a subject with some access right(s) for some object(s)

- Subject 某个用户 / 进程  
Owner：creator of a resource, system administrator, project leader, etc.  
Group：一个用户可能属于多个组  
World：其他
- Object 某种 resource
- Access Right 是否有权限做某种事情

### 9.6.1 DAC

Discretionary Access Control，自由访问控制

- Access Matrix

![](img/17a9282f2d66104f0a5b9b62125741ad_MD5.png)

- ACL - Access Control List

![](img/b0b8f8f47b439fd1c19ed772925c650b_MD5.png)

- Capability List

![](img/08613d727aaae854b645ad95a427e8b2_MD5.png)

  

### 9.6.2 RBAC

Role-Based Access Control，基于权限分类，授予不同的身份

根据 user 的职责，给 user 设置某种 role，赋予 role 对应的权限；检测 role，而不是 ID

![](img/fccc86850050a622aa9188dccb076477_MD5.png)

### 9.6.3 ABAC

Attribute-Based Access Control，基于实时的属性和使用场景划分用户对某资源的访问权限

灵活，前几种都是分配了访问权限之后就固定了。


## 9.7 Incident Response

周期性活动，不断学习和进步，以发现如何最好地保护组织。

四个主要阶段: 准备、检测/分析、控制/根除和恢复

在四个阶段中不断切换反复

![](img/5b30a6955e195be8a6e584471d265268_MD5.png)
