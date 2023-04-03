# 6 Email Security

## 6.1 Email Architecture

![](img/7872d9b2b6b6218e316f328008229814_MD5.png)

## 6.2 Email Security Threats

- **Authentication-related Threats**
- 未认证的访问 unauthorised access to email systems
- **Integrity-related Threats**
- 非法修改 unauthorized modification of email contents
- **Confidential-related Threats**
- 信息泄露 unauthorized disclosure of sensitive information
- **Availability-related Threats**
- 无法正常使用 block users from sending and receiving emails

## 6.3 S/MIME

Secure / Multipurpose Internet Mail Extension

- Authentication | 认证
- Confidentiality | 保密
- Compression | 压缩
- Email compatibility | 兼容

### 6.3.1 Authentication

1. 发送方创建消息
2. 使用 SHA-256 生成 256 位的消息摘要
3. 使用发送方的私钥用 RSA 加密消息摘要，将结果和签名者的身份追加到消息中
4. 接收方使用 RSA 和发送方的公钥对消息摘要进行解密、恢复和验证

### 6.3.2 Confidentiality

1. 发送方创建一条消息和一个 128 位的随机数字，作为此消息的内容加密密钥（Content-Encryption Key）
2. 使用内容加密密钥加密消息
3. 使用接收方的公钥对内容加密密钥进行 RSA 加密，并将其附加到消息中
4. 接收方使用 RSA 及其私钥对内容加密密钥进行解密和恢复
5. 使用内容加密密钥解密消息

### 6.3.3 Content Type

Data - 内部 MIME 编码的消息内容，可以封装在以下类型：

- SignedData - 信息的数字签名
- EnvelopedData - 任何类型的加密数据，以及一个或多个收件人的加密内容加密密钥
- CompressedData - 信息的压缩

  

## 6.4 PGP

**Pretty Good Privacy** - 和 S/MIME 一样的功能，对个人使用免费且流行

**与 S/MIME 的区别：**

1 Key Certification

- S/MIME 使用由 CA 或授权机构颁发的 X.509 证书
- OpenPGP 允许用户生成他们自己的 OpenPGP 公钥和私钥，然后从已知的个人或组织征求对他们的公钥的签名

2 Key Distribution

- OpenPGP 不在每条消息中包含发送者的公钥
- 接收方需要从受 TLS 保护的网站或 OpenPGP 公钥服务器来获取
- OpenPGP 密钥没有审查，用户自己决定是否信任

NIST 800-177 建议使用 S/MIME 而不是 PGP，因为在验证公钥的 CA 系统中更有信心。

## 6.5 DANE

CA 也很危险诶，万一 CA 被破坏了就寄了

DANE 的目的是用 DNSSEC 提供的安全性取代对 CA 系统安全性的依赖。

鉴于域名的 DNS 管理员有权提供有关该区域的身份信息，所以也可以让管理员在 域名 和 该域名上的主机可能使用的证书 之间进行认证和绑定。

即，DANE 是 DNS-based Authentication of Named Entities，基于 DNS 的对有域名实体的认证。使用 DNSSEC 将 X.509 证书绑定到 DNS 域名。

### 6.5.1 TLSA Record

TLS Authentication Record

- 一个由 DANE 定义的新的 DNS 记录类型，用于 SSL/TLS 证书的安全认证方式
- 指定 CA 可以为证书提供担保的约束条件，或指定特定的 PKIX [Public Key Infrastructure (X.509)] end-entity 证书有效的约束条件。
- 指定可以直接在 DNS 中认证的 service certificate 或者 CA。


### 6.5.2 DANE for SMTP

### 6.5.3 DANE for S/MIME

## **6.6 Spoofing**

### 6.6.1 SPF

隔壁班没讲

ADMDs (Administrative Management Domains) publish SPF records in DNS specifying which hosts/IP-addresses are permitted to use their names

receivers use the published SPF records to test the authorization of sending Mail Transfer Agents (MTAs) using a given "HELO" or "MAIL FROM" identity during a mail transaction;

### 6.6.2 DKIM

DomainKeys Identified Mail

通过私钥对邮件进行签名：邮件的发送方使用私钥对邮件消息进行签名。该私钥属于邮件来源的管理域，可以保证邮件的真实性和完整性。

通过公钥进行验证：在邮件接收端，MDA 可以通过 DNS 获取相应的公钥，并使用公钥验证邮件签名的真实性。如果邮件的签名可以成功验证，就可以认为该邮件来自声称的管理域，并且没有被篡改或损坏。

## **6.7 What if Email is exploited?**

### Spam

### Phishing

### Malware
