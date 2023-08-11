# Assigenment

## 1 DDOS

a. What is the difference between DoS attacks and DDoS attacks?

Dos attack is denial of service attack, and DDos is Distributed Denial of Service. So the main difference comes from 'Distributed', which means the source of the attack traffic varies. In Dos attack, the attacker uses a single device. But in DDos attack, the attacker uses a lot of devices, which form a "botnet". Due to the larger scale and distributed nature of DDoS attacks, they are often more difficult to defend against than DoS attacks.

b. How does the TCP SYN Flood attack work?

As is known to all, in TCP handshake, it should shake three times in normal case. The first Step is the client sent a SYN packet, which is a connection request. And the Server keeps the sequence number of the client and the server's sequence. So we can see, when we diliver a SYN to the server, it will consume the server's resource. Thus, we can overwhelming a server with a flood of connection requests. As a result, the server becomes overwhelmed and unable to respond to legitimate requests, ultimately leading to denial of service.

c. How does the solution of SYN Cookies against TCP SYN Flood attacks work?

When the server first time receive an SYN packet, it doesn't allocate any space to hold the information, but use TML to generate a random server sequence number. In here, T means timestamp, M means maximum segment size, and L means MACkey(SAddr, SPort, DAddr, DPort, SNC, T). And when the Server receive the ACK packet, it get the SNs in the packet, and the server recompute the SNs, if the two SNs equals, then it means the connection is valid, so the server will allocate resource for it.

But as we can see, it use the MACkey to compute L, so the computation resouce will still be comsumed.

d. How does the DNS Amplification Attack work?How to defend against it?

This is a reflected DDos attack. It exploits DNS query of type ANY that retrieves all the available types for a given name. The acctacker will spoofing the source IP, and send query request to Open DNS resolver. This query always query for ANY, so the DNS resolver will send big data to the victim to overwhelm the victim's network capacity.

In order to defend against it, we may reduce the number of open resolvers or use source IP verification–stop spoofed packets leaving network. The DNS can blocking requests for certain domains. And we may apply IPS or firewall.

## 2 DDos

a. How does Memcached attack work?

The target server must have a memcached server first. The attacker first preload large data to memcached server. And when the preparation has done, the attacker spoof the source IP to the victioms source IP, and request for the preloaded data. Then the memcached server will send the preloaded data to the victim, which is a sufficient number of data.

b. What is the difference between HTTP Flood and Fragmented HTTP Flood?

In HTTP Flood, the attacker either GET or POST large data to consume the victim's limited bandwidth. But in fragmented HTTP Flood, the acctacker sends data as slow as possible before time out. In this case, the server still view the connection is active, so it need to keep the connection's relative information like SN etc. Which consumes the server's resource.

c. Why is Fragmented HTTP Flood relatively more challenging to detect?

First, it delivers data in a slow rate, which won't alarm the speed limitation. And the action is like normal people, it is hard to distinguish the attacker's HTTP connection from the normal connection.

d. How does Ingress Filtering work?

ISP only forwards packets with legitimate source IP. In does so, the attacker can't modify its IP to the victim's IP, except the victim and the attacker are in the same ISP. By dropping packets with spoofed IP addresses, ingress filtering can help reduce the impact of DDoS attacks and improve network security.

e. How does IP Traceback work?

The assumption is that trusted routers, sufficient packets to track, stable route from attacker to victim. We need to change routers. The router will have to add/modify some information the the current packet. We will need three extra space, start, end, and length. Every routers follow the following steps:

![](img/4efc52b20c2c23a241f4a7534ef2f0c9_MD5.png)

So if the packets are sufficient, the receiver can construct a path from the sender to the receiver.

## 3 Secure Routing

a. What are the key features of the five typical delivery schemes?

Unicast involves sending data to a single host  
Broadcast involves sending data to all hosts in the same network or subnet  
Multicast allows sending data to a group of hosts  
Anycast sends data to any one host in a group  
Geocast is a special case of multicast that defines the group based on the hosts' geographical locations.

b. What is the framework of the Dijkstra algorithm?

The dijkstra algoritm is used for search the shortest path from given resouce to any other destination. It keeps two arrays, one records the node that have been visited and thus the shortest path is validated, and the other array keeps the node which has not been visited. Every loop it add a nearest node from unvisted to visted, and update the unvited array's every node's distance.

c. What is the frameworkof the Bellman-Ford algorithm?

The bellman-Ford algorithm is also a big loop, but at every time, it loops all node, update their length to other node, and keep on going until no update occurs or only negative weights edge matters.

d. How does prefix hijacking work?

Prefix take effect when the router is deciding where to forward the packet. First case is that, we know the router will keep the 'longest match first' rule. So we can claim we have a specific IP address, and with more bits. And the other normal router will think that this router is more specific, so they will transmit packet to this accaker router. The second case is that, the accacker claims that it is more close to a specifc IP address. And the other router will always find the shorest path to a specific destination, so they will deliver to the attatck router.

e. How does RPKI work? Why is it insufficient for secure routing?

Resource Public Key Infrastructure. Using RPKI, the router can use the destination Public Key to check if the AS have the given prefix. So if the accacker pretend to have the prefix in its AS, but other router can find out that the AS doesn't have the given ip's prefix, and will not deliver information to this attacker's AS.

Because for case 2, the attacker can still claim that it is very near to the specific IP address, and this can't be verified by the RPKI.

## 4 Anonymous Communication

a. Why is current Internet communication vulnerable to anonymity or privacy leakage?

Iternet communication are use IP to get the receiver's information and record the sender's infomation. And the router need to know the destination IP to know where to forward the packet. In most cases, communication between two parties is facilitated through various intermediaries, such as routers and servers, which can potentially intercept, monitor, or modify the data being transmitted. The attacker can easily get the sender's and receiver's ip address.

b. In which scenariosdo users require the communication anonymity or privacy as concerned in sub-question a?

Unmonitored access to health and medical information. Preservation of democracy: anonymous election/jurl. Censorship circumvention: anonymous access to otherwise restricted information. In this cases, if we know someone's visit frequency of some web etc. We can infer some important information about the sender.

c. How to use proxies to secure communication anonymity? What are the possible limitations?

The sender sends packet to proxy, and the proxy decrept the content and send it to receiver. If the attacker monitoring on the sender to proxy link, the attacker can't know the receiver. If the attacker monitoring on the proxy receiver link, the attacker can't know the sender.

But if the attacker monitoring on both side of the proxy, and analyze the traffic, if may get the packet's sender and receiver. What's more, if the attacker itself is proxy, it will also know the sender and receiver's information.

d. How does Onion Routing provide a better guaranteefor anonymity?

It uses many proxy nodes, and these nodes are randomly selected from the system. The sender use the proxy's key to encry the context and destination layer by layer. Every node receive the packet and decrypt the packet, and then can get where to forward next, but will not know the final destination, for it is encrypted by the next step device key.

e. How to infer anonymity or privacy of Onion Routing traffic?

Path Selection Attack: the attacker have a Onion Routing node under control, and the node report to the symtem it has very large bandwidth to encrease the possibility to be chosen. If the node is the first node in the link, it will knows the sender. If the node is the last node in the link, it knows the receiver.  
Counting Attack: Correlate incoming and outgoing flows by counting the number of packets.  
Low Latency Attack: The attacker periodly send packet to one of the onion node and record the respond time. If the respond time has encrease, then the attcker knows there is a conversation through this node.

## 5 Web Security

a. How does Same Origin Policy work?

Policy 1: Each site in the browser is isolated from all others. Policy 2: Multiple pages from the same site are not isolated. So what is origin? Origin = Protocol + Hostname + Port. So when the protocol and hostname and port are all the same, then the resource can be accessed.

b. How does SQL Injection work?How to defend against it

SQL injection happens when the backend design is bad. The backend doesn't filter the user's input, but simply run the user's input. So the attacker can design malicious input, which can get the database information, or make the database service unavailable to other users.

To defend the SQL injection, there are two ways. One is called input escaping. The user's input should be consindered as string but not special character. The program should insert charater like "\\" before the special character the user put in. The second way is called Prepared Statement. The program send information to database in two channel, one is called code channel, the other is called data channel. The code channel transmit the trusted code to the database first. And the parameter is leaved unbind at first. So the user's input will be treated as string but not code.

c.Please refer to the slides or search online and provide two concrete examples of SQL Injection.

If the web frontend get the user's input【name】, and doesn't fliter the user's input. The backend code is like `select【name】from user`

And the attacker can typein `' ; INSERT INTO TABLE Users (‘attacker’, ‘attacker secret’); --` Here "\`" close the front select, "--" makes the select following sentence as comment. And the malicious insert code will be carried.

Or we can drop the whole table use `' ; DROP TABLE Users -- `

## 6 Web Security

a. How does a DNS hijacking attack affect networksecurity?

If the DNS is hijacted, the result the DNS returns may be maliciously modified. Suppose we want to visit bank.com, and the host machine request DNS for specific IP address. Bug as the DNS has been hijacted, the IP address returned may lead to a fishing website. If the user type some personal information in that website, the information may be leaked.

b. In HTTPS, how does a user verify a certificate for determining the authenticity of the website it connects to?

The user's machine have some trusted CA and its public key. The website certificate will contain the information about which CA publish this certificate. We can decrypt the certificate's signature, compared with the hashed certificate. If the two are the same, means the certificate surely comes from the specific CA. And if we trust the CA, we trust the information CA gives. That is the binding between the publickey and its owner.

c. Please provide a concrete example to showcase CSRF.

CSRF is cross site request forgery. Suppose the <www.attacker.com> have html element like this.

```html
<form action="https://www.bank.com/transfer" method=POST target = invisibleframe>
<input name = recipient value=attacker>
<input name = amount value=$100>
</form>
<script> document.forms[0].submit() </script>
```

And when you visit this site, a POST request will be sent to <www.band.com.> What's more, as this request is made by your browser, it will carry you own cookie, make the bank's server believes that it is exactly you who make the transfer.

d. Please provide two concrete examples to showcase Stored XSS and Reflective XSS.

We image a web page have comment function. And it will show user's comment without filtering. So one attacker may try to comment with `<script>echo "hello"<\sctipt>` . So when other user try to access the message board, the malicious code will be executed.

Reflective XSS is similar to CSRF. Image a web url with parameter `www.somesite.com/?comment=` . Here which follows comment will be treated as html element. So the attacker can modify the url like this `<www.somesite.com/?comment=<script>echo "hello"<\script> ,` when the victim click on this link, the script will be executed.

## 7 Email Security

a. Please describe common threats against Email security.  

Authenticity-related Threats：the access must be authenticated  
Integrity-related Threats：the content must not be modified  
Confidentiality-related Threats：the information must not be leaked  
Availability-related Threats：the email service must be available

b. How should an Email be protected to support both Authentication and Confidentiality?

Authentication: the sender creates a message and then use SHA-256 to generate a 256-bit message digest. The sender encrypt the message digest with RSA using the sender’s private key; append the result as well as the signer’s identity to the message. The receiver uses RSA with the sender’s public key to decrypt, recover, and verify the message digest.

Confidentiality: the sender creates a message and a random 128-bit number as a content-encryption key for this message only, encrypt the message using the content-encryption key and encrypt the content-encryption key with RSA using the receiver’s public key and append it to the message. The receiver uses RSA with its private key to decrypt and recover the content-encryption key, then use the content-encryption key to decrypt the message.

c. Please describe the differences among DANE, SPF, and DKIM.

DANE is used to authenticate digital certificates for secure email communication, SPF is used to verify the sender's IP address and prevent email spoofing, and DKIM is used to verify the authenticity of the sender's domain through a digital signature.

## 8 Traffic Analysis

a. Please describe the properties of the four types of commonly used Firewall.

Packet Filtering Firewall 		Make filtering decisions on an individual packet basis, consider no higher layer context.  
Stateful Insepction Firewall 	Both packets and their context are examined by the firewall.  
Application Proxy Firewall 		Application-Level Gateway  
Act as a relay of application-level traffic.  
Circuit-Level Proxy Firewall 	Circuit-Level Gateway  
Act as a relay of TCP segments without examining the contents

b. What are the differences among Firewall, IDS, and IPS?

Firewall filters traffic based on predefined rules, IDS detects and alerts on suspicious traffic, and IPS not only detects but also takes automated actions to prevent attacks in real-time.

c. Please list commonly used methods for obfuscating traffic to evade detection?

Encrypt traffic to hide payloads  
Use proxy to hide entire packets  
Introduce noise traffic to hide patterns

## 9 Open Question -Authentication Efficiency

	Consider a time-consuming authentication scenario where a database records all secret keys of a large number of users. When the system authenticates a user, it first issues a challenge message to the user. The user then uses his/her key to encrypt the challenge and then returns the encrypted challenge to the system. The system then encrypts the challenge using one key in the database after another and compares the result with the received encrypted message. Once a match is found, the system accepts the user. Otherwise, the user is denied. This authentication protocol surely takes a lot of time and computation.

Design a possible solution to speed up the authentication process.

We can use space to reduce time consumption. We may store the challenge message and its encrypted result in the database. That is, suppose we have n hashtable, the number n is equal to challenge message kind.

The server send challenge message k to user, and use hashtable k to verify user's input. The user give the specific encryption result, we call it R. When the database receives R, it computes the【hash(R) mod size】, and can get a linked list (in case of hash collision) composed with encryed result using the exist key. We compare the R with the item in the linked list (usually not longer than two item), if some item is the same, we accept the user.

## 10 SHINE YOUR WAY

a. Which topic among the lectures you would like to consider?  
Traffic

b. Describe a (sufficiently complex) question;  
please clarify the the meanings of true positive, true negtive, false positive, false negtive

c. Provide also a correct sample solution, thanks.

True positive: When a system correctly identifies a positive result (e.g., correctly identifying a malicious file as malware).  
True negative: When a system correctly identifies a negative result (e.g., correctly identifying a harmless file as not malware).  
False positive: When a system incorrectly identifies a positive result (e.g., falsely identifying a harmless file as malware).  
False negative: When a system incorrectly identifies a negative result (e.g., falsely identifying a malicious file as not malware).
